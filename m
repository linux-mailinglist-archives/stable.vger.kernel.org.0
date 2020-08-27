Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1614025500E
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 22:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgH0UdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 16:33:25 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50413 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726266AbgH0UdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 16:33:22 -0400
Received: (qmail 450389 invoked by uid 1000); 27 Aug 2020 16:33:21 -0400
Date:   Thu, 27 Aug 2020 16:33:21 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block: Fix a race in the runtime power management code
Message-ID: <20200827203321.GB449067@rowland.harvard.edu>
References: <20200824030607.19357-1-bvanassche@acm.org>
 <1598346681.10649.8.camel@mtkswgap22>
 <20200825182423.GB375466@rowland.harvard.edu>
 <1f798c21-241f-59f8-5298-a32fffe2ff01@acm.org>
 <20200826015159.GA387575@rowland.harvard.edu>
 <af1b1f57-59ff-0133-8108-0f3d1e1254e1@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af1b1f57-59ff-0133-8108-0f3d1e1254e1@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26, 2020 at 08:35:42PM -0700, Bart Van Assche wrote:
> On 2020-08-25 18:51, Alan Stern wrote:
> > Ah, perfect.  So in blk_queue_enter(), pm should be defined in terms of 
> > RQF_PM rather than BLK_MQ_REQ_PREEMPT.
> > 
> > The difficulty is that the flags argument is the wrong type; RQF_PM is 
> > defined as req_flags_t, not blk_mq_req_flags_t.  It is associated with a 
> > particular request after the request has been created, so after 
> > blk_queue_enter() has been called.
> > 
> > How can we solve this?
> 
> The current code looks a bit weird because my focus when modifying the PM
> code has been on not breaking any existing code.
> 
> scsi_device_quiesce() relies on blk_queue_enter() processing all PREEMPT
> requests. A difficulty is that scsi_device_quiesce() is used for two
> separate purposes:
> * Runtime power management.
> * SCSI domain validation. See e.g. https://lwn.net/Articles/75917/.
> 
> I think that modifying blk_queue_enter() such that it only accepts PM
> requests will require to split scsi_device_quiesce() into two functions:
> one function that is used by the runtime power management code and another
> function that is used by the SCSI domain validation code. This may require
> to introduce new SCSI device states. If new SCSI device states are
> introduced, that should be done without modifying the state that is
> reported to user space. See also sdev_states[] and show_state_field in
> scsi_sysfs.c.

It may not need to be that complicated.  what about something like this?

Alan Stern


Index: usb-devel/block/blk-core.c
===================================================================
--- usb-devel.orig/block/blk-core.c
+++ usb-devel/block/blk-core.c
@@ -420,11 +420,11 @@ EXPORT_SYMBOL(blk_cleanup_queue);
 /**
  * blk_queue_enter() - try to increase q->q_usage_counter
  * @q: request queue pointer
- * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PREEMPT
+ * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PM
  */
 int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 {
-	const bool pm = flags & BLK_MQ_REQ_PREEMPT;
+	const bool pm = flags & BLK_MQ_REQ_PM;
 
 	while (true) {
 		bool success = false;
@@ -626,7 +626,8 @@ struct request *blk_get_request(struct r
 	struct request *req;
 
 	WARN_ON_ONCE(op & REQ_NOWAIT);
-	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PREEMPT));
+	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PREEMPT |
+			BLK_MQ_REQ_PM));
 
 	req = blk_mq_alloc_request(q, op, flags);
 	if (!IS_ERR(req) && q->mq_ops->initialize_rq_fn)
Index: usb-devel/drivers/scsi/scsi_lib.c
===================================================================
--- usb-devel.orig/drivers/scsi/scsi_lib.c
+++ usb-devel/drivers/scsi/scsi_lib.c
@@ -245,11 +245,15 @@ int __scsi_execute(struct scsi_device *s
 {
 	struct request *req;
 	struct scsi_request *rq;
+	blk_mq_req_flags_t mq_req_flags;
 	int ret = DRIVER_ERROR << 24;
 
+	mq_req_flags = BLK_MQ_REQ_PREEMPT;
+	if (rq_flags & RQF_PM)
+		mq_req_flags |= BLK_MQ_REQ_PM;
 	req = blk_get_request(sdev->request_queue,
 			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);
+			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, mq_req_flags);
 	if (IS_ERR(req))
 		return ret;
 	rq = scsi_req(req);
Index: usb-devel/include/linux/blk-mq.h
===================================================================
--- usb-devel.orig/include/linux/blk-mq.h
+++ usb-devel/include/linux/blk-mq.h
@@ -435,6 +435,8 @@ enum {
 	BLK_MQ_REQ_RESERVED	= (__force blk_mq_req_flags_t)(1 << 1),
 	/* set RQF_PREEMPT */
 	BLK_MQ_REQ_PREEMPT	= (__force blk_mq_req_flags_t)(1 << 3),
+	/* used for power management */
+	BLK_MQ_REQ_PM		= (__force blk_mq_req_flags_t)(1 << 4),
 };
 
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,

