Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F33E1F42
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 17:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390924AbfJWP02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 11:26:28 -0400
Received: from forward106j.mail.yandex.net ([5.45.198.249]:38850 "EHLO
        forward106j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732725AbfJWP02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 11:26:28 -0400
Received: from mxback27o.mail.yandex.net (mxback27o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::78])
        by forward106j.mail.yandex.net (Yandex) with ESMTP id E05E611A07DB;
        Wed, 23 Oct 2019 18:26:25 +0300 (MSK)
Received: from sas1-e6a95a338f12.qloud-c.yandex.net (sas1-e6a95a338f12.qloud-c.yandex.net [2a02:6b8:c08:37a4:0:640:e6a9:5a33])
        by mxback27o.mail.yandex.net (nwsmtp/Yandex) with ESMTP id 2HHJc5qrXO-QP38MIjQ;
        Wed, 23 Oct 2019 18:26:25 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1571844385;
        bh=pXHgoFEZjIhQb6wtUSotGvV+HIzXvVjUqGHw8fCPev0=;
        h=Subject:To:From:Cc:Date:Message-Id;
        b=u+/IVuEhnzCVdq1vXEfZw6OMBYG/663au1LeoOd3cD0fFS7VoPpctMojVkXXsCzXb
         TuxoPX7gORVdPRk5+Vgzrpk7pa9kZLZaalN0sG18v9va1xNR5ZA0KIuJDxnDyBF4pl
         Ah9toa8pKyXk+GfZCwjnKl/732qUfKsfTjx8EVrI=
Authentication-Results: mxback27o.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by sas1-e6a95a338f12.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id U0vjoMzp4P-QEViFZBI;
        Wed, 23 Oct 2019 18:26:17 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     paul.burton@mips.com, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        stable@vger.kernel.org
Subject: [PATCH] MIPS: elf_hwcap: Export microMIPS and vz
Date:   Wed, 23 Oct 2019 23:25:51 +0800
Message-Id: <20191023152551.10535-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After further discussion with userland library develpoer,
we addressed another two ASEs that can be used runtimely in programs.

Export them in hwcap as well to benefit userspace programs.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: <stable@vger.kernel.org> # 4.4+
---
 arch/mips/include/uapi/asm/hwcap.h | 2 ++
 arch/mips/kernel/cpu-probe.c       | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/uapi/asm/hwcap.h b/arch/mips/include/uapi/asm/hwcap.h
index 1ade1daa4921..e1a9bac62149 100644
--- a/arch/mips/include/uapi/asm/hwcap.h
+++ b/arch/mips/include/uapi/asm/hwcap.h
@@ -17,5 +17,7 @@
 #define HWCAP_LOONGSON_MMI  (1 << 11)
 #define HWCAP_LOONGSON_EXT  (1 << 12)
 #define HWCAP_LOONGSON_EXT2 (1 << 13)
+#define HWCAP_MIPS_MICROMIPS (1 << 14)
+#define HWCAP_MIPS_VZ       (1 << 15)
 
 #endif /* _UAPI_ASM_HWCAP_H */
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index f521cbf934e7..11e853d88aae 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -2213,8 +2213,13 @@ void cpu_probe(void)
 	if (cpu_has_loongson_ext2)
 		elf_hwcap |= HWCAP_LOONGSON_EXT2;
 
-	if (cpu_has_vz)
+	if (cpu_has_mmips)
+		elf_hwcap |= HWCAP_MIPS_MICROMIPS;
+
+	if (cpu_has_vz) {
+		elf_hwcap |= HWCAP_MIPS_VZ;
 		cpu_probe_vz(c);
+	}
 
 	cpu_probe_vmbits(c);
 
-- 
2.23.0

