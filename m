Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4040249F294
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 05:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346076AbiA1EuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 23:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237235AbiA1EuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 23:50:14 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A99BC06173B
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 20:50:14 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id t32so4202177pgm.7
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 20:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FD5pKwU2Fwdg7X48mCrqr+jAVcD4ZyeHTAqc+k2RM+c=;
        b=B4CgcY0fEOxqhrw24tg4Q5GH/lXkTLByoWqfd2Mwf8j929EOPzS/1422VapoQYGodH
         FiWXBWuWdBxfetOk3EkoRKBcrlec3LK1FH+jmYGYDR6hzgHm1lSVh9D6Owdq7QIHpHF4
         V/Gqkvy0Yvn6ocSksO5aRQxpk6EnOid8UZRNNF/uJwaPk5n8bK+TTWfbz3OVnyLtmtVn
         BCah28BN9fVtVIbp1qia6BJ9wszMUcpZYRJdsmkyBLeGA00rcQa7DRgqN4fBglwrIFye
         4It2VtWQcF4fh06KHjEUe/lQ0af2DL76+nzrXJRYxAPuIX8NNJAR+ENw69J6e+sZEzY+
         nQDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FD5pKwU2Fwdg7X48mCrqr+jAVcD4ZyeHTAqc+k2RM+c=;
        b=nEg5t3xlBjCGTk9AUm3gErl+nzX8TMdRmxbsTYuJ9rqQBu0nD3ffaPJ9v+jN8pRAkH
         DszQZJj+Sq8x1IUQ4JLRvCmIw+tI1SOBnzmc3b1kg0jXxP38BFX/sFqxKlk34OMBxZno
         UG1KdJVJSGnh4QXhFezgrNm2QzEhDaIXpfMptlZdMFvyroEdSBiLc2M8bAgywwkWfNAX
         jmSbTGOvOBOTNJNAuhdg+pc4Y9GiUwrrf8Eh3jFsBMP36WW+E1uZntkC/E2okdvCWBTD
         y1Y3Fy9GXwzH2Zpw6p6mkZ4SJLTul/ZN8AqRy8WRQKgCw/bZcSVvD588iMT0a6E/Nv3I
         3p/A==
X-Gm-Message-State: AOAM530RpJmberFqjZ7cf0g9gPlozPb8KRV1445XvqVJPac3uQzQHZ6b
        lJlmpzqDgtHcRaDrd4/J/E/l9A==
X-Google-Smtp-Source: ABdhPJxsk7PAsAbzq8HVim93uXfpup+rKn0o1kD3wHiWk2p7hYt+rlgXyL4Lt/ufFIunBH/WWgYdMA==
X-Received: by 2002:a63:1d4a:: with SMTP id d10mr5342186pgm.92.1643345413975;
        Thu, 27 Jan 2022 20:50:13 -0800 (PST)
Received: from sunil-ThinkPad-T490.dc1.ventanamicro.com ([49.206.3.187])
        by smtp.gmail.com with ESMTPSA id oa10sm858023pjb.27.2022.01.27.20.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 20:50:13 -0800 (PST)
From:   Sunil V L <sunilvl@ventanamicro.com>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>
Cc:     linux-efi@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Anup Patel <apatel@ventanamicro.com>,
        Sunil V L <sunilvl@ventanamicro.com>, stable@vger.kernel.org
Subject: [PATCH] riscv/efi_stub: Fix get_boot_hartid_from_fdt() return value
Date:   Fri, 28 Jan 2022 10:20:04 +0530
Message-Id: <20220128045004.4843-1-sunilvl@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The get_boot_hartid_from_fdt() function currently returns U32_MAX
for failure case which is not correct because U32_MAX is a valid
hartid value. This patch fixes the issue by returning error code.

Fixes: d7071743db31 ("RISC-V: Add EFI stub support.")
Cc: stable@vger.kernel.org

Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
---
 drivers/firmware/efi/libstub/riscv-stub.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
index 380e4e251399..9c460843442f 100644
--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -25,7 +25,7 @@ typedef void __noreturn (*jump_kernel_func)(unsigned int, unsigned long);
 
 static u32 hartid;
 
-static u32 get_boot_hartid_from_fdt(void)
+static int get_boot_hartid_from_fdt(void)
 {
 	const void *fdt;
 	int chosen_node, len;
@@ -33,23 +33,26 @@ static u32 get_boot_hartid_from_fdt(void)
 
 	fdt = get_efi_config_table(DEVICE_TREE_GUID);
 	if (!fdt)
-		return U32_MAX;
+		return -EINVAL;
 
 	chosen_node = fdt_path_offset(fdt, "/chosen");
 	if (chosen_node < 0)
-		return U32_MAX;
+		return -EINVAL;
 
 	prop = fdt_getprop((void *)fdt, chosen_node, "boot-hartid", &len);
 	if (!prop || len != sizeof(u32))
-		return U32_MAX;
+		return -EINVAL;
 
-	return fdt32_to_cpu(*prop);
+	hartid = fdt32_to_cpu(*prop);
+	return 0;
 }
 
 efi_status_t check_platform_features(void)
 {
-	hartid = get_boot_hartid_from_fdt();
-	if (hartid == U32_MAX) {
+	int ret;
+
+	ret = get_boot_hartid_from_fdt();
+	if (ret) {
 		efi_err("/chosen/boot-hartid missing or invalid!\n");
 		return EFI_UNSUPPORTED;
 	}
-- 
2.25.1

