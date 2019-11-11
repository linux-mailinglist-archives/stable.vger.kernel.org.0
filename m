Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E614DF74A1
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 14:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfKKNTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 08:19:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfKKNTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 08:19:09 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FAA22190F;
        Mon, 11 Nov 2019 13:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573478348;
        bh=qyBg9bdFVIL1EvyvpUhCDyDamOZmYL9V35D/8KSeDYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rQ5TwBuTzmjK2iH/6nrG9xwyiSJ8nhHqbPDmiZPaMAKQzoswUUt4cXB+N25Pluc+b
         ekqs1O17HQzS4j4VKhB82Ta36zozyoiZBIBWvZ/z6uejC7mQ0qA3Crq3YHz+dzttSR
         7Jy7CMjyOuc1FgCSa0Mwpy/pM70x75Fh5VoITHgE=
Date:   Mon, 11 Nov 2019 08:19:07 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     andriy.shevchenko@linux.intel.com, malin.jonsson@ericsson.com,
        mika.westerberg@linux.intel.com, oliver.barta@aptiv.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] pinctrl: intel: Avoid potential glitches
 if pin is in GPIO" failed to apply to 4.19-stable tree
Message-ID: <20191111131907.GR4787@sasha-vm>
References: <157345199314214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157345199314214@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 06:59:53AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From 29c2c6aa32405dfee4a29911a51ba133edcedb0f Mon Sep 17 00:00:00 2001
>From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>Date: Mon, 14 Oct 2019 12:51:04 +0300
>Subject: [PATCH] pinctrl: intel: Avoid potential glitches if pin is in GPIO
> mode
>
>When consumer requests a pin, in order to be on the safest side,
>we switch it first to GPIO mode followed by immediate transition
>to the input state. Due to posted writes it's luckily to be a single
>I/O transaction.
>
>However, if firmware or boot loader already configures the pin
>to the GPIO mode, user expects no glitches for the requested pin.
>We may check if the pin is pre-configured and leave it as is
>till the actual consumer toggles its state to avoid glitches.

I've queued it up for 4.19, it was just a minor conflict with
e58926e781d8 ("pinctrl: intel: Use GENMASK() consistently").

However, for 4.14 and older:

>Fixes: 7981c0015af2 ("pinctrl: intel: Add Intel Sunrisepoint pin controller and GPIO support")
>Depends-on: f5a26acf0162 ("pinctrl: intel: Initialize GPIO properly when used through irqchip")

We need to take this "Depends-on" commit, but in the past we have
reverted it:

https://lore.kernel.org/lkml/20180427135732.999030511@linuxfoundation.org/

So I didn't do anything with this patch for <=4.14.

-- 
Thanks,
Sasha
