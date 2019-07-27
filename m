Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF2F775D9
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 04:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbfG0CMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 22:12:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44584 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfG0CMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 22:12:38 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 69654307B17E;
        Sat, 27 Jul 2019 02:12:38 +0000 (UTC)
Received: from ming.t460p (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E2525D9C6;
        Sat, 27 Jul 2019 02:12:24 +0000 (UTC)
Date:   Sat, 27 Jul 2019 10:12:20 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH V2 0/2] block/scsi/dm-rq: fix leak of request private
 data in dm-mpath
Message-ID: <20190727021219.GA6926@ming.t460p>
References: <20190720030637.14447-1-ming.lei@redhat.com>
 <20190726162046.GA7523@t480-pf1aa2c2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726162046.GA7523@t480-pf1aa2c2>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Sat, 27 Jul 2019 02:12:38 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 06:20:46PM +0200, Benjamin Block wrote:
> Hey Ming Lei,
> 
> On Sat, Jul 20, 2019 at 11:06:35AM +0800, Ming Lei wrote:
> > Hi,
> > 
> > When one request is dispatched to LLD via dm-rq, if the result is
> > BLK_STS_*RESOURCE, dm-rq will free the request. However, LLD may allocate
> > private data for this request, so this way will cause memory leak.
> 
> I am confused about this. Probably because I am not up-to-date with
> all of blk-mq. But if you free the LLD private data before the request
> is finished, what is the LLD doing if the request finishes afterwards?
> Would that not be an automatic use-after-free?

Wrt. this special use case, the underlying request is totally covered by
dm-rq after .queue_rq() returns BLK_STS_*RESOURCE. So the request won't
be re-dispatched by blk-mq at all.

thanks,
Ming
