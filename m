Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0115404737
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 10:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhIIIsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 04:48:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56192 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231821AbhIIIsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 04:48:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631177246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=M5q4BwPXNeAfn9sJLPwyrIlaPqHnzNYHcHdNI2hZwvE=;
        b=b/Nwt1K75Bjaeuet8n05YebFSdv4Xw5n0JcCfuN0A26x5wLLT0GMgeCgLD6KzONPs2l3Ot
        CSqKdK00IjVJ+on1yhEkgPgJXpefz30YWXAiXEzVoYH5zB1DXTZblT79ONwihMl7ZiEVkM
        WgclJWRxC8MtKXr4qUB0cKhFJHdYB5Q=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-leerSXZrMeyhdBfgVs6MTQ-1; Thu, 09 Sep 2021 04:47:25 -0400
X-MC-Unique: leerSXZrMeyhdBfgVs6MTQ-1
Received: by mail-yb1-f200.google.com with SMTP id o76-20020a25414f000000b0059bb8130257so1622540yba.0
        for <stable@vger.kernel.org>; Thu, 09 Sep 2021 01:47:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=M5q4BwPXNeAfn9sJLPwyrIlaPqHnzNYHcHdNI2hZwvE=;
        b=RHYtSphMw6rN33L4GzXvKTyufnE+P/oXbVPEeDgtKkdpY+G7vCz6euj7MHRcCv6iJF
         PTnJYmTb4uLTCV8ar4YAnLXuZJzfm8cTZQ65BgcFd1en/kAPTB1zR53oc5IxeOJywGXx
         OSwGtaCZCoULtfMbS/kL1aceJl3MMXoMaHpZBfbKzY3CD93Y4ehn6/pIpVuYM9hLvDiA
         y3euAgWu5lBbcZSTRsuYWCmBA85MD0hr2KeokWkFpHv40kHX4YKP7r4F/fiaaYB3FfF/
         26zSoDJIWSTWsWHcxKAWYSv5b8SaFWUhXaSMbsh1+3YZxBklE5d1Y6YMEK6F+zJxxzS1
         jkWw==
X-Gm-Message-State: AOAM532CsEFuekfvM9o459BJqzS9lyR1vjO6AOgOxecHaNLOII3ew0nl
        VWrYQLDjbw3NBpNLAoMPxra8Ctv+d95zBsKmnw8zHhlclsGWjHDFrEZ7WGYaiCSbZ47gMRCDzG3
        YOGLLqqpJ0xgUUXUYNPnM0stYZvuzbTp+
X-Received: by 2002:a25:ad97:: with SMTP id z23mr2473384ybi.412.1631177244654;
        Thu, 09 Sep 2021 01:47:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPfOAeCT9yHz2A1BrmZLQOuxNKA7ums4Zf0PoR+I/Pw5rnXRfA3Lsh/1CtWLIrzEFADbIi04uZv7/Vf9lDyKM=
X-Received: by 2002:a25:ad97:: with SMTP id z23mr2473353ybi.412.1631177244268;
 Thu, 09 Sep 2021 01:47:24 -0700 (PDT)
MIME-Version: 1.0
From:   Yi Zhang <yi.zhang@redhat.com>
Date:   Thu, 9 Sep 2021 16:47:13 +0800
Message-ID: <CAHj4cs-noupgFn3QjB96Z20hv-BhFLHOyFZFEtrhGpESkeoRSA@mail.gmail.com>
Subject: [bug report] NULL pointer at blk_mq_put_rq_ref+0x20/0xb4 observed
 with blktests on 5.13.15
To:     linux-block <linux-block@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello

I found this issue with blktests on[1], did we miss some patch on stable?
[1]
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
queue/5.13

