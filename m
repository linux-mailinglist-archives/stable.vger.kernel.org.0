Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B4669695
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388192AbfGOOFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731284AbfGOOFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:05:46 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E4BF217F9;
        Mon, 15 Jul 2019 14:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199546;
        bh=WeOczSlAxi1PpfYbpQfUm578xh1Zna2AUiZaBBpukxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6wJkQAHcSr4bR3nQRzorM1NxHgBEU0j1RPf7w4xiuyuv66zElOVdJf5D8lxcJigl
         jTUGuIoIzhucqZR8JGyo5l+wniYBWStIf93Mq7/cZNDrsKAZRdHjdDQnCPfAAf4S1a
         zzOX+OyytoBe15sEcq3wugqk7JPtQWGrkoO/PZgc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     sumitg <sumitg@nvidia.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 038/219] media: v4l2-core: fix use-after-free error
Date:   Mon, 15 Jul 2019 10:00:39 -0400
Message-Id: <20190715140341.6443-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: sumitg <sumitg@nvidia.com>

[ Upstream commit 3e0f724346e96daae7792262c6767449795ac3b5 ]

Fixing use-after-free within __v4l2_ctrl_handler_setup().
Memory is being freed with kfree(new_ref) for duplicate
control reference entry but ctrl->cluster pointer is still
referring to freed duplicate entry resulting in error on
access. Change done to update cluster pointer only when new
control reference is added.

 ==================================================================
 BUG: KASAN: use-after-free in __v4l2_ctrl_handler_setup+0x388/0x428
 Read of size 8 at addr ffffffc324e78618 by task systemd-udevd/312

 Allocated by task 312:

 Freed by task 312:

 The buggy address belongs to the object at ffffffc324e78600
  which belongs to the cache kmalloc-64 of size 64
 The buggy address is located 24 bytes inside of
  64-byte region [ffffffc324e78600, ffffffc324e78640)
 The buggy address belongs to the page:
 page:ffffffbf0c939e00 count:1 mapcount:0 mapping:
					(null) index:0xffffffc324e78f80
 flags: 0x4000000000000100(slab)
 raw: 4000000000000100 0000000000000000 ffffffc324e78f80 000000018020001a
 raw: 0000000000000000 0000000100000001 ffffffc37040fb80 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffffffc324e78500: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  ffffffc324e78580: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 >ffffffc324e78600: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                             ^
  ffffffc324e78680: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
  ffffffc324e78700: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
 ==================================================================

Suggested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 54d66dbc2a31..fd18923ccc14 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2148,15 +2148,6 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 	if (size_extra_req)
 		new_ref->p_req.p = &new_ref[1];
 
-	if (ctrl->handler == hdl) {
-		/* By default each control starts in a cluster of its own.
-		   new_ref->ctrl is basically a cluster array with one
-		   element, so that's perfect to use as the cluster pointer.
-		   But only do this for the handler that owns the control. */
-		ctrl->cluster = &new_ref->ctrl;
-		ctrl->ncontrols = 1;
-	}
-
 	INIT_LIST_HEAD(&new_ref->node);
 
 	mutex_lock(hdl->lock);
@@ -2189,6 +2180,15 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 	hdl->buckets[bucket] = new_ref;
 	if (ctrl_ref)
 		*ctrl_ref = new_ref;
+	if (ctrl->handler == hdl) {
+		/* By default each control starts in a cluster of its own.
+		 * new_ref->ctrl is basically a cluster array with one
+		 * element, so that's perfect to use as the cluster pointer.
+		 * But only do this for the handler that owns the control.
+		 */
+		ctrl->cluster = &new_ref->ctrl;
+		ctrl->ncontrols = 1;
+	}
 
 unlock:
 	mutex_unlock(hdl->lock);
-- 
2.20.1

