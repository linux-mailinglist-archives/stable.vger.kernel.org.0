Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B789D37C9C2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbhELQVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240014AbhELQQ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:16:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33C3761D67;
        Wed, 12 May 2021 15:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834192;
        bh=h1xEYbGRZj8V32Gf8SC2xsEOB47uOLaCUPpJUX7bZ68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2MMNFPHg2V6b2qWk0x4Vsbp9fN4axz1CZftTEA25IAhwm4i/2rGDChFnytrv9ok2
         V6QIEFCPE6qwoXS0wfJPisE1yojrEZ7llCeOhHTsCHLFxU+bf4FTKDMs/prdOqhOnV
         2Tt7PUVH4gquHQRBjnbjHMsi3BppY4qlrb1224e4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 410/601] MIPS: fix local_irq_{disable,enable} in asmmacro.h
Date:   Wed, 12 May 2021 16:48:07 +0200
Message-Id: <20210512144841.334037854@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Pei <huangpei@loongson.cn>

[ Upstream commit 05c4e2721d7af0df7bc1378a23712a0fd16947b5 ]

commit ba9196d2e005 ("MIPS: Make DIEI support as a config option")
use CPU_HAS_DIEI to indicate whether di/ei is implemented correctly,
without this patch, "local_irq_disable" from entry.S in 3A1000
(with buggy di/ei) lose protection of commit e97c5b609880 ("MIPS:
Make irqflags.h functions preempt-safe for non-mipsr2 cpus")

Fixes: ba9196d2e005 ("MIPS: Make DIEI support as a config option")
Signed-off-by: Huang Pei <huangpei@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/asmmacro.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/asmmacro.h b/arch/mips/include/asm/asmmacro.h
index 86f2323ebe6b..ca83ada7015f 100644
--- a/arch/mips/include/asm/asmmacro.h
+++ b/arch/mips/include/asm/asmmacro.h
@@ -44,8 +44,7 @@
 	.endm
 #endif
 
-#if defined(CONFIG_CPU_MIPSR2) || defined(CONFIG_CPU_MIPSR5) || \
-    defined(CONFIG_CPU_MIPSR6)
+#ifdef CONFIG_CPU_HAS_DIEI
 	.macro	local_irq_enable reg=t0
 	ei
 	irq_enable_hazard
-- 
2.30.2



