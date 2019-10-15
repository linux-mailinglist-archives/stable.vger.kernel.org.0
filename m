Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25395D7276
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 11:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfJOJrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 05:47:53 -0400
Received: from foss.arm.com ([217.140.110.172]:33884 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfJOJrx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 05:47:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3C5E28;
        Tue, 15 Oct 2019 02:47:51 -0700 (PDT)
Received: from [10.1.194.37] (e113632-lin.cambridge.arm.com [10.1.194.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D45D13F68E;
        Tue, 15 Oct 2019 02:47:50 -0700 (PDT)
Subject: Re: [PATCH] sched/topology: Disable sched_asym_cpucapacity on domain
 destruction
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Quentin Perret <qperret@google.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Quentin Perret <qperret@qperret.net>,
        "# v4 . 16+" <stable@vger.kernel.org>
References: <20191014114710.22142-1-valentin.schneider@arm.com>
 <20191014121648.GA53234@google.com>
 <CAKfTPtDoBrE=npY_Ay1pucdXsW1yQr1UiaCGq1DXKa2VmNqcUg@mail.gmail.com>
 <fe5977ab-0a70-e705-fcca-246c7dc3d23f@arm.com>
 <20191014135256.GA85340@google.com>
 <2b058430-1951-3d58-ebf4-8195a28ff233@arm.com>
 <c5fec41b-87f1-be4e-475f-69c7394f5467@arm.com>
From:   Valentin Schneider <valentin.schneider@arm.com>
Message-ID: <30d20b89-2108-5eed-2d2c-df99331d2320@arm.com>
Date:   Tue, 15 Oct 2019 10:47:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c5fec41b-87f1-be4e-475f-69c7394f5467@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/10/2019 10:22, Dietmar Eggemann wrote:
> I still don't understand the benefit of the counter approach here.
> sched_smt_present counts the number of cores with SMT. So in case you
> have 2 SMT cores with 2 HW threads and you CPU hp out one CPU, you still
> have sched_smt_present, although 1 CPU doesn't have a SMT thread sibling
> anymore.
> 
> Valentin's patch makes sure that sched_asym_cpucapacity is correctly set
> when the sd hierarchy is rebuild due to CPU hp. Including the unlikely
> scenario that an asymmetric CPU capacity system (based on DT's
> capacity-dmips-mhz values) turns normal SMT because of the max frequency
> values of the CPUs involved.
> 
> Systems with a mix of asymmetric and symmetric CPU capacity rd's have to
> live with the fact that wake_cap and misfit handling is enabled for
> them. This should be the case already today.
> 

Good point, that's what I slowly came to realize this morning.

> There should be no SD_ASYM_CPUCAPACITY flag on the sd's of the CPUs of
> the symmetric CPU capacity rd's. I.e. update_top_cache_domain() should
> set sd_asym_cpucapacity=NULL for those CPUs.
> 
> So as a rule we could say even if a static key enables a code path, a
> derefenced sd still has to be checked against NULL.
> 

Yeah, I think there's no escaping it. Let me see if I can do something
sensible regarding the static key.
