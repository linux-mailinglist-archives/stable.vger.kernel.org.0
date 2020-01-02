Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68F6B12EFC5
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbgABW2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:28:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729818AbgABW2A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:28:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1615F20863;
        Thu,  2 Jan 2020 22:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004079;
        bh=Jz4+tiQoA3soK8mhbo9Lb7ejNwOo5S1DZL385cqGIac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c8Z+SNCHBUBRsHbkBR62aPNPvmxOlqNxgtGVBv3wqU/AhoTYDO4L0fW16FjvIOG+8
         lcnzQZl9gpnjc8mZDhApzBGp+Piay6n1GOp8mZZjtEYOT7iiCe5vIsBg842LQg+88n
         FLuIp0m8y820r6gDpoiMS0CCNd4xgGw0K5Pf5nWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 029/171] media: ti-vpe: vpe: fix a v4l2-compliance failure about frame sequence number
Date:   Thu,  2 Jan 2020 23:06:00 +0100
Message-Id: <20200102220551.106012580@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index da308fa6561f..067548e14e11 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1298,6 +1298,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 		d_vb->timecode = s_vb->timecode;
 
 	d_vb->sequence = ctx->sequence;
+	s_vb->sequence = ctx->sequence;
 
 	d_q_data = &ctx->q_data[Q_DATA_DST];
 	if (d_q_data->flags & Q_DATA_INTERLACED) {
-- 
2.20.1



