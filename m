Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FEC3BD2D1
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238889AbhGFLkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237373AbhGFLgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 220C161D8E;
        Tue,  6 Jul 2021 11:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570836;
        bh=QuJTIMQ5VK6Gfj7t+RpW9EpkFv4Tgo3EbCbcDqTAWfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llP+apL+Q+Uin0jc84gAZzae8+BpfANkIB9RYVjaxEMKcfR9R1XamDZ/9F0JvCtS2
         wc9EO2FdriV2N3ss8P90iZWLxFcISU+aY1ks4e/kE+ltSEaSDty4nryOKj+zS9vFTi
         3X4CoNFiafTTAz8aUembkkm6C0M3qesiK1Pj/V4JqNwVZ8yjzKJHGSXca/M9+IsvOc
         NGxkQTVgyNFxhAdHp4nQZH6+6Yfp0J6m/bwSyNtnOxXOR4VKONE8uyDbw/4ZnNBcvr
         s+QMLApSSGoqqgwi/K7VT3yhAvr7iS+Dclf084wbuEDYcIDzxTi3VhCvI1d3Jgu1ZK
         JR4i1H3f2l4Og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Minchan Kim <minchan@kernel.org>, Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, selinux@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 30/55] selinux: use __GFP_NOWARN with GFP_NOWAIT in the AVC
Date:   Tue,  6 Jul 2021 07:26:13 -0400
Message-Id: <20210706112638.2065023-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112638.2065023-1-sashal@kernel.org>
References: <20210706112638.2065023-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>

[ Upstream commit 648f2c6100cfa18e7dfe43bc0b9c3b73560d623c ]

In the field, we have seen lots of allocation failure from the call
path below.

06-03 13:29:12.999 1010315 31557 31557 W Binder  : 31542_2: page allocation failure: order:0, mode:0x800(GFP_NOWAIT), nodemask=(null),cpuset=background,mems_allowed=0
...
...
06-03 13:29:12.999 1010315 31557 31557 W Call trace:
06-03 13:29:12.999 1010315 31557 31557 W         : dump_backtrace.cfi_jt+0x0/0x8
06-03 13:29:12.999 1010315 31557 31557 W         : dump_stack+0xc8/0x14c
06-03 13:29:12.999 1010315 31557 31557 W         : warn_alloc+0x158/0x1c8
06-03 13:29:12.999 1010315 31557 31557 W         : __alloc_pages_slowpath+0x9d8/0xb80
06-03 13:29:12.999 1010315 31557 31557 W         : __alloc_pages_nodemask+0x1c4/0x430
06-03 13:29:12.999 1010315 31557 31557 W         : allocate_slab+0xb4/0x390
06-03 13:29:12.999 1010315 31557 31557 W         : ___slab_alloc+0x12c/0x3a4
06-03 13:29:12.999 1010315 31557 31557 W         : kmem_cache_alloc+0x358/0x5e4
06-03 13:29:12.999 1010315 31557 31557 W         : avc_alloc_node+0x30/0x184
06-03 13:29:12.999 1010315 31557 31557 W         : avc_update_node+0x54/0x4f0
06-03 13:29:12.999 1010315 31557 31557 W         : avc_has_extended_perms+0x1a4/0x460
06-03 13:29:12.999 1010315 31557 31557 W         : selinux_file_ioctl+0x320/0x3d0
06-03 13:29:12.999 1010315 31557 31557 W         : __arm64_sys_ioctl+0xec/0x1fc
06-03 13:29:12.999 1010315 31557 31557 W         : el0_svc_common+0xc0/0x24c
06-03 13:29:12.999 1010315 31557 31557 W         : el0_svc+0x28/0x88
06-03 13:29:12.999 1010315 31557 31557 W         : el0_sync_handler+0x8c/0xf0
06-03 13:29:12.999 1010315 31557 31557 W         : el0_sync+0x1a4/0x1c0
..
..
06-03 13:29:12.999 1010315 31557 31557 W SLUB    : Unable to allocate memory on node -1, gfp=0x900(GFP_NOWAIT|__GFP_ZERO)
06-03 13:29:12.999 1010315 31557 31557 W cache   : avc_node, object size: 72, buffer size: 80, default order: 0, min order: 0
06-03 13:29:12.999 1010315 31557 31557 W node 0  : slabs: 57, objs: 2907, free: 0
06-03 13:29:12.999 1010161 10686 10686 W SLUB    : Unable to allocate memory on node -1, gfp=0x900(GFP_NOWAIT|__GFP_ZERO)
06-03 13:29:12.999 1010161 10686 10686 W cache   : avc_node, object size: 72, buffer size: 80, default order: 0, min order: 0
06-03 13:29:12.999 1010161 10686 10686 W node 0  : slabs: 57, objs: 2907, free: 0
06-03 13:29:12.999 1010161 10686 10686 W SLUB    : Unable to allocate memory on node -1, gfp=0x900(GFP_NOWAIT|__GFP_ZERO)
06-03 13:29:12.999 1010161 10686 10686 W cache   : avc_node, object size: 72, buffer size: 80, default order: 0, min order: 0
06-03 13:29:12.999 1010161 10686 10686 W node 0  : slabs: 57, objs: 2907, free: 0
06-03 13:29:12.999 1010161 10686 10686 W SLUB    : Unable to allocate memory on node -1, gfp=0x900(GFP_NOWAIT|__GFP_ZERO)
06-03 13:29:12.999 1010161 10686 10686 W cache   : avc_node, object size: 72, buffer size: 80, default order: 0, min order: 0
06-03 13:29:12.999 1010161 10686 10686 W node 0  : slabs: 57, objs: 2907, free: 0
06-03 13:29:13.000 1010161 10686 10686 W SLUB    : Unable to allocate memory on node -1, gfp=0x900(GFP_NOWAIT|__GFP_ZERO)
06-03 13:29:13.000 1010161 10686 10686 W cache   : avc_node, object size: 72, buffer size: 80, default order: 0, min order: 0
06-03 13:29:13.000 1010161 10686 10686 W node 0  : slabs: 57, objs: 2907, free: 0
06-03 13:29:13.000 1010161 10686 10686 W SLUB    : Unable to allocate memory on node -1, gfp=0x900(GFP_NOWAIT|__GFP_ZERO)
06-03 13:29:13.000 1010161 10686 10686 W cache   : avc_node, object size: 72, buffer size: 80, default order: 0, min order: 0
06-03 13:29:13.000 1010161 10686 10686 W node 0  : slabs: 57, objs: 2907, free: 0
06-03 13:29:13.000 1010161 10686 10686 W SLUB    : Unable to allocate memory on node -1, gfp=0x900(GFP_NOWAIT|__GFP_ZERO)
06-03 13:29:13.000 1010161 10686 10686 W cache   : avc_node, object size: 72, buffer size: 80, default order: 0, min order: 0
06-03 13:29:13.000 1010161 10686 10686 W node 0  : slabs: 57, objs: 2907, free: 0
06-03 13:29:13.000 10230 30892 30892 W SLUB    : Unable to allocate memory on node -1, gfp=0x900(GFP_NOWAIT|__GFP_ZERO)
06-03 13:29:13.000 10230 30892 30892 W cache   : avc_node, object size: 72, buffer size: 80, default order: 0, min order: 0
06-03 13:29:13.000 10230 30892 30892 W node 0  : slabs: 57, objs: 2907, free: 0
06-03 13:29:13.000 10230 30892 30892 W SLUB    : Unable to allocate memory on node -1, gfp=0x900(GFP_NOWAIT|__GFP_ZERO)
06-03 13:29:13.000 10230 30892 30892 W cache   : avc_node, object size: 72, buffer size: 80, default order: 0, min order: 0

