Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B17C4520E0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359300AbhKPA45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245672AbhKOTVA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C78CB63307;
        Mon, 15 Nov 2021 18:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001545;
        bh=p/IA2iKt52Z3pdaNhuOinkutgSIYR8hqCzI0OdvDL1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RW83hjVHsVb9NYFYnTJ9QwI6P+CF0FehJ0lPDf1WUSWeTqgmnzHgNYygC3wcEGRyM
         5yKOGpFfL1EWjxz6FvRh5y8jsec3psFHBP8TLq7jYVd9aIcAL652W5DKL/aiwmj/nO
         sm+lD4ntvzzRgnhBbvP7oXhaSD1XdWt+SxTTlyiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 230/917] media: rcar-vin: Use user provided buffers when starting
Date:   Mon, 15 Nov 2021 17:55:25 +0100
Message-Id: <20211115165436.586425254@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit a5991c4e947153418f71f4689614b87ca0551b81 ]

When adding an internal scratch buffer to improve buffer handling when
stopping it was also erroneously used when syncing at capture start.
This led to that the first three buffers captured were always dropped
as they were captured in the scratch buffer instead of in a buffer
provided by the user.

Allow the hardware to be given user provided buffers when preparing for
capture in the stopped state. This still allows the driver to sync with
the hardware and always completes the buffers to user-space in the
correct order as no buffers are completed before the sync is complete.
This change improves the driver as buffers are completed and given to
the user three frames earlier than before.

The change also fixes a warning produced by v4l2-compliance,

    warn: v4l2-test-buffers.cpp(448): got sequence number 3, expected 0

[hverkuil: fixed some typos in the Subject and the log message]

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index f5f722ab1d4e8..520d044bfb8d5 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -904,7 +904,8 @@ static void rvin_fill_hw_slot(struct rvin_dev *vin, int slot)
 				vin->format.sizeimage / 2;
 			break;
 		}
-	} else if (vin->state != RUNNING || list_empty(&vin->buf_list)) {
+	} else if ((vin->state != STOPPED && vin->state != RUNNING) ||
+		   list_empty(&vin->buf_list)) {
 		vin->buf_hw[slot].buffer = NULL;
 		vin->buf_hw[slot].type = FULL;
 		phys_addr = vin->scratch_phys;
-- 
2.33.0



