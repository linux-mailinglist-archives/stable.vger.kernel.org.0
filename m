Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7E314C111
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 20:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgA1Tej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 14:34:39 -0500
Received: from minas.morgul.net ([128.31.0.48]:44024 "EHLO minas.morgul.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726234AbgA1Tej (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 14:34:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morgul.net;
         s=20141010; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nimprqg/Mrpmzw+w+B0PeZeKK3IhZ21eWWhT18x3Hwg=; b=qyUbkVzcze4Y9pwHQisTcYQmdM
        E+/cLtGlIk0gdM8OMm7i7I02bSmsMDhnnopLZRAO1LJGMAPVVv3pQsFCkV6ZSXuGJU2u40U7QfVc1
        84K6rlGi/X7ibi8W2SQrrkWJ/DPtln7dHZa1NCOtza2oHkzpc6Q5jyk16am/QfgqFgFs=;
Received: from frodo by minas.morgul.net with local (Exim 4.92)
        (envelope-from <frodo@morgul.net>)
        id 1iwWdB-00065Z-Q6; Tue, 28 Jan 2020 14:34:37 -0500
Date:   Tue, 28 Jan 2020 14:34:37 -0500
From:   Noah Meyerhans <noahm@debian.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please apply 50ee7529ec45 ("random: try to actively add entropy
 rather than passively wait for it") to 4.19.y
Message-ID: <20200128193437.GA18426@morgul.net>
Mail-Followup-To: Noah Meyerhans <noahm@debian.org>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20200127230214.GC25530@morgul.net>
 <20200128075223.GD2105706@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128075223.GD2105706@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 08:52:23AM +0100, Greg KH wrote:
> > As detailed in https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=948519 and
> > https://wiki.debian.org/BoottimeEntropyStarvation, lack of boot-time entropy
> > can contribute to multi-minute pauses during system initialization in some
> > hardware configurations.  While userspace workarounds, e.g. haveged, are
> > documented, the in-kernel jitter entropy collector eliminates the need for such
> > workarounds.
> > 
> > It cherry-picks cleanly to 4.19.y and 4.14.y.  I'm particularly interested
> > in the former.
> > 
> > Thanks for considering this.
> 
> Please cc: the developers of that commit, and the maintainer of that
> code, and we will be glad to consider it if they agree it is viable for
> those kernels.

Added torvalds and tytso to the CC list.  Linus and Ted, what do you
think of the idea of applying 50ee7529ec45 ("random: try to actively add
entropy rather than passively wait for it") to the 4.19.y and 4.14.y
kernels?

> Personally, this looks like a "new feature" to me, if you really need
> this, what is preventing you from moving to a newer kernel version?

From a personal perspective, I'm fine with moving to a newer kernel, but
for distributions it's not that simple.  The fact is, at the moment, the
current state of boot time entropy on systems running stable kernels on
systems without an HRNG-backed entropy source has lead to all manner of
workarounds being deployed.  While some of the workarounds may be fine,
others may be quite a bit less safe.  At least with the in-kernel jitter
entropy collector we can make things consistent.

Thanks
noah

