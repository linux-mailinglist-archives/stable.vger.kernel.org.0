Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF9BFA5C3
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfKMCYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:24:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:40186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728062AbfKMBv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:51:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDF8920674;
        Wed, 13 Nov 2019 01:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609915;
        bh=mvmcZdrkG5dSBFb2qDk8NGuPqozB3u6Kci68/K4eDoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uq9pzFe8jx+JgAn9zRSWpgOiwrXYBbqW0PeLTVXonbdPEWAAc9EkWt/uyOISA5RR7
         TTyBCpykvAmt2bis8D9rESZT6h0mSOvg96T0FW/RFGMDmWLSLUz5PUKsbPFQaPhAm5
         uBxUxnt+938pGgYsGI8bcan1CPrc5u/SjTjN8M6w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 064/209] clocksource/drivers/sh_cmt: Fixup for 64-bit machines
Date:   Tue, 12 Nov 2019 20:48:00 -0500
Message-Id: <20191113015025.9685-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[ Upstream commit 22627c6f3ed3d9d0df13eec3c831b08f8186c38e ]

When trying to use CMT for clockevents on R-Car gen3 SoCs, I noticed
that 'max_delta_ns' for the broadcast timer (CMT) was shown as 1000 in
/proc/timer_list. It turned out that when calculating it, the driver did
1 << 32 (causing what I think was undefined behavior) resulting in a zero
delta, later clamped to 1000 by cev_delta2ns(). The root cause turned out
to be that the driver abused *unsigned long* for the CMT register values
(which are 16/32-bit), so that the calculation of 'ch->max_match_value'
in sh_cmt_setup_channel() used the wrong branch. Using more proper 'u32'
instead fixed 'max_delta_ns' and even fixed the switching an active
clocksource to CMT (which caused the system to turn non-interactive
before).

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/sh_cmt.c | 72 +++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 39 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index bbbf37c471a39..49302086f36fd 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -78,18 +78,17 @@ struct sh_cmt_info {
 	unsigned int channels_mask;
 
 	unsigned long width; /* 16 or 32 bit version of hardware block */
-	unsigned long overflow_bit;
-	unsigned long clear_bits;
+	u32 overflow_bit;
+	u32 clear_bits;
 
 	/* callbacks for CMSTR and CMCSR access */
-	unsigned long (*read_control)(void __iomem *base, unsigned long offs);
+	u32 (*read_control)(void __iomem *base, unsigned long offs);
 	void (*write_control)(void __iomem *base, unsigned long offs,
-			      unsigned long value);
+			      u32 value);
 
 	/* callbacks for CMCNT and CMCOR access */
