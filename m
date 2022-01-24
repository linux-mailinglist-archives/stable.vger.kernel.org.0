Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C07499DAE
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586056AbiAXWZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584555AbiAXWVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC54C0424D5;
        Mon, 24 Jan 2022 12:50:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD2D9B80FA1;
        Mon, 24 Jan 2022 20:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04891C340E5;
        Mon, 24 Jan 2022 20:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057431;
        bh=S6hpoQrFRb7CVdHf4+uQee5G+SjwJeDuyUv4UHKTi+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/zsgJ/E95o5Qns17fCDiJ/9O/VU6/+tttVbYLw9vowEsR9W3NfwPyQZPmk0HNfo6
         TOWZrExAVHsT6DofnFg6JUhOUYeTK8CJZup3Y53me1m7vYhZv88CYFN7kd/rpEthwi
         q2RqVYDP7ivy9R2t+2aEW6a6iXv+sKZXskbSdUSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 810/846] xfrm: Dont accidentally set RTO_ONLINK in decode_session4()
Date:   Mon, 24 Jan 2022 19:45:27 +0100
Message-Id: <20220124184128.865192336@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -3297,7 +3298,7 @@ decode_session4(struct sk_buff *skb, str
 	fl4->flowi4_proto = iph->protocol;
 	fl4->daddr = reverse ? iph->saddr : iph->daddr;
 	fl4->saddr = reverse ? iph->daddr : iph->saddr;
-	fl4->flowi4_tos = iph->tos;
+	fl4->flowi4_tos = iph->tos & ~INET_ECN_MASK;
 
 	if (!ip_is_fragment(iph)) {
 		switch (iph->protocol) {


