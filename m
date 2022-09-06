Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBB25AEA94
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238206AbiIFNuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbiIFNsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:48:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE5B7C308;
        Tue,  6 Sep 2022 06:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21ADE6154A;
        Tue,  6 Sep 2022 13:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3115CC433D6;
        Tue,  6 Sep 2022 13:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471555;
        bh=2t5gG7chT0YaqazGsBisRir+uDym/eOwq0dvTSwEEQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWvaCNe4Ucjj/BON3WykNR8ujSfDhd7QD/HjaL6SbmqGC5EnyQO2fuXAxMynICgWc
         S519+bHAzH6K8qHw6srR7xfvcpvu2tbYQzhSXNfK9m35RqnD/xgSdPVh7zWNsL9Fny
         fJ5PX23s+kH4W/2nNko1aLFqc+dWL9S/WCgS48kE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 034/107] powerpc: align syscall table for ppc32
Date:   Tue,  6 Sep 2022 15:30:15 +0200
Message-Id: <20220906132823.236001530@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
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
@@ -18,6 +18,7 @@
 	.p2align	3
 #define __SYSCALL(nr, entry)	.8byte entry
 #else
+	.p2align	2
 #define __SYSCALL(nr, entry)	.long entry
 #endif
 


