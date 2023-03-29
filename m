Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDE66CD3EF
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 10:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjC2IE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 04:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjC2IE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 04:04:28 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFA31FE7
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 01:04:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yzs75Ek6dA+LIcaaSrIGCpsYJdPfIeozJyL9rDK6qAa8MHUhUVM0n5fzJUs75Srudi9Ci+27SILguGKWDVqVqX9xm+JouQ2hOSOObR3brZikQaFraozR/dmQuKEtLngDjapLxxTv6edU/v03v+pGBfHH4Ug7NFZ3XoVZsU/4C+33gLMD1u7VOmlfq6EIMamKrguetcI4CaBQV+mooAkgXSFVCqThMERwMNpKSk+bZeGAt4veNjYz7YkIdoYGB7JKhh1k+v7rwIS0Fp6Uuz7pOZhxKpov3ZXLYCiWgDWJrphiST4kEn0AyBjObkqtLiKuAVQ+iBiWMwt9ZsfySQZ0Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VMctb8oYf/jWGQtaZza/DSaJjqOzioGW62qU4VAPqZk=;
 b=U9SFmja6T+TY0GFXtKDqTdbY89X+RcVVfm13qG3Vgr24tyyz7ECbyWPNcZf9Mido+JBzo6LH1xNhw9oDdoQqvn5865+uzYsQV/y2iCKVJQTZdRDRcrIiOphHnsYC7gz9SdX8XcKkR3aljF2uqIBbWXKGkXyMCStYQgmW9pN53QQgilOOOJo4sXrFIiTcAXyq6pPZb3eU2aZJxdjDgDbo7U7oli2MIz9/SWBSReo6GNOQ43rPs9r4WT0pQYJaGF0nfBH4ODbqkPuGAB0vqttFoiqS0UEu/nBaVJdXnvffeoWj2CaKOZW7BUb3LWQqBWF/MrU//VqYRslLMvuG8by/EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 8.4.225.30) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=infinera.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=infinera.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMctb8oYf/jWGQtaZza/DSaJjqOzioGW62qU4VAPqZk=;
 b=jaMmFmOREVmHhzkAT5QmD8P9NnZFDoIwIfaxnOrJQrhNt2SbvJmlRMa2uRd770q5n64+oAFpVUcr/esyCjQvs6noaO9i/KG8Xf05XIX2TSajKTvUCC8yTCVSDvDTUQOSpH4J0ChsruXhe5n6eJO8CNIhbfcobzrSLBUiZ9YWo1JqpvZbgelERwCfq2lmdUSEQqtdOofSB4HLPXzg5jIHu2ec9sbmeah8nDoT5XexdqMubngoie052/CKvbFlAB213pW3p8pYqFds4oXVCsDnHhf508v/lmyB+qHHMH1TakqdB0hYTFV7eLbyxTdLJAXd9+wVN/FLvGatoTTgPO1ZQQ==
Received: from BN1PR12CA0001.namprd12.prod.outlook.com (2603:10b6:408:e1::6)
 by BY5PR10MB4132.namprd10.prod.outlook.com (2603:10b6:a03:20b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 08:04:23 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::6) by BN1PR12CA0001.outlook.office365.com
 (2603:10b6:408:e1::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.43 via Frontend
 Transport; Wed, 29 Mar 2023 08:04:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 8.4.225.30)
 smtp.mailfrom=infinera.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=infinera.com;
Received-SPF: Pass (protection.outlook.com: domain of infinera.com designates
 8.4.225.30 as permitted sender) receiver=protection.outlook.com;
 client-ip=8.4.225.30; helo=owa.infinera.com; pr=C
Received: from owa.infinera.com (8.4.225.30) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.20 via Frontend Transport; Wed, 29 Mar 2023 08:04:23 +0000
Received: from sv-ex16-prd.infinera.com (10.100.96.229) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 29 Mar 2023 01:04:19 -0700
Received: from sv-smtp-prod2.infinera.com (10.100.98.82) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 29 Mar 2023 01:04:19 -0700
Received: from se-metroit-prd1.infinera.com ([10.210.32.58]) by sv-smtp-prod2.infinera.com with Microsoft SMTPSVC(7.5.7601.17514);
         Wed, 29 Mar 2023 01:04:19 -0700
