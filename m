Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3C11CE130
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 19:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730730AbgEKREX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 13:04:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:4823 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730644AbgEKREX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 13:04:23 -0400
IronPort-SDR: AmJ5/2N263ec4Pl3UD5ntKFil2WlprAZTg4CUgB15QwJuwfQGAmj+j1xkgm4swi8SgQPJytpdC
 +CU9oGWnZAaA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 10:04:22 -0700
IronPort-SDR: ntszgkceox0lWd12Jc20izlJKLdrnbmShfomhJ4hzbB6Oj5SjFqkAZE+RYvk92JPIrOM9Dn+2Y
 Ii6zUOil0Fwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,380,1583222400"; 
   d="scan'208";a="306233453"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 11 May 2020 10:04:20 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 0CAC1101; Mon, 11 May 2020 20:04:19 +0300 (EEST)
Date:   Mon, 11 May 2020 20:04:19 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, dave.hansen@linux.intel.com,
        linux-drivers-review@eclists.intel.com, stable@vger.kernel.org
Subject: Re: [linux-drivers-review] [PATCH] x86/mm: Fix boot with some memory
 above MAXMEM
Message-ID: <20200511170419.a53lgasfxd33nrk7@black.fi.intel.com>
References: <20200511163706.41619-1-kirill.shutemov@linux.intel.com>
 <4db011da-35b4-c6c0-aa35-54a28776169b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4db011da-35b4-c6c0-aa35-54a28776169b@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 09:43:30AM -0700, Dave Hansen wrote:
> On 5/11/20 9:37 AM, Kirill A. Shutemov wrote:
> > -		memblock_add(entry->addr, entry->size);
> > +		if (entry->addr >= MAXMEM || end >= MAXMEM)
> > +			pr_err_once("Some physical memory is not addressable in the paging mode.\n");
> 
> Hi Kirill,
> 
> Thanks for fixing this!
> 
> Could we make the pr_err() a bit more informative, though?  It would be
> nice to print out how much memory (or which addresses at least) are
> being thrown away.
> 
> I was also thinking that it would be handy to tell folks how to rectify
> the situation.  Should we perhaps dump out the runtime status of
> X86_FEATURE_LA57?

Something like this (incremental patch)?

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 022fe1de8940..172b4244069f 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1280,8 +1280,8 @@ void __init e820__memory_setup(void)
 
 void __init e820__memblock_setup(void)
 {
+	u64 size, end, not_addressable = 0;
 	int i;
-	u64 end;
 
 	/*
 	 * The bootstrap memblock region count maximum is 128 entries
@@ -1307,16 +1307,24 @@ void __init e820__memblock_setup(void)
 		if (entry->type != E820_TYPE_RAM && entry->type != E820_TYPE_RESERVED_KERN)
 			continue;
 
-		if (entry->addr >= MAXMEM || end >= MAXMEM)
-			pr_err_once("Some physical memory is not addressable in the paging mode.\n");
-
-		if (entry->addr >= MAXMEM)
+		if (entry->addr >= MAXMEM) {
+			not_addressable += entry->size;
 			continue;
+		}
 
 		end = min_t(u64, end, MAXMEM - 1);
+		size = end - entry->addr;
+		not_addressable += entry->size - size;
 		memblock_add(entry->addr, end - entry->addr);
 	}
 
+	if (not_addressable) {
+		pr_err("%lldMB of physical memory is not addressable in the paging mode\n",
+		       not_addressable >> 20);
+		if (!pgtable_l5_enabled())
+			pr_err("Consider enabling 5-level paging\n");
+	}
+
 	/* Throw away partial pages: */
 	memblock_trim_memory(PAGE_SIZE);
 
-- 
 Kirill A. Shutemov
