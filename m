Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646564B4B9E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346256AbiBNKRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:17:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346536AbiBNKPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:15:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321FC78077;
        Mon, 14 Feb 2022 01:53:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23E00612E8;
        Mon, 14 Feb 2022 09:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B81C340F2;
        Mon, 14 Feb 2022 09:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832367;
        bh=AZXAbiZvJ6nWw7gXrj10+47lyAwQoRGzUY4LNP2uiBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Di5xauHkd/V9ATNnYaZYsVnm/oIjgwDLnq/B7MQmquTMjfmH1yO1KC/gz9ZJhV0VB
         ChCJ7FU5IbGaQdZmcJWYvgrGPDd5OHn//QSibpLo92DpWtm7MVE6QTzvOffs+UTmKX
         vuuvVbAGmLUva787VwK9h+jcpMREfkkm069Ofdt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Armin Wolf <W_Armin@gmx.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 163/172] hwmon: (dell-smm) Speed up setting of fan speed
Date:   Mon, 14 Feb 2022 10:27:01 +0100
Message-Id: <20220214092512.018661400@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>

commit c0d79987a0d82671bff374c07f2201f9bdf4aaa2 upstream.

When setting the fan speed, i8k_set_fan() calls i8k_get_fan_status(),
causing an unnecessary SMM call since from the two users of this
function, only i8k_ioctl_unlocked() needs to know the new fan status
while dell_smm_write() ignores the new fan status.
Since SMM calls can be very slow while also making error reporting
difficult for dell_smm_write(), remove the function call from
i8k_set_fan() and call it separately in i8k_ioctl_unlocked().

Tested on a Dell Inspiron 3505.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20211021190531.17379-6-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/dell-smm-hwmon.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -326,7 +326,7 @@ static int i8k_enable_fan_auto_mode(cons
 }
 
 /*
- * Set the fan speed (off, low, high). Returns the new fan status.
+ * Set the fan speed (off, low, high, ...).
  */
 static int i8k_set_fan(const struct dell_smm_data *data, int fan, int speed)
 {
@@ -338,7 +338,7 @@ static int i8k_set_fan(const struct dell
 	speed = (speed < 0) ? 0 : ((speed > data->i8k_fan_max) ? data->i8k_fan_max : speed);
 	regs.ebx = (fan & 0xff) | (speed << 8);
 
-	return i8k_smm(&regs) ? : i8k_get_fan_status(data, fan);
+	return i8k_smm(&regs);
 }
 
 static int __init i8k_get_temp_type(int sensor)
@@ -452,7 +452,7 @@ static int
 i8k_ioctl_unlocked(struct file *fp, struct dell_smm_data *data, unsigned int cmd, unsigned long arg)
 {
 	int val = 0;
-	int speed;
+	int speed, err;
 	unsigned char buff[16];
 	int __user *argp = (int __user *)arg;
 
@@ -513,7 +513,11 @@ i8k_ioctl_unlocked(struct file *fp, stru
 		if (copy_from_user(&speed, argp + 1, sizeof(int)))
 			return -EFAULT;
 
-		val = i8k_set_fan(data, val, speed);
+		err = i8k_set_fan(data, val, speed);
+		if (err < 0)
+			return err;
+
+		val = i8k_get_fan_status(data, val);
 		break;
 
 	default:


