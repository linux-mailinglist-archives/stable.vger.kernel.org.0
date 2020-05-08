Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D461CAB0D
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgEHMjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbgEHMjW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1C1521835;
        Fri,  8 May 2020 12:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941561;
        bh=XgqZ47eejARrn/IJvigT5qeeQFyfofjfC9J7rZ7c808=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tf7yUI+D60RwcdQ9bCvmWfvv03XP5e4LNFFzq18+ysJdwOyFvLKlwhhR3tuygAQQx
         08C6bkd1orrOhDxQ6jM6fjkJaCWTv43l7M6kV/Pz6G020dCPsHtgiRHpjtdQj6jMH7
         4Ai7FMBkU4ptcH3VxLZtoQv2eGxNwCPIoz7Pt4E8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mohamad Haj Yahia <mohamad@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 081/312] net/mlx5: Avoid calling sleeping function by the health poll thread
Date:   Fri,  8 May 2020 14:31:12 +0200
Message-Id: <20200508123130.227210621@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohamad Haj Yahia <mohamad@mellanox.com>

commit c1d4d2e92ad670168a17a57dfa182a5a5baa72d4 upstream.

In internal error state the health poll thread will eventually call
synchronize_irq() (to safely trigger command completions) which might
sleep, so we are calling sleeping function from atomic context which is
invalid.
Here we move trigger_cmd_completions(dev) to enter error state which is
the earliest stage in error state handling.
This way we won't need to wait for next health poll to trigger command
completions and will solve the scheduling while atomic issue.
mlx5_enter_error_state can be called from two contexts, protect it with
dev->intf_state_lock

Fixes: 89d44f0a6c73 ('net/mlx5_core: Add pci error handlers to mlx5_core driver')
Signed-off-by: Mohamad Haj Yahia <mohamad@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/health.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -108,15 +108,21 @@ static int in_fatal(struct mlx5_core_dev
 
 void mlx5_enter_error_state(struct mlx5_core_dev *dev)
 {
+	mutex_lock(&dev->intf_state_mutex);
 	if (dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
-		return;
+		goto unlock;
 
 	mlx5_core_err(dev, "start\n");
-	if (pci_channel_offline(dev->pdev) || in_fatal(dev))
+	if (pci_channel_offline(dev->pdev) || in_fatal(dev)) {
 		dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
+		trigger_cmd_completions(dev);
+	}
 
 	mlx5_core_event(dev, MLX5_DEV_EVENT_SYS_ERROR, 0);
 	mlx5_core_err(dev, "end\n");
+
+unlock:
+	mutex_unlock(&dev->intf_state_mutex);
 }
 
 static void mlx5_handle_bad_state(struct mlx5_core_dev *dev)
@@ -245,7 +251,6 @@ static void poll_health(unsigned long da
 	u32 count;
 
 	if (dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR) {
-		trigger_cmd_completions(dev);
 		mod_timer(&health->timer, get_next_poll_jiffies());
 		return;
 	}


