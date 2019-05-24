Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE5729EFB
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 21:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbfEXTWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 15:22:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:58716 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729017AbfEXTWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 15:22:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hoNOqHXo5AF7rmfT5cvaQvenH+apZ2meHqOG+V3ZTk8=; b=E86AzCtYqiDp3qSRnyOcJxBUTU
        vLpqV7407uJ4AdhCn1z5EfLh3tObrEVmJjnZsnMrBsHLO+ZbdM3iwGNX3WOB5Iudz4EupNvksGr3/
        zZxY1CG2ZpApI7OpV+uidLOmHqSGgaAsUYvaQuEIVlmvGHXluypmMxS8qa+ZqzUOYJJdVdK3QPcJZ
        rGv/UWqFYP7f2Cwef/ubW+T6IQR+aR2twpLeQH289qPmPjpDNx4y5JhaT+aW/h0Nuiy+afVFI28w6
        C/+eZXA5a912M4hz0OA7kJZO92UYfElWyf8VuXgSTiqxA/tEXDVz4tgFgssP5Mr7ol/hlawXlXZzf
        7xPpyOFA==;
Received: from 177.97.63.247.dynamic.adsl.gvt.net.br ([177.97.63.247] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hUFlx-0006cw-4N; Fri, 24 May 2019 19:22:33 +0000
Date:   Fri, 24 May 2019 16:22:26 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Allison Randal <allison@lohutok.net>,
        Steve Winslow <swinslow@gmail.com>,
        Wen Yang <wen.yang99@zte.com.cn>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2] media: smsusb: better handle optional alignment
Message-ID: <20190524162226.2aa3df9c@coco.lan>
In-Reply-To: <20190524190941.GA18849@kroah.com>
References: <c53ea00f339529f69b89deac620e4ab540717eb9.1558709939.git.mchehab+samsung@kernel.org>
        <20190524190941.GA18849@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Fri, 24 May 2019 21:09:41 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:

> On Fri, May 24, 2019 at 10:59:43AM -0400, Mauro Carvalho Chehab wrote:
> > Most Siano devices require an alignment for the response.
> > 
> > Changeset f3be52b0056a ("media: usb: siano: Fix general protection fault in smsusb")
> > changed the logic with gets such aligment, but it now produces a
> > sparce warning:
> > 
> > drivers/media/usb/siano/smsusb.c: In function 'smsusb_init_device':
> > drivers/media/usb/siano/smsusb.c:447:37: warning: 'in_maxp' may be used uninitialized in this function [-Wmaybe-uninitialized]
> >   447 |   dev->response_alignment = in_maxp - sizeof(struct sms_msg_hdr);
> >       |                             ~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > The sparse message itself is bogus, but a broken (or fake) USB
> > eeprom could produce a negative value for response_alignment.
> > 
> > So, change the code in order to check if the result is not
> > negative.
> > 
> > Fixes: f3be52b0056a ("media: usb: siano: Fix general protection fault in smsusb")
> > CC: <stable@vger.kernel.org>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > ---
> > 
> > Greg,
> > 
> > As the Alan patches went via your tree, please apply this one too.  
> 
> Thanks, now done, and I fixed up the Fixes: sha1 tag to match my tree.

Ah, thanks! I forgot about that :-)

> 
> greg k-h



Thanks,
Mauro
