Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F6C3BB2F5
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhGDXQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233510AbhGDXOa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF2E46198F;
        Sun,  4 Jul 2021 23:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440200;
        bh=QscHBCdwyz845ByNO9AmsX1v5TFqG9DVE99wooaq7oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbrdEEz4dDqMw0eStAvRtHmSNlNPndcKvleqUxT5lB4z0UZSjzBDj0q/bHPHBjQHh
         UAld1omJ5Em0XLXHN9V4r5uyozB5XJ55i4v0xZtYwqjw8uh5m0fL2ua6zuhHVLAsle
         5spZcj8y0Zax/R8qpy3kdD9mUmsQPz8/0EfzV43APimNSwiWN2Jmwy51bNyIeDkkS8
         BDkv1cE0DMCdiH8JJjCiwseelkceTT8v8bXFzmsyrZ1QPgYrsgvo5kXYOVmcyycgbJ
         iMJlJ74riDqOX0rb2uZpbwlEy/VqH49ECfMYMAaRZ8EVnoGBlTidylxl5PQaTXld0y
         ObyVJ/vUfBM0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/50] media: cobalt: fix race condition in setting HPD
Date:   Sun,  4 Jul 2021 19:09:05 -0400
Message-Id: <20210704230938.1490742-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 3d37ef41bed0854805ab9af22c422267510e1344 ]

The cobalt_s_bit_sysctrl reads the old register value over PCI,
then changes a bit and sets writes the new value to the register.

This is used among other things for setting the HPD output pin.

But if the HPD is changed for multiple inputs at the same time,
then this causes a race condition where a stale value is read.

Serialize this function with a mutex.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cobalt/cobalt-driver.c | 1 +
 drivers/media/pci/cobalt/cobalt-driver.h | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 0695078ef812..1bd8bbe57a30 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -667,6 +667,7 @@ static int cobalt_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 	cobalt->pci_dev = pci_dev;
 	cobalt->instance = i;
+	mutex_init(&cobalt->pci_lock);
 
 	retval = v4l2_device_register(&pci_dev->dev, &cobalt->v4l2_dev);
 	if (retval) {
diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
index bca68572b324..12c33e035904 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.h
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -251,6 +251,8 @@ struct cobalt {
 	int instance;
 	struct pci_dev *pci_dev;
 	struct v4l2_device v4l2_dev;
+	/* serialize PCI access in cobalt_s_bit_sysctrl() */
+	struct mutex pci_lock;
 
 	void __iomem *bar0, *bar1;
 
@@ -320,10 +322,13 @@ static inline u32 cobalt_g_sysctrl(struct cobalt *cobalt)
 static inline void cobalt_s_bit_sysctrl(struct cobalt *cobalt,
 					int bit, int val)
 {
-	u32 ctrl = cobalt_read_bar1(cobalt, COBALT_SYS_CTRL_BASE);
+	u32 ctrl;
 
+	mutex_lock(&cobalt->pci_lock);
+	ctrl = cobalt_read_bar1(cobalt, COBALT_SYS_CTRL_BASE);
 	cobalt_write_bar1(cobalt, COBALT_SYS_CTRL_BASE,
 			(ctrl & ~(1UL << bit)) | (val << bit));
+	mutex_unlock(&cobalt->pci_lock);
 }
 
 static inline u32 cobalt_g_sysstat(struct cobalt *cobalt)
-- 
2.30.2

