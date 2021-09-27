Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBAB4419AE6
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbhI0ROh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235903AbhI0RLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:11:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8454D61260;
        Mon, 27 Sep 2021 17:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762505;
        bh=gbg0rutphFkZs8yPTvbw04awPgPi4s4f/mRCFXZpLXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqntMWexF5Bu8WpCq5Xx+XhwIxjJzgcR3YQnVasEsv/AntCPEsh1AWp5YGn+jn2Sj
         pRpNZxySLG3gQf247scIWTPFvit2wtYcU1MaIZcXvivq506MKOj5meWesNSnvdQibO
         qPlyzfFORDP4f9omLqNkMOkvTfM0XfYSghV2amJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/103] s390/qeth: fix deadlock during failing recovery
Date:   Mon, 27 Sep 2021 19:02:20 +0200
Message-Id: <20210927170227.414776158@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit d2b59bd4b06d84a4eadb520b0f71c62fe8ec0a62 ]

Commit 0b9902c1fcc5 ("s390/qeth: fix deadlock during recovery") removed
taking discipline_mutex inside qeth_do_reset(), fixing potential
deadlocks. An error path was missed though, that still takes
discipline_mutex and thus has the original deadlock potential.

Intermittent deadlocks were seen when a qeth channel path is configured
offline, causing a race between qeth_do_reset and ccwgroup_remove.
Call qeth_set_offline() directly in the qeth_do_reset() error case and
then a new variant of ccwgroup_set_offline(), without taking
discipline_mutex.

Fixes: b41b554c1ee7 ("s390/qeth: fix locking for discipline setup / removal")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/ccwgroup.h  |  2 +-
 drivers/s390/cio/ccwgroup.c       | 10 ++++++++--
 drivers/s390/net/qeth_core_main.c |  3 ++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/ccwgroup.h b/arch/s390/include/asm/ccwgroup.h
index ad3acb1e882b..8a22da9a735a 100644
--- a/arch/s390/include/asm/ccwgroup.h
+++ b/arch/s390/include/asm/ccwgroup.h
@@ -58,7 +58,7 @@ struct ccwgroup_device *get_ccwgroupdev_by_busid(struct ccwgroup_driver *gdrv,
 						 char *bus_id);
 
 extern int ccwgroup_set_online(struct ccwgroup_device *gdev);
-extern int ccwgroup_set_offline(struct ccwgroup_device *gdev);
+int ccwgroup_set_offline(struct ccwgroup_device *gdev, bool call_gdrv);
 
 extern int ccwgroup_probe_ccwdev(struct ccw_device *cdev);
 extern void ccwgroup_remove_ccwdev(struct ccw_device *cdev);
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 483a9ecfcbb1..cfdc1c7825d0 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -98,12 +98,13 @@ EXPORT_SYMBOL(ccwgroup_set_online);
 /**
  * ccwgroup_set_offline() - disable a ccwgroup device
  * @gdev: target ccwgroup device
+ * @call_gdrv: Call the registered gdrv set_offline function
  *
  * This function attempts to put the ccwgroup device into the offline state.
  * Returns:
  *  %0 on success and a negative error value on failure.
  */
-int ccwgroup_set_offline(struct ccwgroup_device *gdev)
+int ccwgroup_set_offline(struct ccwgroup_device *gdev, bool call_gdrv)
 {
 	struct ccwgroup_driver *gdrv = to_ccwgroupdrv(gdev->dev.driver);
 	int ret = -EINVAL;
@@ -112,11 +113,16 @@ int ccwgroup_set_offline(struct ccwgroup_device *gdev)
 		return -EAGAIN;
 	if (gdev->state == CCWGROUP_OFFLINE)
 		goto out;
+	if (!call_gdrv) {
+		ret = 0;
+		goto offline;
+	}
 	if (gdrv->set_offline)
 		ret = gdrv->set_offline(gdev);
 	if (ret)
 		goto out;
 
+offline:
 	gdev->state = CCWGROUP_OFFLINE;
 out:
 	atomic_set(&gdev->onoff, 0);
@@ -145,7 +151,7 @@ static ssize_t ccwgroup_online_store(struct device *dev,
 	if (value == 1)
 		ret = ccwgroup_set_online(gdev);
 	else if (value == 0)
-		ret = ccwgroup_set_offline(gdev);
+		ret = ccwgroup_set_offline(gdev, true);
 	else
 		ret = -EINVAL;
 out:
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 7b0155b0e99e..15477bfb5bd8 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5406,7 +5406,8 @@ static int qeth_do_reset(void *data)
 		dev_info(&card->gdev->dev,
 			 "Device successfully recovered!\n");
 	} else {
-		ccwgroup_set_offline(card->gdev);
+		qeth_set_offline(card, disc, true);
+		ccwgroup_set_offline(card->gdev, false);
 		dev_warn(&card->gdev->dev,
 			 "The qeth device driver failed to recover an error on the device\n");
 	}
-- 
2.33.0