Based on [1], selinux is tolerate for failure of memory allocation.
Then, use __GFP_NOWARN together.

[1] 476accbe2f6e ("selinux: use GFP_NOWAIT in the AVC kmem_caches")

Signed-off-by: Minchan Kim <minchan@kernel.org>
[PM: subj fix, line wraps, normalized commit refs]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/avc.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index d52be7b9f08c..717a4be771ab 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -366,26 +366,27 @@ static struct avc_xperms_decision_node
 	struct avc_xperms_decision_node *xpd_node;
 	struct extended_perms_decision *xpd;
 
-	xpd_node = kmem_cache_zalloc(avc_xperms_decision_cachep, GFP_NOWAIT);
+	xpd_node = kmem_cache_zalloc(avc_xperms_decision_cachep,
+				     GFP_NOWAIT | __GFP_NOWARN);
 	if (!xpd_node)
 		return NULL;
 
 	xpd = &xpd_node->xpd;
 	if (which & XPERMS_ALLOWED) {
 		xpd->allowed = kmem_cache_zalloc(avc_xperms_data_cachep,
-						GFP_NOWAIT);
+						GFP_NOWAIT | __GFP_NOWARN);
 		if (!xpd->allowed)
 			goto error;
 	}
 	if (which & XPERMS_AUDITALLOW) {
 		xpd->auditallow = kmem_cache_zalloc(avc_xperms_data_cachep,
-						GFP_NOWAIT);
+						GFP_NOWAIT | __GFP_NOWARN);
 		if (!xpd->auditallow)
 			goto error;
 	}
 	if (which & XPERMS_DONTAUDIT) {
 		xpd->dontaudit = kmem_cache_zalloc(avc_xperms_data_cachep,
-						GFP_NOWAIT);
+						GFP_NOWAIT | __GFP_NOWARN);
 		if (!xpd->dontaudit)
 			goto error;
 	}
@@ -413,7 +414,7 @@ static struct avc_xperms_node *avc_xperms_alloc(void)
 {
 	struct avc_xperms_node *xp_node;
 
-	xp_node = kmem_cache_zalloc(avc_xperms_cachep, GFP_NOWAIT);
+	xp_node = kmem_cache_zalloc(avc_xperms_cachep, GFP_NOWAIT | __GFP_NOWARN);
 	if (!xp_node)
 		return xp_node;
 	INIT_LIST_HEAD(&xp_node->xpd_head);
@@ -569,7 +570,7 @@ static struct avc_node *avc_alloc_node(struct selinux_avc *avc)
 {
 	struct avc_node *node;
 
-	node = kmem_cache_zalloc(avc_node_cachep, GFP_NOWAIT);
+	node = kmem_cache_zalloc(avc_node_cachep, GFP_NOWAIT | __GFP_NOWARN);
 	if (!node)
 		goto out;
 
-- 
2.30.2

