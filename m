Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBD023C7CE
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 10:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgHEIaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 04:30:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32268 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726563AbgHEIaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 04:30:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596616220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=O5CwGFxP1NwqNMCATOYsNo6Q80nOHmjcvroNFuMzYy0=;
        b=fivHgZam6nV0Ue9RySBtZqdybkcFyQqYRQz0QB8AkjLY9iGvHw/fiTdqL1bXvXeZAlcYw/
        tSem3sc0MfIewLLr0KzETtwRXImvpcEimuZwTRF3bVJC5RvVX7vaeYItOHbGTvA4CSq3kR
        Q5mIZ9nhYduv3eAm0ZPfX7tZxb+j2Sg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-a7c8LH9aMZWASgMRCRW-_g-1; Wed, 05 Aug 2020 04:30:18 -0400
X-MC-Unique: a7c8LH9aMZWASgMRCRW-_g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C029580183C;
        Wed,  5 Aug 2020 08:30:17 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-138.ams2.redhat.com [10.36.112.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E7EE1D3;
        Wed,  5 Aug 2020 08:30:13 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andrea Borgia <andrea@borgia.bo.it>,
        linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] HID: i2c-hid: Always sleep 1ms after I2C_HID_PWR_ON commands
Date:   Wed,  5 Aug 2020 10:30:11 +0200
Message-Id: <20200805083011.5752-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before this commit i2c_hid_parse() consists of the following steps:

1. Send power on cmd
2. usleep_range(1000, 5000)
3. Send reset cmd
4. Wait for reset to complete (device interrupt, or msleep(100))
5. Send power on cmd
6. Try to read HID descriptor

Notice how there is an usleep_range(1000, 5000) after the first power-on
command, but not after the second power-on command.

Testing has shown that at least on the BMAX Y13 laptop's i2c-hid touchpad,
not having a delay after the second power-on command causes the HID
descriptor to read as all zeros.

In case we hit this on other devices too, the descriptor being all zeros
can be recognized by the following message being logged many, many times:

hid-generic 0018:0911:5288.0002: unknown main item tag 0x0

Having 2 cases where we need a delay after sending the power-on command,
seems to indicate that we should always sleep after the power-on command.
So this commit fixes the all zeros HID descriptor issue by moving the
existing usleep_range(1000, 5000) to the i2c_hid_set_power() function.

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208247
Reported-and-tested-by: Andrea Borgia <andrea@borgia.bo.it>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 294c84e136d7..e5d7aaf39b5e 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -420,6 +420,17 @@ static int i2c_hid_set_power(struct i2c_client *client, int power_state)
 		dev_err(&client->dev, "failed to change power setting.\n");
 
 set_pwr_exit:
+
+	/*
+	 * The HID over I2C specification states that if a DEVICE needs time
+	 * after the PWR_ON request, it should utilise CLOCK stretching.
+	 * However, it has been observered that the Windows driver provides a
+	 * 1ms sleep between the PWR_ON and RESET requests and that some devices
+	 * rely on having a short delay after PWR_ON commands.
+	 */
+	if (power_state == I2C_HID_PWR_ON)
+		usleep_range(1000, 5000);
+
 	return ret;
 }
 
@@ -441,15 +452,6 @@ static int i2c_hid_hwreset(struct i2c_client *client)
 	if (ret)
 		goto out_unlock;
 
-	/*
-	 * The HID over I2C specification states that if a DEVICE needs time
-	 * after the PWR_ON request, it should utilise CLOCK stretching.
-	 * However, it has been observered that the Windows driver provides a
-	 * 1ms sleep between the PWR_ON and RESET requests and that some devices
-	 * rely on this.
-	 */
-	usleep_range(1000, 5000);
-
 	i2c_hid_dbg(ihid, "resetting...\n");
 
 	ret = i2c_hid_command(client, &hid_reset_cmd, NULL, 0);
-- 
2.26.2

