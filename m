Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E4F35C069
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237778AbhDLJNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240284AbhDLJKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3930D61278;
        Mon, 12 Apr 2021 09:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218309;
        bh=e2GOtONqIKPscLHRK3BMkU515TNI6jGtQk8adjOJPJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Evrd+T9yVrPXy24pE/3OjBBqYtZsAgIrMdFy5ayr/6VXTTdGHgk+v7UNA8Sa9imOH
         xcrPNqHWStHEAhN/E5ONPGD+2u6+W880yJ3z2B6Lx8XvIaM4S/V4aTUjKJvYHT2hW9
         7m/UA2mB3z8Z6C0bnzIldE19OMikGPhqlbCATNzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 149/210] xdp: fix xdp_return_frame() kernel BUG throw for page_pool memory model
Date:   Mon, 12 Apr 2021 10:40:54 +0200
Message-Id: <20210412084020.951775534@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

[ Upstream commit 622d13694b5f048c01caa7ba548498d9880d4cb0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/xdp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 3a8c9ab4ecbe..a86bc3660729 100644
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



