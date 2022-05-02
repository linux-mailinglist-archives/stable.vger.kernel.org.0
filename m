Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601EC517727
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 21:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiEBTMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 15:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbiEBTMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 15:12:13 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3276DE9A;
        Mon,  2 May 2022 12:08:43 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id p10so26840917lfa.12;
        Mon, 02 May 2022 12:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LjoDDvqprdB7JFPNuo+HfAB/XK42wU1VvUB1iuJhQeI=;
        b=inJYsyn+IefgTHrcvmDfbEd0wce/L60Fi4YDVE/zNEt18Ip2kJsYJQCfRORrV6ZsZ0
         i9y8jblvWpySAGq9g6fD2H0efVkw9QyBdvx8s7xd+REGJnu2UF+XA37/Bz91hdQ3o4tE
         OYEdyUr670hNkCDw+aX0qGjW24bwPbjuo4DYi/5+jkHGci4XvuTaDZ3jtFhAyShJGjpZ
         eOodko+qETLkHzKTmBkKnHktyfkawRb6Bia3S4ljs0aRj0MmCpHee5GpcHCoG2FiO1kb
         Toc325iz60m4XETtg659R18qIAN1hmkecd46/OEwXDoxUlZMa2jooymaDm9DdInUJWDJ
         bAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LjoDDvqprdB7JFPNuo+HfAB/XK42wU1VvUB1iuJhQeI=;
        b=R2nQEf1IApvP81I66gh4o8m7735mTZ6w4KiprlS6y9dLM+mshQgcS7tGxbtRWq+3sW
         TVj4oJo8cEO24TO7jJ0POYy5mxC5SGEAacD9AVwPTQTQnNd8r/OS4E1ZItb26mm4i4sr
         hNUA1uJAbRcB2t6gJ4U0yflpC1/tnk+gelfRo1LN9y67ctDekISeTXDFEDT/BhyvaCGx
         XrW5I4WVuXyGNuVmaxb2V70c1Ce3H+CFceoqGYfsW4Ja9aoigZQpt5WaQ/HhrgQsHYyl
         oKRw0C4XsSDt4hFjwQaT4lvqdmGwzsjxMmJdp+nFUkHJsk5TJwsbsxGsY59yGG92qOd4
         ReVw==
X-Gm-Message-State: AOAM5311A6n32AxrG5FLTV1jvdPVlBXSxDBZE9ONRfnBy5w/fG2zwakd
        pE0+9yJtZYKKBxm1RFlhfF0ZaiItmLI=
X-Google-Smtp-Source: ABdhPJyD+hNhx+Zf/YFei7AJXjpy4ZWes3PKHUptvqobTZAOc8CvWqan8xEN2BCfFy7JHQ+ChrePpA==
X-Received: by 2002:a19:ca50:0:b0:471:f556:92b with SMTP id h16-20020a19ca50000000b00471f556092bmr9632527lfj.587.1651518521956;
        Mon, 02 May 2022 12:08:41 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id bj39-20020a2eaaa7000000b0024f3d1daeadsm1131483ljb.53.2022.05.02.12.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 12:08:41 -0700 (PDT)
From:   "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To:     stable@vger.kernel.org
Cc:     RCU <rcu@vger.kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: [PATCH 0/2] RCU offloading vs scheduler latency
Date:   Mon,  2 May 2022 21:08:31 +0200
Message-Id: <20220502190833.3352-1-urezki@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Motivation of backport:
-----------------------
   
1. The cfcdef5e30469 ("rcu: Allow rcu_do_batch() to dynamically adjust batch sizes")
broke the default behaviour of "offloading rcu callbacks" setup. In that scenario
after each callback the caller context was used to check if it has to be rescheduled
giving a CPU time for others. After that change an "offloaded" setup can switch to
time-based RCU callbacks processing, what can be long for latency sensitive workloads
and SCHED_FIFO processes, i.e. callbacks are invoked for a long time with keeping
preemption off and without checking cond_resched().
    
2. Our devices which run Android and 5.10 kernel have some critical areas which
are sensitive to latency. It is a low latency audio, 8k video, UI stack and so on.
For example below is a trace that illustrates a delay of "irq/396-5-0072" RT task
to complete IRQ processing:
    
<snip>
  rcuop/6-54  [000] d.h2  183.752989: irq_handler_entry:    irq=85 name=i2c_geni
  rcuop/6-54  [000] d.h5  183.753007: sched_waking:         comm=irq/396-5-0072 pid=12675 prio=49 target_cpu=000
  rcuop/6-54  [000] dNh6  183.753014: sched_wakeup:         irq/396-5-0072:12675 [49] success=1 CPU:000
  rcuop/6-54  [000] dNh2  183.753015: irq_handler_exit:     irq=85 ret=handled
  rcuop/6-54  [000] .N..  183.753018: rcu_invoke_callback:  rcu_preempt rhp=0xffffff88ffd440b0 func=__d_free.cfi_jt
  rcuop/6-54  [000] .N..  183.753020: rcu_invoke_callback:  rcu_preempt rhp=0xffffff892ffd8400 func=inode_free_by_rcu.cfi_jt
  rcuop/6-54  [000] .N..  183.753021: rcu_invoke_callback:  rcu_preempt rhp=0xffffff89327cd708 func=i_callback.cfi_jt
  ...
  rcuop/6-54  [000] .N..  183.755941: rcu_invoke_callback:  rcu_preempt rhp=0xffffff8993c5a968 func=i_callback.cfi_jt
  rcuop/6-54  [000] .N..  183.755942: rcu_invoke_callback:  rcu_preempt rhp=0xffffff8993c4bd20 func=__d_free.cfi_jt
  rcuop/6-54  [000] dN..  183.755944: rcu_batch_end:        rcu_preempt CBs-invoked=2112 idle=>c<>c<>c<>c<
  rcuop/6-54  [000] dN..  183.755946: rcu_utilization:      Start context switch
  rcuop/6-54  [000] dN..  183.755946: rcu_utilization:      End context switch
  rcuop/6-54  [000] d..2  183.755959: sched_switch:         rcuop/6:54 [120] R ==> migration/0:16 [0]
  ...
  migratio-16 [000] d..2  183.756021: sched_switch:         migration/0:16 [0] S ==> irq/396-5-0072:12675 [49]
<snip>
    
The "irq/396-5-0072:12675" was delayed for ~3 milliseconds due to introduced side effect.
Please note, on our Android devices we get ~70 000 callbacks registered to be invoked by
the "rcuop/x" workers. This is during 1 seconds time interval and regular handset usage.
Latencies bigger that 3 milliseconds affect our high-resolution audio streaming over the
LDAC/Bluetooth stack.

Two patches depend on each other.

Frederic Weisbecker (2):
  rcu: Fix callbacks processing time limit retaining cond_resched()
  rcu: Apply callbacks processing time limit only on softirq

 kernel/rcu/tree.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

-- 
2.30.2

