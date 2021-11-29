Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327A2461C29
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 17:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347326AbhK2Qya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 11:54:30 -0500
Received: from relay.sw.ru ([185.231.240.75]:39272 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347769AbhK2Qwa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 11:52:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=q07RS84Jqk/jFfG+rfabh5rvPRD2zM0T5KpDWC9GQDQ=; b=vHu2UTIuTkyo2yuygNo
        lOOTkYy/HKYUtfNhCo+N4kq9Ousl6adsj5LEZMNUEge68yhgvuTtmlbqyQPXI/p/teQtR70NGYlXZ
        IW4QUvaGTwvHX7cfqpPaklfkvkFYz++oezpBWLRPK46SmB9xMynKMWyORQBfWFKRj/XC/QchO8I=;
Received: from [192.168.15.164] (helo=mikhalitsyn-laptop)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1mrjpx-001n0p-Ay; Mon, 29 Nov 2021 19:49:05 +0300
Date:   Mon, 29 Nov 2021 19:49:04 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, avagin@gmail.com, dave@stgolabs.net,
        ebiederm@xmission.com, manfred@colorfullife.com,
        ptikhomirov@virtuozzo.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vvs@virtuozzo.com,
        alexander@mihalicyn.com
Subject: Re: FAILED: patch
 "[PATCH] ipc: WARN if trying to remove ipc object which is absent" failed
 to apply to 4.4-stable tree
Message-Id: <20211129194904.d14d2270604c135d50efcc69@virtuozzo.com>
In-Reply-To: <163758371621116@kroah.com>
References: <163758371621116@kroah.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Nov 2021 13:21:56 +0100
<gregkh@linuxfoundation.org> wrote:

> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Dear Greg,

please drop this patch for 4.4.y tree, just because idr API in this tree
not allow us to check that something goes wrong with idr element remove

>void idr_remove(struct idr *idp, int id)
vs
>void *idr_remove(struct idr *, unsigned long id)

in the recent kernels.

Good news here is that we have some similar check inside idr_remove already:
>	if (id > idr_max(idp->layers)) {
>		idr_remove_warning(id);
>		return;
>	}

So, I think it's okay just to drop that patch.

Thanks,
Alex

> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 126e8bee943e9926238c891e2df5b5573aee76bc Mon Sep 17 00:00:00 2001
> From: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> Date: Fri, 19 Nov 2021 16:43:18 -0800
> Subject: [PATCH] ipc: WARN if trying to remove ipc object which is absent
> 
> Patch series "shm: shm_rmid_forced feature fixes".
> 
> Some time ago I met kernel crash after CRIU restore procedure,
> fortunately, it was CRIU restore, so, I had dump files and could do
> restore many times and crash reproduced easily.  After some
> investigation I've constructed the minimal reproducer.  It was found
> that it's use-after-free and it happens only if sysctl
> kernel.shm_rmid_forced = 1.
> 
> The key of the problem is that the exit_shm() function not handles shp's
> object destroy when task->sysvshm.shm_clist contains items from
> different IPC namespaces.  In most cases this list will contain only
> items from one IPC namespace.
> 
> How can this list contain object from different namespaces? The
> exit_shm() function is designed to clean up this list always when
> process leaves IPC namespace.  But we made a mistake a long time ago and
> did not add a exit_shm() call into the setns() syscall procedures.
> 
> The first idea was just to add this call to setns() syscall but it
> obviously changes semantics of setns() syscall and that's
> userspace-visible change.  So, I gave up on this idea.
> 
> The first real attempt to address the issue was just to omit forced
> destroy if we meet shp object not from current task IPC namespace [1].
> But that was not the best idea because task->sysvshm.shm_clist was
> protected by rwsem which belongs to current task IPC namespace.  It
> means that list corruption may occur.
> 
> Second approach is just extend exit_shm() to properly handle shp's from
> different IPC namespaces [2].  This is really non-trivial thing, I've
> put a lot of effort into that but not believed that it's possible to
> make it fully safe, clean and clear.
> 
> Thanks to the efforts of Manfred Spraul working an elegant solution was
> designed.  Thanks a lot, Manfred!
> 
> Eric also suggested the way to address the issue in ("[RFC][PATCH] shm:
> In shm_exit destroy all created and never attached segments") Eric's
> idea was to maintain a list of shm_clists one per IPC namespace, use
> lock-less lists.  But there is some extra memory consumption-related
> concerns.
> 
> An alternative solution which was suggested by me was implemented in
> ("shm: reset shm_clist on setns but omit forced shm destroy").  The idea
> is pretty simple, we add exit_shm() syscall to setns() but DO NOT
> destroy shm segments even if sysctl kernel.shm_rmid_forced = 1, we just
> clean up the task->sysvshm.shm_clist list.
> 
> This chages semantics of setns() syscall a little bit but in comparision
> to the "naive" solution when we just add exit_shm() without any special
> exclusions this looks like a safer option.
> 
> [1] https://lkml.org/lkml/2021/7/6/1108
> [2] https://lkml.org/lkml/2021/7/14/736
> 
> This patch (of 2):
> 
> Let's produce a warning if we trying to remove non-existing IPC object
> from IPC namespace kht/idr structures.
> 
> This allows us to catch possible bugs when the ipc_rmid() function was
> called with inconsistent struct ipc_ids*, struct kern_ipc_perm*
> arguments.
> 
> Link: https://lkml.kernel.org/r/20211027224348.611025-1-alexander.mikhalitsyn@virtuozzo.com
> Link: https://lkml.kernel.org/r/20211027224348.611025-2-alexander.mikhalitsyn@virtuozzo.com
> Co-developed-by: Manfred Spraul <manfred@colorfullife.com>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Andrei Vagin <avagin@gmail.com>
> Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> Cc: Vasily Averin <vvs@virtuozzo.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/ipc/util.c b/ipc/util.c
> index d48d8cfa1f3f..fa2d86ef3fb8 100644
> --- a/ipc/util.c
> +++ b/ipc/util.c
> @@ -447,8 +447,8 @@ static int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
>  static void ipc_kht_remove(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
>  {
>  	if (ipcp->key != IPC_PRIVATE)
> -		rhashtable_remove_fast(&ids->key_ht, &ipcp->khtnode,
> -				       ipc_kht_params);
> +		WARN_ON_ONCE(rhashtable_remove_fast(&ids->key_ht, &ipcp->khtnode,
> +				       ipc_kht_params));
>  }
>  
>  /**
> @@ -498,7 +498,7 @@ void ipc_rmid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
>  {
>  	int idx = ipcid_to_idx(ipcp->id);
>  
> -	idr_remove(&ids->ipcs_idr, idx);
> +	WARN_ON_ONCE(idr_remove(&ids->ipcs_idr, idx) != ipcp);
>  	ipc_kht_remove(ids, ipcp);
>  	ids->in_use--;
>  	ipcp->deleted = true;
> 