[   68.989907] run blktests block/006 at 2021-09-09 04:34:35
[   69.085724] null_blk: module loaded
[   74.271624] Unable to handle kernel NULL pointer dereference at
virtual address 00000000000002b8
[   74.280414] Mem abort info:
[   74.283195]   ESR = 0x96000004
[   74.286245]   EC = 0x25: DABT (current EL), IL = 32 bits
[   74.291545]   SET = 0, FnV = 0
[   74.294587]   EA = 0, S1PTW = 0
[   74.297720] Data abort info:
[   74.300588]   ISV = 0, ISS = 0x00000004
[   74.304411]   CM = 0, WnR = 0
[   74.307368] user pgtable: 4k pages, 48-bit VAs, pgdp=000008004366e000
[   74.313796] [00000000000002b8] pgd=0000000000000000, p4d=0000000000000000
[   74.320577] Internal error: Oops: 96000004 [#1] SMP
[   74.325443] Modules linked in: null_blk mlx5_ib ib_uverbs ib_core
rfkill sunrpc vfat fat joydev acpi_ipmi ipmi_ssif cdc_ether usbnet mii
mlx5_core psample ipmi_devintf mlxfw tls ipmi_msghandler arm_cmn
cppc_cpufreq arm_dsu_pmu acpi_tad fuse zram ip_tables xfs ast
i2c_algo_bit drm_vram_helper drm_kms_helper crct10dif_ce syscopyarea
ghash_ce sysfillrect uas sysimgblt sbsa_gwdt fb_sys_fops cec
drm_ttm_helper ttm nvme usb_storage nvme_core drm xgene_hwmon
aes_neon_bs
[   74.366458] CPU: 31 PID: 2511 Comm: fio Not tainted 5.13.15+ #1
[   74.372367] Hardware name: WIWYNN Mt.Jade Server System
B81.030Z1.0007/Mt.Jade Motherboard, BIOS 1.6.20210526 (SCP:
1.06.20210526) 2021/05/26
[   74.385045] pstate: 00400009 (nzcv daif +PAN -UAO -TCO BTYPE=--)
[   74.391040] pc : blk_mq_put_rq_ref+0x20/0xb4
[   74.395301] lr : bt_iter+0x64/0xd0
[   74.398690] sp : ffff800049153980
[   74.401992] x29: ffff800049153980 x28: ffff07ff8f694520 x27: 0000000000400cc0
[   74.409116] x26: ffff07ffbff407f0 x25: 00000000000000c0 x24: 0000000000000010
[   74.416240] x23: 0000000000000000 x22: 0000000000000001 x21: ffff07ffc50d0000
[   74.423363] x20: ffff800049153a50 x19: ffff07ffc5188c40 x18: 0000000000000000
[   74.430486] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[   74.437609] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
[   74.444732] x11: 0000000000000000 x10: 0000000000000000 x9 : ffffaae6737ae164
[   74.451855] x8 : ffff800049153c00 x7 : ffffffffffffff80 x6 : 0000000000000007
[   74.458978] x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff07ffc5188d28
[   74.466100] x2 : 0000000000000000 x1 : ffff07ffc5188c40 x0 : ffff07ffc5188c40
[   74.473224] Call trace:
[   74.475657]  blk_mq_put_rq_ref+0x20/0xb4
[   74.479567]  bt_iter+0x64/0xd0
[   74.482609]  blk_mq_queue_tag_busy_iter+0x1a0/0x300
[   74.487475]  blk_mq_in_flight+0x30/0x44
[   74.491298]  part_stat_show+0x60/0x160
[   74.495036]  dev_attr_show+0x2c/0x6c
[   74.498599]  sysfs_kf_seq_show+0x94/0x140
[   74.502598]  kernfs_seq_show+0x38/0x44
[   74.506336]  seq_read_iter+0x1dc/0x4f0
[   74.510075]  kernfs_fop_read_iter+0x44/0x50
[   74.514245]  new_sync_read+0xdc/0x154
[   74.517896]  vfs_read+0x158/0x1e4
[   74.521199]  ksys_read+0x64/0xf0
[   74.524414]  __arm64_sys_read+0x28/0x34
[   74.528237]  invoke_syscall+0x50/0x120
[   74.531976]  el0_svc_common.constprop.0+0x4c/0x100
[   74.536755]  do_el0_svc+0x34/0xa0
[   74.540057]  el0_svc+0x2c/0x54
[   74.543100]  el0_sync_handler+0xa4/0x130
[   74.547011]  el0_sync+0x19c/0x1c0
[   74.550320] Code: a9bf7bfd aa0003e1 910003fd f9400802 (f9415c42)
[   74.556503] ---[ end trace 76adda8a4ccf9d09 ]---
[   74.561107] Kernel panic - not syncing: Oops: Fatal exception
[   74.566897] SMP: stopping secondary CPUs
[   74.570914] Kernel Offset: 0x2ae6630e0000 from 0xffff800010000000
[   74.576994] PHYS_OFFSET: 0x80000000
[   74.580469] CPU features: 0x000042c1,a3302e42
[   74.584813] Memory Limit: none
[   74.587902] ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---


-- 
Best Regards,
  Yi Zhang

