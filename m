Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7268F2118E2
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgGBB33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:29:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbgGBB1S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:27:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0255721473;
        Thu,  2 Jul 2020 01:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653237;
        bh=lY5i/G1xFnqXCzRAHXjROM97QoklifLMJB3E/TZuJmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPeoSEqGGt232TiWTXVWssCvtllVLh2UEsAK5+XtIvnDAsTtbLtRnilZAz1TaNwyH
         6mTsOxqCXjAaZPYHVfkkb56CZfhtAXGpbGmCZusyuAS2feuxnBfgw6lhA42fh1/oIm
         xoFcNjr2Zkdy8fUzeJ/RBVyhnsvLLxYqsm4Gbvrs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/13] spi: spidev: fix a race between spidev_release and spidev_remove
Date:   Wed,  1 Jul 2020 21:27:03 -0400
Message-Id: <20200702012712.2701986-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012712.2701986-1-sashal@kernel.org>
References: <20200702012712.2701986-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@gmail.com>

[ Upstream commit abd42781c3d2155868821f1b947ae45bbc33330d ]

Imagine below scene, spidev is referenced after it's freed.

spidev_release()                spidev_remove()
...
                                spin_lock_irq(&spidev->spi_lock);
                                    spidev->spi = NULL;
                                spin_unlock_irq(&spidev->spi_lock);
mutex_lock(&device_list_lock);
dofree = (spidev->spi == NULL);
if (dofree)
    kfree(spidev);
mutex_unlock(&device_list_lock);
                                mutex_lock(&device_list_lock);
                                list_del(&spidev->device_entry);
                                device_destroy(spidev_class, spidev->devt);
                                clear_bit(MINOR(spidev->devt), minors);
                                if (spidev->users == 0)
                                    kfree(spidev);
                                mutex_unlock(&device_list_lock);

Fix it by resetting spidev->spi in device_list_lock's protection.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
Link: https://lore.kernel.org/r/20200618032125.4650-1-zhenzhong.duan@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index a685c6114a8d5..67ad7e46da42d 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -809,13 +809,13 @@ static int spidev_remove(struct spi_device *spi)
 {
 	struct spidev_data	*spidev = spi_get_drvdata(spi);
 
+	/* prevent new opens */
+	mutex_lock(&device_list_lock);
 	/* make sure ops on existing fds can abort cleanly */
 	spin_lock_irq(&spidev->spi_lock);
 	spidev->spi = NULL;
 	spin_unlock_irq(&spidev->spi_lock);
 
-	/* prevent new opens */
-	mutex_lock(&device_list_lock);
 	list_del(&spidev->device_entry);
 	device_destroy(spidev_class, spidev->devt);
 	clear_bit(MINOR(spidev->devt), minors);
-- 
2.25.1

