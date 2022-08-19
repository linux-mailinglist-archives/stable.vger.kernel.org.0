Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31FE599AF6
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 13:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348853AbiHSLZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 07:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348610AbiHSLZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 07:25:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65F9FEEB0;
        Fri, 19 Aug 2022 04:25:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F2BDB8274A;
        Fri, 19 Aug 2022 11:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F579C433D6;
        Fri, 19 Aug 2022 11:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660908340;
        bh=jEfI2tZuqE93nCv99untFA824HIB3TeXZACUpILlGqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b+8oNnCyF8uwypm+XLZREZu5qAuMbge/xHWWs6983BqVmoXlpWibHGFcsCZIF0ZIG
         Ds+GSRovsOoSOPNf/qMTUD7bOg7Jz/4IJZOnt3yLGJxfVlqDBAtgbK3O4wh5UYzGOz
         kU92F0jSvWfSTfaM0BG4qoZ+xsj2bptGI4+07oIE=
Date:   Fri, 19 Aug 2022 13:25:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org, Tadeusz Struk <tadeusz.struk@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org,
        syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10 1/1] sched/fair: Fix fault in reweight_entity
Message-ID: <Yv9zMfh0/Ng94k1Z@kroah.com>
References: <20220819071140.35728-1-pchelkin@ispras.ru>
 <20220819071140.35728-2-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220819071140.35728-2-pchelkin@ispras.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 10:11:40AM +0300, Fedor Pchelkin wrote:
> From: Tadeusz Struk <tadeusz.struk@linaro.org>
> 
> commit 13765de8148f71fa795e0a6607de37c49ea5915a upstream.
> 
> Syzbot found a GPF in reweight_entity. This has been bisected to
> commit 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid
> sched_task_group")
> 
> There is a race between sched_post_fork() and setpriority(PRIO_PGRP)
> within a thread group that causes a null-ptr-deref in
> reweight_entity() in CFS. The scenario is that the main process spawns
> number of new threads, which then call setpriority(PRIO_PGRP, 0, -20),
> wait, and exit.  For each of the new threads the copy_process() gets
> invoked, which adds the new task_struct and calls sched_post_fork()
> for it.
> 
> In the above scenario there is a possibility that
> setpriority(PRIO_PGRP) and set_one_prio() will be called for a thread
> in the group that is just being created by copy_process(), and for
> which the sched_post_fork() has not been executed yet. This will
> trigger a null pointer dereference in reweight_entity(), as it will
> try to access the run queue pointer, which hasn't been set.
> 
> Before the mentioned change the cfs_rq pointer for the task  has been
> set in sched_fork(), which is called much earlier in copy_process(),
> before the new task is added to the thread_group.  Now it is done in
> the sched_post_fork(), which is called after that.  To fix the issue
> the remove the update_load param from the update_load param() function
> and call reweight_task() only if the task flag doesn't have the
> TASK_NEW flag set.
> 
> Fixes: 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")
> Reported-by: syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: stable@vger.kernel.org
> Link: https://lkml.kernel.org/r/20220203161846.1160750-1-tadeusz.struk@linaro.org
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---
> 5.10 adaptation: Replaced a task_struct field '__state' with 'state' 

Now queued up, thanks.

greg k-h
