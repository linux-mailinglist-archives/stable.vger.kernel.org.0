Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F1749F80E
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 12:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiA1LSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 06:18:25 -0500
Received: from mail-bn8nam11on2066.outbound.protection.outlook.com ([40.107.236.66]:27713
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348125AbiA1LSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jan 2022 06:18:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lc8dH3JDlv1sqnDB/e1XQdqM1NQoxL9e0s6ieLEFOQJfvvKihTCXV4xiClCXAAqS9vIrOLffbq5C249wsNo30tTHdNv2yzzDCoJkQdl5IBJi3oz90XgTr+pNYYpvY9HuosUQPeeQThcjUa+4iOKoYbQT4V1dx9CsgHFcio7i7v0ooU9MpUqdnH54ClFdacmhuvFUsoWMyv9+hmyE0lIqy/XDOie6/vNsNeS0pqviij6UfX3JAKP+honKmfzPmyn4J4qz4IaD7wVx5gyQRZNGrkU6yhBcPkV/cDB4S451GWB85gLj+LcrnrQSftNJCHGPtPFIE1g5zrlOYgC3ehQVaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gn+pF8XbOY+qBsx34HFFFK14fvRCrVVk2Ikh26C9m34=;
 b=KWl83xd2cCSm2f6vwXzGuG1ANfnHpnmphGfX/xRxVvcgbehfOofJxfSTLhXOPtUskANe5rFjHGRZQIEqaJ8zJa9rj5CdilepqMFuZGiW7u3K2zPScY7f7k2Xpjt8YJiYv4F89KmUJuufHdHKhXUD9GRZdAi1+3SbDBAeu2AkDuwbJkvc7tNelTQaolE7hOu8oXhmxHyJhq+YLypk8IsdRTVKD1zTIB1CgRyQSTAKjx156s90D88EGL30/H+eEjpfowWsng/U6QmKS+2tV6Yh2gWRYR+AbaAoVj0xAThY8eyOKmg1E0pAtiOKrc1xcOwzP2oA1Hd8y9l5QZby9uIipg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gn+pF8XbOY+qBsx34HFFFK14fvRCrVVk2Ikh26C9m34=;
 b=uL0VF6DfO3JOTVkLvXNA3Ww0nEnFMRjVvnOFBnNUFckilH/OxKTc8Dh1qh+3iF3ScaAd7UdYLFHiTrGSl9HDraKE+uz0KmJUzn3j/dkkboV3Vwt9oAFahkeb3Bw8dFZdh16IhDQQMH9yWeLOGSGAjgc7G+2WhNN5wxv6XtCNvVqsP2BUibDDztrI1vbIeqh21uvxi19LdwuYuvF2Phy/EMtUNpiaSrfnowEOZW0sTdMeu/eiKSQf1L+K35RcBMmWrqOTWFCwmkagm/lUiGDk7JX3D8q7Qx3C8g8kIXuv9BjIGRrSyFITUYqapvSOSVtqVuSnx1/m+Qyjn2KN5xwVYw==
Received: from BN6PR12CA0032.namprd12.prod.outlook.com (2603:10b6:405:70::18)
 by MN2PR12MB3230.namprd12.prod.outlook.com (2603:10b6:208:108::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Fri, 28 Jan
 2022 11:18:21 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::c8) by BN6PR12CA0032.outlook.office365.com
 (2603:10b6:405:70::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Fri, 28 Jan 2022 11:18:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Fri, 28 Jan 2022 11:18:20 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 28 Jan 2022 11:18:19 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Fri, 28 Jan 2022 03:18:19 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Fri, 28 Jan 2022 03:18:19 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 0/1] 4.4.301-rc1 review
In-Reply-To: <20220127180256.347004543@linuxfoundation.org>
References: <20220127180256.347004543@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d8993baa-587f-4df8-b8f9-836926bafc91@drhqmail201.nvidia.com>
Date:   Fri, 28 Jan 2022 03:18:19 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87c74983-829f-4f63-803a-08d9e24fe459
X-MS-TrafficTypeDiagnostic: MN2PR12MB3230:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB323065FF55C4C2FD18CA95B8D9229@MN2PR12MB3230.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wAR5Bel4RsgTIx6mu/qlLBlSdZObva4niNQGw/Ld+98YFMZTfV2UKU3gUqGv3PR+GvdgH4x+KUMDzTCEo/IrZc6zz+HeF6ZrPEf7l6WS7gquW830s2n+eobzEaGUXRgU7iIT5/m435l6uvY+Okfx+dvBG+iYCxDqd7s/h37RLeFbpS9nwTdYzoTxSJ7U91fCEUEmYjPKYEYs8go1APK0f8M0UsBDnVBZIwWZx5uAevXrILE3wkZR8EP65sb+BPn2P3bemClPFlnDDVqP/n4izYZQpsrBOeoxIv3E8E5EUh2WsZGHANgzBIGsmlAMLlOyWu9fsrW3wupk+ATFaToq/eTax8OxdR0y9GLKjc3BWqeIUwp42fOWQc2uqPY+gqr4ULhuCB/lhnr1jh1lqN//y7QP41q0k0+EgEO193O+r+A10YOmSY13arEER0H2mGIGgWGPlkvbWwNyXtwa8AN2IeAqUD6OJvgQ0ATe1svsb60wBLU+E5onBxGXUjEzYeg3eRpZUYe6XUk+FrvjZVShir7/bH7QPPl/Qy9d4NEPUdoGD3zB5J1FlwIu7+Cw7IsmW2qv0ZhmFhuYBi/XKjo//3o3pRt5x4IheI8+7+ubNv7rHMZvuOgMRe8eEuf2op8oIS4Fa1hBhPJlQVQr/Ho+tXGf3hNJg0sk7dy+CLrItQSEppg9c2cSn9bS7d4GEWjXFI4g2wHykIns7mk7ZCPygsmtPyFaZrOgMDJSGe5Hh6WUUaCY2KzTJdZ8pTv1/at+KmjVCmCt965CDsiP7IYIUv1OMwg0afhH436sVOn9Eo8=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(31696002)(86362001)(82310400004)(81166007)(356005)(40460700003)(2906002)(70586007)(70206006)(4326008)(316002)(54906003)(6916009)(8936002)(8676002)(7416002)(5660300002)(426003)(336012)(36860700001)(47076005)(186003)(966005)(31686004)(26005)(508600001)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 11:18:20.9281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c74983-829f-4f63-803a-08d9e24fe459
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3230
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 19:08:13 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.301 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.301-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.301-rc1-g187d7c3b8ca0
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
