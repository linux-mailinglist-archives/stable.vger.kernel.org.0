Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBF5109C2B
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 11:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfKZKTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 05:19:31 -0500
Received: from mail.skyhub.de ([5.9.137.197]:33128 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727688AbfKZKTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 05:19:31 -0500
Received: from zn.tnic (p200300EC2F0EC20064FC04F570E1B7F9.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:c200:64fc:4f5:70e1:b7f9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 921071EC0CCE;
        Tue, 26 Nov 2019 11:19:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1574763569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=haVL+dkqsD/o7fe1hvHolTBqze2NBMzLiLmc9pvNU5E=;
        b=YBGK7122KKv+pHSfXF4Nwx5xHHfiSMzlTEfMJXb9+KAbDN/iFLTKEzGDxd4hIEtnXjNTfd
        YcI29/8Y5/h1foaydwS0LSLaxSLVFYkHzAvCrp7ISDjqHTwU2BH0iKqX3OlffH6aLRMtRz
        nQy3NNgjWWz9U0/xyEofvo1LCiiMeS0=
Date:   Tue, 26 Nov 2019 11:19:22 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH -tip] x86/mm/32: Sync only to LDT_BASE_ADDR in
 vmalloc_sync_all()
Message-ID: <20191126101922.GB31379@zn.tnic>
References: <20191126100942.13059-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191126100942.13059-1-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 26, 2019 at 11:09:42AM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> When vmalloc_sync_all() iterates over the address space until
> FIX_ADDR_TOP it will sync the whole kernel address space starting from
> VMALLOC_START.
> 
> This is not a problem when the kernel address range is identical in
> all page-tables, but this is no longer the case when PTI is enabled on
> x86-32. In that case the per-process LDT is mapped in the kernel
> address range and vmalloc_sync_all() clears the LDT mapping for all
> processes.
> 
> To make LDT working again vmalloc_sync_all() must only iterate over
> the volatile parts of the kernel address range that are identical
> between all processes. This includes the VMALLOC and the PKMAP areas
> on x86-32.
> 
> The order of the ranges in the address space is:
> 
> 	VMALLOC -> PKMAP -> LDT -> CPU_ENTRY_AREA -> FIX_ADDR
> 
> So the right check in vmalloc_sync_all() is "address < LDT_BASE_ADDR"
> to make sure the VMALLOC and PKMAP areas are synchronized and the LDT
> mapping is not falsely overwritten. the CPU_ENTRY_AREA and
> the FIXMAP area are no longer synced as well, but these
> ranges are synchronized on page-table creation time and do
> not change during runtime.
> 
> This change fixes the ldt_gdt selftest in my setup.
> 
> Fixes: 7757d607c6b3 ("x86/pti: AllowCONFIG_PAGE_TABLE_ISOLATION for x86_32")
> Cc: stable@vger.kernel.org
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/mm/fault.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reported-by: Borislav Petkov <bp@suse.de>
Tested-by: Borislav Petkov <bp@suse.de>

Thx Jörg!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
