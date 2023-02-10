Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B18F6924AD
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 18:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbjBJRjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 12:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbjBJRjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 12:39:19 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDFB7BFE1
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 09:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676050747; x=1707586747;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=V9bM2vfFegX3OT8PEyJIVBZb6rdModzJONhPulPp81Y=;
  b=K7MXbcf2kvE0xTqZMygD/9cQBsZSraz0YPXGPmmSqDI7RyjtMUJYqzyX
   HeRVoDn9AMNG+FY0IQ+38KQ5Vn2lsENP+WZYBfSBuVKzx28bhDUKukxWq
   vPay4a3udvVrdQT9slkRIL8vqwPDK23sgaXsrLRRVc/2IY55jpvQK9ma4
   Udk4PJvluPAmC+5i26HEiT+zjQaHEMWnO8DUMY/6ccY6iVh1FPd7gs0+5
   3SSaL7XCaaJ2mAOiDdZNFL2Ri6r4T0FIp56IvFqEiKIweAmwDrUaGtrkx
   MqGXx6IpBhzIle93+0ZVWLGO/WOn4AdaVlcn9X56E08LXVnukunEIwqgR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="392882816"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="392882816"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 09:38:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="617962986"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="617962986"
Received: from pbfische-mobl1.amr.corp.intel.com (HELO [10.209.127.157]) ([10.209.127.157])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 09:38:18 -0800
Message-ID: <cd7749f1-3b68-37d6-d90c-a090ac380322@intel.com>
Date:   Fri, 10 Feb 2023 09:38:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] x86/sev: Adjust the alignment of vaddr_end
Content-Language: en-US
To:     Pavan Kumar Paluri <papaluri@amd.com>, bp@alien8.de
Cc:     tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        hpa@zytor.com, brijesh.singh@amd.com, michael.roth@amd.com,
        thomas.lendacky@amd.com, venu.busireddy@oracle.com,
        Jason@zx2c4.com, x86@kernel.org,
        Nikunj Dadhania <nikunj.dadhania@amd.com>,
        stable@vger.kernel.org
References: <20230210165854.12146-1-papaluri@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230210165854.12146-1-papaluri@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/10/23 08:58, Pavan Kumar Paluri wrote:
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -648,8 +648,8 @@ static void pvalidate_pages(unsigned long vaddr, unsigned int npages, bool valid
>  	unsigned long vaddr_end;
>  	int rc;
>  
> -	vaddr = vaddr & PAGE_MASK;
> -	vaddr_end = vaddr + (npages << PAGE_SHIFT);
> +	vaddr_end = PAGE_ALIGN(vaddr + (npages << PAGE_SHIFT));
> +	vaddr = PAGE_ALIGN_DOWN(vaddr);

Could you folks please go take a look at all of the callers that call
into pvalidate_pages() and set_pages_state()?

I think part of the problem here is that the API is quite inconsistent.
There have been a few bugs in this area.  Ideally, if you have an
interface that deals in 'pages', then the addresses should be aligned
already before hitting that interface.

But, there are messes like this:

static inline void __init snp_memcpy(void *dst, void *src, size_t sz,
                                     unsigned long paddr, bool decrypt)
{
        unsigned long npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
	...
	early_snp_set_memory_shared((unsigned long)__va(paddr), paddr,
				    npages);

That's taking a theoretically unaligned 'paddr', page-aligning the size,
then passing the result into an 'npages' interface.  That makes zero
sense if, for instance, it tried to do:

	paddr = 0x0fff
	sz = 2

That would pass along:

	paddr = 0x0fff
	npages = 1

npages (the effective end address) is aligned, but paddr is not.

We can keep on hacking around these bugs as they present themselves
one-by-one.  Could you look a bit more widely, please, and see if
there's something more fundamental that should be done?
