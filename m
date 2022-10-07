Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FB65F746D
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 08:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiJGG4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 02:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiJGG4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 02:56:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AD7A3F63
        for <stable@vger.kernel.org>; Thu,  6 Oct 2022 23:56:37 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1oghHc-0000xc-U9; Fri, 07 Oct 2022 08:56:32 +0200
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1oghHc-0003F6-5l; Fri, 07 Oct 2022 08:56:32 +0200
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1oghHb-0096Ut-IG; Fri, 07 Oct 2022 08:56:31 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-pci@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org
Subject: [PATCH] PCI/sysfs: Fix double free in error path
Date:   Fri,  7 Oct 2022 08:56:18 +0200
Message-Id: <20221007065618.2169880-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When pci_create_attr() fails then pci_remove_resource_files() is called
which will iterate over the res_attr[_wc] arrays and frees every non
NULL entry. To avoid a double free here we have to set the failed entry
to NULL in pci_create_attr() when freeing it.

Fixes: b562ec8f74e4 ("PCI: Don't leak memory if sysfs_create_bin_file() fails")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: <stable@vger.kernel.org>
---
 drivers/pci/pci-sysfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index fc804e08e3cb5..a07381d46ddae 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1196,8 +1196,13 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 	res_attr->size = pci_resource_len(pdev, num);
 	res_attr->private = (void *)(unsigned long)num;
 	retval = sysfs_create_bin_file(&pdev->dev.kobj, res_attr);
-	if (retval)
+	if (retval) {
+		if (write_combine)
+			pdev->res_attr_wc[num] = NULL;
+		else
+			pdev->res_attr[num] = NULL;
 		kfree(res_attr);
+	}
 
 	return retval;
 }
-- 
2.30.2

