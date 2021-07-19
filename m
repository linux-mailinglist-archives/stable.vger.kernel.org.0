Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2733CD930
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243778AbhGSO1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:27:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243493AbhGSO0C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:26:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB3956008E;
        Mon, 19 Jul 2021 15:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707201;
        bh=JVLNcAVvJA766fz17y2DwfSvWm1nR3bQ+DMjcfM4Kns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sulxdaDtpqXJTepzGawoEBcOGPDAcLUg/8wd9VcdDOKs39m/lw5d5g7hC+BpLvu4F
         qH6Ir9ZPV7kwgA/ywifa001gJXRycz8E+gumcb4SM5H+mhCY1uCMwmAg65xTRfH2vf
         ODUn1BKbQ8XvJXS0pPTPsFt4Y7VoN/hv76M2ZGbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 034/245] media: cobalt: fix race condition in setting HPD
Date:   Mon, 19 Jul 2021 16:49:36 +0200
Message-Id: <20210719144941.500366594@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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
index 979634000597..17b717a1c7fa 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -689,6 +689,7 @@ static int cobalt_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 	cobalt->pci_dev = pci_dev;
 	cobalt->instance = i;
+	mutex_init(&cobalt->pci_lock);
 
 	retval = v4l2_device_register(&pci_dev->dev, &cobalt->v4l2_dev);
 	if (retval) {
diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
index ed00dc9d9399..8f9454d30b95 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.h
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -262,6 +262,8 @@ struct cobalt {
 	int instance;
 	struct pci_dev *pci_dev;
 	struct v4l2_device v4l2_dev;
+	/* serialize PCI access in cobalt_s_bit_sysctrl() */
+	struct mutex pci_lock;
 
 	void __iomem *bar0, *bar1;
 
@@ -333,10 +335,13 @@ static inline u32 cobalt_g_sysctrl(struct cobalt *cobalt)
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



