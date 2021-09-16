Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE63140DE00
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 17:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239167AbhIPPcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 11:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239172AbhIPPcE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 11:32:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 431EA6121F;
        Thu, 16 Sep 2021 15:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631806243;
        bh=I0QaK/2rbPrDUqCwKDAgD9k9kSWTb+OYUzIOH/5tHyE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ahMad47Tp6ix1LHEXj8scA8cWHbqXa6tKiGjeK/GGxTwbxNOrsYFrAySpAj750Qwo
         ZrfGbO7YyrSrRWkbBk3hUXdoQzavfQftNQsmEMqE4Ui4a4McaNS9z8mQ7YkfpyI1qv
         x5cyj5ztgDYPxJCvPE4Xe8xUgwpV5lAIBVF2frjQtyujSuTuO6zpys+VHwm2so2BO9
         P3YxnCptpn8ZPLCbbi2BRLAacxxiqPXYFgyWlHtVshJPfk1+O0+dqCsxZLPj8Kw+PJ
         Yb7ytTSHc0CIYI49J8OXP5efmtrQVf29T0Nj9JrI1ZgTKf2G/4Td/xLCJbnCFJVkgm
         pTthCaQScU9Kg==
Date:   Thu, 16 Sep 2021 08:30:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     x86@kernel.org, jose.souza@intel.com, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, tglx@linutronix.de, kai.heng.feng@canonical.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com, stable@vger.kernel.org,
        paulmck@kernel.org
Subject: Re: [PATCH] x86/intel: Disable HPET on another Intel Coffee Lake
 platform
Message-ID: <20210916083042.5f63163a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210916150707.GA1611532@bjorn-Precision-5520>
References: <20210916131739.1260552-1-kuba@kernel.org>
        <20210916150707.GA1611532@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Sep 2021 10:07:07 -0500 Bjorn Helgaas wrote:
> On Thu, Sep 16, 2021 at 06:17:39AM -0700, Jakub Kicinski wrote:
> > My Lenovo T490s with i7-8665U had been marking TSC as unstable
> > since v5.13, resulting in very sluggish desktop experience...  
> 
> Including the actual dmesg log line here might help others locate this
> fix.

Good point, will add in v2.

clocksource: timekeeping watchdog on CPU3: hpet read-back delay of 316000ns, attempt 4, marking unstable
tsc: Marking TSC unstable due to clocksource watchdog
TSC found unstable after boot, most likely due to broken BIOS. Use 'tsc=unstable'.
sched_clock: Marking unstable (14539801827657, -530891666)<-(14539319241737, -48307500)
clocksource: Checking clocksource tsc synchronization from CPU 3 to CPUs 0-2,6-7.
clocksource: Switched to clocksource hpet

> > I have a 8086:3e34 bridge, also known as "Host bridge: Intel
> > Corporation Coffee Lake HOST and DRAM Controller (rev 0c)".
> > Add it to the list.
> > 
> > We should perhaps consider applying this quirk more widely.
> > The Intel documentation does not list my device [1], but
> > linuxhw [2] does, and it seems to list a few more bridges
> > we do not currently cover (3e31, 3ecc, 3e35, 3e0f).  
> 
> In the fine tradition of:
> 
>   e0748539e3d5 ("x86/intel: Disable HPET on Intel Ice Lake platforms")
>   f8edbde885bb ("x86/intel: Disable HPET on Intel Coffee Lake H platforms")
>   fc5db58539b4 ("x86/quirks: Disable HPET on Intel Coffe Lake platforms")
>   62187910b0fc ("x86/intel: Add quirk to disable HPET for the Baytrail plat form")
> 
> This seems to be an ongoing issue, not just a point defect in a single
> product, and I really hate the onesy-twosy nature of this.

Indeed. Or at least cover all Coffee Lakes in one fell swoop.

> Is there really no way to detect this issue automatically or fix
> whatever Linux bug makes us trip over this?  I am no clock expert, so
> I have absolutely no idea whether this is possible.

I'm deferring to clock experts. Paul mentioned he has some prototype
patches that may help.

> > [1] https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/8th-gen-core-family-datasheet-vol-2.pdf
> > [2] https://github.com/linuxhw/DevicePopulation/blob/master/README.md
> > 
> > Cc: stable@vger.kernel.org # v5.13+  
> 
> How did you pick v5.13?  force_disable_hpet() was added by
> 62187910b0fc ("x86/intel: Add quirk to disable HPET for the Baytrail
> platform"), which appeared in v3.15.

Erm, good question, it started happening for me (and others with the
same laptop) with v5.13. I just sort of assumed it was 2e27e793e280
("clocksource: Reduce clocksource-skew threshold"). 

It usually takes  a day to repro (4 hours was the quickest repro I've
seen) so bisection was kind of out of question.
