Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C726770E6E
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 03:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387665AbfGWBEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 21:04:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731828AbfGWBEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jul 2019 21:04:10 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B5164B2DC7;
        Tue, 23 Jul 2019 01:04:09 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E3FA5C54A;
        Tue, 23 Jul 2019 01:03:52 +0000 (UTC)
Date:   Tue, 23 Jul 2019 09:03:47 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH V2 2/2] scsi: implement .cleanup_rq callback
Message-ID: <20190723010345.GB30776@ming.t460p>
References: <20190720030637.14447-1-ming.lei@redhat.com>
 <20190720030637.14447-3-ming.lei@redhat.com>
 <eed624d5-0585-699c-9084-9f5f0ea09e52@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eed624d5-0585-699c-9084-9f5f0ea09e52@acm.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 23 Jul 2019 01:04:09 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 22, 2019 at 08:40:23AM -0700, Bart Van Assche wrote:
> On 7/19/19 8:06 PM, Ming Lei wrote:
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index e1da8c70a266..52537c145762 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -154,12 +154,9 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
> >   static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
> >   {
> > -	if (cmd->request->rq_flags & RQF_DONTPREP) {
> > -		cmd->request->rq_flags &= ~RQF_DONTPREP;
> > -		scsi_mq_uninit_cmd(cmd);
> > -	} else {
> > -		WARN_ON_ONCE(true);
> > -	}
> > +	WARN_ON_ONCE(!(cmd->request->rq_flags & RQF_DONTPREP));
> > +
> > +	scsi_mq_uninit_cmd(cmd);
> >   	blk_mq_requeue_request(cmd->request, true);
> >   }
> 
> The above changes are independent of this patch series. Have you considered
> to move these into a separate patch?

OK.

> 
> > +/*
> > + * Only called when the request isn't completed by SCSI, and not freed by
> > + * SCSI
> > + */
> > +static void scsi_cleanup_rq(struct request *rq)
> > +{
> > +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
> > +
> > +	scsi_mq_uninit_cmd(cmd);
> > +}
> 
> Is the comment above this function correct? The previous patch adds an
> unconditional call to mq_ops->cleanup_rq() in blk_mq_free_request().

You are right, will fix it in V3.

Thanks,
Ming
