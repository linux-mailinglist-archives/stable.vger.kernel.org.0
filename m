Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 324B0E657D
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbfJ0VCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbfJ0VCj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:02:39 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A0162064A;
        Sun, 27 Oct 2019 21:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210157;
        bh=JAjNnovaKiGZ0JEZqWC//3IDhdNyQTZW3xqY1GsT6Hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUeNj7ki8KBilcan/kdBsFghy+Cne3mI1GaLpvYOwAv7c2GTT7sEob0n0lv1JPG+f
         kLaOcFS+VehQmjmHMmOkudEeytoQprF5a6nrZr4TmIdk/AWfNKWPjO2+7/pnaSyOP5
         vyfrQo6hYVcxtKK9QWSEhpqywKbHXoIkDxDJ0Oxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Zhuo <mengzhuo1203@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 11/41] MIPS: elf_hwcap: Export userspace ASEs
Date:   Sun, 27 Oct 2019 22:00:49 +0100
Message-Id: <20191027203108.951999877@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203056.220821342@linuxfoundation.org>
References: <20191027203056.220821342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 38dffe1e4dde1d3174fdce09d67370412843ebb5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/uapi/asm/hwcap.h | 11 +++++++++++
 arch/mips/kernel/cpu-probe.c       | 25 +++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/arch/mips/include/uapi/asm/hwcap.h b/arch/mips/include/uapi/asm/hwcap.h
index c7484a7ca686d..2b6f8d569d00f 100644
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
index ee71bda53d4e6..3903737e08cc8 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1540,6 +1540,31 @@ void cpu_probe(void)
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
+	if (cpu_has_loongson_mmi)
+		elf_hwcap |= HWCAP_LOONGSON_MMI;
+
+	if (cpu_has_loongson_ext)
+		elf_hwcap |= HWCAP_LOONGSON_EXT;
+
+
 	cpu_probe_vmbits(c);
 
 #ifdef CONFIG_64BIT
-- 
2.20.1



