Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B11117735
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 21:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfLIURN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 15:17:13 -0500
Received: from mga05.intel.com ([192.55.52.43]:33839 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbfLIURN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 15:17:13 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 12:17:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,296,1571727600"; 
   d="scan'208";a="244585491"
Received: from nshalmon-mobl.ger.corp.intel.com (HELO localhost) ([10.252.8.146])
  by fmsmga002.fm.intel.com with ESMTP; 09 Dec 2019 12:17:09 -0800
Date:   Mon, 9 Dec 2019 22:17:07 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org, James Morris <jmorris@namei.org>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] tpmdd updates for Linux v5.4
Message-ID: <20191209201707.GI19243@linux.intel.com>
References: <20190902143121.pjnykevzlajlcrh6@linux.intel.com>
 <CAA9_cmeLnHK4y+usQaWo72nUG3RNsripuZnS-koY4XTRC+mwJA@mail.gmail.com>
 <20191127205800.GA14290@linux.intel.com>
 <20191127205912.GB14290@linux.intel.com>
 <20191128012055.f3a6gq7bjpvuierx@cantor>
 <20191129235322.GB21546@linux.intel.com>
 <20191130001253.rtovohtfbg25uifm@cantor>
 <20191206211834.GD9971@linux.intel.com>
 <20191206230255.mhinntfevp6vdlkj@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206230255.mhinntfevp6vdlkj@cantor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 06, 2019 at 04:02:55PM -0700, Jerry Snitselaar wrote:
> On Fri Dec 06 19, Jarkko Sakkinen wrote:
> > On Fri, Nov 29, 2019 at 05:12:53PM -0700, Jerry Snitselaar wrote:
> > > On Sat Nov 30 19, Jarkko Sakkinen wrote:
> > > > On Wed, Nov 27, 2019 at 06:20:55PM -0700, Jerry Snitselaar wrote:
> > > > > There also was that other issue reported on the list about
> > > > > tpm_tis_core_init failing when calling tpm_get_timeouts due to the
> > > > > power gating changes.
> > > >
> > > > Please add a (lore.ko) link for reference to this thread.
> > > >
> > > > /Jarkko
> > > >
> > > 
> > > https://lore.kernel.org/linux-integrity/a60dadce-3650-44ce-8785-2f737ab9b993@www.fastmail.com/
> > 
> > tpm_chip_stop() probably causes the issue. That is why tpm2_probe()
> > works and failure happens after that.
> > 
> > tpm_chip_stop() should be called once at the end of the function.
> > 
> 
> The patch I posted that fixed the issue for him moved the
> tpm_chip_start() from the irq probing section right below there to
> before the tpm_get_timeouts call, but your idea is better.

Yes, the chip can be reserved for the whole course of the function
because it is single user at that point.

> Any thoughts on the irq issue? I need to go back and look at the older
> commits again, but before Stefan's patch enabling the irq flag I'm not
> sure the last time that testing code section in tpm_tis_send was
> actually used. I think prior to that it always just went straight to
> tpm_tis_send_main.

I'd prefer to look it up with the fix for start/stop because it is
a regression on its own and mixed effect is not great way to analyze
anything.

So what we need is a T490S owner to provide klog with the fix applied.

/Jarkko
