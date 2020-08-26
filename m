Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055AD252556
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 03:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgHZBwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 21:52:02 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45335 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727013AbgHZBwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 21:52:01 -0400
Received: (qmail 387936 invoked by uid 1000); 25 Aug 2020 21:51:59 -0400
Date:   Tue, 25 Aug 2020 21:51:59 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH] block: Fix a race in the runtime power management code
Message-ID: <20200826015159.GA387575@rowland.harvard.edu>
References: <20200824030607.19357-1-bvanassche@acm.org>
 <1598346681.10649.8.camel@mtkswgap22>
 <20200825182423.GB375466@rowland.harvard.edu>
 <1f798c21-241f-59f8-5298-a32fffe2ff01@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f798c21-241f-59f8-5298-a32fffe2ff01@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 03:22:03PM -0700, Bart Van Assche wrote:
> On 2020-08-25 11:24, Alan Stern wrote:
> > A related question concerns the BLK_MQ_REQ_PREEMPT flag.  If it is set 
> > then the request is allowed while rpm_status is RPM_SUSPENDING.  But in 
> > fact, the only requests which should be allowed at that time are those 
> > created by the lower-layer driver as part of its runtime-suspend 
> > handling; all other requests should be deferred.  The BLK_MQ_REQ_PREEMPT 
> > flag doesn't seem like the right way to achieve this.  Should we be 
> > using a different flag?
> 
> I think there is already a flag that is used to mark power management
> commands, namely RQF_PM.
> 
> My understanding is that the BLK_MQ_REQ_PREEMPT/RQF_PREEMPT flags are used
> for the following purposes:
> * In the SCSI core, scsi_execute() sets the BLK_MQ_PREEMPT flag. As a
>   result, SCSI commands submitted with scsi_execute() are processed in
>   the SDEV_QUIESCE SCSI device state. Since scsi_execute() is only used
>   to submit other than medium access commands, in the SDEV_QUIESCE state
>   medium access commands are paused and commands that do not access the
>   storage medium (e.g. START/STOP commands) are processed.
> * In the IDE-driver, for making one request preempt another request. From
>   an old IDE commit (not sure if this is still relevant):
>   + * If action is ide_preempt, then the rq is queued at the head of
>   + * the request queue, displacing the currently-being-processed
>   + * request and this function returns immediately without waiting
>   + * for the new rq to be completed.  This is VERY DANGEROUS, and is
>   + * intended for careful use by the ATAPI tape/cdrom driver code.

Ah, perfect.  So in blk_queue_enter(), pm should be defined in terms of 
RQF_PM rather than BLK_MQ_REQ_PREEMPT.

The difficulty is that the flags argument is the wrong type; RQF_PM is 
defined as req_flags_t, not blk_mq_req_flags_t.  It is associated with a 
particular request after the request has been created, so after 
blk_queue_enter() has been called.

How can we solve this?

Alan Stern
