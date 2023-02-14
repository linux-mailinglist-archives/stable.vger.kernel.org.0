Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287C669685E
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 16:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbjBNPrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 10:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbjBNPrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 10:47:15 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557BF28D3D;
        Tue, 14 Feb 2023 07:47:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJO4VtVVLdOk3AicIwrHwyzQxcRtXLCv7pLNm06D1pnYc8sDbDqQQecJmhHayMSQ5h82w4uJ6ShWdrxDUrTmJKz3i/ouGbUohuBc/rczOTvs8tvG+CBZ/ntGI4Na9QDKsUQfEdea7BdvVwqkvmc4EVdt0G7XYbEqcc52pwCXVHt8rm3r/fts1EX0hcgF0ymUPwvh0EokKujG+RNgu4aVODoJq/6Y9ha2iqzWlzmpJor0XLIn4kwnY67E2DCjB12c/e6tpnJATO/UjBd6LUYxQ+t6UgIe4Sc/hdQc5aMtCi1nrxpeAZfbTkTkpYmooY0IMnSNoonlyZm6a5vvrUm60A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8858fGuRsCX+Eu2ncz0L3X1FHPKEJ+3xr/O36+dFOeM=;
 b=eIT8O4SDtm1yDuGJjfdLqpFvfpCwGfRXUM129mgjp1XafRQWF7blrZY8wtY8pqB9ZfHDnbW8ZeDQApaxhBJQHCgIZlG+Fo3XGcenVM6ne7Ek2vznQ70f7y4JV41WIfNCBQQWbktoZ7UIqZt1OeRMNyhKfI324AJWcgw9kiPnEYzRKFHY/Z5FpqleiP/K9c4z/GTuuoDG+ge3fkR+tk1l17lGPZIPp0ffQXR9Ngy27qALFsk/rlTzsH2EtWr/VskZ1/FYJRwVfaXfpINKvrybUH/OV4Zjgv6SYsEA9DYxc+4nSINuYh+vq4X+K1kmjd/hIBgFRSZBb42cIQolHkgRVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8858fGuRsCX+Eu2ncz0L3X1FHPKEJ+3xr/O36+dFOeM=;
 b=22e37WXZaVE49q+CIahikv/0j8dZdwF3FO/lw9Nen2tmKA7p3HqveECGRDmeOkIENE9602pbg6CKhzCyr3CKkdE5QID7N3qGKK/llCW5VgFIz5O1sOZZT9KCRZQn7XMmSnythj11+nuYwsK5jRuKVtHNRsKFvaAJygI2a9sSW2Q=
Received: from DS7PR03CA0261.namprd03.prod.outlook.com (2603:10b6:5:3b3::26)
 by IA1PR12MB8539.namprd12.prod.outlook.com (2603:10b6:208:446::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 15:47:12 +0000
Received: from DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::3c) by DS7PR03CA0261.outlook.office365.com
 (2603:10b6:5:3b3::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Tue, 14 Feb 2023 15:47:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT005.mail.protection.outlook.com (10.13.172.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.24 via Frontend Transport; Tue, 14 Feb 2023 15:47:11 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Feb
 2023 09:47:10 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <mika.westerberg@linux.intel.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        "Yehezkel Bernat" <YehezkelShB@gmail.com>
CC:     <Sanju.Mehta@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        <stable@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] thunderbolt: Read DROM directly from NVM before trying bit banging
Date:   Tue, 14 Feb 2023 09:46:45 -0600
Message-ID: <20230214154647.874-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230214154647.874-1-mario.limonciello@amd.com>
References: <20230214154647.874-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT005:EE_|IA1PR12MB8539:EE_
X-MS-Office365-Filtering-Correlation-Id: c719468f-b030-4bd1-1c01-08db0ea2bc99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P+8WaJw1wflloPlLwv3fGLf4GzN++8ptykw02rdxLgkZn7MUZZjbycMe1XxQx0HNIsayR+CX5ahR2/kBp/T6P4N7mP3zwijc/rGt0F70VuEbxgGy6/dnPwA4QFOsDT/qz/FluSdfvD+BG/BLRb56DImY0yKWY4g8rXjMC6agUIga6tLbhKC1snvggQF2ZrTc/5i4KBfDjDPIaR/WjfgnowrpwTZkJOfrPpMslcY1tDJ9f9jWA8DQ8tyqvlv9VbsjSNc/UHXfW6BJL6fIj+B1ABVpxwFW3lBGbKh9rITTp9Ky6FjjXCks+vMFhgFd4Melte8yJiSpW4jn050ICSE6WpoQD88E1bKFZGR4crhcBaiq4ZJKwMnc6yhqU75/YjGooyUTvcIolCDqQ8z31/osVYsvMqr3511PGPIXnyzNuNTxoNisW/D104G2Am/LvQ9dD6mxKljeCuCKxJrPfJAx9cLqa0cDWDCNkxL24xpNMPCGMw5snZ6vhRQ3jAT/6LHjxFc3h+ijzQ8tYyYQ++eroHKX8atDqJ0iLaD48JXwg53Sk+L9iuBUVY/aMkl0gXEsZlIfA/VN00dEtqOFdLBZ7KWXOsUJiTwnNslLKhiR1DoEojp0/Ckr/zYJo4A1Has+eHSMyoHmO8iY1Vqud0oGlk4g4628IFwW95K6+bw2Y+h3NLDC2+MOM1S/Mdp9KPR1Xm05ZWigmgWqzP13foSScmxGTRRbJI00D0k4OaYNJ7s60sHnvwtIKNBKsY03/mPJyki4/CF7QRjwUn+qhfVBag==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199018)(36840700001)(46966006)(40470700004)(44832011)(2906002)(6666004)(2616005)(8676002)(336012)(478600001)(356005)(86362001)(4326008)(70206006)(83380400001)(82310400005)(40460700003)(110136005)(54906003)(70586007)(8936002)(82740400003)(7696005)(40480700001)(1076003)(316002)(41300700001)(16526019)(36860700001)(186003)(36756003)(26005)(426003)(81166007)(47076005)(5660300002)(187633001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 15:47:11.3761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c719468f-b030-4bd1-1c01-08db0ea2bc99
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8539
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some TBT3 devices have a hard time reliably responding to bit banging
requests correctly when connected to AMD USB4 hosts running Linux.

These problems are not reported in any other CM, and comparing the
implementations the Linux CM is the only one that utilizes bit banging
to access the DROM. Other CM implementations access the DROM directly
from the NVM instead of bit banging.

Adjust the flow to try this on TBT3 devices before resorting to bit
banging.

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/thunderbolt/eeprom.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index c90d22f56d4e1..d9d9567bb938b 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -640,6 +640,10 @@ int tb_drom_read(struct tb_switch *sw)
 		return 0;
 	}
 
+	/* TBT3 devices have the DROM as part of NVM */
+	if (tb_drom_copy_nvm(sw, &size) == 0)
+		goto parse;
+
 	res = tb_drom_read_n(sw, 14, (u8 *) &size, 2);
 	if (res)
 		return res;
-- 
2.25.1

