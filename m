Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259133FF117
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 18:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346092AbhIBQSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 12:18:43 -0400
Received: from mail-co1nam11on2043.outbound.protection.outlook.com ([40.107.220.43]:24609
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346028AbhIBQSk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Sep 2021 12:18:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9Fhe3L7+HwqbR2BT2NFiProyWpExksiIUw07tAK1FChdBrkT4ABhhTMwjnrJ72f2rIWp0snQph6WdKkd7qavbZMtzcu427lEdrX/un56xK5GjPBf+KmBTEmY4L9uAiYSEW0fixR2zPvwHOC+ELWM4L1PVjfW3lry+hghOyQGPO6Qs5KwKqSXzE2Y0HKw2dQdOZjAXXw1AIpGR4TWMUPYalA7AgjcPKsKECuzv7QWwmJumgyXSy/nr4pdcmz0ePz2cyct2iYFTFiDvY5HoSD6/NgkUtTpvtDcFpXiOl7N7LCkyfQsyOM460BsmyZtFjMfhzzIlCQa1epiy94e5nxVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=l8M6OKqbRGwwuTEXP7XMwQ3f6waZMScXAtXJ6CEkSLw=;
 b=fF7XzN3bwCevfG7Z1Pbgio0D6v919fcCX3eEZHKncHXEzwGw7lOglQHb4MkhpqEC8zjP6syD6xCCFVMBqzRCyTQGdvJrEbAOwBfSeuiR+PPiZ4ntWllmCljjXoLtBVKb/zVIoLptDDe0r/R0K7ZGQCCwCVBeSHegNXHKAnaURj28fJk5KIbQmmvt/hKTzVP+eOFWVuL/X5IFloawHoSiKfyxhFyXZqMnKtsTtypDxpJeOdPZwoE3V8K7XhJtb86YsbSEFc9Vr9p/H0T8K+fPXxq24htcMFrzCbWdrWrPeek6ut1KRlGtV2i+cAEpfn+5/+sTJrhisyd/F7cmJoM0yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8M6OKqbRGwwuTEXP7XMwQ3f6waZMScXAtXJ6CEkSLw=;
 b=WpHXaRhjIeOEjMX/MfJVg8hykvxzTKlkd132kjzUGkfD+IqAA4DPEcPn5FlrSwb6DLCeTYS+PEmsczm+RfioVq/J49yvd6e0j7zXUPKYNkhxK+Uyxxb8dqu/xSoKF4I3NL5zwXOXv/g0n4FMkXWFdbE+SkDkbB3Bh6IeikgBvzA=
Received: from BN9PR03CA0215.namprd03.prod.outlook.com (2603:10b6:408:f8::10)
 by MWHPR1201MB0207.namprd12.prod.outlook.com (2603:10b6:301:4d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Thu, 2 Sep
 2021 16:17:40 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::69) by BN9PR03CA0215.outlook.office365.com
 (2603:10b6:408:f8::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Thu, 2 Sep 2021 16:17:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4478.19 via Frontend Transport; Thu, 2 Sep 2021 16:17:40 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.12; Thu, 2 Sep
 2021 11:17:30 -0500
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <stable@vger.kernel.org>
CC:     <guoqing.chen@amd.com>, Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <Alexander.Deucher@amd.com>,
        Changfeng Zhu <Changfeng.Zhu@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 2/2] drm/amd/pm: Fix a bug in semaphore double-lock
Date:   Thu, 2 Sep 2021 12:17:17 -0400
Message-ID: <20210902161717.35399-2-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902161717.35399-1-alexander.deucher@amd.com>
References: <20210902161717.35399-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d974366-bc21-4869-9248-08d96e2d3003
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0207:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB020709D6688A4E0CDCF9AC5FF7CE9@MWHPR1201MB0207.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ck1v2iAQ0gZd+/6YseXR30ZI11SIjHRvPe5fSZL7mBhi9qxb6PA/RQcldzPhq51RdDZ3hFB76+qdVTEDaIqLrSZXSSHIb9Rxvt8Z0QH3/wYuN2qNPPZU3uInry1GmahpCqb7VPHiizkMvCuyTuoIZDAX0JX7yfS98KRmzcoPN99qVydP8xpCx0Fo9QVhJVboqU6SuSTIifrBQMoy0Co5k32x0xIotFTqJWDjg6pcelDNWaZjZP1NzaT3vVoJdFnC3BTi3VniISQO7yW4bw7YajFfaY+BNYZPMH2ki08iDxIaWZxrtON24ktpF5tw46UOzmEf8A2JWIhANqRjHT88mKuhGlQ0V69K2M6BmK4dCCFHvohePN6lphSpoYd97Lqx06/Gvlk89cHr2mEvTprERTXWyDVcnY9BL8KuHRItKV6oCUb5HLtE3keVrGoW4X6WBaTtmvOAwHngfWel7a07+y2djwUu1eD5BY0fm0PmC9fyNCX51b+dhN07aGzcFKD5Z6yLx/hpSVMCb3JWkHfW2S6aKBVCfNjtx3vPKxWeNeYbMqKloNhabmsPVful34kNZZY92jnqNbVzi1uhN5WyS6RfrDvvYtKjbmGN6KOoVsC0A3EoGJNUWqhBEbOvz0ky/Ger+YJMNcwHIy4eqLRDJ9Og4TAxttUskelFlld0JaFn5mqB3cz/pPvlRK06Sve5E5sSYhTrBh2z8sRJ785tBRmHAGXuj8nr+TLGu39ayuE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(346002)(36840700001)(46966006)(186003)(8936002)(4326008)(16526019)(2906002)(1076003)(8676002)(81166007)(82310400003)(26005)(7696005)(36860700001)(426003)(336012)(2616005)(478600001)(82740400003)(83380400001)(966005)(36756003)(86362001)(5660300002)(47076005)(6666004)(356005)(70586007)(54906003)(6916009)(316002)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 16:17:40.7330
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d974366-bc21-4869-9248-08d96e2d3003
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0207
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luben Tuikov <luben.tuikov@amd.com>

Fix a bug in smu_cmn_send_msg_without_waiting() in
that this function does not need to take the
smu->message_lock mutex in order to send a message
down to the SMU. The mutex is acquired by the
caller of this function instead.

Cc: Alex Deucher <Alexander.Deucher@amd.com>
Cc: Changfeng Zhu <Changfeng.Zhu@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Fixes: 5810323ba69289 ("drm/amd/pm: Fix a bug communicating with the SMU (v5)")
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 544dcd74b7093ad4befac99b11d90331aa73348e)
Cc: stable@vger.kernel.org # 5.14.x
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1670
---
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
index a0e2111eb783..415be74df28c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -259,7 +259,6 @@ int smu_cmn_send_msg_without_waiting(struct smu_context *smu,
 	if (smu->adev->no_hw_access)
 		return 0;
 
-	mutex_lock(&smu->message_lock);
 	reg = __smu_cmn_poll_stat(smu);
 	res = __smu_cmn_reg2errno(smu, reg);
 	if (reg == SMU_RESP_NONE ||
@@ -269,7 +268,6 @@ int smu_cmn_send_msg_without_waiting(struct smu_context *smu,
 	__smu_cmn_send_msg(smu, msg_index, param);
 	res = 0;
 Out:
-	mutex_unlock(&smu->message_lock);
 	return res;
 }
 
-- 
2.31.1

