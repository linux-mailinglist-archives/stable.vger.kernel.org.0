Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B860827C62B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbgI2Lm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730708AbgI2LmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:42:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2B9D2065C;
        Tue, 29 Sep 2020 11:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379743;
        bh=t/dL6LPjtS1TrQtU8/Vc04Fb463C66wB6aGtkDlVgYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIg1eYmA8po4u0pjhVVA12S7OYduYutXw42Cpj8IVoG11hGcgBBbDsDR0VLxebH+V
         j7hz6ChObcp3ATGipgqxaWxNO00iuxnjqxjST9ksigIlOa8wNCmgXl8qsxZoVKPECy
         UnHgiR12bj0qiF43ncUq3rQNqCN4lORHhP6CDxPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ira Weiny <ira.weiny@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Pavel Andrianov <andrianov@ispras.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 299/388] rapidio: avoid data race between file operation callbacks and mport_cdev_add().
Date:   Tue, 29 Sep 2020 13:00:30 +0200
Message-Id: <20200929110024.937751965@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit e1c3cdb26ab881b77486dc50370356a349077c74 ]

Fields of md(mport_dev) are set after cdev_device_add().  However, the
file operation callbacks can be called after cdev_device_add() and
therefore accesses to fields of md in the callbacks can race with the rest
of the mport_cdev_add() function.

One such example is INIT_LIST_HEAD(&md->portwrites) in mport_cdev_add(),
the list is initialised after cdev_device_add().  This can race with
list_add_tail(&pw_filter->md_node,&md->portwrites) in
rio_mport_add_pw_filter() which is called by unlocked_ioctl.

To avoid such data races use cdev_device_add() after initializing md.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Allison Randal <allison@lohutok.net>
Cc: Pavel Andrianov <andrianov@ispras.ru>
Link: http://lkml.kernel.org/r/20200426112950.1803-1-madhuparnabhowmik10@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index 10af330153b5e..0b85a80ae7ef6 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -2384,13 +2384,6 @@ static struct mport_dev *mport_cdev_add(struct rio_mport *mport)
 	cdev_init(&md->cdev, &mport_fops);
 	md->cdev.owner = THIS_MODULE;
 
-	ret = cdev_device_add(&md->cdev, &md->dev);
-	if (ret) {
-		rmcd_error("Failed to register mport %d (err=%d)",
-		       mport->id, ret);
-		goto err_cdev;
-	}
-
 	INIT_LIST_HEAD(&md->doorbells);
 	spin_lock_init(&md->db_lock);
 	INIT_LIST_HEAD(&md->portwrites);
@@ -2410,6 +2403,13 @@ static struct mport_dev *mport_cdev_add(struct rio_mport *mport)
 #else
 	md->properties.transfer_mode |= RIO_TRANSFER_MODE_TRANSFER;
 #endif
+
+	ret = cdev_device_add(&md->cdev, &md->dev);
+	if (ret) {
+		rmcd_error("Failed to register mport %d (err=%d)",
+		       mport->id, ret);
+		goto err_cdev;
+	}
 	ret = rio_query_mport(mport, &attr);
 	if (!ret) {
 		md->properties.flags = attr.flags;
-- 
2.25.1



