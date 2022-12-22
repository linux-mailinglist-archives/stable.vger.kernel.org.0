Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACC265478B
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 21:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiLVUxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 15:53:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiLVUxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 15:53:14 -0500
Received: from mailfilter02-out40.webhostingserver.nl (mailfilter02-out40.webhostingserver.nl [195.211.72.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2431C93E
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 12:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=exalondelft.nl; s=whs1;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=5qhayPKhfBfDxM0F+uRbZ4HQENiaq8XOO7xJH6gBv6g=;
        b=QSDzSMyXiXkIT2XfNUMGCDngq1KffMLlXc/Vp5DTxhMGzp0uElrvLombgdcXDnmtic8SteS08kZP9
         KShbF2USqJxxLOTuhx/DdwrqCGEQ+7mdHjJpn/n7UsDDCOLsZY5w40bFP1JuNzgrudZTRYey7vVTuf
         dpRtP7Kq+/SU7GdiUxJLlwUl13e0MozJF5Qw1Ygy/qe0ZFx8zXgrdaRvnYUyg84X/hm97fAeNDNplu
         DcBaM5LCQhbV8ZR1SULHNcsLzTH8BvKIR/i72+w5iYBR4bbHsvT3H7J79BPGAqF9+MsjBahgolP9f9
         3002f32NF29DFRCwshAqU1mHtlTxwHQ==
X-Halon-ID: a4057b1d-823a-11ed-ac07-001a4a4cb922
Received: from s198.webhostingserver.nl (s198.webhostingserver.nl [141.138.168.154])
        by mailfilter02.webhostingserver.nl (Halon) with ESMTPSA
        id a4057b1d-823a-11ed-ac07-001a4a4cb922;
        Thu, 22 Dec 2022 21:53:09 +0100 (CET)
Received: from 2a02-a466-68ed-1-86df-abe6-f3ae-663d.fixed6.kpn.net ([2a02:a466:68ed:1:86df:abe6:f3ae:663d] helo=delfion.fritz.box)
        by s198.webhostingserver.nl with esmtpa (Exim 4.96)
        (envelope-from <ftoth@exalondelft.nl>)
        id 1p8SYu-00Gils-2c;
        Thu, 22 Dec 2022 21:53:08 +0100
From:   Ferry Toth <ftoth@exalondelft.nl>
To:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Ferry Toth <fntoth@gmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ferry Toth <ftoth@exalondelft.nl>,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org
Subject: [PATCH v2 1/1] Revert "usb: ulpi: defer ulpi_register on ulpi_read_id timeout"
Date:   Thu, 22 Dec 2022 21:53:02 +0100
Message-Id: <20221222205302.45761-1-ftoth@exalondelft.nl>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 8a7b31d545d3a15f0e6f5984ae16f0ca4fd76aac.

This patch results in some qemu test failures, specifically xilinx-zynq-a9
machine and zynq-zc702 as well as zynq-zed devicetree files, when trying
to boot from USB drive.

Fixes: 8a7b31d545d3 ("usb: ulpi: defer ulpi_register on ulpi_read_id timeout")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/20221220194334.GA942039@roeck-us.net/
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
---
 drivers/usb/common/ulpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
index 60e8174686a1..d7c8461976ce 100644
--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -207,7 +207,7 @@ static int ulpi_read_id(struct ulpi *ulpi)
 	/* Test the interface */
 	ret = ulpi_write(ulpi, ULPI_SCRATCH, 0xaa);
 	if (ret < 0)
-		return ret;
+		goto err;
 
 	ret = ulpi_read(ulpi, ULPI_SCRATCH);
 	if (ret < 0)
-- 
2.37.2

