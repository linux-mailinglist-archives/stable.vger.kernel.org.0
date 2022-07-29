Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171D9585729
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 01:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238670AbiG2XHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 19:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbiG2XHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 19:07:40 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0BD89E9F;
        Fri, 29 Jul 2022 16:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659136059; x=1690672059;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hGwXsBPfLbniIEZXPfhnODd25ALV2jQacZ1UuFVjN/A=;
  b=UJphJ9gURVgIECgKYoGf5W92RhRSxtEZx7zFIHBjpKFq8GOJu10wZOik
   bA8DJH9GigHP00EZIX5QPs6boA8zjbBCoJJ4FsblVlSjsaHjUmMlqLuvS
   FO7eiOQ/Qcvfd4DhIr0YiSLBiuYSmRWUhmV/3OpTxpVD5tUy3mXn28Krh
   EbDE1Z6L++Ms7SUeh+gl7RRL/st/qdB6zM1o6Awnu7qRmLgQc8/J5t9dS
   i9e4sVfuqheu1Q97iK7StWyOnWXuulR5Lqpex1GlM9HeP7UEMevx4NkQE
   mF/I9hez7i+09BR1SOowx8afSGzfSPXtSBD7XpAfyqWK4YdrkD3R7I5+Z
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="269247449"
X-IronPort-AV: E=Sophos;i="5.93,202,1654585200"; 
   d="scan'208";a="269247449"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 16:07:38 -0700
X-IronPort-AV: E=Sophos;i="5.93,202,1654585200"; 
   d="scan'208";a="629549660"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 16:07:38 -0700
Date:   Fri, 29 Jul 2022 16:07:36 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        andrew.cooper3@citrix.com, Josh Poimboeuf <jpoimboe@kernel.org>
Subject: Re: [RESEND RFC PATCH] x86/bugs: Add "unknown" reporting for MMIO
 Stale Data
Message-ID: <YuRoOCUxGUJ/8QVH@agluck-desk3.sc.intel.com>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
 <YuJ6TQpSTIeXLNfB@zn.tnic>
 <20220729022851.mdj3wuevkztspodh@desk>
 <YuPpKa6OsG9e9nTj@zn.tnic>
 <20220729173609.45o7lllpvsgjttqt@desk>
 <YuRDbuQPYiYBZghm@zn.tnic>
 <20220729214627.wowu5sny226c5pe4@desk>
 <1bcf0b54-6ddf-b343-87c5-f7fd7538759c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bcf0b54-6ddf-b343-87c5-f7fd7538759c@intel.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 29, 2022 at 03:54:58PM -0700, Dave Hansen wrote:
> On 7/29/22 14:46, Pawan Gupta wrote:
> > Let me see if there is a way to distinguish between 4. and 5. below:
> > 
> >    CPU category				  X86_BUG_MMIO_STALE_DATA	X86_BUG_MMIO_UNKNOWN
> > -----------------------------------------------------------------------------------------------
> > 1. Known affected (in cpu list)			1				0
> > 2. CPUs with HW immunity (MMIO_NO=1)		0				0
> > 3. Other vendors				0				0
> > 4. Older Intel CPUs				0				1
> > 5. Not affected current CPUs (but MMIO_NO=0)	0				?
> 
> This seems like something we would need to go back to our colleagues to
> figure out.  Basically, at the time of publishing the
> X86_BUG_MMIO_STALE_DATA papers, what was considered "older"?
> 
> In other words, we need the folks at Intel that did this good work to
> _show_ their work (at least part of it).

https://www.intel.com/content/www/us/en/developer/topic-technology/software-security-guidance/processors-affected-consolidated-product-cpu-model.html

Click to the 2022 tab. The MMIO affected/not-affected status is there
(you'll need to use the horizontal scroll to shift over to see those
columns).

This table lists all the CPUs that were not "older".

Any CPU not on that list is out of servicing period.

-Tony
