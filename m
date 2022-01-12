Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6462848C12D
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 10:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352151AbiALJl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 04:41:59 -0500
Received: from mail-co1nam11on2074.outbound.protection.outlook.com ([40.107.220.74]:40097
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349438AbiALJl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jan 2022 04:41:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RA/5/W0u10QQQUiRPHqNlheYxFSIwOvyOkIKEojvcpdt4d+14yA0W5JbifgA4IWgeLtR9ZQ9j7aosb8cxCJ/lJGpDfrHVZD/AWKP5OdZmv9dgV0BMzROnkRt5dKLw3JShCO/EdSlXNzdWAKFbH+5DVPEaTmWNPWvixh1gRhjqQPMXpd1TBXIgVQYT+DDwIt15nfPQqgsJ37LRw03Fi4zbh3WRmtCSc124mlRXGdBkwDMdcS5m7sfx59udkIMgYm8P3YtZ/zfBDjEJ+zEIM+6MRkBkUVkwdihS96L689H/V5tPegzrmCLdQYPU9XhCsL87SrKS/dIM+Uziiv+wPDe7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k665TgVDSm3qXqQSpkMBItG+pMeD8K8C4D1maWqAi2w=;
 b=iXB8ZPa1byw5YSxWiHeY4baFAWe7/baRuHXibUbXgaNc977b8xIiJiH9CPT/knwnOxSLDAsAQL/0StpVnbNpHZRdZ1R0k2UT8DypHFTET9VKCDOsz+51lgOHYoduZ/jU4puEwIoGbLTia9qodtrriCwQb0cEEHmqc/8s7uZScWeBhWjRjQ84ORk/JaUPawwvTWAckiSeS63PiGlhs+aY2IiHTzUG9l8pWpoAq5b0+xOWbL6w0kAUTYvGV7cQAEq/lJEACk5w3wudkclnpHe2BavJ5Wx36e5yr9yRyIA+3J/R6qRk6qEKDrAyA+vs3BQUdzLbxhQYj4e6x/WmEriFjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k665TgVDSm3qXqQSpkMBItG+pMeD8K8C4D1maWqAi2w=;
 b=KXvMtAV9fkpUNFdnXVvNngmdkb2PS8VT73xJkfj9x6LhlfHwPSeMpAunfyjLxUzXF+ZiAHDJZPtFdRNdif1XHiGgPrIR/4w3GKxwHjm5q420bOan77tzISFspNUh3AcCAq87IdR5UBkU4Jjvsx+wheFp4gSteMnztIM4C4ubpxa0KdMHvj4e9aycEIpjUIBnosBT5QWIqLCZBKAVXJIx9Uxwwyp51gIXElhjsoOaGfMPVJvLc0jjZNfyiNF+rE9QkGm4RxrhF68epdAQR1utDovPTE6naIIdO+XF25/0osqiZf+WMxPf/0uEKRcbIVTOG9ka2pzBZS6sZuqKfcSvxw==
Received: from BN0PR08CA0021.namprd08.prod.outlook.com (2603:10b6:408:142::16)
 by CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Wed, 12 Jan
 2022 09:41:57 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::31) by BN0PR08CA0021.outlook.office365.com
 (2603:10b6:408:142::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10 via Frontend
 Transport; Wed, 12 Jan 2022 09:41:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4867.9 via Frontend Transport; Wed, 12 Jan 2022 09:41:56 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 12 Jan
 2022 09:41:46 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 12 Jan
 2022 09:41:46 +0000
Received: from waynec-Precision-5760.nvidia.com (10.127.8.13) by
 mail.nvidia.com (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Wed, 12 Jan 2022 09:41:44 +0000
From:   Wayne Chang <waynec@nvidia.com>
To:     <heikki.krogerus@linux.intel.com>, <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <singhanc@nvidia.com>, <waynec@nvidia.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v5 1/1] ucsi_ccg: Check DEV_INT bit only when starting CCG4
Date:   Wed, 12 Jan 2022 17:41:43 +0800
Message-ID: <20220112094143.628610-1-waynec@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f1fd480-55c7-487c-2fb0-08d9d5afc623
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB5001CB1B1AA34C7F3F10B517AF529@CH2PR12MB5001.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tFuMQfNy/8S2qRvjppGln7tCfvaIJijPPGcyzEfRvztmMM4vZOMbvlGbGiFbfrrwvBjYVffh6dlxlRIDE+3zJkpVy1bLC5NjBQBncgp3AgnFBiLx+BAnDhXSh6Xpp/jBX0SPBrPAfQka5mTbE6XaQ5OYlQIEj16T03Wi1jhccQiKSw2UY6nwKEa2/patXYNQ6QzGVQhopibRUu0h2kKdvAYqfDyI8dIJFv7UV9h1l6lTsbraE3oRxi7Y/7J0yoKThsOJFbI+ygk7HisJuZlL20BjZDXjPBSdYEJI5ZyWDsfKMGJ+3qYY5bccrOIChf0qXb8tfE5ueaK5HU8DUMo5+dJl2e8AZJ/WN2l7tVoGpWYSp/x+nE0HcjnD9o75Z2DDYsVDDeDGTQnD7XYc0FLV2ialhj0xpuks6rZbC/ekT6hJOlUp6a3DmSb2dEDPxwj49KBgecqQtwbTsaYpwmyI9OtArd5hk3b7eEX7UQcedMRWQIQzWh5Q3iHr14/kamjjaYu5a1YRnyegcaUI/s56zHbTNNtX5Y+jEsK+qaKPpy1Hm5E90n82sOkEChFy0wnY58yjibajxiAqCjRnB0s3vyicOkavipsk+JuBZ0tN3FIhhAH3jUhg4IaCiVCdUJiSil+4z2R1yTOtwqV832/qfsGdSegjseIvPzXKORd+xmUPH7Y6KGGkw0Zqk58dhYybKQRJF7EShILgqnpwDTQXb4EmqKy/4OXv7LnRkov8CY0VFf5Ry9HSNJNO8g9lAGm2H50FepQNcB8MBxrnNgjlyK80h65xwlrXcAEXozUOweI=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(8676002)(40460700001)(5660300002)(47076005)(70206006)(356005)(110136005)(508600001)(81166007)(2906002)(83380400001)(36756003)(316002)(86362001)(70586007)(82310400004)(2616005)(186003)(4326008)(36860700001)(54906003)(336012)(8936002)(426003)(1076003)(7696005)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 09:41:56.8105
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1fd480-55c7-487c-2fb0-08d9d5afc623
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5001
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sing-Han Chen <singhanc@nvidia.com>

CCGx clears Bit 0:Device Interrupt in the INTR_REG
if CCGx is reset successfully. However, there might
be a chance that other bits in INTR_REG are not
cleared due to internal data queued in PPM. This case
misleads the driver that CCGx reset failed.

The commit checks bit 0 in INTR_REG and ignores other
bits. The ucsi driver would reset PPM later.

Fixes: 247c554a14aa ("usb: typec: ucsi: add support for Cypress CCGx")
Cc: stable@vger.kernel.org
Signed-off-by: Sing-Han Chen <singhanc@nvidia.com>
Signed-off-by: Wayne Chang <waynec@nvidia.com>
---
V4 -> V5: Added Cc tag and revised the commit messages
V3 -> V4: Updated the Fixes tag
V2 -> V3: Added the Fixes tag
V1 -> V2: Fixed the name of Sign-off-by
 drivers/usb/typec/ucsi/ucsi_ccg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_ccg.c b/drivers/usb/typec/ucsi/ucsi_ccg.c
index bff96d64dddf..6db7c8ddd51c 100644
--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -325,7 +325,7 @@ static int ucsi_ccg_init(struct ucsi_ccg *uc)
 		if (status < 0)
 			return status;
 
-		if (!data)
+		if (!(data & DEV_INT))
 			return 0;
 
 		status = ccg_write(uc, CCGX_RAB_INTR_REG, &data, sizeof(data));
-- 
2.25.1

