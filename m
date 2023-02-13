Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D405C694ADB
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjBMPRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjBMPQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:16:56 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7571E9D7
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:16:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5L2KqCQvIcNajF7T4MCWXnr85kT1tE+C4WVYUn0vgOPqc1/OsgMrqi7s07OIa2qHepZUe4zcTqqAkhF4LNXBY8iaP78rfU+5wXWYO01a3Xd0c72uDl+WakUifpQ4AvhonOHKrbfZhnuyFo6vyYJ5NZWBBOBVDUCnbQIjMfO/VeIpd49f0yZPrjWvg9k6iYvTTM4MwjnFaT4Xa9UINZSQ+Ed4qOCFfu27xKkhnwdNoAg3LzGiUoGlvcD/93pa5yswk5rSkUoPBO+Qy9G49RRgR/QEoy1JGedAoAoKanQ7RzGwXtiBoMmlKmNxfWgUHK5cUVltP6sOzRrDNo/8UoJRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mu/bvGTymXbS5uPeqfBtrV1A1GhZkcCkFwRqQViIDbk=;
 b=nQwgeQTK++caAiW5R0qOBtPlhOWPbDzEyaavuQK2SeCIsaMnrhO6yUSy3lPiOm8MrWDjFRcsXsaMLEYiBeGfFFaFGL1nw1S/6fR5q9oEZ0U0nKGvNli+lsbVBbw6qFBAP65ZuhhVIVxkl0q9kI49tJr0Zq9gh9Eh09apX9Oa0bh76iUGt9El31Qn9WOnQY0BHebWvU8mRl666f2Rj/cmT3K10By/RdwgzelzEpd4cSB9/rSBWAGcjD+Rl3SGRaQSoPrrrNhWxqk9y2xcdksku7QUt+0EdaZ8XwVYJxNFXVUeY01ItzDtWUrZei9oA3bGEKbWRv3plZcOYZjhTks4pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mu/bvGTymXbS5uPeqfBtrV1A1GhZkcCkFwRqQViIDbk=;
 b=VWY3Cdx9NbI7XWUOKFQrqzx1XhNxoMO82DLS+B0QTuZhFBNC/MJvim+Cl+rgCqSoM1WqMYId9lv8fB7BWx68JJbKRRHUpY2DTq/G2FMikcUZ1v2Ma0nAJ5FMRdoFP5Yh5UVJtvPuGJSs7SJoly7Ftxx2g18o4oIfpFwki1+K3FU=
Received: from MW4PR04CA0106.namprd04.prod.outlook.com (2603:10b6:303:83::21)
 by CY5PR12MB6300.namprd12.prod.outlook.com (2603:10b6:930:f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 15:16:00 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::20) by MW4PR04CA0106.outlook.office365.com
 (2603:10b6:303:83::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 15:16:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.24 via Frontend Transport; Mon, 13 Feb 2023 15:16:00 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 09:15:59 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Mario Limonciello <mario.limonciello@amd.com>
Subject: [5.15.y backport 0/1] Disable IRQ1 wakeup on CZN systems for s2idle
Date:   Mon, 13 Feb 2023 09:15:42 -0600
Message-ID: <20230213151543.176-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT014:EE_|CY5PR12MB6300:EE_
X-MS-Office365-Filtering-Correlation-Id: ce2272af-db1b-4366-a336-08db0dd53727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XQbkTwnyYsK0xnwV8Ryp2nkTdr1doy+e2/L13tGSFtyYKw1rkzdYdQ1gHaFI1gRebv8dZABUuhCDgqIMGZejFCkdeU/yYIwnqobDAl7yt0h9HJN3G3wgrWXhrZZ4sOiF7+AI3XelOuVuDhiWX40jhnLZJJxw+u2N87sKc/l9X1yxCj2uVOvvl6+piksoUqskepefQRz/11J0PKmiUS346gTAFEph140U0EG1cWxMDCX9oguFBInL0RkucMpypdEOBd1U3r/6+GOLMgNM7DwQwUAw4+Oh/VW0yDGo8PH4jRNvo/8WkPZFHNW54XqFpZz/fJix10tEQ7ZXZsmlljef/DXLgHtbJAd2mU3IX3Re3mVFfpDU3L8lNHlKf2djN/rQP5paGructn9pUGTwcHBQsTHnhbtlaGKLZufSiu38gjP3FmfD2C2CFZf9IlHegFVCFAT+nUwntplvk7A53IjJkjrm1Ars/m76XxYQzdEiIdbKtAlE7/Wok1r72OugxBV2IVaDa3uDkDT8gnG+ymRMG4WTy93v8xTibSS3AkmLXoEJVjeNuwY6PO8wZvXwex+KKDf344ve1+BuAVgM+lbE9ndFzJ+qcx0O/yi8jlWaF9TomwGv9gztn+mjbuxtWoT+NzkP/v5J2r/chFWwkaSEpYU8gmaygX/peF4/fL4/tWWKOTSMtF77wTrHVLVmWaK9
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199018)(46966006)(36840700001)(40470700004)(356005)(47076005)(70586007)(70206006)(336012)(2616005)(1076003)(86362001)(82740400003)(26005)(186003)(8676002)(4326008)(6916009)(6666004)(16526019)(82310400005)(2906002)(41300700001)(40480700001)(316002)(966005)(7696005)(36860700001)(426003)(8936002)(40460700003)(36756003)(4744005)(44832011)(81166007)(478600001)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 15:16:00.5878
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce2272af-db1b-4366-a336-08db0dd53727
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6300
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A number of Cezanne systems report IRQ1 as a wakeup source when it's not
actually a wakeup. This can cause problems for certain ACPI events. The
following fix went upstream that fixed it:

commit 8e60615e8932 ("platform/x86/amd: pmc: Disable IRQ1 wakeup for
RN/CZN")

It was reported that this fix actually helped here with older kernels too:
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1921#note_1770257

So backport this fix to 5.15.y as well. The backport is done by hand
because the driver has changed significantly. To backport this also
requires the SMU version reading function which was introduced from:

commit f6045de1f532 ("platform/x86: amd-pmc: Export Idlemask values based
on the APU")

So backport that part of that commit as well.
Mario Limonciello (1):
  platform/x86/amd: pmc: Disable IRQ1 wakeup for RN/CZN

 drivers/platform/x86/amd-pmc.c | 59 ++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

-- 
2.34.1

