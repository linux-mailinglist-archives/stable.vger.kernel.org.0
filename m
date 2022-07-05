Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41528566D07
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbiGEMUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbiGEMTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6671CFEE;
        Tue,  5 Jul 2022 05:14:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3375DB8170A;
        Tue,  5 Jul 2022 12:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E7AC341C8;
        Tue,  5 Jul 2022 12:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023260;
        bh=NYZ5Ma/SMXxg5Sf1OWiBbN8Nj/5zSg0poVPTAMM+Wt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaCuCBp1NYqQeH1Yq7KPhjP9sCEjtQAQrQxH7kgHAGaMpKzpMOI3euYcyXYbLBZlg
         gJkwa7qTGKVB18fz8z3Fz5xEkxtaUNIhDwKD3u8+Z6gp27U7mit1Z0H13i31MyWeP/
         9bDtx4Ju03WGP0oRrxy1QyaKnuJ/H5J1aJb90jag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 96/98] hwmon: (occ) Remove sequence numbering and checksum calculation
Date:   Tue,  5 Jul 2022 13:58:54 +0200
Message-Id: <20220705115620.297922907@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
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

[ Upstream commit 908dbf0242e21dd95c69a1b0935814cd1abfc134 ]

Checksumming of the request and sequence numbering is now done in the
OCC interface driver in order to keep unique sequence numbers. So
remove those in the hwmon driver. Also, add the command length to the
send_cmd function pointer, since the checksum must be placed in the
last two bytes of the command. The submit interface must receive the
exact size of the command - previously it could be rounded to the
nearest 8 bytes with no consequence.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20210721190231.117185-3-eajames@linux.ibm.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/common.c | 30 ++++++++++++------------------
 drivers/hwmon/occ/common.h |  3 +--
 drivers/hwmon/occ/p8_i2c.c | 15 +++++++++------
 drivers/hwmon/occ/p9_sbe.c |  4 ++--
 4 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
