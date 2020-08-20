Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5558E24C673
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 21:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgHTT6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 15:58:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:59267 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbgHTT6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 15:58:12 -0400
IronPort-SDR: FsrGtP93efUMa9jhdiFWhFrUVwLTzFpCy7rFlGZ5Y6p2ECj/P6uSoLGFSnHZX0llEalwooJGbk
 pDiMjTC8Sn5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9718"; a="152810177"
X-IronPort-AV: E=Sophos;i="5.76,334,1592895600"; 
   d="scan'208";a="152810177"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2020 12:58:12 -0700
IronPort-SDR: 7ff5AW1OqJFyIq9w0Y0w/6okfpx2Z6o8s+b+Kgv9kt9JBCuS0bhUtg2F5m17yH+1gocNNLuzQ4
 me8rXcGpPHGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,334,1592895600"; 
   d="scan'208";a="497741219"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by fmsmga006.fm.intel.com with ESMTP; 20 Aug 2020 12:58:11 -0700
Date:   Thu, 20 Aug 2020 12:58:11 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Evan Green <evgreen@chromium.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Srikanth Nandamuri <srikanth.nandamuri@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH] x86/hotplug: Silence APIC only after all irq's are
 migrated
Message-ID: <20200820195811.GA22799@otc-nc-03>
References: <20200814213842.31151-1-ashok.raj@intel.com>
 <CAE=gft6fQ7cLQO025TDYNF-d6xxMeGkOHVieMZDq6wAZ84NsGQ@mail.gmail.com>
 <20200817183322.GA11486@araj-mobl1.jf.intel.com>
 <CAE=gft6D_1NWVczfO3JFhwCGeYBKsUUtt03TrtgWVViOVgP=4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE=gft6D_1NWVczfO3JFhwCGeYBKsUUtt03TrtgWVViOVgP=4w@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 11:21:24AM -0700, Evan Green wrote:
> > >
> > > I'm slightly unclear about whether interrupts are disabled at the core
> > > by this point or not. I followed native_cpu_disable() up to
> > > __cpu_disable(), up to take_cpu_down(). This is passed into a call to
> > > stop_machine_cpuslocked(), where interrupts get disabled at the core.
> > > So unless there's another path, it seems like interrupts are always
> > > disabled at the core by this point.
> >
> > local_irq_disable() just does cli() which allows interrupts to trickle
> > in to the IRR bits, and once you do sti() things would flow back for
> > normal interrupt processing.
> >
> >
> > >
> > > If interrupts are always disabled, then the comment above is a little
> >
> > Disable interrupts is different from disabling LAPIC. Once you do the
> > apic_soft_disable(), there is nothing flowing into the LAPIC except
> > for INIT, NMI, SMI and SIPI messages.
> >
> > This turns off the pipe for all other interrupts to enter LAPIC. Which
> > is different from doing a cli().
> 
> I understand the distinction. I was mostly musing on the difference in
> behavior your change causes if this function is entered with
> interrupts enabled at the core (ie sti()). But I think it never is, so
> that thought is moot.
> 
> I could never repro the issue reliably on comet lake after Thomas'
> original fix. But I can still repro it easily on jasper lake. And this
> patch fixes the issue for me on that platform. Thanks for the fix.
> 
> Reviewed-by: Evan Green <evgreen@chromium.org>
> Tested-by: Evan Green <evgreen@chromium.org>

Thanks Evan for testing. I'll wait for thomas if he finds anything else
that needs to be fixed and send a final v2 after fixing the typos and
others identified by Randy. 

Cheers,
Ashok
