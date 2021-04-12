Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BAD35B884
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbhDLCXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235857AbhDLCXG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 859A36120A;
        Mon, 12 Apr 2021 02:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194169;
        bh=W30D/kBvJbrJaKXriUvPqBgwdlRPu5605x+r/a0p8Ug=;
        h=From:To:Cc:Subject:Date:From;
        b=C1fqm3t15xJ4GNJOjcbf/tZ7SQEHGWLOz2rZBfYunIdSlleOAV763s6rFnXMm8/oI
         tx6udXBdIABJGGy6tcgUwUKVIOYoEV9hfzGgz95n2gxgUYm50bSr4pjtpB3WoJBNlE
         hNWeR9FJ6ShM5rUCGMugXauOLBthEUMXJ/VlSIMsZDu/1tALPWnG1dO/bDfUdEnIF9
         IFPXeOwyDjLMDN6LZQSRXGG5BtEzphSQSDLsLkTsduInYLGdti2rFUaOYtcyVroah8
         Rv8R6gXGJ/PFIadFm/oi6s+OVhUeB8FnEQl+asWhpSggOyDIr2NaL1A7fo353/yPU4
         Ao+2irSARa5uQ==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, boon.leong.ong@intel.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: FAILED: Patch "xdp: fix xdp_return_frame() kernel BUG throw for page_pool memory model" failed to apply to 5.4-stable tree
Date:   Sun, 11 Apr 2021 22:22:47 -0400
Message-Id: <20210412022247.283277-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 622d13694b5f048c01caa7ba548498d9880d4cb0 Mon Sep 17 00:00:00 2001
From: Ong Boon Leong <boon.leong.ong@intel.com>
Date: Wed, 31 Mar 2021 21:25:03 +0800
Subject: [PATCH] xdp: fix xdp_return_frame() kernel BUG throw for page_pool
 memory model

xdp_return_frame() may be called outside of NAPI context to return
xdpf back to page_pool. xdp_return_frame() calls __xdp_return() with
napi_direct = false. For page_pool memory model, __xdp_return() calls
xdp_return_frame_no_direct() unconditionally and below false negative
kernel BUG throw happened under preempt-rt build:

[  430.450355] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/3884
[  430.451678] caller is __xdp_return+0x1ff/0x2e0
[  430.452111] CPU: 0 PID: 3884 Comm: modprobe Tainted: G     U      E     5.12.0-rc2+ #45

Changes in v2:
 - This patch fixes the issue by making xdp_return_frame_no_direct() is
   only called if napi_direct = true, as recommended for better by
   Jesper Dangaard Brouer. Thanks!

Fixes: 2539650fadbf ("xdp: Helpers for disabling napi_direct of xdp_return_frame")
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/core/xdp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 05354976c1fc..858276e72c68 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -350,7 +350,8 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
 		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
 		page = virt_to_head_page(data);
-		napi_direct &= !xdp_return_frame_no_direct();
+		if (napi_direct && xdp_return_frame_no_direct())
+			napi_direct = false;
 		page_pool_put_full_page(xa->page_pool, page, napi_direct);
 		rcu_read_unlock();
 		break;
-- 
2.30.2




