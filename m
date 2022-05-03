Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EB65180D9
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 11:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbiECJXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 05:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbiECJXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 05:23:07 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025051F617;
        Tue,  3 May 2022 02:19:35 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id s27so21284770ljd.2;
        Tue, 03 May 2022 02:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9bGhXUxqXhqDJnMfPqCdUh/KYGhkwvQNfeXyR1CHA6A=;
        b=NDwWz1tuXJzu3UcjgihQsidXGDZ2UyYgGkjRFTDgif39ppYK8RN//4NDGnDhp2l3g+
         iGBaZPelj9g3G+ysWdhMWail3Lv4Oy0qflNTlx9XE8psT9pf/IxmwvIQvxRU38ez6Q7l
         NRsh9i0fjmHnrEIv9aPeG9So151FVY8HwwSm+PYAuQh1xZzmzwLKqg2iSjfVgueL5953
         R0M8zAwKdVOVyqRsY5XclK5YhPhOR2JgBEgnfch0DXCNYIDYyNND0AWOnMUo72i8QN3E
         DwGDKXX71R/vtlqGMKE2sZMthhxJY5bt5uVRWkXyKw+/cwfw9Q2clwKON3k4A1GckR6J
         T8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9bGhXUxqXhqDJnMfPqCdUh/KYGhkwvQNfeXyR1CHA6A=;
        b=zOBjNueIYKc6CMC+o4iBrsReqquPw59RO5/KTpb4+JFugKJxzge1pjwGb9+wOWza4e
         4ZalZcqSQ4oMGtVS7YuJQLvyQupIayibHIyKhPyywVdKH6m6/tgIBossTn94KP3KwBNT
         HfNvDm6pe9YoRyyvO5i+x9qfftqOMX76i2j4vx97mHUtA2VWOMsMKnOWa3tUwX/RR0EG
         ccvcYBh5n+X4rm6E5br1djexKT/bktNmInni8YtE4Bc8OHItlAqJrwkM3+G549+GbNC4
         JAUuvw0vHY719s8rQfLc9Q6xFSEcCYifBfpYkZtjejrw5vGMnhaSd5emPGVwwARNIUcq
         kBVw==
X-Gm-Message-State: AOAM5331rvo8kfw7AN76VK0ZrpduL8zcb/nvTBSwt0XdWRyVMDT79Ddo
        YAWsszbigHpKW5SO07Y7LC0=
X-Google-Smtp-Source: ABdhPJwZiwmzm3upFPcxntpHnE/rzc6IG8PbGUiVityfKy/lw+4bQy3LfBoM6OOqZl7j+MGauT0ntQ==
X-Received: by 2002:a2e:5cc8:0:b0:24f:1616:7d67 with SMTP id q191-20020a2e5cc8000000b0024f16167d67mr9347589ljb.368.1651569573132;
        Tue, 03 May 2022 02:19:33 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id l9-20020ac24a89000000b0047255d211c7sm906822lfp.246.2022.05.03.02.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 02:19:32 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Tue, 3 May 2022 11:19:30 +0200
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        stable@vger.kernel.org, RCU <rcu@vger.kernel.org>
Subject: Re: [PATCH 0/2] RCU offloading vs scheduler latency
Message-ID: <YnDzohUAn1RF3fTP@pc638.lan>
References: <20220502190833.3352-1-urezki@gmail.com>
 <YnAw6gb5JNAIBXHf@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnAw6gb5JNAIBXHf@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Mon, May 02, 2022 at 09:08:31PM +0200, Uladzislau Rezki (Sony) wrote:
