Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E995866AFD4
	for <lists+stable@lfdr.de>; Sun, 15 Jan 2023 09:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjAOIBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Jan 2023 03:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjAOIBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Jan 2023 03:01:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B99B450
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 00:01:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22374B80A06
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 08:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58589C433EF;
        Sun, 15 Jan 2023 08:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673769696;
        bh=ogLVVM5HY2rrAL7iccRBXaKB5nz4jqLgR3a7fZVqNMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nraafNFkKcuTzUlhTlGWe1Xo/Mu0Vr6S+VSvQqfL/l77nIJQFJhSt+IfpeP3Ke/LE
         CSPWowCOUJyajerUKXjgT+WZpIpNX9E7JuI16VY31uglCzpvBEtEwzt7vHFlyy5YfE
         Ej0eATWY294r/oSecxvec6Uy2Pxk4MLcIepojMWE=
Date:   Sun, 15 Jan 2023 09:01:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Waiman Long <longman@redhat.com>
Cc:     stable@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        wangbiao3@xiaomi.com
Subject: Re: FAILED: patch "[PATCH] sched/core: Fix use-after-free bug in
 dup_user_cpus_ptr()" failed to apply to 6.1-stable tree
Message-ID: <Y8Oy3UCj2sK14sCO@kroah.com>
References: <167368999799102@kroah.com>
 <fea9d850-4942-3457-0e14-573763e891a4@redhat.com>
 <881dc653-a6b4-6fea-542d-e06d79d011e5@redhat.com>
 <41a01c47-ebf6-49c5-45f0-5d03a2a3b805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <41a01c47-ebf6-49c5-45f0-5d03a2a3b805@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 14, 2023 at 09:26:54PM -0500, Waiman Long wrote:
> 
> On 1/14/23 14:33, Waiman Long wrote:
> > On 1/14/23 14:28, Waiman Long wrote:
> > > On 1/14/23 04:53, gregkh@linuxfoundation.org wrote:
> > > > The patch below does not apply to the 6.1-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > > 
> > > > Possible dependencies:
> > > > 
> > > > 87ca4f9efbd7 ("sched/core: Fix use-after-free bug in
> > > > dup_user_cpus_ptr()")
> > > > 8f9ea86fdf99 ("sched: Always preserve the user requested cpumask")
> > > > 713a2e21a513 ("sched: Introduce affinity_context")
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > > ------------------ original commit in Linus's tree ------------------
> > > > 
> > > >  From 87ca4f9efbd7cc649ff43b87970888f2812945b8 Mon Sep 17 00:00:00 2001
> > > > From: Waiman Long <longman@redhat.com>
> > > > Date: Fri, 30 Dec 2022 23:11:19 -0500
> > > > Subject: [PATCH] sched/core: Fix use-after-free bug in
> > > > dup_user_cpus_ptr()
> > > > MIME-Version: 1.0
> > > > Content-Type: text/plain; charset=UTF-8
> > > > Content-Transfer-Encoding: 8bit
> > > > 
> > > > Since commit 07ec77a1d4e8 ("sched: Allow task CPU affinity to be
> > > > restricted on asymmetric systems"), the setting and clearing of
> > > > user_cpus_ptr are done under pi_lock for arm64 architecture. However,
> > > > dup_user_cpus_ptr() accesses user_cpus_ptr without any lock
> > > > protection. Since sched_setaffinity() can be invoked from another
> > > > process, the process being modified may be undergoing fork() at
> > > > the same time.  When racing with the clearing of user_cpus_ptr in
> > > > __set_cpus_allowed_ptr_locked(), it can lead to user-after-free and
> > > > possibly double-free in arm64 kernel.
> > > > 
> > > > Commit 8f9ea86fdf99 ("sched: Always preserve the user requested
> > > > cpumask") fixes this problem as user_cpus_ptr, once set, will never
> > > > be cleared in a task's lifetime. However, this bug was re-introduced
> > > > in commit 851a723e45d1 ("sched: Always clear user_cpus_ptr in
> > > > do_set_cpus_allowed()") which allows the clearing of user_cpus_ptr in
> > > > do_set_cpus_allowed(). This time, it will affect all arches.
> > > > 
> > > > Fix this bug by always clearing the user_cpus_ptr of the newly
> > > > cloned/forked task before the copying process starts and check the
> > > > user_cpus_ptr state of the source task under pi_lock.
> > > > 
> > > > Note to stable, this patch won't be applicable to stable releases.
> > > > Just copy the new dup_user_cpus_ptr() function over.
> > > 
> > > I have a note here about what to do when backporting to stable. Just
> > > copy the new function over will be fine.
> > 
> > That will be before the application of the subsequent patch which will
> > modify it in a way for suitable for stable. I can send out a separate
> > stable patch for that later today.
> 
> The attached patch will apply to linux-6.1.y as well as linux-5.15.y.

Thanks for the backport, now queued up.

greg k-h
