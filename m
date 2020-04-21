Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137FC1B33AC
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 01:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgDUX4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 19:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgDUX4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 19:56:41 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0E4A206D5;
        Tue, 21 Apr 2020 23:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587513401;
        bh=ctA1U9q3Zx90mf2b83dqC9BHPrOh5AkAmplZ2Db/ZdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zQh7TD4K1XAHmZ53qukEtX2YknU5nu/Izf+HI6YSUKIr7/jdMEow5szcA+SANiP+Y
         WWIVruxBjiz0oOg5YCutoir8jCGrErIx4mT7qiUBPHjWjXmYw8oFTcA/nqGH7tTvaV
         etgtDl4uby5y8yZr4GaXrImHGZ4b+lg2UqoZTHFE=
Date:   Tue, 21 Apr 2020 19:56:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     idryomov@gmail.com, dillaman@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] rbd: call rbd_dev_unprobe() after
 unwatching and flushing" failed to apply to 5.4-stable tree
Message-ID: <20200421235639.GN1809@sasha-vm>
References: <158748884210038@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158748884210038@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 07:07:22PM +0200, gregkh@linuxfoundation.org wrote:
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
>From 952c48b0ed18919bff7528501e9a3fff8a24f8cd Mon Sep 17 00:00:00 2001
>From: Ilya Dryomov <idryomov@gmail.com>
>Date: Mon, 16 Mar 2020 15:52:54 +0100
>Subject: [PATCH] rbd: call rbd_dev_unprobe() after unwatching and flushing
> notifies
>
>rbd_dev_unprobe() is supposed to undo most of rbd_dev_image_probe(),
>including rbd_dev_header_info(), which means that rbd_dev_header_info()
>isn't supposed to be called after rbd_dev_unprobe().
>
>However, rbd_dev_image_release() calls rbd_dev_unprobe() before
>rbd_unregister_watch().  This is racy because a header update notify
>can sneak in:
>
>  "rbd unmap" thread                   ceph-watch-notify worker
>
>  rbd_dev_image_release()
>    rbd_dev_unprobe()
>      free and zero out header
>                                       rbd_watch_cb()
>                                         rbd_dev_refresh()
>                                           rbd_dev_header_info()
>                                             read in header
>
>The same goes for "rbd map" because rbd_dev_image_probe() calls
>rbd_dev_unprobe() on errors.  In both cases this results in a memory
>leak.
>
>Fixes: fd22aef8b47c ("rbd: move rbd_unregister_watch() call into rbd_dev_image_release()")
>Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>Reviewed-by: Jason Dillaman <dillaman@redhat.com>

Another conflict because we miss b9ef2b8858a0 ("rbd: don't establish
watch for read-only mappings") on 5.4 and older. Fixed and queued up for
5.4-4.14.

-- 
Thanks,
Sasha
