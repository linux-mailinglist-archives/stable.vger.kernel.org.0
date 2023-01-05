Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C99A65E4A1
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 05:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjAEETT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 23:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjAEETE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 23:19:04 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8526B38BD;
        Wed,  4 Jan 2023 20:19:03 -0800 (PST)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305438b1017380;
        Thu, 5 Jan 2023 04:19:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=EIz1r3weYrMpVmqjXDa8LiM8O69EPji0OVAxdkWrPQ8=;
 b=fz6oBuXvGxcUVee6K9EP3ykTL2dewleJny8cWgev8JT1YIRCLA5J8MlM885iGQ185BPW
 FEkXZTxqd8FNyIYfMToZUt7jTLRshAGbj+eDPZ8psPM8jMTE5AVWJr8TlV5lrDGPZYPy
 x5hkE1qJ3JtRZQWnbTXNiMhlhJtmZOz5DUSBASND49iwtI8E79YKUVO19G5ydzobzeQG
 OB8MNY/Ky6N8mgO8IidI0DDEWSHFxsgoIR9YgMB9E7LE9jk/sIR5D/mdwrGiXhKrKvZa
 5kYeqvQEIo9uIlsBNxNWj65HhikyZLdBQxBq4nR/6T6fRgJZEdetF2ZLzfr/wm40AOTc Iw== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3mvsvwugmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 04:19:00 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3054IxsZ032384
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 5 Jan 2023 04:18:59 GMT
Received: from linyyuan-gv.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 4 Jan 2023 20:18:57 -0800
From:   Linyu Yuan <quic_linyyuan@quicinc.com>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-usb@vger.kernel.org>, <stable@vger.kernel.org>,
        Jack Pham <quic_jackp@quicinc.com>,
        Wesley Cheng <quic_wcheng@quicinc.com>,
        "Subbaraman Narayanamurthy" <quic_subbaram@quicinc.com>,
        Fenglin Wu <quic_fenglinw@quicinc.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>
Subject: [PATCH] usb: ucsi: fix connector partner ucsi work issue
Date:   Thu, 5 Jan 2023 12:18:44 +0800
Message-ID: <1672892324-12335-1-git-send-email-quic_linyyuan@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: xT8Vu7yHaFquU6cjgJfXrqhKPwzo3ZUz
X-Proofpoint-ORIG-GUID: xT8Vu7yHaFquU6cjgJfXrqhKPwzo3ZUz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxlogscore=840 phishscore=0 clxscore=1011 malwarescore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050034
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When ucsi unregister, it will destroy connector work queue, but a pending
delay work may still exist, once delay timer expire, as work queue
destroyed, it will cause system crash.

Move all partner related delay work to connector instance and cancel all
of them when ucsi unregister happen.

Fixes: b9aa02c ("usb: typec: ucsi: Add polling mechanism for partner tasks like alt mode checking")
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
---
 drivers/usb/typec/ucsi/ucsi.c | 61 +++++++++++++++++++++++++------------------
 drivers/usb/typec/ucsi/ucsi.h | 11 ++++++++
 2 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index eabe519..f6b23e9 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -185,14 +185,6 @@ EXPORT_SYMBOL_GPL(ucsi_send_command);
 
 /* -------------------------------------------------------------------------- */
 
-struct ucsi_work {
-	struct delayed_work work;
-	unsigned long delay;
-	unsigned int count;
-	struct ucsi_connector *con;
-	int (*cb)(struct ucsi_connector *);
-};
-
 static void ucsi_poll_worker(struct work_struct *work)
 {
 	struct ucsi_work *uwork = container_of(work, struct ucsi_work, work.work);
@@ -203,7 +195,6 @@ static void ucsi_poll_worker(struct work_struct *work)
 
 	if (!con->partner) {
 		mutex_unlock(&con->lock);
-		kfree(uwork);
 		return;
 	}
 
@@ -211,30 +202,20 @@ static void ucsi_poll_worker(struct work_struct *work)
 
 	if (uwork->count-- && (ret == -EBUSY || ret == -ETIMEDOUT))
 		queue_delayed_work(con->wq, &uwork->work, uwork->delay);
-	else
-		kfree(uwork);
 
 	mutex_unlock(&con->lock);
 }
 
