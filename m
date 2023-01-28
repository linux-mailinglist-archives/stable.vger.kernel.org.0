Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C409067F3C3
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 02:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjA1BiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 20:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjA1BiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 20:38:03 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8856530C2;
        Fri, 27 Jan 2023 17:37:58 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id u5so4105297pfm.10;
        Fri, 27 Jan 2023 17:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3a1yXQVFpS6R59AZFBrPnTFwVD5eb/1KT01F13zn41Y=;
        b=Zjl4okPk+ATZo/uvMvv0KJMQywtec7RvaU1Yh6B7yGS4JRRTHYTHAyKHHsUV+Lelt9
         /DntdJUgwwX2OzglPxaolc7ZbPzO+lD/AlgzTfuLZPK0eyeNTUlo47aBeN9Md3107Enx
         4+Ib4R5npDTsxeSf41E/6yJK1CyyIblQDU7QgL1yHW/TFYjRvusxVZbUv35xkmDZSfFT
         HEd+FTa0xXHInH7pVQi1ynrNGq0F0R7ZVmO7XDXi4CLTddKtLX3phusYyg877LXuox+h
         jEHRkbJTExiHq91Yi0QcfSdPLO9BaKpPMEPUk/ZQrXcn2KLPjmtz6IcD6NLX+9zGAEPB
         n5yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3a1yXQVFpS6R59AZFBrPnTFwVD5eb/1KT01F13zn41Y=;
        b=L45SnN/PZgk1NVgcaGkhhrn97x2Um+e3pfXyAGN/xvH5oPzXt0zKqUjPllAjdAjGhV
         XlZpP9Bmy2BENPw0w6Q4mBc5LdCMojpAE8bJG+ARZp4/MxLES2YVFF8ftwjriRvc8LEz
         PYXBufxuDcawxz+JrCvHDMYA5AXETcliVmP9gannRDpR0GboUM8+1ed3sIZVwtaty4s/
         RMbqJw5PK4eN1mQ4LPsqB3wWUEsiJxbYC7ttRLyL5lPCoj7NyVqaET+upqw3dF7A8g1E
         GUHINVZ6cEpQmrWkYpzSZVcuITKWrCK7snPabfzudTftunhm+aBvJ+6M+rJ5B/d4O1Ha
         WVyQ==
X-Gm-Message-State: AFqh2kryQsOycVIfX9sCPF1xnGuz6JU0Vpk9yLOA9LJJL/TonCbAa/p7
        PZhJL4E3AHnznf8Nmho0zFW/GyDxKViPvXTmzJEBpkkrlYQk8g==
X-Google-Smtp-Source: AMrXdXsZCpgjATkcOseHDmflIpoQbWVjpOsVdx2W2oELWTcXb2lswLnxczwIOs+1d8J1oBQX1nU10sdC3CwLH5shzM8=
X-Received: by 2002:a63:f047:0:b0:470:2c91:9579 with SMTP id
 s7-20020a63f047000000b004702c919579mr4416484pgj.22.1674869878022; Fri, 27 Jan
 2023 17:37:58 -0800 (PST)
MIME-Version: 1.0
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Sat, 28 Jan 2023 09:37:47 +0800
Message-ID: <CAABZP2ywCbu4Po63BDBE7U1WEqx4DF7F2CZjTqFp0dSDw-uziQ@mail.gmail.com>
Subject: Chasing a 'use after free' bug of SCSI subsystem for linux-stable 5.15.y
To:     eric@andante.org, jejb@linux.ibm.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        rcu <rcu@vger.kernel.org>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, lance@osuosl.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear SCSI developers:
During the rcutorture test performed on linux-stable 5.15.y in PPC VM
of Open Source Lab of Oregon State University, A SCSI related bug is
discovered [1]:
[    5.178733][    C1] BUG: Kernel NULL pointer dereference on read at
0x00000008
...
[    5.231013][    C1] [c00000001ff9fca0] [c0000000009ffbc8]
scsi_end_request+0xd8/0x1f0 (unreliable)^M
[    5.234961][    C1] [c00000001ff9fcf0] [c000000000a00e68]
scsi_io_completion+0x88/0x700^M
[    5.237863][    C1] [c00000001ff9fda0] [c0000000009f5028]
scsi_finish_command+0xe8/0x150^M
[    5.240089][    C1] [c00000001ff9fdf0] [c000000000a00c70]
scsi_complete+0x90/0x140^M
[    5.242481][    C1] [c00000001ff9fe20] [c0000000007e5170]
blk_complete_reqs+0x80/0xa0^M
[    5.245187][    C1] [c00000001ff9fe50] [c000000000f0b5d0]
__do_softirq+0x1e0/0x4e0^M
[    5.248479][    C1] [c00000001ff9ff90] [c0000000000170e8]
do_softirq_own_stack+0x48/0x60^M
[    5.250919][    C1] [c00000000a5e7c40] [c00000000a5e7c80]
0xc00000000a5e7c80^M
[    5.253792][    C1] [c00000000a5e7c70] [c0000000001534c0]
do_softirq+0xb0/0xc0^M
[    5.256824][    C1] [c00000000a5e7ca0] [c0000000001535ac]
__local_bh_enable_ip+0xdc/0x110^M
[    5.259414][    C1] [c00000000a5e7cc0] [c0000000001d75e8]
irq_forced_thread_fn+0xc8/0xf0^M
[    5.261921][    C1] [c00000000a5e7d00] [c0000000001d7ae4]
irq_thread+0x1b4/0x2a0^M
[    5.265298][    C1] [c00000000a5e7da0] [c00000000017d8c8]
kthread+0x1a8/0x1d0^M
[    5.269184][    C1] [c00000000a5e7e10] [c00000000000cee4]

By adding printk statement in the SCSI subsystem and perform rounds of
qemu bootup, I found the bug is caused by following 'use after free'
scenery:

A)
                           B)
__scsi_scan_target
  scsi_probe_and_add_lun
     scsi_probe_lun
       scsi_execute_req
         __scsi_execute
            blk_execute_rq              ---> req --->
time out
   __scsi_remove_device
       blk_cleanup_queue
           percpu_ref_exit(&q->q_usage_counter)
     scsi_end_request

                                   percpu_ref_put(&q->q_usage_counter)

                                      USE-AFTER-FREE
Reported-by: Zhouyi Zhou <zhouzhouyi@gmail.com>

Thanks for your intention
Zhouyi
[1] https://lore.kernel.org/lkml/CAABZP2wa_ZTHUr9tH_6OSpr+TgNACo4kMu3eawsGV5qkCDoAKg@mail.gmail.com/T/
