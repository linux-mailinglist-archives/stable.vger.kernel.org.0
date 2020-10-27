Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789BC29B89C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368892AbgJ0PmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800530AbgJ0Pg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:36:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D0D422282;
        Tue, 27 Oct 2020 15:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812985;
        bh=EG7xkLK5RvfqEIedMaeojofnrNqdn+++hd7xuiN/faw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V10jfGFn6kf5zkhvZRmhw3GdENizvPYclsASZwDvsZFCoGUCBfnT8KRepgtw2rNA/
         1jEED/GKT2z78wbb0sk9qNO0w/1qbn3i3alBooZU9y4u/JVrsMDTPTCqvpxw9jRT8N
         epnVn0fOtqAKSE8eyc1r7wFhUT6ebaLlF/uOeA4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parshuram Thombare <pthombar@cadence.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 398/757] i3c: master add i3c_master_attach_boardinfo to preserve boardinfo
Date:   Tue, 27 Oct 2020 14:50:48 +0100
Message-Id: <20201027135509.243540092@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parshuram Thombare <pthombar@cadence.com>

[ Upstream commit 9da36a7ec42135428e1d41621e3703429bda3b2e ]

Boardinfo was lost if I3C object for devices with boardinfo
available are not created or not added to the I3C device list
because of some failure e.g. SETDASA failed, retrieve info failed etc
This patch adds i3c_master_attach_boardinfo which scan boardinfo list
in the master object and 'attach' it to the I3C device object.

Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://lore.kernel.org/linux-i3c/1590053542-389-1-git-send-email-pthombar@cadence.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 97f2e29265da7..cc7564446ccd2 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1782,6 +1782,21 @@ static void i3c_master_bus_cleanup(struct i3c_master_controller *master)
 	i3c_master_detach_free_devs(master);
 }
 
+static void i3c_master_attach_boardinfo(struct i3c_dev_desc *i3cdev)
+{
+	struct i3c_master_controller *master = i3cdev->common.master;
+	struct i3c_dev_boardinfo *i3cboardinfo;
+
+	list_for_each_entry(i3cboardinfo, &master->boardinfo.i3c, node) {
+		if (i3cdev->info.pid != i3cboardinfo->pid)
+			continue;
+
+		i3cdev->boardinfo = i3cboardinfo;
+		i3cdev->info.static_addr = i3cboardinfo->static_addr;
+		return;
+	}
+}
+
 static struct i3c_dev_desc *
 i3c_master_search_i3c_dev_duplicate(struct i3c_dev_desc *refdev)
 {
@@ -1837,10 +1852,10 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
 	if (ret)
 		goto err_detach_dev;
 
+	i3c_master_attach_boardinfo(newdev);
+
 	olddev = i3c_master_search_i3c_dev_duplicate(newdev);
 	if (olddev) {
-		newdev->boardinfo = olddev->boardinfo;
-		newdev->info.static_addr = olddev->info.static_addr;
 		newdev->dev = olddev->dev;
 		if (newdev->dev)
 			newdev->dev->desc = newdev;
-- 
2.25.1



