Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F6266C1E1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbjAPOP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbjAPOOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:14:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4459E2FCC4;
        Mon, 16 Jan 2023 06:05:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 298BD60FE6;
        Mon, 16 Jan 2023 14:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DB8C433F2;
        Mon, 16 Jan 2023 14:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877937;
        bh=wE8uk0FU4UXeaQkN4P+yBE4HMzTbuMhO9JXJf/AJ0IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRDrRO7kmGjf4IOMKj2OyynOlJlIyqwRjdJe86PpvzYhFz4c8hVOaMSuCwZDDS4NY
         XIsjEk1heckL6VAIZuXSyTm2gNZVKgw64zf3lft9JL9E6ocB+2j9PRoimmfKjB3U2j
         9YLgYhKr8yuFftj4aNDWgJn15DYu+xhAxGJg1rdfnoe31akScCfc4twgyY4hCJzire
         wQnzBYhOaqI3ZS1kRS7syb++hxBkqRGnGfe3TzQaZ9WSrtrxIZ5z4UwHoVGnFMAh97
         aSojZrQusYVod67o69Y9pqRovCtu4B7+axj4xqcrLLr0mRse2FM424H/1h3qyBCdgk
         zufmdeNLgP/FA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/16] spi: spidev: fix a race condition when accessing spidev->spi
Date:   Mon, 16 Jan 2023 09:05:12 -0500
Message-Id: <20230116140520.116257-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140520.116257-1-sashal@kernel.org>
References: <20230116140520.116257-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit a720416d94634068951773cb9e9d6f1b73769e5b ]

There's a spinlock in place that is taken in file_operations callbacks
whenever we check if spidev->spi is still alive (not null). It's also
taken when spidev->spi is set to NULL in remove().

This however doesn't protect the code against driver unbind event while
one of the syscalls is still in progress. To that end we need a lock taken
continuously as long as we may still access spidev->spi. As both the file
ops and the remove callback are never called from interrupt context, we
can replace the spinlock with a mutex.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20230106100719.196243-1-brgl@bgdev.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index be503a0e6ef7..a360dabdcb8b 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -66,7 +66,7 @@ static DECLARE_BITMAP(minors, N_SPI_MINORS);
 
 struct spidev_data {
 	dev_t			devt;
-	spinlock_t		spi_lock;
+	struct mutex		spi_lock;
 	struct spi_device	*spi;
 	struct list_head	device_entry;
 
@@ -93,9 +93,8 @@ spidev_sync(struct spidev_data *spidev, struct spi_message *message)
 	int status;
 	struct spi_device *spi;
 
-	spin_lock_irq(&spidev->spi_lock);
+	mutex_lock(&spidev->spi_lock);
 	spi = spidev->spi;
-	spin_unlock_irq(&spidev->spi_lock);
 
 	if (spi == NULL)
 		status = -ESHUTDOWN;
@@ -105,6 +104,7 @@ spidev_sync(struct spidev_data *spidev, struct spi_message *message)
 	if (status == 0)
 		status = message->actual_length;
 
+	mutex_unlock(&spidev->spi_lock);
 	return status;
 }
 
@@ -355,12 +355,12 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	 * we issue this ioctl.
 	 */
 	spidev = filp->private_data;
-	spin_lock_irq(&spidev->spi_lock);
+	mutex_lock(&spidev->spi_lock);
 	spi = spi_dev_get(spidev->spi);
-	spin_unlock_irq(&spidev->spi_lock);
-
-	if (spi == NULL)
+	if (spi == NULL) {
+		mutex_unlock(&spidev->spi_lock);
 		return -ESHUTDOWN;
+	}
 
 	/* use the buffer lock here for triple duty:
 	 *  - prevent I/O (from us) so calling spi_setup() is safe;
@@ -485,6 +485,7 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	mutex_unlock(&spidev->buf_lock);
 	spi_dev_put(spi);
+	mutex_unlock(&spidev->spi_lock);
 	return retval;
 }
 
@@ -506,12 +507,12 @@ spidev_compat_ioc_message(struct file *filp, unsigned int cmd,
 	 * we issue this ioctl.
 	 */
 	spidev = filp->private_data;
-	spin_lock_irq(&spidev->spi_lock);
+	mutex_lock(&spidev->spi_lock);
 	spi = spi_dev_get(spidev->spi);
-	spin_unlock_irq(&spidev->spi_lock);
-
-	if (spi == NULL)
+	if (spi == NULL) {
+		mutex_unlock(&spidev->spi_lock);
 		return -ESHUTDOWN;
+	}
 
 	/* SPI_IOC_MESSAGE needs the buffer locked "normally" */
 	mutex_lock(&spidev->buf_lock);
@@ -538,6 +539,7 @@ spidev_compat_ioc_message(struct file *filp, unsigned int cmd,
 done:
 	mutex_unlock(&spidev->buf_lock);
 	spi_dev_put(spi);
+	mutex_unlock(&spidev->spi_lock);
 	return retval;
 }
 
@@ -616,10 +618,10 @@ static int spidev_release(struct inode *inode, struct file *filp)
 	spidev = filp->private_data;
 	filp->private_data = NULL;
 
-	spin_lock_irq(&spidev->spi_lock);
+	mutex_lock(&spidev->spi_lock);
 	/* ... after we unbound from the underlying device? */
 	dofree = (spidev->spi == NULL);
-	spin_unlock_irq(&spidev->spi_lock);
+	mutex_unlock(&spidev->spi_lock);
 
 	/* last close? */
 	spidev->users--;
@@ -746,7 +748,7 @@ static int spidev_probe(struct spi_device *spi)
 
 	/* Initialize the driver data */
 	spidev->spi = spi;
-	spin_lock_init(&spidev->spi_lock);
+	mutex_init(&spidev->spi_lock);
 	mutex_init(&spidev->buf_lock);
 
 	INIT_LIST_HEAD(&spidev->device_entry);
@@ -791,9 +793,9 @@ static int spidev_remove(struct spi_device *spi)
 	/* prevent new opens */
 	mutex_lock(&device_list_lock);
 	/* make sure ops on existing fds can abort cleanly */
-	spin_lock_irq(&spidev->spi_lock);
+	mutex_lock(&spidev->spi_lock);
 	spidev->spi = NULL;
-	spin_unlock_irq(&spidev->spi_lock);
+	mutex_unlock(&spidev->spi_lock);
 
 	list_del(&spidev->device_entry);
 	device_destroy(spidev_class, spidev->devt);
-- 
2.35.1

