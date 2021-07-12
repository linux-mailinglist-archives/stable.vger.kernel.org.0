Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F863C44CB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbhGLGV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234252AbhGLGUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:20:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 647AC61107;
        Mon, 12 Jul 2021 06:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070675;
        bh=+0RmVVSDzLNt2nkptVlfGz2MqVzeDxn8hiCZHkPC86c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4qKT6nVfCQFjOiCgOsuBLPdZ0s5oS0rnHX9849rKOQzGs9411ON2UePKl6Oze+UW
         4oFGqEoe+psBGO1XgO4+D2NQZKu3xUt9CXGdqNpfZqeuyWIZpTcglRNGmrd71douHK
         MfS6Y0pqjKvniaafWWqMYYQxA8Lj8P3OBkdjiFk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/348] memstick: rtsx_usb_ms: fix UAF
Date:   Mon, 12 Jul 2021 08:07:56 +0200
Message-Id: <20210712060713.946521111@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 42933c8aa14be1caa9eda41f65cde8a3a95d3e39 ]

This patch fixes the following issues:
1. memstick_free_host() will free the host, so the use of ms_dev(host) after
it will be a problem. To fix this, move memstick_free_host() after when we
are done with ms_dev(host).
2. In rtsx_usb_ms_drv_remove(), pm need to be disabled before we remove
and free host otherwise memstick_check will be called and UAF will
happen.

[   11.351173] BUG: KASAN: use-after-free in rtsx_usb_ms_drv_remove+0x94/0x140 [rtsx_usb_ms]
[   11.357077]  rtsx_usb_ms_drv_remove+0x94/0x140 [rtsx_usb_ms]
[   11.357376]  platform_remove+0x2a/0x50
[   11.367531] Freed by task 298:
[   11.368537]  kfree+0xa4/0x2a0
[   11.368711]  device_release+0x51/0xe0
[   11.368905]  kobject_put+0xa2/0x120
[   11.369090]  rtsx_usb_ms_drv_remove+0x8c/0x140 [rtsx_usb_ms]
[   11.369386]  platform_remove+0x2a/0x50

[   12.038408] BUG: KASAN: use-after-free in __mutex_lock.isra.0+0x3ec/0x7c0
[   12.045432]  mutex_lock+0xc9/0xd0
[   12.046080]  memstick_check+0x6a/0x578 [memstick]
[   12.046509]  process_one_work+0x46d/0x750
[   12.052107] Freed by task 297:
[   12.053115]  kfree+0xa4/0x2a0
[   12.053272]  device_release+0x51/0xe0
[   12.053463]  kobject_put+0xa2/0x120
[   12.053647]  rtsx_usb_ms_drv_remove+0xc4/0x140 [rtsx_usb_ms]
[   12.053939]  platform_remove+0x2a/0x50

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Co-developed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20210511163944.1233295-1-ztong0001@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/host/rtsx_usb_ms.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/memstick/host/rtsx_usb_ms.c b/drivers/memstick/host/rtsx_usb_ms.c
index 102dbb8080da..29271ad4728a 100644
--- a/drivers/memstick/host/rtsx_usb_ms.c
+++ b/drivers/memstick/host/rtsx_usb_ms.c
@@ -799,9 +799,9 @@ static int rtsx_usb_ms_drv_probe(struct platform_device *pdev)
 
 	return 0;
 err_out:
-	memstick_free_host(msh);
 	pm_runtime_disable(ms_dev(host));
 	pm_runtime_put_noidle(ms_dev(host));
+	memstick_free_host(msh);
 	return err;
 }
 
@@ -828,9 +828,6 @@ static int rtsx_usb_ms_drv_remove(struct platform_device *pdev)
 	}
 	mutex_unlock(&host->host_mutex);
 
-	memstick_remove_host(msh);
-	memstick_free_host(msh);
-
 	/* Balance possible unbalanced usage count
 	 * e.g. unconditional module removal
 	 */
@@ -838,10 +835,11 @@ static int rtsx_usb_ms_drv_remove(struct platform_device *pdev)
 		pm_runtime_put(ms_dev(host));
 
 	pm_runtime_disable(ms_dev(host));
-	platform_set_drvdata(pdev, NULL);
-
+	memstick_remove_host(msh);
 	dev_dbg(ms_dev(host),
 		": Realtek USB Memstick controller has been removed\n");
+	memstick_free_host(msh);
+	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
2.30.2



