Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E1365AD88
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 07:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjABGtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 01:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjABGtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 01:49:24 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA66113C;
        Sun,  1 Jan 2023 22:49:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C67sCh2/EKXuifM/3c3x+6S56Y8sAKkgBlX+zT9fXHufmKIGtPgGH2ebaCcezEDyO7zPsIY45hkVapAU2shP02a3GTHGafn1dzZj0Ev+j9YMJEMkWGDRMtVjTg49Ioo7Wgxk0Z58NxiUcv50J76DhKNj1Fk5f7X/gS217Ns3OD3USzirh2DSBssS1d4eygm78BXh+iRjGpw5i5cZREMhhqgurytzU6cFwGtg6v1qXxfzjxiuRs+1bsbB8rmZituhgOBamErn0HogH8K/3wDISO6OLIm6gGHRcEP5YWAcJnIhCVDeq2b5o/nuVsaV6Nn2n05C5u1JKAbPNFhUwk0tOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjlPzEtMVR1/2xBVTHoc4DAvlrw58CGzObYNjGi0ATY=;
 b=E1UGMvYFbhPDQi0bs7ZlODhwTr2SKg4xj1eArFldPyqdAVXyl62UvPqROqj2hmOz35pzXCwFZeiXcaM6K2C82+NyVG0bWLHLk7OPa0wXaW96g8ZJsoA/jKoxc4V6McyXMYpyPH6eS11q6CYv3DSIXdCQ5CNv8MsJQroqKMCKgp8a5HuRFecvM+X2l+YNqmTd4QpyFwRy40EhZz6OYitvprZfwJsCVbTUd6IVf9PH1IG9NLUtZ5IdZcWM8c4kzGK7qFxtAmA6CqObpEz6xIsVPmpGEX5sKyL9SCFW0iuPmqvBfuWI/NgCswieS2mMx6zP8c6sYLnqiPm6oYtHpsl9DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjlPzEtMVR1/2xBVTHoc4DAvlrw58CGzObYNjGi0ATY=;
 b=Yhnrs5tRM+nnFZh/3c9a2qnDDCTue0KLBp2XqjEBQsACbDGNOqWEUoBTQF4AhAusiUFAMMOeor7r1r9PxbmQO5x4kdOwqcrJfzBxOQtLcHiFHQeRLSOAZOCAdcJEmafSmyvN2rjKSXLg7rLJvYPC8kGunq0IQqn/IX/bHk5jn2ktWmWO49Q8FqjK54NNIJwbvFYhofTtPWDIq5slU3ySaySHn1dYv1INp71dXkyeD2MlavcXglQ1M5cfOKzfmU4K18RfZZ6FfZGg+wtiy/nlalFcSz/TuM16fcF/OUG/FhUn0+ojmUHIXWvOjYsW4y33s605jhDRWXDUAqq7qnDXog==
