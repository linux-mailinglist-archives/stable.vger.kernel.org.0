Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BCB4B592E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 18:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344193AbiBNR47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 12:56:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbiBNR46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 12:56:58 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10F0DC0
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 09:56:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DVoNgN5hiFFpkyLV4yaR4zjdPp9OvtULgkyVmvP+3CmVtuCGjwSNko6ySY305vaQR/eZACqgCPuPkR5/WM6Tk9fJ1er9+MfH5mRJiFVwYvzv3IcO/JnEwCU5mXptDOZduzZzeX6F0LbM97LfIuKrnQF78eAtIoEgjk0jWa1JCs9p2mNdm9Hyj0gIwM3XOFlVMHQo6LxXPdSb2HWtgNvuW1wyqxz5zAiRRbeni9cjkIhDLDkqwwNztHo8PFugoEn5Uwlx8vZsindZ+Z5NPrEkD4qPM/oYBVOlaOllM1rCavoXCKSIonFOyUgspVG2EmjIBykRdq1A2rh0IAtUhCRoPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cl0zquRWw+QXt3/5+/boInSH/wbd0gRG1LoRRcT3dJc=;
 b=NJ6IBBETm6MTw1IJVu3WXyknnh3WF1RjB2LkpKdhJPEqkvFt2ScCi8Od5VnSm8jFd2vUQCQMn+J+B5RtuRxpLDPBQMnE/ePGbZZhked04fLfon8jCMLNPNpAaS+VZhyMi2cJgxDW+FOODcm2RX2zxJ8GZ0ECb3xAZTbS9sAGKrjkkIH/egABwHYqkZO4tSqc1UzNT6tbtQZwESl0Td2+XZO5hSB6WwGQyYqpoODmIaop1eJPF+WzI8Nlgf4VgIU1Zm0HYsSvUaqZuaIUvn1N7hEN2u5Ss0vJsOtXO+2IV+6UZ96ciCYKV+ZR3ZAWzc8dkH81xbuD7MRDIAbslW4NOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 8.4.225.30) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=infinera.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=infinera.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cl0zquRWw+QXt3/5+/boInSH/wbd0gRG1LoRRcT3dJc=;
 b=T8aInU/G/tE7eVzLnaOKRqp7ng2Ogk98zG6m+AeMLjJ0iub5Br/p93Dir1XvsnjmFSgvzN3zm9DlFpbnG0ce4Nux03kO1mqn4KB/taz4aABhfGDuYbXtoi5I9mB8IINk890X8Dg741BJy8IqEVZoYXKB33czSJwvYRwKOveaG9Y=
Received: from CO2PR18CA0059.namprd18.prod.outlook.com (2603:10b6:104:2::27)
 by BN0PR10MB5287.namprd10.prod.outlook.com (2603:10b6:408:12f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 17:56:47 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:2:cafe::24) by CO2PR18CA0059.outlook.office365.com
 (2603:10b6:104:2::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.16 via Frontend
 Transport; Mon, 14 Feb 2022 17:56:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 8.4.225.30)
 smtp.mailfrom=infinera.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=infinera.com;
Received-SPF: Pass (protection.outlook.com: domain of infinera.com designates
 8.4.225.30 as permitted sender) receiver=protection.outlook.com;
 client-ip=8.4.225.30; helo=owa.infinera.com;
Received: from owa.infinera.com (8.4.225.30) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 17:56:47 +0000
Received: from sv-ex16-prd.infinera.com (10.100.96.229) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 14 Feb 2022 09:56:46 -0800
Received: from sv-smtp-prod2.infinera.com (10.100.98.82) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 14 Feb 2022 09:56:46 -0800
Received: from se-metroit-prd1.infinera.com ([10.210.32.58]) by sv-smtp-prod2.infinera.com with Microsoft SMTPSVC(7.5.7601.17514);
         Mon, 14 Feb 2022 09:56:45 -0800
Received: from gentoo-jocke.infinera.com (gentoo-jocke.infinera.com [10.210.71.2])
        by se-metroit-prd1.infinera.com (Postfix) with ESMTP id C46302C06D81;
        Mon, 14 Feb 2022 18:56:45 +0100 (CET)
Received: by gentoo-jocke.infinera.com (Postfix, from userid 1001)
        id BF13F400B676; Mon, 14 Feb 2022 18:56:45 +0100 (CET)
