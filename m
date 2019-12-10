Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD6F71199D3
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfLJVIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:08:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:56286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727573AbfLJVIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5792A24680;
        Tue, 10 Dec 2019 21:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012120;
        bh=C8pkPNteKe4v3Hogd5f/wzVbWZbO5QD6AhnNQUR05OM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EpxT6YUaaTH2lZVcV2wP4P1H+iG+xZLcDBJsWF7ez69s9xvQ7iw7P4vnwe5L0P4Ic
         +oFflLBj/rF89VGzkCSk1x974bfuATFBcMuJ16Xht1BBm3vdrVX/2qA6QWgySP1K6J
         BidFK6bbFiK7heg1pLS8GuTncfHYTx3fcbQ63bzo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benoit Parrot <bparrot@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 091/350] media: ti-vpe: vpe: fix a v4l2-compliance failure about frame sequence number
Date:   Tue, 10 Dec 2019 16:03:16 -0500
Message-Id: <20191210210735.9077-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
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
index 328976a529414..e44299008a7b5 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1417,6 +1417,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 		d_vb->timecode = s_vb->timecode;
 
 	d_vb->sequence = ctx->sequence;
+	s_vb->sequence = ctx->sequence;
 
 	d_q_data = &ctx->q_data[Q_DATA_DST];
 	if (d_q_data->flags & Q_IS_INTERLACED) {
-- 
2.20.1

