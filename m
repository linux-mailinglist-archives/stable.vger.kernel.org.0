Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF93136B9E5
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 21:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbhDZTTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 15:19:37 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:30299 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239804AbhDZTTh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 15:19:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619464735; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=d19V215dGXqIKoS4xGzQ54lVR378nkYn0Qrw7sz10tw=; b=BXIm+zQW4HoSSRem0oO06T/51PG95I7+fRpVnIUdzheDX7m1LXNOM9A4AAt4KFYB1hnS42CP
 UcDwac4U+KE4WrhP0pUsSY8e0z5GPpbNe5sOhbb1iLN7tmX4nMoaCoZtv/p2vVG6aCGCvKsC
 l10w28eiSfQub5UjdCNxRvzTH7c=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 6087121e87ce1fbb56cbe2bd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 26 Apr 2021 19:18:54
 GMT
Sender: jackp=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E88F7C43460; Mon, 26 Apr 2021 19:18:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from jackp-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jackp)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 99717C4338A;
        Mon, 26 Apr 2021 19:18:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 99717C4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jackp@codeaurora.org
From:   Jack Pham <jackp@codeaurora.org>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Jack Pham <jackp@codeaurora.org>
Subject: [PATCH] usb: typec: ucsi: Retrieve all the PDOs instead of just the first 4
Date:   Mon, 26 Apr 2021 12:18:25 -0700
Message-Id: <20210426191825.30721-1-jackp@codeaurora.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4dbc6a4ef06d ("usb: typec: ucsi: save power data objects
in PD mode") introduced retrieval of the PDOs when connected to a
PD-capable source. But only the first 4 PDOs are received since
that is the maximum number that can be fetched at a time given the
MESSAGE_IN length limitation (16 bytes). However, as per the PD spec
a connected source may advertise up to a maximum of 7 PDOs.

If such a source is connected it's possible the UCSI FW could have
negotiated a power contract with one of the PDOs at index greater
than 4, and would be reflected in the request data object's (RDO)
object position field. This would result in an out-of-bounds access
when the rdo_index() is used to index into the src_pdos array in
ucsi_psy_get_voltage_now().

We can resolve this by instead retrieving and storing up to the
maximum of 7 PDOs in the con->src_pdos array. This would involve
two calls to the GET_PDOS command.

Fixes: 992a60ed0d5e ("usb: typec: ucsi: register with power_supply class")
Fixes: 4dbc6a4ef06d ("usb: typec: ucsi: save power data objects in PD mode")
Cc: stable@vger.kernel.org
Signed-off-by: Jack Pham <jackp@codeaurora.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 41 +++++++++++++++++++++++++++--------
 drivers/usb/typec/ucsi/ucsi.h |  6 +++--
 2 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 244270755ae6..ac214b855986 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -495,7 +495,8 @@ static void ucsi_unregister_altmodes(struct ucsi_connector *con, u8 recipient)
 	}
 }
 
