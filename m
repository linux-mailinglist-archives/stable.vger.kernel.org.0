Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE6113F3BC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732638AbgAPSo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:44:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389681AbgAPRKq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 662672468B;
        Thu, 16 Jan 2020 17:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194646;
        bh=tA3GxtibskflyMCJ9nDoF9nv8bgFxzueSpZL7trjodY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRlcmkPlLYpRuoL50u8/pAq+/vygvOQu1gtc/cEU+/ZPFU7pPwzJSh6SdNKpxLe09
         7EWx649/KIZ/pnBKoA+rlO8qOeh+tsYLQnG1mFP+NIjYi1+MY6iLqo8SXBnhIaZk5w
         EBxKc83rcwaqYf1GqNtVQEkA580vYuUArUqM/qnI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Tom Evans <tom.evans@motec.com.au>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 502/671] rtc: rv3029: revert error handling patch to rv3029_eeprom_write()
Date:   Thu, 16 Jan 2020 12:02:20 -0500
Message-Id: <20200116170509.12787-239-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 3d6174eb32f6..cfe3aece51d1 100644
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

