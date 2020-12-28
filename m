Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7F22E3ABA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391435AbgL1Nkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:40:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:41100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404013AbgL1Nky (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:40:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02BA0206ED;
        Mon, 28 Dec 2020 13:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162813;
        bh=gSaJ9OYw+rLN/FdFRZGTrXrv3BYNoJ5UpwK5HWWzMSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqjrsHHp4XeTDQqVFIFZR1akJgFGcCrNbBFqfb+LaVw48JOkRgXvGbFfidwDY0LxD
         8W9exgE7NKt7zIjS+NaS9j/+gfVnD5QjKGdNGXFYzdeqRoWsBVxNPyBs/ChEjYkvAZ
         eWqZyqvP7g49lAxsZtUCHm1hUJGtYOkisdBbL5fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/453] habanalabs: put devices before driver removal
Date:   Mon, 28 Dec 2020 13:44:36 +0100
Message-Id: <20201228124939.187128286@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit 5555b7c56bdec7a29c789fec27f84d40f52fbdfa ]

Driver never puts its device and control_device objects, hence
a memory leak is introduced every driver removal.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/device.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/habanalabs/device.c b/drivers/misc/habanalabs/device.c
index a7a4fed4d8995..3eeb1920ddb43 100644
--- a/drivers/misc/habanalabs/device.c
+++ b/drivers/misc/habanalabs/device.c
@@ -229,16 +229,16 @@ static int device_cdev_sysfs_add(struct hl_device *hdev)
 
 static void device_cdev_sysfs_del(struct hl_device *hdev)
 {
-	/* device_release() won't be called so must free devices explicitly */
-	if (!hdev->cdev_sysfs_created) {
-		kfree(hdev->dev_ctrl);
-		kfree(hdev->dev);
-		return;
-	}
+	if (!hdev->cdev_sysfs_created)
+		goto put_devices;
 
 	hl_sysfs_fini(hdev);
 	cdev_device_del(&hdev->cdev_ctrl, hdev->dev_ctrl);
 	cdev_device_del(&hdev->cdev, hdev->dev);
+
+put_devices:
+	put_device(hdev->dev);
+	put_device(hdev->dev_ctrl);
 }
 
 /*
@@ -1285,9 +1285,9 @@ int hl_device_init(struct hl_device *hdev, struct class *hclass)
 early_fini:
 	device_early_fini(hdev);
 free_dev_ctrl:
-	kfree(hdev->dev_ctrl);
+	put_device(hdev->dev_ctrl);
 free_dev:
-	kfree(hdev->dev);
+	put_device(hdev->dev);
 out_disabled:
 	hdev->disabled = true;
 	if (add_cdev_sysfs_on_err)
-- 
2.27.0



