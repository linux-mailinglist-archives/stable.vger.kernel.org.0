Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE40C21726A
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbgGGPcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:32:55 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30927 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728655AbgGGPcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 11:32:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594135974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fI6zyW/Q6dQ0mgMSvs1HAB1XmZOZ4PZvn8vJbh28b3s=;
        b=KetIa+cCQUtf2qdDl4ufoGgxI2UU27SNsh/IMp14iGxVIAQoY9pc2EKZVnIt01OH27E8NW
        Pa5bp1DH/hZrFpFjC1yxDjHsC7EB//9ysYrdaWu00JNRMuy1jsc9pVLnsDT9prvy/7tyV1
        V/2eZTBVvJo5nUHCmG73Q2x9XWE5Z8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-F94UkfFIPM6ewwm_MEYMXg-1; Tue, 07 Jul 2020 11:32:52 -0400
X-MC-Unique: F94UkfFIPM6ewwm_MEYMXg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A5BC1005510;
        Tue,  7 Jul 2020 15:32:51 +0000 (UTC)
Received: from pick.fieldses.org (ovpn-114-172.phx2.redhat.com [10.3.114.172])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F2E2A10013D7;
        Tue,  7 Jul 2020 15:32:50 +0000 (UTC)
Received: by pick.fieldses.org (Postfix, from userid 2815)
        id F26701202DC; Tue,  7 Jul 2020 11:32:49 -0400 (EDT)
Date:   Tue, 7 Jul 2020 11:32:49 -0400
From:   "J. Bruce Fields" <bfields@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5.7 070/112] kthread: save thread function
Message-ID: <20200707153249.GC171624@pick.fieldses.org>
References: <20200707145800.925304888@linuxfoundation.org>
 <20200707145804.332402326@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707145804.332402326@linuxfoundation.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

NACK to this and following patch.--b.

On Tue, Jul 07, 2020 at 05:17:15PM +0200, Greg Kroah-Hartman wrote:
> From: J. Bruce Fields <bfields@redhat.com>
> 
> [ Upstream commit 52782c92ac85c4e393eb4a903a62e6c24afa633f ]
> 
> It's handy to keep the kthread_fn just as a unique cookie to identify
> classes of kthreads.  E.g. if you can verify that a given task is
> running your thread_fn, then you may know what sort of type kthread_data
> points to.
> 
> We'll use this in nfsd to pass some information into the vfs.  Note it
> will need kthread_data() exported too.
> 
> Original-patch-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: J. Bruce Fields <bfields@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/linux/kthread.h |  1 +
>  kernel/kthread.c        | 17 +++++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/include/linux/kthread.h b/include/linux/kthread.h
> index 8bbcaad7ef0f4..c2a274b79c429 100644
> --- a/include/linux/kthread.h
> +++ b/include/linux/kthread.h
> @@ -57,6 +57,7 @@ bool kthread_should_stop(void);
>  bool kthread_should_park(void);
>  bool __kthread_should_park(struct task_struct *k);
>  bool kthread_freezable_should_stop(bool *was_frozen);
> +void *kthread_func(struct task_struct *k);
>  void *kthread_data(struct task_struct *k);
>  void *kthread_probe_data(struct task_struct *k);
>  int kthread_park(struct task_struct *k);
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index bfbfa481be3a5..b84fc7eec0358 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -46,6 +46,7 @@ struct kthread_create_info
>  struct kthread {
>  	unsigned long flags;
>  	unsigned int cpu;
> +	int (*threadfn)(void *);
>  	void *data;
>  	struct completion parked;
>  	struct completion exited;
> @@ -152,6 +153,20 @@ bool kthread_freezable_should_stop(bool *was_frozen)
>  }
>  EXPORT_SYMBOL_GPL(kthread_freezable_should_stop);
>  
> +/**
> + * kthread_func - return the function specified on kthread creation
> + * @task: kthread task in question
> + *
> + * Returns NULL if the task is not a kthread.
> + */
> +void *kthread_func(struct task_struct *task)
> +{
> +	if (task->flags & PF_KTHREAD)
> +		return to_kthread(task)->threadfn;
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(kthread_func);
> +
>  /**
>   * kthread_data - return data value specified on kthread creation
>   * @task: kthread task in question
> @@ -164,6 +179,7 @@ void *kthread_data(struct task_struct *task)
>  {
>  	return to_kthread(task)->data;
>  }
> +EXPORT_SYMBOL_GPL(kthread_data);
>  
>  /**
>   * kthread_probe_data - speculative version of kthread_data()
> @@ -244,6 +260,7 @@ static int kthread(void *_create)
>  		do_exit(-ENOMEM);
>  	}
>  
> +	self->threadfn = threadfn;
>  	self->data = data;
>  	init_completion(&self->exited);
>  	init_completion(&self->parked);
> -- 
> 2.25.1
> 
> 
> 

