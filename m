Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E2837CB51
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242594AbhELQfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241657AbhELQ1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF6B561DFA;
        Wed, 12 May 2021 15:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834890;
        bh=WGJM24H87IV1cFTUbbAlOeYWk9NY0ci639uGr9WFkKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7//ftRRpzL2Ws+mm7y9GzSnpr+XJXdyhDV9aASjurhBA0E6hGqLlfvCSobmV/ibE
         JxACJZCRUAKTBzcB4XxhPUGzPJJHE3OXMfEx9tzSudGkXWXnzpmHonoAMFzRM904dP
         Ff8gxBtf2fqRp+MweL1p9UXKjkUrDVizyMSNZsj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        David Brazdil <dbrazdil@google.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.12 125/677] KVM: arm64: Support PREL/PLT relocs in EL2 code
Date:   Wed, 12 May 2021 16:42:51 +0200
Message-Id: <20210512144841.367275440@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Brazdil <dbrazdil@google.com>

commit 77e06b300161d41d65950be9c77a785c142b381d upstream.

gen-hyprel tool parses object files of the EL2 portion of KVM
and generates runtime relocation data. While only filtering for
R_AARCH64_ABS64 relocations in the input object files, it has an
allow-list of relocation types that are used for relative
addressing. Other, unexpected, relocation types are rejected and
cause the build to fail.

This allow-list did not include the position-relative relocation
types R_AARCH64_PREL64/32/16 and the recently introduced _PLT32.
While not seen used by toolchains in the wild, add them to the
allow-list for completeness.

Fixes: 8c49b5d43d4c ("KVM: arm64: Generate hyp relocation data")
Cc: <stable@vger.kernel.org>
Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210331133048.63311-1-dbrazdil@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
+++ b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
@@ -50,6 +50,18 @@
 #ifndef R_AARCH64_ABS64
 #define R_AARCH64_ABS64			257
 #endif
+#ifndef R_AARCH64_PREL64
+#define R_AARCH64_PREL64		260
+#endif
+#ifndef R_AARCH64_PREL32
+#define R_AARCH64_PREL32		261
+#endif
+#ifndef R_AARCH64_PREL16
+#define R_AARCH64_PREL16		262
+#endif
+#ifndef R_AARCH64_PLT32
+#define R_AARCH64_PLT32			314
+#endif
 #ifndef R_AARCH64_LD_PREL_LO19
 #define R_AARCH64_LD_PREL_LO19		273
 #endif
@@ -371,6 +383,12 @@ static void emit_rela_section(Elf64_Shdr
 		case R_AARCH64_ABS64:
 			emit_rela_abs64(rela, sh_orig_name);
 			break;
+		/* Allow position-relative data relocations. */
+		case R_AARCH64_PREL64:
+		case R_AARCH64_PREL32:
+		case R_AARCH64_PREL16:
+		case R_AARCH64_PLT32:
+			break;
 		/* Allow relocations to generate PC-relative addressing. */
 		case R_AARCH64_LD_PREL_LO19:
 		case R_AARCH64_ADR_PREL_LO21:


