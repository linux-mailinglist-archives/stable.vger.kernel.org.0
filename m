Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1D03EE681
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 08:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhHQGQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 02:16:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233676AbhHQGQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Aug 2021 02:16:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64DF660F5C;
        Tue, 17 Aug 2021 06:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629180984;
        bh=rIukTODKRHBI49BFyVKeyjRTgNsoIPhKluS8fDPo4fI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tjX2tSLHEdZGY0OmXv29xKI6ZmXFOQpIUO94amXD02Sjpm7RISgoL3ocC/q8lAlyf
         FHDusCNugkEI/ssyym2I9yKpSZIlUU7LIAK7ICMVmNncLnF9W5jkBtrCgAi4Cvg2Jz
         Q61nad2A2wzYQc7Q0B3A/VzGU5lWapIPZHMY92Zk=
Date:   Tue, 17 Aug 2021 08:16:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Chen <david.chen@nutanix.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "neeraju@codeaurora.org" <neeraju@codeaurora.org>
Subject: Re: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
Message-ID: <YRtUNtyom4DDaa5a@kroah.com>
References: <CO1PR02MB8489A10983A22C72447EEB5C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
 <YRq81jcZIH5+/ZpB@kroah.com>
 <CO1PR02MB8489899CD7101180B2759D9C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CO1PR02MB8489899CD7101180B2759D9C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 10:02:28PM +0000, David Chen wrote:
> 
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Monday, August 16, 2021 12:31 PM
> > To: David Chen <david.chen@nutanix.com>
> > Cc: stable@vger.kernel.org; Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com>; neeraju@codeaurora.org
> > Subject: Re: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
> > 
> > On Mon, Aug 16, 2021 at 07:19:34PM +0000, David Chen wrote:
> > > Hi Greg,
> > >
> > > We recently hit a hung task timeout issue in synchronize_rcu_expedited on
> > 4.14 branch.
> > > The issue seems to be identical to the one described in `fd6bc19d7676
> > > rcu: Fix missed wakeup of exp_wq waiters` Can we backport it to 4.14 and
> > 4.19 branch?
> > > The patch doesn't apply cleanly, but it should be trivial to resolve,
> > > just do this
> > >
> > > -		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(rsp-
> > >expedited_sequence) & 0x3]);
> > > +		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(s) & 0x3]);
> > >
> > > I don't know if we should do it for 4.9, because the handling of sequence
> > number is a bit different.
> > 
> > Please provide a working backport, me hand-editing patches does not scale,
> > and this way you get the proper credit for backporting it (after testing it).
> 
> Sure, appended at the end.
> 
> > 
> > You have tested, this, right?
> 
> I don't have a good repro for the original issue, so I only ran rcutorture and
> some basic work load test to see if anything obvious went wrong.

Ideally you would be able to also hit this without the patch on the
older kernels, is this the case?

thanks,

greg k-h
