Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4708E18A0E9
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 17:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgCRQxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 12:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgCRQxZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 12:53:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B62120724;
        Wed, 18 Mar 2020 16:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584550403;
        bh=UpJkneZMfg6zGdcSqBWcVrphpLZ4RdeFDw+xKE3Af/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jRDw7v3XYMwKjmEODPoFDqttLXEXXWgafxq/VMMojpr53XY2/iEl6hdX9jCn7dwop
         +Emwm+iZU64gOSIEjnC9DQKmiv/TQ9MhcykEzwQOOou10YkzNVqss9bo1peSOvya12
         sIePcjF5WXmMVXIOh1qR1z/Yrhj4f8DebUDBFBXA=
Date:   Wed, 18 Mar 2020 17:53:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linus.walleij@linaro.org, bjorn.andersson@linaro.org,
        david@ixit.cz, ilina@codeaurora.org, maz@kernel.org,
        swboyd@chromium.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] pinctrl: qcom: Assign irq_eoi
 conditionally" failed to apply to 5.4-stable tree
Message-ID: <20200318165320.GA3090655@kroah.com>
References: <1584358449195216@kroah.com>
 <20200318164023.GG4189@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318164023.GG4189@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 18, 2020 at 12:40:23PM -0400, Sasha Levin wrote:
> On Mon, Mar 16, 2020 at 12:34:09PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > > From 1cada2f307665e208a486d7ac2294ed9a6f74a6f Mon Sep 17 00:00:00 2001
> > From: Linus Walleij <linus.walleij@linaro.org>
> > Date: Mon, 9 Mar 2020 16:26:04 +0100
> > Subject: [PATCH] pinctrl: qcom: Assign irq_eoi conditionally
> > 
> > The hierarchical parts of MSM pinctrl/GPIO is only
> > used when the device tree has a "wakeup-parent" as
> > a phandle, but the .irq_eoi is anyway assigned leading
> > to semantic problems on elder Qualcomm chipsets.
> > 
> > When the drivers/mfd/qcom-pm8xxx.c driver calls
> > chained_irq_exit() that call will in turn call chip->irq_eoi()
> > which is set to irq_chip_eoi_parent() by default on a
> > hierachical IRQ chip, and the parent is pinctrl-msm.c
> > so that will in turn unconditionally call
> > irq_chip_eoi_parent() again, but its parent is invalid
> > so we get the following crash:
> > 
> > Unnable to handle kernel NULL pointer dereference at
> > virtual address 00000010
> > pgd = (ptrval)
> > [00000010] *pgd=00000000
> > Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> > (...)
> > PC is at irq_chip_eoi_parent+0x4/0x10
> > LR is at pm8xxx_irq_handler+0x1b4/0x2d8
> > 
> > If we solve this crash by avoiding to call up to
> > irq_chip_eoi_parent(), the machine will hang and get
> > reset by the watchdog, because of semantic issues,
> > probably inside irq_chip.
> > 
> > As a solution, just assign the .irq_eoi conditionally if
> > we are actually using a wakeup parent.
> > 
> > Cc: David Heidelberg <david@ixit.cz>
> > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Cc: Lina Iyer <ilina@codeaurora.org>
> > Cc: Stephen Boyd <swboyd@chromium.org>
> > Cc: stable@vger.kernel.org
> > Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
> 
> This shouldn't go in 5.4, e35a6ae0eb3a is not there.

Ah, grep failed me, there is another reference to that commit id in a
5.4.y release.

thanks,

greg k-h
