Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D43A653776
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 21:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbiLUUSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 15:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiLUUSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 15:18:47 -0500
Received: from mailfilter05-out40.webhostingserver.nl (mailfilter05-out40.webhostingserver.nl [195.211.74.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A741EC45
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 12:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=exalondelft.nl; s=whs1;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=pWO3hqi+QAixwpdeI1+jy7duJrkYMUdLerm7qfnV53A=;
        b=bt4Sry3aTw0lf00bXdiWU63WNWX2xULSlnLeoMlYGJgIUrA0UaELJreJBK7qG0rqme9vHQccu0DoQ
         8d3jK+pqdJdDihGPzjRg4FlbGmDFRo7y3oT5vU/K7Dkd5ui7thxDwpTQOSR2xRnPpbzp8I8FQNCspe
         hj0dFvmoyiD65Vr2SZ3fTiI1QsZTL/sYxq5Xh8YQr/iK9AMKfK/gXygUtgotOmBL+zuuI6gf9DU7ET
         SfZZLnuV3uYR/e5rT+4J2382bjF+8WdY28g1ypON7S585DxzeBsvzts5se2S7rpdADrzVsXtn7p/6N
         61PBJ40+gS6dIWvhLrArPQBZxs30OFw==
X-Halon-ID: e54b552b-816b-11ed-936b-001a4a4cb933
Received: from s198.webhostingserver.nl (s198.webhostingserver.nl [141.138.168.154])
        by mailfilter05.webhostingserver.nl (Halon) with ESMTPSA
        id e54b552b-816b-11ed-936b-001a4a4cb933;
        Wed, 21 Dec 2022 21:13:12 +0100 (CET)
Received: from 2a02-a466-68ed-1-b319-6467-c1bf-a947.fixed6.kpn.net ([2a02:a466:68ed:1:b319:6467:c1bf:a947] helo=delfion.fritz.box)
        by s198.webhostingserver.nl with esmtpa (Exim 4.96)
        (envelope-from <ftoth@exalondelft.nl>)
        id 1p85Y1-00ELTs-1X;
        Wed, 21 Dec 2022 21:18:41 +0100
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
Subject: [PATCH v1 1/1] Revert "usb: ulpi: defer ulpi_register on ulpi_read_id timeout"
Date:   Wed, 21 Dec 2022 21:18:05 +0100
Message-Id: <20221221201805.19436-1-ftoth@exalondelft.nl>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Link: https://lkml.org/lkml/2022/12/20/803
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

