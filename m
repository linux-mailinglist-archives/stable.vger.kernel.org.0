Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3865F159276
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 16:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgBKPBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 10:01:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728063AbgBKPBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Feb 2020 10:01:24 -0500
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BF6E2086A;
        Tue, 11 Feb 2020 15:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581433283;
        bh=y2EbHrP06L5OaU1623dq+EIafyEnQOLyL46r5Dkjrpo=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=Uaz/KHVYLGOszKR34MSUWB52cAjb8lmuCshYOv+e/VCKiXQsORIqdpuKMX0xn7QuO
         6axmkMTSXl4WkHQJC5xsUTxKQiPx/c8ObwVSJxQ4aD2NMQQfq1N5finJEKfJ9WfwM3
         SOuidlMVJL42uzyrnkWbIkJ7eyBmMVG51FboHqqY=
Date:   Tue, 11 Feb 2020 16:01:06 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Alan Stern <stern@rowland.harvard.edu>
cc:     peter enderborg <peter.enderborg@sony.com>,
        Johan Korsnes <jkorsnes@cisco.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] HID: Extend report buffer size
In-Reply-To: <Pine.LNX.4.44L0.2002110952570.1574-100000@iolanthe.rowland.org>
Message-ID: <nycvar.YFH.7.76.2002111600250.3144@cbobk.fhfr.pm>
References: <Pine.LNX.4.44L0.2002110952570.1574-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 11 Feb 2020, Alan Stern wrote:

> > >> In the patch "HID: Fix slab-out-of-bounds read in hid_field_extract"
> > >> there added a check for buffer overruns. This made Elgato StreamDeck
> > >> to fail. This patch extend the buffer to 8192 to solve this. It also
> > >> adds a print of the requested length if it fails on this test.
> > >>
> > >> Signed-off-by: Peter Enderborg <peter.enderborg@sony.com>
> > >> ---
> > >>  drivers/hid/hid-core.c | 2 +-
> > >>  include/linux/hid.h    | 2 +-
> > >>  2 files changed, 2 insertions(+), 2 deletions(-)
> > >>
> > >> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > >> index 851fe54ea59e..28841219b3d2 100644
> > >> --- a/drivers/hid/hid-core.c
> > >> +++ b/drivers/hid/hid-core.c
> > >> @@ -290,7 +290,7 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
> > >>  
> > >>  	/* Total size check: Allow for possible report index byte */
> > >>  	if (report->size > (HID_MAX_BUFFER_SIZE - 1) << 3) {
> > >> -		hid_err(parser->device, "report is too long\n");
> > >> +		hid_err(parser->device, "report is too long (%d)\n", report->size);
> > >>  		return -1;
> > >>  	}
> > >>  
> > >> diff --git a/include/linux/hid.h b/include/linux/hid.h
> > >> index cd41f209043f..875f71132b14 100644
> > >> --- a/include/linux/hid.h
> > >> +++ b/include/linux/hid.h
> > >> @@ -492,7 +492,7 @@ struct hid_report_enum {
> > >>  };
> > >>  
> > >>  #define HID_MIN_BUFFER_SIZE	64		/* make sure there is at least a packet size of space */
> > >> -#define HID_MAX_BUFFER_SIZE	4096		/* 4kb */
> > >> +#define HID_MAX_BUFFER_SIZE	8192		/* 8kb */
> > >>  #define HID_CONTROL_FIFO_SIZE	256		/* to init devices with >100 reports */
> > >>  #define HID_OUTPUT_FIFO_SIZE	64
> > > The second part of this patch is identical to the "HID: core: increase
> > > HID report buffer size to 8KiB" patch submitted by Johan Korsnes a few
> > > weeks ago.  You might want to submit just the first part of your patch,
> > > or not submit anything at all.
> > >
> > > Alan Stern
> > >
> > >
> > Korsnes patch is not in Torvalds tree nor is it requested for stable. How do we get it there?
> 
> Bring the whole matter to Jiri's attention.  He is the person who will
> take care of it.

I have been a bit swamped during past few days. Johan's patch is in my 
list of things to process either today or tomorrow.

Thanks,

-- 
Jiri Kosina
SUSE Labs

