Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DAD1CAF41
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729536AbgEHNQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728881AbgEHMpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCBA32145D;
        Fri,  8 May 2020 12:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941905;
        bh=AZFAajj6vGzBXFJeIq6jSaAV/h+w4Rx6RIx4LoU/HHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+v1FGjW4HWk0ttSgz2/hZlkr9C0m77nA8+6+q1j2SN4iE1uc86rit9Xq1uRXfxQQ
         MvmHe6GA9GjnxWwi2ztfo6ZLhsNX6MR0VKMdJvSELBV/4/sOsnQbbBUiJaj0w4B4dZ
         PPKIgP+EXbrG01MYWJgLGZgl9Ytk5qvYp5x6Z3VI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 218/312] net/mlx4_core: Do not access comm channel if it has not yet been initialized
Date:   Fri,  8 May 2020 14:33:29 +0200
Message-Id: <20200508123139.792987205@linuxfoundation.org>
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

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

commit 81d184199e328fdad5633da139a10337327154e0 upstream.

In the Hypervisor, there are several FW commands which are invoked
before the comm channel is initialized (in mlx4_multi_func_init).
These include MOD_STAT_CONFIG, QUERY_DEV_CAP, INIT_HCA, and others.

If any of these commands fails, say with a timeout, the Hypervisor
driver enters the internal error reset flow. In this flow, the driver
attempts to notify all slaves via the comm channel that an internal error
has occurred.

Since the comm channel has not yet been initialized (i.e., mapped via
ioremap), this will cause dereferencing a NULL pointer.

To fix this, do not access the comm channel in the internal error flow
if it has not yet been initialized.

Fixes: 55ad359225b2 ("net/mlx4_core: Enable device recovery flow with SRIOV")
Fixes: ab9c17a009ee ("mlx4_core: Modify driver initialization flow to accommodate SRIOV for Ethernet")
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/cmd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -2451,6 +2451,7 @@ err_comm_admin:
 	kfree(priv->mfunc.master.slave_state);
 err_comm:
 	iounmap(priv->mfunc.comm);
+	priv->mfunc.comm = NULL;
 err_vhcr:
 	dma_free_coherent(&dev->persist->pdev->dev, PAGE_SIZE,
 			  priv->mfunc.vhcr,
@@ -2518,6 +2519,13 @@ void mlx4_report_internal_err_comm_event
 	int slave;
 	u32 slave_read;
 
+	/* If the comm channel has not yet been initialized,
+	 * skip reporting the internal error event to all
+	 * the communication channels.
+	 */
+	if (!priv->mfunc.comm)
+		return;
+
 	/* Report an internal error event to all
 	 * communication channels.
 	 */
@@ -2552,6 +2560,7 @@ void mlx4_multi_func_cleanup(struct mlx4
 	}
 
 	iounmap(priv->mfunc.comm);
+	priv->mfunc.comm = NULL;
 }
 
 void mlx4_cmd_cleanup(struct mlx4_dev *dev, int cleanup_mask)


