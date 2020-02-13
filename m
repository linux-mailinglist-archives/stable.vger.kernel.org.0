Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C618815C2F5
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgBMPiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:38:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729670AbgBMP3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:29:12 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 137B3218AC;
        Thu, 13 Feb 2020 15:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607751;
        bh=n9qPfzZareJWROB5S1i2u8Q8pzKf0P4hrNCvkAWh3w0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUOCVgr/h168DEixxlbkmEx+UI97j8o6inlZ7TrZ9Y578onM+55vzLRyej8p2eQHI
         pKyWxeSMExO8BZrebVcjBB1BXVgb6+0p8vdgDr/h6hhVUHn0ONgHyQUwGWphfI1AVB
         vOhQK7mr1ZH2I3C+dNIhiz989B7vWl1B8EInNX8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.5 094/120] mtd: sharpslpart: Fix unsigned comparison to zero
Date:   Thu, 13 Feb 2020 07:21:30 -0800
Message-Id: <20200213151932.657671950@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit f33113b542219448fa02d77ca1c6f4265bd7f130 upstream.

The unsigned variable log_num is being assigned a return value
from the call to sharpsl_nand_get_logical_num that can return
-EINVAL.

Detected using Coccinelle:
./drivers/mtd/parsers/sharpslpart.c:207:6-13: WARNING: Unsigned expression compared with zero: log_num > 0

Fixes: 8a4580e4d298 ("mtd: sharpslpart: Add sharpslpart partition parser")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/parsers/sharpslpart.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/parsers/sharpslpart.c
+++ b/drivers/mtd/parsers/sharpslpart.c
@@ -165,10 +165,10 @@ static int sharpsl_nand_get_logical_num(
 
 static int sharpsl_nand_init_ftl(struct mtd_info *mtd, struct sharpsl_ftl *ftl)
 {
-	unsigned int block_num, log_num, phymax;
+	unsigned int block_num, phymax;
+	int i, ret, log_num;
 	loff_t block_adr;
 	u8 *oob;
-	int i, ret;
 
 	oob = kzalloc(mtd->oobsize, GFP_KERNEL);
 	if (!oob)


