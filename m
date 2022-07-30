Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB3758580E
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 04:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiG3Ck2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 22:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiG3Ck0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 22:40:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA36E029;
        Fri, 29 Jul 2022 19:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659148824; x=1690684824;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZOfkkbSr9Kz9OSg2dqohMlXKgKNZ6vkhC5qYNXvx98E=;
  b=J9ynEbYt1Vg2WEgNXh62ZS0B/UdPKMpREX6UX+qAmgj1Z2j9I8Uwglx6
   XDkmAbsDrlIcVnik6i///4bL64f+2fBYo5jIB+VHQc0LgDlydpRL3bGLD
   0TnNH2Q7YkkQtHYepy/+q39XwIHLrHvQomDxAvH2nInZwZi0pshDcUxbE
   W1+G/XJDMWeUKuhm6/K1BYj2c0Pe9cbyF7LkbtDeSbceLvccC5+lcuS7o
   5ofGNPRSgoOO08pXLAKZI5DRtx9AlpynJ/GEcDBN1nG75yHygCVJMC31M
   ctMwBiVHl3Cq54nFtrk4TEeTefLZuNL5YQtjN49f9MNDTEJCQJumhRXfx
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="314693219"
X-IronPort-AV: E=Sophos;i="5.93,202,1654585200"; 
   d="scan'208";a="314693219"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 19:40:24 -0700
X-IronPort-AV: E=Sophos;i="5.93,202,1654585200"; 
   d="scan'208";a="777715583"
Received: from unknown (HELO desk) ([10.252.135.102])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 19:40:23 -0700
Date:   Fri, 29 Jul 2022 19:40:22 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Tony Luck <tony.luck@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
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
Message-ID: <20220730024022.dn2b66ecaqar5h4t@desk>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
 <YuJ6TQpSTIeXLNfB@zn.tnic>
 <20220729022851.mdj3wuevkztspodh@desk>
 <YuPpKa6OsG9e9nTj@zn.tnic>
 <20220729173609.45o7lllpvsgjttqt@desk>
 <YuRDbuQPYiYBZghm@zn.tnic>
 <20220729214627.wowu5sny226c5pe4@desk>
 <1bcf0b54-6ddf-b343-87c5-f7fd7538759c@intel.com>
 <YuRoOCUxGUJ/8QVH@agluck-desk3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuRoOCUxGUJ/8QVH@agluck-desk3.sc.intel.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 29, 2022 at 04:07:36PM -0700, Tony Luck wrote:
> On Fri, Jul 29, 2022 at 03:54:58PM -0700, Dave Hansen wrote:
> > On 7/29/22 14:46, Pawan Gupta wrote:
> > > Let me see if there is a way to distinguish between 4. and 5. below:
> > > 
> > >    CPU category				  X86_BUG_MMIO_STALE_DATA	X86_BUG_MMIO_UNKNOWN
> > > -----------------------------------------------------------------------------------------------
> > > 1. Known affected (in cpu list)			1				0
> > > 2. CPUs with HW immunity (MMIO_NO=1)		0				0
> > > 3. Other vendors				0				0
> > > 4. Older Intel CPUs				0				1
> > > 5. Not affected current CPUs (but MMIO_NO=0)	0				?
> > 
> > This seems like something we would need to go back to our colleagues to
> > figure out.  Basically, at the time of publishing the
> > X86_BUG_MMIO_STALE_DATA papers, what was considered "older"?
> > 
> > In other words, we need the folks at Intel that did this good work to
> > _show_ their work (at least part of it).
> 
> https://www.intel.com/content/www/us/en/developer/topic-technology/software-security-guidance/processors-affected-consolidated-product-cpu-model.html
> 
> Click to the 2022 tab. The MMIO affected/not-affected status is there
> (you'll need to use the horizontal scroll to shift over to see those
> columns).
> 
> This table lists all the CPUs that were not "older".
> 
> Any CPU not on that list is out of servicing period.

I thought about this option, this will require CPUs to be added to
whitelist too. If the maintainers wont hate it, I will go this route.
