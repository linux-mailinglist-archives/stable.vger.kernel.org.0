Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D724BDC63
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345025AbiBUIvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 03:51:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345012AbiBUIvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 03:51:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824C65F64;
        Mon, 21 Feb 2022 00:51:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EE216114A;
        Mon, 21 Feb 2022 08:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0330C340EB;
        Mon, 21 Feb 2022 08:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433482;
        bh=kGaxBwPREl1YNNSsVl3yhY4N9ZSYBCM7azMKuUbnDI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQErazDxYmCY6ZaMTIfE/HU749WJU3fKxpIicwtwtQkGwH2oqB4O/hEPAE/H0cQij
         P4V/JRlc+HucEVS4TiWkPdvKZTMC7DNXTriPFChH6cBZnIa7tH6xGCoLzy2o86DAgL
         xfpwCYJ9DSliUdZyvH65xhxnfsj9XXkTDlCqGIOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 15/33] xfrm: Dont accidentally set RTO_ONLINK in decode_session4()
Date:   Mon, 21 Feb 2022 09:49:08 +0100
Message-Id: <20220221084909.273177621@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084908.568970525@linuxfoundation.org>
References: <20220221084908.568970525@linuxfoundation.org>
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

From: Guillaume Nault <gnault@redhat.com>

commit 23e7b1bfed61e301853b5e35472820d919498278 upstream.

Similar to commit 94e2238969e8 ("xfrm4: strip ECN bits from tos field"),
clear the ECN bits from iph->tos when setting ->flowi4_tos.
This ensures that the last bit of ->flowi4_tos is cleared, so
ip_route_output_key_hash() isn't going to restrict the scope of the
route lookup.

Use ~INET_ECN_MASK instead of IPTOS_RT_MASK, because we have no reason
to clear the high order bits.

Found by code inspection, compile tested only.

Fixes: 4da3089f2b58 ("[IPSEC]: Use TOS when doing tunnel lookups")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[sudip: manually backport to previous location]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/xfrm4_policy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -16,6 +16,7 @@
 #include <net/xfrm.h>
 #include <net/ip.h>
 #include <net/l3mdev.h>
+#include <net/inet_ecn.h>
 
 static struct xfrm_policy_afinfo xfrm4_policy_afinfo;
 
@@ -123,7 +124,7 @@ _decode_session4(struct sk_buff *skb, st
 	fl4->flowi4_proto = iph->protocol;
 	fl4->daddr = reverse ? iph->saddr : iph->daddr;
 	fl4->saddr = reverse ? iph->daddr : iph->saddr;
-	fl4->flowi4_tos = iph->tos;
+	fl4->flowi4_tos = iph->tos & ~INET_ECN_MASK;
 
 	if (!ip_is_fragment(iph)) {
 		switch (iph->protocol) {