index ae664613289c..0cb4a0a6cbc1 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -132,22 +132,20 @@ struct extended_sensor {
 static int occ_poll(struct occ *occ)
 {
 	int rc;
-	u16 checksum = occ->poll_cmd_data + occ->seq_no + 1;
-	u8 cmd[8];
+	u8 cmd[7];
 	struct occ_poll_response_header *header;
 
 	/* big endian */
-	cmd[0] = occ->seq_no++;		/* sequence number */
+	cmd[0] = 0;			/* sequence number */
 	cmd[1] = 0;			/* cmd type */
 	cmd[2] = 0;			/* data length msb */
 	cmd[3] = 1;			/* data length lsb */
 	cmd[4] = occ->poll_cmd_data;	/* data */
-	cmd[5] = checksum >> 8;		/* checksum msb */
-	cmd[6] = checksum & 0xFF;	/* checksum lsb */
-	cmd[7] = 0;
+	cmd[5] = 0;			/* checksum msb */
+	cmd[6] = 0;			/* checksum lsb */
 
 	/* mutex should already be locked if necessary */
-	rc = occ->send_cmd(occ, cmd);
+	rc = occ->send_cmd(occ, cmd, sizeof(cmd));
 	if (rc) {
 		occ->last_error = rc;
 		if (occ->error_count++ > OCC_ERROR_COUNT_THRESHOLD)
@@ -184,25 +182,23 @@ static int occ_set_user_power_cap(struct occ *occ, u16 user_power_cap)
 {
 	int rc;
 	u8 cmd[8];
-	u16 checksum = 0x24;
 	__be16 user_power_cap_be = cpu_to_be16(user_power_cap);
 
-	cmd[0] = 0;
-	cmd[1] = 0x22;
-	cmd[2] = 0;
-	cmd[3] = 2;
+	cmd[0] = 0;	/* sequence number */
+	cmd[1] = 0x22;	/* cmd type */
+	cmd[2] = 0;	/* data length msb */
+	cmd[3] = 2;	/* data length lsb */
 
 	memcpy(&cmd[4], &user_power_cap_be, 2);
 
-	checksum += cmd[4] + cmd[5];
-	cmd[6] = checksum >> 8;
-	cmd[7] = checksum & 0xFF;
+	cmd[6] = 0;	/* checksum msb */
+	cmd[7] = 0;	/* checksum lsb */
 
 	rc = mutex_lock_interruptible(&occ->lock);
 	if (rc)
 		return rc;
 
-	rc = occ->send_cmd(occ, cmd);
+	rc = occ->send_cmd(occ, cmd, sizeof(cmd));
 
 	mutex_unlock(&occ->lock);
 
@@ -1144,8 +1140,6 @@ int occ_setup(struct occ *occ, const char *name)
 {
 	int rc;
 
-	/* start with 1 to avoid false match with zero-initialized SRAM buffer */
-	occ->seq_no = 1;
 	mutex_init(&occ->lock);
 	occ->groups[0] = &occ->group;
 
diff --git a/drivers/hwmon/occ/common.h b/drivers/hwmon/occ/common.h
index e6df719770e8..5020117be740 100644
--- a/drivers/hwmon/occ/common.h
+++ b/drivers/hwmon/occ/common.h
@@ -95,9 +95,8 @@ struct occ {
 	struct occ_sensors sensors;
 
 	int powr_sample_time_us;	/* average power sample time */
-	u8 seq_no;
 	u8 poll_cmd_data;		/* to perform OCC poll command */
-	int (*send_cmd)(struct occ *occ, u8 *cmd);
+	int (*send_cmd)(struct occ *occ, u8 *cmd, size_t len);
 
 	unsigned long next_update;
 	struct mutex lock;		/* lock OCC access */
diff --git a/drivers/hwmon/occ/p8_i2c.c b/drivers/hwmon/occ/p8_i2c.c
index 0cf8588be35a..9e61e1fb5142 100644
--- a/drivers/hwmon/occ/p8_i2c.c
+++ b/drivers/hwmon/occ/p8_i2c.c
@@ -97,18 +97,21 @@ static int p8_i2c_occ_putscom_u32(struct i2c_client *client, u32 address,
 }
 
 static int p8_i2c_occ_putscom_be(struct i2c_client *client, u32 address,
-				 u8 *data)
+				 u8 *data, size_t len)
 {
-	__be32 data0, data1;
+	__be32 data0 = 0, data1 = 0;
 
-	memcpy(&data0, data, 4);
-	memcpy(&data1, data + 4, 4);
+	memcpy(&data0, data, min_t(size_t, len, 4));
+	if (len > 4) {
+		len -= 4;
+		memcpy(&data1, data + 4, min_t(size_t, len, 4));
+	}
 
 	return p8_i2c_occ_putscom_u32(client, address, be32_to_cpu(data0),
 				      be32_to_cpu(data1));
 }
 
-static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd)
+static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len)
 {
 	int i, rc;
 	unsigned long start;
@@ -127,7 +130,7 @@ static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd)
 		return rc;
 
 	/* write command (expected to already be BE), we need bus-endian... */
-	rc = p8_i2c_occ_putscom_be(client, OCB_DATA3, cmd);
+	rc = p8_i2c_occ_putscom_be(client, OCB_DATA3, cmd, len);
 	if (rc)
 		return rc;
 
diff --git a/drivers/hwmon/occ/p9_sbe.c b/drivers/hwmon/occ/p9_sbe.c
index f6387cc0b754..9709f2b9c052 100644
--- a/drivers/hwmon/occ/p9_sbe.c
+++ b/drivers/hwmon/occ/p9_sbe.c
@@ -16,14 +16,14 @@ struct p9_sbe_occ {
 
 #define to_p9_sbe_occ(x)	container_of((x), struct p9_sbe_occ, occ)
 
-static int p9_sbe_occ_send_cmd(struct occ *occ, u8 *cmd)
+static int p9_sbe_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len)
 {
 	struct occ_response *resp = &occ->resp;
 	struct p9_sbe_occ *ctx = to_p9_sbe_occ(occ);
 	size_t resp_len = sizeof(*resp);
 	int rc;
 
-	rc = fsi_occ_submit(ctx->sbe, cmd, 8, resp, &resp_len);
+	rc = fsi_occ_submit(ctx->sbe, cmd, len, resp, &resp_len);
 	if (rc < 0)
 		return rc;
 
-- 
2.35.1



