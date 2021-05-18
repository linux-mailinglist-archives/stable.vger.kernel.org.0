Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EC8386FE8
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 04:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344392AbhERC0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 22:26:35 -0400
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:20643
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237658AbhERC0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 22:26:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndMOxB8T4Z0a68Dc6ZAQLt0v7M26HFbm5Bxoyy4XQs5mK08VkST9xa2aJLxTk7K+/nI8deUHCzBbjM9cas4VbLiMZ+bP84fMmCOG8zjmMWprtnS1QjCKZ7Rv8Tbv5s8P5MMDXRFPG9qx98HNcOISH1ywkkVBnNTdAOg6awgBSids8zrUDaLr2iTLneOftAHQH1VsDWGYD1Jk+tZPwhtlVFaidN1hjP8oAeCp+UyuCc/bYPWYe87mQF7uK84DcUa47+fligPRmbqpR56Uf+0AC678XemUW9dKP2xJ7AmQQQTPnBgI9x9lgQiOg5AKQMKN2VK0BfPP8+USVxV+prFA7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9u/R+9fCwV6UYMJ2Q6MN/RpoFkfMaKjxceHzfGu6xaU=;
 b=fMI/ep2sO9F7lYG+veUgQtMK3p6yLysDf4ZgJv4BjTZgfjZ9nJg1sEz0fyAf01LOfmUwyolxUAkcC00UL1Kc5RCCzlJzhY/H7z555M8tcOdGiExd9vVKZ24an7mkpcU0ufLNQ5ehkyZHwdTIhrXNWbHoxKKd3F7Nb7WYFo7Dl+1eSmGQxvsQXfAII63WUc4lVK4DcUHrBl6Er3As7m1cO1FF3e0Qeopjhr5w1pcLeSrpOKY3pBhum5BzlS7HcqNqbV6RL+znxopSX5medhSVtCf2wSJ0bFxgneHxFSlCR0xIQzfOmuL3zmfdRrgvlvtTh8EB0tGkqcg58rODOMwZkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=amd.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9u/R+9fCwV6UYMJ2Q6MN/RpoFkfMaKjxceHzfGu6xaU=;
 b=FNI3qmKbDn8SMNjB7OKFK4r/A/DoKygwe5gDqIvfgIdNY/4y1/bXchzuHyUbJOl+RkrjMmtHXn2ne9aieTsKCB7h07ik7FJTGqRVLBclCpSMHkO7TzDHjVrAdcox8o302dausak3PEmDfMIjbl4JnHiO8IbBE3MeZGXX9Y5ezAw=
Received: from DS7PR03CA0262.namprd03.prod.outlook.com (2603:10b6:5:3b3::27)
 by BYAPR12MB2662.namprd12.prod.outlook.com (2603:10b6:a03:61::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Tue, 18 May
 2021 02:25:14 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::e7) by DS7PR03CA0262.outlook.office365.com
 (2603:10b6:5:3b3::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Tue, 18 May 2021 02:25:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4129.25 via Frontend Transport; Tue, 18 May 2021 02:25:13 +0000
Received: from prike.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Mon, 17 May
 2021 21:25:10 -0500
From:   Prike Liang <Prike.Liang@amd.com>
To:     <helgaas@kernel.org>, <linux-pci@vger.kernel.org>,
        <kbusch@kernel.org>, <axboe@fb.com>, <hch@lst.de>,
        <sagi@grimberg.me>, <linux-nvme@lists.infradead.org>
CC:     <Alexander.Deucher@amd.com>, <stable@vger.kernel.org>,
        <Shyam-sundar.S-k@amd.com>, Prike Liang <Prike.Liang@amd.com>
Subject: [PATCH v5 0/2] nvme-pci: add AMD PCIe quirk for NVMe simple suspend/resume
Date:   Tue, 18 May 2021 10:24:33 +0800
Message-ID: <1621304675-17874-1-git-send-email-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 329a0c94-e22f-4d80-5085-08d919a42b2e
X-MS-TrafficTypeDiagnostic: BYAPR12MB2662:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2662C7C6632CEDFBB9CCC8BCFB2C9@BYAPR12MB2662.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2a2eCVsONubZKaAZXX6+92YomlU/xB7ypirlDjB8qzF0yns+0pACa362HY8lTzzz4hXRB/zkMeNTx40T0/jtal30jGIzBEEwZ5ijjnDBygADRM6ajopHA9rKTc/aegxXS6mi8NNX611uKLj1DTPjtoYTtaIag3ar/OAE49Z8RFZPiq1swtW0CDX+CYLd7bmcSYbcCu+KiWC0PYTQXQUjTdxEU3aKSqL/8hx1eEbMLOwKkkv6GjMWMSftLi9PVNYiy24dEdLbgahVtN1vx7sJlRC/yvSdxs8+uGdohI+ZBPCHwZMO1KxH0+uKu30baje+HlSiSBfeOio4d2jhiJ1gi2RAdQc4gvua2tyn0vYyACtPiXMyE+/P71hRLazUfb7BOSnW1wbjFrC0qr1gVU6qdYEmvh0xx4ToNMQcAb4G3hlJf009d/rrPGvxXDYOoxEFk3fBZLUkCsV+nlafdYinTwhqZL6/Yehf7hKWFPRmjIxtPFBcLcfY6IZzQbXgHyUzEVOwcFmFpFVUwGGKfqSvpcRszEgCP2v/FJ1taiKXnaAoYUkk4OvjXLMLGvfmjvo60iV5peRimagsZg8F274IcnoTa2hO7Oa3bKS3v9d5NynWbeGVWilfXa6YJtXF41hDbhSSUkepj6l9OTd9z3suAF1dIzFC4hnGij/snBu+A5wTX6pHcs1esA+eswuE7Qs8
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(46966006)(36840700001)(2616005)(356005)(2906002)(336012)(54906003)(316002)(83380400001)(4326008)(15650500001)(8936002)(86362001)(5660300002)(36860700001)(82740400003)(26005)(82310400003)(36756003)(7696005)(426003)(16526019)(186003)(478600001)(6666004)(70206006)(8676002)(70586007)(81166007)(110136005)(47076005)(4744005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2021 02:25:13.8392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 329a0c94-e22f-4d80-5085-08d919a42b2e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2662
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Those patch series can handle NVMe can't suspend to D3 during s2idle
entry on some AMD platform. In this case, can be settld by assigning and
passing a PCIe bus flag to the armed device which need NVMe shutdown opt
in s2idle suspend and then use PCIe power setting to put the NVMe device
to D3.

Prike Liang (2):
  PCI: add AMD PCIe quirk for nvme shutdown opt
  nvme-pci: add AMD PCIe quirk for simple suspend/resume

 drivers/nvme/host/pci.c | 2 ++
 drivers/pci/probe.c     | 5 ++++-
 drivers/pci/quirks.c    | 7 +++++++
 include/linux/pci.h     | 2 ++
 4 files changed, 15 insertions(+), 1 deletion(-)

-- 
2.7.4

