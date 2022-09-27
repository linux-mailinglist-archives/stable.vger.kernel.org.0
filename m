Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C905EC2AB
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 14:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiI0M34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 08:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbiI0M3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 08:29:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0EB4D274;
        Tue, 27 Sep 2022 05:29:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0TMPMbF6M54OC4Cfkfe4xN3sR4VTxBt0HlNlqCvqzP0Dyu4T1CZ5V37uZ/begrBs4KYbTuJv8RKfLPq1TUuEz+iNQRAcU+OhyQLcekvtNH4c85HxnyfqXY2bVxK2IL7W/QSwL7uxJdY/W87vU0m3cNzCKhKg19GLXuij0jfyohTOhNj7uQyvNG3rGwSnkSH3z/w43AgKvaNsbmfDeeDEI7XpbuNBhm57r77RHiV+36lDjMEzzfE7NITt85E7FommnZQswu2UsRb5/BnBxAIsmGR1P/x4ikArfNS7Khjfi96VJ1/vmk3RhiMAc4qODpsBWrC8eOhZbvfhfKnXIrjXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3oOU1bDMHQuo8bukxViz0DtMRlBm4SMJYtCrHhB23I=;
 b=lB0KvHpztN0iNm63jV5igOOb9Qiqvi1Fq7ud8D0o/2sT+7f17IkxSfpBQFLGB7LCq7Vk8eqObNvKVduJb6B6gMaPMJiQaH5CTNqYxdof5/S5c8gFbzG8uOkBoDhKrdYa+hBhND+TspxCMH4jlDD/oIFTbdIYCGnqMPRKKMG0E6zcbO681Pmdd930bc5WalTOGMmNDwbVJc+mbtKP/KJfrs3C8Ht7R4D1lY+ET835VwgIEk4tnBHBbKNS8ZG4Aq+rWfZs7wtMgBOgmbTkLItYdjkBnc81SOov2oY2kSzJrQociriXmu9oPWwC5aw/EDndYgvxa6i6S5Q5G03WhgMOmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3oOU1bDMHQuo8bukxViz0DtMRlBm4SMJYtCrHhB23I=;
 b=RsnM54BY0dExVwnTtu+N8bJjTo0uiIlthSNKxvdVcBGFKe8xRJ1CAfv0v24XILjCvkHDlOPyTzvX/Jz7lVfxYkQA3mKINeiAH6a+ioGAt7/hJy8Er1IuKRotiKQEXsS85BVjT71/AH6Av3nEIn4DvfHKghLxNE3Yc4bVUqJtR7eT/zj+QlbarNgI+9rgtXKUQGeQDlwzvEEOlNQtIpfGTxTiUfV+h77WR94d8QJMMVkHQ9lyiD2UApCyfC8Qm44i4zw6KWNaLGAt1m3jH/AE2NirvAKzkGv7TDpoZOu/aycfWaOgILaWi5slr1blxdMReFrwp6nWrR+l7H738YVWfw==
Received: from DM6PR03CA0049.namprd03.prod.outlook.com (2603:10b6:5:100::26)
 by PH7PR12MB5807.namprd12.prod.outlook.com (2603:10b6:510:1d3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Tue, 27 Sep
 2022 12:29:21 +0000
Received: from DM6NAM11FT092.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::22) by DM6PR03CA0049.outlook.office365.com
 (2603:10b6:5:100::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15 via Frontend
 Transport; Tue, 27 Sep 2022 12:29:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT092.mail.protection.outlook.com (10.13.173.44) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.14 via Frontend Transport; Tue, 27 Sep 2022 12:29:21 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 27 Sep
 2022 05:29:16 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 27 Sep 2022 05:29:16 -0700
Received: from waynec-Precision-5760.nvidia.com (10.127.8.13) by
 mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29
 via Frontend Transport; Tue, 27 Sep 2022 05:29:14 -0700
From:   Wayne Chang <waynec@nvidia.com>
To:     <heikki.krogerus@linux.intel.com>, <gregkh@linuxfoundation.org>
CC:     <quic_linyyuan@quicinc.com>, <quic_jackp@quicinc.com>,
        <saranya.gopal@intel.com>, <tiwai@suse.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <waynec@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 1/1] usb: typec: ucsi: Don't warn on probe deferral
