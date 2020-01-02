Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0506A12E16D
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 02:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgABBFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 20:05:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgABBFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jan 2020 20:05:23 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3CED20863;
        Thu,  2 Jan 2020 01:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577927123;
        bh=+OjJVwrQe6z4q0Fc+7TX1UA3yFBSJSSw6AzyMyJTOlM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q2euln0San9MMyrdkNI3Wf8ehfVx2H9CwjO8Sr16ishzj4qj/gitAHvGMaBkg8lyG
         E0GzGEwQLtDQ72oZXSKbqbGSuDMK12rSx9thSt8GPDjcaMTqdDZjbitSYkUtYV5vC+
         Uv9PIQ7bDfXpUNbu1I3VziiznVU3tv4CZvfaNub0=
Date:   Wed, 1 Jan 2020 20:05:21 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     hdegoede@redhat.com, andriy.shevchenko@linux.intel.com,
        mika.westerberg@linux.intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] pinctrl: baytrail: Really serialize all
 register accesses" failed to apply to 4.19-stable tree
Message-ID: <20200102010521.GD16372@sasha-vm>
References: <1577634412127144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1577634412127144@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 04:46:52PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 40ecab551232972a39cdd8b6f17ede54a3fdb296 Mon Sep 17 00:00:00 2001
>From: Hans de Goede <hdegoede@redhat.com>
>Date: Tue, 19 Nov 2019 16:46:41 +0100
>Subject: [PATCH] pinctrl: baytrail: Really serialize all register accesses
>
>Commit 39ce8150a079 ("pinctrl: baytrail: Serialize all register access")
>added a spinlock around all register accesses because:
>
>"There is a hardware issue in Intel Baytrail where concurrent GPIO register
> access might result reads of 0xffffffff and writes might get dropped
> completely."
>
>Testing has shown that this does not catch all cases, there are still
>2 problems remaining
>
>1) The original fix uses a spinlock per byt_gpio device / struct,
>additional testing has shown that this is not sufficient concurent
>accesses to 2 different GPIO banks also suffer from the same problem.
>
>This commit fixes this by moving to a single global lock.
>
>2) The original fix did not add a lock around the register accesses in
>the suspend/resume handling.
>
>Since pinctrl-baytrail.c is using normal suspend/resume handlers,
>interrupts are still enabled during suspend/resume handling. Nothing
>should be using the GPIOs when they are being taken down, _but_ the
>GPIOs themselves may still cause interrupts, which are likely to
>use (read) the triggering GPIO. So we need to protect against
>concurrent GPIO register accesses in the suspend/resume handlers too.
>
>This commit fixes this by adding the missing spin_lock / unlock calls.
>
>The 2 fixes together fix the Acer Switch 10 SW5-012 getting completely
>confused after a suspend resume. The DSDT for this device has a bug
>in its _LID method which reprograms the home and power button trigger-
>flags requesting both high and low _level_ interrupts so the IRQs for
>these 2 GPIOs continuously fire. This combined with the saving of
>registers during suspend, triggers concurrent GPIO register accesses
>resulting in saving 0xffffffff as pconf0 value during suspend and then
>when restoring this on resume the pinmux settings get all messed up,
>resulting in various I2C busses being stuck, the wifi no longer working
>and often the tablet simply not coming out of suspend at all.
>
>Cc: stable@vger.kernel.org
>Fixes: 39ce8150a079 ("pinctrl: baytrail: Serialize all register access")
>Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

There were quite a few variable/struct renames in the file which
resulted in conflicts. I've fixed them up and queued for all branches.

-- 
Thanks,
Sasha