Received: from gentoo-jocke.infinera.com (gentoo-jocke.infinera.com [10.210.71.2])
        by se-metroit-prd1.infinera.com (Postfix) with ESMTP id D396C2C06D80;
        Wed, 29 Mar 2023 10:04:18 +0200 (CEST)
Received: by gentoo-jocke.infinera.com (Postfix, from userid 1001)
        id CCCDE127D2; Wed, 29 Mar 2023 10:04:18 +0200 (CEST)
From:   Joakim Tjernlund <joakim.tjernlund@infinera.com>
To:     <stable@vger.kernel.org>
CC:     Hans de Goede <hdegoede@redhat.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joakim Tjernlund <joakim.tjernlund@infinera.com>
Subject: [PATCH] usb: ucsi: Fix ucsi->connector race
Date:   Wed, 29 Mar 2023 10:03:58 +0200
Message-ID: <20230329080358.29193-1-joakim.tjernlund@infinera.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <16800048817970@kroah.com>
References: <16800048817970@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Mar 2023 08:04:19.0575 (UTC) FILETIME=[108E8070:01D96215]
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT031:EE_|BY5PR10MB4132:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b53ee2c-f0f4-485c-9b90-08db302c3540
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LHlhPhtfB7xIV5YgMSc7/yQOi/02SMhHFmPWSvRqovvq7wqH3V4bbxYpzkWgx6lVn2ryasIEabhJ0x2C91KeT8FAVA8isvytb2pyNXJ6lJKO70s1s2/knpJ88CpP8W50d+gFI+hDQP/j0bgkrvqpIHCV+c70uI7z1pv5qCeeCbx28u9g1tceQ1dcl9cGdzUU/agjipDN+IbgYXZj07fHa5KkRjRE+3UDKCSHP5lf/Y74/FrOBDPy2SuABOjA2gRsZsMFoogCj36UqeqSSiHbPkqvzH9O08/J3LnSEuttz65PKvewos3YeO9YJNqPcgdcLUnvPAA6gDDCStJhJ4pvFJikgrMFklcoiwK+0Cq5B+p/9nN2bFCCUUkzckdRnwq3PdpLpiA/HvVG0zkv8z87XCaFVJnzr30MGA2oM1zI8HpsK1mFXrEjpRU+7qzRGdYqE6rgpIVZCKZVmSVS9JED8g7fAbXnqaIK5l8SETVFj94sgS7Wz1WNWQoUOX9iClBs6KGow1vnFy+dPTEA/epJwD8Qf1tXNWHju2ttQqGcH7sCrNjRfgZmnYTn6hLm79vmMXfESbZ/WhxIfiVpvZtUAp+0x34P05/nXnU9uxexXYMVP6srzhk7TSTmMyPBYRQsXw5MCIN6BLhjLPAhFEmdi1mWb0V7HWK6pmhhD2c7aKo2kZdbG1WxuXKhD6ZYiRE1
X-Forefront-Antispam-Report: CIP:8.4.225.30;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:owa.infinera.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39850400004)(136003)(346002)(376002)(451199021)(36840700001)(46966006)(40480700001)(36860700001)(42186006)(54906003)(8676002)(6916009)(4326008)(356005)(81166007)(41300700001)(82740400003)(70206006)(70586007)(316002)(6266002)(186003)(26005)(1076003)(83380400001)(426003)(336012)(47076005)(2616005)(966005)(478600001)(107886003)(6666004)(86362001)(82310400005)(36756003)(44832011)(2906002)(5660300002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 08:04:23.1615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b53ee2c-f0f4-485c-9b90-08db302c3540
X-MS-Exchange-CrossTenant-Id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=285643de-5f5b-4b03-a153-0ae2dc8aaf77;Ip=[8.4.225.30];Helo=[owa.infinera.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4132
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

ucsi_init() which runs from a workqueue sets ucsi->connector and
on an error will clear it again.

ucsi->connector gets dereferenced by ucsi_resume(), this checks for
ucsi->connector being NULL in case ucsi_init() has not finished yet;
or in case ucsi_init() has failed.

ucsi_init() setting ucsi->connector and then clearing it again on
an error creates a race where the check in ucsi_resume() may pass,
only to have ucsi->connector free-ed underneath it when ucsi_init()
hits an error.

Fix this race by making ucsi_init() store the connector array in
a local variable and only assign it to ucsi->connector on success.

Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
Cc: stable@vger.kernel.org
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230308154244.722337-3-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 0482c34ec6f8557e06cd0f8e2d0e20e8ede6a22c)
Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
---

 - This is a dry port to 6.1.x, will be some time before it will be tested.

 drivers/usb/typec/ucsi/ucsi.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 8cbbb002fefe..086b50968983 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1039,9 +1039,8 @@ static struct fwnode_handle *ucsi_find_fwnode(struct ucsi_connector *con)
 	return NULL;
 }
 