Date:   Tue, 27 Sep 2022 20:29:13 +0800
Message-ID: <20220927122913.2642497-1-waynec@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT092:EE_|PH7PR12MB5807:EE_
X-MS-Office365-Filtering-Correlation-Id: f3874d36-af92-406b-ec8d-08daa083e784
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xn5icKbCfiEMBzwHIrmhlQhbmRncHVAXlHHcbwsZipSsiqUrgC6UznSbuZwN0/s8iE2xOPgt+vMdsG3mqNf4ng9QKbfTpW/XS9qHIoU1V9EDBhm4QwLjql55Miba0bKN3K25kceCZMhM7n8CbBhAtTBQ0U/ZdSIrGTZ6LeJoNTaKH7O1vuZ4OErrJ2yCBjwnykoatlW0gTwylwIHUorCQN6sZGy1CFcC91UVhX/Keecf9IyTN6nD/k7p2/LAmwxLeZATn6qJdX65amrRDAN9c8Lq1Khi9O/NhSBXQn/e5OVcSd7TNAXul4Rcy5fGhqSme4E7lTa1WUZVMLaw3T7rKjaJOWKFcr1Hin6ZAvkUv+U+iikvLn+ciDq+5MRJTa3qP53gxU3VE7/ttGDCUFnIoFnHfS7l+X49Z5D3TP9RHuHpKb5XPzYr2KFJLWhiMXBk/AqQ9Svq7SuyiSNbREdu48XuW7GvL3LvlzysmbDuPHK8SxPxkxKp2xCdKMhMfTNrVV7zZyOeu9evbaQXBOJG5M/wSK4b1Arb89StR+2wpspU7vlY/6pYqiUbThN+FCEpyz8NvGHxZYzD9x0MDQwwm8uWDeD9YD0ZQxvVA4kc7Mu2rJswKc4NplFSsccpVwNPDUBXoMbYhwM8mgYS7yE4s6j+Qe+W2eQh0F9KYDJOf7lk74EXYwBm3aIzN1qAJDsQ6LINu6onVEAaIIAveSPyv1fokr0Mtu6w6yfk1SyAyEwmAf3K65keWrcf3HYzfi9koecAatY6StsRNiPy89YzSw==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199015)(46966006)(36840700001)(40470700004)(7696005)(41300700001)(478600001)(47076005)(83380400001)(426003)(5660300002)(40460700003)(186003)(336012)(2906002)(82310400005)(1076003)(26005)(40480700001)(54906003)(110136005)(2616005)(8936002)(70586007)(8676002)(70206006)(316002)(4326008)(82740400003)(7636003)(86362001)(356005)(66899015)(36860700001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 12:29:21.0348
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3874d36-af92-406b-ec8d-08daa083e784
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT092.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5807
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Deferred probe is an expected return value for fwnode_usb_role_switch_get().
Given that the driver deals with it properly, there's no need to output a
warning that may potentially confuse users.

Fixes: 3c162511530c ("usb: typec: ucsi: Wait for the USB role switches")
Cc: stable@vger.kernel.org
Signed-off-by: Wayne Chang <waynec@nvidia.com>
---
V1 -> V2: adjust the coding style for better reading format.
 drivers/usb/typec/ucsi/ucsi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 7f2624f42724..e961ebecd7df 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1069,11 +1069,9 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 
 	cap->fwnode = ucsi_find_fwnode(con);
 	con->usb_role_sw = fwnode_usb_role_switch_get(cap->fwnode);
-	if (IS_ERR(con->usb_role_sw)) {
-		dev_err(ucsi->dev, "con%d: failed to get usb role switch\n",
-			con->num);
-		return PTR_ERR(con->usb_role_sw);
-	}
+	if (IS_ERR(con->usb_role_sw))
+		return dev_err_probe(ucsi->dev, PTR_ERR(con->usb_role_sw),
+			"con%d: failed to get usb role switch\n", con->num);
 
 	/* Delay other interactions with the con until registration is complete */
 	mutex_lock(&con->lock);
-- 
2.25.1

