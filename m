Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464A054063D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347237AbiFGReQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347380AbiFGRam (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F271109A5;
        Tue,  7 Jun 2022 10:26:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77A8261281;
        Tue,  7 Jun 2022 17:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDE7C3411C;
        Tue,  7 Jun 2022 17:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622790;
        bh=pyLxJJu2335MYC6nO5LPYnAaHyR9bqLkt5X1tsiA4IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXYNNB2Lh7Hy/+SDJVu8Vpil52rWN8U/8DSFIdcbg9R3ipnSBSM2W82N5zngemT00
         yT1PnhpGOS9k6zUUF2h1EwSvAdP+b2qdXPc8VDg1ln4Hl2qB8J2BXqf/fCbZzXkpq1
         SwYWDgKKakzhcmmOWCzIKvKFjUor1CdjGfKSgtGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Randy Dunlap <rdunlap@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 184/452] x86: Fix return value of __setup handlers
Date:   Tue,  7 Jun 2022 19:00:41 +0200
Message-Id: <20220607164914.043084880@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 12441ccdf5e2f5a01a46e344976cbbd3d46845c9 ]

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled. A return
of 0 causes the boot option/value to be listed as an Unknown kernel
parameter and added to init's (limited) argument (no '=') or environment
(with '=') strings. So return 1 from these x86 __setup handlers.

Examples:

  Unknown kernel command line parameters "apicpmtimer
    BOOT_IMAGE=/boot/bzImage-517rc8 vdso=1 ring3mwait=disable", will be
    passed to user space.

  Run /sbin/init as init process
   with arguments:
     /sbin/init
     apicpmtimer
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc8
     vdso=1
     ring3mwait=disable

Fixes: 2aae950b21e4 ("x86_64: Add vDSO for x86-64 with gettimeofday/clock_gettime/getcpu")
Fixes: 77b52b4c5c66 ("x86: add "debugpat" boot option")
Fixes: e16fd002afe2 ("x86/cpufeature: Enable RING3MWAIT for Knights Landing")
Fixes: b8ce33590687 ("x86_64: convert to clock events")
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Link: https://lore.kernel.org/r/20220314012725.26661-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/vdso/vma.c   | 2 +-
 arch/x86/kernel/apic/apic.c | 2 +-
 arch/x86/kernel/cpu/intel.c | 2 +-
 arch/x86/mm/pat/memtype.c   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 9185cb1d13b9..5876289e48d8 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -440,7 +440,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 static __init int vdso_setup(char *s)
 {
 	vdso64_enabled = simple_strtoul(s, NULL, 0);
-	return 0;
+	return 1;
 }
 __setup("vdso=", vdso_setup);
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 24539a05c58c..1c96f2425eaf 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -168,7 +168,7 @@ static __init int setup_apicpmtimer(char *s)
 {
 	apic_calibrate_pmtmr = 1;
 	notsc_setup(NULL);
-	return 0;
+	return 1;
 }
 __setup("apicpmtimer", setup_apicpmtimer);
 #endif
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 816fdbec795a..c6ad53e38f65 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -88,7 +88,7 @@ static bool ring3mwait_disabled __read_mostly;
 static int __init ring3mwait_disable(char *__unused)
 {
 	ring3mwait_disabled = true;
-	return 0;
+	return 1;
 }
 __setup("ring3mwait=disable", ring3mwait_disable);
 
diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index 232932bda4e5..f9c53a710740 100644
--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -101,7 +101,7 @@ int pat_debug_enable;
 static int __init pat_debug_setup(char *str)
 {
 	pat_debug_enable = 1;
-	return 0;
+	return 1;
 }
 __setup("debugpat", pat_debug_setup);
 
-- 
2.35.1



