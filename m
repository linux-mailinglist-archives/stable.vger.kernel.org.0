Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3BE6E9C33
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 14:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfJ3NXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 09:23:51 -0400
Received: from forward102p.mail.yandex.net ([77.88.28.102]:47761 "EHLO
        forward102p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726119AbfJ3NXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Oct 2019 09:23:51 -0400
Received: from mxback21g.mail.yandex.net (mxback21g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:321])
        by forward102p.mail.yandex.net (Yandex) with ESMTP id 3DDCA1D41E15;
        Wed, 30 Oct 2019 16:23:47 +0300 (MSK)
Received: from sas8-93a22d3a76f4.qloud-c.yandex.net (sas8-93a22d3a76f4.qloud-c.yandex.net [2a02:6b8:c1b:2988:0:640:93a2:2d3a])
        by mxback21g.mail.yandex.net (nwsmtp/Yandex) with ESMTP id uPlcrWIFet-NlrWnuoI;
        Wed, 30 Oct 2019 16:23:47 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1572441827;
        bh=KfhJ/UE2KV/nn9miMf2ABXtPoXMVwWg7U6oyL3DH0NU=;
        h=In-Reply-To:Subject:To:From:Cc:References:Date:Message-Id;
        b=dLU1W2iH9u8yDimQw9ntzPG8OdadZur+DHVnii86ISC3Y1zboWGLylgO9N3xugTPQ
         UqRlc9JPRxD1+W7pKb+eM5TKxk8TFxzBT7fXLm/UTHW7ADS4QnyzMOlMAEXJ49V6Sa
         MRV9agIR0x61FyZK2OY7raGAx7ewto9CgPh18ezw=
Authentication-Results: mxback21g.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by sas8-93a22d3a76f4.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id ZJ1N6fEznp-MiVmvGgF;
        Wed, 30 Oct 2019 16:23:02 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] MIPS: elf_hwcap: Export userspace ASEs
Date:   Wed, 30 Oct 2019 21:22:24 +0800
Message-Id: <20191030132224.15731-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030090214.GA628862@kroah.com>
References: <20191030090214.GA628862@kroah.com>
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

Reported-by: Meng Zhuo <mengzhuo1203@gmail.com>
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: linux-mips@vger.kernel.org
Cc: Paul Burton <paul.burton@mips.com>
Cc: <stable@vger.kernel.org> # 4.14+
Signed-off-by: Paul Burton <paul.burton@mips.com>
---
 arch/mips/include/uapi/asm/hwcap.h | 11 ++++++++++
 arch/mips/kernel/cpu-probe.c       | 33 ++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/mips/include/uapi/asm/hwcap.h b/arch/mips/include/uapi/asm/hwcap.h
index a2aba4b059e63..1ade1daa49210 100644
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
index c2eb392597bf6..f521cbf934e76 100644
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
 
