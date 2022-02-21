Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6109B4BDDB3
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347395AbiBUJGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:06:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347446AbiBUJFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:05:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B23024095;
        Mon, 21 Feb 2022 00:59:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2174B80EA1;
        Mon, 21 Feb 2022 08:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC06C340EB;
        Mon, 21 Feb 2022 08:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433944;
        bh=uCDU3Iu8HRlLzNeHWBl0YvfMWpvWbc7yd8s/av4iXHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2n60tDoDWXEE+L8ufpkYZ9NqzM0nsUP61Qux2EELqPKXfSp7VnL+0g/O/MkOvjjK
         xBabQyw5UnpMoh8AczP+atUjr8kGRMzTNZfJYX79wMg/n/4y0G6rS3cupZw91Jppl/
         dvGJ2bgRRLvHlVICCgcBmJp/9RGZcO4i1APTYIqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 38/80] netfilter: nft_synproxy: unregister hooks on init error path
Date:   Mon, 21 Feb 2022 09:49:18 +0100
Message-Id: <20220221084916.817774605@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
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
 


