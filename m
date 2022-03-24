Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D3B4E6753
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 17:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352045AbiCXQ41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 12:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352106AbiCXQ4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 12:56:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670B998F5A;
        Thu, 24 Mar 2022 09:53:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57384B824A6;
        Thu, 24 Mar 2022 16:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9C1C340EC;
        Thu, 24 Mar 2022 16:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648140810;
        bh=RScfqBuaHBvINh3Oshl5Oe9QzFycEgDhFH1156Kqxtw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zCJjsK4CfPhNrswjvgITtlBe/SyLu6cstafWsWugsHVr4b2j+Jz96U4V3lyp/8/2r
         dpzIEKUwgXX3sRDX/3Z/IrJUiDD/gfeBfP+T1GAyvijHINXuf2emShERIiYDDSq4mg
         W55rAAJ/0iGEqrXGwsgm+jF4Qtavlk2hPns4yuAg=
Date:   Thu, 24 Mar 2022 17:53:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dan Vacura <w36195@motorola.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: gadget: uvc: Fix crash when encoding data for
 usb request
Message-ID: <YjyiB6IlfbMSGKZ2@kroah.com>
References: <20220318164706.22365-1-w36195@motorola.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318164706.22365-1-w36195@motorola.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 18, 2022 at 11:47:06AM -0500, Dan Vacura wrote:
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
> Fixes: d692522577c0 ("usb: gadget/uvc: Port UVC webcam gadget to use videobuf2 framework")
> Signed-off-by: Dan Vacura <w36195@motorola.com>
> 
> ---
> Changes in v2:
> - Add Fixes tag

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
