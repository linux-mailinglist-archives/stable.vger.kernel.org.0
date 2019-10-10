Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 039E2D2CC6
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 16:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfJJOqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 10:46:22 -0400
Received: from forward100o.mail.yandex.net ([37.140.190.180]:41235 "EHLO
        forward100o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726222AbfJJOqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 10:46:22 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Oct 2019 10:46:19 EDT
Received: from forward100q.mail.yandex.net (forward100q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb97])
        by forward100o.mail.yandex.net (Yandex) with ESMTP id CD53E4AC108C;
        Thu, 10 Oct 2019 17:40:14 +0300 (MSK)
Received: from mxback11q.mail.yandex.net (mxback11q.mail.yandex.net [IPv6:2a02:6b8:c0e:1b4:0:640:1f0c:10f2])
        by forward100q.mail.yandex.net (Yandex) with ESMTP id C8F257080010;
        Thu, 10 Oct 2019 17:40:14 +0300 (MSK)
Received: from vla3-11710f0f0dbd.qloud-c.yandex.net (vla3-11710f0f0dbd.qloud-c.yandex.net [2a02:6b8:c15:2584:0:640:1171:f0f])
        by mxback11q.mail.yandex.net (nwsmtp/Yandex) with ESMTP id jcBmc2PTK9-eECKUkkl;
        Thu, 10 Oct 2019 17:40:14 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1570718414;
        bh=ItG4PUK2mFQT3B+nOSpcLn8Q78SCtsVhq29/WQ2jmbY=;
        h=Subject:To:From:Cc:Date:Message-Id;
        b=Nw+nI/yoyCc3iy4yBFQkFzAzJ4/nfZ3tpNmo/XU1B00gP5hyVm5rdWfa6azYUv3tg
         5T+v+PZZUzEYa+JREJ6eip4ixzytbpFI1Wg1Xjimm5ljtAoskH2c6cli+wirJxVBjc
         kRgLWis7Wg3FO5PGo/5TZSpEyzUoh9NkHkPkE9is=
Authentication-Results: mxback11q.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by vla3-11710f0f0dbd.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id jkcnUXP3Wb-e8qa76XE;
        Thu, 10 Oct 2019 17:40:11 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Meng Zhou <mengzhuo1203@gmail.com>,
        Paul Burton <paul.burton@mips.com>, stable@vger.kernel.org
Subject: [PATCH] MIPS: elf_hwcap: Export userspace ASEs
Date:   Thu, 10 Oct 2019 22:39:40 +0800
Message-Id: <20191010143940.15725-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A Golang developer reported MIPS hwcap isn't reflecting instructions
that the processor actually supported so programs can't apply optimized
code at runtime.

Thus we export the ASEs that can be used in userspace programs.

Reported-by: Meng Zhou <mengzhuo1203@gmail.com>
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: linux-mips@vger.kernel.org
Cc: Paul Burton <paul.burton@mips.com>
Cc: <stable@vger.kernel.org> # 4.14+
---
 arch/mips/include/uapi/asm/hwcap.h | 11 ++++++++++
 arch/mips/kernel/cpu-probe.c       | 33 ++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/mips/include/uapi/asm/hwcap.h b/arch/mips/include/uapi/asm/hwcap.h
index a2aba4b059e6..1ade1daa4921 100644
--- a/arch/mips/include/uapi/asm/hwcap.h
+++ b/arch/mips/include/uapi/asm/hwcap.h
@@ -6,5 +6,16 @@
 #define HWCAP_MIPS_R6		(1 << 0)
 #define HWCAP_MIPS_MSA		(1 << 1)
 #define HWCAP_MIPS_CRC32	(1 << 2)
+#define HWCAP_MIPS_MIPS16	(1 << 3)
+#define HWCAP_MIPS_MDMX     (1 << 4)
+#define HWCAP_MIPS_MIPS3D   (1 << 5)
+#define HWCAP_MIPS_SMARTMIPS (1 << 6)
+#define HWCAP_MIPS_DSP      (1 << 7)
+#define HWCAP_MIPS_DSP2     (1 << 8)
+#define HWCAP_MIPS_DSP3     (1 << 9)
+#define HWCAP_MIPS_MIPS16E2 (1 << 10)
+#define HWCAP_LOONGSON_MMI  (1 << 11)
+#define HWCAP_LOONGSON_EXT  (1 << 12)
+#define HWCAP_LOONGSON_EXT2 (1 << 13)
 
 #endif /* _UAPI_ASM_HWCAP_H */
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index c2eb392597bf..f521cbf934e7 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -2180,6 +2180,39 @@ void cpu_probe(void)
 		elf_hwcap |= HWCAP_MIPS_MSA;
 	}
 
+	if (cpu_has_mips16)
+		elf_hwcap |= HWCAP_MIPS_MIPS16;
+
+	if (cpu_has_mdmx)
+		elf_hwcap |= HWCAP_MIPS_MDMX;
+
+	if (cpu_has_mips3d)
+		elf_hwcap |= HWCAP_MIPS_MIPS3D;
+
+	if (cpu_has_smartmips)
+		elf_hwcap |= HWCAP_MIPS_SMARTMIPS;
+
+	if (cpu_has_dsp)
+		elf_hwcap |= HWCAP_MIPS_DSP;
+
+	if (cpu_has_dsp2)
+		elf_hwcap |= HWCAP_MIPS_DSP2;
+
+	if (cpu_has_dsp3)
+		elf_hwcap |= HWCAP_MIPS_DSP3;
+
+	if (cpu_has_mips16e2)
+		elf_hwcap |= HWCAP_MIPS_MIPS16E2;
+
+	if (cpu_has_loongson_mmi)
+		elf_hwcap |= HWCAP_LOONGSON_MMI;
+
+	if (cpu_has_loongson_ext)
+		elf_hwcap |= HWCAP_LOONGSON_EXT;
+
+	if (cpu_has_loongson_ext2)
+		elf_hwcap |= HWCAP_LOONGSON_EXT2;
+
 	if (cpu_has_vz)
 		cpu_probe_vz(c);
 
-- 
2.23.0

