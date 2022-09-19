Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B92C5BC126
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 03:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiISByf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Sep 2022 21:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiISBye (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Sep 2022 21:54:34 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8CFD88
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 18:54:31 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id q3-20020a056e0220e300b002f5e648e02eso314191ilv.3
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 18:54:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=AHzgcS2X+/QGWeM29O6XDWtLRyz5Wh5W1xcwpVvlPvM=;
        b=oo6iBmjIA1c+6WkHoqQ3lbvzqxyfJKVr9Cmbqfc8oxh/3qW5btVqItTzWxNrU+T4il
         zuWVBIx2f2HavMkz2oWHSVeL8MmIctnhkj2YUsDv7PvhCXmMOR4uSXlWjjCNgkmQ7wYE
         mxHsKcmeWRFdSj8uFSn9oM+U2YCqgNIJLI50EHOdl7VNXGPhfrVB3GqfRdSY9+D6FjC8
         QN+qotZJoJd26iK4Eyomb+VX+a+5TwKe12e1jBMHUhUsNb5Y2iod1evzS7qxFYAEwfCQ
         5c1OtmB5kVBZk0yafUDwA5kWFNtn05St57hZlcaEFpUwPDQMB08p2D+qtAIEO9c+XpZH
         QXlQ==
X-Gm-Message-State: ACrzQf12PA482CgZUZWJP+k2Ze/Ew4jQr5CXMgD06FCtltOlZuih/NC2
        0tx7hvyQyJXPndpyAaHiBAFOaUrcpj/YHhzEZy+ZxhZEvakd
X-Google-Smtp-Source: AMsMyM7ZQqh9NzN3Y9R0Kia3MIp01A0IfVeCN73By221uH6MUBD+0Qv6Cwo0640uSSgvoI/8ZWuMGXGjfE0R5cJlUoakbOo8bTc6
MIME-Version: 1.0
X-Received: by 2002:a6b:6918:0:b0:6a0:f9d7:8a0a with SMTP id
 e24-20020a6b6918000000b006a0f9d78a0amr6106791ioc.183.1663552471132; Sun, 18
 Sep 2022 18:54:31 -0700 (PDT)
Date:   Sun, 18 Sep 2022 18:54:31 -0700
In-Reply-To: <000000000000d893d805d0def1a0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001b70f305e8fdfeba@google.com>
Subject: Re: [syzbot] INFO: task hung in hub_port_init (2)
From:   syzbot <syzbot+76629376e06e2c2ad626@syzkaller.appspotmail.com>
To:     admindpt@BOC.com, brauner@kernel.org, broonie@kernel.org,
        catalin.marinas@arm.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, hdanton@sina.com, johan@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, madvenka@linux.microsoft.com,
        mark.rutland@arm.com, paskripkin@gmail.com, qiazbgvr@Amazon.co.jp,
        scott@os.amperecomputing.com, stable@vger.kernel.org,
        stern@rowland.harvard.edu, support@tokocrypto.com,
        syzkaller-bugs@googlegroups.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    a6b443748715 Merge branch 'for-next/core', remote-tracking..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=16b7e0f8880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=14bf9ec0df433b27
dashboard link: https://syzkaller.appspot.com/bug?extid=76629376e06e2c2ad626
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111ff2d5080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11667887080000

Downloadable assets:
disk image: https://storage.googleapis.com/81b491dd5861/disk-a6b44374.raw.xz
vmlinux: https://storage.googleapis.com/69c979cdc99a/vmlinux-a6b44374.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+76629376e06e2c2ad626@syzkaller.appspotmail.com

INFO: task kworker/0:0:6 blocked for more than 143 seconds.
      Not tainted 6.0.0-rc4-syzkaller-17255-ga6b443748715 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:0     state:D stack:    0 pid:    6 ppid:     2 flags:0x00000008
Workqueue: usb_hub_wq hub_event
Call trace:
 __switch_to+0x180/0x28c arch/arm64/kernel/process.c:557
 context_switch kernel/sched/core.c:5182 [inline]
 __schedule+0x414/0x5a0 kernel/sched/core.c:6494
 schedule+0x64/0xa4 kernel/sched/core.c:6570
 usb_kill_urb+0xe0/0x1c8 drivers/usb/core/urb.c:726
 usb_start_wait_urb+0xf8/0x1ec drivers/usb/core/message.c:64
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0xd8/0x17c drivers/usb/core/message.c:153
 hub_port_init+0x534/0x1064 drivers/usb/core/hub.c:4825
 hub_port_connect+0x528/0xe30 drivers/usb/core/hub.c:5282
 hub_port_connect_change+0x3d8/0x70c drivers/usb/core/hub.c:5497
 port_event+0x780/0x930 drivers/usb/core/hub.c:5653
 hub_event+0x2f0/0x658 drivers/usb/core/hub.c:5735
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20
INFO: task kworker/1:0:20 blocked for more than 143 seconds.
      Not tainted 6.0.0-rc4-syzkaller-17255-ga6b443748715 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:0     state:D stack:    0 pid:   20 ppid:     2 flags:0x00000008
Workqueue: usb_hub_wq hub_event
Call trace:
 __switch_to+0x180/0x28c arch/arm64/kernel/process.c:557
 context_switch kernel/sched/core.c:5182 [inline]
 __schedule+0x414/0x5a0 kernel/sched/core.c:6494
 schedule+0x64/0xa4 kernel/sched/core.c:6570
 usb_kill_urb+0xe0/0x1c8 drivers/usb/core/urb.c:726
 usb_start_wait_urb+0xf8/0x1ec drivers/usb/core/message.c:64
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0xd8/0x17c drivers/usb/core/message.c:153
 hub_port_init+0x534/0x1064 drivers/usb/core/hub.c:4825
 hub_port_connect+0x528/0xe30 drivers/usb/core/hub.c:5282
 hub_port_connect_change+0x3d8/0x70c drivers/usb/core/hub.c:5497
 port_event+0x780/0x930 drivers/usb/core/hub.c:5653
 hub_event+0x2f0/0x658 drivers/usb/core/hub.c:5735
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20
INFO: task kworker/1:2:109 blocked for more than 143 seconds.
      Not tainted 6.0.0-rc4-syzkaller-17255-ga6b443748715 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:2     state:D stack:    0 pid:  109 ppid:     2 flags:0x00000008
Workqueue: usb_hub_wq hub_event
Call trace:
 __switch_to+0x180/0x28c arch/arm64/kernel/process.c:557
 context_switch kernel/sched/core.c:5182 [inline]
 __schedule+0x414/0x5a0 kernel/sched/core.c:6494
 schedule+0x64/0xa4 kernel/sched/core.c:6570
 usb_kill_urb+0xe0/0x1c8 drivers/usb/core/urb.c:726
 usb_start_wait_urb+0xf8/0x1ec drivers/usb/core/message.c:64
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0xd8/0x17c drivers/usb/core/message.c:153
 hub_port_init+0x534/0x1064 drivers/usb/core/hub.c:4825
 hub_port_connect+0x528/0xe30 drivers/usb/core/hub.c:5282
 hub_port_connect_change+0x3d8/0x70c drivers/usb/core/hub.c:5497
 port_event+0x780/0x930 drivers/usb/core/hub.c:5653
 hub_event+0x2f0/0x658 drivers/usb/core/hub.c:5735
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20
INFO: task syz-executor535:3088 blocked for more than 143 seconds.
      Not tainted 6.0.0-rc4-syzkaller-17255-ga6b443748715 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor535 state:D stack:    0 pid: 3088 ppid:  3083 flags:0x00000001
Call trace:
 __switch_to+0x180/0x28c arch/arm64/kernel/process.c:557
 context_switch kernel/sched/core.c:5182 [inline]
 __schedule+0x414/0x5a0 kernel/sched/core.c:6494
 schedule+0x64/0xa4 kernel/sched/core.c:6570
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:6629
 __mutex_lock_common+0x788/0xca8 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
 device_lock include/linux/device.h:835 [inline]
 usbdev_release+0x40/0x3b8 drivers/usb/core/devio.c:1087
 __fput+0x198/0x3dc fs/file_table.c:320
 ____fput+0x20/0x30 fs/file_table.c:353
 task_work_run+0xc4/0x14c kernel/task_work.c:177
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x174/0x1f0 arch/arm64/kernel/signal.c:1127
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0x9c/0x150 arch/arm64/kernel/entry-common.c:625
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:642
 el0t_64_sync+0x18c/0x190
INFO: task kworker/0:1:3090 blocked for more than 143 seconds.
      Not tainted 6.0.0-rc4-syzkaller-17255-ga6b443748715 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:1     state:D stack:    0 pid: 3090 ppid:     2 flags:0x00000008
Workqueue: usb_hub_wq hub_event
Call trace:
 __switch_to+0x180/0x28c arch/arm64/kernel/process.c:557
 context_switch kernel/sched/core.c:5182 [inline]
 __schedule+0x414/0x5a0 kernel/sched/core.c:6494
 schedule+0x64/0xa4 kernel/sched/core.c:6570
 usb_kill_urb+0xe0/0x1c8 drivers/usb/core/urb.c:726
 usb_start_wait_urb+0xf8/0x1ec drivers/usb/core/message.c:64
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0xd8/0x17c drivers/usb/core/message.c:153
 hub_port_init+0x534/0x1064 drivers/usb/core/hub.c:4825
 hub_port_connect+0x528/0xe30 drivers/usb/core/hub.c:5282
 hub_port_connect_change+0x3d8/0x70c drivers/usb/core/hub.c:5497
 port_event+0x780/0x930 drivers/usb/core/hub.c:5653
 hub_event+0x2f0/0x658 drivers/usb/core/hub.c:5735
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20
INFO: task syz-executor535:3091 blocked for more than 143 seconds.
      Not tainted 6.0.0-rc4-syzkaller-17255-ga6b443748715 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor535 state:D stack:    0 pid: 3091 ppid:  3080 flags:0x00000001
Call trace:
 __switch_to+0x180/0x28c arch/arm64/kernel/process.c:557
 context_switch kernel/sched/core.c:5182 [inline]
 __schedule+0x414/0x5a0 kernel/sched/core.c:6494
 schedule+0x64/0xa4 kernel/sched/core.c:6570
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:6629
 __mutex_lock_common+0x788/0xca8 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
 device_lock include/linux/device.h:835 [inline]
 usbdev_release+0x40/0x3b8 drivers/usb/core/devio.c:1087
 __fput+0x198/0x3dc fs/file_table.c:320
 ____fput+0x20/0x30 fs/file_table.c:353
 task_work_run+0xc4/0x14c kernel/task_work.c:177
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x174/0x1f0 arch/arm64/kernel/signal.c:1127
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0x9c/0x150 arch/arm64/kernel/entry-common.c:625
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:642
 el0t_64_sync+0x18c/0x190
INFO: task syz-executor535:3092 blocked for more than 143 seconds.
      Not tainted 6.0.0-rc4-syzkaller-17255-ga6b443748715 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor535 state:D stack:    0 pid: 3092 ppid:  3082 flags:0x00000001
Call trace:
 __switch_to+0x180/0x28c arch/arm64/kernel/process.c:557
 context_switch kernel/sched/core.c:5182 [inline]
 __schedule+0x414/0x5a0 kernel/sched/core.c:6494
 schedule+0x64/0xa4 kernel/sched/core.c:6570
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:6629
 __mutex_lock_common+0x788/0xca8 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
 device_lock include/linux/device.h:835 [inline]
 usbdev_release+0x40/0x3b8 drivers/usb/core/devio.c:1087
 __fput+0x198/0x3dc fs/file_table.c:320
 ____fput+0x20/0x30 fs/file_table.c:353
 task_work_run+0xc4/0x14c kernel/task_work.c:177
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x174/0x1f0 arch/arm64/kernel/signal.c:1127
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0x9c/0x150 arch/arm64/kernel/entry-common.c:625
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:642
 el0t_64_sync+0x18c/0x190
INFO: task syz-executor535:3096 blocked for more than 143 seconds.
      Not tainted 6.0.0-rc4-syzkaller-17255-ga6b443748715 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor535 state:D stack:    0 pid: 3096 ppid:  3084 flags:0x00000001
Call trace:
 __switch_to+0x180/0x28c arch/arm64/kernel/process.c:557
 context_switch kernel/sched/core.c:5182 [inline]
 __schedule+0x414/0x5a0 kernel/sched/core.c:6494
 schedule+0x64/0xa4 kernel/sched/core.c:6570
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:6629
 __mutex_lock_common+0x788/0xca8 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
 device_lock include/linux/device.h:835 [inline]
 usbdev_release+0x40/0x3b8 drivers/usb/core/devio.c:1087
 __fput+0x198/0x3dc fs/file_table.c:320
 ____fput+0x20/0x30 fs/file_table.c:353
 task_work_run+0xc4/0x14c kernel/task_work.c:177
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x174/0x1f0 arch/arm64/kernel/signal.c:1127
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0x9c/0x150 arch/arm64/kernel/entry-common.c:625
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:642
 el0t_64_sync+0x18c/0x190
INFO: task syz-executor535:3099 blocked for more than 143 seconds.
      Not tainted 6.0.0-rc4-syzkaller-17255-ga6b443748715 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor535 state:D stack:    0 pid: 3099 ppid:  3076 flags:0x00000001
Call trace:
 __switch_to+0x180/0x28c arch/arm64/kernel/process.c:557
 context_switch kernel/sched/core.c:5182 [inline]
 __schedule+0x414/0x5a0 kernel/sched/core.c:6494
 schedule+0x64/0xa4 kernel/sched/core.c:6570
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:6629
 __mutex_lock_common+0x788/0xca8 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
 device_lock include/linux/device.h:835 [inline]
 usbdev_release+0x40/0x3b8 drivers/usb/core/devio.c:1087
 __fput+0x198/0x3dc fs/file_table.c:320
 ____fput+0x20/0x30 fs/file_table.c:353
 task_work_run+0xc4/0x14c kernel/task_work.c:177
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x174/0x1f0 arch/arm64/kernel/signal.c:1127
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0x9c/0x150 arch/arm64/kernel/entry-common.c:625
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:642
 el0t_64_sync+0x18c/0x190
INFO: task kworker/1:1:3101 blocked for more than 143 seconds.
      Not tainted 6.0.0-rc4-syzkaller-17255-ga6b443748715 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:1     state:D stack:    0 pid: 3101 ppid:     2 flags:0x00000008
Workqueue: usb_hub_wq hub_event
Call trace:
 __switch_to+0x180/0x28c arch/arm64/kernel/process.c:557
 context_switch kernel/sched/core.c:5182 [inline]
 __schedule+0x414/0x5a0 kernel/sched/core.c:6494
 schedule+0x64/0xa4 kernel/sched/core.c:6570
 usb_kill_urb+0xe0/0x1c8 drivers/usb/core/urb.c:726
 usb_start_wait_urb+0xf8/0x1ec drivers/usb/core/message.c:64
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0xd8/0x17c drivers/usb/core/message.c:153
 hub_port_init+0x534/0x1064 drivers/usb/core/hub.c:4825
 hub_port_connect+0x528/0xe30 drivers/usb/core/hub.c:5282
 hub_port_connect_change+0x3d8/0x70c drivers/usb/core/hub.c:5497
 port_event+0x780/0x930 drivers/usb/core/hub.c:5653
 hub_event+0x2f0/0x658 drivers/usb/core/hub.c:5735
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20

Showing all locks held in the system:
5 locks held by kworker/0:0/6:
 #0: ffff0000c0c12138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x270/0x504 kernel/workqueue.c:2262
 #1: ffff80000f21bd80 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x29c/0x504 kernel/workqueue.c:2264
 #2: ffff0000c4a87990 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #2: ffff0000c4a87990 (&dev->mutex){....}-{3:3}, at: hub_event+0x8c/0x658 drivers/usb/core/hub.c:5681
 #3: ffff0000c6299508 (&port_dev->status_lock){+.+.}-{3:3}, at: usb_lock_port drivers/usb/core/hub.c:3103 [inline]
 #3: ffff0000c6299508 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect+0x33c/0xe30 drivers/usb/core/hub.c:5249
 #4: ffff0000c66b8468 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_connect+0x348/0xe30 drivers/usb/core/hub.c:5250
1 lock held by rcu_tasks_kthre/10:
 #0: ffff80000d4634e8 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x3c/0x450 kernel/rcu/tasks.h:507
1 lock held by rcu_tasks_trace/11:
 #0: ffff80000d463b38 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x3c/0x450 kernel/rcu/tasks.h:507
5 locks held by kworker/1:0/20:
 #0: ffff0000c0c12138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x270/0x504 kernel/workqueue.c:2262
 #1: ffff80000f293d80 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x29c/0x504 kernel/workqueue.c:2264
 #2: ffff0000c622f990 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #2: ffff0000c622f990 (&dev->mutex){....}-{3:3}, at: hub_event+0x8c/0x658 drivers/usb/core/hub.c:5681
 #3: ffff0000c4bf1508 (&port_dev->status_lock){+.+.}-{3:3}, at: usb_lock_port drivers/usb/core/hub.c:3103 [inline]
 #3: ffff0000c4bf1508 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect+0x33c/0xe30 drivers/usb/core/hub.c:5249
 #4: ffff0000c64c9168 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_connect+0x348/0xe30 drivers/usb/core/hub.c:5250
1 lock held by khungtaskd/26:
 #0: ffff80000d4633c0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x4/0x48 include/linux/rcupdate.h:279
5 locks held by kworker/1:2/109:
 #0: ffff0000c0c12138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x270/0x504 kernel/workqueue.c:2262
 #1: ffff8000126ebd80 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x29c/0x504 kernel/workqueue.c:2264
 #2: ffff0000c5283990 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #2: ffff0000c5283990 (&dev->mutex){....}-{3:3}, at: hub_event+0x8c/0x658 drivers/usb/core/hub.c:5681
 #3: ffff0000c5285508 (&port_dev->status_lock){+.+.}-{3:3}, at: usb_lock_port drivers/usb/core/hub.c:3103 [inline]
 #3: ffff0000c5285508 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect+0x33c/0xe30 drivers/usb/core/hub.c:5249
 #4: ffff0000c64d2368 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_connect+0x348/0xe30 drivers/usb/core/hub.c:5250
2 locks held by getty/2728:
 #0: ffff0000c6f4d898 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x28/0x58 drivers/tty/tty_ldisc.c:244
 #1: ffff80000f63e2f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x19c/0x89c drivers/tty/n_tty.c:2177
1 lock held by syz-executor535/3088:
 #0: ffff0000c5283990 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #0: ffff0000c5283990 (&dev->mutex){....}-{3:3}, at: usbdev_release+0x40/0x3b8 drivers/usb/core/devio.c:1087
5 locks held by kworker/0:1/3090:
 #0: ffff0000c0c12138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x270/0x504 kernel/workqueue.c:2262
 #1: ffff8000127a3d80 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x29c/0x504 kernel/workqueue.c:2264
 #2: ffff0000c6289990 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #2: ffff0000c6289990 (&dev->mutex){....}-{3:3}, at: hub_event+0x8c/0x658 drivers/usb/core/hub.c:5681
 #3: ffff0000c628b508 (&port_dev->status_lock){+.+.}-{3:3}, at: usb_lock_port drivers/usb/core/hub.c:3103 [inline]
 #3: ffff0000c628b508 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect+0x33c/0xe30 drivers/usb/core/hub.c:5249
 #4: ffff0000c66b8f68 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_connect+0x348/0xe30 drivers/usb/core/hub.c:5250
1 lock held by syz-executor535/3091:
 #0: ffff0000c5283990 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #0: ffff0000c5283990 (&dev->mutex){....}-{3:3}, at: usbdev_release+0x40/0x3b8 drivers/usb/core/devio.c:1087
1 lock held by syz-executor535/3092:
 #0: ffff0000c5283990 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #0: ffff0000c5283990 (&dev->mutex){....}-{3:3}, at: usbdev_release+0x40/0x3b8 drivers/usb/core/devio.c:1087
1 lock held by syz-executor535/3096:
 #0: ffff0000c5283990 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #0: ffff0000c5283990 (&dev->mutex){....}-{3:3}, at: usbdev_release+0x40/0x3b8 drivers/usb/core/devio.c:1087
1 lock held by syz-executor535/3099:
 #0: ffff0000c5283990 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #0: ffff0000c5283990 (&dev->mutex){....}-{3:3}, at: usbdev_release+0x40/0x3b8 drivers/usb/core/devio.c:1087
5 locks held by kworker/1:1/3101:
 #0: ffff0000c0c12138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x270/0x504 kernel/workqueue.c:2262
 #1: ffff800012863d80 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x29c/0x504 kernel/workqueue.c:2264
 #2: ffff0000c62c9190 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #2: ffff0000c62c9190 (&dev->mutex){....}-{3:3}, at: hub_event+0x8c/0x658 drivers/usb/core/hub.c:5681
 #3: ffff0000c62cb508 (&port_dev->status_lock){+.+.}-{3:3}, at: usb_lock_port drivers/usb/core/hub.c:3103 [inline]
 #3: ffff0000c62cb508 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect+0x33c/0xe30 drivers/usb/core/hub.c:5249
 #4: ffff0000c64d2d68 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_connect+0x348/0xe30 drivers/usb/core/hub.c:5250
1 lock held by syz-executor535/3102:
 #0: ffff0000c5283990 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #0: ffff0000c5283990 (&dev->mutex){....}-{3:3}, at: usbdev_open+0xb0/0x370 drivers/usb/core/devio.c:1042

=============================================


