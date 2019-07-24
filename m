Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FACE73FF1
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388102AbfGXUgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729096AbfGXTYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:24:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4176B22AEC;
        Wed, 24 Jul 2019 19:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996275;
        bh=8Epo5mX/jfx/Dnfn9i/juu/jynssAskXHtTYW82raC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7frPnrREQVOGlohAAIEgjEKQrM8GbI98Xd3LsvuX588/yL/YY8g2AhralObN0UXL
         rT7nSecLL2l9mFhdPLcdftS1+qxFekz4Yn+u+9j+yMZXkVa5yjTugxdMo+7cIDk/e2
         8xXhSYWXuUDvMbYaAE166LsbqXvU43+CHQylQBCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sumit Gupta <sumitg@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 042/413] media: v4l2-core: fix use-after-free error
Date:   Wed, 24 Jul 2019 21:15:33 +0200
Message-Id: <20190724191738.601822314@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 7d3a33258748..3c720f54efa8 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2149,15 +2149,6 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
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
@@ -2190,6 +2181,15 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
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



