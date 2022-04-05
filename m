Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184F24F3565
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355609AbiDEKU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347261AbiDEJZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:25:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D947DCAB0;
        Tue,  5 Apr 2022 02:15:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E3FE61659;
        Tue,  5 Apr 2022 09:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD13C385A0;
        Tue,  5 Apr 2022 09:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150102;
        bh=4djunoAxJHOaDgEd2iZ0RMBXmqeYYQMugjYVYuIJyBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDYIdw22qhOhK0A9LFH4yO1dWKTBnNBCzXh2qQGiQus/H2dH3cjvubrYRpz4hNG5i
         C6TuafokJNnmH5fc7o4LnBKa16mLE9lz/1gqMXCdJwDRBG+0A3bjy2vqvxtiD/uAWR
         qR9/0x9zz3Plh8XQMywhaAPrQ0uOPyb2/Kn/JZKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Fangrui Song <maskray@google.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.16 0954/1017] riscv module: remove (NOLOAD)
Date:   Tue,  5 Apr 2022 09:31:07 +0200
Message-Id: <20220405070422.528094436@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Fangrui Song <maskray@google.com>

commit 60210a3d86dc57ce4a76a366e7841dda746a33f7 upstream.

On ELF, (NOLOAD) sets the section type to SHT_NOBITS[1]. It is conceptually
inappropriate for .plt, .got, and .got.plt sections which are always
SHT_PROGBITS.

In GNU ld, if PLT entries are needed, .plt will be SHT_PROGBITS anyway
and (NOLOAD) will be essentially ignored. In ld.lld, since
https://reviews.llvm.org/D118840 ("[ELF] Support (TYPE=<value>) to
customize the output section type"), ld.lld will report a `section type
mismatch` error (later changed to a warning). Just remove (NOLOAD) to
fix the warning.

[1] https://lld.llvm.org/ELF/linker_script.html As of today, "The
section should be marked as not loadable" on
https://sourceware.org/binutils/docs/ld/Output-Section-Type.html is
outdated for ELF.

Link: https://github.com/ClangBuiltLinux/linux/issues/1597
Fixes: ab1ef68e5401 ("RISC-V: Add sections of PLT and GOT for kernel module")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Fangrui Song <maskray@google.com>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/module.lds.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/riscv/include/asm/module.lds.h
+++ b/arch/riscv/include/asm/module.lds.h
@@ -2,8 +2,8 @@
 /* Copyright (C) 2017 Andes Technology Corporation */
 #ifdef CONFIG_MODULE_SECTIONS
 SECTIONS {
-	.plt (NOLOAD) : { BYTE(0) }
-	.got (NOLOAD) : { BYTE(0) }
-	.got.plt (NOLOAD) : { BYTE(0) }
+	.plt : { BYTE(0) }
+	.got : { BYTE(0) }
+	.got.plt : { BYTE(0) }
 }
 #endif


