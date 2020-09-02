Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E438A25A2F1
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 04:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgIBCM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 22:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgIBCMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 22:12:54 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F45DC061244
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 19:12:54 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d22so1966992pfn.5
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 19:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:references:to:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tCi0NSRN520tFZBfN9tGZPv0GW+VKietKjyn3B/X3/U=;
        b=YWllcw1YwzUisghZlq/YoKWsnlel5n9Gs5XWiNGp1B+83agsge811iYTgmmu0Gy6Su
         whEotvDQJYswOU3JoLUriH0JN9Dk2VschZPeeWbuQltyOP0mIr+anMLPYgQhvvLU6GN5
         0wPPVM6CAWbpArSH5Tr7Q7WCkb5yWfn6KmJzxHyYsfBL/SKXd4pGxyKd7VDcQvQeA8iC
         dvU375uEjAUySx6VV9AKE0rigghKIcQKJiRYPdfmsEhMjRfoNacdMhAjLWbjXuQojW40
         EDPygh3lydqN3AbPEFbxj38xw9FwfHJOps/hifjq4uAOUAXrHwq1psJThzSuYOJEf1Ta
         Yh2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:references:to:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tCi0NSRN520tFZBfN9tGZPv0GW+VKietKjyn3B/X3/U=;
        b=uRUIdEIg6nEXWPlQDjsw/A0YeXwsK04R/NJ5jZ3Lj2eKi9StIZN73elo98SB0QyD/u
         op1JcyPrKUshXmgLRDOlWv1GvVedik4FDGddZWUkmuJpKwZdSV8MUEPM/rs41pyzOBP1
         hjLEWbo9EswtoO4t435wguy/uw+qNc1HitSpmn/Mg5q6XmdutNv/ReHlP5mw8XdekODA
         kNYY7HREXOLoJ5jUacFcWi1+PT0kuCYsK04uUSJr8FQLDM3Gs0JFbfXt7UnyrsgQTjUG
         qePcvFt256p14pPc1MaAOMOBBohbTaQUtxVM9J07EXuhTlzaPbI9+sWgj3mbAe0gyzWl
         H0Lg==
X-Gm-Message-State: AOAM533yYVhqmGXEFKeTFJsbtjZhhGyJJ2ZFcwVHmRBsfZDLxm+CMhVL
        h3Qa2AC0bmw53+eJwNkXxt9x7oZP5O6unjn5
X-Google-Smtp-Source: ABdhPJzB9t57XUF5GovTgnEygGgiYL+ysedexitiMkQ84LCf7zt/wej6eaKF/hJtrcbLdqZdNaXY0g==
X-Received: by 2002:a05:6a00:1343:: with SMTP id k3mr1083956pfu.91.1599012773666;
        Tue, 01 Sep 2020 19:12:53 -0700 (PDT)
Received: from [192.168.1.187] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c130sm3479227pfb.115.2020.09.01.19.12.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 19:12:53 -0700 (PDT)
Subject: Fwd: [PATCH] io_uring: Fix NULL pointer dereference in
 io_sq_wq_submit_work()
References: <20200902015948.109580-1-yinxin_1989@aliyun.com>
To:     stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
X-Forwarded-Message-Id: <20200902015948.109580-1-yinxin_1989@aliyun.com>
Message-ID: <be051730-4ffe-0907-65c3-ace0ce070e09@kernel.dk>
Date:   Tue, 1 Sep 2020 20:12:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200902015948.109580-1-yinxin_1989@aliyun.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can you queue this for 5.4-stable? Thanks!


-------- Forwarded Message --------
Subject: [PATCH] io_uring: Fix NULL pointer dereference in io_sq_wq_submit_work()
Date: Wed,  2 Sep 2020 09:59:48 +0800
From: Xin Yin <yinxin_1989@aliyun.com>
To: axboe@kernel.dk, viro@zeniv.linux.org.uk
CC: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Yin <yinxin_1989@aliyun.com>

