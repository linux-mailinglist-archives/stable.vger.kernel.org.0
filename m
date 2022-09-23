Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1CC85E81DB
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 20:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbiIWSkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 14:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbiIWSkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 14:40:04 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2052.outbound.protection.outlook.com [40.107.95.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D097D785;
        Fri, 23 Sep 2022 11:40:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADxF4esxPy0a0dlXSYxtmztDCD4maitMmCsI59N4VI5UwveUP+731GMK4hb7jWE155CZlv8CbNpAAKscHQlJ3E2AIlt0AFdB4mb9zMDhMZKBMB6IEp7BvdVrrDsscwu2GtJ4e0AYcIHEvxumB/7lBO8pVEH2tqPSwKA2RFamesTteP01KJo2dkw4NJ8cns+hKhzsCXgFfoRQA/E5v6ZiZ0Sdsi+wIoN39mgPsqTMtRt4xLcR87LDcYrNSfWd4FSMlMwVKP92VdW0yY+sgFfOL747XNJoZX2mCBVgE1TVWVudkPsrhaomBTVIsWL/OOP5hxZXACTJJJ+EO7Py5axzog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zrzjDGPwMygm1xH9Vs7CFuMAp8+zY8iudWhGS2zHtug=;
 b=ZE9VArVwbmt9+DpMsSnMVw5P1SAoEEiX9b8b2tCQ73/Cti1wiJT//J9ZESNum1IKju8DnHmgWS8s0lsr9MIn9A8wysfePotGXcILscaCdfY9xOwytA+DrE8re8ML2XfqogWvLrWhualoC6WfsMV0tgA2xck3zHaHGZ3fnr6QsXSbsjGDMLvV7vmhsuDiqMacOG7/0zHGzB5A3shvtbmvL+D2c7dSxxBWntTpPmlCdk/O/R8NJz/KCGx1+UHbgbWz5Na+nmjzPRUNDn71rrUHU9ipV8v8kVm070ASuIyC5WxWAg27wY4D5rns63YMcOpdJceHr+kbKeA5p0AsRPmaJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrzjDGPwMygm1xH9Vs7CFuMAp8+zY8iudWhGS2zHtug=;
 b=f+nUbdtzzqhtS9YcI13bX/W1MRFSR5wsXoq2Ayyz7OHPTtsc9+aR9wVkiOZ2atTaPZalLTP0o53pzXvDiIP3MXMv9ZKKjHleuB+4gXWEPjLrPTKV5flXmfbQAbzuPqqNmj1v5/HuZMANLkNGtP4n8Nv0XxvbsCdXtFVuYKRhcJU=
Received: from BN8PR04CA0025.namprd04.prod.outlook.com (2603:10b6:408:70::38)
 by IA0PR12MB7556.namprd12.prod.outlook.com (2603:10b6:208:43c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Fri, 23 Sep
 2022 18:39:59 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::67) by BN8PR04CA0025.outlook.office365.com
 (2603:10b6:408:70::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20 via Frontend
 Transport; Fri, 23 Sep 2022 18:39:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Fri, 23 Sep 2022 18:39:58 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 23 Sep
 2022 13:39:57 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <mario.limonciello@amd.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>
CC:     Mehta Sanju <Sanju.Mehta@amd.com>, <stable@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] thunderbolt: Explicitly enable lane adapter hotplug events at startup
Date:   Fri, 23 Sep 2022 13:39:44 -0500
Message-ID: <20220923183944.10746-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT013:EE_|IA0PR12MB7556:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d717c54-6b55-49f0-9e03-08da9d930494
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FAy6dtnle9mEWr58YXLX0719MoNN1/nzTD9KgppIAqYzSjAA7v9Rt9AzFSCwR3k+l8HHLeG0cabMhdwNz03fVVrQd4hnyxBp5BUlv4IlMK4C54cKjA4i9q2QPrYvQrNQxrBtQbnMHJTf1fS3ggmwlNEmTwsL2PpBVG3kwcnCOnlk+hm0TFdxsr0aiD0N2t3igX6J5ltiMN5e0Ltw12zQtuD07tlLY59XB6VJQ1/8NC65AZ/bpqc0+C/5egwoCBhMiqEqHkBGkLi+bLIU9vqy4OtqObwj8m9o9VaknNR6Anpeh/JwfQEy/Hl7Iiy3WmsmLVrZFSvhjchUVMNIQ+9HOJbWzE8jZIY8XliDsSnQXydXP3OMqjOfd/2qVoZ6w8D0PjJuQZ5YfbOfeHb2PtU1FR2B5smBuAZXds+l2+1oFONd5Rm3mZjILDLR+hzkMd1xKnDF2WtcrWDM3hE1UUbJq+8w/TIr5/Tyr/ivXisFFtgXvCNmVFiYrecvotVZU0DGTvITdkW/geGqfqkveGXbdNcHm4OiZ7eYTqPOhqZz/oFk9C7GhKQWnY3rBxMwML5bEqInvUqQEsjGFNsaCK8gK39SBWkYA01x06CXLds4J/qDx3AU3A9SHe8/diiYT78jXJ/kbs+mBiVMlTFrIwvM+KTaON3yd3YTfkfxGFGV81JU2tGu9gy4ytfHZhKJ+jJ+Tz1ctMS+I5yfzGao32RC8BOPFW/SS7WCHMuSoOx90IHl8qRpaIBdeulv5amziATn3IsmiulWLGMEpJRQQNNMjrqJYXhHTKjUhgVA5d8xnrk7s2FoB80RgMQeXySQ+viT
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(2906002)(5660300002)(8936002)(82310400005)(36756003)(70206006)(44832011)(4326008)(70586007)(426003)(41300700001)(8676002)(36860700001)(356005)(40460700003)(26005)(54906003)(7696005)(478600001)(86362001)(6666004)(81166007)(110136005)(316002)(2616005)(16526019)(40480700001)(83380400001)(47076005)(82740400003)(1076003)(336012)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 18:39:58.8167
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d717c54-6b55-49f0-9e03-08da9d930494
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7556
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Software that has run before the USB4 CM in Linux runs may have disabled
hotplug events for a given lane adapter.

Other CMs such as that one distributed with Windows 11 will enable hotplug
events. Do the same thing in the Linux CM which fixes hotplug events on
"AMD Pink Sardine".

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v2->v3:
 * Guard with tb_switch_is_icm to avoid risk to Intel FW CM case
v1->v2:
 * s/usb4_enable_hotplug/usb4_port_hotplug_enable/
 * Clarify intended users in documentation comment
 * Only call for lane adapters
 * Add stable tag

Note: v2 it was suggested to move this to tb_switch_configure, but
port->config is not yet read at that time.  This should be the right
time to call it, so this version of the patch just guards against the
code running on Intel's controllers that have a FW CM.

 drivers/thunderbolt/switch.c  |  4 ++++
 drivers/thunderbolt/tb.h      |  1 +
 drivers/thunderbolt/tb_regs.h |  1 +
 drivers/thunderbolt/usb4.c    | 23 +++++++++++++++++++++++
 4 files changed, 29 insertions(+)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 77d7f07ca075..3213239d12c8 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -778,6 +778,10 @@ static int tb_init_port(struct tb_port *port)
 
 			if (!tb_port_read(port, &hop, TB_CFG_HOPS, 0, 2))
 				port->ctl_credits = hop.initial_credits;
+
+			res = usb4_port_hotplug_enable(port);
+			if (res)
+				return res;
 		}
 		if (!port->ctl_credits)
 			port->ctl_credits = 2;
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 5db76de40cc1..332159f984fc 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -1174,6 +1174,7 @@ int usb4_switch_add_ports(struct tb_switch *sw);
 void usb4_switch_remove_ports(struct tb_switch *sw);
 
 int usb4_port_unlock(struct tb_port *port);
