Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1626BBD7E
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 20:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbjCOTpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 15:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbjCOTor (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 15:44:47 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78276A1C1
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:44:37 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id n2so1349813qtp.0
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1678909477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kmL3NaGdkJr0Bc+bh875hISga550hRk4RtUTBtwwn0w=;
        b=bnBx2KLF4/8ayT1hsKRH/YELY31dEXlopSuwsSIBqqg+vaXM/EzMzHk3VEelU5122J
         jwQb+81WA0fyC2BsjfFRu6dch564OgwoXcO8sX+yjQIZbugkKoJ2HG34dTE3ocYhrCar
         8S/A3URcPENhyHM0kLeY152ccpK6HGiSkJAnw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678909477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kmL3NaGdkJr0Bc+bh875hISga550hRk4RtUTBtwwn0w=;
        b=dtDkcKc9qmo7yTqP9q8NjugpiVwHYU296hSS3MUjoXi74q1qgk4jqkpPRu6rJCy9XN
         +ZagRFZGDWLcYinxaolWER5iVIXXlXOxurgo2znx83LJhrOq2dU5XItyPu3FtLb5Gs4h
         k8FY9QzEBP3U4lyT0cwQG2eMJpGGh2z7Hd8q26bLWsXpYKimdYuemXXeuqHDUioAldHW
         z1R9wQ6PwFDplEpLj1RdAnjjLzoVuPAntGqj4FmlVbRn8BldPOK6zwWaAjLKW9LaqMp2
         tHUdTD1hqBOsM0FkpyECjd1OrbRS7gj61lpKba9dYfxAwwJyZq6cXrqkH14tPRdccyRT
         HhMg==
X-Gm-Message-State: AO0yUKUfHewL5r1NExodNa3zvtCxnAFVJuZ18Bjainheclsi6avLiV8I
        1O60oGitmP++/dK9vAgzCaexBg==
X-Google-Smtp-Source: AK7set/ClKfiibjlVpcqax3G+t0GuqIKsox+SDD/jjB1WY+e+c9YqxkMfF3ISk2g3yWXShpXuSq1zg==
X-Received: by 2002:ac8:5989:0:b0:3bf:c5a7:595f with SMTP id e9-20020ac85989000000b003bfc5a7595fmr1903191qte.21.1678909476912;
        Wed, 15 Mar 2023 12:44:36 -0700 (PDT)
Received: from joelboxx.c.googlers.com.com (129.239.188.35.bc.googleusercontent.com. [35.188.239.129])
        by smtp.gmail.com with ESMTPSA id c15-20020ac8660f000000b003b86b088755sm4346666qtp.15.2023.03.15.12.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 12:44:36 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Zheng Yejian <zhengyejian1@huawei.com>, stable@vger.kernel.org,
        rcu@vger.kernel.org
Subject: [PATCH 8/9] rcu: Avoid stack overflow due to __rcu_irq_enter_check_tick() being kprobe-ed
Date:   Wed, 15 Mar 2023 19:43:48 +0000
Message-Id: <20230315194349.10798-8-joel@joelfernandes.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230315194349.10798-1-joel@joelfernandes.org>
References: <20230315194349.10798-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yejian <zhengyejian1@huawei.com>

Registering a kprobe on __rcu_irq_enter_check_tick() can cause kernel
stack overflow as shown below. This issue can be reproduced by enabling
CONFIG_NO_HZ_FULL and booting the kernel with argument "nohz_full=",
and then giving the following commands at the shell prompt:

  # cd /sys/kernel/tracing/
  # echo 'p:mp1 __rcu_irq_enter_check_tick' >> kprobe_events
  # echo 1 > events/kprobes/enable

This commit therefore adds __rcu_irq_enter_check_tick() to the kprobes
blacklist using NOKPROBE_SYMBOL().

Insufficient stack space to handle exception!
ESR: 0x00000000f2000004 -- BRK (AArch64)
FAR: 0x0000ffffccf3e510
Task stack:     [0xffff80000ad30000..0xffff80000ad38000]
IRQ stack:      [0xffff800008050000..0xffff800008058000]
Overflow stack: [0xffff089c36f9f310..0xffff089c36fa0310]
CPU: 5 PID: 190 Comm: bash Not tainted 6.2.0-rc2-00320-g1f5abbd77e2c #19
Hardware name: linux,dummy-virt (DT)
pstate: 400003c5 (nZcv DAIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __rcu_irq_enter_check_tick+0x0/0x1b8
lr : ct_nmi_enter+0x11c/0x138
sp : ffff80000ad30080
x29: ffff80000ad30080 x28: ffff089c82e20000 x27: 0000000000000000
x26: 0000000000000000 x25: ffff089c02a8d100 x24: 0000000000000000
x23: 00000000400003c5 x22: 0000ffffccf3e510 x21: ffff089c36fae148
x20: ffff80000ad30120 x19: ffffa8da8fcce148 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: ffffa8da8e44ea6c
x14: ffffa8da8e44e968 x13: ffffa8da8e03136c x12: 1fffe113804d6809
x11: ffff6113804d6809 x10: 0000000000000a60 x9 : dfff800000000000
x8 : ffff089c026b404f x7 : 00009eec7fb297f7 x6 : 0000000000000001
x5 : ffff80000ad30120 x4 : dfff800000000000 x3 : ffffa8da8e3016f4
x2 : 0000000000000003 x1 : 0000000000000000 x0 : 0000000000000000
Kernel panic - not syncing: kernel stack overflow
CPU: 5 PID: 190 Comm: bash Not tainted 6.2.0-rc2-00320-g1f5abbd77e2c #19
Hardware name: linux,dummy-virt (DT)
Call trace:
 dump_backtrace+0xf8/0x108
 show_stack+0x20/0x30
 dump_stack_lvl+0x68/0x84
 dump_stack+0x1c/0x38
 panic+0x214/0x404
 add_taint+0x0/0xf8
 panic_bad_stack+0x144/0x160
 handle_bad_stack+0x38/0x58
 __bad_stack+0x78/0x7c
 __rcu_irq_enter_check_tick+0x0/0x1b8
 arm64_enter_el1_dbg.isra.0+0x14/0x20
 el1_dbg+0x2c/0x90
 el1h_64_sync_handler+0xcc/0xe8
 el1h_64_sync+0x64/0x68
 __rcu_irq_enter_check_tick+0x0/0x1b8
 arm64_enter_el1_dbg.isra.0+0x14/0x20
 el1_dbg+0x2c/0x90
 el1h_64_sync_handler+0xcc/0xe8
 el1h_64_sync+0x64/0x68
 __rcu_irq_enter_check_tick+0x0/0x1b8
 arm64_enter_el1_dbg.isra.0+0x14/0x20
 el1_dbg+0x2c/0x90
 el1h_64_sync_handler+0xcc/0xe8
 el1h_64_sync+0x64/0x68
 __rcu_irq_enter_check_tick+0x0/0x1b8
 [...]
 el1_dbg+0x2c/0x90
 el1h_64_sync_handler+0xcc/0xe8
 el1h_64_sync+0x64/0x68
 __rcu_irq_enter_check_tick+0x0/0x1b8
 arm64_enter_el1_dbg.isra.0+0x14/0x20
 el1_dbg+0x2c/0x90
 el1h_64_sync_handler+0xcc/0xe8
 el1h_64_sync+0x64/0x68
 __rcu_irq_enter_check_tick+0x0/0x1b8
 arm64_enter_el1_dbg.isra.0+0x14/0x20
 el1_dbg+0x2c/0x90
 el1h_64_sync_handler+0xcc/0xe8
 el1h_64_sync+0x64/0x68
 __rcu_irq_enter_check_tick+0x0/0x1b8
 el1_interrupt+0x28/0x60
 el1h_64_irq_handler+0x18/0x28
 el1h_64_irq+0x64/0x68
 __ftrace_set_clr_event_nolock+0x98/0x198
 __ftrace_set_clr_event+0x58/0x80
 system_enable_write+0x144/0x178
 vfs_write+0x174/0x738
 ksys_write+0xd0/0x188
 __arm64_sys_write+0x4c/0x60
 invoke_syscall+0x64/0x180
 el0_svc_common.constprop.0+0x84/0x160
 do_el0_svc+0x48/0xe8
 el0_svc+0x34/0xd0
 el0t_64_sync_handler+0xb8/0xc0
 el0t_64_sync+0x190/0x194
SMP: stopping secondary CPUs
Kernel Offset: 0x28da86000000 from 0xffff800008000000
PHYS_OFFSET: 0xfffff76600000000
CPU features: 0x00000,01a00100,0000421b
Memory Limit: none

Link: https://lore.kernel.org/all/20221119040049.795065-1-zhengyejian1@huawei.com/
Fixes: aaf2bc50df1f ("rcu: Abstract out rcu_irq_enter_check_tick() from rcu_nmi_enter()")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/rcu/tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 90d54571126a..ee27a03d7576 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -640,6 +640,7 @@ void __rcu_irq_enter_check_tick(void)
 	}
 	raw_spin_unlock_rcu_node(rdp->mynode);
 }
+NOKPROBE_SYMBOL(__rcu_irq_enter_check_tick);
 #endif /* CONFIG_NO_HZ_FULL */
 
 /*
-- 
2.40.0.rc1.284.g88254d51c5-goog

