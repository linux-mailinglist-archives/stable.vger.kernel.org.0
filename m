Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A968310A335
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 18:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbfKZRO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 12:14:26 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42060 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbfKZRO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 12:14:26 -0500
Received: by mail-wr1-f68.google.com with SMTP id a15so23405583wrf.9;
        Tue, 26 Nov 2019 09:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hJ+mySIKZE9YWQww3Oig0WCOhwfH8Gl6sLfsRd7dgOA=;
        b=Z8EmiFm6SeX3lT4w2Huk2NheYOE3OG8m79056nuuaErHIUPSSC7FE3MkAtcLatqCRI
         DGT0ISdlccrFlnjaITKVJHp7m1fa4LQBG6gwUVKGWbsQTOPZmOwGuVjWfh+dG00XjxeR
         f9UVS2+hLg4ryx+V3jxx5IFhBuBl7e2gfwB7DMlUYYFicjmB9lkFHxwmKn5JJXOYIRQ5
         zvTCAseoGIakNzrjU9/+i2JHUmX57kq2yGzpWJu2IMvZOv8EErtFt05gy2fqSYmH/gRb
         W1fVxQMxSDNNrJFIdziaeAm4LhLeuhaecX4dhYZnByjaBxdiVdb047pWHWS/O3QU4mCU
         xiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=hJ+mySIKZE9YWQww3Oig0WCOhwfH8Gl6sLfsRd7dgOA=;
        b=Lhb2+T3wM5ecDHKHD8xE/JbKbU0ygcm1fjwA1GoqqHQe3QD/cLe2Jl+IiN+wROxH9q
         dhy0snkYPtPloMEZdCpneW3qeZHvFJnfo2PCqxTae/VU2KrFAGNKbJGXAKE4mx9HoYtL
         NzJkJ6JDdI+VMzCrp9o2XXcD3DgFn7DHThcGngGcCDSiOUGUWlgnVhmJBUcfpW5rDoEI
         FZjmMM7XlolqGO+gpqI3od1M9RQiiHRPtYckdZRnnDVrTy47RKKgEVdddmxaXdi2upFi
         hgeCrBhSq0OhGnSsCuDdZq5CiSch/PuroXHHme6SF6OF9BDUOnWLqyvbnuckCwwz8JHS
         qu0w==
X-Gm-Message-State: APjAAAV/ltPJvb1/e1LyPqJNRQhBRw63x1FVDWrmUfCAz/Ceg7xjIDGA
        DwDcAbcS3drxvLZHLwUOy7vy0irU
X-Google-Smtp-Source: APXvYqzSAqyz0xqEcDhKNWq7dHM/jDKYKJSqTZdjOGh5UIOm/2LA7Fh+D3a7l0MS00ge0XTQsVgFlQ==
X-Received: by 2002:adf:ecc7:: with SMTP id s7mr3789882wro.54.1574788464404;
        Tue, 26 Nov 2019 09:14:24 -0800 (PST)
Received: from gmail.com (54033286.catv.pool.telekom.hu. [84.3.50.134])
        by smtp.gmail.com with ESMTPSA id f19sm16649587wrf.23.2019.11.26.09.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 09:14:23 -0800 (PST)
Date:   Tue, 26 Nov 2019 18:14:21 +0100
From:   Ingo Molnar <mingo@kernel.org>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH -tip, v2] x86/mm/32: Sync only to VMALLOC_END in
 vmalloc_sync_all()
Message-ID: <20191126171421.GB28423@gmail.com>
References: <20191126100942.13059-1-joro@8bytes.org>
 <20191126111119.GA110513@gmail.com>
 <20191126123043.GH21753@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126123043.GH21753@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Joerg Roedel <jroedel@suse.de> wrote:

> Hi Ingo,
> 
> On Tue, Nov 26, 2019 at 12:11:19PM +0100, Ingo Molnar wrote:
> > The vmalloc_sync_all() also iterating over the LDT range is buggy, 
> > because for the LDT the mappings are *intentionally* and fundamentally 
> > different between processes, i.e. not synchronized.
> 
> Yes, you are right, your patch description is much better, thanks for
> making it more clear and correct.
> 
> > Furthermore I'm not sure we need to iterate over the PKMAP range either: 
> > those are effectively permanent PMDs as well, and they are not part of 
> > the vmalloc.c lazy deallocation scheme in any case - they are handled 
> > entirely separately in mm/highmem.c et al.
> 
> I looked a bit at that, and I didn't find an explict place where the
> PKMAP PMD gets established. It probably happens implicitly on the first
> kmap() call, so we are safe as long as the first call to kmap happens
> before the kernel starts the first userspace process.

No, it happens during early boot, in permanent_kmaps_init():

        vaddr = PKMAP_BASE;
        page_table_range_init(vaddr, vaddr + PAGE_SIZE*LAST_PKMAP, pgd_base);

That page_table_range_init() will go from PKMAP_BASE to the last PKMAP, 
which on PAE kernels is typically 0xff600000...0xff800000, 2MB in size, 
taking up exactly one PMD entry.

This single pagetable page, covering 2MB of virtual memory via 4K 
entries, gets passed on to the mm/highmem.c code via:

        pkmap_page_table = pte;

The pkmap_page_table is mapped early on into init_mm, every task started 
after that with a new pgd inherits it, and the pmd entry never changes, 
so there's nothing to synchronize.

The pte entries within this single pagetable page do change frequently 
according to the kmap() code, but since the pagetable page is shared 
between all tasks and the TLB flushes are SMP safe, it's all synchronized 
by only modifying pkmap_page_table, as it should.

> But that is not an issue that should be handled by vmalloc_sync_all(), 
> as the name already implies that it only cares about the vmalloc range.

Well, hypothetically it could *accidentally* have some essentially effect 
on bootstrapping the PKMAP pagetables - I don't think that's so, based on 
the reading of the code, but only testing will tell for sure.

> So your change to only iterate to VMALLOC_END makes sense and we should 
> establish the PKMAP PMD at a defined place to make sure it exists when 
> we start the first process.

I believe that's done in permanent_kmaps_init().

> > Note that this is *completely* untested - I might have wrecked PKMAP in 
> > my ignorance. Mind giving it a careful review and a test?
> 
> My testing environment for 32 bit is quite limited these days, but I 
> tested it in my PTI-x32 environment and the patch below works perfectly 
> fine there and still fixes the ldt_gdt selftest.

Cool, thanks! I'll apply it with your Tested-by.

	Ingo
