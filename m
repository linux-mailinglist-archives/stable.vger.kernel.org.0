Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B914CAAA4
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 17:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242506AbiCBQlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 11:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243299AbiCBQlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 11:41:22 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785EBCA0E5;
        Wed,  2 Mar 2022 08:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646239237; x=1677775237;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=WYdj9HsqlR6mD7UuAQBB90fXgHWVIMAG8azr7wg+GKA=;
  b=Xc1MICeFkY54mnnvgi1/7t2Hum902GFPZrtHLsZ1stEP6DXbmDHFrlEV
   2D81WfzWgVo5WofsNW3CiG61fQbD/lNd3xoeDqt3BzDRBDksLdC4z6vN8
   KPWCHV+AjlRG/2gMXAcZch11GTM81W/rbK10cSKiCWbUm15G/c5LYUQH8
   GoeOVpIYwji2336S412QOZ4WWdyDQSwNMYPNitu0RsiDy9Jmd9/P2I8BE
   3kV7dHWShOugbYBzDyJ0oPA5G6iugIvjPB1EnsKWhXJVs9sLL6bfVT0Fr
   kVdc7kRMO6V2sSSxwkMrxHVhJK8hgZr3sZVUhbuL2EFEoIodZ6FQLt63a
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251018458"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="251018458"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 08:40:36 -0800
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="511067040"
Received: from nagana-mobl.amr.corp.intel.com (HELO [10.252.142.107]) ([10.252.142.107])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 08:40:35 -0800
Message-ID: <1f06eb77-1c08-33f6-d784-8eeee25f6f6a@intel.com>
Date:   Wed, 2 Mar 2022 08:40:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20220301125836.3430-1-jarkko@kernel.org>
 <3a083b4d-9645-dec6-8cdc-481429dd0a1f@intel.com> <Yh7LUU401weiq0ew@iki.fi>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v5] x86/sgx: Free backing memory after faulting the
 enclave page
In-Reply-To: <Yh7LUU401weiq0ew@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/22 17:41, Jarkko Sakkinen wrote:
> On Tue, Mar 01, 2022 at 09:54:14AM -0800, Dave Hansen wrote:
>> On 3/1/22 04:58, Jarkko Sakkinen wrote:
>>> @@ -32,14 +58,16 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>>>  	else
>>>  		page_index = PFN_DOWN(encl->size);
>>>  
>>> +	page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
>>> +
>>>  	ret = sgx_encl_lookup_backing(encl, page_index, &b);
>>>  	if (ret)
>>>  		return ret;
>> What tree is this against?  It looks like it might be on top of
>> Kristen's overcommit series.
>>
>> It would be best if you could test this on top of tip/sgx.  Kristen
>> changed code in this area as well.
> I rebased this against latest stuff and now I did a sanity check:
> 
> $ git fetch tip
> remote: Enumerating objects: 75, done.
> remote: Counting objects: 100% (75/75), done.
> remote: Compressing objects: 100% (12/12), done.
> remote: Total 77 (delta 65), reused 65 (delta 63), pack-reused 2
> Unpacking objects: 100% (77/77), 34.07 KiB | 157.00 KiB/s, done.
>>From git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>    161a9a33702a..cedd3614e5d9  perf/core  -> tip/perf/core
>    6255b48aebfd..25795ef6299f  sched/core -> tip/sched/core
> 
> $ git rebase tip/x86/sgx 
> Current branch master is up to date.

Are you sure you didn't also rebase all of Kristen's work along with
your one patch?  How many patches did you rebase?

You might want to do:

	git log tip/x86/sgx..
