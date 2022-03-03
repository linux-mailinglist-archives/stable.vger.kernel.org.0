Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9861B4CC96B
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 23:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237082AbiCCWtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 17:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiCCWtT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 17:49:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0044E6582C;
        Thu,  3 Mar 2022 14:48:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A3B960F9F;
        Thu,  3 Mar 2022 22:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CF4C340EF;
        Thu,  3 Mar 2022 22:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646347711;
        bh=QNkCs3gq+fyss8gHFLQECcOqOecJIrrIXQgMYwTMW6Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J8EZ4Mm0v3P/T6UKhgqimMANFcVjSUEa7e3Of3826vKxZ0EfCsFRv1vcixUTHsMML
         zbPF2uqP6yYwjXGdfFKHq+2QrHzLMTCG+yYo8f0iS5u8XmwOhPxgy6UMjtvPZmsVV6
         vBaCyexpoNDu6MOoGcGuyvmcwHw2277P5XonWH3aR9e3GDt7G0Am0yrsHT2hjRpw+7
         f32P8ZaL8FC6Y3Wu1/cVf/Pg7hiZuBVZF04/5wZpX7VGkNTZ/JuVX+1HiHlzf4Fy93
         ZV9POMA8nZ/qUQReV4RTwrDiQnWyEXURkZDtL8IBrCbl1SIA5jEuV4q6I26V7bI6Sy
         lFCnI4MxTTWjA==
Date:   Fri, 4 Mar 2022 00:47:50 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
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
Subject: Re: [PATCH v5] x86/sgx: Free backing memory after faulting the
 enclave page
Message-ID: <YiFFlioG3E/JtFPY@iki.fi>
References: <20220301125836.3430-1-jarkko@kernel.org>
 <3a083b4d-9645-dec6-8cdc-481429dd0a1f@intel.com>
 <Yh7LUU401weiq0ew@iki.fi>
 <1f06eb77-1c08-33f6-d784-8eeee25f6f6a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f06eb77-1c08-33f6-d784-8eeee25f6f6a@intel.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 02, 2022 at 08:40:29AM -0800, Dave Hansen wrote:
> On 3/1/22 17:41, Jarkko Sakkinen wrote:
> > On Tue, Mar 01, 2022 at 09:54:14AM -0800, Dave Hansen wrote:
> >> On 3/1/22 04:58, Jarkko Sakkinen wrote:
> >>> @@ -32,14 +58,16 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >>>  	else
> >>>  		page_index = PFN_DOWN(encl->size);
> >>>  
> >>> +	page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
> >>> +
> >>>  	ret = sgx_encl_lookup_backing(encl, page_index, &b);
> >>>  	if (ret)
> >>>  		return ret;
> >> What tree is this against?  It looks like it might be on top of
> >> Kristen's overcommit series.
> >>
> >> It would be best if you could test this on top of tip/sgx.  Kristen
> >> changed code in this area as well.
> > I rebased this against latest stuff and now I did a sanity check:
> > 
> > $ git fetch tip
> > remote: Enumerating objects: 75, done.
> > remote: Counting objects: 100% (75/75), done.
> > remote: Compressing objects: 100% (12/12), done.
> > remote: Total 77 (delta 65), reused 65 (delta 63), pack-reused 2
> > Unpacking objects: 100% (77/77), 34.07 KiB | 157.00 KiB/s, done.
> >>From git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> >    161a9a33702a..cedd3614e5d9  perf/core  -> tip/perf/core
> >    6255b48aebfd..25795ef6299f  sched/core -> tip/sched/core
> > 
> > $ git rebase tip/x86/sgx 
> > Current branch master is up to date.
> 
> Are you sure you didn't also rebase all of Kristen's work along with
> your one patch?  How many patches did you rebase?
> 
> You might want to do:
> 
> 	git log tip/x86/sgx..

I did "git reset --hard tip/x86/sgx" and reapplied patch, and fixed the
merge conflict, i.e. "lookup" to "get" :-) You're right.

BR, Jarkko
