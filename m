Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7D71E4AC6
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 18:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391551AbgE0Qql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 12:46:41 -0400
Received: from muru.com ([72.249.23.125]:55860 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389014AbgE0Qqh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 12:46:37 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id C200A80DB;
        Wed, 27 May 2020 16:47:26 +0000 (UTC)
Date:   Wed, 27 May 2020 09:46:33 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        YueHaibing <yuehaibing@huawei.com>, linux-kernel@vger.kernel.org,
        kernel@pyra-handheld.com, letux-kernel@openphoenux.org,
        linux-omap@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/4] w1: omap-hdq: fix interrupt handling which did show
 spurious timeouts
Message-ID: <20200527164633.GJ37466@atomide.com>
References: <cover.1590255176.git.hns@goldelico.com>
 <68fc8623ae741878beef049273696d2377526165.1590255176.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <68fc8623ae741878beef049273696d2377526165.1590255176.git.hns@goldelico.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* H. Nikolaus Schaller <hns@goldelico.com> [200523 17:34]:
> Since
> 
> commit 27d13da8782a ("w1: omap-hdq: Simplify driver with PM runtime autosuspend")
> 
> was applied,
> 
> I did see timeouts and wrong values when reading a bq27000 connected
> to hdq of the omap3. This occurred mainly after boot but remained and
> only sometimes settled down after several reads.
> 
> root@letux:~# time cat /sys/class/power_supply/bq27000-battery/uevent
> POWER_SUPPLY_NAME=bq27000-battery
> POWER_SUPPLY_STATUS=Discharging
> POWER_SUPPLY_PRESENT=1
> POWER_SUPPLY_VOLTAGE_NOW=0
> POWER_SUPPLY_CURRENT_NOW=0
> POWER_SUPPLY_CAPACITY=0
> POWER_SUPPLY_CAPACITY_LEVEL=Normal
> POWER_SUPPLY_TEMP=-2731
> POWER_SUPPLY_TIME_TO_EMPTY_NOW=0
> POWER_SUPPLY_TIME_TO_EMPTY_AVG=0
> POWER_SUPPLY_TIME_TO_FULL_NOW=0
> POWER_SUPPLY_TECHNOLOGY=Li-ion
> POWER_SUPPLY_CHARGE_FULL=0
> POWER_SUPPLY_CHARGE_NOW=0
> POWER_SUPPLY_CHARGE_FULL_DESIGN=0
> POWER_SUPPLY_CYCLE_COUNT=0
> POWER_SUPPLY_ENERGY_NOW=0
> POWER_SUPPLY_POWER_AVG=0
> POWER_SUPPLY_HEALTH=Good
> POWER_SUPPLY_MANUFACTURER=Texas Instruments
> 
> real    0m15.761s
> user    0m0.001s
> sys     0m0.025s
> root@letux:~#
> 
> Sometimes the effect did disappear after accessing
> the device multiple times, speed went up and results
> became correct.
> 
> All this indicates that some interrupts from the hdq
> controller are lost by the driver.
> 
> Enabling debugging revealed that there were spurious tx
> and rx timeouts, i.e. the driver does not always recognise
> interrupts. The main problem is that rx and tx interrupts
> share a single variable which was sometimes reset to
> 0 wiping out other interrupts. And it was overwritten
> by a second interrupt, independent of whether the
> previous interrupt was already processed or not.
> 
> This patch improves interrupt handling to avoid such
> races and loss of interrupt flags.

Good to hear you got it figured out :) Looks OK to me:

Acked-by: Tony Lindgren <tony@atomide.com>
