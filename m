Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150DC657C1B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbiL1P24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbiL1P2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:28:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5809714D38
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:28:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5AE661551
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35B2C433D2;
        Wed, 28 Dec 2022 15:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241333;
        bh=41plOrEQaanX3DeAZoPV8kY/RXcc+grIgxlQxmVwa24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWQ4D+PHwHewUMK/8oekTpTgOxo5LAFw9Bg1m7KIQZL7O/tyOF3OoV1n/QwuL1xs/
         SjaHL2mHnuGCHQXKm/msNf7/b7feuCPnjwc65WXYLFoEOMLymQzlh09Z2KDpKXqXWt
         8aJSv37JKTslQLjPpow0mCqHLn2ImWD3hM9z8xSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Donnellan <ajd@linux.ibm.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 467/731] ocxl: fix pci device refcount leak when calling get_function_0()
Date:   Wed, 28 Dec 2022 15:39:34 +0100
Message-Id: <20221228144310.085312191@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 27158c72678b39ee01cc01de1aba6b51c71abe2f ]

get_function_0() calls pci_get_domain_bus_and_slot(), as comment
says, it returns a pci device with refcount increment, so after
using it, pci_dev_put() needs be called.

Get the device reference when get_function_0() is not called, so
pci_dev_put() can be called in the error path and callers
unconditionally. And add comment above get_dvsec_vendor0() to tell
callers to call pci_dev_put().

Fixes: 87db7579ebd5 ("ocxl: control via sysfs whether the FPGA is reloaded on a link reset")
Suggested-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Andrew Donnellan <ajd@linux.ibm.com>
Link: https://lore.kernel.org/r/20221121154339.4088935-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ocxl/config.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/ocxl/config.c b/drivers/misc/ocxl/config.c
index a68738f38252..f1f669efe050 100644
--- a/drivers/misc/ocxl/config.c
+++ b/drivers/misc/ocxl/config.c
@@ -204,6 +204,18 @@ static int read_dvsec_vendor(struct pci_dev *dev)
 	return 0;
 }
 
+/**
+ * get_dvsec_vendor0() - Find a related PCI device (function 0)
+ * @dev: PCI device to match
+ * @dev0: The PCI device (function 0) found
+ * @out_pos: The position of PCI device (function 0)
+ *
+ * Returns 0 on success, negative on failure.
+ *
+ * NOTE: If it's successful, the reference of dev0 is increased,
+ * so after using it, the callers must call pci_dev_put() to give
+ * up the reference.
+ */
 static int get_dvsec_vendor0(struct pci_dev *dev, struct pci_dev **dev0,
 			     int *out_pos)
 {
@@ -213,10 +225,14 @@ static int get_dvsec_vendor0(struct pci_dev *dev, struct pci_dev **dev0,
 		dev = get_function_0(dev);
 		if (!dev)
 			return -1;
+	} else {
+		dev = pci_dev_get(dev);
 	}
 	pos = find_dvsec(dev, OCXL_DVSEC_VENDOR_ID);
-	if (!pos)
+	if (!pos) {
+		pci_dev_put(dev);
 		return -1;
+	}
 	*dev0 = dev;
 	*out_pos = pos;
 	return 0;
@@ -233,6 +249,7 @@ int ocxl_config_get_reset_reload(struct pci_dev *dev, int *val)
 
 	pci_read_config_dword(dev0, pos + OCXL_DVSEC_VENDOR_RESET_RELOAD,
 			      &reset_reload);
+	pci_dev_put(dev0);
 	*val = !!(reset_reload & BIT(0));
 	return 0;
 }
@@ -254,6 +271,7 @@ int ocxl_config_set_reset_reload(struct pci_dev *dev, int val)
 		reset_reload &= ~BIT(0);
 	pci_write_config_dword(dev0, pos + OCXL_DVSEC_VENDOR_RESET_RELOAD,
 			       reset_reload);
+	pci_dev_put(dev0);
 	return 0;
 }
 
-- 
2.35.1



