Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6F644B87B
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344987AbhKIWoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:44:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345148AbhKIWlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:41:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2090161B3D;
        Tue,  9 Nov 2021 22:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496636;
        bh=T8Xd1nsfnBiyD8c1nofywRIz1BrHf431p4/cAfcbR4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVNwmIgWEdkPMdZS0LEnD2Gk0Fml2bFzefZg6HMDZDw4DT8sTMlOqQy3wbx9899Fx
         ZiKWcZiJaZYRn6RNe7aWn3myXaHw3iJaFVaCDocFjEnaAt5Ac2l2JXGLY8TYzH6vcu
         fCR6BfqKAT1ee3QWsULpTDms7mzVcD+ouGgsSz4jaK51AGXCko9jl/Q3hXIr6wDqhl
         nR8V7n1PpmtWQyLBQo0XjGfFzxjvZUtHVgGv3Fs9w66PJ1B9BssXUOENvH6XnNMqex
         FyJZGm/9CCudkS87/I9F+2P5yrX9WEh+At8UFkcx3UxSrrCvQMgahsC86lruVcKvIm
         Ay+aUtjmjlqyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-mips@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, Ralf@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: [PATCH AUTOSEL 4.14 09/14] MIPS: sni: Fix the build
Date:   Tue,  9 Nov 2021 17:23:38 -0500
Message-Id: <20211109222343.1235902-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222343.1235902-1-sashal@kernel.org>
References: <20211109222343.1235902-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c91cf42f61dc77b289784ea7b15a8531defa41c0 ]

This patch fixes the following gcc 10 build error:

arch/mips/sni/time.c: In function ‘a20r_set_periodic’:
arch/mips/sni/time.c:15:26: error: unsigned conversion from ‘int’ to ‘u8’ {aka ‘volatile unsigned char’} changes value from ‘576’ to ‘64’ [-Werror=overflow]
   15 | #define SNI_COUNTER0_DIV ((SNI_CLOCK_TICK_RATE / SNI_COUNTER2_DIV) / HZ)
      |                          ^
arch/mips/sni/time.c:21:45: note: in expansion of macro ‘SNI_COUNTER0_DIV’
   21 |  *(volatile u8 *)(A20R_PT_CLOCK_BASE + 0) = SNI_COUNTER0_DIV;
      |                                             ^~~~~~~~~~~~~~~~

Cc: linux-mips@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/sni/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/sni/time.c b/arch/mips/sni/time.c
index 0eb7d1e8821be..d741e24a21879 100644
--- a/arch/mips/sni/time.c
+++ b/arch/mips/sni/time.c
@@ -18,14 +18,14 @@ static int a20r_set_periodic(struct clock_event_device *evt)
 {
 	*(volatile u8 *)(A20R_PT_CLOCK_BASE + 12) = 0x34;
 	wmb();
-	*(volatile u8 *)(A20R_PT_CLOCK_BASE + 0) = SNI_COUNTER0_DIV;
+	*(volatile u8 *)(A20R_PT_CLOCK_BASE + 0) = SNI_COUNTER0_DIV & 0xff;
 	wmb();
 	*(volatile u8 *)(A20R_PT_CLOCK_BASE + 0) = SNI_COUNTER0_DIV >> 8;
 	wmb();
 
 	*(volatile u8 *)(A20R_PT_CLOCK_BASE + 12) = 0xb4;
 	wmb();
-	*(volatile u8 *)(A20R_PT_CLOCK_BASE + 8) = SNI_COUNTER2_DIV;
+	*(volatile u8 *)(A20R_PT_CLOCK_BASE + 8) = SNI_COUNTER2_DIV & 0xff;
 	wmb();
 	*(volatile u8 *)(A20R_PT_CLOCK_BASE + 8) = SNI_COUNTER2_DIV >> 8;
 	wmb();
-- 
2.33.0

