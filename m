Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A5E66AD60
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 20:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjANT3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 14:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjANT3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 14:29:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781A059DA
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 11:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673724541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QWfM5pQs+X2RxT+eFAeQm31hR1pLtPf0Wpz6BXkOr+w=;
        b=Hy4AUs47oXIHUEDtbDFoYAtHcE/hcmsjYV5Be7SI7GoGEolxxVQUuOMGdshqqTbNwK2Uqy
        uyVQwZ/T6Pxi1fEpZPzupGEmft/FCUldUYk7+bbKEoDvOVR19ivG3i+MDZRARkOHSJpNoG
        TmdVpiD8E1UAJGqzSpRdV7D8bG+Zg5I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-MENKez8LMNOcpTJse_Nx_w-1; Sat, 14 Jan 2023 14:28:58 -0500
X-MC-Unique: MENKez8LMNOcpTJse_Nx_w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD730811E6E;
        Sat, 14 Jan 2023 19:28:57 +0000 (UTC)
Received: from [10.22.32.40] (unknown [10.22.32.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 864EB2026D68;
        Sat, 14 Jan 2023 19:28:57 +0000 (UTC)
Message-ID: <fea9d850-4942-3457-0e14-573763e891a4@redhat.com>
Date:   Sat, 14 Jan 2023 14:28:57 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: FAILED: patch "[PATCH] sched/core: Fix use-after-free bug in
 dup_user_cpus_ptr()" failed to apply to 6.1-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, mingo@kernel.org, peterz@infradead.org,
        wangbiao3@xiaomi.com
Cc:     stable@vger.kernel.org
References: <167368999799102@kroah.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <167368999799102@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/23 04:53, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> Possible dependencies:
>
> 87ca4f9efbd7 ("sched/core: Fix use-after-free bug in dup_user_cpus_ptr()")
> 8f9ea86fdf99 ("sched: Always preserve the user requested cpumask")
> 713a2e21a513 ("sched: Introduce affinity_context")
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
>  From 87ca4f9efbd7cc649ff43b87970888f2812945b8 Mon Sep 17 00:00:00 2001
> From: Waiman Long <longman@redhat.com>
> Date: Fri, 30 Dec 2022 23:11:19 -0500
> Subject: [PATCH] sched/core: Fix use-after-free bug in dup_user_cpus_ptr()
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
>
> Since commit 07ec77a1d4e8 ("sched: Allow task CPU affinity to be
> restricted on asymmetric systems"), the setting and clearing of
> user_cpus_ptr are done under pi_lock for arm64 architecture. However,
> dup_user_cpus_ptr() accesses user_cpus_ptr without any lock
> protection. Since sched_setaffinity() can be invoked from another
> process, the process being modified may be undergoing fork() at
> the same time.  When racing with the clearing of user_cpus_ptr in
> __set_cpus_allowed_ptr_locked(), it can lead to user-after-free and
> possibly double-free in arm64 kernel.
>
> Commit 8f9ea86fdf99 ("sched: Always preserve the user requested
> cpumask") fixes this problem as user_cpus_ptr, once set, will never
> be cleared in a task's lifetime. However, this bug was re-introduced
> in commit 851a723e45d1 ("sched: Always clear user_cpus_ptr in
> do_set_cpus_allowed()") which allows the clearing of user_cpus_ptr in
> do_set_cpus_allowed(). This time, it will affect all arches.
>
> Fix this bug by always clearing the user_cpus_ptr of the newly
> cloned/forked task before the copying process starts and check the
> user_cpus_ptr state of the source task under pi_lock.
>
> Note to stable, this patch won't be applicable to stable releases.
> Just copy the new dup_user_cpus_ptr() function over.

I have a note here about what to do when backporting to stable. Just 
copy the new function over will be fine.

Cheers,
Longman

>
> Fixes: 07ec77a1d4e8 ("sched: Allow task CPU affinity to be restricted on asymmetric systems")
> Fixes: 851a723e45d1 ("sched: Always clear user_cpus_ptr in do_set_cpus_allowed()")
> Reported-by: David Wang 王标 <wangbiao3@xiaomi.com>
> Signed-off-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Reviewed-by: Peter Zijlstra <peterz@infradead.org>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20221231041120.440785-2-longman@redhat.com

