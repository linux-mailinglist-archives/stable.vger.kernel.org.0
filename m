Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C9C148242
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388632AbgAXL0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:26:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391545AbgAXL0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:26:32 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93BAD20718;
        Fri, 24 Jan 2020 11:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865191;
        bh=lwaYhIzhG7iXIAFaL3oOOSvXFQlcES0ttMPN/K7OsOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Arf4MdadvadLqYrH3S1+hLo+Gp/0KayjIgT02g2wqxhq/vqYMz8G3Uid72rz5ykAn
         MXyKIvSKEdmf/2r53HXOC1kwUlpO96J2UpVuwwWbeFTa0ERUwYmo2Bi6np5x4yxUu1
         dVepl84fhgBP3CGS0fKAbv2+B4cJoQUqUFyiKIuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lei YU <mine260309@gmail.com>,
        John Wang <wangzqbj@inspur.com>, Jeremy Kerr <jk@ozlabs.org>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 465/639] fsi/core: Fix error paths on CFAM init
Date:   Fri, 24 Jan 2020 10:30:35 +0100
Message-Id: <20200124093145.474957094@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c6fa9b393e84b..bd62236d3f975 100644
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



