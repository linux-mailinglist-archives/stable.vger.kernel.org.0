Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3576F756D
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 14:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfKKNvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 08:51:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfKKNvn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 08:51:43 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13656206A3;
        Mon, 11 Nov 2019 13:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573480302;
        bh=1R+knT9QFYv3b8z7wjWjLCJDywXyJJz/PJgR4UVEDqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VPrAiLdjfcAxePQnpmXBStpMY7n00/06UEaYIzQPjnEhBrpbPgw3AwzW9pDgRrALY
         vuWkIwywei6tP5K9000KyCsnpDh8dFiy7h4cUraBYl0rTcCSH6YzjxFNtsKAQKWxna
         nYAn9IGyxLcvbwyPisgNCEC/VgYb9VypX4efA0Rw=
Date:   Mon, 11 Nov 2019 08:51:41 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     leonard.crestez@nxp.com, sboyd@kernel.org, shawnguo@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] clk: imx8m: Use SYS_PLL1_800M as
 intermediate parent of" failed to apply to 5.3-stable tree
Message-ID: <20191111135141.GC8496@sasha-vm>
References: <157345338112980@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157345338112980@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 07:23:01AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
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
>From b234fe9558615098d8d62516e7041ad7f99ebcea Mon Sep 17 00:00:00 2001
>From: Leonard Crestez <leonard.crestez@nxp.com>
>Date: Tue, 22 Oct 2019 22:21:28 +0300
>Subject: [PATCH] clk: imx8m: Use SYS_PLL1_800M as intermediate parent of
> CLK_ARM
>
>During cpu frequency switching the main "CLK_ARM" is reparented to an
>intermediate "step" clock. On imx8mm and imx8mn the 24M oscillator is
>used for this purpose but it is extremely slow, increasing wakeup
>latencies to the point that i2c transactions can timeout and system
>becomes unresponsive.
>
>Fix by switching the "step" clk to SYS_PLL1_800M, matching the behavior
>of imx8m cpufreq drivers in imx vendor tree.
>
>This bug was not immediately apparent because upstream arm64 defconfig
>uses the "performance" governor by default so no cpufreq transitions
>happen.
>
>Fixes: ba5625c3e272 ("clk: imx: Add clock driver support for imx8mm")
>Fixes: 96d6392b54db ("clk: imx: Add support for i.MX8MN clock driver")

96d6392b54db doesn't exist on 5.3, so I've modified the patch to only
fix the ba5625c3e272 related code and queued it for 5.3. Neither commit
exists on 4.19 and older.

-- 
Thanks,
Sasha
