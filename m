Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDD142FD31
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 23:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbhJOVCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 17:02:44 -0400
Received: from mga05.intel.com ([192.55.52.43]:4105 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231621AbhJOVCo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 17:02:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10138"; a="314183217"
X-IronPort-AV: E=Sophos;i="5.85,376,1624345200"; 
   d="scan'208";a="314183217"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 13:59:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,376,1624345200"; 
   d="scan'208";a="571866704"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 15 Oct 2021 13:58:58 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 1CA83155; Fri, 15 Oct 2021 23:43:38 +0300 (EEST)
Date:   Fri, 15 Oct 2021 23:43:38 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/sme: Use #define USE_EARLY_PGTABLE_L5 in
 mem_encrypt_identity.c
Message-ID: <20211015204338.64p3a7vwylqacbfm@black.fi.intel.com>
References: <2cb8329655f5c753905812d951e212022a480475.1634318656.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cb8329655f5c753905812d951e212022a480475.1634318656.git.thomas.lendacky@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 15, 2021 at 12:24:16PM -0500, Tom Lendacky wrote:
> When runtime support for converting between 4-level and 5-level pagetables
> was added to the kernel, the SME code that built pagetables was updated
> to use the pagetable functions, e.g. p4d_offset(), etc., in order to
> simplify the code. However, the use of the pagetable functions in early
> boot code requires the use of the USE_EARLY_PGTABLE_L5 #define in order to
> ensure that proper definition of pgtable_l5_enabled() is used.
> 
> Without the #define, pgtable_l5_enabled() is #defined as
> cpu_feature_enabled(X86_FEATURE_LA57). In early boot, the CPU features
> have not yet been discovered and populated, so pgtable_l5_enabled() will
> return false even when 5-level paging is enabled. This causes the SME code
> to always build 4-level pagetables to perform the in-place encryption.
> If 5-level paging is enabled, switching to the SME pagetables results in
> a page-fault that kills the boot.
> 
> Adding the #define results in pgtable_l5_enabled() using the
> __pgtable_l5_enabled variable set in early boot and the SME code building
> pagetables for the proper paging level.
> 
> Cc: <stable@vger.kernel.org> # 4.18.x
> Fixes: aad983913d77 ("x86/mm/encrypt: Simplify sme_populate_pgd() and sme_populate_pgd_large()")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
