Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AECC46AF01E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbjCGS3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbjCGS1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:27:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB127B1ECD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:20:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39A80614E8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53866C433EF;
        Tue,  7 Mar 2023 18:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213257;
        bh=YtKYInGt8VBTJB2alN4aCTeQ4DKlAicfnwsCC2NacNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zeav1yaqOYM+dfsrxXIUfateAHMdUUu8dOuwmqDLT1wCED3BpVYdvKDS4AStCYEt3
         ZdmAjTw71vEKpDWS/i7VPyJAataj/gfo+DmieoUEszFUm0WPy/CZjxckuiFhJslfZh
         P70Gi3MsDxyAtSAQiDwMJsUFCwNWh8JNIc+/9TVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ivan Bornyakov <i.bornyakov@metrotek.ru>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Xu Yilun <yilun.xu@intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 450/885] fpga: microchip-spi: rewrite status polling in a time measurable way
Date:   Tue,  7 Mar 2023 17:56:24 +0100
Message-Id: <20230307170022.033258659@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Bornyakov <i.bornyakov@metrotek.ru>

[ Upstream commit 88e705697e801299a13ecaf2ba54599964fe711c ]

Original busy loop with retries count in mpf_poll_status() is not too
reliable, as it takes different times on different systems. Replace it
with read_poll_timeout() macro.

While at it, fix polling stop condition to met function's original
intention declared in the comment. The issue with original polling stop
condition is that it stops if any of mask bits is set, while intention
was to stop if all mask bits is set. This was not noticible because only
MPF_STATUS_READY is passed as mask argument and it is BIT(1).

Fixes: 5f8d4a900830 ("fpga: microchip-spi: add Microchip MPF FPGA manager")
Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20221230092922.18822-3-i.bornyakov@metrotek.ru
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/microchip-spi.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/fpga/microchip-spi.c b/drivers/fpga/microchip-spi.c
index bb69f5beefe78..137fafdf57a6f 100644
--- a/drivers/fpga/microchip-spi.c
+++ b/drivers/fpga/microchip-spi.c
@@ -6,6 +6,7 @@
 #include <asm/unaligned.h>
 #include <linux/delay.h>
 #include <linux/fpga/fpga-mgr.h>
+#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/spi/spi.h>
@@ -33,7 +34,7 @@
 
 #define	MPF_BITS_PER_COMPONENT_SIZE	22
 
-#define	MPF_STATUS_POLL_RETRIES		10000
+#define	MPF_STATUS_POLL_TIMEOUT		(2 * USEC_PER_SEC)
 #define	MPF_STATUS_BUSY			BIT(0)
 #define	MPF_STATUS_READY		BIT(1)
 #define	MPF_STATUS_SPI_VIOLATION	BIT(2)
@@ -194,24 +195,25 @@ static int mpf_ops_parse_header(struct fpga_manager *mgr,
 	return 0;
 }
 
-/* Poll HW status until busy bit is cleared and mask bits are set. */
 static int mpf_poll_status(struct mpf_priv *priv, u8 mask)
 {
-	int status, retries = MPF_STATUS_POLL_RETRIES;
+	int ret, status;
 
-	while (retries--) {
-		status = mpf_read_status(priv);
-		if (status < 0)
-			return status;
-
-		if (status & MPF_STATUS_BUSY)
-			continue;
-
-		if (!mask || (status & mask))
-			return status;
-	}
+	/*
+	 * Busy poll HW status. Polling stops if any of the following
+	 * conditions are met:
+	 *  - timeout is reached
+	 *  - mpf_read_status() returns an error
+	 *  - busy bit is cleared AND mask bits are set
+	 */
+	ret = read_poll_timeout(mpf_read_status, status,
+				(status < 0) ||
+				((status & (MPF_STATUS_BUSY | mask)) == mask),
+				0, MPF_STATUS_POLL_TIMEOUT, false, priv);
+	if (ret < 0)
+		return ret;
 
-	return -EBUSY;
+	return status;
 }
 
 static int mpf_spi_write(struct mpf_priv *priv, const void *buf, size_t buf_size)
-- 
2.39.2



