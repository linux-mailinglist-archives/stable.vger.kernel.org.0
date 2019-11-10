Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69316F697E
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 15:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfKJOnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 09:43:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:45656 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726402AbfKJOnL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Nov 2019 09:43:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EE954AEF1;
        Sun, 10 Nov 2019 14:43:09 +0000 (UTC)
Message-ID: <1573396023.2662.4.camel@suse.com>
Subject: Re: [PATCH 4.19 114/149] UAS: Revert commit 3ae62a42090f ("UAS: fix
 alignment of scatter/gather segments")
From:   Oliver Neukum <oneukum@suse.com>
To:     Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Date:   Sun, 10 Nov 2019 15:27:03 +0100
In-Reply-To: <Pine.LNX.4.44L0.1911081029440.1498-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1911081029440.1498-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Freitag, den 08.11.2019, 10:35 -0500 schrieb Alan Stern:
> On Fri, 8 Nov 2019, Greg Kroah-Hartman wrote:
> 
> > On Thu, Nov 07, 2019 at 12:32:45PM +0100, Oliver Neukum wrote:
> > > Am Dienstag, den 05.11.2019, 17:38 +0100 schrieb Greg Kroah-Hartman:
> > > > > > Given this information, perhaps you will decide that the revert is 
> > > > > > worthwhile.
> > > > > 
> > > > > Damned if I do, damned if I do not.
> > > > > Check for usbip and special case it?
> > > > 
> > > > We should be able to do that in the host controller driver for usbip,
> > > > right?  What is the symptom if you use a UAS device with usbip and this
> > > > commit?
> > > 
> > > Yes, that patch should then also be applied. Then it will work.
> > > Without it, commands will fail, as transfers will end prematurely.
> > 
> > Ok, I'm confused now.  I just checked, and I really have no idea what
> > needs to be backported anymore.  3ae62a42090f ("UAS: fix alignment of
> > scatter/gather segments") was backported to all of the stable kernels,
> > and now we reverted it.
> > 
> > So what else needs to be done here?
> 
> In one sense, nothing needs to be done.  3ae62a42090f was intended to
> fix a long-standing problem with USBIP, but people reported a

OK, now I am a bit confused. AFAICT 3ae62a42090f actually did fix the
issue. So if you simply revert it, the issue will reappear.

> regression in performance.  (Admittedly, the report was about the
> correponding change to usb-storage, not the change to uas, but it's
> reasonable to think the effect would be the same.)  So in line with the

Yes.

> no-regressions policy, we only need to revert the commit -- which you 
> have already done.

But that breaks UAS over USBIP, doesn't it?

> On the other hand, the long-standing problem in USBIP can be fixed by
> back-porting commit ea44d190764b.  But since that commit isn't a
> bug-fix (and since it's rather large), you may question whether it is
> appropriate for the -stable kernel series.

It certainly is large. But without it UAS won't work over USBIP, will
it? I think that is the central question we need to answer here.

	Regards
		Oliver

