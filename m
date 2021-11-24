Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BA945C19E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347096AbhKXNT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:19:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348923AbhKXNSD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:18:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97B1461153;
        Wed, 24 Nov 2021 12:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757948;
        bh=x5qcFKYOyOmWl07vopDKLv6ZhkVqNZinvRTiY4oCImw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2ElQffD3bF8wQiOo1TaIJtjMNyoB2V2lj6IyjhIZgHWWVpwR83/z2pf4Gk9HQ7mN
         bEWvCDJz71fI52dx+kHk+xeYZCB2IfnYbGufF2PrQYHobpbDv8WFC6wFcAy6U0uuJM
         +7PhSw+dfSJs6zLcS4oZezDg4mW04cTSi/K7Irew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 300/323] NFC: reorder the logic in nfc_{un,}register_device
Date:   Wed, 24 Nov 2021 12:58:10 +0100
Message-Id: <20211124115729.043646209@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 3e3b5dfcd16a3e254aab61bd1e8c417dd4503102 ]

There is a potential UAF between the unregistration routine and the NFC
netlink operations.

The race that cause that UAF can be shown as below:

 (FREE)                      |  (USE)
nfcmrvl_nci_unregister_dev   |  nfc_genl_dev_up
  nci_close_device           |
  nci_unregister_device      |    nfc_get_device
    nfc_unregister_device    |    nfc_dev_up
      rfkill_destory         |
      device_del             |      rfkill_blocked
  ...                        |    ...

The root cause for this race is concluded below:
1. The rfkill_blocked (USE) in nfc_dev_up is supposed to be placed after
the device_is_registered check.
2. Since the netlink operations are possible just after the device_add
in nfc_register_device, the nfc_dev_up() can happen anywhere during the
rfkill creation process, which leads to data race.

This patch reorder these actions to permit
1. Once device_del is finished, the nfc_dev_up cannot dereference the
rfkill object.
2. The rfkill_register need to be placed after the device_add of nfc_dev
because the parent device need to be created first. So this patch keeps
the order but inject device_lock to prevent the data race.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Fixes: be055b2f89b5 ("NFC: RFKILL support")
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20211116152652.19217-1-linma@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/core.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index 947a470f929d6..ff646d1758d16 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -106,13 +106,13 @@ int nfc_dev_up(struct nfc_dev *dev)
 
 	device_lock(&dev->dev);
 
-	if (dev->rfkill && rfkill_blocked(dev->rfkill)) {
-		rc = -ERFKILL;
+	if (!device_is_registered(&dev->dev)) {
+		rc = -ENODEV;
 		goto error;
 	}
 
-	if (!device_is_registered(&dev->dev)) {
-		rc = -ENODEV;
+	if (dev->rfkill && rfkill_blocked(dev->rfkill)) {
+		rc = -ERFKILL;
 		goto error;
 	}
 
@@ -1130,11 +1130,7 @@ int nfc_register_device(struct nfc_dev *dev)
 	if (rc)
 		pr_err("Could not register llcp device\n");
 
-	rc = nfc_genl_device_added(dev);
-	if (rc)
-		pr_debug("The userspace won't be notified that the device %s was added\n",
-			 dev_name(&dev->dev));
-
+	device_lock(&dev->dev);
 	dev->rfkill = rfkill_alloc(dev_name(&dev->dev), &dev->dev,
 				   RFKILL_TYPE_NFC, &nfc_rfkill_ops, dev);
 	if (dev->rfkill) {
@@ -1143,6 +1139,12 @@ int nfc_register_device(struct nfc_dev *dev)
 			dev->rfkill = NULL;
 		}
 	}
+	device_unlock(&dev->dev);
+
+	rc = nfc_genl_device_added(dev);
+	if (rc)
+		pr_debug("The userspace won't be notified that the device %s was added\n",
+			 dev_name(&dev->dev));
 
 	return 0;
 }
@@ -1159,10 +1161,17 @@ void nfc_unregister_device(struct nfc_dev *dev)
 
 	pr_debug("dev_name=%s\n", dev_name(&dev->dev));
 
+	rc = nfc_genl_device_removed(dev);
+	if (rc)
+		pr_debug("The userspace won't be notified that the device %s "
+			 "was removed\n", dev_name(&dev->dev));
+
+	device_lock(&dev->dev);
 	if (dev->rfkill) {
 		rfkill_unregister(dev->rfkill);
 		rfkill_destroy(dev->rfkill);
 	}
+	device_unlock(&dev->dev);
 
 	if (dev->ops->check_presence) {
 		device_lock(&dev->dev);
@@ -1172,11 +1181,6 @@ void nfc_unregister_device(struct nfc_dev *dev)
 		cancel_work_sync(&dev->check_pres_work);
 	}
 
-	rc = nfc_genl_device_removed(dev);
-	if (rc)
-		pr_debug("The userspace won't be notified that the device %s "
-			 "was removed\n", dev_name(&dev->dev));
-
 	nfc_llcp_unregister_device(dev);
 
 	mutex_lock(&nfc_devlist_mutex);
-- 
2.33.0



