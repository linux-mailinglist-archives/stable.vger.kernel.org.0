Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9845B71E1
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiIMOux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbiIMOte (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:49:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154CC719AD;
        Tue, 13 Sep 2022 07:25:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B8B2B80EF6;
        Tue, 13 Sep 2022 14:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C70CC433C1;
        Tue, 13 Sep 2022 14:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079153;
        bh=OSzpNpfBxOFdDV5lrsHtQsAg+W0Vb3hSIKxhvePc5zE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWSKx9PVVB4XmodeNsMS58T/O9bzKC34aSGuCpYBoSbjmn1WG50c4oM+vFmEI+YGG
         dRQ/VtG062cc6ZIfkyTxUVhARBcNNOn05fTjMCWffSgMq7Ss5HHkPb+bPu9b8Qguuy
         j+RJBkgeErzi2/oEULSLx9Tk1q77gTV9JEMucAUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 023/108] powerpc: align syscall table for ppc32
Date:   Tue, 13 Sep 2022 16:05:54 +0200
Message-Id: <20220913140354.625153846@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit c7acee3d2f128a38b68fb7af85dbbd91bfd0b4ad upstream.

Christophe Leroy reported that commit 7b4537199a4a ("kbuild: link
symbol CRCs at final link,  removing CONFIG_MODULE_REL_CRCS") broke
mpc85xx_defconfig + CONFIG_RELOCATABLE=y.

    LD      vmlinux
    SYSMAP  System.map
    SORTTAB vmlinux
    CHKREL  vmlinux
  WARNING: 451 bad relocations
  c0b312a9 R_PPC_UADDR32     .head.text-0x3ff9ed54
  c0b312ad R_PPC_UADDR32     .head.text-0x3ffac224
  c0b312b1 R_PPC_UADDR32     .head.text-0x3ffb09f4
  c0b312b5 R_PPC_UADDR32     .head.text-0x3fe184dc
  c0b312b9 R_PPC_UADDR32     .head.text-0x3fe183a8
      ...

The compiler emits a bunch of R_PPC_UADDR32, which is not supported by
arch/powerpc/kernel/reloc_32.S.

The reason is there exists an unaligned symbol.

  $ powerpc-linux-gnu-nm -n vmlinux
    ...
  c0b31258 d spe_aligninfo
  c0b31298 d __func__.0
  c0b312a9 D sys_call_table
  c0b319b8 d __func__.0

Commit 7b4537199a4a is not the root cause. Even before that, I can
reproduce the same issue for mpc85xx_defconfig + CONFIG_RELOCATABLE=y
+ CONFIG_MODVERSIONS=n.

It is just that nobody noticed because when CONFIG_MODVERSIONS is
enabled, a __crc_* symbol inserted before sys_call_table was hiding the
unalignment issue.

Adding alignment to the syscall table for ppc32 fixes the issue.

Cc: stable@vger.kernel.org
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Trim change log discussion, add Cc stable]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/lkml/38605f6a-a568-f884-f06f-ea4da5b214f0@csgroup.eu/
Link: https://lore.kernel.org/r/20220820165129.1147589-1-masahiroy@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/systbl.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/systbl.S
+++ b/arch/powerpc/kernel/systbl.S
@@ -25,6 +25,7 @@ sys_call_table:
 #include <asm/syscall_table_64.h>
 #undef __SYSCALL
 #else
+	.p2align	2
 #define __SYSCALL(nr, entry)	.long entry
 #include <asm/syscall_table_32.h>
 #undef __SYSCALL


