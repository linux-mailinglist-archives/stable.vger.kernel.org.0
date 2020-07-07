Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6E021705E
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgGGPQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:16:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729083AbgGGPQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:16:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3415620663;
        Tue,  7 Jul 2020 15:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135004;
        bh=idTxtCNKIbSRyntYocSBfWdeqKocdgP1o74vUnpWvY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7NdC5nL1tVjxCtHwC2tytJA3nGIFRWgYjq1T+wriVpsiRflI7vNxIuxMi9YdR31F
         a7LlzREOiAUvOz+tJir+NvxsY3dWXOonLSQf0wxXt/C6iGeLS0n9DB3t+qxpe6CSfj
         GhN1P7QMje8uVztzviKPVrEosjCL9Gu5aJiuLaHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/27] i2c: algo-pca: Add 0x78 as SCL stuck low status for PCA9665
Date:   Tue,  7 Jul 2020 17:15:45 +0200
Message-Id: <20200707145749.827942938@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.944863698@linuxfoundation.org>
References: <20200707145748.944863698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit cd217f2300793a106b49c7dfcbfb26e348bc7593 ]

The PCA9665 datasheet says that I2CSTA = 78h indicates that SCL is stuck
low, this differs to the PCA9564 which uses 90h for this indication.
Treat either 0x78 or 0x90 as an indication that the SCL line is stuck.

Based on looking through the PCA9564 and PCA9665 datasheets this should
be safe for both chips. The PCA9564 should not return 0x78 for any valid
state and the PCA9665 should not return 0x90.

Fixes: eff9ec95efaa ("i2c-algo-pca: Add PCA9665 support")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/algos/i2c-algo-pca.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/algos/i2c-algo-pca.c b/drivers/i2c/algos/i2c-algo-pca.c
index e370804ec8bc6..3a9db4626cb60 100644
--- a/drivers/i2c/algos/i2c-algo-pca.c
+++ b/drivers/i2c/algos/i2c-algo-pca.c
@@ -326,7 +326,8 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
 			DEB2("BUS ERROR - SDA Stuck low\n");
 			pca_reset(adap);
 			goto out;
-		case 0x90: /* Bus error - SCL stuck low */
+		case 0x78: /* Bus error - SCL stuck low (PCA9665) */
+		case 0x90: /* Bus error - SCL stuck low (PCA9564) */
 			DEB2("BUS ERROR - SCL Stuck low\n");
 			pca_reset(adap);
 			goto out;
-- 
2.25.1



