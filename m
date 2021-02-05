Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2390F311195
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhBESOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 13:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbhBESNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 13:13:22 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADECC06174A;
        Fri,  5 Feb 2021 11:55:05 -0800 (PST)
Date:   Fri, 05 Feb 2021 19:55:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612554902;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=60UK+BRAgNDrSuMPNEtATYvdu08y1VykIANnMVc0sR4=;
        b=VnlHOjM/5qE4oE187BCCni3DZ+R4TFjxdC+rJA+9b0pyIMnSPcJSljjxdX7DSQmMyeJcK8
        eHV1RUOcf7LAHYXx5X3h+9PpELhTPr8l2aw7W0Sm14/DNnKL2o/eCV8gFL536QzJrUMqZY
        fyeOFKo8MTE90kg3JslkeF6qhxEETEbRc+9hB7p0Za7XiQ18KS9KCZ/omiaqT4bpl0PQWj
        QUhgrSaJaa5OX3LrhNik+H9zuElzqDhopXoUW7uliLTUA1hTw0vw1hOuaZ/MTeealsMvdO
        P/LjFZc1eg/ESfCSysYbzDkaZ/l8IjWCUCSKZakiv9Y44YKrbDlKj9Drc14O6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612554902;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=60UK+BRAgNDrSuMPNEtATYvdu08y1VykIANnMVc0sR4=;
        b=mRU0LC6zf7KNT4n+R66RjplHopgfkXa+XuyTrQKxZPOZNTDBOl6tkRvppYF/0EWarPFGOd
        btQDdA7IlUB5ELAw==
From:   "tip-bot2 for Hans de Goede" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] genirq: Prevent [devm_]irq_alloc_desc from returning irq 0
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org
In-Reply-To: <20201221185647.226146-1-hdegoede@redhat.com>
References: <20201221185647.226146-1-hdegoede@redhat.com>
MIME-Version: 1.0
Message-ID: <161255490170.23325.127304907450199511.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     4c7bcb51ae25f79e3733982e5d0cd8ce8640ddfc
Gitweb:        https://git.kernel.org/tip/4c7bcb51ae25f79e3733982e5d0cd8ce8640ddfc
Author:        Hans de Goede <hdegoede@redhat.com>
AuthorDate:    Mon, 21 Dec 2020 19:56:47 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 05 Feb 2021 20:48:28 +01:00

genirq: Prevent [devm_]irq_alloc_desc from returning irq 0

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
---
 include/linux/irq.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 4aeb1c4..2efde6a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -928,7 +928,7 @@ int __devm_irq_alloc_descs(struct device *dev, int irq, unsigned int from,
 	__irq_alloc_descs(irq, from, cnt, node, THIS_MODULE, NULL)
 
 #define irq_alloc_desc(node)			\
-	irq_alloc_descs(-1, 0, 1, node)
+	irq_alloc_descs(-1, 1, 1, node)
 
 #define irq_alloc_desc_at(at, node)		\
 	irq_alloc_descs(at, at, 1, node)
@@ -943,7 +943,7 @@ int __devm_irq_alloc_descs(struct device *dev, int irq, unsigned int from,
 	__devm_irq_alloc_descs(dev, irq, from, cnt, node, THIS_MODULE, NULL)
 
 #define devm_irq_alloc_desc(dev, node)				\
-	devm_irq_alloc_descs(dev, -1, 0, 1, node)
+	devm_irq_alloc_descs(dev, -1, 1, 1, node)
 
 #define devm_irq_alloc_desc_at(dev, at, node)			\
 	devm_irq_alloc_descs(dev, at, at, 1, node)
