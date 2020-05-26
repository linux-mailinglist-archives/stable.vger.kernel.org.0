Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6F91CAFF5
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgEHNWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728552AbgEHMjY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 641FB2495F;
        Fri,  8 May 2020 12:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941563;
        bh=tm9FGvjd0MyW71FzYD0zA/MVsERx+V3EhF8qLAKFV6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgiuAHgm3pCValh9+F23a6BRgileFIBiKOkEzYJHYLzP/ePn4ETJXf6rXiKoTP21W
         9RJC1AX8V2V6hpxCDW2seOOfPf+F0zcbkhf4racI25DM42nbig1jQY483rYbq7yfvT
         IeNI2s+IJrAFPU5rtwwJylKSEQbody9+QAe6Od4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jurgens <danielj@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 082/312] net/mlx5: Fix wait_vital for VFs and remove fixed sleep
Date:   Fri,  8 May 2020 14:31:13 +0200
Message-Id: <20200508123130.316606306@linuxfoundation.org>
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

From: Daniel Jurgens <danielj@mellanox.com>

commit d57847dc4177c6fd8d950cb533f5edf0eab45b11 upstream.

The device ID for VFs is in a different location than PFs. This results
in the poll always timing out for VFs. There's no good way to read the
VF device ID without using the PF's configuration space.  Switch to waiting
for the health poll to start incrementing. Also remove the 1s sleep
at the beginning.

fixes: 89d44f0a6c73 ('net/mlx5_core: Add pci error handlers to mlx5_core
driver')
Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 drivers/net/ethernet/mellanox/mlx5/core/main.c |   41 +++++++++----------------
 1 file changed, 15 insertions(+), 26 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1306,46 +1306,31 @@ void mlx5_disable_device(struct mlx5_cor
 	mlx5_pci_err_detected(dev->pdev, 0);
 }
 
-/* wait for the device to show vital signs. For now we check
- * that we can read the device ID and that the health buffer
- * shows a non zero value which is different than 0xffffffff
+/* wait for the device to show vital signs by waiting
+ * for the health counter to start counting.
  */
-static void wait_vital(struct pci_dev *pdev)
+static int wait_vital(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 	struct mlx5_core_health *health = &dev->priv.health;
 	const int niter = 100;
+	u32 last_count = 0;
 	u32 count;
-	u16 did;
 	int i;
 
-	/* Wait for firmware to be ready after reset */
-	msleep(1000);
-	for (i = 0; i < niter; i++) {
-		if (pci_read_config_word(pdev, 2, &did)) {
-			dev_warn(&pdev->dev, "failed reading config word\n");
-			break;
-		}
-		if (did == pdev->device) {
-			dev_info(&pdev->dev, "device ID correctly read after %d iterations\n", i);
-			break;
-		}
-		msleep(50);
-	}
-	if (i == niter)
-		dev_warn(&pdev->dev, "%s-%d: could not read device ID\n", __func__, __LINE__);
-
 	for (i = 0; i < niter; i++) {
 		count = ioread32be(health->health_counter);
 		if (count && count != 0xffffffff) {
-			dev_info(&pdev->dev, "Counter value 0x%x after %d iterations\n", count, i);
-			break;
+			if (last_count && last_count != count) {
+				dev_info(&pdev->dev, "Counter value 0x%x after %d iterations\n", count, i);
+				return 0;
+			}
+			last_count = count;
 		}
 		msleep(50);
 	}
 
-	if (i == niter)
-		dev_warn(&pdev->dev, "%s-%d: could not read device ID\n", __func__, __LINE__);
+	return -ETIMEDOUT;
 }
 
 static void mlx5_pci_resume(struct pci_dev *pdev)
@@ -1357,7 +1342,11 @@ static void mlx5_pci_resume(struct pci_d
 	dev_info(&pdev->dev, "%s was called\n", __func__);
 
 	pci_save_state(pdev);
-	wait_vital(pdev);
+	err = wait_vital(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "%s: wait_vital timed out\n", __func__);
+		return;
+	}
 
 	err = mlx5_load_one(dev, priv);
 	if (err)


