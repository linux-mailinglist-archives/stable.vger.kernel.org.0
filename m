Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18CD3CDCAD
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237617AbhGSOxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237933AbhGSOtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:49:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 989CF611F2;
        Mon, 19 Jul 2021 15:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708610;
        bh=0uJ50+GR1GXb++JGu48gzrWZBY9aV7V3ZS3Fu0rd30c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yXFRpKvYuBUrCPGHYK0irTWTqsnIekPhVWJ+i6L5Bs2Hk6kwsgdGPXXRHHYz140o1
         szBbfbB8XKNSVaw1z/J/zMhGepxPNm+dKmpTV5/D1UCOLZjOyfu01v6HnPSBQwKGd8
         pMNH2p3uwfrkO9WDJThMY1yDKc9gLuZn3wLVzWsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/421] media: cobalt: fix race condition in setting HPD
Date:   Mon, 19 Jul 2021 16:47:49 +0200
Message-Id: <20210719144948.215015817@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4885e833c052..f422558e6392 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -675,6 +675,7 @@ static int cobalt_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 	cobalt->pci_dev = pci_dev;
 	cobalt->instance = i;
+	mutex_init(&cobalt->pci_lock);
 
 	retval = v4l2_device_register(&pci_dev->dev, &cobalt->v4l2_dev);
 	if (retval) {
diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
index 429bee4ef79c..883093e5adea 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.h
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -250,6 +250,8 @@ struct cobalt {
 	int instance;
 	struct pci_dev *pci_dev;
 	struct v4l2_device v4l2_dev;
+	/* serialize PCI access in cobalt_s_bit_sysctrl() */
+	struct mutex pci_lock;
 
 	void __iomem *bar0, *bar1;
 
@@ -319,10 +321,13 @@ static inline u32 cobalt_g_sysctrl(struct cobalt *cobalt)
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



