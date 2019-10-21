Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 903BBDF3A2
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 18:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbfJUQvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 12:51:10 -0400
Received: from forward101p.mail.yandex.net ([77.88.28.101]:43883 "EHLO
        forward101p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbfJUQvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 12:51:10 -0400
Received: from forward102q.mail.yandex.net (forward102q.mail.yandex.net [IPv6:2a02:6b8:c0e:1ba:0:640:516:4e7d])
        by forward101p.mail.yandex.net (Yandex) with ESMTP id 893EC328124A
        for <stable@vger.kernel.org>; Mon, 21 Oct 2019 19:51:06 +0300 (MSK)
Received: from mxback10q.mail.yandex.net (mxback10q.mail.yandex.net [IPv6:2a02:6b8:c0e:1b4:0:640:b6ef:cb3])
        by forward102q.mail.yandex.net (Yandex) with ESMTP id 85C3E7F2001E
        for <stable@vger.kernel.org>; Mon, 21 Oct 2019 19:51:06 +0300 (MSK)
Received: from vla3-2bcfd5e94671.qloud-c.yandex.net (vla3-2bcfd5e94671.qloud-c.yandex.net [2a02:6b8:c15:350f:0:640:2bcf:d5e9])
        by mxback10q.mail.yandex.net (nwsmtp/Yandex) with ESMTP id rrgLESFACT-p6ZmkE7v;
        Mon, 21 Oct 2019 19:51:06 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1571676666;
        bh=lNMu0HoF3AzDUf45xlQlx2Z+r22j1qd85TVi6i+sCzE=;
        h=In-Reply-To:Subject:To:From:Message-Id:Cc:References:Date;
        b=F9EuT3ziS+Tq+BLyNVEJhn23pgSVau9wwl1HYIZCN1FDPyLjFMAcxLXnLFOJPRe4M
         RJWDNu/SaiZSZtk7UyleR6NR+KO7wGD8qsQ1Yo2FI2TbwdsbL4sIBd782FDvbTvf08
         1znFXRHoIijjF/o0kHjvB9yWGOkbQ7XZ6G9YISpI=
Authentication-Results: mxback10q.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by vla3-2bcfd5e94671.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id rut2FNHrRJ-p1WSTjfe;
        Mon, 21 Oct 2019 19:51:04 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     stable@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 4.9,2/2] MIPS: elf_hwcap: Export userspace ASEs
Date:   Tue, 22 Oct 2019 00:49:56 +0800
Message-Id: <20191021164956.1731-7-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021164956.1731-1-jiaxun.yang@flygoat.com>
References: <20191021164956.1731-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upsteam commit: 38dffe1e4dde1d3174fdce09d67370412843ebb5

A Golang developer reported MIPS hwcap isn't reflecting instructions
that the processor actually supported so programs can't apply optimized
code at runtime.

Thus we export the ASEs that can be used in userspace programs.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: <stable@vger.kernel.org> # 4.9
---
 arch/mips/include/uapi/asm/hwcap.h | 11 ++++++++++
 arch/mips/kernel/cpu-probe.c       | 33 ++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/mips/include/uapi/asm/hwcap.h b/arch/mips/include/uapi/asm/hwcap.h
index c7484a7ca686..2b6f8d569d00 100644
--- a/arch/mips/include/uapi/asm/hwcap.h
+++ b/arch/mips/include/uapi/asm/hwcap.h
@@ -4,5 +4,16 @@
 /* HWCAP flags */
 #define HWCAP_MIPS_R6		(1 << 0)
 #define HWCAP_MIPS_MSA		(1 << 1)
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
index 0a7b3e513650..1a1ab0a78ac0 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -2055,6 +2055,39 @@ void cpu_probe(void)
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
+	if (cpu_has_loongson_mmi)
+		elf_hwcap |= HWCAP_LOONGSON_MMI;
+
+	if (cpu_has_loongson_mmi)
+		elf_hwcap |= HWCAP_LOONGSON_CAM;
+
+	if (cpu_has_loongson_ext)
+		elf_hwcap |= HWCAP_LOONGSON_EXT;
+
+	if (cpu_has_loongson_ext)
+		elf_hwcap |= HWCAP_LOONGSON_EXT2;
+
 	if (cpu_has_vz)
 		cpu_probe_vz(c);
 
-- 
2.23.0

