Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF28E9C32
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 14:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfJ3NXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 09:23:41 -0400
Received: from forward105p.mail.yandex.net ([77.88.28.108]:34694 "EHLO
        forward105p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726119AbfJ3NXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Oct 2019 09:23:41 -0400
Received: from mxback29j.mail.yandex.net (mxback29j.mail.yandex.net [IPv6:2a02:6b8:0:1619::229])
        by forward105p.mail.yandex.net (Yandex) with ESMTP id 11F1A4D41EBE;
        Wed, 30 Oct 2019 16:23:37 +0300 (MSK)
Received: from myt3-372f9bf9bd7d.qloud-c.yandex.net (myt3-372f9bf9bd7d.qloud-c.yandex.net [2a02:6b8:c12:70e:0:640:372f:9bf9])
        by mxback29j.mail.yandex.net (nwsmtp/Yandex) with ESMTP id Nvq3btGlO5-NaXGS7fq;
        Wed, 30 Oct 2019 16:23:37 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1572441817;
        bh=KfhJ/UE2KV/nn9miMf2ABXtPoXMVwWg7U6oyL3DH0NU=;
        h=In-Reply-To:Subject:To:From:Cc:References:Date:Message-Id;
        b=ZjufzQ/8KUWuOd3CGdXfYSs7qBX/sDr+amGrUMzFuSVZmdvU5L+xYQ+hLqR6BUUM0
         4ZrwXNmpCTm2gNtkimIOgYUedmBjtC7J18pRH0o9NSnm05jV68sLtSboppxYnKKf6s
         AMnki7zuoo+xWZzuwtnW0TdnVxE0JbtapkbADHv4=
Authentication-Results: mxback29j.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by myt3-372f9bf9bd7d.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id TyIYfkmJey-NWViSBGq;
        Wed, 30 Oct 2019 16:23:34 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] MIPS: elf_hwcap: Export userspace ASEs
Date:   Wed, 30 Oct 2019 21:23:24 +0800
Message-Id: <20191030132324.15800-1-jiaxun.yang@flygoat.com>
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
 
