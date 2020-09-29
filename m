Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8BF27C672
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730413AbgI2LpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730954AbgI2LpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:45:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CEAD20702;
        Tue, 29 Sep 2020 11:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379919;
        bh=1gAGrbXkitidD3g7ye9RQkSH/Sy+fK3BMcHRDM4xKXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lMhPfCWQ1uUtpIHxcfLBfXwASBEIRgqe0+AmrLcmibgzKbLGno5m9rcbgbBP7/aX
         ySoh9OTCIX0Z+Wcth2TOZWZLPThMrHNp0KMlkgLBKqKwKAac6ziSEHfOdiFvqnle8S
         t4lj6kvFz2L76DulsfBSF6ljsTBXTLK8wmj9yrLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 375/388] s390/dasd: Fix zero write for FBA devices
Date:   Tue, 29 Sep 2020 13:01:46 +0200
Message-Id: <20200929110028.615175225@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Höppner <hoeppner@linux.ibm.com>

commit 709192d531e5b0a91f20aa14abfe2fc27ddd47af upstream.

A discard request that writes zeros using the global kernel internal
ZERO_PAGE will fail for machines with more than 2GB of memory due to the
location of the ZERO_PAGE.

Fix this by using a driver owned global zero page allocated with GFP_DMA
flag set.

Fixes: 28b841b3a7cb ("s390/dasd: Add discard support for FBA devices")
Signed-off-by: Jan Höppner <hoeppner@linux.ibm.com>
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 4.14+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/block/dasd_fba.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -40,6 +40,7 @@
 MODULE_LICENSE("GPL");
 
 static struct dasd_discipline dasd_fba_discipline;
+static void *dasd_fba_zero_page;
 
 struct dasd_fba_private {
 	struct dasd_fba_characteristics rdc_data;
@@ -270,7 +271,7 @@ static void ccw_write_zero(struct ccw1 *
 	ccw->cmd_code = DASD_FBA_CCW_WRITE;
 	ccw->flags |= CCW_FLAG_SLI;
 	ccw->count = count;
-	ccw->cda = (__u32) (addr_t) page_to_phys(ZERO_PAGE(0));
+	ccw->cda = (__u32) (addr_t) dasd_fba_zero_page;
 }
 
 /*
@@ -830,6 +831,11 @@ dasd_fba_init(void)
 	int ret;
 
 	ASCEBC(dasd_fba_discipline.ebcname, 4);
+
+	dasd_fba_zero_page = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	if (!dasd_fba_zero_page)
+		return -ENOMEM;
+
 	ret = ccw_driver_register(&dasd_fba_driver);
 	if (!ret)
 		wait_for_device_probe();
@@ -841,6 +847,7 @@ static void __exit
 dasd_fba_cleanup(void)
 {
 	ccw_driver_unregister(&dasd_fba_driver);
+	free_page((unsigned long)dasd_fba_zero_page);
 }
 
 module_init(dasd_fba_init);


