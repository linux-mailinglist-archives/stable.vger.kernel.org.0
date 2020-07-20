Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA1A2264D7
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbgGTPso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729962AbgGTPsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:48:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 236862064B;
        Mon, 20 Jul 2020 15:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260122;
        bh=hzLAThHvf7gJmaisKABfV8tEcvLhHCQOlRUK9Pj01rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DkWUIPqfdYIaUlLHlAmiidBJSFwwp6nHLlEmlbrnxS5QXxiL9Lyi6m8L05JYfU/DC
         xwdlqwF7YWje9I3hVJeznmPcR1NMWH6xXHKnWaCBD/TVd0Gd5MWW8LkwTgcjoQn/lr
         cOqvrTgpHVs3AWYiT6Ss8IBYVtBhobEojtlzzmw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vishwas M <vishwas.reddy.vr@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 114/125] hwmon: (emc2103) fix unable to change fan pwm1_enable attribute
Date:   Mon, 20 Jul 2020 17:37:33 +0200
Message-Id: <20200720152808.537990545@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
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
@@ -454,7 +454,7 @@ static ssize_t pwm1_enable_store(struct
 	}
 
 	result = read_u8_from_i2c(client, REG_FAN_CONF1, &conf_reg);
-	if (result) {
+	if (result < 0) {
 		count = result;
 		goto err;
 	}