-static void ucsi_get_pdos(struct ucsi_connector *con, int is_partner)
+static int ucsi_get_pdos(struct ucsi_connector *con, int is_partner,
+		u32 *pdos, int offset, int num_pdos)
 {
 	struct ucsi *ucsi = con->ucsi;
 	u64 command;
@@ -503,17 +504,39 @@ static void ucsi_get_pdos(struct ucsi_connector *con, int is_partner)
 
 	command = UCSI_COMMAND(UCSI_GET_PDOS) | UCSI_CONNECTOR_NUMBER(con->num);
 	command |= UCSI_GET_PDOS_PARTNER_PDO(is_partner);
-	command |= UCSI_GET_PDOS_NUM_PDOS(UCSI_MAX_PDOS - 1);
+	command |= UCSI_GET_PDOS_PDO_OFFSET(offset);
+	command |= UCSI_GET_PDOS_NUM_PDOS(num_pdos - 1);
 	command |= UCSI_GET_PDOS_SRC_PDOS;
-	ret = ucsi_send_command(ucsi, command, con->src_pdos,
-			       sizeof(con->src_pdos));
-	if (ret < 0) {
+	ret = ucsi_send_command(ucsi, command, pdos + offset,
+			num_pdos * sizeof(u32));
+	if (ret < 0)
 		dev_err(ucsi->dev, "UCSI_GET_PDOS failed (%d)\n", ret);
+	if (ret == 0 && offset == 0)
+		dev_warn(ucsi->dev, "UCSI_GET_PDOS returned 0 bytes\n");
+
+	return ret;
+}
+
+static void ucsi_get_src_pdos(struct ucsi_connector *con, int is_partner)
+{
+	int ret;
+
+	/* UCSI max payload means only getting at most 4 PDOs at a time */
+	ret = ucsi_get_pdos(con, 1, con->src_pdos, 0, UCSI_MAX_PDOS);
+	if (ret < 0)
 		return;
-	}
+
 	con->num_pdos = ret / sizeof(u32); /* number of bytes to 32-bit PDOs */
-	if (ret == 0)
-		dev_warn(ucsi->dev, "UCSI_GET_PDOS returned 0 bytes\n");
+	if (con->num_pdos < UCSI_MAX_PDOS)
+		return;
+
+	/* get the remaining PDOs, if any */
+	ret = ucsi_get_pdos(con, 1, con->src_pdos, UCSI_MAX_PDOS,
+			PDO_MAX_OBJECTS - UCSI_MAX_PDOS);
+	if (ret < 0)
+		return;
+
+	con->num_pdos += ret / sizeof(u32);
 }
 
 static void ucsi_pwr_opmode_change(struct ucsi_connector *con)
@@ -522,7 +545,7 @@ static void ucsi_pwr_opmode_change(struct ucsi_connector *con)
 	case UCSI_CONSTAT_PWR_OPMODE_PD:
 		con->rdo = con->status.request_data_obj;
 		typec_set_pwr_opmode(con->port, TYPEC_PWR_MODE_PD);
-		ucsi_get_pdos(con, 1);
+		ucsi_get_src_pdos(con, 1);
 		break;
 	case UCSI_CONSTAT_PWR_OPMODE_TYPEC1_5:
 		con->rdo = 0;
diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index 3920e20a9e9e..cee666790907 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -8,6 +8,7 @@
 #include <linux/power_supply.h>
 #include <linux/types.h>
 #include <linux/usb/typec.h>
+#include <linux/usb/pd.h>
 #include <linux/usb/role.h>
 
 /* -------------------------------------------------------------------------- */
@@ -134,7 +135,9 @@ void ucsi_connector_change(struct ucsi *ucsi, u8 num);
 
 /* GET_PDOS command bits */
 #define UCSI_GET_PDOS_PARTNER_PDO(_r_)		((u64)(_r_) << 23)
+#define UCSI_GET_PDOS_PDO_OFFSET(_r_)		((u64)(_r_) << 24)
 #define UCSI_GET_PDOS_NUM_PDOS(_r_)		((u64)(_r_) << 32)
+#define UCSI_MAX_PDOS				(4)
 #define UCSI_GET_PDOS_SRC_PDOS			((u64)1 << 34)
 
 /* -------------------------------------------------------------------------- */
@@ -302,7 +305,6 @@ struct ucsi {
 
 #define UCSI_MAX_SVID		5
 #define UCSI_MAX_ALTMODES	(UCSI_MAX_SVID * 6)
-#define UCSI_MAX_PDOS		(4)
 
 #define UCSI_TYPEC_VSAFE5V	5000
 #define UCSI_TYPEC_1_5_CURRENT	1500
@@ -330,7 +332,7 @@ struct ucsi_connector {
 	struct power_supply *psy;
 	struct power_supply_desc psy_desc;
 	u32 rdo;
-	u32 src_pdos[UCSI_MAX_PDOS];
+	u32 src_pdos[PDO_MAX_OBJECTS];
 	int num_pdos;
 
 	struct usb_role_switch *usb_role_sw;
-- 
2.24.0

