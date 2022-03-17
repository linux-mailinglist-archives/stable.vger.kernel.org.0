Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715E34DC3EB
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 11:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbiCQKZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 06:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbiCQKZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 06:25:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3CEEEA5C;
        Thu, 17 Mar 2022 03:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E8EDB81DB3;
        Thu, 17 Mar 2022 10:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CB3C340E9;
        Thu, 17 Mar 2022 10:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647512674;
        bh=68w1tBfa5hfpEaga9MZQXCX1hOMPkNsWM96WRhnVm0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=milHrrh/RcWjo06/GkwOiu42NyaO4rw8mEPLYsgrvJPx7L0ZcSZ7/uI+eugEqaMps
         16gqEj8ciZMM54g9BbHdceJdV9gT6RfCMy5W1VIaW9ucaMT1NxlQ6qV5LQYSeSb9ne
         MQRBRtXKd1IPZb9Oz2urK/gs7i9+TBTlQ8wwJmt8=
Date:   Thu, 17 Mar 2022 11:24:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Zhang Qiao <zhangqiao22@huawei.com>
Cc:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zhao Gongyi <zhaogongyi@huawei.com>,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH 4.19 01/34] cgroup/cpuset: Fix a race between
 cpuset_attach() and cpu hotplug
Message-ID: <YjMMX7jSU8ynwgON@kroah.com>
References: <20220228172207.090703467@linuxfoundation.org>
 <20220228172208.566431934@linuxfoundation.org>
 <20220308151232.GA21752@blackbody.suse.cz>
 <Yi73dKB10LBTGb+S@kroah.com>
 <aa25447a-f6ff-2ff2-72e9-3bbab1d430e9@huawei.com>
 <20220314111940.GC1035@blackbody.suse.cz>
 <YjHz2bifJBuCs/UK@kroah.com>
 <1ea13066-aa98-ead2-f50f-f62d030ce3c5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1ea13066-aa98-ead2-f50f-f62d030ce3c5@huawei.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 17, 2022 at 10:41:57AM +0800, Zhang Qiao wrote:
> 
> 
> 在 2022/3/16 22:27, Greg Kroah-Hartman 写道:
> > On Mon, Mar 14, 2022 at 12:19:41PM +0100, Michal Koutný wrote:
> >> Hello.
> >>
> >> In my opinion there are two approaches:
> >> a) drop this backport (given other races present),
> > 
> > I have no problem with that, want to send a revert patch?
> > 
> >> b) swap the locks compatible with v4.19 as this patch proposes.
> >>
> >> On Mon, Mar 14, 2022 at 05:11:50PM +0800, Zhang Qiao <zhangqiao22@huawei.com> wrote:
> >>> +       /*
> >>> +        * It should hold cpus lock because a cpu offline event can
> >>> +        * cause set_cpus_allowed_ptr() failed.
> >>> +        */
> >>> +       cpus_read_lock();
> >>
> >> Maybe just a nit, the old kernels before commit c5c63b9a6a2e ("cgroup:
> >> Replace deprecated CPU-hotplug functions.") v5.15-rc1~159^2~5
> >> would be more consistent with get_online_cpus() here (but they're
> >> equivalent functionally so the locking order is correct).
> > 
> > A fixed up patch would also be appreciated :)
> > 
> 
> Fixed up patch as follows, replace cpus_read_lock() with get_online_cpus().
> 
> thanks.
> 
> --------
> 
> 
> [PATCH] cpuset: Fix unsafe lock order between cpuset lock and cpuslock
> 
> The backport commit 4eec5fe1c680a ("cgroup/cpuset: Fix a race
> between cpuset_attach() and cpu hotplug") looks suspicious since
> it comes before commit d74b27d63a8b ("cgroup/cpuset: Change
> cpuset_rwsem and hotplug lock order") v5.4-rc1~176^2~30 when
> the locking order was: cpuset lock, cpus lock.
> 
> Fix it with the correct locking order and reduce the cpus locking
> range because only set_cpus_allowed_ptr() needs the protection of
> cpus lock.
> 
> Fixes: 4eec5fe1c680a ("cgroup/cpuset: Fix a race between cpuset_attach() and cpu hotplug")
> Reported-by: Michal Koutný <mkoutny@suse.com>
> Signed-off-by: Zhang Qiao <zhangqiao22@huawei.com>
> ---
>  kernel/cgroup/cpuset.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index d43d25acc..4e1c4232e 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1528,9 +1528,13 @@ static void cpuset_attach(struct cgroup_taskset *tset)
>         cgroup_taskset_first(tset, &css);
>         cs = css_cs(css);
> 
> -       cpus_read_lock();
>         mutex_lock(&cpuset_mutex);
> 
> +       /*
> +        * It should hold cpus lock because a cpu offline event can
> +        * cause set_cpus_allowed_ptr() failed.
> +        */
> +       get_online_cpus();
>         /* prepare for attach */
>         if (cs == &top_cpuset)
>                 cpumask_copy(cpus_attach, cpu_possible_mask);
> @@ -1549,6 +1553,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
>                 cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
>                 cpuset_update_task_spread_flag(cs, task);
>         }
> +       put_online_cpus();
> 
>         /*
>          * Change mm for all threadgroup leaders. This is expensive and may
> @@ -1584,7 +1589,6 @@ static void cpuset_attach(struct cgroup_taskset *tset)
>                 wake_up(&cpuset_attach_wq);
> 
>         mutex_unlock(&cpuset_mutex);
> -       cpus_read_unlock();
>  }
> 
>  /* The various types of files and directories in a cpuset file system */
> --
> 2.18.0
> 
> 

Argh, whitespace was corrupted :(

I've fixed this up by hand and queued it up...

greg k-h