+int usb4_port_hotplug_enable(struct tb_port *port);
 int usb4_port_configure(struct tb_port *port);
 void usb4_port_unconfigure(struct tb_port *port);
 int usb4_port_configure_xdomain(struct tb_port *port);
diff --git a/drivers/thunderbolt/tb_regs.h b/drivers/thunderbolt/tb_regs.h
index 166054110388..bbe38b2d9057 100644
--- a/drivers/thunderbolt/tb_regs.h
+++ b/drivers/thunderbolt/tb_regs.h
@@ -308,6 +308,7 @@ struct tb_regs_port_header {
 #define ADP_CS_5				0x05
 #define ADP_CS_5_LCA_MASK			GENMASK(28, 22)
 #define ADP_CS_5_LCA_SHIFT			22
+#define ADP_CS_5_DHP				BIT(31)
 
 /* TMU adapter registers */
 #define TMU_ADP_CS_3				0x03
diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index 3a2e7126db9d..98f3afa03036 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -1046,6 +1046,29 @@ int usb4_port_unlock(struct tb_port *port)
 	return tb_port_write(port, &val, TB_CFG_PORT, ADP_CS_4, 1);
 }
 
+/**
+ * usb4_port_hotplug_enable() - Enables hotplug for a port
+ * @port: USB4 port to operate on
+ *
+ * Enables hot plug events on a given port. This is only intended
+ * to be used on lane, DP-IN, and DP-OUT adapters.
+ */
+int usb4_port_hotplug_enable(struct tb_port *port)
+{
+	int ret;
+	u32 val;
+
+	if (tb_switch_is_icm(port->sw))
+		return 0;
+
+	ret = tb_port_read(port, &val, TB_CFG_PORT, ADP_CS_5, 1);
+	if (ret)
+		return ret;
+
+	val &= ~ADP_CS_5_DHP;
+	return tb_port_write(port, &val, TB_CFG_PORT, ADP_CS_5, 1);
+}
+
 static int usb4_port_set_configured(struct tb_port *port, bool configured)
 {
 	int ret;
-- 
2.34.1

