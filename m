Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CFE54E340
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 16:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbiFPOUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 10:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377153AbiFPOUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 10:20:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6F23B3EF;
        Thu, 16 Jun 2022 07:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655389240; x=1686925240;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3lBsGFfL5N6NyfcA2AMIV2yhCK5s/sysL3/tFfQ+p+0=;
  b=gRwE1I5FYojmK3j4eIjefPOn4FhmgwSFGCoRackDG3dzcrgWzVGaD3Kv
   Q2q4PsFDoCRBH6z+u65V+AMZNW5eaWKiaFymllAk1fO+ye8anHqfRIXZS
   AFaMaq2tMGUFCdH11gyyr7JVaH9vpI2fAdddtsWjbJrNkmyMdsHO4BwO8
   jajsOkkPhXyAEcJEOQYFtx2BSSgG5k59sCedKhVAHKRtPOVCyFw7OUK/7
   rlgQaYj4KYlz7LJE30JxJ+h8V6MHbS384WH4K4kqf1xJ16DZUrUhfJF9C
   S6tLgt5I/mVXdQ9kVML0t6LmkdPQAfHM52UPQOk8smMjxfMcsas1eUb86
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259720740"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="259720740"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 07:20:40 -0700
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="641563105"
Received: from rrmiller-mobl.amr.corp.intel.com (HELO [10.212.205.54]) ([10.212.205.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 07:20:39 -0700
Message-ID: <8e2c9b2b-d8ad-5e9a-7aa6-23e0c599c2e9@intel.com>
Date:   Thu, 16 Jun 2022 07:20:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] x86/mm: Fix possible index overflow when creating page
 table mapping
Content-Language: en-US
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     bhe@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
        luto@kernel.org, mingo@redhat.com, peterz@infradead.org,
        stable@vger.kernel.org, tglx@linutronix.de, x86@kernel.org
References: <3e754cf7-35f8-0163-a24a-063fa3d96718@intel.com>
 <20220616141525.1790083-1-ytcoode@gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220616141525.1790083-1-ytcoode@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/16/22 07:15, Yuntao Wang wrote:
> On Thu, 16 Jun 2022 07:02:56 -0700, Dave Hansen wrote:
>> On 6/16/22 06:55, Yuntao Wang wrote:
>>> There are two issues in phys_p4d_init():
>>>
>>> - The __kernel_physical_mapping_init() does not do boundary-checking for
>>>   paddr_end and passes it directly to phys_p4d_init(), phys_p4d_init() does
>>>   not do bounds checking either, so if the physical memory to be mapped is
>>>   large enough, 'p4d_page + p4d_index(vaddr)' will wrap around to the
>>>   beginning entry of the P4D table and its data will be overwritten.
>>>
>>> - The for loop body will be executed only when 'vaddr < vaddr_end'
>>>   evaluates to true, but if that condition is true, 'paddr >= paddr_end'
>>>   will evaluate to false, thus the 'if (paddr >= paddr_end) {}' block will
>>>   never be executed and become dead code.
>> Could you explain a bit how you found this?  Was this encountered in
>> practice and debugged or was it found by inspection?
> I found it by inspection.

Dare I ask how this was tested?
