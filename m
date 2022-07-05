Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D74C566E13
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237357AbiGEMbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237937AbiGEM0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A28E19;
        Tue,  5 Jul 2022 05:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 661D5B816A4;
        Tue,  5 Jul 2022 12:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EBAC341C8;
        Tue,  5 Jul 2022 12:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023502;
        bh=laE41Lg/hDGw0qxy9DssI/CKKA3A4ZWA3I/Wys2UskA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCr4MBbpxmX3HPB66/ObKd8Bzvralf4LsQdQ81Ai98FMdodu72QFsdgDy5mdfzpRz
         pwsPGDdx4idthVUvSVG93Flw++jS3i/8PL2rWH6ZpwzY7w3u1N+mbKOLxWLnv1REGJ
         bzDd7Mr3mPGiuj7i+gg0tqV4W4EHA0S5PGOIJXUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.18 042/102] hwmon: (occ) Prevent power cap command overwriting poll response
Date:   Tue,  5 Jul 2022 13:58:08 +0200
Message-Id: <20220705115619.605657758@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Eddie James <eajames@linux.ibm.com>

commit 1bbb2809040a1f9c7c53c9f06c21aa83275ed27b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/occ/common.c |    5 +++--
 drivers/hwmon/occ/common.h |    3 ++-
 drivers/hwmon/occ/p8_i2c.c |   13 +++++++------
 drivers/hwmon/occ/p9_sbe.c |    7 +++----
 4 files changed, 15 insertions(+), 13 deletions(-)

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
@@ -182,6 +182,7 @@ static int occ_set_user_power_cap(struct
 {
 	int rc;
 	u8 cmd[8];
+	u8 resp[8];
 	__be16 user_power_cap_be = cpu_to_be16(user_power_cap);
 
 	cmd[0] = 0;	/* sequence number */
@@ -198,7 +199,7 @@ static int occ_set_user_power_cap(struct
 	if (rc)
 		return rc;
 
-	rc = occ->send_cmd(occ, cmd, sizeof(cmd));
+	rc = occ->send_cmd(occ, cmd, sizeof(cmd), resp, sizeof(resp));
 
 	mutex_unlock(&occ->lock);
 
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
--- a/drivers/hwmon/occ/p8_i2c.c
+++ b/drivers/hwmon/occ/p8_i2c.c
@@ -111,7 +111,8 @@ static int p8_i2c_occ_putscom_be(struct
 				      be32_to_cpu(data1));
 }
 
-static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len)
+static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len,
+			       void *resp, size_t resp_len)
 {
 	int i, rc;
 	unsigned long start;
@@ -120,7 +121,7 @@ static int p8_i2c_occ_send_cmd(struct oc
 	const long wait_time = msecs_to_jiffies(OCC_CMD_IN_PRG_WAIT_MS);
 	struct p8_i2c_occ *ctx = to_p8_i2c_occ(occ);
 	struct i2c_client *client = ctx->client;
-	struct occ_response *resp = &occ->resp;
+	struct occ_response *or = (struct occ_response *)resp;
 
 	start = jiffies;
 
@@ -151,7 +152,7 @@ static int p8_i2c_occ_send_cmd(struct oc
 			return rc;
 
 		/* wait for OCC */
-		if (resp->return_status == OCC_RESP_CMD_IN_PRG) {
+		if (or->return_status == OCC_RESP_CMD_IN_PRG) {
 			rc = -EALREADY;
 
 			if (time_after(jiffies, start + timeout))
@@ -163,7 +164,7 @@ static int p8_i2c_occ_send_cmd(struct oc
 	} while (rc);
 
 	/* check the OCC response */
-	switch (resp->return_status) {
+	switch (or->return_status) {
 	case OCC_RESP_CMD_IN_PRG:
 		rc = -ETIMEDOUT;
 		break;
@@ -192,8 +193,8 @@ static int p8_i2c_occ_send_cmd(struct oc
 	if (rc < 0)
 		return rc;
 
-	data_length = get_unaligned_be16(&resp->data_length);
-	if (data_length > OCC_RESP_DATA_BYTES)
+	data_length = get_unaligned_be16(&or->data_length);
+	if ((data_length + 7) > resp_len)
 		return -EMSGSIZE;
 
 	/* fetch the rest of the response data */
--- a/drivers/hwmon/occ/p9_sbe.c
+++ b/drivers/hwmon/occ/p9_sbe.c
@@ -78,11 +78,10 @@ done:
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
@@ -96,7 +95,7 @@ static int p9_sbe_occ_send_cmd(struct oc
 		return rc;
 	}
 
-	switch (resp->return_status) {
+	switch (((struct occ_response *)resp)->return_status) {
 	case OCC_RESP_CMD_IN_PRG:
 		rc = -ETIMEDOUT;
 		break;


