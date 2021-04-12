Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B273135B88A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbhDLCXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236608AbhDLCXV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1EC26120D;
        Mon, 12 Apr 2021 02:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194184;
        bh=HvDlUADo7ytrxih9rh1i+Ig1FSjWh/AOcjNDKfdP+Go=;
        h=From:To:Cc:Subject:Date:From;
        b=gyTJFmK5DisD7dlfwE1tsR5/ZqyEh/CbyN2oBLEfq93bEuRuKWz+95AEkW84b/mCE
         2kZ9btoUNloSEk+/2a6l0xRMU6ilpyBHMXcI4z11Kk0mu2puPXuZqgqykyPZoVV5Q4
         WtoqhjX1+y+mblcs4vTNAPE2VPg6ueSEXaMh9aBRMVLNDFymF0Qa44JCmqo+GOIH/P
         WQKANKY1P9gN/BYn00I5OHonSAX7FqfGu9tqno/ZRIr5MEO3zJZqByl9QEc8qDQ8mm
         PosyLSZhjdWitBUSkeabjUFmV8rg+e76hMPVGLmnOp6okDZAQB2fvBgPilfbZRLu9e
         8NhUac/LNWX3w==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, i.maximets@ovn.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: FAILED: Patch "openvswitch: fix send of uninitialized stack memory in ct limit reply" failed to apply to 4.19-stable tree
Date:   Sun, 11 Apr 2021 22:23:02 -0400
Message-Id: <20210412022302.283681-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 4d51419d49930be2701c2633ae271b350397c3ca Mon Sep 17 00:00:00 2001
From: Ilya Maximets <i.maximets@ovn.org>
Date: Sun, 4 Apr 2021 19:50:31 +0200
Subject: [PATCH] openvswitch: fix send of uninitialized stack memory in ct
 limit reply

'struct ovs_zone_limit' has more members than initialized in
ovs_ct_limit_get_default_limit().  The rest of the memory is a random
kernel stack content that ends up being sent to userspace.

Fix that by using designated initializer that will clear all
non-specified fields.

Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/openvswitch/conntrack.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 71cec03e8612..d217bd91176b 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2034,10 +2034,10 @@ static int ovs_ct_limit_del_zone_limit(struct nlattr *nla_zone_limit,
 static int ovs_ct_limit_get_default_limit(struct ovs_ct_limit_info *info,
 					  struct sk_buff *reply)
 {
-	struct ovs_zone_limit zone_limit;
-
-	zone_limit.zone_id = OVS_ZONE_LIMIT_DEFAULT_ZONE;
-	zone_limit.limit = info->default_limit;
+	struct ovs_zone_limit zone_limit = {
+		.zone_id = OVS_ZONE_LIMIT_DEFAULT_ZONE,
+		.limit   = info->default_limit,
+	};
 
 	return nla_put_nohdr(reply, sizeof(zone_limit), &zone_limit);
 }
-- 
2.30.2




