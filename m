Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43885EC26E
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 14:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbiI0MUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 08:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbiI0MUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 08:20:19 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81FDDF3AE;
        Tue, 27 Sep 2022 05:18:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHkZpkGDAiKtsgecJTdxaHRSPL93QOe2Dr9jHvHRsMMUayfll6kmuY+Jvq25+SyI8PZ1ThyhU2nlSrdACn7npeE1OzsN7Dmb6jE1j/1kUu0QOATNh53v6ke5bXog2m9SwZEFjPgPhwz4mkZXNmbWGmU945mdNo5YRS2eS/hHi4e9DCPzogS+A9OEB7m/ddNX7xtfy3tMlDCmrOrp2hfvCzoxMna8haO+AF4KAqANQOmtmxlfXo5Xr1NDwpwDx3zeLAQ9dU7QQ1TeSqeIV/2UA5jsXsUWeQUx189VmNzFTnVoO6Y/vf7jcjFshsfaxM+JLPZ88TMahAArpHXblZPx8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ndweqxUWS4OT2TtA0ZtD5mooARzloUJrdcHqJX88l38=;
 b=AyZNdh/U4hco3CVW27t+pGRtKl7u13hDXsnakkF/+HYmaZd2D9qhL6pf2zifMApRNp+jtNQaeHXGrtTltJkBNGC0aHgMjHT2S6t1G2M3XKVhLEKQDVnw9xo1f6DUrY0wDRD+1tjLWiEmEOIXS4aqxnW4y8ULe2jGPmfL1epNM+BFjE5VOqYbZDh9GVq1EqYpInl6N1txb2hIyc+qwrj5CB/Jwi1Ruw5oudyJOIK0M2AzDIERdjEkMnzyhTVrUY0M5m8KnVy2Kx0fih+rGYYQ+FjQBZE5JfIPTV6In57EHI6/jc3xJu1xg0elN+grqfNi9AZWN6NNQvOpVfV3D5re9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndweqxUWS4OT2TtA0ZtD5mooARzloUJrdcHqJX88l38=;
 b=jsGzvnSFq9wq7Iqh0dNCVZuOwcQrrOYjUe+PZs3gOpwE5qSoPPhCDaA1QeijaNIu7p7bd2gMxUns9FvQhsprq+2piL175tQthB2te9URZKFMRGpqvVLHQ64W7yVTRu/I5zid2Myx7sgmk1tgpF3+j8WK1Kx0gkgYDfX5i4DpKeLn/nHJQTFM7U7GqYMVmaenSqKeynmLhnnKVf08yMj0qimsQu54E+za0U9oh8duOI05u6OhCnYu5FtoXV02RRaoza5Nn1F5EVy9hnVX9SqrwrLQTnTcjbGSgo3XPu9k6rS+Frs5uSXBNYqfN+/gHSZZmAOt4I9IRm2YxSvFfdRppQ==
Received: from BN9PR03CA0929.namprd03.prod.outlook.com (2603:10b6:408:107::34)
 by IA1PR12MB6435.namprd12.prod.outlook.com (2603:10b6:208:3ad::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Tue, 27 Sep
 2022 12:18:45 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::37) by BN9PR03CA0929.outlook.office365.com
 (2603:10b6:408:107::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26 via Frontend
 Transport; Tue, 27 Sep 2022 12:18:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.14 via Frontend Transport; Tue, 27 Sep 2022 12:18:45 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 27 Sep
 2022 05:18:35 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 27 Sep
 2022 05:18:35 -0700
Received: from waynec-Precision-5760.nvidia.com (10.127.8.13) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Tue, 27 Sep 2022 05:18:33 -0700
From:   Wayne Chang <waynec@nvidia.com>
To:     <heikki.krogerus@linux.intel.com>, <gregkh@linuxfoundation.org>
CC:     <quic_linyyuan@quicinc.com>, <quic_jackp@quicinc.com>,
        <saranya.gopal@intel.com>, <tiwai@suse.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <waynec@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/1] usb: typec: ucsi: Don't warn on probe deferral
Date:   Tue, 27 Sep 2022 20:18:07 +0800
Message-ID: <20220927121807.2471422-1-waynec@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT014:EE_|IA1PR12MB6435:EE_
X-MS-Office365-Filtering-Correlation-Id: 42230363-6695-4f73-c5cb-08daa0826c82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gqtl7LrWU9ccgNnRMolnKqAc4MJ1C4g9hpEOqQMb8lk52mI582B0y06gO3MpCdR4aDlo/0kLLAsphVdJbv5EIlokkHGMh1c6kugYYM+p/yCFU8TmWPqHcP5XrIjbVaJQostQtGUZI5sde+7wnfkPoY8Gr95WtOy+wkC7jsAh24HZ88hTn8BHDlMSXz1DLlVsMqq8xSPwD6jmwqAAS6CYD9MfzjPeySawRrHRv24Eu6gccK10F5EAtKRRUVbzV9qjzLBHKq7k6zHJkbiwOwDDpFQPfst0RX588bIothutn1m7/Q85gokS95XI0lwM/ZC8oiaBf5gzhsAwomaGoTR1LATavHb/xA5r4hSuzxx1qoboocZXV4fppZUWt6DPhuffdeDfBuwT8GbkFYrj9W5nRaFxxlTNh3otEvEUCoIYXzxkx8nqvyyrh2aar78c6T/ikwS7NOymhZUXWWKsPzHse4b7omvDcq5f1D0gaXhRL+GmND+V9uBmF1KR03KTdbcKhuIipJOAfA9Jcrd1WB1/L+mEgO1Iik5XFMbxpSaEU3PkPqeE0xvvh9Yqij0mJxbVmi8lZX2iG3pUBMVEQvweouHG1ZphReNLIdeQ9que7EfJElt7dE4sFynH4v2wBWimG/Tm4Wvr+Aru93+kSXLS1pPM1LMfP82f+YTCT93X9QLIBwYcRL5GepMW9jlCwlVA9uEtZ2vI2+2Bidff8hLvRluYPuNZ2chPgJok1X9hoVVdhKTKnrJeN72jPrjlpFCSDTJ7oNqw+9DKwc6hrMFzAw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(36756003)(478600001)(66899015)(83380400001)(36860700001)(5660300002)(47076005)(82740400003)(2616005)(426003)(1076003)(336012)(356005)(186003)(86362001)(7636003)(40480700001)(6666004)(7696005)(26005)(110136005)(316002)(8936002)(54906003)(40460700003)(41300700001)(8676002)(4326008)(70586007)(70206006)(2906002)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 12:18:45.1017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42230363-6695-4f73-c5cb-08daa0826c82
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6435
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
 drivers/usb/typec/ucsi/ucsi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 7f2624f42724..45a4374e9baa 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1069,11 +1069,10 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 
 	cap->fwnode = ucsi_find_fwnode(con);
 	con->usb_role_sw = fwnode_usb_role_switch_get(cap->fwnode);
-	if (IS_ERR(con->usb_role_sw)) {
-		dev_err(ucsi->dev, "con%d: failed to get usb role switch\n",
+	if (IS_ERR(con->usb_role_sw))
+		return dev_err_probe(ucsi->dev, PTR_ERR(con->usb_role_sw),
+			"con%d: failed to get usb role switch\n",
 			con->num);
-		return PTR_ERR(con->usb_role_sw);
-	}
 
 	/* Delay other interactions with the con until registration is complete */
 	mutex_lock(&con->lock);
-- 
2.25.1

