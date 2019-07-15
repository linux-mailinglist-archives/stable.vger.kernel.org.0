Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8926963E
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731240AbfGOPDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 11:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388262AbfGOOKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:10:22 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB7C720868;
        Mon, 15 Jul 2019 14:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199821;
        bh=vcGn3ElHcdimtT8hx9eq+HzmedGg7CPrXqHkCAf/oPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRQICuuvFXB/MTdwXfQLDXEpSi58RjFBmGTjjvfcFQkcprxJms7Mhi9476OIp56O6
         o6QYvWyEWTqngQrNXoY/SeCDX22vlyJPdSJjsh9+YstB8izovULxOtfY/N/EExNPdP
         9PeuA3iBxN7YDlTA6nULpAM69ow71D/WwL9Xru+U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg KH <gregkh@linuxfoundation.org>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 116/219] EDAC/sysfs: Drop device references properly
Date:   Mon, 15 Jul 2019 10:01:57 -0400
Message-Id: <20190715140341.6443-116-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

[ Upstream commit 7adc05d2dc3af95e4e1534841d58f736262142cd ]

Do put_device() if device_add() fails.

 [ bp: do device_del() for the successfully created devices in
   edac_create_csrow_objects(), on the unwind path. ]

Signed-off-by: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20190427214925.GE16338@kroah.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/edac_mc_sysfs.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 464174685589..bf9273437e3f 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -443,7 +443,8 @@ static int edac_create_csrow_objects(struct mem_ctl_info *mci)
 		csrow = mci->csrows[i];
 		if (!nr_pages_per_csrow(csrow))
 			continue;
-		put_device(&mci->csrows[i]->dev);
+
+		device_del(&mci->csrows[i]->dev);
 	}
 
 	return err;
@@ -645,9 +646,11 @@ static int edac_create_dimm_object(struct mem_ctl_info *mci,
 	dev_set_drvdata(&dimm->dev, dimm);
 	pm_runtime_forbid(&mci->dev);
 
-	err =  device_add(&dimm->dev);
+	err = device_add(&dimm->dev);
+	if (err)
+		put_device(&dimm->dev);
 
-	edac_dbg(0, "creating rank/dimm device %s\n", dev_name(&dimm->dev));
+	edac_dbg(0, "created rank/dimm device %s\n", dev_name(&dimm->dev));
 
 	return err;
 }
@@ -928,6 +931,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci,
 	err = device_add(&mci->dev);
 	if (err < 0) {
 		edac_dbg(1, "failure: create device %s\n", dev_name(&mci->dev));
+		put_device(&mci->dev);
 		goto out;
 	}
 
-- 
2.20.1

