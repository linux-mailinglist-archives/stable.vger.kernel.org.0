Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342C24980BB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbiAXNO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:14:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45052 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiAXNO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:14:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A761B61033
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AB4C340E1;
        Mon, 24 Jan 2022 13:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643030095;
        bh=wu9EvMowYmzhYqIEyEoUGZxzd2RRh7vdA57AxFrznJI=;
        h=Subject:To:Cc:From:Date:From;
        b=JI9Cz2F9kePHSKVgxbMleGCX1lPKcluTLH8aFLVOer5D7iSO+uP+YWT7rxcuLu1w4
         39Ig03K2bPJWtD1nRtv4AI+edTFrOdFdwNAMWw/k1RH32pBRGOi8RecJKbXsClvd76
         bTbtFVGioesDgywOjC55piTGkQtESErD3c+zIAWE=
Subject: FAILED: patch "[PATCH] xfrm: Don't accidentally set RTO_ONLINK in decode_session4()" failed to apply to 4.19-stable tree
To:     gnault@redhat.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:14:39 +0100
Message-ID: <16430300795760@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 23e7b1bfed61e301853b5e35472820d919498278 Mon Sep 17 00:00:00 2001
From: Guillaume Nault <gnault@redhat.com>
Date: Mon, 10 Jan 2022 14:43:06 +0100
Subject: [PATCH] xfrm: Don't accidentally set RTO_ONLINK in decode_session4()

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

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index dccb8f3318ef..04d1ce9b510f 100644
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
@@ -3295,7 +3296,7 @@ decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
 	fl4->flowi4_proto = iph->protocol;
 	fl4->daddr = reverse ? iph->saddr : iph->daddr;
 	fl4->saddr = reverse ? iph->daddr : iph->saddr;
-	fl4->flowi4_tos = iph->tos;
+	fl4->flowi4_tos = iph->tos & ~INET_ECN_MASK;
 
 	if (!ip_is_fragment(iph)) {
 		switch (iph->protocol) {