-	unsigned long (*read_count)(void __iomem *base, unsigned long offs);
-	void (*write_count)(void __iomem *base, unsigned long offs,
-			    unsigned long value);
+	u32 (*read_count)(void __iomem *base, unsigned long offs);
+	void (*write_count)(void __iomem *base, unsigned long offs, u32 value);
 };
 
 struct sh_cmt_channel {
@@ -103,9 +102,9 @@ struct sh_cmt_channel {
 
 	unsigned int timer_bit;
 	unsigned long flags;
-	unsigned long match_value;
-	unsigned long next_match_value;
-	unsigned long max_match_value;
+	u32 match_value;
+	u32 next_match_value;
+	u32 max_match_value;
 	raw_spinlock_t lock;
 	struct clock_event_device ced;
 	struct clocksource cs;
@@ -160,24 +159,22 @@ struct sh_cmt_device {
 #define SH_CMT32_CMCSR_CKS_RCLK1	(7 << 0)
 #define SH_CMT32_CMCSR_CKS_MASK		(7 << 0)
 
-static unsigned long sh_cmt_read16(void __iomem *base, unsigned long offs)
+static u32 sh_cmt_read16(void __iomem *base, unsigned long offs)
 {
 	return ioread16(base + (offs << 1));
 }
 
-static unsigned long sh_cmt_read32(void __iomem *base, unsigned long offs)
+static u32 sh_cmt_read32(void __iomem *base, unsigned long offs)
 {
 	return ioread32(base + (offs << 2));
 }
 
-static void sh_cmt_write16(void __iomem *base, unsigned long offs,
-			   unsigned long value)
+static void sh_cmt_write16(void __iomem *base, unsigned long offs, u32 value)
 {
 	iowrite16(value, base + (offs << 1));
 }
 
-static void sh_cmt_write32(void __iomem *base, unsigned long offs,
-			   unsigned long value)
+static void sh_cmt_write32(void __iomem *base, unsigned long offs, u32 value)
 {
 	iowrite32(value, base + (offs << 2));
 }
@@ -242,7 +239,7 @@ static const struct sh_cmt_info sh_cmt_info[] = {
 #define CMCNT 1 /* channel register */
 #define CMCOR 2 /* channel register */
 
-static inline unsigned long sh_cmt_read_cmstr(struct sh_cmt_channel *ch)
+static inline u32 sh_cmt_read_cmstr(struct sh_cmt_channel *ch)
 {
 	if (ch->iostart)
 		return ch->cmt->info->read_control(ch->iostart, 0);
@@ -250,8 +247,7 @@ static inline unsigned long sh_cmt_read_cmstr(struct sh_cmt_channel *ch)
 		return ch->cmt->info->read_control(ch->cmt->mapbase, 0);
 }
 
-static inline void sh_cmt_write_cmstr(struct sh_cmt_channel *ch,
-				      unsigned long value)
+static inline void sh_cmt_write_cmstr(struct sh_cmt_channel *ch, u32 value)
 {
 	if (ch->iostart)
 		ch->cmt->info->write_control(ch->iostart, 0, value);
@@ -259,39 +255,35 @@ static inline void sh_cmt_write_cmstr(struct sh_cmt_channel *ch,
 		ch->cmt->info->write_control(ch->cmt->mapbase, 0, value);
 }
 
-static inline unsigned long sh_cmt_read_cmcsr(struct sh_cmt_channel *ch)
+static inline u32 sh_cmt_read_cmcsr(struct sh_cmt_channel *ch)
 {
 	return ch->cmt->info->read_control(ch->ioctrl, CMCSR);
 }
 
-static inline void sh_cmt_write_cmcsr(struct sh_cmt_channel *ch,
-				      unsigned long value)
+static inline void sh_cmt_write_cmcsr(struct sh_cmt_channel *ch, u32 value)
 {
 	ch->cmt->info->write_control(ch->ioctrl, CMCSR, value);
 }
 
-static inline unsigned long sh_cmt_read_cmcnt(struct sh_cmt_channel *ch)
+static inline u32 sh_cmt_read_cmcnt(struct sh_cmt_channel *ch)
 {
 	return ch->cmt->info->read_count(ch->ioctrl, CMCNT);
 }
 
-static inline void sh_cmt_write_cmcnt(struct sh_cmt_channel *ch,
-				      unsigned long value)
+static inline void sh_cmt_write_cmcnt(struct sh_cmt_channel *ch, u32 value)
 {
 	ch->cmt->info->write_count(ch->ioctrl, CMCNT, value);
 }
 
-static inline void sh_cmt_write_cmcor(struct sh_cmt_channel *ch,
-				      unsigned long value)
+static inline void sh_cmt_write_cmcor(struct sh_cmt_channel *ch, u32 value)
 {
 	ch->cmt->info->write_count(ch->ioctrl, CMCOR, value);
 }
 
-static unsigned long sh_cmt_get_counter(struct sh_cmt_channel *ch,
-					int *has_wrapped)
+static u32 sh_cmt_get_counter(struct sh_cmt_channel *ch, u32 *has_wrapped)
 {
-	unsigned long v1, v2, v3;
-	int o1, o2;
+	u32 v1, v2, v3;
+	u32 o1, o2;
 
 	o1 = sh_cmt_read_cmcsr(ch) & ch->cmt->info->overflow_bit;
 
@@ -311,7 +303,8 @@ static unsigned long sh_cmt_get_counter(struct sh_cmt_channel *ch,
 
 static void sh_cmt_start_stop_ch(struct sh_cmt_channel *ch, int start)
 {
-	unsigned long flags, value;
+	unsigned long flags;
+	u32 value;
 
 	/* start stop register shared by multiple timer channels */
 	raw_spin_lock_irqsave(&ch->cmt->lock, flags);
@@ -418,11 +411,11 @@ static void sh_cmt_disable(struct sh_cmt_channel *ch)
 static void sh_cmt_clock_event_program_verify(struct sh_cmt_channel *ch,
 					      int absolute)
 {
-	unsigned long new_match;
-	unsigned long value = ch->next_match_value;
-	unsigned long delay = 0;
-	unsigned long now = 0;
-	int has_wrapped;
+	u32 value = ch->next_match_value;
+	u32 new_match;
+	u32 delay = 0;
+	u32 now = 0;
+	u32 has_wrapped;
 
 	now = sh_cmt_get_counter(ch, &has_wrapped);
 	ch->flags |= FLAG_REPROGRAM; /* force reprogram */
@@ -619,9 +612,10 @@ static struct sh_cmt_channel *cs_to_sh_cmt(struct clocksource *cs)
 static u64 sh_cmt_clocksource_read(struct clocksource *cs)
 {
 	struct sh_cmt_channel *ch = cs_to_sh_cmt(cs);
-	unsigned long flags, raw;
+	unsigned long flags;
 	unsigned long value;
-	int has_wrapped;
+	u32 has_wrapped;
+	u32 raw;
 
 	raw_spin_lock_irqsave(&ch->lock, flags);
 	value = ch->total_cycles;
-- 
2.20.1

