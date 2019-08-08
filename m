Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9131A86A61
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404893AbfHHTPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404458AbfHHTGf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:06:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E15F2184E;
        Thu,  8 Aug 2019 19:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291194;
        bh=uLl5H01r+k8IDY1DBXgejoGkOhkHH3VpZfJmjS8a4VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8v3Cyr7pvkTQ9tw9GQUnMjbpQx76zbROYUchsHS302TQDGEEHbuzxiZ9Xhp8FroM
         biuWxCPGIPThNLh9C5VYsktdIfdS28ztxqpqtDF2IeKF72IFJWtN0OY6IkgkUY0a0E
         HjsMMvjOtwjvPg861LZGWqb6yM8APTOE047RIwB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 22/56] net/mlx5e: always initialize frag->last_in_page
Date:   Thu,  8 Aug 2019 21:04:48 +0200
Message-Id: <20190808190453.775711815@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 60d60c8fbd8d1acf25b041ecd72ae4fa16e9405b ]

The commit 069d11465a80 ("net/mlx5e: RX, Enhance legacy Receive Queue
memory scheme") introduced an undefined behaviour below due to
"frag->last_in_page" is only initialized in mlx5e_init_frags_partition()
when,

if (next_frag.offset + frag_info[f].frag_stride > PAGE_SIZE)

or after bailed out the loop,

for (i = 0; i < mlx5_wq_cyc_get_size(&rq->wqe.wq); i++)

As the result, there could be some "frag" have uninitialized
value of "last_in_page".

Later, get_frag() obtains those "frag" and check "frag->last_in_page" in
mlx5e_put_rx_frag() and triggers the error during boot. Fix it by always
initializing "frag->last_in_page" to "false" in
mlx5e_init_frags_partition().

UBSAN: Undefined behaviour in
drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:325:12
load of value 170 is not a valid value for type 'bool' (aka '_Bool')
Call trace:
 dump_backtrace+0x0/0x264
 show_stack+0x20/0x2c
 dump_stack+0xb0/0x104
 __ubsan_handle_load_invalid_value+0x104/0x128
 mlx5e_handle_rx_cqe+0x8e8/0x12cc [mlx5_core]
 mlx5e_poll_rx_cq+0xca8/0x1a94 [mlx5_core]
 mlx5e_napi_poll+0x17c/0xa30 [mlx5_core]
 net_rx_action+0x248/0x940
 __do_softirq+0x350/0x7b8
 irq_exit+0x200/0x26c
 __handle_domain_irq+0xc8/0x128
 gic_handle_irq+0x138/0x228
 el1_irq+0xb8/0x140
 arch_cpu_idle+0x1a4/0x348
 do_idle+0x114/0x1b0
 cpu_startup_entry+0x24/0x28
 rest_init+0x1ac/0x1dc
 arch_call_rest_init+0x10/0x18
 start_kernel+0x4d4/0x57c

Fixes: 069d11465a80 ("net/mlx5e: RX, Enhance legacy Receive Queue memory scheme")
Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -340,12 +340,11 @@ static inline u64 mlx5e_get_mpwqe_offset
 
 static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 {
-	struct mlx5e_wqe_frag_info next_frag, *prev;
+	struct mlx5e_wqe_frag_info next_frag = {};
+	struct mlx5e_wqe_frag_info *prev = NULL;
 	int i;
 
 	next_frag.di = &rq->wqe.di[0];
-	next_frag.offset = 0;
-	prev = NULL;
 
 	for (i = 0; i < mlx5_wq_cyc_get_size(&rq->wqe.wq); i++) {
 		struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];


