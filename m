Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783AE2594D0
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731661AbgIAPnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731660AbgIAPnU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:43:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2BDD207D3;
        Tue,  1 Sep 2020 15:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974999;
        bh=1qda+kQmpKqBY47qqkI2NZVo5Aw4YP6+SFGJx53KV3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNUFVvsw9oucvcnAf986pKzl81pHJvGoAYpVs9L5362MGagyzOy4gi7+jiZYHydOL
         xz8e2EKal8N1hZjKe3Ju5td4zRkm/OxRBMoLsYVpkZ+PcNs4Wj/Y1ms4fJLWT0GYrR
         Il/1XCOmDLgRIM4WEYiukAPLg6AxqjXMP3D4iulg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrea Borgia <andrea@borgia.bo.it>
Subject: [PATCH 5.8 170/255] HID: i2c-hid: Always sleep 60ms after I2C_HID_PWR_ON commands
Date:   Tue,  1 Sep 2020 17:10:26 +0200
Message-Id: <20200901151008.841588110@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit eef4016243e94c438f177ca8226876eb873b9c75 upstream.

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

At the same time as the BMAX Y13's touchpad issue was debugged,
Kai-Heng was working on debugging some issues with Goodix i2c-hid
touchpads. It turns out that these need a delay after a PWR_ON command
too, otherwise they stop working after a suspend/resume cycle.
According to Goodix a delay of minimal 60ms is needed.

Having multiple cases where we need a delay after sending the power-on
command, seems to indicate that we should always sleep after the power-on
command.

This commit fixes the mentioned issues by moving the existing 1ms sleep to
the i2c_hid_set_power() function and changing it to a 60ms sleep.

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208247
Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reported-and-tested-by: Andrea Borgia <andrea@borgia.bo.it>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/i2c-hid/i2c-hid-core.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -420,6 +420,19 @@ static int i2c_hid_set_power(struct i2c_
 		dev_err(&client->dev, "failed to change power setting.\n");
 
 set_pwr_exit:
+
+	/*
+	 * The HID over I2C specification states that if a DEVICE needs time
+	 * after the PWR_ON request, it should utilise CLOCK stretching.
+	 * However, it has been observered that the Windows driver provides a
+	 * 1ms sleep between the PWR_ON and RESET requests.
+	 * According to Goodix Windows even waits 60 ms after (other?)
+	 * PWR_ON requests. Testing has confirmed that several devices
+	 * will not work properly without a delay after a PWR_ON request.
+	 */
+	if (!ret && power_state == I2C_HID_PWR_ON)
+		msleep(60);
+
 	return ret;
 }
 
@@ -441,15 +454,6 @@ static int i2c_hid_hwreset(struct i2c_cl
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


