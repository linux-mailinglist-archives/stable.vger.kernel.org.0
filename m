Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 104F87F890
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393447AbfHBNUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393444AbfHBNUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8B9B2173E;
        Fri,  2 Aug 2019 13:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752042;
        bh=9FaxuvGlL/MM4rTlmObzREzC0/lIE6SRjkWENMXn1M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gb4Gq7tOVfjwJQouIXTRWcm06Pc4TDFLr6M7SHbNufeHjWua1oHELMG16rG7MrO5c
         jtQcjXUs9yI51yqQw5CSj2otXdhfPVoAY9m9qEUhV4LmKfCMYXNAUt4FW7DDWjLnfc
         041Ja5iKkFewzxtNatf/bpdqjI5R/05peZAqQZys=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lei YU <mine260309@gmail.com>, Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 31/76] hwmon: (occ) Fix division by zero issue
Date:   Fri,  2 Aug 2019 09:19:05 -0400
Message-Id: <20190802131951.11600-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lei YU <mine260309@gmail.com>

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

