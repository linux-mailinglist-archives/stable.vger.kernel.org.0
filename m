Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 330F71482A3
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391825AbgAXL3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:29:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391822AbgAXL3h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:29:37 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA9C9206D4;
        Fri, 24 Jan 2020 11:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865376;
        bh=h+D3fc1X2bbvN0462OR0SmPlb60QQjyxnM4BJqv94BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USxv0Tfoa7GvIx2DdmYhJcmR7UBaxPqCUWr7TealHFXa4QQ06Bw5AC95je1NlKPwF
         ft6eN4oNwbLuJSCUXLq/jEj1QifvAHMVpz6ZQRapNiq1sjI/jPBQJxHgzLvaN/rg5P
         9Xh4XAQWLY1s7EJJGlmFoz20iHmRQwYO5OCW+rY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Evans <tom.evans@motec.com.au>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 516/639] rtc: rv3029: revert error handling patch to rv3029_eeprom_write()
Date:   Fri, 24 Jan 2020 10:31:26 +0100
Message-Id: <20200124093153.439142590@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit a6f26606ddd03c5eab8b2132f1bfaa768c06158f ]

My error handling "cleanup" was totally wrong.  Both the "err" and "ret"
variables are required.  The "err" variable holds the error codes for
rv3029_eeprom_enter/exit() and the "ret" variable holds the error codes
for if actual write fails.  In my patch if the write failed, the
function probably still returned success.

Reported-by: Tom Evans <tom.evans@motec.com.au>
Fixes: 97f5b0379c38 ("rtc: rv3029: Clean up error handling in rv3029_eeprom_write()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20190817065604.GB29951@mwanda
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rv3029c2.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-rv3029c2.c b/drivers/rtc/rtc-rv3029c2.c
index 3d6174eb32f6a..cfe3aece51d17 100644
--- a/drivers/rtc/rtc-rv3029c2.c
+++ b/drivers/rtc/rtc-rv3029c2.c
@@ -282,13 +282,13 @@ static int rv3029_eeprom_read(struct device *dev, u8 reg,
 static int rv3029_eeprom_write(struct device *dev, u8 reg,
 			       u8 const buf[], size_t len)
 {
-	int ret;
+	int ret, err;
 	size_t i;
 	u8 tmp;
 
-	ret = rv3029_eeprom_enter(dev);
-	if (ret < 0)
-		return ret;
+	err = rv3029_eeprom_enter(dev);
+	if (err < 0)
+		return err;
 
 	for (i = 0; i < len; i++, reg++) {
 		ret = rv3029_read_regs(dev, reg, &tmp, 1);
@@ -304,11 +304,11 @@ static int rv3029_eeprom_write(struct device *dev, u8 reg,
 			break;
 	}
 
-	ret = rv3029_eeprom_exit(dev);
-	if (ret < 0)
-		return ret;
+	err = rv3029_eeprom_exit(dev);
+	if (err < 0)
+		return err;
 
-	return 0;
+	return ret;
 }
 
 static int rv3029_eeprom_update_bits(struct device *dev,
-- 
2.20.1



