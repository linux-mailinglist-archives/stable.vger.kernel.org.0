Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE7E4BE84E
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbiBUJ1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:27:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349607AbiBUJ0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:26:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEB41DA6C;
        Mon, 21 Feb 2022 01:10:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC53460DDF;
        Mon, 21 Feb 2022 09:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C04C340E9;
        Mon, 21 Feb 2022 09:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434640;
        bh=bYmxFUxu5FgBnwgvdPY3DcQ50JmfRGtEJ/k/w9849Q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RT1EvrFrmFwUJ9kz2RMmn0eFbIO8an5nrTEHO7Fp+qMUafzod3tU+izegCvbuMzif
         Dp6KqsYNvLziBwMTa9c8yd/V4kxYn4MRMt1OnJnAEZZNYWFOYGvf9605a5QvEE8Ve8
         lpK4/O9cHij2Fo3LmkIqV49L7HjTh3t4WOTO0fbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 077/196] netfilter: xt_socket: fix a typo in socket_mt_destroy()
Date:   Mon, 21 Feb 2022 09:48:29 +0100
Message-Id: <20220221084933.509894998@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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


