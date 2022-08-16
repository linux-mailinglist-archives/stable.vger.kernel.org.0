Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACAD0595A04
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbiHPL0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiHPLZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:25:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2366FDAA31;
        Tue, 16 Aug 2022 03:40:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4187B60FD8;
        Tue, 16 Aug 2022 10:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35338C433C1;
        Tue, 16 Aug 2022 10:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660646453;
        bh=gSjVtTMHmcCP+F+et6XLqR45DdAYSPHlIjBiEp42ecI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Trfn+xNeaMhBVprN8l/8VMDwytSHq5zftykSUZpB6TRpC0mn86ATen1rnJOWQ2Cou
         6wZz15kUEz4AvoSspVJ7y9x1md6yb/jNvGAFYztfx3cjG3BdZgio6qC07tguaEh0cp
         q3auma6NXE5b6m/r+8YaKxEYLng55jtfEbnhf9uU=
Date:   Tue, 16 Aug 2022 12:40:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 0191/1157] hwmon: (sht15) Fix wrong assumptions in
 device remove callback
Message-ID: <Yvt0Ms9ur2aSj2Zz@kroah.com>
References: <20220815180439.416659447@linuxfoundation.org>
 <20220815180447.391756473@linuxfoundation.org>
 <20220815214911.wy7p5sqbog6r6tcg@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220815214911.wy7p5sqbog6r6tcg@pengutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 11:49:11PM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> On Mon, Aug 15, 2022 at 07:52:27PM +0200, Greg Kroah-Hartman wrote:
> > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > 
> > [ Upstream commit 7d4edccc9bbfe1dcdff641343f7b0c6763fbe774 ]
> > 
> > Taking a lock at the beginning of .remove() doesn't prevent new readers.
> > With the existing approach it can happen, that a read occurs just when
> > the lock was taken blocking the reader until the lock is released at the
> > end of the remove callback which then accessed *data that is already
> > freed then.
> > 
> > To actually fix this problem the hwmon core needs some adaption. Until
> > this is implemented take the optimistic approach of assuming that all
> > readers are gone after hwmon_device_unregister() and
> > sysfs_remove_group() as most other drivers do. (And once the core
> > implements that, taking the lock would deadlock.)
> > 
> > So drop the lock, move the reset to after device unregistration to keep
> > the device in a workable state until it's deregistered. Also add a error
> > message in case the reset fails and return 0 anyhow. (Returning an error
> > code, doesn't stop the platform device unregistration and only results
> > in a little helpful error message before the devm cleanup handlers are
> > called.)
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Link: https://lore.kernel.org/r/20220725194344.150098-1-u.kleine-koenig@pengutronix.de
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Does this mean my concerns I expressed in the mail with Message-Id:
> 20220814155638.idxnihylofsxqlql@pengutronix.de were not taken into
> consideration?

I can't find that message-id on lore.kernel.org, do you have a link?

thanks,

greg k-h
