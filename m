Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95A333AF9C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 11:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhCOKJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 06:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhCOKJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 06:09:42 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0BFC061574
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 03:09:42 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id a188so6260765pfb.4
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 03:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xjxz7T7FKCNoP/ooGZ5ryoM5GFAU3/9+k7o+wjXhrVw=;
        b=lAMovr6GQ0+cA2UoJCJBdsf+W2wwVH8YGDsefc3jb+yEMvKgtPYlkBSKfilWKKM9xd
         BfL+0vEnd6VYztUNciFcNG7di9KTHJngOW255oS581KO3nnEfvrUJEW/TqwALKqjks34
         EzJhYwTpIt6CILPOX0GoJhfgfVgbp3LmUh1ouZWvJ8Lp5cDP/NfZJYV8oeKsbvCYUjS1
         xcuFWyI9j0gQNcE40KUOiEXmz6lAtm1XCjW/RlMD/SgzNdJWNrcDkq8uPM/UxdD1rj31
         HU8zW/HiGa6ZVYQSDNA4N1pAtcp/WtNdQnntzA9HQNf+J8hFcOykv29424nyvKJtxA6k
         yEJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xjxz7T7FKCNoP/ooGZ5ryoM5GFAU3/9+k7o+wjXhrVw=;
        b=l8+JW3/q9Vmso6LF4CGZt2rSKPSSJ9CwW2fNNOl6GVpwV38+RB9cJtigd7dmBtm4HA
         w5dxEEJ78P8dNR1GJabeqHR+KnwGg8ZO9l/Js1XpScxi28+b03PoikDLQOZIrYhB62A7
         NDdxQgVDSnoiYSjUrg6LJDNC3YDVorVU8IKHI2acb1ugz4xFh64e4B5m6TsXArvlknNs
         6+jL2Gi/76kN6H7Spvi4Dp0ZiqX0IX1iQn3dvvTNTtgJvD/yK4bV/3zTqhaLLnyX6eDw
         DZFi7gjwRqkpmgs8h8UCVCz3QlZ8N4vM34O+Kpj+Pt7GeQvFuOkgAvqvV/jp4PsRQTdA
         EJ4g==
X-Gm-Message-State: AOAM533ZVYkHCRgwZC7yos7qfl3qpTZciamm9RcZR7J9l9lav9sdyhv0
        EzFAjEPqmAmlAMegIg6+qsY=
X-Google-Smtp-Source: ABdhPJyB8b3z7UgzqE+mO3JnWbDdIlOqVMT0Xa3wFEUx++/9WMzV6WADP6VfdgQg2AWQ4likNfV5PA==
X-Received: by 2002:a63:440e:: with SMTP id r14mr22303231pga.331.1615802982169;
        Mon, 15 Mar 2021 03:09:42 -0700 (PDT)
Received: from mydomain ([61.120.150.74])
        by smtp.gmail.com with ESMTPSA id 205sm8357863pfc.201.2021.03.15.03.09.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Mar 2021 03:09:41 -0700 (PDT)
From:   Hou Pu <houpu.main@gmail.com>
To:     hch@lst.de, sagi@grimberg.me, chaitanya.kulkarni@wdc.com
Cc:     linux-nvme@lists.infradead.org, Hou Pu <houpu.main@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] nvmet-tcp: finish receiving before send back response if nvmet_req_init() failed.
Date:   Mon, 15 Mar 2021 18:09:28 +0800
Message-Id: <20210315100928.87596-1-houpu.main@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When receiving a pdu, if nvmet_req_init() failed (for example a ns is
not found), the queue->rcv_state could be moved to NVMET_TCP_RECV_DATA
by nvmet_tcp_handle_req_failure(). We should return 0 here to continue
to consume the possible remaining inline write out data in
nvmet_tcp_try_recv_one(). Otherwise, the response to this request would
be sent and iov would be freed. Next time in nvmet_tcp_try_recv_one(),
we would go to the receiving data phase and the iov is used again.

A panic happend with a 5.4 kernel installed as below:

[  169.906573] nvmet_tcp: failed cmd 0000000027717054 id 106 opcode 1, data_len: 1024
[  169.908131] general protection fault: 0000 [#1] SMP NOPTI
[  169.908884] CPU: 0 PID: 122 Comm: kworker/0:1H Kdump: loaded Tainted: G           OE [...]
[  169.910328] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), [...]
[  169.911943] Workqueue: nvmet_tcp_wq nvmet_tcp_io_work [nvmet_tcp]
[  169.912815] RIP: 0010:__memcpy+0x12/0x20
[  169.913393] Code: e3 97 ff 0f 31 48 c1 e2 20 48 09 d0 48 31 c3 e9 79 ff [...]
[  169.915819] RSP: 0018:ffffc9000026bbc8 EFLAGS: 00010246
[  169.916547] RAX: ebf4958c4fda661b RBX: ffff888119613096 RCX: 0000000000000080
[  169.917511] RDX: 0000000000000000 RSI: ffff888119613096 RDI: ebf4958c4fda661b
[  169.918469] RBP: 0000000000000400 R08: 0000000000000000 R09: 0000000000000400
[  169.919435] R10: 0000000000000000 R11: 000000000000003e R12: ffff888114244068
[  169.920398] R13: 0000000000000400 R14: 0000000000000400 R15: ffff888118c37cb0
[  169.921378] FS:  0000000000000000(0000) GS:ffff88813fc00000(0000) knlGS:0000000000000000
[  169.922473] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  169.923269] CR2: 0000555eb19943e0 CR3: 00000001186fc000 CR4: 00000000000006f0
[  169.924245] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  169.925214] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  169.926184] Call Trace:
[  169.926569]  _copy_to_iter+0x26f/0x440
[  169.927112]  ? __check_object_size+0x70/0x230
[  169.927724]  __skb_datagram_iter+0x15a/0x290
[  169.928327]  ? skb_kill_datagram+0x60/0x60
[  169.928921]  skb_copy_datagram_iter+0x3b/0x90
[  169.929545]  tcp_recvmsg+0x759/0xc50
[  169.930081]  ? ksoftirqd_running+0x2c/0x30
[  169.930668]  ? free_unref_page_commit+0x95/0x120
[  169.931331]  inet_recvmsg+0x55/0xc0
[  169.931834]  nvmet_tcp_io_work+0x685/0xb23 [nvmet_tcp]
[  169.932549]  process_one_work+0x18c/0x370
[  169.933118]  worker_thread+0x4f/0x3b0
[  169.933654]  ? rescuer_thread+0x340/0x340
[  169.934223]  kthread+0xf6/0x130
[  169.934682]  ? kthread_create_worker_on_cpu+0x70/0x70
[  169.935393]  ret_from_fork+0x1f/0x30

Cc: <stable@vger.kernel.org> # 5.0
Signed-off-by: Hou Pu <houpu.main@gmail.com>
---
 drivers/nvme/target/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 8b0485ada315..da1c667e21ba 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -961,7 +961,7 @@ static int nvmet_tcp_done_recv_pdu(struct nvmet_tcp_queue *queue)
 			le32_to_cpu(req->cmd->common.dptr.sgl.length));
 
 		nvmet_tcp_handle_req_failure(queue, queue->cmd, req);
-		return -EAGAIN;
+		return 0;
 	}
 
 	ret = nvmet_tcp_map_data(queue->cmd);
-- 
2.28.0

