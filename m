Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19633CF726
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 11:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhGTJFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 05:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233602AbhGTJFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 05:05:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 419FC60230;
        Tue, 20 Jul 2021 09:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626774350;
        bh=FrOkYivcAO96cYhGi2qpCO+Jdfg8pb5DTqTaS7rbcpI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MrN52bq+Pn0IVXQI0rH/5ELEh+Vdqhf3o0BpOG33XDIbFgLtyW5ZBi65tFpfjSiXP
         vlb8Snm/wmXn3s3ybYjqsW6PLa1DxCFYRuTXCjSfIye1MXnM4YUmIto0timK1r3W4A
         QplaQBegBFQVmHZthFxyP+9Qt2p3hRDw/aYt3AOo=
Date:   Tue, 20 Jul 2021 11:45:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lukasz Luba <lukasz.luba@arm.com>
Cc:     linux-kernel@vger.kernel.org, Chris.Redpath@arm.com,
        dietmar.eggemann@arm.com, morten.rasmussen@arm.com,
        qperret@google.com, linux-pm@vger.kernel.org,
        stable@vger.kernel.org, peterz@infradead.org, rjw@rjwysocki.net,
        viresh.kumar@linaro.org, vincent.guittot@linaro.org,
        mingo@redhat.com, juri.lelli@redhat.com, rostedt@goodmis.org,
        segall@google.com, mgorman@suse.de, bristot@redhat.com,
        CCj.Yeh@mediatek.com
Subject: Re: [PATCH v2 1/1] PM: EM: Increase energy calculation precision
Message-ID: <YPabR/dfllPVZbzu@kroah.com>
References: <20210720094153.31097-1-lukasz.luba@arm.com>
 <20210720094153.31097-2-lukasz.luba@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720094153.31097-2-lukasz.luba@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 20, 2021 at 10:41:53AM +0100, Lukasz Luba wrote:
> The Energy Model (EM) provides useful information about device power in
> each performance state to other subsystems like: Energy Aware Scheduler
> (EAS). The energy calculation in EAS does arithmetic operation based on
> the EM em_cpu_energy(). Current implementation of that function uses
> em_perf_state::cost as a pre-computed cost coefficient equal to:
> cost = power * max_frequency / frequency.
> The 'power' is expressed in milli-Watts (or in abstract scale).
> 
> There are corner cases when the EAS energy calculation for two Performance
> Domains (PDs) return the same value. The EAS compares these values to
> choose smaller one. It might happen that this values are equal due to
> rounding error. In such scenario, we need better resolution, e.g. 1000
> times better. To provide this possibility increase the resolution in the
> em_perf_state::cost for 64-bit architectures. The costs for increasing
> resolution in 32-bit architectures are pretty high (64-bit division) and
> the returns do not justify the increased costs.
> 
> This patch allows to avoid the rounding to milli-Watt errors, which might
> occur in EAS energy estimation for each Performance Domains (PD). The
> rounding error is common for small tasks which have small utilization
> value.
> 
> There are two places in the code where it makes a difference:
> 1. In the find_energy_efficient_cpu() where we are searching for
> best_delta. We might suffer there when two PDs return the same result,
> like in the example below.
> 
> Scenario:
> Low utilized system e.g. ~200 sum_util for PD0 and ~220 for PD1. There
> are quite a few small tasks ~10-15 util. These tasks would suffer for
> the rounding error. Such system utilization has been seen while playing
> some simple games. In such condition our partner reported 5..10mA less
> battery drain.
> 
> Some details:
> We have two Perf Domains (PDs): PD0 (big) and PD1 (little)
> Let's compare w/o patch set ('old') and w/ patch set ('new')
> We are comparing energy w/ task and w/o task placed in the PDs
> 
> a) 'old' w/o patch set, PD0
> task_util = 13
> cost = 480
> sum_util_w/o_task = 215
> sum_util_w_task = 228
> scale_cpu = 1024
> energy_w/o_task = 480 * 215 / 1024 = 100.78 => 100
> energy_w_task = 480 * 228 / 1024 = 106.87 => 106
> energy_diff = 106 - 100 = 6
> (this is equal to 'old' PD1's energy_diff in 'c)')
> 
> b) 'new' w/ patch set, PD0
> task_util = 13
> cost = 480 * 1000 = 480000
> sum_util_w/o_task = 215
> sum_util_w_task = 228
> energy_w/o_task = 480000 * 215 / 1024 = 100781
> energy_w_task = 480000 * 228 / 1024  = 106875
> energy_diff = 106875 - 100781 = 6094
> (this is not equal to 'new' PD1's energy_diff in 'd)')
> 
> c) 'old' w/o patch set, PD1
> task_util = 13
> cost = 160
> sum_util_w/o_task = 283
> sum_util_w_task = 293
> scale_cpu = 355
> energy_w/o_task = 160 * 283 / 355 = 127.55 => 127
> energy_w_task = 160 * 296 / 355 = 133.41 => 133
> energy_diff = 133 - 127 = 6
> (this is equal to 'old' PD0's energy_diff in 'a)')
> 
> d) 'new' w/ patch set, PD1
> task_util = 13
> cost = 160 * 1000 = 160000
> sum_util_w/o_task = 283
> sum_util_w_task = 293
> scale_cpu = 355
> energy_w/o_task = 160000 * 283 / 355 = 127549
> energy_w_task = 160000 * 296 / 355 =   133408
> energy_diff = 133408 - 127549 = 5859
> (this is not equal to 'new' PD0's energy_diff in 'b)')
> 
> 2. Difference in the the last find_energy_efficient_cpu(): margin filter.
> With this patch the margin comparison also has better resolution,
> so it's possible to have better task placement thanks to that.
> 
> Fixes: 27871f7a8a341ef ("PM: Introduce an Energy Model management framework")
> Reported-by: CCJ Yeh <CCj.Yeh@mediatek.com>
> Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
> ---
>  include/linux/energy_model.h | 16 ++++++++++++++++
>  kernel/power/energy_model.c  |  3 ++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
