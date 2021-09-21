Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D36413409
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 15:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhIUN2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 09:28:24 -0400
Received: from mail-dm6nam10on2050.outbound.protection.outlook.com ([40.107.93.50]:60640
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231247AbhIUN2X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 09:28:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRxiLWa66GosICrdqa0bgEY8v8TG42XaqEvErHil+lo0cab9Fnvycvwv2OWeTgKdzZ2ufemsPha5/om68Wk1DfTHhjgbW/x+bWY+ajVZBxtJM4YLbKPw77Q+qIahcKrRif1SH1TLSkGJQBScca9dqw+1gjUxgwuBQ5QNTAxXS4DpAmhC1rVV844pArk1ZW536LOx7lVzKkiILlz4s/nMu7hbADa+mwT8dqojhwX5HCI/BavQUhy+T5MCX/peLdoxwXNf+OwMSxWYenaF6DvgDpPQ9FokDGyihD2P15WvnvdykPDn9RbN5F3fLuTfXDaah8AxR8FGbOkwnUZbShu28Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xFHWckGMd4zjILbDCF8nVUtXoV8M/AMUJyaSHo+HzBk=;
 b=MKgbIdUyTGENJWbEu/NUV2VVWxcybHI/xtOUVkueilJtLBhlewgA73VLgn4K+8yj5/5gXWJLFt/EeDocGI1yn3YiuD4B5JpRnrXaMJX1FapuleqNyP2hHyDoHQuOw1JnjuQQfYoPr4CGAOFd3Qtr0JiAf9QS+tT+32UA/y5GfodeZYegCm4ATb/oC/d/VPb3Tn8mlmTHX7ozAaKepAqfdeVklVsdDsyVhX91sEE17QqH5MQKed+jk5Ph3rgFs17lSyIsuBHLAP0+73CRfX2OMhbftgH7oCqpmZb6PSjHNeJ5HozEkab389WGcQNiLX4ibnImgI4HrELh1RWI48LgwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFHWckGMd4zjILbDCF8nVUtXoV8M/AMUJyaSHo+HzBk=;
 b=L8ga45lzmYZrvcBSy4oohlFNp28Rhp8GB4s/XNFTjnxvSW0miBvDa4O/Nr8gR4efA7mw60Ge7fbCRv1ghmdlby0qglnqKizAI7PmB3mTK80zHx06icZ1pj2/Cz3FSy3hOiMTYoQy7h2kGP0sVfiMCU2cFuMgp9axNqEEHGUaM1FJpOmx1THFSqubtrZc4Z47DtKao8cpvZp75h4hZsD7TeYw9V3ppUUfDaLGeu2zxweYyWFrezPw/KVc/Sn6rDcYWgeYmmWC3yq8vPSpdVdKb+Yx1kIVs00pfaptrBQdCNAlSuOi8w+r7F5P0hqPcS2riEqQdFUXG0I7U4j9yj7Pug==
Received: from BN8PR03CA0019.namprd03.prod.outlook.com (2603:10b6:408:94::32)
 by SJ0PR12MB5455.namprd12.prod.outlook.com (2603:10b6:a03:3ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 21 Sep
 2021 13:26:53 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::cf) by BN8PR03CA0019.outlook.office365.com
 (2603:10b6:408:94::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend
 Transport; Tue, 21 Sep 2021 13:26:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 13:26:53 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Sep
 2021 13:26:26 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 21 Sep 2021 13:26:26 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/260] 5.4.148-rc1 review
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <98299c713b1c4437b7b862f01a6d5cc4@HQMAIL111.nvidia.com>
Date:   Tue, 21 Sep 2021 13:26:26 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e1ddd35-87ed-4718-d5f5-08d97d037a07
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5455:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5455E6268A2439FD81E3B1DCD9A19@SJ0PR12MB5455.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MlF1s0Os8YnsEpNUGTgU8Rh02Le/RAotyjalSQyQtK1saKTfdCBbDmsOrhtCH/spqRCk0MuqJDEXOQ9r0yuGyk+R68XOge+qUfIwVtRBt75VuBOlfu/1AOc177kehOw0cWXuNEGFR58vfzhE2tKhgHxi7dtLdfoSh+DZ4ab5UhDPTz5warGrZjvT41cJcLbojDcw9JH83kQ287a1CyoO2kjCiwiSDe0dz8P7ueQoEkSSOEP5s8GK1LHxFwDkCfbT3c1ipHsMRO64NhdpK4ZU4defYNXrM4wpRZJ0tWMvCGvsi70YnP8R/RFhGQoj6CGxKpWelniraXoe4fpRZN3jriXvDn5eDq4+5AaJlswZkUh5i+GEm7UH6b3IhWCY3/z6qXOqbD6HX6yQatSHKe3orjqDpKvU6VIClEuX6fJiP27fq+EVCH32YsY14p9u86Zq93spjdJtMOSGzVRWnWx8IGyah6Mfs9kzRvTl0L9alPT7+3lGWWbhczcI26FG8oO/feGKY1lIWaKtTOqfqTFnWW0QeLmmNJhUkCff+qyaiRzHLSWgHK+BQJAW8NdUC3bsAwJYBMrMGbA0YmmvyCPoBAmnVCgQ82Jq1njVp89WrjLC2RylI6gYwbLL4eI/FeQs0Fhaio2/YVDIDpm8KIIi7uMOiCO9q9Bo10nTiKwKJ0dlhxwD2x7A0QdQj90khGiK+vO3iOtNy5ZbN1pkWbRwNi57gS2vXMop6ntq/tS57o78tqDqdhPmiG1Z/04AFF0MVT+dEGIFxSgQraENrIHzhrMZtMZooHiqXxxT/2R3NqM=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(108616005)(24736004)(7636003)(356005)(4326008)(2906002)(7416002)(26005)(186003)(966005)(426003)(508600001)(336012)(86362001)(5660300002)(82310400003)(70586007)(47076005)(54906003)(36906005)(6916009)(70206006)(316002)(8936002)(8676002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 13:26:53.3626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e1ddd35-87ed-4718-d5f5-08d97d037a07
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5455
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Sep 2021 18:40:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.148 release.
> There are 260 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.148-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.148-rc1-g9f540728b6a3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
