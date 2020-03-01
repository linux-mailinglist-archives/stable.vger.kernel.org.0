Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8FC0174ADC
	for <lists+stable@lfdr.de>; Sun,  1 Mar 2020 04:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgCADLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 22:11:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgCADLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Feb 2020 22:11:30 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D50962192A;
        Sun,  1 Mar 2020 03:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583032290;
        bh=ZUVdFgH1vJCAZMnf9e1GdLgCw44/12P7SIlksJcKsLQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kBgdPv2dv7RO+zzgOXZ4OSNJM5lMjdbaKKHUOYJlbuaoVlELPP0Q3L+LNuCRBMXAW
         tJMz4LdEQvX/6CatG8U9g8Fu4sUxFYlwQOEDhkxcxyRMF1rdAxQ5wfa46MVBLVV1EE
         Bhq+dwZVW9pnpElTnskJhLQXTYKnSqnqfBXsi5q8=
Date:   Sat, 29 Feb 2020 22:11:28 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        Andrew Forgue <andrewf@apple.com>, vincent.guittot@linaro.org,
        peterz@infradead.org, dietmar.eggemann@arm.com,
        rafael.j.wysocki@intel.com
Subject: Re: Fixes for 4.19 stable
Message-ID: <20200301031128.GK21491@sasha-vm>
References: <6CF798B4-B68B-4729-A496-2152FC032ABC@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6CF798B4-B68B-4729-A496-2152FC032ABC@apple.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 28, 2020 at 12:13:54PM -0800, Vishnu Rangayyan wrote:
>Hi,
>
>I still see high (upto 30%) ksoftirqd cpu use with 4.19.101+ after these 2 back ports went in for 4.19.101
>(had all 4 backports applied earlier to our tree):
>
>commit f6783319737f28e4436a69611853a5a098cbe974 sched/fair: Fix insertion in rq->leaf_cfs_rq_list
>commit 5d299eabea5a251fbf66e8277704b874bbba92dc sched/fair: Add tmp_alone_branch assertion
>
>perf shows for any given ksoftirqd, with 20k-30k processes on the system with high scheduler load:
>  58.88%  ksoftirqd/0  [kernel.kallsyms]  [k] update_blocked_averages
>
>Can we backport these 2 also, confirmed that it fixes this behavior of ksoftirqd.
>
>commit 039ae8bcf7a5f4476f4487e6bf816885fb3fb617 upstream
>commit 31bc6aeaab1d1de8959b67edbed5c7a4b3cdbe7c upstream

Do we also need bef69dd87828 ("sched/cpufreq: Move the
cfs_rq_util_change() call to cpufreq_update_util()") then?

-- 
Thanks,
Sasha
