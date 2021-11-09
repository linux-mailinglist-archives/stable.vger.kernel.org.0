Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA5E44B5EE
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343510AbhKIWYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:24:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343535AbhKIWWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:22:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84ABF6137F;
        Tue,  9 Nov 2021 22:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496310;
        bh=mhSzMwWW4rI8F89tcktNvyzwyOgUJFo1iiLUthPJbbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7OrudC1G1qQEBZACs/FQXmIbUDm9G3O047AcG+UJznDnfOFBOXuG6DAqHAacRU8Q
         9jDYvcVCn8z9rmNxrbrs/g1Lj5zeoIhhivl05SEkpK1BGK3YaO6igb+pUaNSH5j+Wa
         kvxLxY7Ae6cFdh6QrLIt5/kXCuWti+fPsR4fgBgWG6BZWXJXUGMEuwmmT6WsV1AkvV
         r6oMFMniKWa5SeAILNxOXS5XZDKkfXQv/E4lGdzthqHTIdcuZAwebzGfB6PUyKyUcO
         6IyS8b6w0VPddQoAbEP09kjZHQ6gHcyxEzfUbDWrfz88VnndDlHRRRgOpzOsN672Sr
         iWJA6Z/q48p0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-mips@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, Ralf@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: [PATCH AUTOSEL 5.15 61/82] MIPS: sni: Fix the build
Date:   Tue,  9 Nov 2021 17:16:19 -0500
Message-Id: <20211109221641.1233217-61-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
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
index 240bb68ec2478..ff3ba7e778901 100644
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

