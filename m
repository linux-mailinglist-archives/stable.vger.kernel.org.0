Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAF54BDC73
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351367AbiBUJuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:50:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352885AbiBUJsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986DB192AA;
        Mon, 21 Feb 2022 01:20:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0E224CE0E88;
        Mon, 21 Feb 2022 09:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAE7C340EB;
        Mon, 21 Feb 2022 09:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435255;
        bh=uCDU3Iu8HRlLzNeHWBl0YvfMWpvWbc7yd8s/av4iXHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CwdNvDJ3rRus+Yiw+2jp4xQBaweqCK3EiEQBnyXpeIaksP1JNPCBbRzI7IG3C70Kc
         GmcbcF1o/quBDe5JAnXpo9HKIoYMEvDyn3/CVgdaCCIuB19WSsCDOG49ZD7tmiJDTU
         v8JwuVx3eK5bjoAew2bKNFR6zpMRuODtvYInUznk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.16 099/227] netfilter: nft_synproxy: unregister hooks on init error path
Date:   Mon, 21 Feb 2022 09:48:38 +0100
Message-Id: <20220221084938.170112613@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 2b4e5fb4d3776c391e40fb33673ba946dd96012d upstream.

Disable the IPv4 hooks if the IPv6 hooks fail to be registered.

Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_synproxy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -191,8 +191,10 @@ static int nft_synproxy_do_init(const st
 		if (err)
 			goto nf_ct_failure;
 		err = nf_synproxy_ipv6_init(snet, ctx->net);
-		if (err)
+		if (err) {
+			nf_synproxy_ipv4_fini(snet, ctx->net);
 			goto nf_ct_failure;
+		}
 		break;
 	}
 


