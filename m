Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28CE226B3A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbgGTPrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:47:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730749AbgGTPrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:47:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0D8122CBB;
        Mon, 20 Jul 2020 15:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260036;
        bh=4+SJGv96MYFvYFb3UxSt396NCljZyKXMQrodKaOrMuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwYMEkOi8UtFxFBj9lMuDYdmitaW1Tc2NrYZArJoZ5ftG4a57qTnVb0vn2R4hx9B3
         CcatRttMPJEjQbg3btggWxt8hm1RDZMLQ0j0fH1zgMHdIAbvG1QhrLO+YGCoEKC5mK
         UBfXr92SmI4AJm6tRjca8iPYqjy1fLc5ZT2M+I4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Dave P Martin <dave.martin@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 056/125] arm64/alternatives: use subsections for replacement sequences
Date:   Mon, 20 Jul 2020 17:36:35 +0200
Message-Id: <20200720152805.735857249@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit f7b93d42945cc71e1346dd5ae07c59061d56745e ]

When building very large kernels, the logic that emits replacement
sequences for alternatives fails when relative branches are present
in the code that is emitted into the .altinstr_replacement section
and patched in at the original site and fixed up. The reason is that
the linker will insert veneers if relative branches go out of range,
and due to the relative distance of the .altinstr_replacement from
the .text section where its branch targets usually live, veneers
may be emitted at the end of the .altinstr_replacement section, with
the relative branches in the sequence pointed at the veneers instead
of the actual target.

The alternatives patching logic will attempt to fix up the branch to
point to its original target, which will be the veneer in this case,
but given that the patch site is likely to be far away as well, it
will be out of range and so patching will fail. There are other cases
where these veneers are problematic, e.g., when the target of the
branch is in .text while the patch site is in .init.text, in which
case putting the replacement sequence inside .text may not help either.

So let's use subsections to emit the replacement code as closely as
possible to the patch site, to ensure that veneers are only likely to
be emitted if they are required at the patch site as well, in which
case they will be in range for the replacement sequence both before
and after it is transported to the patch site.

This will prevent alternative sequences in non-init code from being
released from memory after boot, but this is tolerable given that the
entire section is only 512 KB on an allyesconfig build (which weighs in
at 500+ MB for the entire Image). Also, note that modules today carry
the replacement sequences in non-init sections as well, and any of
those that target init code will be emitted into init sections after
this change.

This fixes an early crash when booting an allyesconfig kernel on a
system where any of the alternatives sequences containing relative
branches are activated at boot (e.g., ARM64_HAS_PAN on TX2)

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Dave P Martin <dave.martin@arm.com>
Link: https://lore.kernel.org/r/20200630081921.13443-1-ardb@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/alternative.h | 16 ++++++++--------
 arch/arm64/kernel/vmlinux.lds.S      |  3 ---
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
index 4ed869845a23b..1824768fb1ee9 100644
--- a/arch/arm64/include/asm/alternative.h
+++ b/arch/arm64/include/asm/alternative.h
@@ -68,11 +68,11 @@ void apply_alternatives(void *start, size_t length);
 	".pushsection .altinstructions,\"a\"\n"				\
 	ALTINSTR_ENTRY(feature)						\
 	".popsection\n"							\
-	".pushsection .altinstr_replacement, \"a\"\n"			\
+	".subsection 1\n"						\
 	"663:\n\t"							\
 	newinstr "\n"							\
 	"664:\n\t"							\
-	".popsection\n\t"						\
+	".previous\n\t"							\
 	".org	. - (664b-663b) + (662b-661b)\n\t"			\
 	".org	. - (662b-661b) + (664b-663b)\n"			\
 	".endif\n"
@@ -112,9 +112,9 @@ void apply_alternatives(void *start, size_t length);
 662:	.pushsection .altinstructions, "a"
 	altinstruction_entry 661b, 663f, \cap, 662b-661b, 664f-663f
 	.popsection
-	.pushsection .altinstr_replacement, "ax"
+	.subsection 1
 663:	\insn2
-664:	.popsection
+664:	.previous
 	.org	. - (664b-663b) + (662b-661b)
 	.org	. - (662b-661b) + (664b-663b)
 	.endif
@@ -155,7 +155,7 @@ void apply_alternatives(void *start, size_t length);
 	.pushsection .altinstructions, "a"
 	altinstruction_entry 663f, 661f, \cap, 664f-663f, 662f-661f
 	.popsection
-	.pushsection .altinstr_replacement, "ax"
+	.subsection 1
 	.align 2	/* So GAS knows label 661 is suitably aligned */
 661:
 .endm
@@ -174,9 +174,9 @@ void apply_alternatives(void *start, size_t length);
 .macro alternative_else
 662:
 	.if .Lasm_alt_mode==0
-	.pushsection .altinstr_replacement, "ax"
+	.subsection 1
 	.else
-	.popsection
+	.previous
 	.endif
 663:
 .endm
@@ -187,7 +187,7 @@ void apply_alternatives(void *start, size_t length);
 .macro alternative_endif
 664:
 	.if .Lasm_alt_mode==0
-	.popsection
+	.previous
 	.endif
 	.org	. - (664b-663b) + (662b-661b)
 	.org	. - (662b-661b) + (664b-663b)
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 6edfdf5b061d6..c4e55176f4b6d 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -154,9 +154,6 @@ SECTIONS
 		*(.altinstructions)
 		__alt_instructions_end = .;
 	}
-	.altinstr_replacement : {
-		*(.altinstr_replacement)
-	}
 
 	. = ALIGN(PAGE_SIZE);
 	__inittext_end = .;
-- 
2.25.1



