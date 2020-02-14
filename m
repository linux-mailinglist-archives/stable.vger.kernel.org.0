Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E9E15E810
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404531AbgBNQ5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:57:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404540AbgBNQRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62CCB246EA;
        Fri, 14 Feb 2020 16:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697062;
        bh=i4rCMs/KdszCUrhFYZjd38y7vAH2KN/V466RTKcmpKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2PjB2sqz5t1awhS8jETcuUNPFOdWPUxBtejfW9kVyAZxVks2vqmlbV5JDsr/4agcz
         dKKqLSSjfrMF7fChSifL/MF7wLayUWl1ks+sigddrmTcchcbDQv+0N3wmY85s0Zzms
         IySjy/7U4FcokMAUlYGwRfwePNPxkqhW3zzO+gro=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 020/186] media: sti: bdisp: fix a possible sleep-in-atomic-context bug in bdisp_device_run()
Date:   Fri, 14 Feb 2020 11:14:29 -0500
Message-Id: <20200214161715.18113-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
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
index b7892f3efd988..5c4c3f0c57be1 100644
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

