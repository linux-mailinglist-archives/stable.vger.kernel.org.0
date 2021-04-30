Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787D536F978
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 13:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhD3Lk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 07:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229875AbhD3Lkz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 07:40:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42967613E7;
        Fri, 30 Apr 2021 11:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619782807;
        bh=OjYzE8T7BuqxJ1VhQlAFv+4eubSMW/QGjcutTf6y2+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V/ToOwGejOhOwWuf9hwzPC0G7hrYeEhLuLxfWAgEx3gMHULOEBQaiikDtkd4k6t7/
         fQn+u69UszqWaRtIWG8s/Ax7q9vkkl4Z/OcNt8o9z6wAgY1FcP8b3bxwwWZOTgsYQX
         +b4y7b4wRrbQvr4eoONRzKRm1VTgwP2aYvFTOkPQ=
Date:   Fri, 30 Apr 2021 13:40:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kasper Zwijsen <Kasper.Zwijsen@ugent.be>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "security@kernel.org" <security@kernel.org>, stable@vger.kernel.org
Subject: Re: Semantic Bug: Privilege Bypass in timerfd for 4.4.y
Message-ID: <YIvslbdvfnwANjge@kroah.com>
References: <PR2PR09MB3180C560FF0F6CAEE9654A47F85E9@PR2PR09MB3180.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PR2PR09MB3180C560FF0F6CAEE9654A47F85E9@PR2PR09MB3180.eurprd09.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 10:57:59AM +0000, Kasper Zwijsen wrote:
> Dear Thomas Gleixner,
> 
> 
> I believe I have found a semantic security bug in the form of a missing capability check in the timerfd_create and timerfd_settime system calls for the 4.4.y LTS kernel.
> 
> In this commit: https://github.com/torvalds/linux/commit/2895a5e5b3ae78d9923a91fce405d4a2f32c4309,
> capability checks for CAP_WAKE_ALARM were added for creating and setting a CLOCK_BOOTTIME_ALARM and CLOCK_REALTIME_ALARM.
> This security patch was applied to all but one LTS kernel, namely 4.4.y.

That is because it showed up in the 4.8 release, there was nothing to
"apply" to any newer kernels :)

> It is therefore still possible for a user process without any privileges to create and set such a timer, resulting in the process being able to wake up the system.
> 
> The man pages state that creating or setting such a timer requires privileges. Similarly, the timer_create system call does check the correct permissions.
> I therefore believe this is unintended and a semantic bug.
> I have tested the original patch and found that it can simply be applied to the latest 4.4.y kernel (4.4.268 as of right now) without any issues.
> The patch: https://lore.kernel.org/patchwork/patch/686888/


I've now queued this up for the next 4.4.y release.  In the future, you
should just email the stable@vger.kernel.org address any git commit ids
that you feel need to be backported.

thanks!

greg k-h
