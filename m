Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2D7518D0F
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 21:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbiECTUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 15:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238334AbiECTUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 15:20:54 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621E53FBCD;
        Tue,  3 May 2022 12:17:21 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 16so23218880lju.13;
        Tue, 03 May 2022 12:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OKodGyr51GJPg/SPUimZ4oXKLHsLsZrV58F63/FMs6Y=;
        b=eCqTNc385Us3PAHyzlVl36x8gcYAzbt5wGfopCcLWwhn+CZ5xfVdqrOtHWuzBLwx7A
         WBUOaAuRcdrDFHpW3paKur0JurSb/DG6eXR9WIX7Sl6m91ufJVMmjE1YFS6I4OOQRshZ
         QI5ctB4swyoMeblvKazAtg4/a7O1Flm3wqk7pgarwvkzzQC+Tr9+mfJFpx3HiDcOVGHd
         A80JDxzLHnvLez0wkLL0FzQioDZ5S6tAzqOIwt5cCLhJl5DnZog8n3dsb2yWYhEjSkb5
         u0sppdHb6CAe1AYyJhletpnflqiayqA6lOKbTFyfw2GhfrGO+FcsKkSeJXUOOiqfTQ4I
         WXZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OKodGyr51GJPg/SPUimZ4oXKLHsLsZrV58F63/FMs6Y=;
        b=Or8WQlBl5nm0iPGO6ddGXCE7tADJIgxJteTm41p1jwfRwptUfZ2LZPHzZditt0WU6o
         Mnipe4XnYbmu4NWElZt0Bh8sDfCFGhdrD02TC2Xisdqe59DbwRtAhl4ta1zP/Q9DAk5d
         phiukAJjuOSEsHTEGHrCxdhn5UhDLQmt1PLFTB7lqr8/JEC4JwjfyF1Cj50MZdvFSzLD
         AKSviRo+qTtQrk/c1eas453yrNcvGaflGmDG9hUWD196P8RcDD+Sco7uTGN3xYBCdEND
         Dysn/Mco12RfFZufkY0AFyaCX+k+YrMbWGwJjnmc7pd9hwt5ElqdZ6hmoREtKfb9Eiak
         stbA==
X-Gm-Message-State: AOAM530CXeoS/7eFaC6Rlo38FcA7SYpJuseMxWl0L1LjNW6WjSItNezA
        xIDjIK5n5u7eKHbQKErQr7QXE/2inyg=
X-Google-Smtp-Source: ABdhPJxIF7vV/zbZAd1dlg+aAE4z77ynWWlc7N7c6ZcM85wEOgJlr4kuuvHS1utw5122xQEOic01dA==
X-Received: by 2002:a2e:9dc8:0:b0:24f:d84:3001 with SMTP id x8-20020a2e9dc8000000b0024f0d843001mr10601424ljj.435.1651605439511;
        Tue, 03 May 2022 12:17:19 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id f13-20020ac2532d000000b0047255d211bfsm1014094lfh.238.2022.05.03.12.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 12:17:18 -0700 (PDT)
From:   "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To:     stable@vger.kernel.org
Cc:     RCU <rcu@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Neeraj Upadhyay <neeraj.iitr10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: [PATCH 0/2] RCU offloading vs scheduler latency(for 5.15 stable)
Date:   Tue,  3 May 2022 21:17:07 +0200
Message-Id: <20220503191709.155266-1-urezki@gmail.com>
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
  rcu: [for 5.15 stable] Fix callbacks processing time limit retaining cond_resched()
  rcu: [for 5.15 stable] Apply callbacks processing time limit only on softirq

 kernel/rcu/tree.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

-- 
2.30.2

