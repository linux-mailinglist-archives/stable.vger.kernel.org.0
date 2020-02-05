Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7FD15285D
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 10:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgBEJca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 04:32:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728034AbgBEJca (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 04:32:30 -0500
Received: from localhost (unknown [212.187.182.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B8E820661;
        Wed,  5 Feb 2020 09:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580895149;
        bh=Gpy2hDxfILCFcNi6YZ66NKuF3zEEEMxnRbdzFslvPF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XB9E4giKihYUTpJkE7e56XLu6u0sCHsEYUC9MMMUVBdEGQif/VQu9hYBz9M9Li8vL
         NrL1zBhh/d7Q/OeY+flSduv0gGKLdIwFOX6Nnq/JESZ0ECyF37wg9ZG4CgljWCJeTV
         8WPvXLXw6oVuYbVFPqZALzn6/KOFRQAcSgPehN94=
Date:   Wed, 5 Feb 2020 09:32:26 +0000
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     peter enderborg <peter.enderborg@sony.com>
Cc:     linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Jiri Kosina <jkosina@suse.cz>, stable@vger.kernel.org,
        syzbot+09ef48aa58261464b621@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.4 17/78] HID: Fix slab-out-of-bounds read in
 hid_field_extract (Broken!)
Message-ID: <20200205093226.GC1164405@kroah.com>
References: <20200114094352.428808181@linuxfoundation.org>
 <20200114094356.028051662@linuxfoundation.org>
 <27ba705a-6734-9a92-a60c-23e27c9bce6d@sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27ba705a-6734-9a92-a60c-23e27c9bce6d@sony.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05, 2020 at 08:12:27AM +0100, peter enderborg wrote:
> On 1/14/20 11:00 AM, Greg Kroah-Hartman wrote:
> > From: Alan Stern <stern@rowland.harvard.edu>
> >
> > commit 8ec321e96e056de84022c032ffea253431a83c3c upstream.
> >
> > The syzbot fuzzer found a slab-out-of-bounds bug in the HID report
> > handler.  The bug was caused by a report descriptor which included a
> > field with size 12 bits and count 4899, for a total size of 7349
> > bytes.
> >
> > The usbhid driver uses at most a single-page 4-KB buffer for reports.
> > In the test there wasn't any problem about overflowing the buffer,
> > since only one byte was received from the device.  Rather, the bug
> > occurred when the HID core tried to extract the data from the report
> > fields, which caused it to try reading data beyond the end of the
> > allocated buffer.
> >
> > This patch fixes the problem by rejecting any report whose total
> > length exceeds the HID_MAX_BUFFER_SIZE limit (minus one byte to allow
> > for a possible report index).  In theory a device could have a report
> > longer than that, but if there was such a thing we wouldn't handle it
> > correctly anyway.
> >
> > Reported-and-tested-by: syzbot+09ef48aa58261464b621@syzkaller.appspotmail.com
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > CC: <stable@vger.kernel.org>
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > ---
> >  drivers/hid/hid-core.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > --- a/drivers/hid/hid-core.c
> > +++ b/drivers/hid/hid-core.c
> > @@ -288,6 +288,12 @@ static int hid_add_field(struct hid_pars
> >  	offset = report->size;
> >  	report->size += parser->global.report_size * parser->global.report_count;
> >  
> > +	/* Total size check: Allow for possible report index byte */
> > +	if (report->size > (HID_MAX_BUFFER_SIZE - 1) << 3) {
> > +		hid_err(parser->device, "report is too long\n");
> > +		return -1;
> > +	}
> > +
> >  	if (!parser->local.usage_index) /* Ignore padding fields */
> >  		return 0;
> >  
> >
> >
> >
> This patch breaks Elgato StreamDeck.

Does that mean the device is broken with a too-large of a report?

Is it broken in Linus's tree?  If so, can you work with the HID
developers to fix it there so we can backport the fix to all stable
trees?

thanks,

greg k-h
