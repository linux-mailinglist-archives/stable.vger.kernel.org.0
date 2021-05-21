Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2854138C296
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 11:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbhEUJHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 05:07:12 -0400
Received: from mail-bn8nam11on2054.outbound.protection.outlook.com ([40.107.236.54]:2145
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234628AbhEUJHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 05:07:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KrF1wUB0UhRplLgg/AZvd7mtvz1SOc2F020Zz/RZz6mjKgLiHn/Oaxo6Damm5rNKuaqsZIVJZyeeYuQTTvn+l5MOA3ZcZWMy8uuhJnYKWALUSbzbhVeGn7kXVTPP/vy60RutT2dHFP4CThl9Co3eTzQ6oXNuhq4iqTWO8m9mGohGRrmxz80243YsuT2TLV3XRCs0ONHUt28aMNssclO9lOIFfuv8N/UyQ5JWN1NYnUHKXPn4X+e2pWiWLUI6b3DYg+hEtiwc1sI0f9LLarmwGzCgNW4X7rh3kr5HA65xXmAWujkwkHekwhFi2wzQnWYIHrJzf/ZWqaDJXqZ3tn2rbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIcO7vlV4GuL8VU5ewuAYgboPqYGcuvuFkWgAfMzRwg=;
 b=D6zKQ9GQT6zrVcrMI+wVeSvBZiyI5+2gOsS+zP6mQj9GtX8RCk3gqBmfqzIhSopQCiT25C7mLJ6QnnNKIU4B404x0xuwXdYAzo52fgKrsoxKAQLgOJt4w7WPfx9AtmfLy+YcINQ7pxx/pfjaA18IO8t9TZ1NERm58ALlP7TIyyi9eS2ojIa/4lGMLGs950F2Me/SNZNZAOyjNHESO7rXu9T8rxgrVXYCSXP8U3xMsWIDNdZOcU63Wjypmq1xtdBXgvzY6Sh1taG0FXn+aGjLOMtycxwZ0VJ4dDkex276+bM75VyEVa8DaN+TgiqkmpYtkJvupV6PmaeRlQ99kw7XlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIcO7vlV4GuL8VU5ewuAYgboPqYGcuvuFkWgAfMzRwg=;
 b=cKufqzZPtq9XEsZ+CilQkMVVnsWyCdOZs8zOtFq3SxltKqtrYBO2v+XrxStM0Zo2lHZLt6q2v3LAo4SXHeLWE6c6/gDzWHjim5Q1pD0wBQrusNeM7E8GKXNujggl00m++GSP+1ejYqU/nKgcM+dk0BauhEmPTR+2LIFQ4du4ASyyVG6HIYM21GNHfWFGALC5fqQPfAdv4bkNFxglRO//wNenJTJfGgyQRmAmm5Uhm1RCY5pZ9WrEo/ac72TgfKWcSBF0Fby0PZpzpLsMHvkH/4HjEpO103Xu2PINBu0ick/jFTVTENJ2zlNCj1chLgtxSqlNy+GtLGtuKMZ7HLNwEQ==
Received: from MWHPR22CA0047.namprd22.prod.outlook.com (2603:10b6:300:69::33)
 by MW3PR12MB4523.namprd12.prod.outlook.com (2603:10b6:303:5b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 21 May
 2021 09:05:47 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:69:cafe::15) by MWHPR22CA0047.outlook.office365.com
 (2603:10b6:300:69::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Fri, 21 May 2021 09:05:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Fri, 21 May 2021 09:05:46 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 21 May
 2021 02:05:45 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 21 May 2021 09:05:45 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 00/43] 5.12.6-rc2 review
In-Reply-To: <20210520152254.218537944@linuxfoundation.org>
References: <20210520152254.218537944@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c572ca85578940c394c509be5100e1a8@HQMAIL105.nvidia.com>
Date:   Fri, 21 May 2021 09:05:45 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a73c91be-f52f-4519-4da7-08d91c379eef
X-MS-TrafficTypeDiagnostic: MW3PR12MB4523:
X-Microsoft-Antispam-PRVS: <MW3PR12MB452384CEF9C213AF9B6E5EDFD9299@MW3PR12MB4523.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Th9wJXyGmn1/RX9hPsIKDuuHixuiJnSYO6Q3ba/GIOmzxPJ/pn+m0tP9EZaVLIIqD7BXForXQQPyTXyTNtuhUClnwtuD+uLhejmKF0atTv2xrEK757twgWRh49Ggnyc6Uuq23ZWStuZ2eTrGq7E1Fj+K0PFp1fiNuHtn7gUbGZMpN8RZZhYNgFfVEuuX73aTkbPNn/CYFCmtlvhIIyylWhfCQ61OgOK8Kl1eLqckNSm9szShJVAy1Xy8SsrE5zduimhlw6mz1SWDxBZiwIKtlwj9t+pbvGo4RLTdjbc8muqwNj2Yp+8cN3KIokScLYeHMQ5HC9Xj05/ofeQfqZMfirwFzAjDVeSo5iyIFeX+xr/dAH0X2/oCo7Ukg6jW83b5pA8aei5LvYqYmveeTPaDzEjMRdK3GXXUFU9s+oVMUiqRRfPCBzTjr6/jOYiaA6JKNd2rBhTEj6D7siOSaw/Vd5V+7UGdqfcNxGtZsmrwUNTbQ6AmRjSDjzz+a3n0JXr2qfB64UX6sZHSRLdaR0dl+BrApAVm9ezEZ6vICPIhX7kotQE+5Fv+KjOsxZctU5/UNBC52AqHMk62FBa7+/fL4Js8Z2KLppicB0ZQTYgg5E5E0jeC4GAHNPqQwYFqwbMlA0x36R50CZuXgs3Y3/qpqrU7MjbCYOoOS8P3XlJFtUJ5qrgawue1HHAmX0Ub6JxZD0P/W23LgkfIhQmViYWnNAbQQJCWLa3CSSnPvJo2m2i3Gt4ovzZrde3ruRwLE2lzY2CICd15VOzf17y+xG4+TA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(346002)(376002)(36840700001)(46966006)(47076005)(86362001)(54906003)(478600001)(426003)(2906002)(336012)(7416002)(356005)(8676002)(7636003)(26005)(24736004)(108616005)(186003)(966005)(82740400003)(8936002)(36860700001)(6916009)(82310400003)(70586007)(5660300002)(4326008)(70206006)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 09:05:46.3828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a73c91be-f52f-4519-4da7-08d91c379eef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4523
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 May 2021 17:23:29 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 15:22:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.6-rc2.gz
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

Linux version:	5.12.6-rc2-gee71fa12d93b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
