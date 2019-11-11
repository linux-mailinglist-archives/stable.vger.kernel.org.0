Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6231F7D62
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbfKKS4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:56:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730682AbfKKS4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:56:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8380220818;
        Mon, 11 Nov 2019 18:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498575;
        bh=R7FGbPqzYg4kJCGPu8gSSLqzU2QM8hGt1Ft1K430dJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3v3Iw24L47CxTeKm5HwQ/IKdVqApxQv5HXPUuoPkkOVadPNly5lAo5kpsjtPLIG3
         GEMzrUcCoTROtmn2moBXvmrkTr0qQj8Rj84w/G3QSinGK6CFLpBBikfvXrCMcVjZCw
         7jZNNCc9wCIAUIBsUPL5hEDnil77IubF2FYNRjsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolin Chen <nicoleotsuka@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 152/193] hwmon: (ina3221) Fix read timeout issue
Date:   Mon, 11 Nov 2019 19:28:54 +0100
Message-Id: <20191111181512.353899726@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolin Chen <nicoleotsuka@gmail.com>

[ Upstream commit 2ccb4f16d013a0954459061d38172b1c53553ba6 ]

After introducing "samples" to the calculation of wait time, the
driver might timeout at the regmap_field_read_poll_timeout call,
because the wait time could be longer than the 100000 usec limit
due to a large "samples" number.

So this patch sets the timeout limit to 2 times of the wait time
in order to fix this issue.

Fixes: 5c090abf945b ("hwmon: (ina3221) Add averaging mode support")
Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
Link: https://lore.kernel.org/r/20191022005922.30239-1-nicoleotsuka@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina3221.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ina3221.c b/drivers/hwmon/ina3221.c
index 0037e2bdacd6b..8a51dcf055eab 100644
--- a/drivers/hwmon/ina3221.c
+++ b/drivers/hwmon/ina3221.c
@@ -170,7 +170,7 @@ static inline int ina3221_wait_for_data(struct ina3221_data *ina)
 
 	/* Polling the CVRF bit to make sure read data is ready */
 	return regmap_field_read_poll_timeout(ina->fields[F_CVRF],
-					      cvrf, cvrf, wait, 100000);
+					      cvrf, cvrf, wait, wait * 2);
 }
 
 static int ina3221_read_value(struct ina3221_data *ina, unsigned int reg,
-- 
2.20.1



