Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB693A6DCB
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 19:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbhFNR5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 13:57:35 -0400
Received: from mail-mw2nam10on2089.outbound.protection.outlook.com ([40.107.94.89]:23173
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234494AbhFNR5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 13:57:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXF7OFzgaaz6AyQgAgJ52dMYcVzYBFs4fAg/6yrIuLbL1rNnTvSGv9KlTtEpNcfQnGrCMknU7B8T1h0Ej8t/c8aeII62YWRPuxqgIQNvizVBr0qWQJw+Vtfoo5HRJGZNFBiR8sC6v2pFrHW4zk3x9aRi4Ai0ArSGRFYY36+6bex/fETGsgSapAzXiJ1MtBVqa4Qwv0SUIwjaanW+fcCjCbH4BoYF/DWkUlEdYlgFIN9tr803fLFWVPX4ovYnfVPfikQRbZ7ef1/rfe7YxFhmxKhsZ6f1wZpkJnGJZFturQivja4IYya9+nf2ZckMGtyjc3shkyVpMZmIjkfupZAI2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h924THONXXS7RbIHZfLrhzCAMiiKt8SYWzx1/I/pwA4=;
 b=Dz0XLWEmQazbyLRfNF2CLfwC5N8zu9dwt5o3/YITr/QbHBPgQEsOYnmqmXAv9n/IBzUv8IS1mQ/oy0hddXfodNXI8dzeeRvUuYddscFBNnq86HOu0IRSb6P6XkWmeSYsoAF14b7LeR1mlH7Ojz3isQuslKbtIMUJrzl22p68oesKuMZpIxiGzLPg/IN9l7jOv/y13wIFpoaHJEMECND949DCNRblZkfCIHDjj4YNaeyldbO34c1Cosf1iTIr5CabZ7vH2sxx5Uzz4ocf1CbX4XbCTbn57LswVXhCdlRQUVL7XigCIi8CcM5ZRil3w0+4eJzL8O6FTlfTA9VfrNzQqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h924THONXXS7RbIHZfLrhzCAMiiKt8SYWzx1/I/pwA4=;
 b=P+DyTagC+aXzzbq7Z4HDTexiQkC8rh5WrfXd6vG60JSWPP+I9NpQYHo+qznaLEc2RE+Uc72pO5PNkq/LJqEmGM/IQjnzoJEg7sUZztT+y2UhPfB9LkiNCPxE46xGU/d9rh1TAEpEcTUPwbKrDuOqKYRWyhX+LsYOtrlqZD96PnreiH6vIc/NX/saYKmSy88iDwlnYaPlsHiC6/mD5HP86twR9enWX3yGjnGhL+Qu4L97Ocm85KFqOt/mCGxsnxuLXvw165fUM1U917VBAvBEUQxLhpvUf7WsRtbMQN/ZDJCVpydfXPoJuowwcOdz5Ek80OwMYcZp6YxahPtKiGfXuQ==
Received: from DM3PR03CA0012.namprd03.prod.outlook.com (2603:10b6:0:50::22) by
 BYAPR12MB2872.namprd12.prod.outlook.com (2603:10b6:a03:12e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Mon, 14 Jun
 2021 17:55:29 +0000
Received: from DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:50:cafe::8b) by DM3PR03CA0012.outlook.office365.com
 (2603:10b6:0:50::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Mon, 14 Jun 2021 17:55:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT061.mail.protection.outlook.com (10.13.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 17:55:29 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 17:55:29 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 17:55:28 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Jun 2021 17:55:29 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 000/173] 5.12.11-rc1 review
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <aeeb6c649fc3470890b31b199e7d514e@HQMAIL101.nvidia.com>
Date:   Mon, 14 Jun 2021 17:55:29 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27c56e9c-fb39-4e9c-5710-08d92f5d9918
X-MS-TrafficTypeDiagnostic: BYAPR12MB2872:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2872D604494DA5B8EF2BCB12D9319@BYAPR12MB2872.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bIp14Tf/P+x+qQplw1yjSTOMWCo+GxuNFVd33/QMZ3tJl1+7Lsqr0vEcZVU3xEkmWEYYEfGBrJqDIgKCX1akDHENZzFs96ftvQJ7gocMjiTbj9FYBXAO7kZpT2B3gZFBWiULt0XTk54vX0jE1MpgEK0hRouYPyxLJvz0tm9ofkbGLcvnk70CTL1hy0i6ZHt5rxPIN6CT25NFSIEF7xDIaqAejt0uPSEa/UirQ4a/5tzbRo3P5LOi0ugj4tu7vruTWOi+Px8oxaDAADx+WQpM6UjDU+qXQTJQVH/ZDlIlZgbO1Uul4wqkJdscilVCggyYMTIeU52HWwLjgcBkFlmPX07TTki8LMaQn+6BFE4OdxlSxDFnnXYYTNQUUnRwsC5tpZ30jMGmDgSS24eh1AMPWkDn2cTyD9xxpVH9hgZm2nOoI/iwNTOtQHysXrKozGyYJ2fg4k0PtVClMtZd/de0BJWLw7LwnBQNp4CStnZiUY0h8AC0GzFiecAPsp+76LB5NeoxMa7/8W4UJs2Z5D/naF7NXA2+NGIWlLK617rVh9yMt/UAkwQb0uJRS6xvLJCwvIuDKcMS1lnUSXf6NDfkDVuoW5fX6jCwYve4X1HWanjBbtOV/oQJrLo3crcXLYqkYOUswfQM/xkqfKi6A8rB8nN9CmYVaSSy7r5yfy512nsmyFRm+W79ck0LpCwdzfWslb3b7hlIQCutmUVciObFdmTQKmNmW/WjcKVL3U6vff901gPtr9vhLSqvsc4aZEJeacXHAABWZQO2JjXNo5ZCSw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(376002)(46966006)(36840700001)(70586007)(4326008)(336012)(70206006)(8936002)(54906003)(86362001)(316002)(7636003)(26005)(426003)(356005)(36906005)(82740400003)(966005)(7416002)(6916009)(36860700001)(186003)(47076005)(5660300002)(82310400003)(108616005)(8676002)(24736004)(478600001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 17:55:29.5399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27c56e9c-fb39-4e9c-5710-08d92f5d9918
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2872
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Jun 2021 12:25:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.12:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	104 pass, 0 fail

Linux version:	5.12.11-rc1-g38004b22b0ae
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