From:   Joakim Tjernlund <joakim.tjernlund@infinera.com>
To:     <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>
CC:     Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] arm64: Correct wrong label in macro __init_el2_gicv3
Date:   Mon, 14 Feb 2022 18:56:43 +0100
Message-ID: <20220214175643.21931-1-joakim.tjernlund@infinera.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Feb 2022 17:56:46.0087 (UTC) FILETIME=[3B63C970:01D821CC]
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 168729e0-dbae-4e50-64ba-08d9efe35e7f
X-MS-TrafficTypeDiagnostic: BN0PR10MB5287:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB528731A74B3E5581B9C6B509F4339@BN0PR10MB5287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:175;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6EHCqIwdjCjPqYCgDZ5FuYd0Yoo8Bo1SdSa7N6CFz7A2OG/Y81banGYlDcCt7nB5WNA+sekt+G7OunvSNxuoGLx/HvbYX3LTKHc0T0Y5Sy76G/LLF1O31ukRsIZBm2GrPSOc619c77oZs7G4es1GV/0J4CLS7APdVseGDwiyUpgBER+lHEMn8s4dwYlK4WbRi11JyEjOkMU7whg8kluxtl/w6yTTKub2v8lZt6j+3u98TpET3M2Um07LBinuW3XxVK7PeD6fRD4eSTiwxlQT6So0DEdemWF/AOEkqCJdAsTma1YLKKBhefMe6M5hi6JEAgMbeAx5ugupH4zMYJhTdEAl1SKoQk3HQ5GssvHvXQPgFQ6RlkFiZ4RxpUVvVUe0CC+O3Z7igBb6YLZM832FM0YWdRXPC9W5EL9UVzqciiGlLojmu53zkAhJ+OWrTVv/0tniwRN3apmnWca8iQSsY0CvsSrDUgWii8EfKQ87wV3f/4ID2zTu5REqSCsx7U7mML5RgaSxcZ1E2eHBRcTj+cw6nXk1YZlTaOQJoryX1y75LTRzsGkoF3F8WpEXfkcTO0RHy20oeIAvfLJhcJn8XLOEyEWMj9DbW4NNKSbBTNdX/GF61ZKRgqpfJHoP8WCXCUuhnukQZ7mwZp8+8c0oDW6GWjdT5HtSUZnAsiCKSshIG+7UlXUlcIQ/3TFk5nkP
X-Forefront-Antispam-Report: CIP:8.4.225.30;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:owa.infinera.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(508600001)(82310400004)(36860700001)(356005)(6266002)(86362001)(83380400001)(8676002)(1076003)(26005)(186003)(2616005)(336012)(426003)(47076005)(36756003)(2906002)(81166007)(316002)(42186006)(44832011)(54906003)(110136005)(8936002)(70206006)(70586007)(4326008)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 17:56:47.1188
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 168729e0-dbae-4e50-64ba-08d9efe35e7f
X-MS-Exchange-CrossTenant-Id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=285643de-5f5b-4b03-a153-0ae2dc8aaf77;Ip=[8.4.225.30];Helo=[owa.infinera.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5287
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit:

  114945d84a30a5fe ("arm64: Fix labels in el2_setup macros")

We renamed a label from '1' to '.Lskip_gicv3_\@', but failed to update
a branch to it, which now targets a later label also called '1'.

The branch is taken rarely, when GICv3 is present but SRE is disabled
at EL3, causing a boot-time crash.
Update the caller to the new label name.

Fixes: 114945d84a30a5fe ("arm64: Fix labels in el2_setup macros")
Cc: stable@vger.kernel.org
Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
---
 - v2: fix commit msg
 
 arch/arm64/include/asm/el2_setup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 3198acb2aad8..7f3c87f7a0ce 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -106,7 +106,7 @@
 	msr_s	SYS_ICC_SRE_EL2, x0
 	isb					// Make sure SRE is now set
 	mrs_s	x0, SYS_ICC_SRE_EL2		// Read SRE back,
-	tbz	x0, #0, 1f			// and check that it sticks
+	tbz	x0, #0, .Lskip_gicv3_\@		// and check that it sticks
 	msr_s	SYS_ICH_HCR_EL2, xzr		// Reset ICC_HCR_EL2 to defaults
 .Lskip_gicv3_\@:
 .endm
-- 
2.32.0

