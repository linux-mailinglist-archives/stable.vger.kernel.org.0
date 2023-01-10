Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D37266486F
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238959AbjAJSLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239068AbjAJSKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:10:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D182BDD
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:09:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B86DAB818D0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2E0C433EF;
        Tue, 10 Jan 2023 18:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374141;
        bh=W2ZA42LxkmspmCSpJqNhI9UlfDiggxcQmXejsapH+QM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXrQe3HfQocOrXPS0xKe1GMN+hgf3RdAEsfFBxn7iYvESlA3rk6/HS/KQJXOpQ3mM
         t6Wp5+AzlBlmJpxTFoPnI6+OK62vahh7YiCZR+/QRDSP6pPBDMZYJT7rN154lU5uUv
         AubEKy7Dz6u8mykO2WuW2WJxUMKIrfTKKJUEl9bA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eli Cohen <elic@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 060/148] net/mlx5: Lag, fix failure to cancel delayed bond work
Date:   Tue, 10 Jan 2023 19:02:44 +0100
Message-Id: <20230110180019.126484175@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 4d1c1379d71777ddeda3e54f8fc26e9ecbfd1009 ]

Commit 0d4e8ed139d8 ("net/mlx5: Lag, avoid lockdep warnings")
accidentally removed a call to cancel delayed bond work thus it may
cause queued delay to expire and fall on an already destroyed work
queue.

Fix by restoring the call cancel_delayed_work_sync() before
destroying the workqueue.

This prevents call trace such as this:

[  329.230417] BUG: kernel NULL pointer dereference, address: 0000000000000000
 [  329.231444] #PF: supervisor write access in kernel mode
 [  329.232233] #PF: error_code(0x0002) - not-present page
 [  329.233007] PGD 0 P4D 0
 [  329.233476] Oops: 0002 [#1] SMP
 [  329.234012] CPU: 5 PID: 145 Comm: kworker/u20:4 Tainted: G OE      6.0.0-rc5_mlnx #1
 [  329.235282] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 [  329.236868] Workqueue: mlx5_cmd_0000:08:00.1 cmd_work_handler [mlx5_core]
 [  329.237886] RIP: 0010:_raw_spin_lock+0xc/0x20
 [  329.238585] Code: f0 0f b1 17 75 02 f3 c3 89 c6 e9 6f 3c 5f ff 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 0f 1f 44 00 00 31 c0 ba 01 00 00 00 <f0> 0f b1 17 75 02 f3 c3 89 c6 e9 45 3c 5f ff 0f 1f 44 00 00 0f 1f
 [  329.241156] RSP: 0018:ffffc900001b0e98 EFLAGS: 00010046
 [  329.241940] RAX: 0000000000000000 RBX: ffffffff82374ae0 RCX: 0000000000000000
 [  329.242954] RDX: 0000000000000001 RSI: 0000000000000014 RDI: 0000000000000000
 [  329.243974] RBP: ffff888106ccf000 R08: ffff8881004000c8 R09: ffff888100400000
 [  329.244990] R10: 0000000000000000 R11: ffffffff826669f8 R12: 0000000000002000
 [  329.246009] R13: 0000000000000005 R14: ffff888100aa7ce0 R15: ffff88852ca80000
 [  329.247030] FS:  0000000000000000(0000) GS:ffff88852ca80000(0000) knlGS:0000000000000000
 [  329.248260] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [  329.249111] CR2: 0000000000000000 CR3: 000000016d675001 CR4: 0000000000770ee0
 [  329.250133] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [  329.251152] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 [  329.252176] PKRU: 55555554

Fixes: 0d4e8ed139d8 ("net/mlx5: Lag, avoid lockdep warnings")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index bbe810f3b373..c142011d2097 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -201,6 +201,7 @@ static void mlx5_ldev_free(struct kref *ref)
 	if (ldev->nb.notifier_call)
 		unregister_netdevice_notifier_net(&init_net, &ldev->nb);
 	mlx5_lag_mp_cleanup(ldev);
+	cancel_delayed_work_sync(&ldev->bond_work);
 	destroy_workqueue(ldev->wq);
 	mlx5_lag_mpesw_cleanup(ldev);
 	mutex_destroy(&ldev->lock);
-- 
2.35.1



