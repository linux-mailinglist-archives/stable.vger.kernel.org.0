Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6CE517771
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 21:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387129AbiEBTcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 15:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356497AbiEBTcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 15:32:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4358F2D;
        Mon,  2 May 2022 12:28:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49653B81914;
        Mon,  2 May 2022 19:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26CCC385AC;
        Mon,  2 May 2022 19:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651519724;
        bh=KV31gzMiQvygiAlTQxri3h5Gq6cV4ZjN/nWqC7g9jxM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D1Tg7ehJXUyPD+f2lkI/qRjGHkNWnKL+XbHMXmHl0xLZNT7nPX+gDYrExnO2GQrpc
         zKrUrsdrkmonJPbK3um8XJ5crbVj0nnZzhMvzO0/A2bNsug7j7Gp9xLncFU00NheTN
         svk8Ra4m9vngq/9sgrYHweTz52+Zma8Yc38injv0=
Date:   Mon, 2 May 2022 21:28:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc:     stable@vger.kernel.org, RCU <rcu@vger.kernel.org>
Subject: Re: [PATCH 0/2] RCU offloading vs scheduler latency
Message-ID: <YnAw6gb5JNAIBXHf@kroah.com>
References: <20220502190833.3352-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502190833.3352-1-urezki@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 02, 2022 at 09:08:31PM +0200, Uladzislau Rezki (Sony) wrote:
> Motivation of backport:
> -----------------------
>    
> 1. The cfcdef5e30469 ("rcu: Allow rcu_do_batch() to dynamically adjust batch sizes")
> broke the default behaviour of "offloading rcu callbacks" setup. In that scenario
> after each callback the caller context was used to check if it has to be rescheduled
> giving a CPU time for others. After that change an "offloaded" setup can switch to
> time-based RCU callbacks processing, what can be long for latency sensitive workloads
> and SCHED_FIFO processes, i.e. callbacks are invoked for a long time with keeping
> preemption off and without checking cond_resched().
>     
> 2. Our devices which run Android and 5.10 kernel have some critical areas which
> are sensitive to latency. It is a low latency audio, 8k video, UI stack and so on.
> For example below is a trace that illustrates a delay of "irq/396-5-0072" RT task
> to complete IRQ processing:
>     
> <snip>
>   rcuop/6-54  [000] d.h2  183.752989: irq_handler_entry:    irq=85 name=i2c_geni
>   rcuop/6-54  [000] d.h5  183.753007: sched_waking:         comm=irq/396-5-0072 pid=12675 prio=49 target_cpu=000
>   rcuop/6-54  [000] dNh6  183.753014: sched_wakeup:         irq/396-5-0072:12675 [49] success=1 CPU:000
>   rcuop/6-54  [000] dNh2  183.753015: irq_handler_exit:     irq=85 ret=handled
>   rcuop/6-54  [000] .N..  183.753018: rcu_invoke_callback:  rcu_preempt rhp=0xffffff88ffd440b0 func=__d_free.cfi_jt
>   rcuop/6-54  [000] .N..  183.753020: rcu_invoke_callback:  rcu_preempt rhp=0xffffff892ffd8400 func=inode_free_by_rcu.cfi_jt
>   rcuop/6-54  [000] .N..  183.753021: rcu_invoke_callback:  rcu_preempt rhp=0xffffff89327cd708 func=i_callback.cfi_jt
>   ...
>   rcuop/6-54  [000] .N..  183.755941: rcu_invoke_callback:  rcu_preempt rhp=0xffffff8993c5a968 func=i_callback.cfi_jt
>   rcuop/6-54  [000] .N..  183.755942: rcu_invoke_callback:  rcu_preempt rhp=0xffffff8993c4bd20 func=__d_free.cfi_jt
>   rcuop/6-54  [000] dN..  183.755944: rcu_batch_end:        rcu_preempt CBs-invoked=2112 idle=>c<>c<>c<>c<
>   rcuop/6-54  [000] dN..  183.755946: rcu_utilization:      Start context switch
>   rcuop/6-54  [000] dN..  183.755946: rcu_utilization:      End context switch
>   rcuop/6-54  [000] d..2  183.755959: sched_switch:         rcuop/6:54 [120] R ==> migration/0:16 [0]
>   ...
>   migratio-16 [000] d..2  183.756021: sched_switch:         migration/0:16 [0] S ==> irq/396-5-0072:12675 [49]
> <snip>
>     
> The "irq/396-5-0072:12675" was delayed for ~3 milliseconds due to introduced side effect.
> Please note, on our Android devices we get ~70 000 callbacks registered to be invoked by
> the "rcuop/x" workers. This is during 1 seconds time interval and regular handset usage.
> Latencies bigger that 3 milliseconds affect our high-resolution audio streaming over the
> LDAC/Bluetooth stack.
> 
> Two patches depend on each other.

One meta-comment.  We can't apply changes to older kernels and not newer
ones, as you do not want to upgrade your kernel and suffer a regression.
This patch series comes from 5.17, but you are backporting to only 5.10.
What about 5.15?  I can't consider this series unless we have a series
also for 5.15 for that reason, we have to keep in sync otherwise things
get unmaintainable.

So, have a 5.15 backport as well?

Also, you forgot to cc: the developers of the patches in this 0/X email,
that just causes confusion for those that do not receive this message.

thanks,

greg k-h
