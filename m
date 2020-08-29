Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690022563EB
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 03:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgH2BMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 21:12:05 -0400
Received: from netrider.rowland.org ([192.131.102.5]:39307 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726236AbgH2BMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 21:12:05 -0400
Received: (qmail 487246 invoked by uid 1000); 28 Aug 2020 21:12:03 -0400
Date:   Fri, 28 Aug 2020 21:12:03 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] block: Fix a race in the runtime power management code
Message-ID: <20200829011203.GA486691@rowland.harvard.edu>
References: <20200824030607.19357-1-bvanassche@acm.org>
 <1598346681.10649.8.camel@mtkswgap22>
 <20200825182423.GB375466@rowland.harvard.edu>
 <1f798c21-241f-59f8-5298-a32fffe2ff01@acm.org>
 <20200826015159.GA387575@rowland.harvard.edu>
 <af1b1f57-59ff-0133-8108-0f3d1e1254e1@acm.org>
 <20200827203321.GB449067@rowland.harvard.edu>
 <5da883fe-b5ec-b98d-ae0c-bc053b6e22cb@acm.org>
 <20200828153745.GB470612@rowland.harvard.edu>
 <31d6f204-21ae-88da-dbfc-3d7132f8bc03@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31d6f204-21ae-88da-dbfc-3d7132f8bc03@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 28, 2020 at 05:51:03PM -0700, Bart Van Assche wrote:
> On 2020-08-28 08:37, Alan Stern wrote:
> > On Thu, Aug 27, 2020 at 08:27:49PM -0700, Bart Van Assche wrote:
> >> On 2020-08-27 13:33, Alan Stern wrote:
> >>> It may not need to be that complicated.  what about something like this?
> > 
> >> I think this patch will break SCSI domain validation. The SCSI domain
> >> validation code calls scsi_device_quiesce() and that function in turn calls
> >> blk_set_pm_only(). The SCSI domain validation code submits SCSI commands with
> >> the BLK_MQ_REQ_PREEMPT flag. Since the above code postpones such requests
> >> while blk_set_pm_only() is in effect, I think the above patch will cause the
> >> SCSI domain validation code to deadlock.
> > 
> > Yes, you're right.
> > 
> > There may be an even simpler solution: Ensure that SCSI domain 
> > validation is mutually exclusive with runtime PM.  It's already mutually 
> > exclusive with system PM, so this makes sense.
> > 
> > What do you think of the patch below?
> > 
> > Alan Stern
> > 
> > 
> > Index: usb-devel/drivers/scsi/scsi_transport_spi.c
> > ===================================================================
> > --- usb-devel.orig/drivers/scsi/scsi_transport_spi.c
> > +++ usb-devel/drivers/scsi/scsi_transport_spi.c
> > @@ -1001,7 +1001,7 @@ spi_dv_device(struct scsi_device *sdev)
> >  	 * Because this function and the power management code both call
> >  	 * scsi_device_quiesce(), it is not safe to perform domain validation
> >  	 * while suspend or resume is in progress. Hence the
> > -	 * lock/unlock_system_sleep() calls.
> > +	 * lock/unlock_system_sleep() and scsi_autopm_get/put_device() calls.
> >  	 */
> >  	lock_system_sleep();
> >  
> > @@ -1018,10 +1018,13 @@ spi_dv_device(struct scsi_device *sdev)
> >  	if (unlikely(!buffer))
> >  		goto out_put;
> >  
> > +	if (scsi_autopm_get_device(sdev))
> > +		goto out_free;
> > +
> >  	/* We need to verify that the actual device will quiesce; the
> >  	 * later target quiesce is just a nice to have */
> >  	if (unlikely(scsi_device_quiesce(sdev)))
> > -		goto out_free;
> > +		goto out_autopm_put;
> >  
> >  	scsi_target_quiesce(starget);
> >  
> > @@ -1041,6 +1044,8 @@ spi_dv_device(struct scsi_device *sdev)
> >  
> >  	spi_initial_dv(starget) = 1;
> >  
> > + out_autopm_put:
> > +	scsi_autopm_put_device(sdev);
> >   out_free:
> >  	kfree(buffer);
> >   out_put:
> 
> Hi Alan,
> 
> I think this is only a part of the solution. scsi_target_quiesce() invokes
> scsi_device_quiesce() and that function in turn calls blk_set_pm_only(). So
> I think that the above is not sufficient to fix the deadlock mentioned in
> my previous email.

Sorry, it sounds like you misinterpreted my preceding email.  I meant to 
suggest that the patch above should be considered _instead of_ the patch 
that introduced BLK_MQ_REQ_PM.  So blk_queue_enter() would remain 
unchanged, using the BLK_MQ_REQ_PREEMPT flag to decide whether or not to 
postpone new requests.  Thus the deadlock you're concerned about would 
not arise.

> Maybe it is possible to fix this by creating a new request queue and by
> submitting the DV SCSI commands to that new request queue. There may be
> better solutions.

I don't think that is necessary.  After all, quiescing is quiescing, 
whether it is done for runtime power management, domain validation, or 
anything else.  What we need to avoid is one thread trying to keep a 
device quiescent at the same time that another thread is re-activating 
it.

To some extent the SCSI core addresses this by allowing only one thread 
to put a device into the SDEV_QUIESCE state at a time.  Making domain 
validation mutually exclusive with runtime suspend is my attempt to 
prevent any odd corner-case interactions from cropping up.

Alan Stern
