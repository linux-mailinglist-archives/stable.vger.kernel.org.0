Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABED13F17F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392694AbgAPS3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:29:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390691AbgAPR0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:26:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42C5C246B9;
        Thu, 16 Jan 2020 17:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195561;
        bh=LSH4FYBmw7ZPauxZ6yfhbgNklBLUqMNtnR6gucz/zuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9rzzKOP43HszqKke5+yShRLY29OSgv3vQz0DVjnBPg5Pw6KdZSgci/Bjv06Zg+4m
         RNb6wg/Gkr+iyohgzerEmS59mZ9tm93gMM0qyoXSRcbixBf6PDvPtGvwK14dW3QrIe
         g7Jr4xCpDaorSP8s3Hot+x3SHBJojDM7Cm8QCiuI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 148/371] media: tw5864: Fix possible NULL pointer dereference in tw5864_handle_frame
Date:   Thu, 16 Jan 2020 12:20:20 -0500
Message-Id: <20200116172403.18149-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 2e7682ebfc750177a4944eeb56e97a3f05734528 ]

'vb' null check should be done before dereferencing it in
tw5864_handle_frame, otherwise a NULL pointer dereference
may occur.

Fixes: 34d1324edd31 ("[media] pci: Add tw5864 driver")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/tw5864/tw5864-video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index e7bd2b8484e3..ee1230440b39 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -1395,13 +1395,13 @@ static void tw5864_handle_frame(struct tw5864_h264_frame *frame)
 	input->vb = NULL;
 	spin_unlock_irqrestore(&input->slock, flags);
 
-	v4l2_buf = to_vb2_v4l2_buffer(&vb->vb.vb2_buf);
-
 	if (!vb) { /* Gone because of disabling */
 		dev_dbg(&dev->pci->dev, "vb is empty, dropping frame\n");
 		return;
 	}
 
+	v4l2_buf = to_vb2_v4l2_buffer(&vb->vb.vb2_buf);
+
 	/*
 	 * Check for space.
 	 * Mind the overhead of startcode emulation prevention.
-- 
2.20.1

