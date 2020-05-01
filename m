Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFBD1C1E2C
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 22:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgEAUGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 16:06:17 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:16390 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbgEAUGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 16:06:16 -0400
X-Greylist: delayed 2664 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 May 2020 16:06:16 EDT
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041JN6vN020977;
        Fri, 1 May 2020 20:27:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=FIb1tRSakOixa+KWRoQwQxkx2NZ7hP7elrzO5eAo2xQ=;
 b=HaZQ4QnFRwOyGdnOW8jnUd0CBlZwxoilEXTBO5jKomHjZLo+9MIRyC7/PjV6BijWAG64
 EMQqmBozS+ft/tl+ryi4e8Ez+1RIHkh+J7DcfpuYyuRlgO9XbB3DkrytCdSV44s67dj4
 JYZmW3W81fxXb0ai/pOcBcvI8JpKfrs4OH2lQJMOImka0Y4W8se3OeN1v9hGN8pjbAIv
 mzFLn8MVAKaFBHcvoolc6Cy1aa4Id5OD93Lk4nbKfnl38vjVs1Kn2Ds5OFMSAh1n+IxT
 U8vZUFqQuSMFg5D8nv+0YnAiqH8L/n6Nx00sYfUHsohKDBcEx5B7zIRBcPB9oEoZDrgx 7A== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 30r7jqbfqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 20:27:19 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.27/8.16.0.27) with SMTP id 041JIvlP013453;
        Fri, 1 May 2020 12:27:18 -0700
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint5.akamai.com with ESMTP id 30mk6909vh-1;
        Fri, 01 May 2020 12:27:18 -0700
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id DAD2034906;
        Fri,  1 May 2020 19:27:17 +0000 (GMT)
Subject: Re: [PATCH 2/2] epoll: atomically remove wait entry on wake up
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Heiher <r@hev.cc>,
        stable@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200430130326.1368509-1-rpenyaev@suse.de>
 <20200430130326.1368509-2-rpenyaev@suse.de>
From:   Jason Baron <jbaron@akamai.com>
Message-ID: <6cb1fc30-d4a1-f483-48b7-9fa594d9e46f@akamai.com>
Date:   Fri, 1 May 2020 15:27:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430130326.1368509-2-rpenyaev@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_14:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002250000 definitions=main-2005010143
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_11:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 impostorscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010143
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/30/20 9:03 AM, Roman Penyaev wrote:
> This patch does two things:
> 
> 1. fixes lost wakeup introduced by:
>   339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")
> 
> 2. improves performance for events delivery.
> 
> The description of the problem is the following: if N (>1) threads
> are waiting on ep->wq for new events and M (>1) events come, it is
> quite likely that >1 wakeups hit the same wait queue entry, because
> there is quite a big window between __add_wait_queue_exclusive() and
> the following __remove_wait_queue() calls in ep_poll() function.  This
> can lead to lost wakeups, because thread, which was woken up, can
> handle not all the events in ->rdllist. (in better words the problem
> is described here: https://lkml.org/lkml/2019/10/7/905)
> 
> The idea of the current patch is to use init_wait() instead of
> init_waitqueue_entry(). Internally init_wait() sets
> autoremove_wake_function as a callback, which removes the wait entry
> atomically (under the wq locks) from the list, thus the next coming
> wakeup hits the next wait entry in the wait queue, thus preventing
> lost wakeups.
> 
> Problem is very well reproduced by the epoll60 test case [1].
> 
> Wait entry removal on wakeup has also performance benefits, because
> there is no need to take a ep->lock and remove wait entry from the
> queue after the successful wakeup. Here is the timing output of
> the epoll60 test case:
> 
>   With explicit wakeup from ep_scan_ready_list() (the state of the
>   code prior 339ddb53d373):
> 
>     real    0m6.970s
>     user    0m49.786s
>     sys     0m0.113s
> 
>  After this patch:
> 
>    real    0m5.220s
>    user    0m36.879s
>    sys     0m0.019s
> 
> The other testcase is the stress-epoll [2], where one thread consumes
> all the events and other threads produce many events:
> 
>   With explicit wakeup from ep_scan_ready_list() (the state of the
>   code prior 339ddb53d373):
> 
>     threads  events/ms  run-time ms
>           8       5427         1474
>          16       6163         2596
>          32       6824         4689
>          64       7060         9064
>         128       6991        18309
> 
>  After this patch:
> 
>     threads  events/ms  run-time ms
>           8       5598         1429
>          16       7073         2262
>          32       7502         4265
>          64       7640         8376
>         128       7634        16767
> 
>  (number of "events/ms" represents event bandwidth, thus higher is
>   better; number of "run-time ms" represents overall time spent
>   doing the benchmark, thus lower is better)
> 
> [1] tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c
> [2] https://github.com/rouming/test-tools/blob/master/stress-epoll.c
> 
> Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Khazhismel Kumykov <khazhy@google.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Heiher <r@hev.cc>
> Cc: Jason Baron <jbaron@akamai.com>
> Cc: stable@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  fs/eventpoll.c | 43 ++++++++++++++++++++++++-------------------
>  1 file changed, 24 insertions(+), 19 deletions(-)
> 

Looks good to me and nice speedups.
Reviewed-by: Jason Baron <jbaron@akamai.com>

Thanks,

-Jason


