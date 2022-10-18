Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FB2601FBB
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiJRAjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiJRAit (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:38:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B828372EF8;
        Mon, 17 Oct 2022 17:38:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA4A861349;
        Tue, 18 Oct 2022 00:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FAEC433C1;
        Tue, 18 Oct 2022 00:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051910;
        bh=nYc/JJQWVLR17zmJ/Apl3A09K9m9aLeR87SkRSK+Grk=;
        h=From:To:Cc:Subject:Date:From;
        b=lcEGQ21lgKqTSMBDpAaTFyzac6X/h8ZPi5vx92OjF6aaoLz4m7vqryAfnz+kxmVfP
         FOtgtO50WGm19Anrrfv6L1i07BPaC2kV36Lhz3DDvW452CtGooM/CQjtTEPNm6Tv9o
         v7wy8FSYIcCg3Ve5UHiwPk5Mjo+NG2tj7PCCX5n8xXA8jVpU9Yj3CCRQPozu0ZoNFK
         93rmmlQqRBooH4ugfCL6cgsaTjF7/CMiDwjT17zTUmz3YbjTf0CO6jy63HzcOKJbvm
         nXmT72btXuIqKxV9gh8okQCX9vHiQmpXYjM1qHA3vNDIyaTHKBgc5gRjisjr/WL2X9
         0kHU5+pAsCMVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Bykowski <marek.bykowski@gmail.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        robh+dt@kernel.org, frowand.list@gmail.com,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 1/8] of/fdt: Don't calculate initrd size from DT if start > end
Date:   Mon, 17 Oct 2022 20:11:40 -0400
Message-Id: <20221018001147.2732350-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Bykowski <marek.bykowski@gmail.com>

[ Upstream commit d5e3050c0feb8bf7b9a75482fafcc31b90257926 ]

If the properties 'linux,initrd-start' and 'linux,initrd-end' of
the chosen node populated from the bootloader, eg. U-Boot, are so that
start > end, then the phys_initrd_size calculated from end - start is
negative that subsequently gets converted to a high positive value for
being unsigned long long. Then, the memory region with the (invalid)
size is added to the bootmem and attempted being paged in paging_init()
that results in the kernel fault.

For example, on the FVP ARM64 system I'm running, the U-Boot populates
the 'linux,initrd-start' with 8800_0000 and 'linux,initrd-end' with 0.
The phys_initrd_size calculated is then ffff_ffff_7800_0000
(= 0 - 8800_0000 = -8800_0000 + ULLONG_MAX + 1). paging_init() then
attempts to map the address 8800_0000 + ffff_ffff_7800_0000 and oops'es
as below.

It should be stressed, it is generally a fault of the bootloader's with
the kernel relying on it, however we should not allow the bootloader's
misconfiguration to lead to the kernel oops. Not only the kernel should be
bullet proof against it but also finding the root cause of the paging
fault spanning over the bootloader, DT, and kernel may happen is not so
easy.

  Unable to handle kernel paging request at virtual address fffffffefe43c000
  Mem abort info:
    ESR = 0x96000007
    EC = 0x25: DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
  Data abort info:
    ISV = 0, ISS = 0x00000007
    CM = 0, WnR = 0
  swapper pgtable: 4k pages, 39-bit VAs, pgdp=0000000080e3d000
  [fffffffefe43c000] pgd=0000000080de9003, pud=0000000080de9003
  Unable to handle kernel paging request at virtual address ffffff8000de9f90
  Mem abort info:
    ESR = 0x96000005
    EC = 0x25: DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
  Data abort info:
    ISV = 0, ISS = 0x00000005
    CM = 0, WnR = 0
  swapper pgtable: 4k pages, 39-bit VAs, pgdp=0000000080e3d000
  [ffffff8000de9f90] pgd=0000000000000000, pud=0000000000000000
  Internal error: Oops: 96000005 [#1] PREEMPT SMP
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper Not tainted 5.4.51-yocto-standard #1
  Hardware name: FVP Base (DT)
  pstate: 60000085 (nZCv daIf -PAN -UAO)
  pc : show_pte+0x12c/0x1b4
  lr : show_pte+0x100/0x1b4
  sp : ffffffc010ce3b30
  x29: ffffffc010ce3b30 x28: ffffffc010ceed80
  x27: fffffffefe43c000 x26: fffffffefe43a028
  x25: 0000000080bf0000 x24: 0000000000000025
  x23: ffffffc010b8d000 x22: ffffffc010e3d000
  x23: ffffffc010b8d000 x22: ffffffc010e3d000
  x21: 0000000080de9000 x20: ffffff7f80000f90
  x19: fffffffefe43c000 x18: 0000000000000030
  x17: 0000000000001400 x16: 0000000000001c00
  x15: ffffffc010cef1b8 x14: ffffffffffffffff
  x13: ffffffc010df1f40 x12: ffffffc010df1b70
  x11: ffffffc010ce3b30 x10: ffffffc010ce3b30
  x9 : 00000000ffffffc8 x8 : 0000000000000000
  x7 : 000000000000000f x6 : ffffffc010df16e8
  x5 : 0000000000000000 x4 : 0000000000000000
  x3 : 00000000ffffffff x2 : 0000000000000000
  x1 : 0000008080000000 x0 : ffffffc010af1d68
  Call trace:
   show_pte+0x12c/0x1b4
   die_kernel_fault+0x54/0x78
   __do_kernel_fault+0x11c/0x128
   do_translation_fault+0x58/0xac
   do_mem_abort+0x50/0xb0
   el1_da+0x1c/0x90
   __create_pgd_mapping+0x348/0x598
   paging_init+0x3f0/0x70d0
   setup_arch+0x2c0/0x5d4
   start_kernel+0x94/0x49c
  Code: 92748eb5 900052a0 9135a000 cb010294 (f8756a96) 

Signed-off-by: Marek Bykowski <marek.bykowski@gmail.com>
Link: https://lore.kernel.org/r/20220909023358.76881-1-marek.bykowski@gmail.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index cc9b8c699da4..253680c84c8c 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -957,6 +957,8 @@ static void __init early_init_dt_check_for_initrd(unsigned long node)
 	if (!prop)
 		return;
 	end = of_read_number(prop, len/4);
+	if (start > end)
+		return;
 
 	__early_init_dt_declare_initrd(start, end);
 
-- 
2.35.1

