Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7882A4C75B5
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235756AbiB1R4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240792AbiB1Ryp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18280532F3;
        Mon, 28 Feb 2022 09:43:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8F34608D5;
        Mon, 28 Feb 2022 17:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7791C340F4;
        Mon, 28 Feb 2022 17:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070221;
        bh=bYmxFUxu5FgBnwgvdPY3DcQ50JmfRGtEJ/k/w9849Q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfPOLW2G5YCIcgX/DGayOJjLfHtQhc63zcU7lb54KAkcrhum5s9rADe6NNYzM5yl/
         5vWObCM3A0P30QflkwJqN4llDXGTrFiLqILJyHZWbcqSY9gB8gaQzLN2Y1U8FfguY4
         7H6oBmwQPOqNn6pu1BLqXfp5nSMggOUUfO15Wkec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.16 030/164] netfilter: xt_socket: fix a typo in socket_mt_destroy()
Date:   Mon, 28 Feb 2022 18:23:12 +0100
Message-Id: <20220228172402.935684937@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