> > Motivation of backport:
> > -----------------------
> >    
> > 1. The cfcdef5e30469 ("rcu: Allow rcu_do_batch() to dynamically adjust batch sizes")
> > broke the default behaviour of "offloading rcu callbacks" setup. In that scenario
> > after each callback the caller context was used to check if it has to be rescheduled
> > giving a CPU time for others. After that change an "offloaded" setup can switch to
> > time-based RCU callbacks processing, what can be long for latency sensitive workloads
> > and SCHED_FIFO processes, i.e. callbacks are invoked for a long time with keeping
> > preemption off and without checking cond_resched().
> >     
> > 2. Our devices which run Android and 5.10 kernel have some critical areas which
> > are sensitive to latency. It is a low latency audio, 8k video, UI stack and so on.
> > For example below is a trace that illustrates a delay of "irq/396-5-0072" RT task
> > to complete IRQ processing:
> >     
> > <snip>
> >   rcuop/6-54  [000] d.h2  183.752989: irq_handler_entry:    irq=85 name=i2c_geni
> >   rcuop/6-54  [000] d.h5  183.753007: sched_waking:         comm=irq/396-5-0072 pid=12675 prio=49 target_cpu=000
> >   rcuop/6-54  [000] dNh6  183.753014: sched_wakeup:         irq/396-5-0072:12675 [49] success=1 CPU:000
> >   rcuop/6-54  [000] dNh2  183.753015: irq_handler_exit:     irq=85 ret=handled
> >   rcuop/6-54  [000] .N..  183.753018: rcu_invoke_callback:  rcu_preempt rhp=0xffffff88ffd440b0 func=__d_free.cfi_jt
> >   rcuop/6-54  [000] .N..  183.753020: rcu_invoke_callback:  rcu_preempt rhp=0xffffff892ffd8400 func=inode_free_by_rcu.cfi_jt
> >   rcuop/6-54  [000] .N..  183.753021: rcu_invoke_callback:  rcu_preempt rhp=0xffffff89327cd708 func=i_callback.cfi_jt
> >   ...
> >   rcuop/6-54  [000] .N..  183.755941: rcu_invoke_callback:  rcu_preempt rhp=0xffffff8993c5a968 func=i_callback.cfi_jt
> >   rcuop/6-54  [000] .N..  183.755942: rcu_invoke_callback:  rcu_preempt rhp=0xffffff8993c4bd20 func=__d_free.cfi_jt
> >   rcuop/6-54  [000] dN..  183.755944: rcu_batch_end:        rcu_preempt CBs-invoked=2112 idle=>c<>c<>c<>c<
> >   rcuop/6-54  [000] dN..  183.755946: rcu_utilization:      Start context switch
> >   rcuop/6-54  [000] dN..  183.755946: rcu_utilization:      End context switch
> >   rcuop/6-54  [000] d..2  183.755959: sched_switch:         rcuop/6:54 [120] R ==> migration/0:16 [0]
> >   ...
> >   migratio-16 [000] d..2  183.756021: sched_switch:         migration/0:16 [0] S ==> irq/396-5-0072:12675 [49]
> > <snip>
> >     
> > The "irq/396-5-0072:12675" was delayed for ~3 milliseconds due to introduced side effect.
> > Please note, on our Android devices we get ~70 000 callbacks registered to be invoked by
> > the "rcuop/x" workers. This is during 1 seconds time interval and regular handset usage.
> > Latencies bigger that 3 milliseconds affect our high-resolution audio streaming over the
> > LDAC/Bluetooth stack.
> > 
> > Two patches depend on each other.
> 
> One meta-comment.  We can't apply changes to older kernels and not newer
> ones, as you do not want to upgrade your kernel and suffer a regression.
> This patch series comes from 5.17, but you are backporting to only 5.10.
> What about 5.15?  I can't consider this series unless we have a series
> also for 5.15 for that reason, we have to keep in sync otherwise things
> get unmaintainable.
> 
> So, have a 5.15 backport as well?
> 
Yep, i can prepare a backport for 5.15 as well. So i can resend the patches 
for 5.10 and 5.15 stable kernels, in total there will be 4 patches with two
separate cover letters.

Does it work for you?

> Also, you forgot to cc: the developers of the patches in this 0/X email,
> that just causes confusion for those that do not receive this message.
> 
Sorry, i missed that point in cover latter. So will update it with appropriate
people on my next resend.

Thanks!

--
Uladzislau Rezki
