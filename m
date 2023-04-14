Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404446E2AD0
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 21:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjDNT4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 15:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjDNT4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 15:56:51 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCE14EE8
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 12:56:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJdGbQble9G4L4TkNosBi6mo+w7bwdBDJdXoKy2MTz1cW98L6/te1MD8K5g48TzHC5NPt8cPWL8ha/Y2eGV6GYwVQ0ZyHPnAMtwrwud8fM4DAkb0FZ0KDojkKVdeTCj4DoDsg9V9tpDPpjBQA0m8qiFROBRBjHWoP/0gQKgGpMYmF83gmen+5ps41krUN3jmLsYfrY3fJwUw4jaMFR8ZwlwbhF2zsMxczCXidW1x8ASashQW5otMr2f8htEPRvqgiMgni6/rSeNLTkCf9IRXoQt5Z2rM+rTHW3ujMABslRAC8jEvOk7oZOeyhpfUvqffuO9SghWbsK9E3aiJVQ4k9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0xmjAoSSKFVe6vsYaodm6yLdcsaezNqhNu6vrr1nQCM=;
 b=oUOxVV4kcGNeJjgdw/wILh7Lx0U1FHCGqTf+HQWWb198frAnLZ/EAYZmESE0oT1j4BsnVwQQrG8Qj6sU5EkTPseck9ebOz2+cwKmthhe+PFEoAN9Gmh0flx3Y1jub1g3+peEwJt16XtfEJ7DdoL7e17QnXXUoCyTpJ45W7yiOQSp3U9xMVJxnkOgy0MDbjTQ/wjUDttwcSRBPDtE8DzaDYGHnbvlTb5oVmMH8D+shbnMZLfzPCY2GfV32MbZNvEsb8hBHKY/33JvQ0meJXX6wpPRcQoipkAanQKie6GjId26ZkT3rWyHtPqxi1irukBmsxH78jeOa1TnwzF8wQ00cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xmjAoSSKFVe6vsYaodm6yLdcsaezNqhNu6vrr1nQCM=;
 b=R/qITyQgQ9a2h83sxHhwgaGq5pfvNrx8IQ/rmHYX5XelE7BptzbA5yIbnCnINgvllWcRhTAh30cyxqpzUI2W5Cg+PLIoqsgFhxBImuWVJIXKm1Zqlxu9hLU9C6IDQX7mgADI9DhPL9eEdT1RB75MhRygxGrU8oZSYJtty/PSYkQ=
Received: from MW4PR04CA0168.namprd04.prod.outlook.com (2603:10b6:303:85::23)
 by BL1PR12MB5222.namprd12.prod.outlook.com (2603:10b6:208:31e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 19:56:47 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::af) by MW4PR04CA0168.outlook.office365.com
 (2603:10b6:303:85::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.36 via Frontend
 Transport; Fri, 14 Apr 2023 19:56:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.33 via Frontend Transport; Fri, 14 Apr 2023 19:56:46 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 14 Apr
 2023 14:56:45 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Veronika Schwan <veronika@pisquaredover6.de>, <Jerry.Zuo@amd.com>
Subject: [PATCH 6.2 6.1 0/1] Fix regression in 6.2.10
Date:   Fri, 14 Apr 2023 14:56:33 -0500
Message-ID: <20230414195634.1845-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT056:EE_|BL1PR12MB5222:EE_
X-MS-Office365-Filtering-Correlation-Id: b35ab97f-17cf-4d4a-97d0-08db3d2260f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: faOxqmVIo6UcCO8gfVEGTbPS75/01I+GzCH4hhDBFNL7uMQ4QT9Cl540JPgUvmpdVxgAlSyT1oDkx/9PNrAk7n8LlwVpCVJhUNkllrnaV6NKa5AiVZSVOZ1/h3AC23AkWBe16/RDvBJEmpT+pZdEgYHvS6rBvyXXly1JyUzP1OLnQMn7nNooUAr+EounakbKYpy8nshOrEIdH3ZMQbp6lCIlfuRxt0tbxxxQgwJZVQ075hl6rOE+I3FRIPBno764bQxVKDTeCDiydLT90+Kgw8HLXY6JrqNrdd9yFIwooyaFkVZ0A7KtE2KAZxjR4x+ak/i3pk2rYxh3kE5hic4GD9q1z1u1pICfbV3azTIYiqZ0Wj5h2NVoyFAorWEo8q3Np+rP7jIUis+BIQJE3c9eB0hRCpxzC2SM/iFB9zTtfVr6rlvbFl7e+XLQ7s1Z8SHBBsHJ3/i9VoS7nsOrBVEDl8MOUoWahc+VHUeP34LP5waM5TEmzduiAKZtbTb2foojomEpSXbe+z3Sv3JOHHWWJZ9jctCGGB9DNdPFevRtpBDBI/K3U1nbC2VwCFnBCfGTv4m+EtFaf2U+cuI07KbEG1xTt7um3vwR0nHSnvZM9xxM4wZl+Q3mk76JgZrj9C2O8kb/Xzm1aNirF02tVPqQ3QLR/SPjknL7riIYn0jmyfiVa48lZQRwAV9f0hwZPrIRywbZkA4dlaOyblp3halUigMKyHwamrpp1X05CXkbWSY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199021)(40470700004)(46966006)(36840700001)(82740400003)(83380400001)(40460700003)(478600001)(47076005)(82310400005)(81166007)(356005)(54906003)(316002)(36860700001)(186003)(26005)(16526019)(40480700001)(1076003)(6666004)(2616005)(426003)(336012)(7696005)(41300700001)(44832011)(8676002)(8936002)(70586007)(6916009)(4326008)(70206006)(2906002)(4744005)(36756003)(86362001)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 19:56:46.6359
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b35ab97f-17cf-4d4a-97d0-08db3d2260f7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5222
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Veronika Schwan reported an MST regression introduced in 6.2.10 by
a backport of commit d7b5638bd337 ("drm/amd/display: Take FEC Overhead
into Timeslot Calculation") into stable.

This fix was actually correct, but there was a related fix that should
have come back as well. This is a backport of that fix for 6.2.y
and 6.1.y.

Due to another code change, it's not a straight backport, but it's just
a one line change from context that changed in other patches.
Wayne Lin (1):
  drm/amd/display: Pass the right info to drm_dp_remove_payload

 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 57 ++++++++++++++++---
 1 file changed, 50 insertions(+), 7 deletions(-)

-- 
2.34.1

