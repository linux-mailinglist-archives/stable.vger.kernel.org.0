Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255BC57260E
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiGLTlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbiGLTlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:41:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DF0DB2EC;
        Tue, 12 Jul 2022 12:18:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9C1A617D6;
        Tue, 12 Jul 2022 19:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F06C3411C;
        Tue, 12 Jul 2022 19:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657653508;
        bh=2RIfHjzzeaQQhj9uzJXlcOnQBgDgLiWKmEU5gvafjvo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j90g64rUwySgLQcT0orHNtAHzvFnFtFE6pp8FersZsVoxYeAjFpRTW5qc8RgIviM1
         WqQN1mOSZWoDFl844y3L3krP+V9M/b/hKSzJ0KCD0tYaKBz9l0SkmSFthCDp3vUq6z
         yeEYHBsorNoBvvSiVhxj0eSSJVayidu2D8Zdd6rE=
Date:   Tue, 12 Jul 2022 21:18:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jimmy Assarsson <jimmyassarsson@gmail.com>
Cc:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jimmy Assarsson <extja@kvaser.com>
Subject: Re: [PATCH 4.14 1/4] can: kvaser_usb: Add struct kvaser_usb_dev_cfg
Message-ID: <Ys3JAReeZCbv+vbt@kroah.com>
References: <20220708184653.280882-1-extja@kvaser.com>
 <20220708184653.280882-2-extja@kvaser.com>
 <YsrgbqIFfcxXesWw@kroah.com>
 <5059cce9-76b4-b19c-2d97-c1e54c7dd87d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5059cce9-76b4-b19c-2d97-c1e54c7dd87d@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 10, 2022 at 08:40:30PM +0200, Jimmy Assarsson wrote:
> On 7/10/22 16:21, Greg KH wrote:
> > On Fri, Jul 08, 2022 at 08:46:50PM +0200, Jimmy Assarsson wrote:
> > > Add struct kvaser_usb_dev_cfg to ease backporting of upstream commits:
> > > 49f274c72357 (can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info)
> > > e6c80e601053 (can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression)
> > > b3b6df2c56d8 (can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits)
> > 
> > What upstream commit is this from?
> 
> Hi Greg,
> 
> The original upstream commit introducing struct kvaser_usb_dev_cfg is
> 7259124eac7d1b76b41c7a9cb2511a30556deebe
> can: kvaser_usb: Split driver into kvaser_usb_core.c and kvaser_usb_leaf.c
> And was first merged to 4.19.
> 
> This was part of a major restructure of the driver to add support for new type of devices.

Then why not just take thos commits, _OR_ rework the bugfixes to handle
the old style of drivers?

Doing this type of major change that is not directly upstream is almost
always a big mistake as it's not tested well and diverges from what is
in Linus's tree.

Please try to rework these two series and resubmit.

thanks,

greg k-h
