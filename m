Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9312B246439
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgHQKRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:17:22 -0400
Received: from verein.lst.de ([213.95.11.211]:56153 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbgHQKRV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 06:17:21 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0673168B05; Mon, 17 Aug 2020 12:17:19 +0200 (CEST)
Date:   Mon, 17 Aug 2020 12:17:18 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.com>,
        Xiao Ni <xni@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Gwendal Grignou <gwendal@chromium.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] block: loop: set discard granularity and
 alignment for block device backed loop
Message-ID: <20200817101718.GC25336@lst.de>
References: <20200817100130.2496059-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817100130.2496059-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 06:01:30PM +0800, Ming Lei wrote:
> In case of block device backend, if the backend supports write zeros, the
> loop device will set queue flag of QUEUE_FLAG_DISCARD. However,
> limits.discard_granularity isn't setup, and this way is wrong,
> see the following description in Documentation/ABI/testing/sysfs-block:
> 
> 	A discard_granularity of 0 means that the device does not support
> 	discard functionality.
> 
> Especially 9b15d109a6b2 ("block: improve discard bio alignment in
> __blkdev_issue_discard()") starts to take q->limits.discard_granularity
> for computing max discard sectors. And zero discard granularity may cause
> kernel oops, or fail discard request even though the loop queue claims
> discard support via QUEUE_FLAG_DISCARD.
> 
> Fix the issue by setup discard granularity and alignment.

This patch looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

If you have a few spare cycles, can you kill QUEUE_FLAG_DISCARD and
just key off discard support based on checking discard_granularity to
avoid problems like this in the future?
