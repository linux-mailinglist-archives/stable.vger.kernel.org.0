Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D598015C2AA
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgBMP3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:29:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729690AbgBMP3P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:29:15 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC44424688;
        Thu, 13 Feb 2020 15:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607755;
        bh=q8XtGX2CbdDm3oYTtQ6OZ88EQxl5iLM35Nkg4DPXLVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+zg2uNUgRRkzmipCzVv+iVIh2Nd50nYkrmEFAngVvjelZm+uOx4Te8ZsTDpKBJZ3
         Lqjps/b9NjKM1TS1NAFWoIwZgETsGr+WtlXr4M8/XSvTrg1Wq5vB51WWwfBDy+v545
         rGuH7Q7FUGGBMTBmtTCZGM0eXrwVbO5svw6AvPSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.5 090/120] KVM: arm64: Treat emulated TVAL TimerValue as a signed 32-bit integer
Date:   Thu, 13 Feb 2020 07:21:26 -0800
Message-Id: <20200213151931.495371546@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

commit 4a267aa707953a9a73d1f5dc7f894dd9024a92be upstream.

According to the ARM ARM, registers CNT{P,V}_TVAL_EL0 have bits [63:32]
RES0 [1]. When reading the register, the value is truncated to the least
significant 32 bits [2], and on writes, TimerValue is treated as a signed
32-bit integer [1, 2].

When the guest behaves correctly and writes 32-bit values, treating TVAL
as an unsigned 64 bit register works as expected. However, things start
to break down when the guest writes larger values, because
(u64)0x1_ffff_ffff = 8589934591. but (s32)0x1_ffff_ffff = -1, and the
former will cause the timer interrupt to be asserted in the future, but
the latter will cause it to be asserted now.  Let's treat TVAL as a
signed 32-bit register on writes, to match the behaviour described in
the architecture, and the behaviour experimentally exhibited by the
virtual timer on a non-vhe host.

[1] Arm DDI 0487E.a, section D13.8.18
[2] Arm DDI 0487E.a, section D11.2.4

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
[maz: replaced the read-side mask with lower_32_bits]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Fixes: 8fa761624871 ("KVM: arm/arm64: arch_timer: Fix CNTP_TVAL calculation")
Link: https://lore.kernel.org/r/20200127103652.2326-1-alexandru.elisei@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/arm/arch_timer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -805,6 +805,7 @@ static u64 kvm_arm_timer_read(struct kvm
 	switch (treg) {
 	case TIMER_REG_TVAL:
 		val = timer->cnt_cval - kvm_phys_timer_read() + timer->cntvoff;
+		val &= lower_32_bits(val);
 		break;
 
 	case TIMER_REG_CTL:
@@ -850,7 +851,7 @@ static void kvm_arm_timer_write(struct k
 {
 	switch (treg) {
 	case TIMER_REG_TVAL:
-		timer->cnt_cval = kvm_phys_timer_read() - timer->cntvoff + val;
+		timer->cnt_cval = kvm_phys_timer_read() - timer->cntvoff + (s32)val;
 		break;
 
 	case TIMER_REG_CTL:


