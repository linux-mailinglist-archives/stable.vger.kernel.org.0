Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC311B33A6
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 01:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDUXuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 19:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgDUXuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 19:50:54 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 122652068F;
        Tue, 21 Apr 2020 23:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587513054;
        bh=8viM/LvXGNIcXxigimtRux/QgrBXyzTmZ2Cb+SDxUFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wd5r9DSw+9thC4aswvQkMBByWTNJP5y/oBCbWzC0XFUzTsmSvSDErk3F6BozcYvYT
         82vMY60blhNFWC+cIk/AQ2JDPJcb/fNuctFKdNtRasK2eA3J5qs7Y182zZ6PObZSOu
         bWYr1zCPdtu98cVLVKTlgJqkK9B42dqYkx/A54Og=
Date:   Tue, 21 Apr 2020 19:50:52 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     idryomov@gmail.com, dillaman@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] rbd: avoid a deadlock on header_rwsem
 when flushing notifies" failed to apply to 5.4-stable tree
Message-ID: <20200421235052.GM1809@sasha-vm>
References: <1587488818238238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1587488818238238@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 07:06:58PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
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
>From 0e4e1de5b63fa423b13593337a27fd2d2b0bcf77 Mon Sep 17 00:00:00 2001
>From: Ilya Dryomov <idryomov@gmail.com>
>Date: Fri, 13 Mar 2020 11:20:51 +0100
>Subject: [PATCH] rbd: avoid a deadlock on header_rwsem when flushing notifies
>
>rbd_unregister_watch() flushes notifies and therefore cannot be called
>under header_rwsem because a header update notify takes header_rwsem to
>synchronize with "rbd map".  If mapping an image fails after the watch
>is established and a header update notify sneaks in, we deadlock when
>erroring out from rbd_dev_image_probe().
>
>Move watch registration and unregistration out of the critical section.
>The only reason they were put there was to make header_rwsem management
>slightly more obvious.
>
>Fixes: 811c66887746 ("rbd: fix rbd map vs notify races")
>Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>Reviewed-by: Jason Dillaman <dillaman@redhat.com>

There was a conflict with:

	b9ef2b8858a0 ("rbd: don't establish watch for read-only	mappings")

And I ended up with a funny resolution, but given the conflict at hand I
think it makes sense:

@@ -6135,6 +6145,8 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 err_out_probe:
        rbd_dev_unprobe(rbd_dev);
 err_out_watch:
+       if (!depth)
+               up_write(&rbd_dev->header_rwsem);
        if (!depth)
                rbd_unregister_watch(rbd_dev);
 err_out_format:

Queued for 5.4-4.14.

-- 
Thanks,
Sasha
