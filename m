Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA394BE1C2
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351454AbiBUJtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:49:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352884AbiBUJsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A34192B7;
        Mon, 21 Feb 2022 01:20:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C747CE0E7A;
        Mon, 21 Feb 2022 09:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F84C340E9;
        Mon, 21 Feb 2022 09:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435249;
        bh=bYmxFUxu5FgBnwgvdPY3DcQ50JmfRGtEJ/k/w9849Q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/9qnWVRnyPdyO1f+4r2brJ+qvbuRMpAI0+cX3xOBIB1V8TKL+QOatWp4N0nnsno4
         OHdTCSdqe8Zr24dPIxkePAEUBLK+WBfBdKbS0+KFmcnGj5UMNm3L6/dvXB7BonjVKO
         deClWiHyNT8A8F/wZgEzATHLst2QaCNF+0fzbshY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.16 097/227] netfilter: xt_socket: fix a typo in socket_mt_destroy()
Date:   Mon, 21 Feb 2022 09:48:36 +0100
Message-Id: <20220221084938.106083394@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 75063c9294fb239bbe64eb72141b6871fe526d29 upstream.

Calling nf_defrag_ipv4_disable() instead of nf_defrag_ipv6_disable()
was probably not the intent.

I found this by code inspection, while chasing a possible issue in TPROXY.

Fixes: de8c12110a13 ("netfilter: disable defrag once its no longer needed")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/xt_socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -221,7 +221,7 @@ static void socket_mt_destroy(const stru
 	if (par->family == NFPROTO_IPV4)
 		nf_defrag_ipv4_disable(par->net);
 	else if (par->family == NFPROTO_IPV6)
-		nf_defrag_ipv4_disable(par->net);
+		nf_defrag_ipv6_disable(par->net);
 }
 
 static struct xt_match socket_mt_reg[] __read_mostly = {


