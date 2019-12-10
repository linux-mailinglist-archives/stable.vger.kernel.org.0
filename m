Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4332011988C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbfLJVdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:33:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729679AbfLJVdO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:33:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B4DB2465B;
        Tue, 10 Dec 2019 21:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013593;
        bh=fUT6Pn01ttJfQAMVCmqg6TU51DnWYoWbK2CehYAnmO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbCuwdgMuMHg8Iv88FUjwUsdEqeyjCBDsfRHrGailenZ0SEyczP/ZiGs9i2giwLuW
         JNVL96kU2uXrJLHnUExXNpHXFp2ncJAtf03ng0iimMkVwBxZ4teULkUzCirXfs8mDU
         2I6Pqehn+JlIzGXcIIedC2MI0Yb+tURRtRSwMJAA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benoit Parrot <bparrot@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 043/177] media: ti-vpe: vpe: fix a v4l2-compliance failure about frame sequence number
Date:   Tue, 10 Dec 2019 16:30:07 -0500
Message-Id: <20191210213221.11921-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benoit Parrot <bparrot@ti.com>

[ Upstream commit 2444846c0dbfa4ead21b621e4300ec32c90fbf38 ]

v4l2-compliance fails with this message:

   fail: v4l2-test-buffers.cpp(294): \
	(int)g_sequence() < seq.last_seq + 1
   fail: v4l2-test-buffers.cpp(740): \
	buf.check(m2m_q, last_m2m_seq)
   fail: v4l2-test-buffers.cpp(974): \
	captureBufs(node, q, m2m_q, frame_count, true)
   test MMAP: FAIL

The driver is failing to update the source frame sequence number in the
vb2 buffer object. Only the destination frame sequence was being
updated.

This is only a reporting issue if the user space app actually cares
about the frame sequence number. But it is fixed nonetheless.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti-vpe/vpe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 76d699e94b001..15f0b0bb89c0e 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1431,6 +1431,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 		d_vb->timecode = s_vb->timecode;
 
 	d_vb->sequence = ctx->sequence;
+	s_vb->sequence = ctx->sequence;
 
 	d_q_data = &ctx->q_data[Q_DATA_DST];
 	if (d_q_data->flags & Q_IS_INTERLACED) {
-- 
2.20.1

