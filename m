Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB4B10A8AE
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 03:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfK0CUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 21:20:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbfK0CUb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 21:20:31 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E660207DD;
        Wed, 27 Nov 2019 02:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574821230;
        bh=Iyp8htKnprYX2xRnTbfbZM6dKE4Q0UzBkvFhrlfQCdM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bk9mR2tF2ZrHiIVTAnZBzKv9+ia/l3ySI0JEExjiwWiXZhF0IZYW4jppL7lcSp1pn
         v1XHEMPOF1mknHkStXTn039oGr00k2I29jXPXG80maqVyYf4Q5vA+WWqjzKpE7zepT
         3ghClu1GL31MGBlSFR60Pnyaj6PPRZkKLnXy6iAI=
Date:   Tue, 26 Nov 2019 21:20:29 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     pasic@linux.ibm.com, mimu@linux.ibm.com, mst@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] virtio_ring: fix return code on DMA
 mapping fails" failed to apply to 4.19-stable tree
Message-ID: <20191127022029.GM5861@sasha-vm>
References: <1574703866101156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1574703866101156@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 25, 2019 at 06:44:26PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From f7728002c1c7bfa787b276a31c3ef458739b8e7c Mon Sep 17 00:00:00 2001
>From: Halil Pasic <pasic@linux.ibm.com>
>Date: Thu, 14 Nov 2019 13:46:46 +0100
>Subject: [PATCH] virtio_ring: fix return code on DMA mapping fails
>
>Commit 780bc7903a32 ("virtio_ring: Support DMA APIs")  makes
>virtqueue_add() return -EIO when we fail to map our I/O buffers. This is
>a very realistic scenario for guests with encrypted memory, as swiotlb
>may run out of space, depending on it's size and the I/O load.
>
>The virtio-blk driver interprets -EIO form virtqueue_add() as an IO
>error, despite the fact that swiotlb full is in absence of bugs a
>recoverable condition.
>
>Let us change the return code to -ENOMEM, and make the block layer
>recover form these failures when virtio-blk encounters the condition
>described above.
>
>Cc: stable@vger.kernel.org
>Fixes: 780bc7903a32 ("virtio_ring: Support DMA APIs")
>Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>Tested-by: Michael Mueller <mimu@linux.ibm.com>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

The code got shuffled around a bit in 138fd2514863 ("virtio_ring: add
_split suffix for split ring functions"), I've cleaned it up and queued
it for 4.19, 4.14, and 4.9.

-- 
Thanks,
Sasha
