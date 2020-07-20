Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D272226686
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732272AbgGTQD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732511AbgGTQD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:03:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A4D420684;
        Mon, 20 Jul 2020 16:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261038;
        bh=UckB6aorP9uBAZnlnr9liyRAEo9To/eHwIwBb1ucEnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTfmDNSnELRJAlD5I2uKX7tPCoECIlqbusPAhEtI5Yf9I9MZE7xW+nSHJ/hkyf3Ji
         iiS14ltZn+gwny+ZD1VvmQgSZOdMaVIV3nkM88JrPsE5+BHsjCQGoPRbgao0W9zfGM
         UgMvT1/FFFDCyagRUk3kQx0MyOIHLy8zcVCBd3wU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vishwas M <vishwas.reddy.vr@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 186/215] hwmon: (emc2103) fix unable to change fan pwm1_enable attribute
Date:   Mon, 20 Jul 2020 17:37:48 +0200
Message-Id: <20200720152829.026671352@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishwas M <vishwas.reddy.vr@gmail.com>

commit 14b0e83dc4f1e52b94acaeb85a18fd7fdd46d2dc upstream.

This patch fixes a bug which does not let FAN mode to be changed from
sysfs(pwm1_enable). i.e pwm1_enable can not be set to 3, it will always
remain at 0.

This is caused because the device driver handles the result of
"read_u8_from_i2c(client, REG_FAN_CONF1, &conf_reg)" incorrectly. The
driver thinks an error has occurred if the (result != 0). This has been
fixed by changing the condition to (result < 0).

Signed-off-by: Vishwas M <vishwas.reddy.vr@gmail.com>
Link: https://lore.kernel.org/r/20200707142747.118414-1-vishwas.reddy.vr@gmail.com
Fixes: 9df7305b5a86 ("hwmon: Add driver for SMSC EMC2103 temperature monitor and fan controller")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/emc2103.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/emc2103.c
+++ b/drivers/hwmon/emc2103.c
@@ -443,7 +443,7 @@ static ssize_t pwm1_enable_store(struct
 	}
 
 	result = read_u8_from_i2c(client, REG_FAN_CONF1, &conf_reg);
-	if (result) {
+	if (result < 0) {
 		count = result;
 		goto err;
 	}


