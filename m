Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1685854AD
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 19:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbiG2RpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 13:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiG2RpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 13:45:24 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804096A49F;
        Fri, 29 Jul 2022 10:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659116723; x=1690652723;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dg2oEUXQjesKyq4mqy/LM3/pJlZaSHEjJ/Zzh7Iz+r0=;
  b=TlFvqxNoOaBg0qHwOuaygQ9zoLvc7gvZsrcldOpHwQmQ7nuVNk9o4IgS
   Y/bHT7gEIq0e6M8qRSdNatYXEV35NPRnbaL0b9Y59t7/u75L6OZgp2Xiq
   WzxsIUxqWkJCpBIFMN7WJigSYCPIxR0So+vxcnHua2NuxOlHYbtBxqi+J
   n0E9zw2cD3mz34yUxydty9a+p+RulNA1uaOauMC2vQ+NR9TTneOrwfTOP
   OeSGYIjnoKER22oPwFhhGiv8Emk31vmOAh8iTRj+OYodHGETmdmhrliLB
   RA7QBD6gH49E2sGDIhDizzgYCuuIc0z/9XbfaYMVw3HZplTM9FEy5khFD
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="275701539"
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="275701539"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 10:45:23 -0700
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="551809239"
Received: from aahmedsi-mobl.amr.corp.intel.com (HELO desk) ([10.209.118.55])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 10:45:22 -0700
Date:   Fri, 29 Jul 2022 10:45:21 -0700
From:   'Pawan Gupta' <pawan.kumar.gupta@linux.intel.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     Borislav Petkov <bp@alien8.de>, Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "antonio.gomez.iglesias@linux.intel.com" 
        <antonio.gomez.iglesias@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Subject: Re: [RESEND RFC PATCH] x86/bugs: Add "unknown" reporting for MMIO
 Stale Data
Message-ID: <20220729174521.kvbudqlpsoyvxzrv@desk>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
 <YuJ6TQpSTIeXLNfB@zn.tnic>
 <20220729022851.mdj3wuevkztspodh@desk>
 <e7ba00885fca4ec9849d8525cbc46f7b@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7ba00885fca4ec9849d8525cbc46f7b@AcuMS.aculab.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 29, 2022 at 10:40:20AM +0000, David Laight wrote:
> From: Pawan Gupta
> > Sent: 29 July 2022 03:29
> > 
> > On Thu, Jul 28, 2022 at 02:00:13PM +0200, Borislav Petkov wrote:
> > > On Thu, Jul 14, 2022 at 06:30:18PM -0700, Pawan Gupta wrote:
> > > > Older CPUs beyond its Servicing period are not listed in the affected
> > > > processor list for MMIO Stale Data vulnerabilities. These CPUs currently
> > > > report "Not affected" in sysfs, which may not be correct.
> 
> I looked this up....
> 
> The mitigations seem to rely on unprivileged code not being able
> to do MMIO accesses.
> That isn't true, device drivers can mmap PCIe addresses directly
> into user program address space.
> While unlikely, there is no reason this can't be supported for
> non-root processes.

Agree. Would it be fair to assume that processes that get direct
hardware access are trusted?
