Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4B840EFE0
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243014AbhIQC6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234959AbhIQC6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:58:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7693361029;
        Fri, 17 Sep 2021 02:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631847435;
        bh=wXfezIYFvZgcQF1nZ2xu2i1izDR8x/hqdRQ/ircZFaY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Myv1BsjhMe1eklE1rtC3/QkxrP6gwsCXkyPdMkm5PUZyd2AgHrEkr6AR/UxAADoKb
         RVzh9cql/mknQrotoHSXz4yClqOFn7IYA4pGB/fyitZlkx+IH8p8uOy504MiDzconB
         amRothnKheOt4bSXC9zPS0JM4zE4dg8B07BTjTsB0y3P1jyNsGA+NT2lr3A9a9PpzN
         QBL96/DKnQQawmvnssOqpLHGk6ZwZ02sHx2bPR1CjckA9vASUBSdbt3KM40knTMdjC
         kBoxTowvpkc5OpIWpcM6b+odBLWbvnLv0Vr3IdODtekRG5FVyqD2twZVFO6vJIskTd
         Y0XhlLFpepFZw==
Date:   Thu, 16 Sep 2021 19:57:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, x86@kernel.org,
        jose.souza@intel.com, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, tglx@linutronix.de, kai.heng.feng@canonical.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com, stable@vger.kernel.org
Subject: Re: [PATCH] x86/intel: Disable HPET on another Intel Coffee Lake
 platform
Message-ID: <20210916195713.289a7889@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210916163547.GD4156@paulmck-ThinkPad-P17-Gen-1>
References: <20210916131739.1260552-1-kuba@kernel.org>
        <20210916150707.GA1611532@bjorn-Precision-5520>
        <20210916083042.5f63163a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210916163547.GD4156@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Sep 2021 09:35:47 -0700 Paul E. McKenney wrote:
> > > How did you pick v5.13?  force_disable_hpet() was added by
> > > 62187910b0fc ("x86/intel: Add quirk to disable HPET for the Baytrail
> > > platform"), which appeared in v3.15.  
> > 
> > Erm, good question, it started happening for me (and others with the
> > same laptop) with v5.13. I just sort of assumed it was 2e27e793e280
> > ("clocksource: Reduce clocksource-skew threshold"). 
> > 
> > It usually takes  a day to repro (4 hours was the quickest repro I've
> > seen) so bisection was kind of out of question.  
> 
> OK, so this is an intermittent condition where HPET is sometimes slow to
> access for a short period of time?  If that is the case, my thought is
> to set the clocksource to be reinitialized (without a splat and without
> marking the clocksource unstable), and to splat (and mark the clocksource
> unstable) if it is not get a good read after 100 subsequent attempts.
> 
> So as long as the period of slowness lasts for less than 50 seconds,
> things would work fine.
> 
> Seem reasonable?

Could well be. Initially I thought it was suspend/resume related, then
I looked closer and it did happen mostly after resume... but anywhere
between 20 minutes to few hours after the resume.

I'm here to test less crude patches but since that may take some time
I'd hope we can get this merged and into stable ASAP. Hopefully it can
make it to 5.13 while that branch is alive and into Fedora. It really
makes Coffee Lake machines pretty much unusable.
