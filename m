Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EAE3137FA
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhBHPeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:34:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233678AbhBHP3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:29:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0C0D64F2F;
        Mon,  8 Feb 2021 15:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797405;
        bh=x3SUHPR1hOCknJIMUCkwaNMMAOZGaXKzLs2YmmUqN40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZmG9wjXpN2GCbm7/hKYQ/0UHKTnd0s4FW5Zb7wt2zJS4vIgxd84rKeloWd4lIWoBI
         +RuLTiyHPt78a4pK42tBRDD/WNAjvG/ND7AIXgz6V6kyxEuzxl45k0KG1+GZc0JBCU
         j2q2YnjMVz05kXxRSsFD2a7tQE1dkfIu1TR3veVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 066/120] genirq: Prevent [devm_]irq_alloc_desc from returning irq 0
Date:   Mon,  8 Feb 2021 16:00:53 +0100
Message-Id: <20210208145821.049459874@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 4c7bcb51ae25f79e3733982e5d0cd8ce8640ddfc upstream.

Since commit a85a6c86c25b ("driver core: platform: Clarify that IRQ 0
is invalid"), having a linux-irq with number 0 will trigger a WARN()
when calling platform_get_irq*() to retrieve that linux-irq.

Since [devm_]irq_alloc_desc allocs a single irq and since irq 0 is not used
on some systems, it can return 0, triggering that WARN(). This happens
e.g. on Intel Bay Trail and Cherry Trail devices using the LPE audio engine
for HDMI audio:

 0 is an invalid IRQ number
 WARNING: CPU: 3 PID: 472 at drivers/base/platform.c:238 platform_get_irq_optional+0x108/0x180
 Modules linked in: snd_hdmi_lpe_audio(+) ...

 Call Trace:
  platform_get_irq+0x17/0x30
  hdmi_lpe_audio_probe+0x4a/0x6c0 [snd_hdmi_lpe_audio]

 ---[ end trace ceece38854223a0b ]---

Change the 'from' parameter passed to __[devm_]irq_alloc_descs() by the
[devm_]irq_alloc_desc macros from 0 to 1, so that these macros will no
longer return 0.

Fixes: a85a6c86c25b ("driver core: platform: Clarify that IRQ 0 is invalid")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201221185647.226146-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/irq.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -922,7 +922,7 @@ int __devm_irq_alloc_descs(struct device
 	__irq_alloc_descs(irq, from, cnt, node, THIS_MODULE, NULL)
 
 #define irq_alloc_desc(node)			\
-	irq_alloc_descs(-1, 0, 1, node)
+	irq_alloc_descs(-1, 1, 1, node)
 
 #define irq_alloc_desc_at(at, node)		\
 	irq_alloc_descs(at, at, 1, node)
@@ -937,7 +937,7 @@ int __devm_irq_alloc_descs(struct device
 	__devm_irq_alloc_descs(dev, irq, from, cnt, node, THIS_MODULE, NULL)
 
 #define devm_irq_alloc_desc(dev, node)				\
-	devm_irq_alloc_descs(dev, -1, 0, 1, node)
+	devm_irq_alloc_descs(dev, -1, 1, 1, node)
 
 #define devm_irq_alloc_desc_at(dev, at, node)			\
 	devm_irq_alloc_descs(dev, at, at, 1, node)


