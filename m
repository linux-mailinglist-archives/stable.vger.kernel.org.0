Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 340DF15EEFC
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389495AbgBNQC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:02:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389492AbgBNQC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:02:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDF1724681;
        Fri, 14 Feb 2020 16:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696175;
        bh=UePCY4BqtIvlghuVOYlkGyqEl9Oi9N2cZL5RSM9Ehrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y939bBz1MDDiWlcYj5L//e+9DBPaQPwIVUEJgYL7AUD9ntKD6AthkFXww5jFXXgiO
         3lVjjkXPV7iTFBTBtLKneB7JxW6QqSXOkZ8gQApguNRycosgS10AAT0Qv2PlP06PLF
         mNQ/3q8csXzIqYZXjyaJgHp2WrdWkCTNWTp5MOaY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 048/459] media: sti: bdisp: fix a possible sleep-in-atomic-context bug in bdisp_device_run()
Date:   Fri, 14 Feb 2020 10:54:58 -0500
Message-Id: <20200214160149.11681-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit bb6d42061a05d71dd73f620582d9e09c8fbf7f5b ]

The driver may sleep while holding a spinlock.
The function call path (from bottom to top) in Linux 4.19 is:

drivers/media/platform/sti/bdisp/bdisp-hw.c, 385:
    msleep in bdisp_hw_reset
drivers/media/platform/sti/bdisp/bdisp-v4l2.c, 341:
    bdisp_hw_reset in bdisp_device_run
drivers/media/platform/sti/bdisp/bdisp-v4l2.c, 317:
    _raw_spin_lock_irqsave in bdisp_device_run

To fix this bug, msleep() is replaced with udelay().

This bug is found by a static analysis tool STCheck written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reviewed-by: Fabien Dessenne <fabien.dessenne@st.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sti/bdisp/bdisp-hw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-hw.c b/drivers/media/platform/sti/bdisp/bdisp-hw.c
index 4372abbb5950f..a74e9fd652389 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-hw.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-hw.c
@@ -14,8 +14,8 @@
 #define MAX_SRC_WIDTH           2048
 
 /* Reset & boot poll config */
-#define POLL_RST_MAX            50
-#define POLL_RST_DELAY_MS       20
+#define POLL_RST_MAX            500
+#define POLL_RST_DELAY_MS       2
 
 enum bdisp_target_plan {
 	BDISP_RGB,
@@ -382,7 +382,7 @@ int bdisp_hw_reset(struct bdisp_dev *bdisp)
 	for (i = 0; i < POLL_RST_MAX; i++) {
 		if (readl(bdisp->regs + BLT_STA1) & BLT_STA1_IDLE)
 			break;
-		msleep(POLL_RST_DELAY_MS);
+		udelay(POLL_RST_DELAY_MS * 1000);
 	}
 	if (i == POLL_RST_MAX)
 		dev_err(bdisp->dev, "Reset timeout\n");
-- 
2.20.1

