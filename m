Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9047165EAA9
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 13:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjAEM3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 07:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjAEM27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 07:28:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D22715FCB
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 04:28:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AC51619FF
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 12:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624FFC433EF;
        Thu,  5 Jan 2023 12:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672921737;
        bh=gAgsYgqYRCbmwEZsn8idYeijbpgxSOVxoTFeEuqJovc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aV3JlQIyjxyuA3vUExci1H79dAHBeL8Cp6ujv9F3w829Pk4cGo/tRIIzJFn0iPGhc
         qYJMCEmSZRuWwTognoBFiDBz6ut4Vqw5pBJ2411ffH07RvbXoOMZglRjmcgvXZ3I9U
         naDLkvsyj45hLZ82MHdjczt41Pd5ho8Z/KwrV7Yg=
Date:   Thu, 5 Jan 2023 13:28:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lee Jones <lee@kernel.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        John Keeping <john@metanate.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 481/731] usb: gadget: f_hid: fix f_hidg lifetime vs
 cdev
Message-ID: <Y7bCgNu1ZXlCHmPm@kroah.com>
References: <20221228144256.536395940@linuxfoundation.org>
 <20221228144310.493605271@linuxfoundation.org>
 <Y7bACmZQdEhlf121@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7bACmZQdEhlf121@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 12:18:18PM +0000, Lee Jones wrote:
> On Wed, 28 Dec 2022, Greg Kroah-Hartman wrote:
> 
> > From: John Keeping <john@metanate.com>
> > 
> > [ Upstream commit 89ff3dfac604614287ad5aad9370c3f984ea3f4b ]
> > 
> > The embedded struct cdev does not have its lifetime correctly tied to
> > the enclosing struct f_hidg, so there is a use-after-free if /dev/hidgN
> > is held open while the gadget is deleted.
> > 
> > This can readily be replicated with libusbgx's example programs (for
> > conciseness - operating directly via configfs is equivalent):
> > 
> > 	gadget-hid
> > 	exec 3<> /dev/hidg0
> > 	gadget-vid-pid-remove
> > 	exec 3<&-
> > 
> > Pull the existing device up in to struct f_hidg and make use of the
> > cdev_device_{add,del}() helpers.  This changes the lifetime of the
> > device object to match struct f_hidg, but note that it is still added
> > and deleted at the same time.
> > 
> > Fixes: 71adf1189469 ("USB: gadget: add HID gadget driver")
> > Tested-by: Lee Jones <lee@kernel.org>
> > Reviewed-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> > Reviewed-by: Lee Jones <lee@kernel.org>
> > Signed-off-by: John Keeping <john@metanate.com>
> > Link: https://lore.kernel.org/r/20221122123523.3068034-2-john@metanate.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/usb/gadget/function/f_hid.c | 52 ++++++++++++++++-------------
> >  1 file changed, 28 insertions(+), 24 deletions(-)
>  
> Dear Stable,
> 
> Would you be kind enough to take this back as far back as linux.4.14.y
> please?  There is a trivial fix-up required for kernels older than
> v5.15, but it's the same fix-up back through v4.14.

This is already in the queue for 5.10, 5.4, and 4.19, but for some
reason not in 4.14.  Can you verify that the 4.19 version works there
too?

thanks,

greg k-h
