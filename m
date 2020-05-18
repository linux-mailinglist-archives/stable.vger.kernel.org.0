Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC681D891B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 22:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgERUZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 16:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgERUZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 16:25:38 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EBC820643;
        Mon, 18 May 2020 20:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589833537;
        bh=n/AJNzIqOGK3k3i8uTfeOxcd4iC5EjLvpksE2xWdpO8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lDiYzOeGUtHXYfLGM6Jq7hHrE8CugUF3Qgi+hYePpg1is6oLCF36Lgh00jj3Z2KL7
         LOY9+25077N8zIyF8zKSXMwVS7kTim5u4cuBcvLgFpNj7dfEMPotlQSLnRAQoXQYlW
         hk5XD2Uv1AkxIYkwX0cmitFL2EIYlkc+YiYp0PZE=
Date:   Mon, 18 May 2020 16:25:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Clay McClure <clay@daemons.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.6 019/194] net: Make PTP-specific drivers depend on
 PTP_1588_CLOCK
Message-ID: <20200518202535.GE33628@sasha-vm>
References: <20200518173531.455604187@linuxfoundation.org>
 <20200518173533.160651742@linuxfoundation.org>
 <05fd5be4-a969-2b7f-52e4-754d9651a280@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <05fd5be4-a969-2b7f-52e4-754d9651a280@ti.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 09:13:54PM +0300, Grygorii Strashko wrote:
>Hi Greg,
>
>On 18/05/2020 20:35, Greg Kroah-Hartman wrote:
>>From: Clay McClure <clay@daemons.net>
>>
>>[ Upstream commit b6d49cab44b567b3e0a5544b3d61e516a7355fad ]
>>
>>Commit d1cbfd771ce8 ("ptp_clock: Allow for it to be optional") changed
>>all PTP-capable Ethernet drivers from `select PTP_1588_CLOCK` to `imply
>>PTP_1588_CLOCK`, "in order to break the hard dependency between the PTP
>>clock subsystem and ethernet drivers capable of being clock providers."
>>As a result it is possible to build PTP-capable Ethernet drivers without
>>the PTP subsystem by deselecting PTP_1588_CLOCK. Drivers are required to
>>handle the missing dependency gracefully.
>>
>>Some PTP-capable Ethernet drivers (e.g., TI_CPSW) factor their PTP code
>>out into separate drivers (e.g., TI_CPTS_MOD). The above commit also
>>changed these PTP-specific drivers to `imply PTP_1588_CLOCK`, making it
>>possible to build them without the PTP subsystem. But as Grygorii
>>Strashko noted in [1]:
>>
>>On Wed, Apr 22, 2020 at 02:16:11PM +0300, Grygorii Strashko wrote:
>>
>>>Another question is that CPTS completely nonfunctional in this case and
>>>it was never expected that somebody will even try to use/run such
>>>configuration (except for random build purposes).
>>
>>In my view, enabling a PTP-specific driver without the PTP subsystem is
>>a configuration error made possible by the above commit. Kconfig should
>>not allow users to create a configuration with missing dependencies that
>>results in "completely nonfunctional" drivers.
>>
>>I audited all network drivers that call ptp_clock_register() but merely
>>`imply PTP_1588_CLOCK` and found five PTP-specific drivers that are
>>likely nonfunctional without PTP_1588_CLOCK:
>>
>>     NET_DSA_MV88E6XXX_PTP
>>     NET_DSA_SJA1105_PTP
>>     MACB_USE_HWSTAMP
>>     CAVIUM_PTP
>>     TI_CPTS_MOD
>>
>>Note how these symbols all reference PTP or timestamping in their name;
>>this is a clue that they depend on PTP_1588_CLOCK.
>>
>>Change them from `imply PTP_1588_CLOCK` [2] to `depends on PTP_1588_CLOCK`.
>>I'm not using `select PTP_1588_CLOCK` here because PTP_1588_CLOCK has
>>its own dependencies, which `select` would not transitively apply.
>>
>>Additionally, remove the `select NET_PTP_CLASSIFY` from CPTS_TI_MOD;
>>PTP_1588_CLOCK already selects that.
>>
>>[1]: https://lore.kernel.org/lkml/c04458ed-29ee-1797-3a11-7f3f560553e6@ti.com/
>>
>>[2]: NET_DSA_SJA1105_PTP had never declared any type of dependency on
>>PTP_1588_CLOCK (`imply` or otherwise); adding a `depends on PTP_1588_CLOCK`
>>here seems appropriate.
>>
>>Cc: Arnd Bergmann <arnd@arndb.de>
>>Cc: Richard Cochran <richardcochran@gmail.com>
>>Cc: Nicolas Pitre <nico@fluxnic.net>
>>Cc: Grygorii Strashko <grygorii.strashko@ti.com>
>>Cc: Geert Uytterhoeven <geert@linux-m68k.org>
>>Fixes: d1cbfd771ce8 ("ptp_clock: Allow for it to be optional")
>>Signed-off-by: Clay McClure <clay@daemons.net>
>>Signed-off-by: David S. Miller <davem@davemloft.net>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>
>Could you drop this patch, pls?
>it's not for stable and can cause build failures.

My bad - now dropped. Sorry!

-- 
Thanks,
Sasha
