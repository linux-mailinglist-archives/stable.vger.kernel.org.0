Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0322B49BCC4
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 21:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiAYUOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 15:14:39 -0500
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:57889
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231477AbiAYUO1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 15:14:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tv/e+qzFIY0gcJNqh2cqbjIP8zvyxLUI8XKZO5AnFZFBT4k12luF7Q7Ybn6kvp07ubUvWQy9DVX8q3ouI94DWFiYtlONWz12+sMFx1GVTfRBk+iDaJXWOvCaT7nBBEz6jI3u50BzoyzQGCX0twSZkUOkAwHNLvx9rEpmH0rbxNuO7Yb5O6gqkhKkxgTOiTYGpm++GwRFsGhqEkpBhW+TS1R+b71ewvvLCvSkcUvdDp7mIY+e5wRIfJoRZQkf7XkdvYj32OJUJRlrBWOcWWCanfJMaZgQ0A0dNRKYa8/6YkJvL10SNFrO0DcmwR4nVXBj26GRANrYi+ZRCCbXIJEh2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Woo6g0YGU9jK3/W+BYF54iP0DKZeqXMhYAIflTGUPo=;
 b=JDmygVar7SuA5aYeUuRmAz5iCrHWYnuurPxcBA+n/jVQo5nKFk/zcsRrBWr/mwobcSVRg/FzkdD76sLIUoJGHBtluLwnOQilF5uXoVmtf3i2/rc9KcpuvPGoOUFSWxe5RuyewJaeqc3irX91zID8e0Iz4f8r2cGVbwgT4erVoWbVAd4iJDJhDLFs+M7kEU+RN9uvWk9spQDXu0O1YBg3sUsX/S14tPhUlaYgpy28vwnj0p1J8dD3uvuAKfBZOeIEXXxo35hYJITswKZeNSOWUWa5/z1g0vllf+dwHzUE5pbk3Zvpx2rxkViM/yLEIeQNT7XCW8tIiZbnf+B2BbEEpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Woo6g0YGU9jK3/W+BYF54iP0DKZeqXMhYAIflTGUPo=;
 b=pS5xFVgdIVFmcVAKSa8zK2aowAdGeOAZzYyqY3IyLlQhBPpH3VgLweHqzIK/TLLNX8oYB2Zmsjvg70Pnv11Cn1Lq/jwjpcTmVYU2Eo164Qbx//b/qqV2AoAvA4Gy9tBHJEMfjao00WoddVzgSAgxsMsbypzelFa70JOw7un2p54VV+jKbYpNqwGpqU8TZL4/flkvrg0FhQZUrOuXSJeoZiIjSLfN6S1DNY6n/zk43r6NseLWrrixVbgBWW7Sujq8mjeMcg5+bwBcDe/tgYzfNPkhIpj6ajkdlmNCQ1H5rMaWHUsJUJdknbxdyPb9SwlUnxukf0x+bijdQ3LK5eQqeA==
Received: from DM5PR20CA0003.namprd20.prod.outlook.com (2603:10b6:3:93::13) by
 DM6PR12MB3193.namprd12.prod.outlook.com (2603:10b6:5:186::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.13; Tue, 25 Jan 2022 20:14:25 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:93:cafe::86) by DM5PR20CA0003.outlook.office365.com
 (2603:10b6:3:93::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.19 via Frontend
 Transport; Tue, 25 Jan 2022 20:14:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 25 Jan 2022 20:14:24 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Tue, 25 Jan 2022 20:14:24 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Tue, 25 Jan 2022 12:14:24 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 25 Jan 2022 12:14:24 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.16 0000/1033] 5.16.3-rc2 review
In-Reply-To: <20220125155447.179130255@linuxfoundation.org>
References: <20220125155447.179130255@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <23f70a6d-b51a-4e50-8f46-c44e322d6c89@drhqmail202.nvidia.com>
Date:   Tue, 25 Jan 2022 12:14:24 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb7653da-afa6-4186-2998-08d9e03f485d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3193:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB319302E1C786C57322B06480D95F9@DM6PR12MB3193.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pq/aT9HXfofC2runSHp1/YqaesHgzSOkbMMOu9fEWB+S0rzSRgHvQ5f+iKS8GjTG1oOg7sKMHP1bd+rJPjanBu0bOqwM0jAUhI314uHmlu5p2z/OGTiPWdpHQEtWhE9cgpRCfJTgQgFBW1xfN7NblW3Z31ykT0vyR3/dIDoOJ0HNXhmw+VsmQ7j0+1S9ZOAv+LJZirKRk82fyMOBGRINhflsd7iBbt9H4iPui0ruomzg1IPANa8hwOBXTeIw9bNp3N3Zhya3HYL2vmBgmA6eRL+uY9haNZbyCOZTkW/Rrn77mqBm64t9xtZ4kTjPehfzXMQte/ZReLi6pvgy6eTRuza6hPeVwbjBmZhwz976IiSi6PGgVW2rz8z57A3R3QE36qlICRpECeDNncTCj9krdC5i+hMPHyIJ65jxExault8TDM2VmcD4MmEO3Up4E5nX+REcv5807e+5zc2y6osHx/ZC6N3jQlMUSlZQ1WF+mC7VpxG0TkBC5KfHq97e+yx8uTw2i0gzTTdZUkWbS8y1FPteGKbCZfd+OLiHbkz2Tf9Jb+LB23vSBNcZfKM2x+AO3ybWmfQlA2qjPwM/PmQq/TP9Uuuxd6p+RHhlWBnFUnn+O2JqiXKsjelRTCwy53ZOCwcYq2EeOIABjF/saKkA1e83I5YjWMaU3oQtSuBKNZ6Vhslbqv3H8N26Om3Pf+IelRx04KoU0zlLfATpXdIY2diU8t/FZuOxFvao9jqTTUtaIGxSk+1PuL+fMOO1O8OngFrDeBEqqIaULpMOInHZIq9BMo6ZeYzNdmIQbvNi8vjYGE5K7xSU9z5XM0Z49AfXPh/enP0semZn3qUuSGdlbdQi3zFez8acXJ05vPkn03NDKzL8cKTdeGlADwDLiHZD
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700004)(46966006)(82310400004)(36860700001)(356005)(186003)(86362001)(81166007)(966005)(8936002)(54906003)(70586007)(70206006)(316002)(47076005)(2906002)(4326008)(336012)(8676002)(31686004)(508600001)(26005)(31696002)(5660300002)(40460700003)(6916009)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 20:14:24.9856
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb7653da-afa6-4186-2998-08d9e03f485d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3193
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 17:33:08 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.3 release.
> There are 1033 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	5.16.3-rc2-g39cb7e05eaf4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
