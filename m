Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 967CA17FDA6
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgCJMwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbgCJMwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:52:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5FAD24699;
        Tue, 10 Mar 2020 12:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844731;
        bh=Q25WBHXvspD9juEVC5yaTk47J15+joeeQqGOlAxDojE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bts7fw+j2SFjP/SVRxNQdXut0WK/zd+4zTBVZ7Pe+WHJNeswx+x1sxWwqK6tJqNwX
         tcqZBjzAu/JKsvD8p8FdXNFYb8r/Z/lBwKD94b+xi5/y78+lDX+DqtjdPf70B8jqgd
         DHKIQOFepsN1MsaQuqqukEABY6wiyL00ZDWSDRuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.4 097/168] x86/pkeys: Manually set X86_FEATURE_OSPKE to preserve existing changes
Date:   Tue, 10 Mar 2020 13:39:03 +0100
Message-Id: <20200310123645.190145951@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 735a6dd02222d8d070c7bb748f25895239ca8c92 upstream.

Explicitly set X86_FEATURE_OSPKE via set_cpu_cap() instead of calling
get_cpu_cap() to pull the feature bit from CPUID after enabling CR4.PKE.
Invoking get_cpu_cap() effectively wipes out any {set,clear}_cpu_cap()
changes that were made between this_cpu->c_init() and setup_pku(), as
all non-synthetic feature words are reinitialized from the CPU's CPUID
values.

Blasting away capability updates manifests most visibility when running
on a VMX capable CPU, but with VMX disabled by BIOS.  To indicate that
VMX is disabled, init_ia32_feat_ctl() clears X86_FEATURE_VMX, using
clear_cpu_cap() instead of setup_clear_cpu_cap() so that KVM can report
which CPU is misconfigured (KVM needs to probe every CPU anyways).
Restoring X86_FEATURE_VMX from CPUID causes KVM to think VMX is enabled,
ultimately leading to an unexpected #GP when KVM attempts to do VMXON.

Arguably, init_ia32_feat_ctl() should use setup_clear_cpu_cap() and let
KVM figure out a different way to report the misconfigured CPU, but VMX
is not the only feature bit that is affected, i.e. there is precedent
that tweaking feature bits via {set,clear}_cpu_cap() after ->c_init()
is expected to work.  Most notably, x86_init_rdrand()'s clearing of
X86_FEATURE_RDRAND when RDRAND malfunctions is also overwritten.

Fixes: 0697694564c8 ("x86/mm/pkeys: Actually enable Memory Protection Keys in the CPU")
Reported-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200226231615.13664-1-sean.j.christopherson@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -464,7 +464,7 @@ static __always_inline void setup_pku(st
 	 * cpuid bit to be set.  We need to ensure that we
 	 * update that bit in this CPU's "cpu_info".
 	 */
-	get_cpu_cap(c);
+	set_cpu_cap(c, X86_FEATURE_OSPKE);
 }
 
 #ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS


