Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8285BEC2C
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 19:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiITRoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 13:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiITRog (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 13:44:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249A965B6
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 10:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B79FB625B0
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 17:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA128C433D6;
        Tue, 20 Sep 2022 17:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663695874;
        bh=xkaGSrs0Th5sRStyC6w5uA1QGT3bAp9Lx8pe7nInHXo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WKMJB3vO20S/7QdVGNumg99v6DmCt33C3wDZIs1BRMp+q3oTbjgQDwhcl3/WQ0b9e
         W3Yr6+vSAEDaOeAnWiZW0uBolRDqsghWgLnLAIKq9h0wTXBaZzwPtTFtsKE9bCw8Mr
         Uiys/p2mJT8vZhxDcm2WB8h4NZ0dbHU6qzyalX6w=
Date:   Tue, 20 Sep 2022 19:44:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stefan Ghinea <stefan.ghinea@windriver.com>
Cc:     stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 5.10 1/1] video: fbdev: i740fb: Error out if 'pixclock'
 equals zero
Message-ID: <Yyn7/wECKwE+djII@kroah.com>
References: <20220919210302.29792-1-stefan.ghinea@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919210302.29792-1-stefan.ghinea@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 20, 2022 at 12:03:02AM +0300, Stefan Ghinea wrote:
> From: Zheyu Ma <zheyuma97@gmail.com>
> 
> commit 15cf0b82271b1823fb02ab8c377badba614d95d5 upstream
> 
> The userspace program could pass any values to the driver through
> ioctl() interface. If the driver doesn't check the value of 'pixclock',
> it may cause divide error.
> 
> Fix this by checking whether 'pixclock' is zero in the function
> i740fb_check_var().
> 
> The following log reveals it:
> 
> divide error: 0000 [#1] PREEMPT SMP KASAN PTI
> RIP: 0010:i740fb_decode_var drivers/video/fbdev/i740fb.c:444 [inline]
> RIP: 0010:i740fb_set_par+0x272f/0x3bb0 drivers/video/fbdev/i740fb.c:739
> Call Trace:
>     fb_set_var+0x604/0xeb0 drivers/video/fbdev/core/fbmem.c:1036
>     do_fb_ioctl+0x234/0x670 drivers/video/fbdev/core/fbmem.c:1112
>     fb_ioctl+0xdd/0x130 drivers/video/fbdev/core/fbmem.c:1191
>     vfs_ioctl fs/ioctl.c:51 [inline]
>     __do_sys_ioctl fs/ioctl.c:874 [inline]
> 
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
> Signed-off-by: Helge Deller <deller@gmx.de>
> Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
> ---
>  drivers/video/fbdev/i740fb.c | 3 +++
>  1 file changed, 3 insertions(+)

Both backports now queued up, thanks.

greg k-h