the commit <1c4404efcf2c0> ("<io_uring: make sure async workqueue
is canceled on exit>") caused a crash in io_sq_wq_submit_work().
when io_ring-wq get a req form async_list, which not have been
added to task_list. Then try to delete the req from task_list will caused
a "NULL pointer dereference".

Ensure add req to async_list and task_list at the sametime.

The crash log looks like this:
[95995.973638] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[95995.979123] pgd = c20c8964
[95995.981803] [00000000] *pgd=1c72d831, *pte=00000000, *ppte=00000000
[95995.988043] Internal error: Oops: 817 [#1] SMP ARM
[95995.992814] Modules linked in: bpfilter(-)
[95995.996898] CPU: 1 PID: 15661 Comm: kworker/u8:5 Not tainted 5.4.56 #2
[95996.003406] Hardware name: Amlogic Meson platform
[95996.008108] Workqueue: io_ring-wq io_sq_wq_submit_work
[95996.013224] PC is at io_sq_wq_submit_work+0x1f4/0x5c4
[95996.018261] LR is at walk_stackframe+0x24/0x40
[95996.022685] pc : [<c059b898>]    lr : [<c030da7c>]    psr: 600f0093
[95996.028936] sp : dc6f7e88  ip : dc6f7df0  fp : dc6f7ef4
[95996.034148] r10: deff9800  r9 : dc1d1694  r8 : dda58b80
[95996.039358] r7 : dc6f6000  r6 : dc6f7ebc  r5 : dc1d1600  r4 : deff99c0
[95996.045871] r3 : 0000cb5d  r2 : 00000000  r1 : ef6b9b80  r0 : c059b88c
[95996.052385] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
[95996.059593] Control: 10c5387d  Table: 22be804a  DAC: 00000055
[95996.065325] Process kworker/u8:5 (pid: 15661, stack limit = 0x78013c69)
[95996.071923] Stack: (0xdc6f7e88 to 0xdc6f8000)
[95996.076268] 7e80:                   dc6f7ecc dc6f7e98 00000000 c1f06c08 de9dc800 deff9a04
[95996.084431] 7ea0: 00000000 dc6f7f7c 00000000 c1f65808 0000080c dc677a00 c1ee9bd0 dc6f7ebc
[95996.092594] 7ec0: dc6f7ebc d085c8f6 c0445a90 dc1d1e00 e008f300 c0288400 e4ef7100 00000000
[95996.100757] 7ee0: c20d45b0 e4ef7115 dc6f7f34 dc6f7ef8 c03725f0 c059b6b0 c0288400 c0288400
[95996.108921] 7f00: c0288400 00000001 c0288418 e008f300 c0288400 e008f314 00000088 c0288418
[95996.117083] 7f20: c1f03d00 dc6f6038 dc6f7f7c dc6f7f38 c0372df8 c037246c dc6f7f5c 00000000
[95996.125245] 7f40: c1f03d00 c1f03d00 c20d3cbe c0288400 dc6f7f7c e1c43880 e4fa7980 00000000
[95996.133409] 7f60: e008f300 c0372d9c e48bbe74 e1c4389c dc6f7fac dc6f7f80 c0379244 c0372da8
[95996.141570] 7f80: 600f0093 e4fa7980 c0379108 00000000 00000000 00000000 00000000 00000000
[95996.149734] 7fa0: 00000000 dc6f7fb0 c03010ac c0379114 00000000 00000000 00000000 00000000
[95996.157897] 7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[95996.166060] 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[95996.174217] Backtrace:
[95996.176662] [<c059b6a4>] (io_sq_wq_submit_work) from [<c03725f0>] (process_one_work+0x190/0x4c0)
[95996.185425]  r10:e4ef7115 r9:c20d45b0 r8:00000000 r7:e4ef7100 r6:c0288400 r5:e008f300
[95996.193237]  r4:dc1d1e00
[95996.195760] [<c0372460>] (process_one_work) from [<c0372df8>] (worker_thread+0x5c/0x5bc)
[95996.203836]  r10:dc6f6038 r9:c1f03d00 r8:c0288418 r7:00000088 r6:e008f314 r5:c0288400
[95996.211647]  r4:e008f300
[95996.214173] [<c0372d9c>] (worker_thread) from [<c0379244>] (kthread+0x13c/0x168)
[95996.221554]  r10:e1c4389c r9:e48bbe74 r8:c0372d9c r7:e008f300 r6:00000000 r5:e4fa7980
[95996.229363]  r4:e1c43880
[95996.231888] [<c0379108>] (kthread) from [<c03010ac>] (ret_from_fork+0x14/0x28)
[95996.239088] Exception stack(0xdc6f7fb0 to 0xdc6f7ff8)
[95996.244127] 7fa0:                                     00000000 00000000 00000000 00000000
[95996.252291] 7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[95996.260453] 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[95996.267054]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c0379108
[95996.274866]  r4:e4fa7980 r3:600f0093
[95996.278430] Code: eb3a59e1 e5952098 e5951094 e5812004 (e5821000)

Signed-off-by: Xin Yin <yinxin_1989@aliyun.com>
---
 fs/io_uring.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fada14ee1cdc..2a539b794f3b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2378,6 +2378,15 @@ static bool io_add_to_prev_work(struct async_list *list, struct io_kiocb *req)
 		list_del_init(&req->list);
 		ret = false;
 	}
+
+	if (ret) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		spin_lock_irq(&ctx->task_lock);
+		list_add(&req->task_list, &ctx->task_list);
+		req->work_task = NULL;
+		spin_unlock_irq(&ctx->task_lock);
+	}
 	spin_unlock(&list->lock);
 	return ret;
 }
-- 
2.19.5

