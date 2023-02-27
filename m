Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB08E6A4487
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 15:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjB0OfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 09:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjB0Oe7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 09:34:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB6310413;
        Mon, 27 Feb 2023 06:34:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E633960E8C;
        Mon, 27 Feb 2023 14:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71EAC433EF;
        Mon, 27 Feb 2023 14:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677508489;
        bh=mNT+8jEC5MkwBhOpq0tgcgDha3VE+qSBUhcJo3FtXNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KLgEB1pcgKXR3Zo7+YHhkbtHkJLT5X/bXixU+79b9Jszj62iwkMDEBanaUCodiU9q
         G6yJUP2bIBMbRvGcGG8Yxf4IY8fxJBRycSyKWqL4e8QqRv/9cCH1mCW8XlCWDDolbq
         5U6jUKTTRkDPKMA2w1fLpPfjr4xJEeIVJ0J80GgM=
Date:   Mon, 27 Feb 2023 15:34:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jean Delvare <jdelvare@suse.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Allen Ballway <ballway@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>, jikos@kernel.org,
        benjamin.tissoires@redhat.com, groeck@chromium.org,
        alistair@alistair23.me, dmitry.torokhov@gmail.com,
        jk@codeconstruct.com.au, Jonathan.Cameron@huawei.com,
        cmo@melexis.com, u.kleine-koenig@pengutronix.de,
        linux-input@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 10/25] HID: multitouch: Add quirks for
 flipped axes
Message-ID: <Y/y/huAI8dDdiBaq@kroah.com>
References: <20230227020855.1051605-1-sashal@kernel.org>
 <20230227020855.1051605-10-sashal@kernel.org>
 <20230227132300.4a3c3fad@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227132300.4a3c3fad@endymion.delvare>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 01:23:00PM +0100, Jean Delvare wrote:
> Hi Sasha,
> 
> On Sun, 26 Feb 2023 21:08:33 -0500, Sasha Levin wrote:
> > From: Allen Ballway <ballway@chromium.org>
> > 
> > [ Upstream commit a2f416bf062a38bb76cccd526d2d286b8e4db4d9 ]
> > 
> > Certain touchscreen devices, such as the ELAN9034, are oriented
> > incorrectly and report touches on opposite points on the X and Y axes.
> > For example, a 100x200 screen touched at (10,20) would report (90, 180)
> > and vice versa.
> > 
> > This is fixed by adding device quirks to transform the touch points
> > into the correct spaces, from X -> MAX(X) - X, and Y -> MAX(Y) - Y.
> > 
> > Signed-off-by: Allen Ballway <ballway@chromium.org>
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/hid/hid-multitouch.c             | 39 ++++++++++++++++++---
> >  drivers/hid/hid-quirks.c                 |  6 ++++
> >  drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c | 43 ++++++++++++++++++++++++
> >  drivers/hid/i2c-hid/i2c-hid.h            |  3 ++
> >  4 files changed, 87 insertions(+), 4 deletions(-)
> > (...)
> 
> Second rule of acceptance for stable patches:
> 
>  - It cannot be bigger than 100 lines, with context.
> 
> Clearly not met here.
> 
> To me, this commit is something distributions may want to backport if
> their users run are likely to run the affected hardware. But it's out
> of scope for stable kernel branches.

For new quirks and ids, this is totally fine, I do not see why we would
NOT want to take such a thing.

The 100 lines is a guideline, to make things easy to review.

thanks,

greg k-h
