Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4865169CC99
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjBTNmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbjBTNmM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:42:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F50F1CF6C
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:41:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DCD460C03
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54831C433EF;
        Mon, 20 Feb 2023 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900505;
        bh=GJx0ju4aigeLfhnWgB36GzGcm2YwC+sYdp3EGLsWlxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QiyPdAEPvj2SKDmtyUTZuaeEDqgBcOaOLS/rJfELTmpKeRLgQJ7AGoY1nrIj9ukvL
         F9sOVeavTotxkTRgVG3rdQ4nZvnNVTYQTDkom7o1m+qgWP4B0JEQ26Z51VQdr/zhLL
         3lfwSOQvLR5OlZaaj3oAKO7EgznqkDjAtmyVDqHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/89] KVM: VMX: Move VMX specific files to a "vmx" subdirectory
Date:   Mon, 20 Feb 2023 14:35:21 +0100
Message-Id: <20230220133553.950224885@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit a821bab2d1ee869e04b218b198837bf07f2d27c1 ]

...to prepare for shattering vmx.c into multiple files without having
to prepend "vmx_" to all new files.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: a44b331614e6 ("KVM: x86/vmx: Do not skip segment attributes if unusable bit is set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/Makefile                      | 2 +-
 arch/x86/kvm/{ => vmx}/pmu_intel.c         | 0
 arch/x86/kvm/{ => vmx}/vmx.c               | 0
 arch/x86/kvm/{ => vmx}/vmx_evmcs.h         | 0
 arch/x86/kvm/{ => vmx}/vmx_shadow_fields.h | 0
 5 files changed, 1 insertion(+), 1 deletion(-)
 rename arch/x86/kvm/{ => vmx}/pmu_intel.c (100%)
 rename arch/x86/kvm/{ => vmx}/vmx.c (100%)
 rename arch/x86/kvm/{ => vmx}/vmx_evmcs.h (100%)
 rename arch/x86/kvm/{ => vmx}/vmx_shadow_fields.h (100%)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index dc4f2fdf5e57..13fd54de5449 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -16,7 +16,7 @@ kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o page_track.o debugfs.o
 
-kvm-intel-y		+= vmx.o pmu_intel.o
+kvm-intel-y		+= vmx/vmx.o vmx/pmu_intel.o
 kvm-amd-y		+= svm.o pmu_amd.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/x86/kvm/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
similarity index 100%
rename from arch/x86/kvm/pmu_intel.c
rename to arch/x86/kvm/vmx/pmu_intel.c
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx/vmx.c
similarity index 100%
rename from arch/x86/kvm/vmx.c
rename to arch/x86/kvm/vmx/vmx.c
diff --git a/arch/x86/kvm/vmx_evmcs.h b/arch/x86/kvm/vmx/vmx_evmcs.h
similarity index 100%
rename from arch/x86/kvm/vmx_evmcs.h
rename to arch/x86/kvm/vmx/vmx_evmcs.h
diff --git a/arch/x86/kvm/vmx_shadow_fields.h b/arch/x86/kvm/vmx/vmx_shadow_fields.h
similarity index 100%
rename from arch/x86/kvm/vmx_shadow_fields.h
rename to arch/x86/kvm/vmx/vmx_shadow_fields.h
-- 
2.39.0



