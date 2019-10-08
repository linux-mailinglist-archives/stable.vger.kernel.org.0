Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEE4D036C
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 00:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfJHWby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 18:31:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbfJHWby (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 18:31:54 -0400
Received: from localhost (unknown [131.107.159.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39D60206BB;
        Tue,  8 Oct 2019 22:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570573913;
        bh=4MhZaGOdsL9awXEKHoe9q5IgRqfY8XjQCl2yJKY3Z6M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HVaJGPDfYlWMAoye8Lzk6SG+6EYO1eaIesIV/TnoqrQCowKK0Y6KdZR9JnW6ETMEW
         GNibKltu9A3MaXckI8Dp617kATOcEqdMlEY5SwnzBH17SaEX3BgBthuqyrb8aYdFRV
         G4Nvtv3Hsk8anA/Pvuk6uyYwGL3SqZjzkMuloETc=
Date:   Tue, 8 Oct 2019 18:31:52 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     mchristi@redhat.com, axboe@kernel.dk, jbacik@fb.com,
        josef@toxicpanda.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] nbd: fix max number of supported devs"
 failed to apply to 4.14-stable tree
Message-ID: <20191008223152.GG1396@sasha-vm>
References: <157051955816884@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157051955816884@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 09:25:58AM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
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
>From e9e006f5fcf2bab59149cb38a48a4817c1b538b4 Mon Sep 17 00:00:00 2001
>From: Mike Christie <mchristi@redhat.com>
>Date: Sun, 4 Aug 2019 14:10:06 -0500
>Subject: [PATCH] nbd: fix max number of supported devs
>
>This fixes a bug added in 4.10 with commit:
>
>commit 9561a7ade0c205bc2ee035a2ac880478dcc1a024
>Author: Josef Bacik <jbacik@fb.com>
>Date:   Tue Nov 22 14:04:40 2016 -0500
>
>    nbd: add multi-connection support
>
>that limited the number of devices to 256. Before the patch we could
>create 1000s of devices, but the patch switched us from using our
>own thread to using a work queue which has a default limit of 256
>active works.
>
>The problem is that our recv_work function sits in a loop until
>disconnection but only handles IO for one connection. The work is
>started when the connection is started/restarted, but if we end up
>creating 257 or more connections, the queue_work call just queues
>connection257+'s recv_work and that waits for connection 1 - 256's
>recv_work to be disconnected and that work instance completing.
>
>Instead of reverting back to kthreads, this has us allocate a
>workqueue_struct per device, so we can block in the work.
>
>Cc: stable@vger.kernel.org
>Reviewed-by: Josef Bacik <josef@toxicpanda.com>
>Signed-off-by: Mike Christie <mchristi@redhat.com>
>Signed-off-by: Jens Axboe <axboe@kernel.dk>

I've queued up 553768d1169a4 ("nbd: fix crash when the blksize is zero")
and 2189c97cdbed6 ("block/ndb: add WQ_UNBOUND to the knbd-recv
workqueue") to resolve this on 4.14.

-- 
Thanks,
Sasha
