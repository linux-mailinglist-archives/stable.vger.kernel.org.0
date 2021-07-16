Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CAE3CB367
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhGPHmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:42:47 -0400
Received: from mail-dm6nam10on2072.outbound.protection.outlook.com ([40.107.93.72]:34273
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231966AbhGPHmr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 03:42:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5OyOL5GeaFJzZ/ySnduj6RB5p+OFFsRvv5zQjDiTDo2ImoF8M7Fhl3mzaelqZ2fMi+PG32a4+agLrrhqwK7jrHBJvNkylBdgcM7LGHhzx7y5RXn3iuqm0guKWMhbjbLfxDbSpy42ZUye1pDFLEgxZlhScn8aRGpYm5aFKo11Mtxpg/07uO9rLaI799lJ7rJWj7uaZor75vFfnkXosEnYj9ebpHyHgahmNwZarzIzTTvekQYdDR54fzOoyp3yuI9bcRgZ2zjXeHcV/RMAp7Pu9/hCJwfaJoIMmVLYmn/Hb874gETKVDuYM9JGL1DDkpEqddulwgqFaOP/R/GxHmb6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWGEW7PwtFO90mX5QSlApAPnc79qzhN3ZI49ef7cDnM=;
 b=c46xeN9XP7G/J7GLy5550wK/1dSdv/ApiwAPkz3xCKo/pFfpx5Y7nU+72qOI3P9ZUFbGX06jUpU7FSyn2HTirB+VljrpY7N1JsSKoUBW9CVpdl1cwp1Vwdw1jVWoI1Ap6pTxV05rLn6jqelVcVSQMm3ecKiN4TzBoevGQORC6kddyi3fof73zvKMOfhYgto81Te16JexVMK02ghDGs6DAQGWG1fOKNXs0Z0R5IWdTcwz8qYQeJ450jt2aaVP7MjaFXdStAk7NvlahtPdIcxRlXm/Jj8tMYkcUmp7LIfExi8Vs/Lm8x3DBukU+byLtI8EhNcyYeE/G6WxoF1Q5TuaXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWGEW7PwtFO90mX5QSlApAPnc79qzhN3ZI49ef7cDnM=;
 b=aN3Vc6dUhtp/TYkZTjbh/qnDjO8JU7misEvSHllAVFQngcUrDgZz7u5JMG969tTi6yWRZqLpKa9FGrA+70pq0JlKDU1zmH2yK/zCmVL6D/F/l8Qc5XyJOZRzkghZd5ywE97kIDI+FFbjVrojQ45izt+xr3cTmJvVvSu2O/0l6V4=
Received: from DS7PR03CA0214.namprd03.prod.outlook.com (2603:10b6:5:3ba::9) by
 BL1PR12MB5285.namprd12.prod.outlook.com (2603:10b6:208:31f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Fri, 16 Jul
 2021 07:39:51 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::58) by DS7PR03CA0214.outlook.office365.com
 (2603:10b6:5:3ba::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Fri, 16 Jul 2021 07:39:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 07:39:50 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:39:50 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:39:49 -0500
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Fri, 16 Jul 2021 02:39:48 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lyude@redhat.com>, Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 0/3] Backport patches for 5.12-stable tree
Date:   Fri, 16 Jul 2021 15:38:28 +0800
Message-ID: <20210716073831.27500-1-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f56319b8-a54f-426f-606c-08d9482ce527
X-MS-TrafficTypeDiagnostic: BL1PR12MB5285:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5285AFA7936F8BF736738782FC119@BL1PR12MB5285.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:556;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g11NNDNBiCUMYAC0GlgwTWToIQuAxGKccZB26+vVil/hC1GNs9u5Ijl8aHuyGOWwJJiWHRQhfPK9gmZEWSPXqyjbsbtQmSCMm0umROHtdtk4i+d43j73hIj3M1CIXuLUVmdXXzWs8pvGXNB8WxhcIKmMXTNMo9PvsaX3fZbOnNGOvDUYTvlAYCDYFuDsxRbmg9PFI3r12I/MIZeUsPKlDl9BzVOFJKQgcOeiaCD6NdxKc0w1VyuOh6ygM6wdYivihlwafx4+dY9t/XTh3zcDav+F4Oavph5QGZXtT+Eu13HEyP3Qi5zzA7qIGMQr3i5KnghymJN6m3xn3mkVl/JcvFDhFXEW0Wt7STWo26TFatM4SFCGNL6yeFK8wWDdGunAfDnFznjZPpiigliZbIsgUR/zMAQqMDiqzYuzPNH5eO/h4yBpFE3MnuDVIT0Tn8BvM1Wfiv8q5HiI4Wh7pbPIPL+DeRo306CDsH/VAwSljOOBT+vy0lfuCzwBVDeTF1ao1/cthrtH7JuhQ8GJNcUJnhJjd3sxQHxP2Sa2gLnFE5JQ8sOBwPGp2Zi8IdNEG4F/rUd+nOp3Ot5p7R/IXEPkvFM/6g08D4fDkp+1XiinVGePo9gpfZagf+svhfdFy8hbOzvtFPjl2WDR/Sy/b+OyKF7J+hewiRFKurnLWv+zEDo8IqmNSf1PIwV6p9agOcJFulUvEHevfuhW7cZpai/Nk3Q7Qx70Fr7hDZMHvCw7WcI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(46966006)(36840700001)(426003)(2616005)(7696005)(6666004)(81166007)(86362001)(70586007)(336012)(478600001)(8676002)(82310400003)(70206006)(82740400003)(54906003)(316002)(36860700001)(26005)(1076003)(186003)(4326008)(83380400001)(8936002)(356005)(47076005)(4744005)(36756003)(110136005)(5660300002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 07:39:50.8880
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f56319b8-a54f-426f-606c-08d9482ce527
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5285
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patches below in Linus's tree failed to apply to 5.12-stable tree.
Adjust them so we can apply them to 5.12-stable tree.

original git commit id:
* 3769e4c0af5b82c8ea21d037013cb9564dfaa51f
  [PATCH] drm/dp_mst: Avoid to mess up payload table by ports in stale topology

* 35d3e8cb35e75450f87f87e3d314e2d418b6954b
  [PATCH] drm/dp_mst: Do not set proposed vcpi directly

* 24ff3dc18b99c4b912ab1746e803ddb3be5ced4c
  [PATCH] drm/dp_mst: Add missing drm parameters to recently added call to drm_dbg_kms()

José Roberto de Souza (1):
  drm/dp_mst: Add missing drm parameters to recently added call to
    drm_dbg_kms()

Wayne Lin (2):
  drm/dp_mst: Do not set proposed vcpi directly
  drm/dp_mst: Avoid to mess up payload table by ports in stale topology

 drivers/gpu/drm/drm_dp_mst_topology.c | 68 +++++++++++++++++----------
 1 file changed, 42 insertions(+), 26 deletions(-)

-- 
2.17.1

