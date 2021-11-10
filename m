Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914E544C546
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 17:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhKJQra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 11:47:30 -0500
Received: from queue02b.mail.zen.net.uk ([212.23.3.237]:58391 "EHLO
        queue02b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbhKJQra (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 11:47:30 -0500
X-Greylist: delayed 1010 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2021 11:47:30 EST
Received: from [212.23.1.21] (helo=smarthost01b.ixn.mail.zen.net.uk)
        by queue02b.mail.zen.net.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <lkml@badpenguin.co.uk>)
        id 1mkqRy-000723-Rq; Wed, 10 Nov 2021 16:27:50 +0000
Received: from [217.155.148.18] (helo=swift)
        by smarthost01b.ixn.mail.zen.net.uk with esmtp (Exim 4.90_1)
        (envelope-from <lkml@badpenguin.co.uk>)
        id 1mkqRq-0007HB-PR; Wed, 10 Nov 2021 16:27:42 +0000
Received: from localhost (localhost [127.0.0.1])
        by swift (Postfix) with ESMTP id 8DC9F2C9336;
        Wed, 10 Nov 2021 16:27:42 +0000 (GMT)
X-Virus-Scanned: Debian amavisd-new at badpenguin.co.uk
Received: from swift ([127.0.0.1])
        by localhost (swift.badpenguin.co.uk [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XkHQ5IbJHKQI; Wed, 10 Nov 2021 16:27:39 +0000 (GMT)
Received: from [192.168.42.11] (katana [192.168.42.11])
        by swift (Postfix) with ESMTPS id 66CF12C9333;
        Wed, 10 Nov 2021 16:27:39 +0000 (GMT)
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev
From:   Mark Boddington <lkml@badpenguin.co.uk>
Subject: kernel 5.15.1: AMD RX 6700 XT - Fails to resume after screen blank
Message-ID: <dbadfe41-24bf-5811-cf38-74973df45214@badpenguin.co.uk>
Date:   Wed, 10 Nov 2021 16:27:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-smarthost01b-IP: [217.155.148.18]
Feedback-ID: 217.155.148.18
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

I run the mainline Linux kernel on Ubuntu 20.04, built from 
https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.1/

There appears to be a regression in 5.15.1 which causes the GPU to fail 
to resume after power saving.

Could it be this change??:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c?h=v5.15.1&id=8af3a335b5531ca3df0920b1cca43e456cd110ad

The errors I see when the card tries to resume the DP output are:

ov 10 09:37:55 katana rtkit-daemon[2577]: Supervising 3 threads of 1 
processes of 1 users.
Nov 10 09:37:55 katana rtkit-daemon[2577]: Successfully made thread 
12215 of process 2820 owned by '10000' RT at priority 5.
Nov 10 09:37:55 katana rtkit-daemon[2577]: Supervising 4 threads of 1 
processes of 1 users.
Nov 10 09:37:55 katana kernel: [ 3296.643206] [drm:dc_dmub_srv_wait_idle 
[amdgpu]] *ERROR* Error waiting for DMUB idle: status=3
Nov 10 09:38:01 katana kernel: [ 3302.722202] snd_hda_intel 
0000:0d:00.1: refused to change power state from D0 to D3hot
Nov 10 09:38:01 katana kernel: [ 3302.988931] amdgpu 0000:0d:00.0: 
amdgpu: Failed to export SMU metrics table!
Nov 10 09:38:06 katana kernel: [ 3308.243937] amdgpu 0000:0d:00.0: 
amdgpu: SMU: I'm not done with your previous command!
Nov 10 09:38:06 katana kernel: [ 3308.243941] amdgpu 0000:0d:00.0: 
amdgpu: Failed to export SMU metrics table!
Nov 10 09:38:06 katana kernel: [ 3308.320003] [drm:amdgpu_job_timedout 
[amdgpu]] *ERROR* ring gfx_0.0.0 timeout, signaled seq=250622, emitted 
seq=250624
Nov 10 09:38:06 katana kernel: [ 3308.320185] [drm:amdgpu_job_timedout 
[amdgpu]] *ERROR* Process information: process Xorg pid 2203 thread 
Xorg:cs0 pid 2355
Nov 10 09:38:06 katana kernel: [ 3308.320334] amdgpu 0000:0d:00.0: 
amdgpu: GPU reset begin!
Nov 10 09:38:12 katana kernel: [ 3313.469702] amdgpu 0000:0d:00.0: 
amdgpu: SMU: I'm not done with your previous command!
Nov 10 09:38:12 katana kernel: [ 3313.469707] amdgpu 0000:0d:00.0: 
amdgpu: Failed to export SMU metrics table!
Nov 10 09:38:17 katana kernel: [ 3318.899866] amdgpu 0000:0d:00.0: 
amdgpu: SMU: I'm not done with your previous command!
Nov 10 09:38:17 katana kernel: [ 3318.899871] amdgpu 0000:0d:00.0: 
amdgpu: Failed to disable gfxoff!
Nov 10 09:38:18 katana kernel: [ 3319.514045] [drm:dc_dmub_srv_wait_idle 
[amdgpu]] *ERROR* Error waiting for DMUB idle: status=3
Nov 10 09:38:20 katana kernel: [ 3322.195318] [drm:dc_dmub_srv_wait_idle 
[amdgpu]] *ERROR* Error waiting for DMUB idle: status=3
Nov 10 09:38:30 katana kernel: [ 3331.866060] amdgpu 0000:0d:00.0: 
[drm:amdgpu_ring_test_helper [amdgpu]] *ERROR* ring kiq_2.1.0 test 
failed (-110)
Nov 10 09:38:30 katana kernel: [ 3331.866199] [drm:gfx_v10_0_hw_fini 
[amdgpu]] *ERROR* KGQ disable failed
Nov 10 09:38:30 katana kernel: [ 3332.187330] amdgpu 0000:0d:00.0: 
[drm:amdgpu_ring_test_helper [amdgpu]] *ERROR* ring kiq_2.1.0 test 
failed (-110)
Nov 10 09:38:30 katana kernel: [ 3332.187465] [drm:gfx_v10_0_hw_fini 
[amdgpu]] *ERROR* KCQ disable failed
Nov 10 09:38:36 katana kernel: [ 3337.614265] amdgpu 0000:0d:00.0: 
amdgpu: SMU: I'm not done with your previous command!
Nov 10 09:38:36 katana kernel: [ 3337.614269] amdgpu 0000:0d:00.0: 
amdgpu: Failed to disable smu features.
Nov 10 09:38:36 katana kernel: [ 3337.614273] amdgpu 0000:0d:00.0: 
amdgpu: Fail to disable dpm features!
Nov 10 09:38:36 katana kernel: [ 3337.614274] 
[drm:amdgpu_device_ip_suspend_phase2 [amdgpu]] *ERROR* suspend of IP 
block <smu> failed -62
Nov 10 09:38:36 katana kernel: [ 3337.625941] [drm] free PSP TMR buffer
Nov 10 09:38:37 katana kernel: [ 3338.724759] [drm] psp gfx command 
DESTROY_TMR(0x7) failed and response status is (0x80000306)
Nov 10 09:38:37 katana kernel: [ 3338.745744] amdgpu 0000:0d:00.0: 
amdgpu: MODE1 reset
Nov 10 09:38:37 katana kernel: [ 3338.745748] amdgpu 0000:0d:00.0: 
amdgpu: GPU mode1 reset
Nov 10 09:38:37 katana kernel: [ 3338.745832] amdgpu 0000:0d:00.0: 
amdgpu: GPU smu mode1 reset
Nov 10 09:38:42 katana kernel: [ 3344.061148] amdgpu 0000:0d:00.0: 
amdgpu: SMU: I'm not done with your previous command!
Nov 10 09:38:42 katana kernel: [ 3344.061151] amdgpu 0000:0d:00.0: 
amdgpu: GPU mode1 reset failed
Nov 10 09:38:42 katana kernel: [ 3344.061265] amdgpu 0000:0d:00.0: 
amdgpu: ASIC reset failed with error, -62 for drm dev, 0000:0d:00.0
Nov 10 09:38:53 katana kernel: [ 3355.141401] amdgpu 0000:0d:00.0: 
amdgpu: GPU reset succeeded, trying to resume
Nov 10 09:38:53 katana kernel: [ 3355.141674] [drm] PCIE GART of 512M 
enabled (table at 0x0000008000300000).
Nov 10 09:38:53 katana kernel: [ 3355.141709] [drm] VRAM is lost due to 
GPU reset!
Nov 10 09:38:53 katana kernel: [ 3355.142685] [drm] PSP is resuming...
Nov 10 09:38:54 katana kernel: [ 3356.258540] [drm] failed to load ucode 
SMC(0x18)
Nov 10 09:38:54 katana kernel: [ 3356.258567] [drm] psp gfx command 
LOAD_IP_FW(0x6) failed and response status is (0x80000306)
Nov 10 09:38:54 katana kernel: [ 3356.258572] [drm] reserve 0xa00000 
from 0x82fe000000 for PSP TMR
Nov 10 09:38:55 katana kernel: [ 3356.503720] amdgpu 0000:0d:00.0: 
amdgpu: RAS: optional ras ta ucode is not available
Nov 10 09:38:55 katana kernel: [ 3356.517290] amdgpu 0000:0d:00.0: 
amdgpu: SECUREDISPLAY: securedisplay ta ucode is not available
Nov 10 09:38:55 katana kernel: [ 3356.517293] amdgpu 0000:0d:00.0: 
amdgpu: SMU is resuming...
Nov 10 09:39:00 katana kernel: [ 3361.828868] amdgpu 0000:0d:00.0: 
amdgpu: SMU: I'm not done with your previous command!
Nov 10 09:39:00 katana kernel: [ 3361.828871] amdgpu 0000:0d:00.0: 
amdgpu: Failed to SetDriverDramAddr!
Nov 10 09:39:00 katana kernel: [ 3361.828873] amdgpu 0000:0d:00.0: 
amdgpu: Failed to setup smc hw!
Nov 10 09:39:00 katana kernel: [ 3361.828874] 
[drm:amdgpu_device_ip_resume_phase2 [amdgpu]] *ERROR* resume of IP block 
<smu> failed -62
Nov 10 09:39:00 katana kernel: [ 3361.829025] amdgpu 0000:0d:00.0: 
amdgpu: GPU reset(2) failed
Nov 10 09:39:00 katana kernel: [ 3361.831396] amdgpu 0000:0d:00.0: 
amdgpu: GPU reset end with ret = -62
Nov 10 09:39:00 katana kernel: [ 3361.848123] snd_hda_intel 
0000:0d:00.1: refused to change power state from D0 to D3hot
Nov 10 09:39:10 katana kernel: [ 3372.062062] [drm:amdgpu_job_timedout 
[amdgpu]] *ERROR* ring gfx_0.0.0 timeout, signaled seq=250624, emitted 
seq=250624
Nov 10 09:39:10 katana kernel: [ 3372.062243] [drm:amdgpu_job_timedout 
[amdgpu]] *ERROR* Process information: process Xorg pid 2203 thread 
Xorg:cs0 pid 2355
Nov 10 09:39:10 katana kernel: [ 3372.062395] amdgpu 0000:0d:00.0: 
amdgpu: GPU reset begin!
Nov 10 09:41:13 katana systemd[1]: Starting Ubuntu Advantage Timer for 
running repeated jobs...
Nov 10 09:41:13 katana systemd[1]: ua-timer.service: Succeeded.
Nov 10 09:41:13 katana systemd[1]: Finished Ubuntu Advantage Timer for 
running repeated jobs.
Nov 10 09:41:23 katana kernel: [ 3505.167372] INFO: task 
kworker/11:2:284 blocked for more than 120 seconds.
Nov 10 09:41:23 katana kernel: [ 3505.167377]       Not tainted 
5.15.1-051501-generic #202111071208-Ubuntu
Nov 10 09:41:23 katana kernel: [ 3505.167379] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 09:41:23 katana kernel: [ 3505.167380] task:kworker/11:2 state:D 
stack:    0 pid:  284 ppid:     2 flags:0x00004000
Nov 10 09:41:23 katana kernel: [ 3505.167384] Workqueue: events 
drm_sched_job_timedout [gpu_sched]
Nov 10 09:41:23 katana kernel: [ 3505.167392] Call Trace:
Nov 10 09:41:23 katana kernel: [ 3505.167394] __schedule+0x2b6/0x7e0
Nov 10 09:41:23 katana kernel: [ 3505.167398]  schedule+0x4e/0xb0
Nov 10 09:41:23 katana kernel: [ 3505.167400] schedule_timeout+0x202/0x290
Nov 10 09:41:23 katana kernel: [ 3505.167402]  ? 
raw_spin_rq_lock_nested.constprop.0+0x10/0x20
Nov 10 09:41:23 katana kernel: [ 3505.167405] 
dma_fence_default_wait+0x174/0x200
Nov 10 09:41:23 katana kernel: [ 3505.167409]  ? 
dma_fence_release+0x140/0x140
Nov 10 09:41:23 katana kernel: [ 3505.167410] 
dma_fence_wait_timeout+0xb7/0xd0
Nov 10 09:41:23 katana kernel: [ 3505.167412] drm_sched_stop+0xf7/0x170 
[gpu_sched]
Nov 10 09:41:23 katana kernel: [ 3505.167417] 
amdgpu_device_gpu_recover.cold+0xabd/0xad3 [amdgpu]
Nov 10 09:41:23 katana kernel: [ 3505.167569]  ? 
amdgpu_job_timedout+0xf5/0x170 [amdgpu]
Nov 10 09:41:23 katana kernel: [ 3505.167698] 
amdgpu_job_timedout+0x14f/0x170 [amdgpu]
Nov 10 09:41:23 katana kernel: [ 3505.167811] 
drm_sched_job_timedout+0x76/0xf0 [gpu_sched]
Nov 10 09:41:23 katana kernel: [ 3505.167814] process_one_work+0x22b/0x3d0
Nov 10 09:41:23 katana kernel: [ 3505.167816] worker_thread+0x4d/0x3f0
Nov 10 09:41:23 katana kernel: [ 3505.167818]  ? 
process_one_work+0x3d0/0x3d0
Nov 10 09:41:23 katana kernel: [ 3505.167820]  kthread+0x12a/0x150
Nov 10 09:41:23 katana kernel: [ 3505.167821]  ? 
set_kthread_struct+0x40/0x40
Nov 10 09:41:23 katana kernel: [ 3505.167822] ret_from_fork+0x22/0x30
Nov 10 09:41:23 katana kernel: [ 3505.167896] INFO: task chrome:sh1:3814 
blocked for more than 120 seconds.
Nov 10 09:41:23 katana kernel: [ 3505.167898]       Not tainted 
5.15.1-051501-generic #202111071208-Ubuntu
Nov 10 09:41:23 katana kernel: [ 3505.167899] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 09:41:23 katana kernel: [ 3505.167900] task:chrome:sh1 state:D 
stack:    0 pid: 3814 ppid:  3747 flags:0x00004002
Nov 10 09:41:23 katana kernel: [ 3505.167902] Call Trace:
Nov 10 09:41:23 katana kernel: [ 3505.167903] __schedule+0x2b6/0x7e0
Nov 10 09:41:23 katana kernel: [ 3505.167905]  schedule+0x4e/0xb0
Nov 10 09:41:23 katana kernel: [ 3505.167906] schedule_timeout+0x202/0x290
Nov 10 09:41:23 katana kernel: [ 3505.167908] 
dma_fence_default_wait+0x174/0x200
Nov 10 09:41:23 katana kernel: [ 3505.167910]  ? 
dma_fence_release+0x140/0x140
Nov 10 09:41:23 katana kernel: [ 3505.167912] 
dma_fence_wait_timeout+0xb7/0xd0
Nov 10 09:41:23 katana kernel: [ 3505.167913] 
drm_sched_entity_fini+0xd8/0x220 [gpu_sched]
Nov 10 09:41:23 katana kernel: [ 3505.167917] 
amdgpu_ctx_mgr_entity_fini+0xa6/0xf0 [amdgpu]
Nov 10 09:41:23 katana kernel: [ 3505.168020] 
amdgpu_ctx_mgr_fini+0x32/0xc0 [amdgpu]
Nov 10 09:41:23 katana kernel: [ 3505.168119] 
amdgpu_driver_postclose_kms+0x16e/0x240 [amdgpu]
Nov 10 09:41:23 katana kernel: [ 3505.168216]  ? idr_destroy+0x7f/0xc0
Nov 10 09:41:23 katana kernel: [ 3505.168219] 
drm_file_free.part.0+0x1e5/0x250 [drm]
Nov 10 09:41:23 katana kernel: [ 3505.168235] 
drm_close_helper.isra.0+0x65/0x70 [drm]
Nov 10 09:41:23 katana kernel: [ 3505.168249]  drm_release+0x6e/0xf0 [drm]
Nov 10 09:41:23 katana kernel: [ 3505.168263]  __fput+0x9f/0x260
Nov 10 09:41:23 katana kernel: [ 3505.168266]  ____fput+0xe/0x10
Nov 10 09:41:23 katana kernel: [ 3505.168267] task_work_run+0x70/0xb0
Nov 10 09:41:23 katana kernel: [ 3505.168269]  do_exit+0x367/0xad0
Nov 10 09:41:23 katana kernel: [ 3505.168271] do_group_exit+0x43/0xb0
Nov 10 09:41:23 katana kernel: [ 3505.168272] get_signal+0x171/0x890
Nov 10 09:41:23 katana kernel: [ 3505.168274]  ? do_futex+0x1b6/0x820
Nov 10 09:41:23 katana kernel: [ 3505.168277] 
arch_do_signal_or_restart+0xf3/0x290
Nov 10 09:41:23 katana kernel: [ 3505.168280] 
exit_to_user_mode_prepare+0x12c/0x1c0
Nov 10 09:41:23 katana kernel: [ 3505.168281] 
syscall_exit_to_user_mode+0x27/0x50
Nov 10 09:41:23 katana kernel: [ 3505.168284] do_syscall_64+0x69/0xc0
Nov 10 09:41:23 katana kernel: [ 3505.168285]  ? switch_fpu_return+0x56/0xc0
Nov 10 09:41:23 katana kernel: [ 3505.168288]  ? 
exit_to_user_mode_prepare+0x98/0x1c0
Nov 10 09:41:23 katana kernel: [ 3505.168289]  ? 
syscall_exit_to_user_mode+0x27/0x50
Nov 10 09:41:23 katana kernel: [ 3505.168291]  ? do_syscall_64+0x69/0xc0
Nov 10 09:41:23 katana kernel: [ 3505.168292]  ? do_syscall_64+0x69/0xc0
Nov 10 09:41:23 katana kernel: [ 3505.168293]  ? 
syscall_exit_to_user_mode+0x27/0x50
Nov 10 09:41:23 katana kernel: [ 3505.168294]  ? __x64_sys_close+0x12/0x40
Nov 10 09:41:23 katana kernel: [ 3505.168297]  ? do_syscall_64+0x69/0xc0
Nov 10 09:41:23 katana kernel: [ 3505.168298] 
entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 10 09:41:23 katana kernel: [ 3505.168300] RIP: 0033:0x7f0c2e2d5376
Nov 10 09:41:23 katana kernel: [ 3505.168301] RSP: 002b:00007f0c1c84b580 
EFLAGS: 00000282 ORIG_RAX: 00000000000000ca
Nov 10 09:41:23 katana kernel: [ 3505.168303] RAX: fffffffffffffe00 RBX: 
0000000000000000 RCX: 00007f0c2e2d5376
Nov 10 09:41:23 katana kernel: [ 3505.168304] RDX: 0000000000000000 RSI: 
0000000000000080 RDI: 00002bc8000dae24
Nov 10 09:41:23 katana kernel: [ 3505.168305] RBP: 00002bc8000dadf8 R08: 
0000000000000000 R09: 0000000000000004
Nov 10 09:41:23 katana kernel: [ 3505.168306] R10: 0000000000000000 R11: 
0000000000000282 R12: 00002bc8000dae1c
Nov 10 09:41:23 katana kernel: [ 3505.168306] R13: 00002bc8000dadd0 R14: 
00007f0c1c84b5c0 R15: 00002bc8000dae24
Nov 10 09:43:24 katana kernel: [ 3625.995050] INFO: task 
kworker/11:2:284 blocked for more than 241 seconds.
Nov 10 09:43:24 katana kernel: [ 3625.995057]       Not tainted 
5.15.1-051501-generic #202111071208-Ubuntu
Nov 10 09:43:24 katana kernel: [ 3625.995059] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 09:43:24 katana kernel: [ 3625.995060] task:kworker/11:2 state:D 
stack:    0 pid:  284 ppid:     2 flags:0x00004000
Nov 10 09:43:24 katana kernel: [ 3625.995065] Workqueue: events 
drm_sched_job_timedout [gpu_sched]
Nov 10 09:43:24 katana kernel: [ 3625.995073] Call Trace:
Nov 10 09:43:24 katana kernel: [ 3625.995076] __schedule+0x2b6/0x7e0
Nov 10 09:43:24 katana kernel: [ 3625.995081]  schedule+0x4e/0xb0
Nov 10 09:43:24 katana kernel: [ 3625.995083] schedule_timeout+0x202/0x290
Nov 10 09:43:24 katana kernel: [ 3625.995085]  ? 
raw_spin_rq_lock_nested.constprop.0+0x10/0x20
Nov 10 09:43:24 katana kernel: [ 3625.995090] 
dma_fence_default_wait+0x174/0x200
Nov 10 09:43:24 katana kernel: [ 3625.995093]  ? 
dma_fence_release+0x140/0x140
Nov 10 09:43:24 katana kernel: [ 3625.995095] 
dma_fence_wait_timeout+0xb7/0xd0
Nov 10 09:43:24 katana kernel: [ 3625.995097] drm_sched_stop+0xf7/0x170 
[gpu_sched]
Nov 10 09:43:24 katana kernel: [ 3625.995103] 
amdgpu_device_gpu_recover.cold+0xabd/0xad3 [amdgpu]
Nov 10 09:43:24 katana kernel: [ 3625.995299]  ? 
amdgpu_job_timedout+0xf5/0x170 [amdgpu]
Nov 10 09:43:24 katana kernel: [ 3625.995465] 
amdgpu_job_timedout+0x14f/0x170 [amdgpu]
Nov 10 09:43:24 katana kernel: [ 3625.995614] 
drm_sched_job_timedout+0x76/0xf0 [gpu_sched]
Nov 10 09:43:24 katana kernel: [ 3625.995618] process_one_work+0x22b/0x3d0
Nov 10 09:43:24 katana kernel: [ 3625.995621] worker_thread+0x4d/0x3f0
Nov 10 09:43:24 katana kernel: [ 3625.995624]  ? 
process_one_work+0x3d0/0x3d0
Nov 10 09:43:24 katana kernel: [ 3625.995626]  kthread+0x12a/0x150
Nov 10 09:43:24 katana kernel: [ 3625.995627]  ? 
set_kthread_struct+0x40/0x40
Nov 10 09:43:24 katana kernel: [ 3625.995629] ret_from_fork+0x22/0x30
Nov 10 09:43:24 katana kernel: [ 3625.995667] INFO: task 
InputThread:2548 blocked for more than 120 seconds.
Nov 10 09:43:24 katana kernel: [ 3625.995669]       Not tainted 
5.15.1-051501-generic #202111071208-Ubuntu
Nov 10 09:43:24 katana kernel: [ 3625.995671] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 09:43:24 katana kernel: [ 3625.995672] task:InputThread state:D 
stack:    0 pid: 2548 ppid:  2105 flags:0x00000000
Nov 10 09:43:24 katana kernel: [ 3625.995674] Call Trace:
Nov 10 09:43:24 katana kernel: [ 3625.995676] __schedule+0x2b6/0x7e0
Nov 10 09:43:24 katana kernel: [ 3625.995678]  schedule+0x4e/0xb0
Nov 10 09:43:24 katana kernel: [ 3625.995680] 
schedule_preempt_disabled+0xe/0x10
Nov 10 09:43:24 katana kernel: [ 3625.995681] 
__mutex_lock.isra.0+0x208/0x470
Nov 10 09:43:24 katana kernel: [ 3625.995684] 
__mutex_lock_slowpath+0x13/0x20
Nov 10 09:43:24 katana kernel: [ 3625.995686]  mutex_lock+0x32/0x40
Nov 10 09:43:24 katana kernel: [ 3625.995688] 
handle_cursor_update.isra.0+0x197/0x320 [amdgpu]
Nov 10 09:43:24 katana kernel: [ 3625.995865] 
dm_plane_atomic_async_update+0xc4/0x100 [amdgpu]
Nov 10 09:43:24 katana kernel: [ 3625.996030] 
drm_atomic_helper_async_commit+0x6f/0x110 [drm_kms_helper]
Nov 10 09:43:24 katana kernel: [ 3625.996046] 
drm_atomic_helper_commit+0xf4/0x150 [drm_kms_helper]
Nov 10 09:43:24 katana kernel: [ 3625.996059] 
drm_atomic_commit+0x4a/0x50 [drm]
Nov 10 09:43:24 katana kernel: [ 3625.996084] 
drm_atomic_helper_update_plane+0xe7/0x140 [drm_kms_helper]
Nov 10 09:43:24 katana kernel: [ 3625.996098] 
__setplane_atomic+0xcc/0x110 [drm]
Nov 10 09:43:24 katana kernel: [ 3625.996121] 
drm_mode_cursor_universal+0x13e/0x260 [drm]
Nov 10 09:43:24 katana kernel: [ 3625.996141] 
drm_mode_cursor_common+0xef/0x220 [drm]
Nov 10 09:43:24 katana kernel: [ 3625.996160]  ? 
drm_mode_setplane+0x340/0x340 [drm]
Nov 10 09:43:24 katana kernel: [ 3625.996179] 
drm_mode_cursor_ioctl+0x4a/0x60 [drm]
Nov 10 09:43:24 katana kernel: [ 3625.996198] drm_ioctl_kernel+0xae/0xf0 
[drm]
Nov 10 09:43:24 katana kernel: [ 3625.996218]  drm_ioctl+0x25f/0x420 [drm]
Nov 10 09:43:24 katana kernel: [ 3625.996237]  ? 
drm_mode_setplane+0x340/0x340 [drm]
Nov 10 09:43:24 katana kernel: [ 3625.996256]  ? aa_file_perm+0x11d/0x470
Nov 10 09:43:24 katana kernel: [ 3625.996260] amdgpu_drm_ioctl+0x4e/0x80 
[amdgpu]
Nov 10 09:43:24 katana kernel: [ 3625.996384] __x64_sys_ioctl+0x91/0xc0
Nov 10 09:43:24 katana kernel: [ 3625.996387] do_syscall_64+0x5c/0xc0
Nov 10 09:43:24 katana kernel: [ 3625.996390]  ? vfs_read+0xa0/0x1a0
Nov 10 09:43:24 katana kernel: [ 3625.996393]  ? 
exit_to_user_mode_prepare+0x3d/0x1c0
Nov 10 09:43:24 katana kernel: [ 3625.996395]  ? ksys_read+0xce/0xe0
Nov 10 09:43:24 katana kernel: [ 3625.996398]  ? 
syscall_exit_to_user_mode+0x27/0x50
Nov 10 09:43:24 katana kernel: [ 3625.996400]  ? __x64_sys_read+0x1a/0x20
Nov 10 09:43:24 katana kernel: [ 3625.996403]  ? do_syscall_64+0x69/0xc0
Nov 10 09:43:24 katana kernel: [ 3625.996404]  ? 
syscall_exit_to_user_mode+0x27/0x50
Nov 10 09:43:24 katana kernel: [ 3625.996406]  ? do_syscall_64+0x69/0xc0
Nov 10 09:43:24 katana kernel: [ 3625.996407]  ? do_syscall_64+0x69/0xc0
Nov 10 09:43:24 katana kernel: [ 3625.996409] 
entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 10 09:43:24 katana kernel: [ 3625.996411] RIP: 0033:0x7f547252750b
Nov 10 09:43:24 katana kernel: [ 3625.996413] RSP: 002b:00007f5404dfb318 
EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Nov 10 09:43:24 katana kernel: [ 3625.996415] RAX: ffffffffffffffda RBX: 
00007f5404dfb350 RCX: 00007f547252750b
Nov 10 09:43:24 katana kernel: [ 3625.996417] RDX: 00007f5404dfb350 RSI: 
00000000c01c64a3 RDI: 000000000000000d
Nov 10 09:43:24 katana kernel: [ 3625.996418] RBP: 00000000c01c64a3 R08: 
000000000000069b R09: 0000000000000001
Nov 10 09:43:24 katana kernel: [ 3625.996419] R10: 0000000000000000 R11: 
0000000000000246 R12: 000055886a8123a0
Nov 10 09:43:24 katana kernel: [ 3625.996420] R13: 000000000000000d R14: 
00000000000006a2 R15: 0000000000000431
Nov 10 09:43:24 katana kernel: [ 3625.996462] INFO: task chrome:sh1:3814 
blocked for more than 241 seconds.
Nov 10 09:43:24 katana kernel: [ 3625.996464]       Not tainted 
5.15.1-051501-generic #202111071208-Ubuntu
Nov 10 09:43:24 katana kernel: [ 3625.996465] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 09:43:24 katana kernel: [ 3625.996466] task:chrome:sh1 state:D 
stack:    0 pid: 3814 ppid:  3747 flags:0x00004002
Nov 10 09:43:24 katana kernel: [ 3625.996468] Call Trace:
Nov 10 09:43:24 katana kernel: [ 3625.996470] __schedule+0x2b6/0x7e0
Nov 10 09:43:24 katana kernel: [ 3625.996472]  schedule+0x4e/0xb0
Nov 10 09:43:24 katana kernel: [ 3625.996474] schedule_timeout+0x202/0x290
Nov 10 09:43:24 katana kernel: [ 3625.996476] 
dma_fence_default_wait+0x174/0x200
Nov 10 09:43:24 katana kernel: [ 3625.996479]  ? 
dma_fence_release+0x140/0x140
Nov 10 09:43:24 katana kernel: [ 3625.996481] 
dma_fence_wait_timeout+0xb7/0xd0
Nov 10 09:43:24 katana kernel: [ 3625.996483] 
drm_sched_entity_fini+0xd8/0x220 [gpu_sched]
Nov 10 09:43:24 katana kernel: [ 3625.996487] 
amdgpu_ctx_mgr_entity_fini+0xa6/0xf0 [amdgpu]
Nov 10 09:43:24 katana kernel: [ 3625.996620] 
amdgpu_ctx_mgr_fini+0x32/0xc0 [amdgpu]
Nov 10 09:43:24 katana kernel: [ 3625.996749] 
amdgpu_driver_postclose_kms+0x16e/0x240 [amdgpu]
Nov 10 09:43:24 katana kernel: [ 3625.996872]  ? idr_destroy+0x7f/0xc0
Nov 10 09:43:24 katana kernel: [ 3625.996876] 
drm_file_free.part.0+0x1e5/0x250 [drm]
Nov 10 09:43:24 katana kernel: [ 3625.996895] 
drm_close_helper.isra.0+0x65/0x70 [drm]
Nov 10 09:43:24 katana kernel: [ 3625.996913]  drm_release+0x6e/0xf0 [drm]
Nov 10 09:43:24 katana kernel: [ 3625.996931]  __fput+0x9f/0x260
Nov 10 09:43:24 katana kernel: [ 3625.996933]  ____fput+0xe/0x10
Nov 10 09:43:24 katana kernel: [ 3625.996935] task_work_run+0x70/0xb0
Nov 10 09:43:24 katana kernel: [ 3625.996937]  do_exit+0x367/0xad0
Nov 10 09:43:24 katana kernel: [ 3625.996940] do_group_exit+0x43/0xb0
Nov 10 09:43:24 katana kernel: [ 3625.996941] get_signal+0x171/0x890
Nov 10 09:43:24 katana kernel: [ 3625.996944]  ? do_futex+0x1b6/0x820
Nov 10 09:43:24 katana kernel: [ 3625.996947] 
arch_do_signal_or_restart+0xf3/0x290
Nov 10 09:43:24 katana kernel: [ 3625.996951] 
exit_to_user_mode_prepare+0x12c/0x1c0
Nov 10 09:43:24 katana kernel: [ 3625.996952] 
syscall_exit_to_user_mode+0x27/0x50
Nov 10 09:43:24 katana kernel: [ 3625.996955] do_syscall_64+0x69/0xc0
Nov 10 09:43:24 katana kernel: [ 3625.996956]  ? switch_fpu_return+0x56/0xc0
Nov 10 09:43:24 katana kernel: [ 3625.996960]  ? 
exit_to_user_mode_prepare+0x98/0x1c0
Nov 10 09:43:24 katana kernel: [ 3625.996961]  ? 
syscall_exit_to_user_mode+0x27/0x50
Nov 10 09:43:24 katana kernel: [ 3625.996963]  ? do_syscall_64+0x69/0xc0
Nov 10 09:43:24 katana kernel: [ 3625.996965]  ? do_syscall_64+0x69/0xc0
Nov 10 09:43:24 katana kernel: [ 3625.996966]  ? 
syscall_exit_to_user_mode+0x27/0x50
Nov 10 09:43:24 katana kernel: [ 3625.996968]  ? __x64_sys_close+0x12/0x40
Nov 10 09:43:24 katana kernel: [ 3625.996970]  ? do_syscall_64+0x69/0xc0
Nov 10 09:43:24 katana kernel: [ 3625.996971] 
entry_SYSCALL_64_after_hwframe+0x44/0xae
Nov 10 09:43:24 katana kernel: [ 3625.996973] RIP: 0033:0x7f0c2e2d5376
Nov 10 09:43:24 katana kernel: [ 3625.996975] RSP: 002b:00007f0c1c84b580 
EFLAGS: 00000282 ORIG_RAX: 00000000000000ca
Nov 10 09:43:24 katana kernel: [ 3625.996976] RAX: fffffffffffffe00 RBX: 
0000000000000000 RCX: 00007f0c2e2d5376
Nov 10 09:43:24 katana kernel: [ 3625.996977] RDX: 0000000000000000 RSI: 
0000000000000080 RDI: 00002bc8000dae24
Nov 10 09:43:24 katana kernel: [ 3625.996978] RBP: 00002bc8000dadf8 R08: 
0000000000000000 R09: 0000000000000004
Nov 10 09:43:24 katana kernel: [ 3625.996979] R10: 0000000000000000 R11: 
0000000000000282 R12: 00002bc8000dae1c
Nov 10 09:43:24 katana kernel: [ 3625.996980] R13: 00002bc8000dadd0 R14: 
00007f0c1c84b5c0 R15: 00002bc8000dae24

Cheers,

Mark