-static int ucsi_register_port(struct ucsi *ucsi, int index)
+static int ucsi_register_port(struct ucsi *ucsi, struct ucsi_connector *con)
 {
-	struct ucsi_connector *con = &ucsi->connector[index];
 	struct typec_capability *cap = &con->typec_cap;
 	enum typec_accessory *accessory = cap->accessory;
 	enum usb_role u_role = USB_ROLE_NONE;
@@ -1062,7 +1061,6 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 	init_completion(&con->complete);
 	mutex_init(&con->lock);
 	INIT_LIST_HEAD(&con->partner_tasks);
-	con->num = index + 1;
 	con->ucsi = ucsi;
 
 	cap->fwnode = ucsi_find_fwnode(con);
@@ -1204,7 +1202,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
  */
 static int ucsi_init(struct ucsi *ucsi)
 {
-	struct ucsi_connector *con;
+	struct ucsi_connector *con, *connector;
 	u64 command, ntfy;
 	int ret;
 	int i;
@@ -1235,16 +1233,16 @@ static int ucsi_init(struct ucsi *ucsi)
 	}
 
 	/* Allocate the connectors. Released in ucsi_unregister() */
-	ucsi->connector = kcalloc(ucsi->cap.num_connectors + 1,
-				  sizeof(*ucsi->connector), GFP_KERNEL);
-	if (!ucsi->connector) {
+	connector = kcalloc(ucsi->cap.num_connectors + 1, sizeof(*connector), GFP_KERNEL);
+	if (!connector) {
 		ret = -ENOMEM;
 		goto err_reset;
 	}
 
 	/* Register all connectors */
 	for (i = 0; i < ucsi->cap.num_connectors; i++) {
-		ret = ucsi_register_port(ucsi, i);
+		connector[i].num = i + 1;
+		ret = ucsi_register_port(ucsi, &connector[i]);
 		if (ret)
 			goto err_unregister;
 	}
@@ -1256,11 +1254,12 @@ static int ucsi_init(struct ucsi *ucsi)
 	if (ret < 0)
 		goto err_unregister;
 
+	ucsi->connector = connector;
 	ucsi->ntfy = ntfy;
 	return 0;
 
 err_unregister:
-	for (con = ucsi->connector; con->port; con++) {
+	for (con = connector; con->port; con++) {
 		ucsi_unregister_partner(con);
 		ucsi_unregister_altmodes(con, UCSI_RECIPIENT_CON);
 		ucsi_unregister_port_psy(con);
@@ -1269,10 +1268,7 @@ static int ucsi_init(struct ucsi *ucsi)
 		typec_unregister_port(con->port);
 		con->port = NULL;
 	}
-
-	kfree(ucsi->connector);
-	ucsi->connector = NULL;
-
+	kfree(connector);
 err_reset:
 	memset(&ucsi->cap, 0, sizeof(ucsi->cap));
 	ucsi_reset_ppm(ucsi);
-- 
2.39.1

