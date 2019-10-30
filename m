Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 286D2EA119
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfJ3P5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728355AbfJ3P5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:57:48 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF9B52067D;
        Wed, 30 Oct 2019 15:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572451067;
        bh=1X6i7lR6+B7BxUJpAHRSlPaRhmFHYsGGR9wrl7CzAA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgSi1GqCW2pM7mpDIzylaSujLgwpvivFy5htd8KK63j39uyGhvjS3Ah0W/+j1ujAN
         8BAl49R0rf4ADnLA3248ZG6Y/varrFSSqSsi2rDI+9/t3zkkjDrNxVx9eN8OWdD03Z
         ddl3zGglnKUR+KNtySP1WeRkXuQ54kDtMQCiDagI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonas Gorski <jonas.gorski@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Burton <paulburton@kernel.org>,
        linux-mips@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 17/18] MIPS: bmips: mark exception vectors as char arrays
Date:   Wed, 30 Oct 2019 11:56:59 -0400
Message-Id: <20191030155700.10748-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155700.10748-1-sashal@kernel.org>
References: <20191030155700.10748-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit e4f5cb1a9b27c0f94ef4f5a0178a3fde2d3d0e9e ]

The vectors span more than one byte, so mark them as arrays.

Fixes the following build error when building when using GCC 8.3:

In file included from ./include/linux/string.h:19,
                 from ./include/linux/bitmap.h:9,
                 from ./include/linux/cpumask.h:12,
                 from ./arch/mips/include/asm/processor.h:15,
                 from ./arch/mips/include/asm/thread_info.h:16,
                 from ./include/linux/thread_info.h:38,
                 from ./include/asm-generic/preempt.h:5,
                 from ./arch/mips/include/generated/asm/preempt.h:1,
                 from ./include/linux/preempt.h:81,
                 from ./include/linux/spinlock.h:51,
                 from ./include/linux/mmzone.h:8,
                 from ./include/linux/bootmem.h:8,
                 from arch/mips/bcm63xx/prom.c:10:
arch/mips/bcm63xx/prom.c: In function 'prom_init':
./arch/mips/include/asm/string.h:162:11: error: '__builtin_memcpy' forming offset [2, 32] is out of the bounds [0, 1] of object 'bmips_smp_movevec' with type 'char' [-Werror=array-bounds]
   __ret = __builtin_memcpy((dst), (src), __len); \
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/mips/bcm63xx/prom.c:97:3: note: in expansion of macro 'memcpy'
   memcpy((void *)0xa0000200, &bmips_smp_movevec, 0x20);
   ^~~~~~
In file included from arch/mips/bcm63xx/prom.c:14:
./arch/mips/include/asm/bmips.h:80:13: note: 'bmips_smp_movevec' declared here
 extern char bmips_smp_movevec;

Fixes: 18a1eef92dcd ("MIPS: BMIPS: Introduce bmips.h")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/bcm63xx/prom.c      |  2 +-
 arch/mips/include/asm/bmips.h | 10 +++++-----
 arch/mips/kernel/smp-bmips.c  |  8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/mips/bcm63xx/prom.c b/arch/mips/bcm63xx/prom.c
index 7019e2967009e..bbbf8057565b2 100644
--- a/arch/mips/bcm63xx/prom.c
+++ b/arch/mips/bcm63xx/prom.c
@@ -84,7 +84,7 @@ void __init prom_init(void)
 		 * Here we will start up CPU1 in the background and ask it to
 		 * reconfigure itself then go back to sleep.
 		 */
-		memcpy((void *)0xa0000200, &bmips_smp_movevec, 0x20);
+		memcpy((void *)0xa0000200, bmips_smp_movevec, 0x20);
 		__sync();
 		set_c0_cause(C_SW0);
 		cpumask_set_cpu(1, &bmips_booted_mask);
diff --git a/arch/mips/include/asm/bmips.h b/arch/mips/include/asm/bmips.h
index a92aee7b977ac..23f55af7d6bad 100644
--- a/arch/mips/include/asm/bmips.h
+++ b/arch/mips/include/asm/bmips.h
@@ -75,11 +75,11 @@ static inline int register_bmips_smp_ops(void)
 #endif
 }
 
-extern char bmips_reset_nmi_vec;
-extern char bmips_reset_nmi_vec_end;
-extern char bmips_smp_movevec;
-extern char bmips_smp_int_vec;
-extern char bmips_smp_int_vec_end;
+extern char bmips_reset_nmi_vec[];
+extern char bmips_reset_nmi_vec_end[];
+extern char bmips_smp_movevec[];
+extern char bmips_smp_int_vec[];
+extern char bmips_smp_int_vec_end[];
 
 extern int bmips_smp_enabled;
 extern int bmips_cpu_offset;
diff --git a/arch/mips/kernel/smp-bmips.c b/arch/mips/kernel/smp-bmips.c
index d4a293b68249b..416d53f587e7c 100644
--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -453,10 +453,10 @@ static void bmips_wr_vec(unsigned long dst, char *start, char *end)
 
 static inline void bmips_nmi_handler_setup(void)
 {
-	bmips_wr_vec(BMIPS_NMI_RESET_VEC, &bmips_reset_nmi_vec,
-		&bmips_reset_nmi_vec_end);
-	bmips_wr_vec(BMIPS_WARM_RESTART_VEC, &bmips_smp_int_vec,
-		&bmips_smp_int_vec_end);
+	bmips_wr_vec(BMIPS_NMI_RESET_VEC, bmips_reset_nmi_vec,
+		bmips_reset_nmi_vec_end);
+	bmips_wr_vec(BMIPS_WARM_RESTART_VEC, bmips_smp_int_vec,
+		bmips_smp_int_vec_end);
 }
 
 struct reset_vec_info {
-- 
2.20.1

