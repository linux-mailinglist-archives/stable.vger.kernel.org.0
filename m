Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFE76C8FD0
	for <lists+stable@lfdr.de>; Sat, 25 Mar 2023 18:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbjCYRe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Mar 2023 13:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbjCYReO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Mar 2023 13:34:14 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C3D9EC4
        for <stable@vger.kernel.org>; Sat, 25 Mar 2023 10:34:06 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id g19so4488959qts.9
        for <stable@vger.kernel.org>; Sat, 25 Mar 2023 10:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1679765646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8qmbLy4FeD1wXnpI5jFiDQ+/P/XNzoLaPeANuPc2CnI=;
        b=EMuepLXHAx1qWBBkKwrBLaXDPtiy7wo5Nx6Gbt+/79BQ1l1YhLOKw+DvIsAKNacCVV
         XLEvZQXEJVNl4Wt9PIGjTLoHgIxkQUfoyMmJqKf0/PvCUQ5q//7G/zQHgcKYkDUfFB7s
         C8yPwfoLXSJEB9JPxc1hkYf/Gi+q1qB5Gu24U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679765646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8qmbLy4FeD1wXnpI5jFiDQ+/P/XNzoLaPeANuPc2CnI=;
        b=nHNJo+FxlQROhJO+UpQTRmAfT52YVaoHW2feFSLBGoYe577HJSLVCRigGGk48/JxmK
         xjWO0GUj0EzkjH4a6arJeYkep6apw26bCsA6hFF+SppL4XVhRDyXRrLrNqDU/BJoeB7K
         mtSbeBwDrqOgyqK7rcnGd7Nevv5LhPXacpeZLfnlCPI21xTCQEjGuL0l4Qc9zX8WEVMH
         YiPpVBTw8cvmnCDaCMpWHKK+uOBXl07TrDllryxzBPpJHl5AbLACi42B19/RX96xkrjW
         HUuPC2ZLbYO8lHfCJVJ2RKA8/uglg3QsEqjnYYWJlluSOV9Y27U6lavknKSc3n0kYoj/
         jIBQ==
X-Gm-Message-State: AO0yUKWAMFtJcrAj3vOIMIe4o2ECoM7tLRhV1k2ELNNs6Fmu14KrnjkT
        Nvxj5t7/Toiyty/gO17vDYAupA==
X-Google-Smtp-Source: AK7set8gLQCta4FYIlst2AUFh/hE7rHGLWZ46fe8EwGZn7VJz0oJc9ujYIdovRFZpYujEKW41/8PTg==
X-Received: by 2002:a05:622a:88:b0:3dd:a703:f7df with SMTP id o8-20020a05622a008800b003dda703f7dfmr12570788qtw.2.1679765646066;
        Sat, 25 Mar 2023 10:34:06 -0700 (PDT)
Received: from joelboxx.c.googlers.com.com (129.239.188.35.bc.googleusercontent.com. [35.188.239.129])
        by smtp.gmail.com with ESMTPSA id m4-20020ac84444000000b003e37ee54b5dsm6762764qtn.90.2023.03.25.10.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 10:34:05 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Zqiang <qiang1.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Cc:     Zheng Yejian <zhengyejian1@huawei.com>, stable@vger.kernel.org,
        rcu@vger.kernel.org
Subject: [PATCH v2 12/13] rcu: Avoid stack overflow due to __rcu_irq_enter_check_tick() being kprobe-ed
Date:   Sat, 25 Mar 2023 17:33:15 +0000
Message-Id: <20230325173316.3118674-13-joel@joelfernandes.org>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
In-Reply-To: <20230325173316.3118674-1-joel@joelfernandes.org>
References: <20230325173316.3118674-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
2.40.0.348.gf938b09366-goog

