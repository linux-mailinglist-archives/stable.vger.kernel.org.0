Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFFA59B270
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 09:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiHUHAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 03:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiHUHAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 03:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5D02A978;
        Sun, 21 Aug 2022 00:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2044B80BA8;
        Sun, 21 Aug 2022 07:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB50C433C1;
        Sun, 21 Aug 2022 07:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661065214;
        bh=WOM4Nyv3E4KUCgCalBOHyh7tljALqF9cO2FpVC93Dsg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P5nqA6/JwNGEoxKmIXlM2AfpJ8tHuvIPuRcsPx7rhBvZpVpKyhZlP5QTT+FpW/o1V
         Ve5PgLAz2juv5NojFPu7sIFE+W1bbdwLjkPls3JGs364nChsSPlShBVG0rjSJvRYQ0
         9ZwAA3Xb1BC6upMy1mwr9TSd7FCovq5IHi984YxU=
Date:   Sat, 20 Aug 2022 20:14:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 0191/1157] hwmon: (sht15) Fix wrong assumptions in
 device remove callback
Message-ID: <YwEkkn1xmGM5kHel@kroah.com>
References: <20220815180439.416659447@linuxfoundation.org>
 <20220815180447.391756473@linuxfoundation.org>
 <20220815214911.wy7p5sqbog6r6tcg@pengutronix.de>
 <Yvt0Ms9ur2aSj2Zz@kroah.com>
 <20220819193501.glb43pf64zkl7n3p@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220819193501.glb43pf64zkl7n3p@pengutronix.de>
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 09:35:01PM +0200, Uwe Kleine-König wrote:
> Hello Greg,
> 
> On Tue, Aug 16, 2022 at 12:40:50PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Aug 15, 2022 at 11:49:11PM +0200, Uwe Kleine-König wrote:
> > > On Mon, Aug 15, 2022 at 07:52:27PM +0200, Greg Kroah-Hartman wrote:
> > > > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > > 
> > > > [ Upstream commit 7d4edccc9bbfe1dcdff641343f7b0c6763fbe774 ]
> > > > 
> > > > Taking a lock at the beginning of .remove() doesn't prevent new readers.
> > > > With the existing approach it can happen, that a read occurs just when
> > > > the lock was taken blocking the reader until the lock is released at the
> > > > end of the remove callback which then accessed *data that is already
> > > > freed then.
> > > > 
> > > > To actually fix this problem the hwmon core needs some adaption. Until
> > > > this is implemented take the optimistic approach of assuming that all
> > > > readers are gone after hwmon_device_unregister() and
> > > > sysfs_remove_group() as most other drivers do. (And once the core
> > > > implements that, taking the lock would deadlock.)
> > > > 
> > > > So drop the lock, move the reset to after device unregistration to keep
> > > > the device in a workable state until it's deregistered. Also add a error
> > > > message in case the reset fails and return 0 anyhow. (Returning an error
> > > > code, doesn't stop the platform device unregistration and only results
> > > > in a little helpful error message before the devm cleanup handlers are
> > > > called.)
> > > > 
> > > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > > Link: https://lore.kernel.org/r/20220725194344.150098-1-u.kleine-koenig@pengutronix.de
> > > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > 
> > > Does this mean my concerns I expressed in the mail with Message-Id:
> > > 20220814155638.idxnihylofsxqlql@pengutronix.de were not taken into
> > > consideration?
> > 
> > I can't find that message-id on lore.kernel.org, do you have a link?
> 
> Oh, I missed your request earlier. No I don't have a link, the mail was
> sent to Sasha Levin, Jean Delvare, Guenter Roeck and stable-commits as I
> just replied to the "note to let you know that I've just added the patch
> titled [...] to the 5.19-stable tree".

Ok, I've dropped it now from all pending queues (5.10 and older), I can
also revert it from the newer ones if you want me to.

thanks,

greg k-h
