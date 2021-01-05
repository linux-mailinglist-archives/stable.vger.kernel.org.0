Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145F92EA45E
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 05:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbhAEETk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 23:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbhAEETk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 23:19:40 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D116C061793
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 20:19:00 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id g20so39639703ejb.1
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 20:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q8gOUdE50UNp9LhAlhCoddse7EZKmhUhGDFbU73aCc4=;
        b=QQAB3r3U7V/2S0pr/HlzDsASSQCQL5YI2Yu+LKkp2b3uUmYomjrfg0xQ/kZkvLyJQ6
         upccUaRauLNncsDHq4Dan5ZBkaKXTJoCxVNuWo6SVKRMoKr0n82h1XgfvAGBdNfBPM3x
         tpbv+nMXZ/yauTzmx7BYKMKDtKWHQl+RnsMxuRFL2Jxbf04JYY8nN/uKYxGMJLS/kCyt
         15iKGTLQ6np+ytfvUZKLGX8b/FbMtjsr+qXMrCWxWeH2+cjGgV3haAtGTdB0LH492H/g
         tnFPN+k4sObUPr8XYZaAxDMevIG02HiaO09sA8oN6jeOYaDd9pD9reN7rEjfXdWPhrcE
         22fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q8gOUdE50UNp9LhAlhCoddse7EZKmhUhGDFbU73aCc4=;
        b=Ek0BpO6GP+BtcAlbM4VX7Wzlpx4TOK9u+MkOkjrKW6WcgHY9nz0JvtjZ1PvFMph81J
         6OHKtrN5Ni58lftz3pkKiRiQcn1bE0xkPSYCORrxhOC0KcYkh0uAx7rHCcvrnkOtdU7N
         /Kg/fFhDawA+TNB5dssp8DIXbH2uk7DYBYr0a9Mcx6UT83L+wC+tMPNz9fDXs7RzMRuN
         zKbS1SCOSEY4NX/Y9h4W3wQI0m7t1HzzqWYI2aiRVe2Q3Ktr8tupjzvmK5ajuixGdV0C
         VYMHwO7lFJSoL8ceJk2KKnTGoMvwEWwg9IFYivoFclnJairKVXoJFVtyPJVc8l9RxeyZ
         enRw==
X-Gm-Message-State: AOAM532tNLIgFFlTSTunlxDGeDweka+FbBeBkAKOK2zpjYiC4TASo8G+
        YbSJS4DgkgAOXcd80GaYpUUWqvqHQtSsCYa2EXHcBg==
X-Google-Smtp-Source: ABdhPJwUnQsFATKp5CduacMlqRJgBHibGCWUhJq78mdMhVMEWJEhUC+nU/NhEqVFi56Uab8rCE8D+QUrCHC/kVrYF4o=
X-Received: by 2002:a17:907:c15:: with SMTP id ga21mr69757557ejc.472.1609820338819;
 Mon, 04 Jan 2021 20:18:58 -0800 (PST)
MIME-Version: 1.0
References: <160697689204.605323.17629854984697045602.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <160697689204.605323.17629854984697045602.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 4 Jan 2021 20:18:52 -0800
Message-ID: <CAPcyv4hdrYFCO6xXv0wfM4DFCyGAeYDETJwmJVOOtsJSKwEjNA@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: Fix leak of pmd ptlock
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     stable <stable@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Yi Zhang <yi.zhang@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ping, this bug is still present on v5.11-rc2, need a resend?

On Wed, Dec 2, 2020 at 10:28 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Commit 28ee90fe6048 ("x86/mm: implement free pmd/pte page interfaces")
> introduced a new location where a pmd was released, but neglected to run
> the pmd page destructor. In fact, this happened previously for a
> different pmd release path and was fixed by commit:
>
> c283610e44ec ("x86, mm: do not leak page->ptl for pmd page tables").
>
> This issue was hidden until recently because the failure mode is silent,
> but commit:
>
> b2b29d6d0119 ("mm: account PMD tables like PTE tables")
>
> ...turns the failure mode into this signature:
>
>  BUG: Bad page state in process lt-pmem-ns  pfn:15943d
>  page:000000007262ed7b refcount:0 mapcount:-1024 mapping:0000000000000000 index:0x0 pfn:0x15943d
>  flags: 0xaffff800000000()
>  raw: 00affff800000000 dead000000000100 0000000000000000 0000000000000000
>  raw: 0000000000000000 ffff913a029bcc08 00000000fffffbff 0000000000000000
>  page dumped because: nonzero mapcount
>  [..]
>   dump_stack+0x8b/0xb0
>   bad_page.cold+0x63/0x94
>   free_pcp_prepare+0x224/0x270
>   free_unref_page+0x18/0xd0
>   pud_free_pmd_page+0x146/0x160
>   ioremap_pud_range+0xe3/0x350
>   ioremap_page_range+0x108/0x160
>   __ioremap_caller.constprop.0+0x174/0x2b0
>   ? memremap+0x7a/0x110
>   memremap+0x7a/0x110
>   devm_memremap+0x53/0xa0
>   pmem_attach_disk+0x4ed/0x530 [nd_pmem]
>   ? __devm_release_region+0x52/0x80
>   nvdimm_bus_probe+0x85/0x210 [libnvdimm]
>
> Given this is a repeat occurrence it seemed prudent to look for other
> places where this destructor might be missing and whether a better
> helper is needed. try_to_free_pmd_page() looks like a candidate, but
> testing with setting up and tearing down pmd mappings via the dax unit
> tests is thus far not triggering the failure. As for a better helper
> pmd_free() is close, but it is a messy fit due to requiring an @mm arg.
> Also, ___pmd_free_tlb() wants to call paravirt_tlb_remove_table()
> instead of free_page(), so open-coded pgtable_pmd_page_dtor() seems the
> best way forward for now.
>
> Fixes: 28ee90fe6048 ("x86/mm: implement free pmd/pte page interfaces")
> Cc: <stable@vger.kernel.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: x86@kernel.org
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Co-debugged-by: Matthew Wilcox <willy@infradead.org>
> Tested-by: Yi Zhang <yi.zhang@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/x86/mm/pgtable.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index dfd82f51ba66..f6a9e2e36642 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -829,6 +829,8 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
>         }
>
>         free_page((unsigned long)pmd_sv);
> +
> +       pgtable_pmd_page_dtor(virt_to_page(pmd));
>         free_page((unsigned long)pmd);
>
>         return 1;
>
