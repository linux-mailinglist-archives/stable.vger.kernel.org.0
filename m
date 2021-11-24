Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D271F45BA79
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbhKXMLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:11:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241644AbhKXMJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:09:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5053D610A8;
        Wed, 24 Nov 2021 12:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755533;
        bh=iM3CgcmJpYI1BYV4arFIc7UHGjgyPXrZXuVgO3cUedw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkAFHh8K5+4QtB+a7ys57lqerI0uo7e4qtf52j0osVbCKvQKW0/6OT/5W5s8qkv2Q
         J4nTsj93Y6PUvezP0KexrSiAoZbj6cITF5csm55wG4k+K3NclyeAK3IrUECfS0KQRf
         KXUBxk5zzE05ZqVYrAkZWJZW9bhKhXLwbnK8cpK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-mips@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 123/162] MIPS: sni: Fix the build
Date:   Wed, 24 Nov 2021 12:57:06 +0100
Message-Id: <20211124115702.286177563@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index fb4b3520cdc61..d72dd0d2ff595 100644
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



