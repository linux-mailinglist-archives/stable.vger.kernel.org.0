Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A402FD04BD
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 02:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbfJIAYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 20:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbfJIAYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 20:24:03 -0400
Received: from localhost (unknown [131.107.159.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F378206C2;
        Wed,  9 Oct 2019 00:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570580642;
        bh=+ncexPhO5N2yz7tqdiK8iKmiLz17cOxeGldSbHcI04Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zxPqpTDQ8mKxdjZ7NLoKDZ0OuSNCtuyx4MQpyPqGxxJvUkgPfA5owgdHm+L2qoKZT
         zjboqhJqa8pJxD+5w+huVCpHFHZlrr2N3JjpA+uZq9ETPe7umm+jw55R342hFqlFdx
         FNCAmep1ojox4XCYFNpmjy9505sJs384vo50xWuQ=
Date:   Tue, 8 Oct 2019 20:12:36 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     srikar@linux.vnet.ibm.com, acme@redhat.com, eranian@google.com,
        jolsa@kernel.org, namhyung@kernel.org,
        naveen.n.rao@linux.vnet.ibm.com, ravi.bangoria@linux.ibm.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] perf stat: Reset previous counts on
 repeat with interval" failed to apply to 5.3-stable tree
Message-ID: <20191009001236.GO1396@sasha-vm>
References: <157055530314038@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157055530314038@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 07:21:43PM +0200, gregkh@linuxfoundation.org wrote:
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
>From b63fd11cced17fcb8e133def29001b0f6aaa5e06 Mon Sep 17 00:00:00 2001
>From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>Date: Wed, 4 Sep 2019 15:17:37 +0530
>Subject: [PATCH] perf stat: Reset previous counts on repeat with interval
>
>When using 'perf stat' with repeat and interval option, it shows wrong
>values for events.
>
>The wrong values will be shown for the first interval on the second and
>subsequent repetitions.
>
>Without the fix:
>
>  # perf stat -r 3 -I 2000 -e faults -e sched:sched_switch -a sleep 5
>
>     2.000282489                 53      faults
>     2.000282489                513      sched:sched_switch
>     4.005478208              3,721      faults
>     4.005478208              2,666      sched:sched_switch
>     5.025470933                395      faults
>     5.025470933              1,307      sched:sched_switch
>     2.009602825 1,84,46,74,40,73,70,95,47,520      faults 		<------
>     2.009602825 1,84,46,74,40,73,70,95,49,568      sched:sched_switch  <------
>     4.019612206              4,730      faults
>     4.019612206              2,746      sched:sched_switch
>     5.039615484              3,953      faults
>     5.039615484              1,496      sched:sched_switch
>     2.000274620 1,84,46,74,40,73,70,95,47,520      faults		<------
>     2.000274620 1,84,46,74,40,73,70,95,47,520      sched:sched_switch	<------
>     4.000480342              4,282      faults
>     4.000480342              2,303      sched:sched_switch
>     5.000916811              1,322      faults
>     5.000916811              1,064      sched:sched_switch
>  #
>
>prev_raw_counts is allocated when using intervals. This is used when
>calculating the difference in the counts of events when using interval.
>
>The current counts are stored in prev_raw_counts to calculate the
>differences in the next iteration.
>
>On the first interval of the second and subsequent repetitions,
>prev_raw_counts would be the values stored in the last interval of the
>previous repetitions, while the current counts will only be for the
>first interval of the current repetition.
>
>Hence there is a possibility of events showing up as big number.
>
>Fix this by resetting prev_raw_counts whenever perf stat repeats the
>command.
>
>With the fix:
>
>  # perf stat -r 3 -I 2000 -e faults -e sched:sched_switch -a sleep 5
>
>     2.019349347              2,597      faults
>     2.019349347              2,753      sched:sched_switch
>     4.019577372              3,098      faults
>     4.019577372              2,532      sched:sched_switch
>     5.019415481              1,879      faults
>     5.019415481              1,356      sched:sched_switch
>     2.000178813              8,468      faults
>     2.000178813              2,254      sched:sched_switch
>     4.000404621              7,440      faults
>     4.000404621              1,266      sched:sched_switch
>     5.040196079              2,458      faults
>     5.040196079                556      sched:sched_switch
>     2.000191939              6,870      faults
>     2.000191939              1,170      sched:sched_switch
>     4.000414103                541      faults
>     4.000414103                902      sched:sched_switch
>     5.000809863                450      faults
>     5.000809863                364      sched:sched_switch
>  #
>
>Committer notes:
>
>This was broken since the cset introducing the --interval feature, i.e.
>--repeat + --interval wasn't tested at that point, add the Fixes tag so
>that automatic scripts can pick this up.
>
>Fixes: 13370a9b5bb8 ("perf stat: Add interval printing")
>Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>Acked-by: Jiri Olsa <jolsa@kernel.org>
>Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>Tested-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
>Cc: Namhyung Kim <namhyung@kernel.org>
>Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>Cc: Stephane Eranian <eranian@google.com>
>Cc: stable@vger.kernel.org # v3.9+
>Link: http://lore.kernel.org/lkml/20190904094738.9558-2-srikar@linux.vnet.ibm.com
>[ Fixed up conflicts with libperf, i.e. some perf_{evsel,evlist} lost the 'perf' prefix ]
>Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Conflicts due to the perf_evsel -> evsel rename. Fixed up and queued for
all kernels.

-- 
Thanks,
Sasha
