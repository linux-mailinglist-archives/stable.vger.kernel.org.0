Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F135F5387
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiJELfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiJELen (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:34:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB0278221;
        Wed,  5 Oct 2022 04:33:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD41561639;
        Wed,  5 Oct 2022 11:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA284C433B5;
        Wed,  5 Oct 2022 11:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969633;
        bh=SgML4ERX6LPoyE2me/6XSp22j98OujAnFt9cQ9QEdL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BsK3DTFGcIgd/ka9iMGH86xnmCftO0BSp+Wc6zpfwc3UJ7rlHok4TVKOEQcRO0qUU
         +57UQNIRRqWHgE2dMqG0TMWHM44W80XUxNYp8huqZiQTttHE72f1XzxK795PN4fQws
         s8gf8qfWIzr/Rzbu4OYDcYbArhLLOkFBZ1WK6ags=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.4 31/51] x86/common: Stamp out the stepping madness
Date:   Wed,  5 Oct 2022 13:32:19 +0200
Message-Id: <20221005113211.719262757@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 7a05bc95ed1c5a59e47aaade9fb4083c27de9e62 upstream.

The whole MMIO/RETBLEED enumeration went overboard on steppings. Get
rid of all that and simply use ANY.

If a future stepping of these models would not be affected, it had
better set the relevant ARCH_CAP_$FOO_NO bit in
IA32_ARCH_CAPABILITIES.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1126,32 +1126,27 @@ static const struct x86_cpu_id cpu_vuln_
 	VULNBL_INTEL_STEPPINGS(HASWELL,		X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(HASWELL_L,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(HASWELL_G,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(HASWELL_X,	BIT(2) | BIT(4),		MMIO),
-	VULNBL_INTEL_STEPPINGS(BROADWELL_D,	X86_STEPPINGS(0x3, 0x5),	MMIO),
+	VULNBL_INTEL_STEPPINGS(HASWELL_X,	X86_STEPPING_ANY,		MMIO),
+	VULNBL_INTEL_STEPPINGS(BROADWELL_D,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_G,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_X,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(BROADWELL,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_L,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_L,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	BIT(3) | BIT(4) | BIT(6) |
-						BIT(7) | BIT(0xB),              MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE,		X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE,		X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_L,	X86_STEPPINGS(0x9, 0xC),	SRBDS | MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_L,	X86_STEPPINGS(0x0, 0x8),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE,	X86_STEPPINGS(0x9, 0xD),	SRBDS | MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE,	X86_STEPPINGS(0x0, 0x8),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_L,	X86_STEPPINGS(0x5, 0x5),	MMIO | MMIO_SBDS | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_D,	X86_STEPPINGS(0x1, 0x1),	MMIO),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPINGS(0x4, 0x6),	MMIO),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE,	BIT(2) | BIT(3) | BIT(5),	MMIO | MMIO_SBDS | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_L,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	X86_STEPPING_ANY,		MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE,		X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_L,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_D,	X86_STEPPING_ANY,		MMIO),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPING_ANY,		MMIO),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPINGS(0x1, 0x1),	MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPING_ANY,		MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_D,	X86_STEPPING_ANY,		MMIO),
-	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | MMIO_SBDS),
+	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS),
 
 	VULNBL_AMD(0x15, RETBLEED),
 	VULNBL_AMD(0x16, RETBLEED),


