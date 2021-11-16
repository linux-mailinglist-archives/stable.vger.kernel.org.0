Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF40453396
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 15:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbhKPOHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 09:07:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237079AbhKPOHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 09:07:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4511B61ABD;
        Tue, 16 Nov 2021 14:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637071461;
        bh=UnLqzcTwNNM3goU0hrPMatP9soI0rIPG0zoXUH9Kx+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wkmUtsWfyTPPW9jzhIkrTvjpfg93PDBlywgjSPJa+OLgsRooN3NjovjmjXAEIL3vz
         M1gYqfuUskgFekTUvkSasuCtoz89BLFWhJQnNN8UFVHSeA7zoQ5TufWxwfhlSFE2NJ
         6QO251oIasjmFM5yv7GGMnHbaO9dlgmIXqjI/c1g=
Date:   Tue, 16 Nov 2021 15:04:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.14 232/849] leds: trigger: use RCU to protect the
 led_cdevs list
Message-ID: <YZO6YwBAaOwatrQ8@kroah.com>
References: <20211115165419.961798833@linuxfoundation.org>
 <20211115165428.044566164@linuxfoundation.org>
 <20211116114147.GD16318@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116114147.GD16318@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 12:41:47PM +0100, Pavel Machek wrote:
> On Mon 2021-11-15 17:55:15, Greg Kroah-Hartman wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > [ Upstream commit 2a5a8fa8b23144d14567d6f8293dd6fbeecee393 ]
> > 
> > Even with the previous commit 27af8e2c90fb
> > ("leds: trigger: fix potential deadlock with libata")
> > to this file, we still get lockdep unhappy, and Boqun
> > explained the report here:
> > https://lore.kernel.org/r/YNA+d1X4UkoQ7g8a@boqun-archlinux
> > 
> > Effectively, this means that the read_lock_irqsave() isn't
> > enough here because another CPU might be trying to do a
> > write lock, and thus block the readers.
> > 
> > This is all pretty messy, but it doesn't seem right that
> > the LEDs framework imposes some locking requirements on
> > users, in particular we'd have to make the spinlock in the
> > iwlwifi driver always disable IRQs, even if we don't need
> > that for any other reason, just to avoid this deadlock.
> > 
> > Since writes to the led_cdevs list are rare (and are done
> > by userspace), just switch the list to RCU. This costs a
> > synchronize_rcu() at removal time so we can ensure things
> > are correct, but that seems like a small price to pay for
> > getting lock-free iterations and no deadlocks (nor any
> > locking requirements imposed on users.)
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Please drop. We discussed this with Johannes, and it was not marked
> for stable on purpose. Bug is rather obscure and change did not have
> enough testing.

Now dropped from 5.14.y and 5.15.y

thanks,

greg k-h
