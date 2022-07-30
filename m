Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB51D585806
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 04:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239779AbiG3Cb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 22:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbiG3Cbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 22:31:55 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A03F5B0;
        Fri, 29 Jul 2022 19:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659148313; x=1690684313;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PcbwJg9Nq+orwj9qt2TIBWrJonHyULIKW9jq5xBZJlY=;
  b=DWC4JAFU8zH/m7E92G/WNCaD8kTAddLJ/K9O/Gsp56vkcWcYHKyEC7jG
   HyUFahuiZi1zgo/nUueelpxhAh21oF392wOSXkfUQfiicymXTqaZANiNv
   GlZDe6KesyjqxPqebyqmpJ/w6KoY7LE0qcqzws+qsl7da2ST/q+jCczE1
   SeI8vaZlUZuz52GE5WqeQf0LwvqaSAyNbED5JGRLbs8OwpSVE3X/FUwe+
   IAFv2BVOSDVVa6nZazpLceJjPA0NNn0ouC5MO8bVSCHE90FOp4oFFyNIJ
   RlAeUhITILNX/bO7m5usK67DpqvuWOcjz0HizKXMWwAxdF9Xz5lcIcbEa
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="286440000"
X-IronPort-AV: E=Sophos;i="5.93,202,1654585200"; 
   d="scan'208";a="286440000"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 19:31:53 -0700
X-IronPort-AV: E=Sophos;i="5.93,202,1654585200"; 
   d="scan'208";a="629589983"
Received: from unknown (HELO desk) ([10.252.135.102])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 19:31:52 -0700
Date:   Fri, 29 Jul 2022 19:31:51 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tony.luck@intel.com, antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        andrew.cooper3@citrix.com, Josh Poimboeuf <jpoimboe@kernel.org>
Subject: Re: [RESEND RFC PATCH] x86/bugs: Add "unknown" reporting for MMIO
 Stale Data
Message-ID: <20220730023151.kogebjrhsvhitklj@desk>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
 <YuJ6TQpSTIeXLNfB@zn.tnic>
 <20220729022851.mdj3wuevkztspodh@desk>
 <YuPpKa6OsG9e9nTj@zn.tnic>
 <20220729173609.45o7lllpvsgjttqt@desk>
 <YuRDbuQPYiYBZghm@zn.tnic>
 <20220729214627.wowu5sny226c5pe4@desk>
 <YuRY+rKaocoV8ECn@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuRY+rKaocoV8ECn@zn.tnic>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 30, 2022 at 12:02:34AM +0200, Borislav Petkov wrote:
> On Fri, Jul 29, 2022 at 02:46:27PM -0700, Pawan Gupta wrote:
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
> Not affected current CPUs should be arch_cap_mmio_immune() == true, no?

That would be true in most cases, with some exceptions like systems
that did not update the microcode.
