Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3681D2D802C
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 21:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392302AbgLKUrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 15:47:12 -0500
Received: from foss.arm.com ([217.140.110.172]:51798 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391666AbgLKUrL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 15:47:11 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B637331B;
        Fri, 11 Dec 2020 12:46:24 -0800 (PST)
Received: from e113632-lin (e113632-lin.cambridge.arm.com [10.1.194.46])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8E003F68F;
        Fri, 11 Dec 2020 12:46:22 -0800 (PST)
References: <cover.1607036601.git.reinette.chatre@intel.com> <c8eebc438e057e4bc2ce00256664b7bb0561b323.1607036601.git.reinette.chatre@intel.com>
User-agent: mu4e 0.9.17; emacs 26.3
From:   Valentin Schneider <valentin.schneider@arm.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     tglx@linutronix.de, fenghua.yu@intel.com, bp@alien8.de,
        tony.luck@intel.com, kuo-lang.tseng@intel.com, shakeelb@google.com,
        mingo@redhat.com, babu.moger@amd.com, james.morse@arm.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/resctrl: Update PQR_ASSOC MSR synchronously when moving task to resource group
In-reply-to: <c8eebc438e057e4bc2ce00256664b7bb0561b323.1607036601.git.reinette.chatre@intel.com>
Date:   Fri, 11 Dec 2020 20:46:17 +0000
Message-ID: <jhjlfe4t6jq.mognet@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 03/12/20 23:25, Reinette Chatre wrote:
> Fixes: e02737d5b826 ("x86/intel_rdt: Add tasks files")
> Reported-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: Valentin Schneider <valentin.schneider@arm.com>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Cc: stable@vger.kernel.org

Some pedantic comments below; with James' task_curr() + task_cpu()
suggestion:

Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>

> ---
>  static int __rdtgroup_move_task(struct task_struct *tsk,
>                               struct rdtgroup *rdtgrp)
>  {
> -	struct task_move_callback *callback;
> -	int ret;
> -
> -	callback = kzalloc(sizeof(*callback), GFP_KERNEL);
> -	if (!callback)
> -		return -ENOMEM;
> -	callback->work.func = move_myself;
> -	callback->rdtgrp = rdtgrp;
> -
>       /*
> -	 * Take a refcount, so rdtgrp cannot be freed before the
> -	 * callback has been invoked.
> +	 * Set the task's closid/rmid before the PQR_ASSOC MSR can be
> +	 * updated by them.
> +	 *
> +	 * For ctrl_mon groups, move both closid and rmid.
> +	 * For monitor groups, can move the tasks only from
> +	 * their parent CTRL group.
>        */
> -	atomic_inc(&rdtgrp->waitcount);
> -	ret = task_work_add(tsk, &callback->work, TWA_RESUME);
> -	if (ret) {
> -		/*
> -		 * Task is exiting. Drop the refcount and free the callback.
> -		 * No need to check the refcount as the group cannot be
> -		 * deleted before the write function unlocks rdtgroup_mutex.
> -		 */
> -		atomic_dec(&rdtgrp->waitcount);
> -		kfree(callback);
> -		rdt_last_cmd_puts("Task exited\n");
> -	} else {
> -		/*
> -		 * For ctrl_mon groups move both closid and rmid.
> -		 * For monitor groups, can move the tasks only from
> -		 * their parent CTRL group.
> -		 */
> -		if (rdtgrp->type == RDTCTRL_GROUP) {
> -			tsk->closid = rdtgrp->closid;
> +
> +	if (rdtgrp->type == RDTCTRL_GROUP) {
> +		tsk->closid = rdtgrp->closid;
> +		tsk->rmid = rdtgrp->mon.rmid;
> +	} else if (rdtgrp->type == RDTMON_GROUP) {
> +		if (rdtgrp->mon.parent->closid == tsk->closid) {
>                       tsk->rmid = rdtgrp->mon.rmid;
> -		} else if (rdtgrp->type == RDTMON_GROUP) {
> -			if (rdtgrp->mon.parent->closid == tsk->closid) {
> -				tsk->rmid = rdtgrp->mon.rmid;
> -			} else {
> -				rdt_last_cmd_puts("Can't move task to different control group\n");
> -				ret = -EINVAL;
> -			}
> +		} else {
> +			rdt_last_cmd_puts("Can't move task to different control group\n");
> +			return -EINVAL;
>               }
> +	} else {
> +		rdt_last_cmd_puts("Invalid resource group type\n");
> +		return -EINVAL;
>       }

James already pointed out this should be a WARN_ON_ONCE(), but is that the
right place to assert rdtgrp->type validity?

I see only a single assignment to rdtgrp->type in mkdir_rdt_prepare();
could we fail the group creation there instead if the passed rtype is
invalid?

> -	return ret;
> +
> +	/*
> +	 * By now, the task's closid and rmid are set. If the task is current
> +	 * on a CPU, the PQR_ASSOC MSR needs to be updated to make the resource
> +	 * group go into effect. If the task is not current, the MSR will be
> +	 * updated when the task is scheduled in.
> +	 */
> +	update_task_closid_rmid(tsk);

We need the above writes to be compile-ordered before the IPI is sent.
There *is* a preempt_disable() down in smp_call_function_single() that
gives us the required barrier(), can we deem that sufficient or would we
want one before update_task_closid_rmid() for the sake of clarity?

> +
> +	return 0;
>  }
>
>  static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)
