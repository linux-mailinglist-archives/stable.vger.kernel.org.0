Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0098DD66CA
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 18:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732990AbfJNQDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 12:03:30 -0400
Received: from foss.arm.com ([217.140.110.172]:47854 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731121AbfJNQDa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 12:03:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9862A28;
        Mon, 14 Oct 2019 09:03:29 -0700 (PDT)
Received: from [10.1.194.37] (unknown [10.1.194.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D0CA3F718;
        Mon, 14 Oct 2019 09:03:28 -0700 (PDT)
Subject: Re: [PATCH] sched/topology: Disable sched_asym_cpucapacity on domain
 destruction
To:     Quentin Perret <qperret@google.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Quentin Perret <qperret@qperret.net>,
        "# v4 . 16+" <stable@vger.kernel.org>
References: <20191014114710.22142-1-valentin.schneider@arm.com>
 <20191014121648.GA53234@google.com>
 <CAKfTPtDoBrE=npY_Ay1pucdXsW1yQr1UiaCGq1DXKa2VmNqcUg@mail.gmail.com>
 <fe5977ab-0a70-e705-fcca-246c7dc3d23f@arm.com>
 <20191014135256.GA85340@google.com>
From:   Valentin Schneider <valentin.schneider@arm.com>
Message-ID: <2b058430-1951-3d58-ebf4-8195a28ff233@arm.com>
Date:   Mon, 14 Oct 2019 17:03:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191014135256.GA85340@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14/10/2019 14:52, Quentin Perret wrote:
> Right, but that's not possible by definition -- static keys aren't
> variables. The static keys for asym CPUs and for EAS are just to
> optimize the case when they're disabled, but when they _are_ enabled,
> you have no choice but do another per-rd check.
> 

Bleh, right, realized my nonsense after sending the email.

> And to clarify what I tried to say before, it might be possible to
> 'count' the number of RDs that have SD_ASYM_CPUCAPACITY set using
> static_branch_inc()/dec(), like we do for the SMT static key. I remember
> trying to do something like that for EAS, but that was easier said than
> done ... :)
> 

Gotcha, the reason I didn't go with this is that I wanted to maintain
the relationship between the key and the flag (you either have both or none).
It feels icky to have the key set and to have a NULL sd_asym_cpucapacity
pointer.

An alternative might be to have a separate counter for asymmetric rd's,
always disable the key on domain destruction and use that counter to figure
out if we need to restore it. If we don't care about having a NULL SD
pointer while the key is set, we could use the included counter as you're
suggesting. 

> Thanks,
> Quentin
> 
