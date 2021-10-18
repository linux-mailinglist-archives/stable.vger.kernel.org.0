Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93712431D3F
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbhJRNt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233598AbhJRNrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:47:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AAFD613C8;
        Mon, 18 Oct 2021 13:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564193;
        bh=jqL16xTccPc2iQwfJ90ixrkDYzSs3Zd9Cx3u7sMDWFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZoYdipuSNq7EjOJCVnVA3cFtXmKNCGAD9Sdar0pzG7lrixQZtN8ifd2kr2wkNopK
         in4Vpr2+y4/3xfmaqbNEAesuHl1yQqkZ4LZttGfH3bgRdbeJLOlFl7XlEBEsqVGOvw
         jgGVZtQMik+VerCumt7EyfFRCjJFvjVHxrzwrT4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 100/103] nfp: flow_offload: move flow_indr_dev_register from app init to app start
Date:   Mon, 18 Oct 2021 15:25:16 +0200
Message-Id: <20211018132338.102694295@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

commit 60d950f443a52d950126ad664fbd4a1eb8353dc9 upstream.

In commit 74fc4f828769 ("net: Fix offloading indirect devices dependency
on qdisc order creation"), it adds a process to trigger the callback to
setup the bo callback when the driver regists a callback.

In our current implement, we are not ready to run the callback when nfp
call the function flow_indr_dev_register, then there will be error
message as:

kernel: Oops: 0000 [#1] SMP PTI
kernel: CPU: 0 PID: 14119 Comm: kworker/0:0 Tainted: G
kernel: Workqueue: events work_for_cpu_fn
kernel: RIP: 0010:nfp_flower_indr_setup_tc_cb+0x258/0x410
kernel: RSP: 0018:ffffbc1e02c57bf8 EFLAGS: 00010286
kernel: RAX: 0000000000000000 RBX: ffff9c761fabc000 RCX: 0000000000000001
kernel: RDX: 0000000000000001 RSI: fffffffffffffff0 RDI: ffffffffc0be9ef1
kernel: RBP: ffffbc1e02c57c58 R08: ffffffffc08f33aa R09: ffff9c6db7478800
kernel: R10: 0000009c003f6e00 R11: ffffbc1e02800000 R12: ffffbc1e000d9000
kernel: R13: ffffbc1e000db428 R14: ffff9c6db7478800 R15: ffff9c761e884e80
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: fffffffffffffff0 CR3: 00000009e260a004 CR4: 00000000007706f0
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
kernel: PKRU: 55555554
kernel: Call Trace:
kernel: ? flow_indr_dev_register+0xab/0x210
kernel: ? __cond_resched+0x15/0x30
kernel: ? kmem_cache_alloc_trace+0x44/0x4b0
kernel: ? nfp_flower_setup_tc+0x1d0/0x1d0 [nfp]
kernel: flow_indr_dev_register+0x158/0x210
kernel: ? tcf_block_unbind+0xe0/0xe0
kernel: nfp_flower_init+0x40b/0x650 [nfp]
kernel: nfp_net_pci_probe+0x25f/0x960 [nfp]
kernel: ? nfp_rtsym_read_le+0x76/0x130 [nfp]
kernel: nfp_pci_probe+0x6a9/0x820 [nfp]
kernel: local_pci_probe+0x45/0x80

So we need to call flow_indr_dev_register in app start process instead of
init stage.

Fixes: 74fc4f828769 ("net: Fix offloading indirect devices dependency on qdisc order creation")
Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Link: https://lore.kernel.org/r/20211012124850.13025-1-louis.peens@corigine.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/flower/main.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -830,10 +830,6 @@ static int nfp_flower_init(struct nfp_ap
 	if (err)
 		goto err_cleanup;
 
-	err = flow_indr_dev_register(nfp_flower_indr_setup_tc_cb, app);
-	if (err)
-		goto err_cleanup;
-
 	if (app_priv->flower_ext_feats & NFP_FL_FEATS_VF_RLIM)
 		nfp_flower_qos_init(app);
 
@@ -942,7 +938,20 @@ static int nfp_flower_start(struct nfp_a
 			return err;
 	}
 
-	return nfp_tunnel_config_start(app);
+	err = flow_indr_dev_register(nfp_flower_indr_setup_tc_cb, app);
+	if (err)
+		return err;
+
+	err = nfp_tunnel_config_start(app);
+	if (err)
+		goto err_tunnel_config;
+
+	return 0;
+
+err_tunnel_config:
+	flow_indr_dev_unregister(nfp_flower_indr_setup_tc_cb, app,
+				 nfp_flower_setup_indr_tc_release);
+	return err;
 }
 
 static void nfp_flower_stop(struct nfp_app *app)