Received: from MW2PR16CA0066.namprd16.prod.outlook.com (2603:10b6:907:1::43)
 by DM6PR12MB4076.namprd12.prod.outlook.com (2603:10b6:5:213::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 2 Jan
 2023 06:49:20 +0000
Received: from CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::f) by MW2PR16CA0066.outlook.office365.com
 (2603:10b6:907:1::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5966.19 via Frontend
 Transport; Mon, 2 Jan 2023 06:49:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT026.mail.protection.outlook.com (10.13.175.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.17 via Frontend Transport; Mon, 2 Jan 2023 06:49:20 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 1 Jan 2023
 22:49:12 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 1 Jan 2023
 22:49:11 -0800
Received: from mkumard.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Sun, 1 Jan 2023 22:49:09 -0800
From:   Mohan Kumar <mkumard@nvidia.com>
To:     <ldewangan@nvidia.com>, <jonathanh@nvidia.com>, <vkoul@kernel.org>,
        <thierry.reding@gmail.com>
CC:     <dmaengine@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mohan Kumar <mkumard@nvidia.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] dmaengine: tegra210-adma: fix global intr clear
Date:   Mon, 2 Jan 2023 12:18:44 +0530
Message-ID: <20230102064844.31306-1-mkumard@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT026:EE_|DM6PR12MB4076:EE_
X-MS-Office365-Filtering-Correlation-Id: a1718b25-5088-4257-117d-08daec8d799f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nkABbZDJplXy6oCnkUlPXKvQluLTntCNVs1L9iUJzQ1NwVQ+I1hTS8WEwJTQEU7AHbc0rCkI3w4Q78vKPHGEeFWx4xJg9SfiunssOJkE0OvmwGVtXfBF4WQPkJtCKD0mNqLuUR0M7uVmQ7lQjeRupzILqIZzIkO+jGEupS/gegmbLSTiO/0J1wZfpshZ7Y0PDo2Smxf/FYkN3j4AS09Abo5mS4egLxwK84ym74RA7zbIUhKrCCinOyZgTrbIdj4ud28eNd6pfhD/PyK5/nx7F/OULyVYzE7OwkHYzJHI5kSqPxoAqI5KeTuqOIF/tz7QGadcRo4vybn0CVYImtFiB6pq5shIRaC53QITDCQasrKfJ4hwCYBS6ADfEcCTqFCuH8EE9mDmJILysgJWVfI/M/DwEdr2TkXar/7fsJ3/x3TuHhFIYhVtBLm/ob7rBCPtkmUe6cOk7jKSSpGvXFRbEFCdsJavTThwxdxNnTJqKx9k6HGem3Iyy6m1sZAPpeEgQsLUPW/SNPItlZUElRoYd+vMEQui9fmFy5Dc2rS/OlX/DuHLjC+V77bKkHJAv40c5gHThQ2gSZGEs/9jUBuSXgCXuxkoDSL8R7+TtMBjC5Ikn/p6xLaj6EJ60rI+LygaEQIcww8ycTXVqcN9M4M7Qg95KZJuEH0ymUpFRIPGxC29cbKTdCbvV1rz9mYv7QjNgoTg7mZ/YW7aTOCcq6MfaO5JeV1Nj3HVGO4/YdJsfwY=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199015)(36840700001)(40470700004)(46966006)(82740400003)(110136005)(36860700001)(478600001)(40460700003)(5660300002)(36756003)(2616005)(1076003)(40480700001)(8936002)(4744005)(41300700001)(7696005)(70206006)(70586007)(4326008)(356005)(8676002)(47076005)(426003)(82310400005)(336012)(7636003)(83380400001)(6666004)(316002)(54906003)(186003)(2906002)(26005)(86362001)(22166006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2023 06:49:20.0420
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1718b25-5088-4257-117d-08daec8d799f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4076
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The current global interrupt clear programming register offset
was not correct. Fix the programming with right offset

Fixes: ded1f3db4cd6 ("dmaengine: tegra210-adma: prepare for supporting newer Tegra chips")
Cc: stable@vger.kernel.org
Signed-off-by: Mohan Kumar <mkumard@nvidia.com>
---
 drivers/dma/tegra210-adma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/tegra210-adma.c b/drivers/dma/tegra210-adma.c
index ae39b52012b2..79da93cc77b6 100644
--- a/drivers/dma/tegra210-adma.c
+++ b/drivers/dma/tegra210-adma.c
@@ -221,7 +221,7 @@ static int tegra_adma_init(struct tegra_adma *tdma)
 	int ret;
 
 	/* Clear any interrupts */
-	tdma_write(tdma, tdma->cdata->global_int_clear, 0x1);
+	tdma_write(tdma, tdma->cdata->ch_base_offset + tdma->cdata->global_int_clear, 0x1);
 
 	/* Assert soft reset */
 	tdma_write(tdma, ADMA_GLOBAL_SOFT_RESET, 0x1);
-- 
2.17.1

