Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3854CF8FE
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239403AbiCGKDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240885AbiCGKBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3856D39F;
        Mon,  7 Mar 2022 01:51:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF490B810DB;
        Mon,  7 Mar 2022 09:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCA3C340F4;
        Mon,  7 Mar 2022 09:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646660;
        bh=4I1nU0P71/pBB/7Sc01HgZewKBA2sy8urZymuFYqK/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNuGgOUf256EVveaBjt6jYallKRpneSRVZ4Yxcr/+hYp+J7UpG0+ndyZfshsZEGic
         3FU9ghiu8lmUqvtPA2hpjkHWDkP6T1sn5ydDSMw1/InFdPxaBHeSdWU8JYk5BTYWoD
         fWxZzO1fqDAeAH3D2vZ7VJ23Z3ddIQMAKU4RVye8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil V L <sunilvl@ventanamicro.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.16 051/186] riscv/efi_stub: Fix get_boot_hartid_from_fdt() return value
Date:   Mon,  7 Mar 2022 10:18:09 +0100
Message-Id: <20220307091655.521050321@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sunil V L <sunilvl@ventanamicro.com>

commit dcf0c838854c86e1f41fb1934aea906845d69782 upstream.

The get_boot_hartid_from_fdt() function currently returns U32_MAX
for failure case which is not correct because U32_MAX is a valid
hartid value. This patch fixes the issue by returning error code.

Cc: <stable@vger.kernel.org>
Fixes: d7071743db31 ("RISC-V: Add EFI stub support.")
Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
Reviewed-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/riscv-stub.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -25,7 +25,7 @@ typedef void __noreturn (*jump_kernel_fu
 
 static u32 hartid;
 
-static u32 get_boot_hartid_from_fdt(void)
+static int get_boot_hartid_from_fdt(void)
 {
 	const void *fdt;
 	int chosen_node, len;
@@ -33,23 +33,26 @@ static u32 get_boot_hartid_from_fdt(void
 
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


