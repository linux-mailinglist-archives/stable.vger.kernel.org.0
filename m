Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E4A6BB1DD
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbjCOMbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbjCOMbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:31:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8331A4AB
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:30:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C26CEB81DF6
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0F2C433EF;
        Wed, 15 Mar 2023 12:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883400;
        bh=byJb1kmaW8u4Bt+XcxXZqHt7YxWyS7lV54NaqaO1ChE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJtD4ir0tlBujXpkqq2br2Kw14nMzRRjAh1kQdGBtV6MbmkE3eTTa6BkkUsF2/Gkx
         LBC3/mevpG0zFBWq8rPX4MmW08irhrwpfuohnHq8AwRKBQHEnLs9RNa2lLws9aK+6/
         tJKwKedh8DWAndS/PIDo8eog2WKX9iYaFnmawwUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dennis Gilmore <dennis@ausil.us>,
        Ard Biesheuvel <ardb@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Tom Saeger <tom.saeger@oracle.com>
Subject: [PATCH 5.15 129/145] arch: fix broken BuildID for arm64 and riscv
Date:   Wed, 15 Mar 2023 13:13:15 +0100
Message-Id: <20230315115743.204873090@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Dennis Gilmore reports that the BuildID is missing in the arm64 vmlinux
since commit 994b7ac1697b ("arm64: remove special treatment for the
link order of head.o").

The issue is that the type of .notes section, which contains the BuildID,
changed from NOTES to PROGBITS.

Ard Biesheuvel figured out that whichever object gets linked first gets
to decide the type of a section. The PROGBITS type is the result of the
compiler emitting .note.GNU-stack as PROGBITS rather than NOTE.

While Ard provided a fix for arm64, I want to fix this globally because
the same issue is happening on riscv since commit 2348e6bf4421 ("riscv:
remove special treatment for the link order of head.o"). This problem
will happen in general for other architectures if they start to drop
unneeded entries from scripts/head-object-list.txt.

Discard .note.GNU-stack in include/asm-generic/vmlinux.lds.h.

Link: https://lore.kernel.org/lkml/CAABkxwuQoz1CTbyb57n0ZX65eSYiTonFCU8-LCQc=74D=xE=rA@mail.gmail.com/
Fixes: 994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")
Reported-by: Dennis Gilmore <dennis@ausil.us>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
[Tom: stable backport 5.15.y, 5.10.y, 5.4.y]

Though the above "Fixes:" commits are not in this kernel, the conditions
which lead to a missing Build ID in arm64 vmlinux are similar.

Evidence points to these conditions:
1. ld version > 2.36 (exact binutils commit documented in a494398bde27)
2. first object which gets linked (head.o) has a PROGBITS .note.GNU-stack segment

These conditions can be observed when:
- 5.15.60+ OR 5.10.136+ OR 5.4.210+
- AND ld version > 2.36
- AND arch=arm64
- AND CONFIG_MODVERSIONS=y

There are notable differences in the vmlinux elf files produced
before(bad) and after(good) applying this series.

Good: p_type:PT_NOTE segment exists.
 Bad: p_type:PT_NOTE segment is missing.

Good: sh_name_str:.notes section has sh_type:SHT_NOTE
 Bad: sh_name_str:.notes section has sh_type:SHT_PROGBITS

`readelf -n` (as of v2.40) searches for Build Id
by processing only the very first note in sh_type:SHT_NOTE sections.

This was previously bisected to the stable backport of 0d362be5b142.
Follow-up experiments were discussed here: https://lore.kernel.org/all/20221221235413.xaisboqmr7dkqwn6@oracle.com/
which strongly hints at condition 2.
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/vmlinux.lds.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -903,7 +903,12 @@
 #define PRINTK_INDEX
 #endif
 
+/*
+ * Discard .note.GNU-stack, which is emitted as PROGBITS by the compiler.
+ * Otherwise, the type of .notes section would become PROGBITS instead of NOTES.
+ */
 #define NOTES								\
+	/DISCARD/ : { *(.note.GNU-stack) }				\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		__start_notes = .;					\
 		KEEP(*(.note.*))					\


