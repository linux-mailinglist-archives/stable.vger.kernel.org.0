Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01443C5A77
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 13:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240475AbhGLJ6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 05:58:41 -0400
Received: from mail-mw2nam08on2062.outbound.protection.outlook.com ([40.107.101.62]:57380
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229604AbhGLJ6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 05:58:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIxk3JZtFgh2kFV09RUE0hmeL6JBAjlYi5plmuaQqudtS92cRE2i3Rfi/fx1SRkru30iSX7ebZE9FfwdWcu+mtq0x2qbpkqNQqA8lMWbvJA1NgLPoyY7AjolrrMnRXFP5ep773W6E08wRnP2MCatfgwRq5/Hc9xCasACLmXi+jmmvlJyZlLzHNyGViJFxvgdECNKqLlAPdVvgd+TuQkbHzsT+iSiNYavm5fPMaoa7Mqggjv/zxg3Pzm0O3s83XvJQFi8tT+qD+fH9q8mGhER9IjLZ00VerLwuknmws02Nbg8GgIFxj4XXn+aWSJFkcoNgjMwFlFxwifCQfq8TDfMEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdszjlr6EntqV1YHVT6OVL1mRsfKiPKNS4NCq91qBVc=;
 b=RlKaVSvu7MYvwIl3Wtp7BOqwrtOGtjKl3blVwV/DmPCH3Iq7ytiorjkF0FZ9YeAzbZw78D4Nn9HdegeeD1rRf3bqczQzG7J2A/+TVBmYhNyP3cfGW4/rRm7e+f8GLRvwqL6cBMU06CtROs72rlLk419bbrX1rp2TrnFfOamJi+ia6k1XtUhj/YY4XeUvK+/GgHFa1F/RmWR0FV5MLliP0MhY2lp0gKoxbpzznZTnSDg4vsYc/ot4O/rj4ED1GbkhZo2ieQyGX4Mn6qKT4IrwhEHNT1bnpbzX7NzttX7isvHwzSDdmHr4F/4Z6VKF4nYlqyrPVF5eDl5HzUNnZB7lXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdszjlr6EntqV1YHVT6OVL1mRsfKiPKNS4NCq91qBVc=;
 b=b89XJLiaYwLX6u70ASR7fZe1VRAx0FFN0FgM6GBxysrNK7qsoxF3uDQNiHl+C/kap474nuS2GvPFxUWUX+EAbvO8kIqHyt7+AHlxKRlwziwQpShsh61HMNLWFU6Da+eSbs9qisoTqVrLbNeiour2Yat2wNtRIgWSDg00G+jXon58POptAmu2GWXMKf8eTOx5dk7zQ0OSQmnWxMJCKOLJNC2MQZchPMJ4bKJJmaw/tEyvFf/nNZnayrQFu/sj4zFF+OT9iPM62jpowvdIdl8Z8Y0uZQ138JzLmSDDWSxSvd6TPUAZgZDn0r21sZYU9BPbNccj/G1tKoodc7+8Rcb+Kg==
Received: from BN9PR03CA0128.namprd03.prod.outlook.com (2603:10b6:408:fe::13)
 by BN9PR12MB5289.namprd12.prod.outlook.com (2603:10b6:408:102::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 09:55:50 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::e4) by BN9PR03CA0128.outlook.office365.com
 (2603:10b6:408:fe::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Mon, 12 Jul 2021 09:55:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 09:55:50 +0000
Received: from [10.21.180.219] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Jul
 2021 09:55:47 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
CC:     linux-tegra <linux-tegra@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Vidya Sagar <vidyas@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Subject: stable request: 5.12+: PCI: tegra194: Fix host initialization during
 resume
Message-ID: <5add238b-aba3-33c6-87a9-85b0a60f5103@nvidia.com>
Date:   Mon, 12 Jul 2021 10:55:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52d56be8-4e04-4eb3-2042-08d9451b3ad2
X-MS-TrafficTypeDiagnostic: BN9PR12MB5289:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5289E3E8BCEFB0C4EE8DEF50D9159@BN9PR12MB5289.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 69YtNnBEghN7CrD0ndbrgAgUjH/TVsrFto80fIT2jdp4H/cYJ87gZWqoYA6jyMT3E3IyxFXjcUZl1i+iYf9cEr8TeTTpQH3BHgpmLkjRREQs8Z+tp+N8fpS/RnULZcB2+VOAAGHe0LWLSdeLup+FV0tdKluMCehFjkzO5GxeEORRUFMKrUYEZVtwdFmRYtjzBrq5MOfdt1aEY5b36YvdkrZ7b1XP7F1DdhzId8EEqzLo5XBdHutMesM8pWs9Ol+V3S+DYiglRZMXH+CG2mMs0gxatB5+QvFBzrzvCEVTdoVzaUEQvITlc3AUU51D2plsXKNNtDU29w1gV+tbQI807X4q+v+D9Jd9cIp5cmxTNOySxoRYq4qltCvCN6LGEhIoYZWL/QbpEQGFPTwSuA8rvjqhZA0/FZglfNVHqjnZpTxFhiRZsB773v5wuI+7VSk++G67z6Sy/QlDaZDZC39Zngnbnp9EfZgkvtvvpmVKezD+BNMeo9e9t8qLIDh3cxl1tJWl6tgFWuY7dmqh5rG/mlle3/rZspvS3RyWCdwx/mskNOpyMkc1sEGqnO5hPMm7xiYSSUbCc8e5aYAChRYkN8qK1O1L7R0mn5boIfetZ4otioI94+P6SBZ90L7kWLGiQdEoVvLCE1d5PqLvsVszv+s7KRhafYEfpt5p91G8GFVyGh5C2Ru60QKgmGLF7xe2Hh2icoirrzE2RFgCGOlBm8bnjgfjYqmve/gr84RzsVnpThda8s3WZPuDbih2EX2ShWysvurOK9h5QgEIX2T7dQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(396003)(346002)(36840700001)(46966006)(4744005)(7636003)(6666004)(356005)(5660300002)(86362001)(31696002)(16526019)(186003)(70586007)(82740400003)(478600001)(26005)(70206006)(31686004)(426003)(2616005)(54906003)(36756003)(316002)(8676002)(82310400003)(336012)(2906002)(16576012)(36860700001)(36906005)(4326008)(34020700004)(8936002)(47076005)(110136005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 09:55:50.1109
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52d56be8-4e04-4eb3-2042-08d9451b3ad2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5289
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Resume of the Tegra194 PCI controller was broken in Linux v5.11 but has
now been fixed for Linux v5.14. Unfortunately, we have missed v5.11 now,
but please can you pull the following commit into Linux v5.12.y and
Linux v5.13.y stable branches?

c4bf1f25c6c1 PCI: tegra194: Fix host initialization during resume

Thanks!
Jon

-- 
nvpublic
