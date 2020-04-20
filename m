Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1591B0BBA
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgDTM54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727782AbgDTMnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:43:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F0422072B;
        Mon, 20 Apr 2020 12:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386623;
        bh=9cG006k3LbqtUOh3C3GQ/cY8hx5/Uc58zO0Ys8/zvsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OizvOOMPTk5EOKlhdBE2CSKKC2B5mHAt3gMsA63CqTyhtG0mUABXF7sXc9WhmLYUW
         e92nzP8eblBTO/C21NyaHu9zPTSylfG0qGQECvdrIEOqeUB2RpgFJ6MGX+ZZO1Tf1S
         PrvAIKf29eOEvqfDO/4aBhz0Hi6nsam0dZgAtgT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.6 14/71] net/mlx5: Fix frequent ioread PCI access during recovery
Date:   Mon, 20 Apr 2020 14:38:28 +0200
Message-Id: <20200420121511.428346027@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit 8c702a53bb0a79bfa203ba21ef1caba43673c5b7 ]

High frequency of PCI ioread calls during recovery flow may cause the
following trace on powerpc:

[ 248.670288] EEH: 2100000 reads ignored for recovering device at
location=Slot1 driver=mlx5_core pci addr=0000:01:00.1
[ 248.670331] EEH: Might be infinite loop in mlx5_core driver
[ 248.670361] CPU: 2 PID: 35247 Comm: kworker/u192:11 Kdump: loaded
Tainted: G OE ------------ 4.14.0-115.14.1.el7a.ppc64le #1
[ 248.670425] Workqueue: mlx5_health0000:01:00.1 health_recover_work
[mlx5_core]
[ 248.670471] Call Trace:
[ 248.670492] [c00020391c11b960] [c000000000c217ac] dump_stack+0xb0/0xf4
(unreliable)
[ 248.670548] [c00020391c11b9a0] [c000000000045818]
eeh_check_failure+0x5c8/0x630
[ 248.670631] [c00020391c11ba50] [c00000000068fce4]
ioread32be+0x114/0x1c0
[ 248.670692] [c00020391c11bac0] [c00800000dd8b400]
mlx5_error_sw_reset+0x160/0x510 [mlx5_core]
[ 248.670752] [c00020391c11bb60] [c00800000dd75824]
mlx5_disable_device+0x34/0x1d0 [mlx5_core]
[ 248.670822] [c00020391c11bbe0] [c00800000dd8affc]
health_recover_work+0x11c/0x3c0 [mlx5_core]
[ 248.670891] [c00020391c11bc80] [c000000000164fcc]
process_one_work+0x1bc/0x5f0
[ 248.670955] [c00020391c11bd20] [c000000000167f8c]
worker_thread+0xac/0x6b0
[ 248.671015] [c00020391c11bdc0] [c000000000171618] kthread+0x168/0x1b0
[ 248.671067] [c00020391c11be30] [c00000000000b65c]
ret_from_kernel_thread+0x5c/0x80

Reduce the PCI ioread frequency during recovery by using msleep()
instead of cond_resched()

Fixes: 3e5b72ac2f29 ("net/mlx5: Issue SW reset on FW assert")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Feras Daoud <ferasda@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -243,7 +243,7 @@ recover_from_sw_reset:
 		if (mlx5_get_nic_state(dev) == MLX5_NIC_IFC_DISABLED)
 			break;
 
-		cond_resched();
+		msleep(20);
 	} while (!time_after(jiffies, end));
 
 	if (mlx5_get_nic_state(dev) != MLX5_NIC_IFC_DISABLED) {


