Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB872A00E7
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 10:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgJ3JN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 05:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbgJ3JN3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 05:13:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44F6220728;
        Fri, 30 Oct 2020 09:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604049208;
        bh=rGFZAxdEquOjEM6OhiSMy36YpDpqeLIYsKc/vDNiDUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ucla+KlaTBQy5baKLWHImDCFUQWEz158viu9zqq6clbHvk5f7zbVkrpO1NM78m7lI
         juYg276FTOuYqjDjwYY+F7YGDUpPDZYHEwV6+zOPIz9RDLxMgdCgzIz7PlEspHigUe
         Td2Mt1hlqnWt+r6hH/TikSCEA/r9/8t3tflLp6x8=
Date:   Fri, 30 Oct 2020 10:14:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>, Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: Linux 4.19.153
Message-ID: <20201030091416.GA1759200@kroah.com>
References: <160396822019115@kroah.com>
 <20201030082653.GA29475@amd>
 <20201030084915.GB1625087@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030084915.GB1625087@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 30, 2020 at 09:49:15AM +0100, Greg Kroah-Hartman wrote:
> On Fri, Oct 30, 2020 at 09:26:54AM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > I'm announcing the release of the 4.19.153 kernel.
> > > 
> > > All users of the 4.19 kernel series must upgrade.
> > > 
> > > The updated 4.19.y git tree can be found at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
> > > and can be browsed at the normal kernel.org git web browser:
> > > 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> > 
> > Did something go seriously wrong here?
> > 
> > The original 4.19.153-rc1 series had 264 patches. "powerpc/tau: Remove
> > duplicated set_thresholds() call" is 146/264 of the series, but it is
> > last one in 4.19.153 as released. "178/264 ext4: limit entries
> > returned when counting...", for example, is not present in
> > 4.19.153... as are others, for example "net: korina: cast KSEG0
> > address to pointer in kfree". Looks like 118 or so patches are
> > missing.
> > 
> > They are not in origin/queue/4.19, either.
> 
> Wow, something did go wrong here, thanks for catching this.
> 
> Let me dig and see what happened, the whole series did not apply, which
> makes me wonder if the same thing happened for other branches as well...
> 
> thanks for checking up and finding this.
> 
> Give me a bit...

Ok, figure3d it out.

Sasha changed a powerpc patch to build properly but didn't realize that
later powerpc patches would not apply because of that.  I didn't run my
"apply all patches to make sure they are clean" script before doing the
release after he did that, so 'git quiltimport' failed when applying the
series at the place where the powerpc path failed to apply.

My scripts don't check for the result of 'git quiltimport' being
successful or not (I don't even know if it return an error for this type
of thing), and just moved on in the release process.

I'll go do a new 4.19 release with the rest of the patches missed here,
thank you for finding this.

And I'll go make my release scripts more robust to failures like this as
well.

thanks so much!

greg k-h
