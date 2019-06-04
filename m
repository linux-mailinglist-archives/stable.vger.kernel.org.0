Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE8133470C
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfFDMj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 08:39:56 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:50250 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727580AbfFDMj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 08:39:56 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 16788264-1500050 
        for multiple; Tue, 04 Jun 2019 13:39:52 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>, stable@vger.kernel.org
Subject: [PATCH] dma-buf: Discard old fence_excl on retrying get_fences_rcu for realloc
Date:   Tue,  4 Jun 2019 13:39:47 +0100
Message-Id: <20190604123947.20713-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we have to drop the seqcount & rcu lock to perform a krealloc, we
have to restart the loop. In doing so, be careful not to lose track of
the already acquired exclusive fence.

Fixes: fedf54132d24 ("dma-buf: Restart reservation_object_get_fences_rcu() after writes") #v4.10
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: stable@vger.kernel.org
---
 drivers/dma-buf/reservation.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index 4d32e2c67862..704503df4892 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -365,6 +365,12 @@ int reservation_object_get_fences_rcu(struct reservation_object *obj,
 					   GFP_NOWAIT | __GFP_NOWARN);
 			if (!nshared) {
 				rcu_read_unlock();
+
+				if (fence_excl) {
+					dma_fence_put(fence_excl);
+					fence_excl = NULL;
+				}
+
 				nshared = krealloc(shared, sz, GFP_KERNEL);
 				if (nshared) {
 					shared = nshared;
-- 
2.20.1

