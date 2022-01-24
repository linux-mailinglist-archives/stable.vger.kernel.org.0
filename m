Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA648498E75
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244526AbiAXTlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:41:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37238 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354924AbiAXTjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:39:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34A256131E;
        Mon, 24 Jan 2022 19:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077B9C340E5;
        Mon, 24 Jan 2022 19:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053177;
        bh=NYJ7RpJ3Zpj/TBTgN+RPZymLDIAJnEHe1ThwT5uOekQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsCzJjof/heIHnsjTnx/QvxYNglJY2KmXefmizHAcdqf5c+ehwayZjQrLAvZJzCFn
         xJHO16eWsUe0AH/Z2G/PiM/K4K/yH/HSiJ/+qqSJrIk1saw6AiIwVaHrSqGZwM/Alp
         X7QZrnWetwyWM8RCbfDIMCnTvpZn24YH4qLA+CUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 301/320] xfrm: Dont accidentally set RTO_ONLINK in decode_session4()
Date:   Mon, 24 Jan 2022 19:44:45 +0100
Message-Id: <20220124184004.188391880@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_policy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -31,6 +31,7 @@
 #include <linux/if_tunnel.h>
 #include <net/dst.h>
 #include <net/flow.h>
+#include <net/inet_ecn.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
 #include <net/gre.h>
@@ -3282,7 +3283,7 @@ decode_session4(struct sk_buff *skb, str
 	fl4->flowi4_proto = iph->protocol;
 	fl4->daddr = reverse ? iph->saddr : iph->daddr;
 	fl4->saddr = reverse ? iph->daddr : iph->saddr;
-	fl4->flowi4_tos = iph->tos;
+	fl4->flowi4_tos = iph->tos & ~INET_ECN_MASK;
 
 	if (!ip_is_fragment(iph)) {
 		switch (iph->protocol) {


