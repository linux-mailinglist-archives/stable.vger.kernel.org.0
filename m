Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16DD26B4F5
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727396AbgIOXem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:34:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727148AbgIOOgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:36:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BCCA223BE;
        Tue, 15 Sep 2020 14:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179984;
        bh=AVqPuBkTTjcguZkuosZqOamQYFdo3B3gnE6D204M4To=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c96cSIHKa/6dXwfGrozZUgmxKFyA0HBUL7+mnpiXsOR399HGTHkOPrEx+UGofsRtC
         LgsmoqGEkJEAWI9jvxJ//tWRZu0zC1H7rBa8l+yEkV4ds2ksp+yIqnE5eUsO8qKP6o
         xFRLX0p0yW91QQHKshBEQNJZ2Lgaz+Ti9+huZ46s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 063/177] MIPS: Loongson64: Do not override watch and ejtag feature
Date:   Tue, 15 Sep 2020 16:12:14 +0200
Message-Id: <20200915140656.652558424@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 433c1ca0d441ee0b88fdd83c84ee6d6d43080dcd ]

Do not override ejtag feature to 0 as Loongson 3A1000+ do have ejtag.
For watch, as KVM emulated CPU doesn't have watch feature, we should
not enable it unconditionally.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mach-loongson64/cpu-feature-overrides.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/mips/include/asm/mach-loongson64/cpu-feature-overrides.h b/arch/mips/include/asm/mach-loongson64/cpu-feature-overrides.h
index b6e9c99b85a52..eb181224eb4c4 100644
--- a/arch/mips/include/asm/mach-loongson64/cpu-feature-overrides.h
+++ b/arch/mips/include/asm/mach-loongson64/cpu-feature-overrides.h
@@ -26,7 +26,6 @@
 #define cpu_has_counter		1
 #define cpu_has_dc_aliases	(PAGE_SIZE < 0x4000)
 #define cpu_has_divec		0
-#define cpu_has_ejtag		0
 #define cpu_has_inclusive_pcaches	1
 #define cpu_has_llsc		1
 #define cpu_has_mcheck		0
@@ -42,7 +41,6 @@
 #define cpu_has_veic		0
 #define cpu_has_vint		0
 #define cpu_has_vtag_icache	0
-#define cpu_has_watch		1
 #define cpu_has_wsbh		1
 #define cpu_has_ic_fills_f_dc	1
 #define cpu_hwrena_impl_bits	0xc0000000
-- 
2.25.1



