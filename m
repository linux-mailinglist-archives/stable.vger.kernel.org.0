Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E424D7D3F
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 09:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237461AbiCNIIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 04:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237899AbiCNIIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 04:08:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304C3443F7;
        Mon, 14 Mar 2022 01:06:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FE9EB80BE7;
        Mon, 14 Mar 2022 08:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145AAC340E9;
        Mon, 14 Mar 2022 08:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647245175;
        bh=gb7LFv9e2vRdyKjuKd26Rvil+QCxagd9WC/7n/TYZAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yq6711oJFJjBjOj6CYAbE53+aSvGy45cd1euulJAqKCaiH91Z4uVgmB5rdVe48/eD
         KTNSS2vKZvW1FcRhcN5QeniQvGD+1YET0IeT8XST9R4m+K+1F63pF5yucx6QhY3Kvs
         qNrlqbj8H6Fz3EvPM5j4WxKb5XPOCsJwwatmMV3k=
Date:   Mon, 14 Mar 2022 09:06:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zhao Gongyi <zhaogongyi@huawei.com>,
        Zhang Qiao <zhangqiao22@huawei.com>,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH 4.19 01/34] cgroup/cpuset: Fix a race between
 cpuset_attach() and cpu hotplug
Message-ID: <Yi73dKB10LBTGb+S@kroah.com>
References: <20220228172207.090703467@linuxfoundation.org>
 <20220228172208.566431934@linuxfoundation.org>
 <20220308151232.GA21752@blackbody.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220308151232.GA21752@blackbody.suse.cz>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 08, 2022 at 04:12:32PM +0100, Michal Koutný wrote:
> Hello.
> 
> On Mon, Feb 28, 2022 at 06:24:07PM +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > [...]
> >      cpuset_attach()				cpu hotplug
> >     ---------------------------            ----------------------
> >     down_write(cpuset_rwsem)
> >     guarantee_online_cpus() // (load cpus_attach)
> > 					sched_cpu_deactivate
> > 					  set_cpu_active()
> > 					  // will change cpu_active_mask
> >     set_cpus_allowed_ptr(cpus_attach)
> >       __set_cpus_allowed_ptr_locked()
> >        // (if the intersection of cpus_attach and
> >          cpu_active_mask is empty, will return -EINVAL)
> >     up_write(cpuset_rwsem)
> > [...]
> > --- a/kernel/cgroup/cpuset.c
> > +++ b/kernel/cgroup/cpuset.c
> > @@ -1528,6 +1528,7 @@ static void cpuset_attach(struct cgroup_
> >  	cgroup_taskset_first(tset, &css);
> >  	cs = css_cs(css);
> >  
> > +	cpus_read_lock();
> >  	mutex_lock(&cpuset_mutex);
> 
> This backport (and possible older kernels) looks suspicious since it comes
> before commit d74b27d63a8b ("cgroup/cpuset: Change cpuset_rwsem and
> hotplug lock order") v5.4-rc1~176^2~30 when the locking order was:
> cpuset lock, cpus lock.
> 
> At the same time it also comes before commit 710da3c8ea7d ("sched/core:
> Prevent race condition between cpuset and __sched_setscheduler()")
> v5.4-rc1~176^2~27 when neither __sched_setscheduler() cared and this
> race is similar. (The swapped locking may still conflict with
> rebuild_sched_domains() before d74b27d63a8b.)

Thanks for noticing this.  What do you recommend to do to resolve this?

thanks,

greg k-h
