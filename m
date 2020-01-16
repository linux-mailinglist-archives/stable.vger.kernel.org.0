Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3E113F454
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389066AbgAPRJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:09:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389385AbgAPRJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BFFC21D56;
        Thu, 16 Jan 2020 17:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194574;
        bh=LRE46spzsK1yi2Y1AgFPyTpW5VLwK4ZFCsLOMK/Y3gY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5glCQDZbUWFc0bC+2n1ezx0QLFlU2Ogva5eUPFawCGs3sNOLXrIeTAZxayA3gcxb
         mQgICiYLkE9kPMl7G3nfreGM/RmWqbchmQOc4DBK8H6737ddxkayM/gmUZx2C67Sy6
         d+UfD1tAh+ovxmR2KusB6xPlHas5Qei7zcDniOGs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeremy Kerr <jk@ozlabs.org>, Lei YU <mine260309@gmail.com>,
        John Wang <wangzqbj@inspur.com>, Joel Stanley <joel@jms.id.au>,
        Sasha Levin <sashal@kernel.org>, linux-fsi@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 450/671] fsi/core: Fix error paths on CFAM init
Date:   Thu, 16 Jan 2020 12:01:28 -0500
Message-Id: <20200116170509.12787-187-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Kerr <jk@ozlabs.org>

[ Upstream commit 371975b0b07520c85098652d561639837a60a905 ]

Change d1dcd67825 re-worked the struct fsi_slave initialisation in
fsi_slave_init, but introduced a few inconsitencies: the slave->dev is
now registered through cdev_device_add, but we may kfree() the device
out from underneath the cdev registration. We may also leave an IDA
allocated.

This change fixes the error paths, so that we kfree() only before the
device is registered with the core code. We also move the smode write to
before we start creating proper devices, as it's the most likely to
fail. We also remove the IDA-allocated minor on error, and properly
clean up the of_node.

Fixes: d1dcd6782576 ("fsi: Add cfam char devices")
Reported-by: Lei YU <mine260309@gmail.com>
Tested-by: John Wang <wangzqbj@inspur.com>
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-core.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/fsi/fsi-core.c b/drivers/fsi/fsi-core.c
index c6fa9b393e84..bd62236d3f97 100644
--- a/drivers/fsi/fsi-core.c
+++ b/drivers/fsi/fsi-core.c
@@ -1060,6 +1060,14 @@ static int fsi_slave_init(struct fsi_master *master, int link, uint8_t id)
 
 	}
 
+	rc = fsi_slave_set_smode(slave);
+	if (rc) {
+		dev_warn(&master->dev,
+				"can't set smode on slave:%02x:%02x %d\n",
+				link, id, rc);
+		goto err_free;
+	}
+
 	/* Allocate a minor in the FSI space */
 	rc = __fsi_get_new_minor(slave, fsi_dev_cfam, &slave->dev.devt,
 				 &slave->cdev_idx);
@@ -1071,17 +1079,14 @@ static int fsi_slave_init(struct fsi_master *master, int link, uint8_t id)
 	rc = cdev_device_add(&slave->cdev, &slave->dev);
 	if (rc) {
 		dev_err(&slave->dev, "Error %d creating slave device\n", rc);
-		goto err_free;
+		goto err_free_ida;
 	}
 
-	rc = fsi_slave_set_smode(slave);
-	if (rc) {
-		dev_warn(&master->dev,
-				"can't set smode on slave:%02x:%02x %d\n",
-				link, id, rc);
-		kfree(slave);
-		return -ENODEV;
-	}
+	/* Now that we have the cdev registered with the core, any fatal
+	 * failures beyond this point will need to clean up through
+	 * cdev_device_del(). Fortunately though, nothing past here is fatal.
+	 */
+
 	if (master->link_config)
 		master->link_config(master, link,
 				    slave->t_send_delay,
@@ -1098,10 +1103,13 @@ static int fsi_slave_init(struct fsi_master *master, int link, uint8_t id)
 		dev_dbg(&master->dev, "failed during slave scan with: %d\n",
 				rc);
 
-	return rc;
+	return 0;
 
- err_free:
-	put_device(&slave->dev);
+err_free_ida:
+	fsi_free_minor(slave->dev.devt);
+err_free:
+	of_node_put(slave->dev.of_node);
+	kfree(slave);
 	return rc;
 }
 
-- 
2.20.1

