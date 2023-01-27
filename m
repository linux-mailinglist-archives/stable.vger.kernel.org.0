Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F3867EBA3
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 17:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbjA0Qxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 11:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbjA0Qxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 11:53:53 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8460B2E814
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 08:53:38 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id m8so2515918ili.7
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 08:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nua+DsCEcokGFKgzeFqSrYyPpVGFrpP2HdUfaCzpN5s=;
        b=ey/+ifzd6cgiY0LYKWnFKldp1yKuves9PfHyobHZBMx4h8vn7w59BG4fWB5wV5Yeq6
         gPdtG6er92kdCCC8BSXAahnFDKepLFnfh+uLNViRga31SxDHAb/GBRtFAeJ7Qzz6NHNc
         Iv+PAEYjExSm9H+8HgHMAYAUGAxT/SASUIvZRo8s1l8/mqQ+hUkPRdsWgBXyOZMZ8WMI
         UQ4K8tQwZ3TDYmt59y1v7q8zUw4GiILBxq/Wp4QP0Rc1yta6a9DbA2z/6H+KiPEf6wQG
         EjWtpwZVPgJMmFwVvEUaT1OVeoUFlZnC5Ad56As/58oKqlabzBuIWqP5WHxeG5gW5vfF
         JU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nua+DsCEcokGFKgzeFqSrYyPpVGFrpP2HdUfaCzpN5s=;
        b=pC6hpvkQqFr6ZqF5s3Lhyk15WpIwQ6u8T+IxJiY5iwrEMepqm5AdntJn7cDmHGh7yb
         WWZks+7Gq+SmbssMu0oi+5wwzZqy2HMJLF5P5SCG0eNVUEKIlCWSwGpKCAhyqZ9eXjQb
         IC5TpmOC8QbfdQPhjDTYufjAzSEpxyi+JRC8/GytTE9oxDK1dD5rfodE+nZ0W4jH3B1P
         7CNifV7TnNyqK1dkRM8UIFkQUI6Gdaxw+4vQnPSg8/T8AY81xEKsLXYf3hb2Ry2nPA1+
         Ulg92v2J71ZTMYRre6PA9SAXS1aQH/xd8/rqnh0B1fOGMP2aqMGj3vS8YeGZj6H7yLjd
         zubg==
X-Gm-Message-State: AFqh2kp3BfzqSnYABq01ifldgB6HZBF4Gg+qHK2oLeuznuOevY6Z21Dr
        w1JJX9ByvKxCNc4iVf6E4qdWKYt2ZhJPEZ5h
X-Google-Smtp-Source: AMrXdXs1Ys3f1pk5k3PuuFuKB5Gf9g8ICeDJyb1kVocbp4ZwOAD/2xN2dLhlJoaEMLeY/2/5peOsLw==
X-Received: by 2002:a92:d3c2:0:b0:30f:4feb:50c7 with SMTP id c2-20020a92d3c2000000b0030f4feb50c7mr3666121ilh.3.1674838417668;
        Fri, 27 Jan 2023 08:53:37 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u4-20020a02cb84000000b0039db6cffcbasm1620587jap.71.2023.01.27.08.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 08:53:36 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: add a conditional reschedule to the IOPOLL cancelation loop
Date:   Fri, 27 Jan 2023 09:53:31 -0700
Message-Id: <20230127165332.71970-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230127165332.71970-1-axboe@kernel.dk>
References: <20230127165332.71970-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the kernel is configured with CONFIG_PREEMPT_NONE, we could be
sitting in a tight loop reaping events but not giving them a chance to
finish. This results in a trace ala:

rcu: INFO: rcu_sched self-detected stall on CPU
rcu: 	2-...!: (5249 ticks this GP) idle=935c/1/0x4000000000000000 softirq=4265/4274 fqs=1
	(t=5251 jiffies g=465 q=4135 ncpus=4)
rcu: rcu_sched kthread starved for 5249 jiffies! g465 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_sched kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_sched       state:R  running task     stack:0     pid:12    ppid:2      flags:0x00000008
Call trace:
 __switch_to+0xb0/0xc8
 __schedule+0x43c/0x520
 schedule+0x4c/0x98
 schedule_timeout+0xbc/0xdc
 rcu_gp_fqs_loop+0x308/0x344
 rcu_gp_kthread+0xd8/0xf0
 kthread+0xb8/0xc8
 ret_from_fork+0x10/0x20
rcu: Stack dump where RCU GP kthread last ran:
Task dump for CPU 0:
task:kworker/u8:10   state:R  running task     stack:0     pid:89    ppid:2      flags:0x0000000a
Workqueue: events_unbound io_ring_exit_work
Call trace:
 __switch_to+0xb0/0xc8
 0xffff0000c8fefd28
CPU: 2 PID: 95 Comm: kworker/u8:13 Not tainted 6.2.0-rc5-00042-g40316e337c80-dirty #2759
Hardware name: linux,dummy-virt (DT)
Workqueue: events_unbound io_ring_exit_work
pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : io_do_iopoll+0x344/0x360
lr : io_do_iopoll+0xb8/0x360
sp : ffff800009bebc60
x29: ffff800009bebc60 x28: 0000000000000000 x27: 0000000000000000
x26: ffff0000c0f67d48 x25: ffff0000c0f67840 x24: ffff800008950024
x23: 0000000000000001 x22: 0000000000000000 x21: ffff0000c27d3200
x20: ffff0000c0f67840 x19: ffff0000c0f67800 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000001 x13: 0000000000000001 x12: 0000000000000000
x11: 0000000000000179 x10: 0000000000000870 x9 : ffff800009bebd60
x8 : ffff0000c27d3ad0 x7 : fefefefefefefeff x6 : 0000646e756f626e
x5 : ffff0000c0f67840 x4 : 0000000000000000 x3 : ffff0000c2398000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_do_iopoll+0x344/0x360
 io_uring_try_cancel_requests+0x21c/0x334
 io_ring_exit_work+0x90/0x40c
 process_one_work+0x1a4/0x254
 worker_thread+0x1ec/0x258
 kthread+0xb8/0xc8
 ret_from_fork+0x10/0x20

Add a cond_resched() in the cancelation IOPOLL loop to fix this.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 80b6204769e8..bb8a532b051e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3162,6 +3162,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		while (!wq_list_empty(&ctx->iopoll_list)) {
 			io_iopoll_try_reap_events(ctx);
 			ret = true;
+			cond_resched();
 		}
 	}
 
-- 
2.39.0

