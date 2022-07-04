Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26CA56556A
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 14:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbiGDMdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 08:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbiGDMdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 08:33:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68692627
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 05:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D7B9B80EF2
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 12:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950C3C3411E;
        Mon,  4 Jul 2022 12:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656938009;
        bh=THflr9JFWI/rCTEan8qUus5whEvppzxJg9+/xggdf2U=;
        h=Subject:To:Cc:From:Date:From;
        b=dL2yG5yK1K3sOH0hiFiRlz0AKuj+I0pc/zRywVu5WXNQ762rISAqRo+bH9YayiVCr
         fvKWAIT15UuunbThVKsZMWUzDv7IA1pSOYOKf0k7NQZhT/Ix3OOAAILe/fYCPhsXms
         AsNX3CuoWIWrETw25dWOs5PJDu7awyT5kFEOCIpg=
Subject: FAILED: patch "[PATCH] hwmon: (occ) Prevent power cap command overwriting poll" failed to apply to 5.10-stable tree
To:     eajames@linux.ibm.com, linux@roeck-us.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 14:33:18 +0200
Message-ID: <165693799824126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1bbb2809040a1f9c7c53c9f06c21aa83275ed27b Mon Sep 17 00:00:00 2001
From: Eddie James <eajames@linux.ibm.com>
Date: Tue, 28 Jun 2022 15:30:29 -0500
Subject: [PATCH] hwmon: (occ) Prevent power cap command overwriting poll
 response

Currently, the response to the power cap command overwrites the
first eight bytes of the poll response, since the commands use
the same buffer. This means that user's get the wrong data between
the time of sending the power cap and the next poll response update.
Fix this by specifying a different buffer for the power cap command
response.

Fixes: 5b5513b88002 ("hwmon: Add On-Chip Controller (OCC) hwmon driver")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20220628203029.51747-1-eajames@linux.ibm.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>

diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
index ea070b91e5b9..157b73a3da29 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -145,7 +145,7 @@ static int occ_poll(struct occ *occ)
 	cmd[6] = 0;			/* checksum lsb */
 
 	/* mutex should already be locked if necessary */
-	rc = occ->send_cmd(occ, cmd, sizeof(cmd));
+	rc = occ->send_cmd(occ, cmd, sizeof(cmd), &occ->resp, sizeof(occ->resp));
 	if (rc) {
 		occ->last_error = rc;
 		if (occ->error_count++ > OCC_ERROR_COUNT_THRESHOLD)
@@ -182,6 +182,7 @@ static int occ_set_user_power_cap(struct occ *occ, u16 user_power_cap)
 {
 	int rc;
 	u8 cmd[8];
+	u8 resp[8];
 	__be16 user_power_cap_be = cpu_to_be16(user_power_cap);
 
 	cmd[0] = 0;	/* sequence number */
@@ -198,7 +199,7 @@ static int occ_set_user_power_cap(struct occ *occ, u16 user_power_cap)
 	if (rc)
 		return rc;
 
-	rc = occ->send_cmd(occ, cmd, sizeof(cmd));
+	rc = occ->send_cmd(occ, cmd, sizeof(cmd), resp, sizeof(resp));
 
 	mutex_unlock(&occ->lock);
 
diff --git a/drivers/hwmon/occ/common.h b/drivers/hwmon/occ/common.h
index 64d5ec7e169b..7ac4b2febce6 100644
--- a/drivers/hwmon/occ/common.h
+++ b/drivers/hwmon/occ/common.h
@@ -96,7 +96,8 @@ struct occ {
 
 	int powr_sample_time_us;	/* average power sample time */
 	u8 poll_cmd_data;		/* to perform OCC poll command */
-	int (*send_cmd)(struct occ *occ, u8 *cmd, size_t len);
+	int (*send_cmd)(struct occ *occ, u8 *cmd, size_t len, void *resp,
+			size_t resp_len);
 
 	unsigned long next_update;
 	struct mutex lock;		/* lock OCC access */
diff --git a/drivers/hwmon/occ/p8_i2c.c b/drivers/hwmon/occ/p8_i2c.c
index da39ea28df31..b221be1f35f3 100644
--- a/drivers/hwmon/occ/p8_i2c.c
+++ b/drivers/hwmon/occ/p8_i2c.c
@@ -111,7 +111,8 @@ static int p8_i2c_occ_putscom_be(struct i2c_client *client, u32 address,
 				      be32_to_cpu(data1));
 }
 
-static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len)
+static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len,
+			       void *resp, size_t resp_len)
 {
 	int i, rc;
 	unsigned long start;
@@ -120,7 +121,7 @@ static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len)
 	const long wait_time = msecs_to_jiffies(OCC_CMD_IN_PRG_WAIT_MS);
 	struct p8_i2c_occ *ctx = to_p8_i2c_occ(occ);
 	struct i2c_client *client = ctx->client;
-	struct occ_response *resp = &occ->resp;
+	struct occ_response *or = (struct occ_response *)resp;
 
 	start = jiffies;
 
@@ -151,7 +152,7 @@ static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len)
 			return rc;
 
 		/* wait for OCC */
-		if (resp->return_status == OCC_RESP_CMD_IN_PRG) {
+		if (or->return_status == OCC_RESP_CMD_IN_PRG) {
 			rc = -EALREADY;
 
 			if (time_after(jiffies, start + timeout))
@@ -163,7 +164,7 @@ static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len)
 	} while (rc);
 
 	/* check the OCC response */
-	switch (resp->return_status) {
+	switch (or->return_status) {
 	case OCC_RESP_CMD_IN_PRG:
 		rc = -ETIMEDOUT;
 		break;
@@ -192,8 +193,8 @@ static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len)
 	if (rc < 0)
 		return rc;
 
-	data_length = get_unaligned_be16(&resp->data_length);
-	if (data_length > OCC_RESP_DATA_BYTES)
+	data_length = get_unaligned_be16(&or->data_length);
+	if ((data_length + 7) > resp_len)
 		return -EMSGSIZE;
 
 	/* fetch the rest of the response data */
diff --git a/drivers/hwmon/occ/p9_sbe.c b/drivers/hwmon/occ/p9_sbe.c
index 42fc7b97bb34..a91937e28e12 100644
--- a/drivers/hwmon/occ/p9_sbe.c
+++ b/drivers/hwmon/occ/p9_sbe.c
@@ -78,11 +78,10 @@ static bool p9_sbe_occ_save_ffdc(struct p9_sbe_occ *ctx, const void *resp,
 	return notify;
 }
 
-static int p9_sbe_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len)
+static int p9_sbe_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len,
+			       void *resp, size_t resp_len)
 {
-	struct occ_response *resp = &occ->resp;
 	struct p9_sbe_occ *ctx = to_p9_sbe_occ(occ);
-	size_t resp_len = sizeof(*resp);
 	int rc;
 
 	rc = fsi_occ_submit(ctx->sbe, cmd, len, resp, &resp_len);
@@ -96,7 +95,7 @@ static int p9_sbe_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len)
 		return rc;
 	}
 
-	switch (resp->return_status) {
+	switch (((struct occ_response *)resp)->return_status) {
 	case OCC_RESP_CMD_IN_PRG:
 		rc = -ETIMEDOUT;
 		break;

