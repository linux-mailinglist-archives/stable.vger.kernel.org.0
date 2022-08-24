Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB405A019F
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 20:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238223AbiHXSxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 14:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235430AbiHXSxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 14:53:52 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7871C7B78F;
        Wed, 24 Aug 2022 11:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661367231; x=1692903231;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yaInQXGMxPy/U9mnFtXLRZ4xzYSYO86IjKv3UMnKCgk=;
  b=iTr7zUzd7RnuOHHnx+V29btfuN82eTWw1XRNU+XdgMZcPIbroGbLSbuD
   w+34VbS8Bc8oDYVP8TO/MeD4X1OGf0c7taTOY1wghGZTBOoxovP+dfXiH
   EHIVCEodECpvwxMtcSVuByACZiJBwyAqB2mq7NSII1og5e+NYJWAk0RvB
   H4LOLBeM5XwsVV4PFN/N0RQee/8Q8gYEZbu8pf38SbnxZHXtMOaxfj2yu
   bpgNbZle6O0pxlLgobkQl1RA3DA2zvaiQTv9kP3nQDqz/9CFdNkcra0/f
   Jkwywb1RJwSI/eYd0P+A6ULDg+RPTa6GjSCdqMGUV59JZjUKtAkzpu73u
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="273803143"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="273803143"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 11:53:51 -0700
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="938024615"
Received: from skeshri-mobl.ger.corp.intel.com (HELO [10.212.154.182]) ([10.212.154.182])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 11:53:50 -0700
Message-ID: <c6d89f21-b914-a7c1-d34c-dd083185d18b@intel.com>
Date:   Wed, 24 Aug 2022 11:53:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] x86/sev: Don't use cc_platform_has() for early SEV-SNP
 calls
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Asish Kalra <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>
References: <0c9b9a6c33ff4b8ce17a87a6c09db44d3b52bad3.1661291751.git.thomas.lendacky@amd.com>
 <10bc452f-3564-e41b-836d-e135a8f4260d@intel.com> <YwZyjE6BmnvxHXcR@zn.tnic>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <YwZyjE6BmnvxHXcR@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/24/22 11:48, Borislav Petkov wrote:
> On Wed, Aug 24, 2022 at 11:43:10AM -0700, Dave Hansen wrote:
>> So, we don't have *ANY* control over where the compiler uses jump
>> tables.  The kernel just happened to add some code that uses them, fell
>> over, and this adds a hack to get booting again.
>>
>> Isn't this a bigger problem?
> I had the same question already. Was thinking of maybe disabling
> the compiler from producing jump tables in the ident-mapped code.
> Tom's argument is that that might prevent the compiler from doing
> optimizations but I haven't talked to compiler folks whether those
> optimizations are even worth the effort.
> 
> Regardless, the potential problem is limited:
> 
> "# (jump-tables are implicitly disabled by RETPOLINE)"

Ahh, I missed the connection with retpoline.  The ubiquity of
RETPOLINE=y probably means we'll see more of these issues because people
won't find them unless they're building and running weirdo configurations.

> i.e., only RETPOLINE=n builds for now which should be a minority?
> 
> I guess when this explodes somewhere else again, we will have to
> generalize a fix.

Yep.  It also reminds me to add RETPOLINE=n build to my tests.
