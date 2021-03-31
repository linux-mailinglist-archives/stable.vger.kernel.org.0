Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1DA350138
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 15:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbhCaNbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 09:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235776AbhCaNbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 09:31:05 -0400
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91EEC06174A
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 06:31:04 -0700 (PDT)
Received: by mail-wm1-x34a.google.com with SMTP id c7so560366wml.8
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 06:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=G0CRqLqXvRiG1/XBSQU7fXbBsXpuUCmZ+DzzZxxUzIo=;
        b=rpChXq0EFgKIpVkS59ynQK6JSC0ep27UrPlpHOIVXXkfEXuY1WiqSTcyQmMkdr6XPW
         53JPsCxnplpk4AqN/UvbynyFxEGzP9Rkq1sDPNgNceVhS5YpfVel6aA/w4KaFNV4vBL+
         QAFVKTMZV/lVWqCLIk5bsq1MIBrRkA/Ooyp+rx78E8X8PzrXals9D+IfBPlLMlBal7B2
         j9drq3kA22qdFUjiiv/1chYzZQIwhn77vvgUXToIwPnCIbU22Ww6RXQnMF7obLxEdoX1
         9ex5kaUnqXGhNbhsmM+ethxGc/m0mPttOb29qF0OS9eSSj0QbOP/jOa/4Jluy5hhGv27
         6S2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=G0CRqLqXvRiG1/XBSQU7fXbBsXpuUCmZ+DzzZxxUzIo=;
        b=YxBvc9ZgepmnM/8H5RxQr2uzKTo5xNdIU2m68IqqMW+QtROflhTg7T7Nlz4sUK8HYD
         uDsf9O55ZNubfKhMxCX70mfXLWWVApKCLxmuhsSwz+E8B40sn2B8n0212B2jxn2L0Ot1
         ece5PX5HZXumi7g+NDkslb/hhltuqAhiEXXpeS9AJFOILBlHw0y0kFaEIizmm5/lVuLv
         F0wgK70HH9AzsI5UupltZdaWlErUPnD+fjbhRZzBggBYVhohHgrVPRvD/CYLJgjPE2bs
         h0ks0d9ko3Fo9q1YRNEtOpumXWTX2OFdWT1irt3KyGPbHWPgWHNYnv1sRJyfilvMCUBy
         n1/w==
X-Gm-Message-State: AOAM530smFVFE0KsJSGZA4gZbn7N7tCIHeOLrDeDkN4GOC9XUbN5u3yo
        XBadQtw2SY+BG7nLbcnri/SNpHgUJd6dqg==
X-Google-Smtp-Source: ABdhPJySMhwc9kqXQ1VmN7daeWnrVfYLeV5Uk5jjjZpqjhpojJFXojBjLNB+z8i/nKEIQhH3v7TuNHaCn5+7lg==
X-Received: from dbrazdil.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:7f9b])
 (user=dbrazdil job=sendgmr) by 2002:adf:fb05:: with SMTP id
 c5mr3869165wrr.302.1617197463183; Wed, 31 Mar 2021 06:31:03 -0700 (PDT)
Date:   Wed, 31 Mar 2021 13:30:48 +0000
Message-Id: <20210331133048.63311-1-dbrazdil@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH] KVM: arm64: Support PREL/PLT relocs in EL2 code
From:   David Brazdil <dbrazdil@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, David Brazdil <dbrazdil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
index ead02c6a7628..6bc88a756cb7 100644
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
@@ -371,6 +383,12 @@ static void emit_rela_section(Elf64_Shdr *sh_rela)
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
-- 
2.31.0.291.g576ba9dcdaf-goog

