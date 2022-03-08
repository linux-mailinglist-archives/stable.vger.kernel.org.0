Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAF74D1B67
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 16:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347804AbiCHPNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 10:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347769AbiCHPNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 10:13:32 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C53710C5;
        Tue,  8 Mar 2022 07:12:35 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CB33C1F388;
        Tue,  8 Mar 2022 15:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646752353; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BxPH7nt5TPZXBWMbjXfb0ej096MEr0JkhBc0/u6GevU=;
        b=cyt46GYaOI6J7Z5rYcz5ScPHcC9keNvMgOAj0NaXjqckcWfllCAin9wTIhR02TqS2nxtsd
        dnCAY+gdaWyCM66XkihTDE6VCGH5GEJW6udz+/0NFmhNEexZhmlmgIG7kq6gN7ERVqqVEh
        hCHtBNTUjVc18hnMj4rvB9LLpTzKwH0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A53AC13CE9;
        Tue,  8 Mar 2022 15:12:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4/fYJ2FyJ2K8TwAAMHmgww
        (envelope-from <mkoutny@suse.com>); Tue, 08 Mar 2022 15:12:33 +0000
Date:   Tue, 8 Mar 2022 16:12:32 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zhao Gongyi <zhaogongyi@huawei.com>,
        Zhang Qiao <zhangqiao22@huawei.com>,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH 4.19 01/34] cgroup/cpuset: Fix a race between
 cpuset_attach() and cpu hotplug
Message-ID: <20220308151232.GA21752@blackbody.suse.cz>
References: <20220228172207.090703467@linuxfoundation.org>
 <20220228172208.566431934@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228172208.566431934@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello.

On Mon, Feb 28, 2022 at 06:24:07PM +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> [...]
>      cpuset_attach()				cpu hotplug
>     ---------------------------            ----------------------
>     down_write(cpuset_rwsem)
>     guarantee_online_cpus() // (load cpus_attach)
> 					sched_cpu_deactivate
> 					  set_cpu_active()
> 					  // will change cpu_active_mask
>     set_cpus_allowed_ptr(cpus_attach)
>       __set_cpus_allowed_ptr_locked()
>        // (if the intersection of cpus_attach and
>          cpu_active_mask is empty, will return -EINVAL)
>     up_write(cpuset_rwsem)
> [...]
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1528,6 +1528,7 @@ static void cpuset_attach(struct cgroup_
>  	cgroup_taskset_first(tset, &css);
>  	cs = css_cs(css);
>  
> +	cpus_read_lock();
>  	mutex_lock(&cpuset_mutex);

This backport (and possible older kernels) looks suspicious since it comes
before commit d74b27d63a8b ("cgroup/cpuset: Change cpuset_rwsem and
hotplug lock order") v5.4-rc1~176^2~30 when the locking order was:
cpuset lock, cpus lock.

At the same time it also comes before commit 710da3c8ea7d ("sched/core:
Prevent race condition between cpuset and __sched_setscheduler()")
v5.4-rc1~176^2~27 when neither __sched_setscheduler() cared and this
race is similar. (The swapped locking may still conflict with
rebuild_sched_domains() before d74b27d63a8b.)


Michal

