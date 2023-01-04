Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B16B65D93A
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbjADQWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239785AbjADQWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:22:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B01641D4B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:22:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAFCF61798
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9629C433D2;
        Wed,  4 Jan 2023 16:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849343;
        bh=N50cOfFxgAGh/igrfdLHnO1oXjCQ9T8lToz0ZfB+JaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVUbMbnKasS/z1kskDsilogCIHblkRUEOubPZyma3H7hPYfqFWubUDXKKLf7nV6Ov
         DqQAd14wxaFZoAHj8Du+0R4NItoFnWGj6f1AxW9rGcp7l+m60QBznnYds/r74p5DbX
         1UHS4xnAyu0pCFgYurmOmv0ejXEVjNIXIlOEpdGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Huafei <lihuafei1@huawei.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.0 106/177] RISC-V: kexec: Fix memory leak of elf header buffer
Date:   Wed,  4 Jan 2023 17:06:37 +0100
Message-Id: <20230104160510.857319215@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Huafei <lihuafei1@huawei.com>

commit cbc32023ddbdf4baa3d9dc513a2184a84080a5a2 upstream.

This is reported by kmemleak detector:

unreferenced object 0xff2000000403d000 (size 4096):
  comm "kexec", pid 146, jiffies 4294900633 (age 64.792s)
  hex dump (first 32 bytes):
    7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00  .ELF............
    04 00 f3 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000566ca97c>] kmemleak_vmalloc+0x3c/0xbe
    [<00000000979283d8>] __vmalloc_node_range+0x3ac/0x560
    [<00000000b4b3712a>] __vmalloc_node+0x56/0x62
    [<00000000854f75e2>] vzalloc+0x2c/0x34
    [<00000000e9a00db9>] crash_prepare_elf64_headers+0x80/0x30c
    [<0000000067e8bf48>] elf_kexec_load+0x3e8/0x4ec
    [<0000000036548e09>] kexec_image_load_default+0x40/0x4c
    [<0000000079fbe1b4>] sys_kexec_file_load+0x1c4/0x322
    [<0000000040c62c03>] ret_from_syscall+0x0/0x2

In elf_kexec_load(), a buffer is allocated via vzalloc() to store elf
headers.  While it's not freed back to system when kdump kernel is
reloaded or unloaded, or when image->elf_header is successfully set and
then fails to load kdump kernel for some reason. Fix it by freeing the
buffer in arch_kimage_file_post_load_cleanup().

Fixes: 8acea455fafa ("RISC-V: Support for kexec_file on panic")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20221104095658.141222-2-lihuafei1@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/elf_kexec.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/riscv/kernel/elf_kexec.c
+++ b/arch/riscv/kernel/elf_kexec.c
@@ -26,6 +26,10 @@ int arch_kimage_file_post_load_cleanup(s
 	kvfree(image->arch.fdt);
 	image->arch.fdt = NULL;
 
+	vfree(image->elf_headers);
+	image->elf_headers = NULL;
+	image->elf_headers_sz = 0;
+
 	return kexec_image_post_load_cleanup_default(image);
 }
 


