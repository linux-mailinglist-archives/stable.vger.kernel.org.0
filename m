Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D4363FAFB
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 23:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiLAWye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 17:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiLAWyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 17:54:33 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C8427B14
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 14:54:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XB/fArsi6QCC7xqM0Q/SAHrx+rn0C6n3SwMYvEYJniWvpZI4yFNsErTZSresRYh6L0/CKpYRmw9GGWFeami3lTaDg3Joo0HVPjJcJK3IhWEgSrV/IVfmqMQh1R/MzFdityIk4OLYgsePh62hW+VnvxAO/M/I3xZ6blxtyjeO3+p8V3izG49Klts9ATx9ckkJVDnuRrrsju4gakovwgy5nNCgAGqTMRnVFeb7cWxtSz+e8/s7jCcXWLIuWcikPlwqewh8vHqXet9cdV6hmTXh/OXitFa8Z5ALHHQsEE2kY/lp0bz8Hg1dZJkXiEn/OF7nZPqzaWdqOedVxAMbcm6cog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRtfbTswM3JtIyG0wB4mkZGrRQatfG4IqESFpTcQdJw=;
 b=Ql8NnPZ/67U+E5Un+aQA+/Ym/YZAMI/8UAoBu2x9oOrYqBOjx8bxYWbW3bWaUPw2Hz0BTFQjDynnpOAzxaacBGl4xGvJlizVS447BCGTPx1dKNkS5c9rXuYgENL4/V0WArY+s4bZIZ2pO3n4MfsK4mejPZoXSvG7pJhMatJXUhE7rbqRvAGc1WfGiz/EcOyJr6rVEnDayhWZR7+/odmNJsYAfPC3nueTwxWYxpjhXN/GGUe/ZnANkNcHSE579NHsjbW0/3XwFw8+SiVGAD4Y1fJC4kCtH5BF931LPhyiU1JwNOS+VexYMEOfqwnbpAnZWn76Xy0v3IKjoObRRjxkRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRtfbTswM3JtIyG0wB4mkZGrRQatfG4IqESFpTcQdJw=;
 b=TLftd+fDqHL2I6x/4NxDa2hI13WTWzDnBqJOLjhPZwmzJXq0j9LvRQBoZh7EY6NApQaE7zXRHXYW9lQlNZ4w9j+EYATgUaSWivc77M7OpHfRkBTZny2TjcXn3mTkrs/Ey5jpTR+eQ48WUtCiVosXEJwdXLe5pGOuUkDME2f0qZI=
Received: from MW4PR03CA0046.namprd03.prod.outlook.com (2603:10b6:303:8e::21)
 by DM4PR12MB7695.namprd12.prod.outlook.com (2603:10b6:8:101::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 22:54:29 +0000
Received: from CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::3b) by MW4PR03CA0046.outlook.office365.com
 (2603:10b6:303:8e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 22:54:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT084.mail.protection.outlook.com (10.13.174.194) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 22:54:28 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 1 Dec
 2022 16:54:27 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 0/1] Fix a problem with cores running at 500MHz on DCN 3.1.4
Date:   Thu, 1 Dec 2022 16:54:16 -0600
Message-ID: <20221201225417.12452-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT084:EE_|DM4PR12MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: d8671141-c113-4e01-6946-08dad3ef00dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: geIJ/1Ps9itjWjO0VDmFJZLZTRSmGC6955bu6z8720WZFP7ueuZW8rberjob7dj3LW0XWJhYfU/FrfSf8yJWY0Dh8BlIy3O+CfFGuMRhQqmsianUGSgXXyxdFjheq/Luco8ddfM64dWeO+0eRFe7iEnGw0qmzXgxhtFeynuDeR6rG9BpW+AlggxuOA6P0W4SLDejfTZN+tkCjyPhyVReQRPk9ru6d4YcP1SnCcePr7GXl6VfIihMEL/4dl9iaZr892ZHTVXf5cR+SXaXxEy9dlDjr1PQajHH9YSxBCF7UMSHapFkzHZ7Luo56sPfNv6g3g47xflNqwUjLqzwtCnONOVp6ST2vGRft4jQAXuB3F0KEJvfKAni9cIivVSaFTI1uhCtAOwSOEWyDKc8oczabwSIAzPYWT14GsNmU60+TALhJVlI6xtGLSlMAtcbpOnCEX3gKgT5fyh/wqVW2k3nCNZJNfKmycKAwZ79/h8WV37g8F4TD0AWNlUtokP5ey71WTMpp8mVmGm084kH1mpPqZ8pzjekxLsEIaQsNtXeoi6VH6Fi9N3tOwP/H9bPKrciSu6Ov5JNjeddGpZgg8FG9/zRYJk57gIjAKbzjyCeObDbiPVvp1+BeWeMvvoAxwxDom5lnHvWCvcHQYZdfdEztSkX0hF3tskY2axSRG5imZfb48vThOQPf6py0qS7w6LpSv9pkLiJZRGSEgkkahvCuMluaT6mz8Ak8JmEPKrcC14=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(478600001)(7696005)(6666004)(8676002)(316002)(186003)(36756003)(41300700001)(4326008)(26005)(1076003)(2616005)(16526019)(5660300002)(336012)(40460700003)(6916009)(47076005)(8936002)(2906002)(83380400001)(40480700001)(426003)(82740400003)(44832011)(86362001)(82310400005)(70586007)(70206006)(356005)(36860700001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 22:54:28.8311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8671141-c113-4e01-6946-08dad3ef00dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7695
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Products containing DCN 3.1.4 and VCN 4.0.2 have a problem in kernel 6.0.y
where after amdgpu has loaded several X86 cores will be running at ~500MHz
and other cores aren't able to scale up to the proper state.

This is fixed in 6.1-rc1, by changes to the DPM messaging in VCN in
commit 167be8522821f ("drm/amdgpu/vcn: update vcn4 fw shared data
structure"). However backporting this commit requires 3 dependency
commits that are rather large:

commit dc5f3829a752b ("drm/amdgpu: sriov remove vcn_4_0 and jpeg_4_0")
commit 63127922e1556 ("drm/amdgpu/vcn: Add MMSCH v4_0 support for sriov")
commit aa44beb5f0155 ("drm/amdgpu/vcn: Add sriov VCN v4_0 unified queue
support")

Instead of backporting the whole series to fix this problem instead
backport part of commit 167be8522821f ("drm/amdgpu/vcn: update vcn4 fw
shared data structure"). and make some context changes for the lack of
`AMDGPU_VCN_SMU_DPM_INTERFACE_FLAG` and
`struct amdgpu_fw_shared_rb_setup rb_setup`.

Ruijing Dong (1):
  drm/amdgpu/vcn: update vcn4 fw shared data structure

 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h | 7 +++++++
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c   | 4 ++++
 2 files changed, 11 insertions(+)

-- 
2.34.1

