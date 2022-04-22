Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1D550B81C
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 15:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447829AbiDVNSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 09:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447832AbiDVNSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 09:18:05 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AF325DB;
        Fri, 22 Apr 2022 06:15:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dIgwzfaJ782Ev5emPDm3TiFwfDyzF1GfMVSNGtthEdKujIMVKmaCRqq3hziGn2lP355k1rzq3z7mxImjnPrY6gZpmd3L0MQlGdTnn62S4ivYSKAopWV6/MrttdMyHLSxFt31f1ROIKbikjFLA2vDG9hfemGzEU29jVX59V7aIDbV54fJzkT6IdB2SlDg/pm/4Af4Oaqs40zt8pgxfVWSf4f4kN8TRPWxiN+xm618lyoHFHfqJs8REcVEsnLNC1jyJMdNQ18tUwmfsG1aJmvPGzWKsOXddNXQZm78u1BNou0WvWqPmcdawqYI7RjuLo2HMZzAmncqOpvDpECUVbgO+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yu5J9WyzEWi4WK+PcOwTUk37ASltwS7jNwBs9IFUhag=;
 b=nU+tHJTuGuzwo9x3Xu5mQnmwjGglANgGNspD87y+TtFdDFYk3XI/kCVDSyc4kWSKRLGRyFEDRM5loZtTPOTJ9tejK5xR8h5myZUutNp/nFErLB+w3ODQJdmTQizRTYkxXmXfHeRUU7wQrd8W2cyQEZeKvau2rC1qh1bAdA/T1HHNJzxzGmjzwInYm6zVlf/AtKk1TUTwT9D83b4NudH1n+LINxhQJ9EmFeifJJdibEkmgb98YPJUlKaAfTCx+cwLvqN2IGK/h6TjB/EPNl896FaWFPosB3RmPvhcvYos2ct7zNDpiqRYVu3UZJq4q0FlvZWz600lwyxACnUn3WzCCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yu5J9WyzEWi4WK+PcOwTUk37ASltwS7jNwBs9IFUhag=;
 b=dVB/1D2djDe8BQhq43RPmF58tk/J1geGWuuZOCS37N8oEm3WmtUjTwxh4vLrW7gxql+4Nu61AwKnRoim7zoeS7p4e2XsrcMTlWUUMDeuZ7eoFjh9Bx28CpzHbBsQtKbmdwCYV7Vxm450TqlG+pcDUEWrBJuYP06+DaTwP2A9P+w=
Received: from BN8PR07CA0009.namprd07.prod.outlook.com (2603:10b6:408:ac::22)
 by CH2PR12MB4924.namprd12.prod.outlook.com (2603:10b6:610:6b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 13:15:08 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::61) by BN8PR07CA0009.outlook.office365.com
 (2603:10b6:408:ac::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Fri, 22 Apr 2022 13:15:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 13:15:08 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 22 Apr
 2022 08:15:06 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <torvalds@linux-foundation.org>
CC:     Natikar Basavaraj <Basavaraj.Natikar@amd.com>,
        Gong Richard <Richard.Gong@amd.com>,
        <regressions@lists.linux.dev>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Greg KH <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Bartosz Golaszewski" <brgl@bgdev.pl>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Mario Limonciello" <mario.limonciello@amd.com>
Subject: [PATCH v2 0/1] Fix regression in 5.18 for GPIO
Date:   Fri, 22 Apr 2022 08:14:51 -0500
Message-ID: <20220422131452.20757-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4238a1bd-c82c-4faf-27c3-08da24621f8b
X-MS-TrafficTypeDiagnostic: CH2PR12MB4924:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4924A85DFC844DCAD38ABC00E2F79@CH2PR12MB4924.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1IIUnn9cLj4MmMrNwR31XjYB6lhb5rNfz929sgyugt+jJyRj7H6kLrCJbtKxZrpra0lxOOhPTa/zKRxLMr+na3BwflsievEjxWp/kWI19h90J3iQ/g4+2Mp16fE3k480kBVm70iQcgof3j02zf5amvK/yV+MixRADO36IW5sQwtXDoqIlcvOPv1NwZ+h+1g7LDjnTKTmGb+ZpY5wX9BfgX8idRAN6gh2id5aT4Eu2qvIEwR7I47xvV54xKxowWrgcMjKPy2lu3knTGmmLyUjPxb+7sx/s6/Pk9t+NvFtbwOxzsYKGV9u6mAoEhclSJpcSsGVoM8slGFLGTJLe0PPqJHtzHBvtv+NnDMbEf+NOVMFGzTDS/jzwBS5R5XghuxtLd3NkEV3kK474GCcnnV46aV/HmDJOBv15PD7keRBPzQk0d1RQ1l/BPSNidNaUfYt7OpvYB7Gaf4EwcsTls/RkXTyvx951e1lmEjGXNp6iHV1eXLXrpWlMbBOBcRbRNVpSjy8oFQiheXC06bEaMkgUrfYdl1XUT2v40+Ge6sspG/1Vefaoim5To9vDwUUJRX57q8ZcdfrqTYJeFBbmGYn61fHtOhsjL7InQZTRvJABQb7q7MeZblAe/Z3eBRYbazYK0oWiNCOE9rR460sIqcQmqLvn6Zp3t4x5T3RidxuPtbqERFmbPD63beFTg94mhvSww8xZubZAXXDhdV6Jq7xiA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(7416002)(356005)(8936002)(7696005)(4744005)(26005)(81166007)(5660300002)(40460700003)(47076005)(6666004)(2906002)(82310400005)(426003)(83380400001)(44832011)(508600001)(16526019)(86362001)(1076003)(36860700001)(2616005)(186003)(336012)(316002)(6916009)(70206006)(54906003)(36756003)(70586007)(4326008)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 13:15:08.0173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4238a1bd-c82c-4faf-27c3-08da24621f8b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4924
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Linus,

This patch is being sent directly to you because there has been
a regression in 5.18 that I identified and sent a fix up that has been
reviewed/tested/acked for nearly a week but the current subsystem
maintainer (Bartosz) hasn't picked it up to send to you.

It's a severe problem; anyone who hits it:
1) Power button doesn't work anymore
2) Can't resume their laptop from S3 or s2idle

Because the original patch was cc stable@, it landed in stable releases
and has been breaking people left and right as distros track the stable
channels.  The patch is well tested. Would you please consider to pick
this up directly to fix that regression?

Thanks,

Mario Limonciello (1):
  gpio: Request interrupts after IRQ is initialized

 drivers/gpio/gpiolib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.34.1

