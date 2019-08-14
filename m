Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1308DB82
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbfHNRZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728882AbfHNRFU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:05:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 649C3208C2;
        Wed, 14 Aug 2019 17:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802319;
        bh=JLGDd8bsW7iM4fXbpOOdEbG+zT1Q3Zdh9IXZ5jbNYuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KEpdsLhkO7dRQGFPBn3mJ8bUqZlzfpb2oOH7R3naHn4cPP/s+uQ5cs15fIoWFLLW
         gNAmnVlGix6DGhMbSB/54LMt0vdk8CSWel/ZYSfIGnx8FxKtTZrQSiX1ZzNKJa3mjo
         L2+BUhyGYNqh+AOn+qt1XyjE0z4JzkhLEG7G2aaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lei YU <mine260309@gmail.com>,
        Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 079/144] hwmon: (occ) Fix division by zero issue
Date:   Wed, 14 Aug 2019 19:00:35 +0200
Message-Id: <20190814165803.163212709@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 211186cae14de09573b062e478eb9fe215aed8d9 ]

The code in occ_get_powr_avg() invokes div64_u64() without checking the
divisor. In case the divisor is zero, kernel gets an "Division by zero
in kernel" error.

Check the divisor and make it return 0 if the divisor is 0.

Fixes: c10e753d43eb ("hwmon (occ): Add sensor types and versions")
Signed-off-by: Lei YU <mine260309@gmail.com>
Reviewed-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/1562813088-23708-1-git-send-email-mine260309@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
index 13a6290c8d254..f02aa403332c2 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -402,8 +402,10 @@ static ssize_t occ_show_power_1(struct device *dev,
 
 static u64 occ_get_powr_avg(u64 *accum, u32 *samples)
 {
-	return div64_u64(get_unaligned_be64(accum) * 1000000ULL,
-			 get_unaligned_be32(samples));
+	u64 divisor = get_unaligned_be32(samples);
+
+	return (divisor == 0) ? 0 :
+		div64_u64(get_unaligned_be64(accum) * 1000000ULL, divisor);
 }
 
 static ssize_t occ_show_power_2(struct device *dev,
-- 
2.20.1



