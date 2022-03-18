Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2AD4DD998
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 13:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbiCRMUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 08:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236144AbiCRMUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 08:20:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626BF126590;
        Fri, 18 Mar 2022 05:18:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2020FB8220B;
        Fri, 18 Mar 2022 12:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D6AC340E8;
        Fri, 18 Mar 2022 12:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647605920;
        bh=q7Bseac7kpl38Kv3dDfiIH4Nix+AJwi5+kmqhdGmllg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MhYgYLfJnDIB9c7dr/aswJZNHs6IbIx5kRZ7S887Z8zop6s0ZDeoH4KgC4HqkcnZc
         vAgO9ykDezLJP3ydj7XFSxNf3NHFV3a6PsyEFdeT3KsQnPSCMdJsobPrckNSFQkX4J
         skkgHuWGCjiuQQFBiaDOqYGWf72emvml8iIPiQtw=
Date:   Fri, 18 Mar 2022 12:58:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dan Vacura <w36195@motorola.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: uvc: Fix crash when encoding data for usb
 request
Message-ID: <YjRz5z8rrxdmtGo5@kroah.com>
References: <20220315174146.27155-1-w36195@motorola.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315174146.27155-1-w36195@motorola.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 12:41:46PM -0500, Dan Vacura wrote:
> During the uvcg_video_pump() process, if an error occurs and
> uvcg_queue_cancel() is called, the buffer queue will be cleared out, but
> the current marker (queue->buf_used) of the active buffer (no longer
> active) is not reset. On the next iteration of uvcg_video_pump() the
> stale buf_used count will be used and the logic of min((unsigned
> int)len, buf->bytesused - queue->buf_used) may incorrectly calculate a
> nbytes size, causing an invalid memory access.
> 
> [80802.185460][  T315] configfs-gadget gadget: uvc: VS request completed
> with status -18.
> [80802.185519][  T315] configfs-gadget gadget: uvc: VS request completed
> with status -18.
> ...
> uvcg_queue_cancel() is called and the queue is cleared out, but the
> marker queue->buf_used is not reset.
> ...
> [80802.262328][ T8682] Unable to handle kernel paging request at virtual
> address ffffffc03af9f000
> ...
> ...
> [80802.263138][ T8682] Call trace:
> [80802.263146][ T8682]  __memcpy+0x12c/0x180
> [80802.263155][ T8682]  uvcg_video_pump+0xcc/0x1e0
> [80802.263165][ T8682]  process_one_work+0x2cc/0x568
> [80802.263173][ T8682]  worker_thread+0x28c/0x518
> [80802.263181][ T8682]  kthread+0x160/0x170
> [80802.263188][ T8682]  ret_from_fork+0x10/0x18
> [80802.263198][ T8682] Code: a8c12829 a88130cb a8c130
> 
> Signed-off-by: Dan Vacura <w36195@motorola.com>
> ---
>  drivers/usb/gadget/function/uvc_queue.c | 2 ++
>  1 file changed, 2 insertions(+)

What commit id does this change fix?  Can you resend this with a proper
"Fixes:" tag added to it?

thanks,

greg k-h
