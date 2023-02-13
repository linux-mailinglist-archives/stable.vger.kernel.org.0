Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0938B69538F
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 23:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjBMWFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 17:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBMWFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 17:05:53 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20628.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::628])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157D01EBF7
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:05:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3L6fbspQ2beDpoFWcGl59OB+3gwlG5KakYEgtaovkUNCEpw59IsheSIORnu6QwOy66MvXeOCYTpcFjOHZZFF6V5Pll8QCG9+pOSWNfvDGhsVzMEmx4f+dnSJSPlszDmghl402yeatEE08LsPVUmBiVQTLj4+P5OIJKmxKZDxbcoBuChdb0GNCnRl6Rh/gppcEnPyT17edCB6GmIxPjDGwB0nw+RTAk1PQ8lZZmY1a5eKmQ9RGQmMcanQkKXG7C5niTrF3IFjoIIwgAsk/LvzHPyMRqnxjodCbM+D/hM2s/Az5Maap70g1kK9E2/1/TbET84G/Gc4ob5ObC23/qy5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIABUQhmdObb+Fruung8sELdRN6/Vp28jJaxZoYXhBc=;
 b=kiKNXYE4rc8pNpbqh0Iy1e+9zl69S6K2JQggJOV9gJH/RK+82ln3VWshoxFfmfyfMCFT0bG6CypqxmT8DXZh+HD0VYpMgrCXFXGWIuM0G5WLdXTNhGpa+lh/MgUsWe/x7cklvsV1Fxc2C8+DKBgGQ49nZnyUVr68yIV5T7d1L/XOg0/AIcrPicHNXFFnNFZhN1EIhi3puD2ZU6QxLwb/CGRHgK/bGHMmFjZPXGxKIfytTIdD+m72tRM8nM7URwQSlVd10J5YtLcXaPjanHp2iJZC2DF3Qv52HDAz9c+rUSwtB5zycS0Q4KhT0urCD1pOesSWmtlTJSS4jahsIcNzfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIABUQhmdObb+Fruung8sELdRN6/Vp28jJaxZoYXhBc=;
 b=n0f0xd1Cd+ffxD4XVl/UqZaRUVZuiFQSc9UfPHgbHnFxY8va7VqGBbPq26aZ+CobUR4m9rVmeA6qz3lBnSSODcAme36VjVDzSact6TNJwzXwpqR2KZ435mcAoj3yzSf2CJo6zAdnfjEBhAt5/5//BVGwqAO3dINGxwqp6F95ekQ=
Received: from DS7PR05CA0094.namprd05.prod.outlook.com (2603:10b6:8:56::11) by
 DM6PR12MB4249.namprd12.prod.outlook.com (2603:10b6:5:223::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23; Mon, 13 Feb 2023 22:05:49 +0000
Received: from DS1PEPF0000E633.namprd02.prod.outlook.com
 (2603:10b6:8:56:cafe::dd) by DS7PR05CA0094.outlook.office365.com
 (2603:10b6:8:56::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10 via Frontend
 Transport; Mon, 13 Feb 2023 22:05:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E633.mail.protection.outlook.com (10.167.17.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 22:05:49 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 16:05:48 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.15.y v2 0/4] Disable IRQ1 wakeup on CZN systems for s2idle
Date:   Mon, 13 Feb 2023 16:05:33 -0600
Message-ID: <20230213220537.6534-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E633:EE_|DM6PR12MB4249:EE_
X-MS-Office365-Filtering-Correlation-Id: 12f9582f-4274-4870-b281-08db0e0e7718
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GhgDmNdugsvo7fAtM/pp3yAsAWF2BwhYMbodQJNSSWs0HN5z5A4dcKba9Lpp3pcx4Gn+8xRpQsEPz3YjYWfmYJlEXKhsUDSnI1MUHwrvGAbEgIUDtJL+rd2wl+11dXFtR3yXHonhgqNetiDwUrmhhcysUYn/uTHMbTCHBbTv5VZXvHcYjW5ml7Em9EK5h0qMx3ySYFUyMfiG4XQKMmmmAFo89eh+hp5IUsn6xDYZKKhFktcUdHkBgSFKwQIJ/W4UzI6Wq1//2Wys+T+1vyYcHxpbHe2oO9ByQQcwxSS/dgcrXgjGizWsN4EgMmSbi+5nu2/NJUyIw+0DxxBoBFUH7XPB9Vojz/c5zdGhStVuhFO6YEhrrhsXDzmmLWdJ6wkOiJIMTBsn9didKhYHWoxS/AwznkT16cNt3IvHPdUO4iW1ZlPRzU7sxSQ2OJyS7xj4Ou6aut8sJCx/xz1ElEe1TH1bzu9d3LuCPEvV4678c++6s8uuO1hM0X921hmlUUYOIzHq/vSTH/t0+bkCsmU3n6NIN0z3Y11arAr0lE6BojdFvU11VWKHFwfpculQfTmbylMo4dgVbjLpSX6gicDtp1ZTcpBurW9kcald3zx5ENs36yrpG484l0Xn+cOBMq1hGsZ4mrkmCYYXPpdJ0VeWoQN7EsdSUqvbFf2uhB1l/X96J4fUdIcIy63Bwg5c2YwX
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199018)(36840700001)(40470700004)(46966006)(6666004)(81166007)(2616005)(1076003)(356005)(83380400001)(40460700003)(478600001)(966005)(26005)(336012)(16526019)(86362001)(7696005)(186003)(47076005)(426003)(82310400005)(82740400003)(2906002)(8936002)(5660300002)(40480700001)(316002)(44832011)(4326008)(8676002)(36756003)(70206006)(6916009)(36860700001)(41300700001)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 22:05:49.2714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f9582f-4274-4870-b281-08db0e0e7718
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E633.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4249
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A number of Cezanne systems report IRQ1 as a wakeup source when it's not actually
a wakeup. This can cause problems for certain ACPI events. The following fix
went upstream that fixed it:

commit 8e60615e8932 ("platform/x86/amd: pmc: Disable IRQ1 wakeup for RN/CZN")

It was reported that this fix actually helped here with older kernels too:
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1921#note_1770257

So backport this fix to 5.15.y as well.
This backport is dependent upon being able to read the SMU version which
happened in a different commit. So backport that commit and follow up fixes
as well.

v1->v2:
 * Split into multiple commits
 * Catch some fixes for reading SMU version too

Hans de Goede (1):
  platform/x86: amd-pmc: Fix compilation when CONFIG_DEBUGFS is disabled

Mario Limonciello (2):
  platform/x86: amd-pmc: Correct usage of SMU version
  platform/x86/amd: pmc: Disable IRQ1 wakeup for RN/CZN

Sanket Goswami (1):
  platform/x86: amd-pmc: Export Idlemask values based on the APU

 drivers/platform/x86/amd-pmc.c | 116 +++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

-- 
2.34.1