-static int ucsi_partner_task(struct ucsi_connector *con,
-			     int (*cb)(struct ucsi_connector *),
+static int ucsi_partner_task(struct ucsi_work *uwork,
 			     int retries, unsigned long delay)
 {
-	struct ucsi_work *uwork;
+	struct ucsi_connector *con = uwork->con;
 
 	if (!con->partner)
 		return 0;
 
-	uwork = kzalloc(sizeof(*uwork), GFP_KERNEL);
-	if (!uwork)
-		return -ENOMEM;
-
-	INIT_DELAYED_WORK(&uwork->work, ucsi_poll_worker);
 	uwork->count = retries;
 	uwork->delay = delay;
-	uwork->con = con;
-	uwork->cb = cb;
 
 	queue_delayed_work(con->wq, &uwork->work, delay);
 
@@ -636,8 +617,8 @@ static void ucsi_pwr_opmode_change(struct ucsi_connector *con)
 	case UCSI_CONSTAT_PWR_OPMODE_PD:
 		con->rdo = con->status.request_data_obj;
 		typec_set_pwr_opmode(con->port, TYPEC_PWR_MODE_PD);
-		ucsi_partner_task(con, ucsi_get_src_pdos, 30, 0);
-		ucsi_partner_task(con, ucsi_check_altmodes, 30, 0);
+		ucsi_partner_task(&con->pdos_work, 30, 0);
+		ucsi_partner_task(&con->altmodes_work, 30, 0);
 		break;
 	case UCSI_CONSTAT_PWR_OPMODE_TYPEC1_5:
 		con->rdo = 0;
@@ -799,7 +780,7 @@ static void ucsi_handle_connector_change(struct work_struct *work)
 
 		if (con->status.flags & UCSI_CONSTAT_CONNECTED) {
 			ucsi_register_partner(con);
-			ucsi_partner_task(con, ucsi_check_connection, 1, HZ);
+			ucsi_partner_task(&con->connection_work, 1, HZ);
 		} else {
 			ucsi_unregister_partner(con);
 		}
@@ -818,7 +799,7 @@ static void ucsi_handle_connector_change(struct work_struct *work)
 	}
 
 	if (con->status.change & UCSI_CONSTAT_CAM_CHANGE)
-		ucsi_partner_task(con, ucsi_check_altmodes, 1, 0);
+		ucsi_partner_task(&con->altmodes_work, 1, 0);
 
 	clear_bit(EVENT_PENDING, &con->ucsi->flags);
 
@@ -1034,6 +1015,21 @@ static struct fwnode_handle *ucsi_find_fwnode(struct ucsi_connector *con)
 	return NULL;
 }
 
+static void ucsi_partner_task_init(struct ucsi_connector *con)
+{
+	INIT_DELAYED_WORK(&con->connection_work.work, ucsi_poll_worker);
+	con->connection_work.cb = ucsi_check_connection;
+	con->connection_work.con = con;
+
+	INIT_DELAYED_WORK(&con->pdos_work.work, ucsi_poll_worker);
+	con->pdos_work.cb = ucsi_get_src_pdos;
+	con->pdos_work.con = con;
+
+	INIT_DELAYED_WORK(&con->altmodes_work.work, ucsi_poll_worker);
+	con->altmodes_work.cb = ucsi_check_altmodes;
+	con->altmodes_work.con = con;
+}
+
 static int ucsi_register_port(struct ucsi *ucsi, int index)
 {
 	struct ucsi_connector *con = &ucsi->connector[index];
@@ -1053,6 +1049,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 	if (!con->wq)
 		return -ENOMEM;
 
+	ucsi_partner_task_init(con);
 	INIT_WORK(&con->work, ucsi_handle_connector_change);
 	init_completion(&con->complete);
 	mutex_init(&con->lock);
@@ -1287,7 +1284,7 @@ static void ucsi_resume_work(struct work_struct *work)
 
 	for (con = ucsi->connector; con->port; con++) {
 		mutex_lock(&con->lock);
-		ucsi_partner_task(con, ucsi_check_connection, 1, 0);
+		ucsi_partner_task(&con->connection_work, 1, 0);
 		mutex_unlock(&con->lock);
 	}
 }
@@ -1396,6 +1393,17 @@ int ucsi_register(struct ucsi *ucsi)
 }
 EXPORT_SYMBOL_GPL(ucsi_register);
 
+static void ucsi_partner_task_destroy(struct ucsi_connector *con)
+{
+	mutex_lock(&con->lock);
+
+	cancel_delayed_work_sync(&con->connection_work.work);
+	cancel_delayed_work_sync(&con->pdos_work.work);
+	cancel_delayed_work_sync(&con->altmodes_work.work);
+
+	mutex_unlock(&con->lock);
+}
+
 /**
  * ucsi_unregister - Unregister UCSI interface
  * @ucsi: UCSI interface to be unregistered
@@ -1420,6 +1428,7 @@ void ucsi_unregister(struct ucsi *ucsi)
 		ucsi_unregister_altmodes(&ucsi->connector[i],
 					 UCSI_RECIPIENT_CON);
 		ucsi_unregister_port_psy(&ucsi->connector[i]);
+		ucsi_partner_task_destroy(&ucsi->connector[i]);
 		if (ucsi->connector[i].wq)
 			destroy_workqueue(ucsi->connector[i].wq);
 		typec_unregister_port(ucsi->connector[i].port);
diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index c968474..40d39d2 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -314,6 +314,14 @@ struct ucsi {
 #define UCSI_TYPEC_1_5_CURRENT	1500
 #define UCSI_TYPEC_3_0_CURRENT	3000
 
+struct ucsi_work {
+	struct delayed_work work;
+	unsigned long delay;
+	unsigned int count;
+	struct ucsi_connector *con;
+	int (*cb)(struct ucsi_connector *con);
+};
+
 struct ucsi_connector {
 	int num;
 
@@ -322,6 +330,9 @@ struct ucsi_connector {
 	struct work_struct work;
 	struct completion complete;
 	struct workqueue_struct *wq;
+	struct ucsi_work connection_work;
+	struct ucsi_work pdos_work;
+	struct ucsi_work altmodes_work;
 
 	struct typec_port *port;
 	struct typec_partner *partner;
-- 
2.7.4

