Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0284176680
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 22:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgCBV7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 16:59:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgCBV7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 16:59:02 -0500
Received: from localhost (mobile-166-175-186-165.mycingular.net [166.175.186.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6DCA20873;
        Mon,  2 Mar 2020 21:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583186342;
        bh=1phsc+o46pCrop8Ilqwo6dykYVm8CdKoZtrs7VOnmKk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=kzbyeYVQeO4OsdDvf7rlFlgwiVSpwEnBXdIBNxrU14JpiGT/TReGLoD1iO8u8BjtS
         DWCpCitOCZZPV9mF5XEz7mikXsC9htvPRqu/F6PYG8l3XJPyoRFtlvHne7ubhYGbKL
         UYO5apv7KTIhdfg5GdeH5ho5vIiWbIZIeV9LJIz0=
Date:   Mon, 2 Mar 2020 15:59:00 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "tristmd@gmail.com" <tristmd@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] blktrace: Protect q->blk_trace with RCU
Message-ID: <20200302215900.GA168003@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB574957E5116240523362B1DC86E70@BYAPR04MB5749.namprd04.prod.outlook.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 02, 2020 at 09:19:33PM +0000, Chaitanya Kulkarni wrote:
> By any chance will the following patch be able to get rid of
> the warning ?
> 
> index 4560878f0bac..889555910555 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -1895,9 +1895,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct 
> device *dev,
>                  goto out_unlock_bdev;
>          }
> 
> -       ret = 0;
> -       if (bt == NULL)
> -               ret = blk_trace_setup_queue(q, bdev);
> +       ret = bt == NULL ? blk_trace_setup_queue(q, bdev) : 0;
> 
>          if (ret == 0) {
>                  if (attr == &dev_attr_act_mask)

I don't have a way to run Coverity (I just get periodic reports), but
I don't see the point of this patch.  I assume "bt" can still be NULL
(otherwise there'd be no point in testing it) and we still reference
"bt->pid" below.

> On 03/02/2020 12:41 PM, Bjorn Helgaas wrote:
> > On Thu, Feb 06, 2020 at 03:28:12PM +0100, Jan Kara wrote:
> >
> >> @@ -1844,18 +1896,18 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
> >>   	}
> >>
> >>   	ret = 0;
> >> -	if (q->blk_trace == NULL)
> >> +	if (bt == NULL)
> >>   		ret = blk_trace_setup_queue(q, bdev);
> >>
> >>   	if (ret == 0) {
> >>   		if (attr == &dev_attr_act_mask)
> >> -			q->blk_trace->act_mask = value;
> >> +			bt->act_mask = value;
> >
> > You've likely seen this already, but Coverity complains that "bt" may
> > be a NULL pointer here, since we checked it for NULL above.
> >
> >    CID 1460458:  Null pointer dereferences  (FORWARD_NULL)
> >
> >>   		else if (attr == &dev_attr_pid)
> >> -			q->blk_trace->pid = value;
> >> +			bt->pid = value;
> >>   		else if (attr == &dev_attr_start_lba)
> >> -			q->blk_trace->start_lba = value;
> >> +			bt->start_lba = value;
> >>   		else if (attr == &dev_attr_end_lba)
> >> -			q->blk_trace->end_lba = value;
> >> +			bt->end_lba = value;
> >>   	}
> >>
> >>   out_unlock_bdev:
> >>
> >
> 
