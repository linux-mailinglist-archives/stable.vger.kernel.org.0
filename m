Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E7936B3BF
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 15:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbhDZNFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 09:05:11 -0400
Received: from mail-mw2nam12on2068.outbound.protection.outlook.com ([40.107.244.68]:53857
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231862AbhDZNFK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 09:05:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjuL0yBxAzrEBc7asEbCmSqf/ruKyAIkA3QHUMu8xMI9vlt2aJu6z5nCNuThyHqfJXrlBoWWOAHcGFrTka2YSIskZdzY214oKWyzZFqL2TFRqNxGcY1V3dZVW4JX7z+kFAwrx/TnsmI7HjUsdhIgHOK7eYZT1gRvvNbS5yH0o/pd/sau26Sh0Vt2FXjcYz1y68zmUfgHj0NWMUJYuy8AkMZcWv/HOm/Qs300dTQEM+zup411YAQKKMTqY5vfVb1XAdlisbLfuDJ8588GCYwLVBdffG0baJg9OoCV4kTPAWJL1Tk/1rt8F1Flvt0MH52tjYBRSMn3qh+Kv2plwUUx+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7OkJh46Bk2+KPXaJqET83KRzCQE1hEKvgadpgwBZDY=;
 b=TJ2od+8HFxra5fInix1O/VwPruMvXAtpRKx2QcdxRsXhe+gag4tmDFPbFQW4nXKKEPkhpXakbsa2ClXeal89hL580g8FN+iXbU3YNg4KznS7nqbwTvFl42u9VtbND3ZBiLrprSpYUQ4ouNbaOWqrGWD5OLBMfO/1MjjZo3aQgq1oFzV22JxD7LCR2t9s3bkgwpNFEDO//49ImmjxlLztmSpHIWElJ7aKOj2/CSASF2nasxFizznmHSVaBKQQ6f2ePCF102zFZ/jAUISM/6qxrYlR2lTCUM98I/ZO1XXw1Rf9j3UCGnmX+VVxghE2qtMRZoqk5IzZ892P+tavmJ0evw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7OkJh46Bk2+KPXaJqET83KRzCQE1hEKvgadpgwBZDY=;
 b=VJHzMtxVHdpkAFuSN1uxZ2WPtZYFLq7SkdZeeNHOEnZLoGSNCF8apk68FnE37I796Aq5tMBsCM+rMMVuaepruG6BCSONrTa/7Iav0fm5JRazYBvgYjQHZfv7rrjl31tYPNXnTrsbkJHNagP/XZJLnIlmV0N7O0EEgtwyymoQH8/I+Hq5TEx5mTq6QiyB8/SfDx3ZrVgk46E9wU/f9UyGh4jWd1MNRmmel4B+wxcUY+SifH5uaDKAU255PSutveOFmY3cKNBLrqbv6ci5AJEK3HEMctmpyOIZ2YSG/majQnbprs68mypTmqq4QssPcXh7/9pCqJAHTWznxwar0EMwnA==
Received: from DM6PR08CA0056.namprd08.prod.outlook.com (2603:10b6:5:1e0::30)
 by BYAPR12MB3479.namprd12.prod.outlook.com (2603:10b6:a03:dc::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Mon, 26 Apr
 2021 13:04:28 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::2d) by DM6PR08CA0056.outlook.office365.com
 (2603:10b6:5:1e0::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend
 Transport; Mon, 26 Apr 2021 13:04:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Mon, 26 Apr 2021 13:04:27 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 26 Apr
 2021 13:04:27 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 26 Apr
 2021 13:04:26 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 26 Apr 2021 13:04:26 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 00/41] 5.11.17-rc1 review
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <55ec9cd5772b4f7c88b4fa034e27c047@HQMAIL107.nvidia.com>
Date:   Mon, 26 Apr 2021 13:04:26 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 095f9d23-0bc4-4b8a-d6b9-08d908b3d2e0
X-MS-TrafficTypeDiagnostic: BYAPR12MB3479:
X-Microsoft-Antispam-PRVS: <BYAPR12MB347972F919C916079D9E04E3D9429@BYAPR12MB3479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3lLtP/cr51ELXWzLpNLz1rsVI09I9aZ7kmu9YMq2CC4ksYeJP+8BmnjbtQwRjF3yGRLa776v51KFSHJGG0geVwD7sVdiinrSR7Fa5R+LOqwBePO1CLvneTedXQTCuzM1+Ez5HFyG1un87XXpjqrs+F7WveXqgczLVCRFvKkfxUMBH4WXz8GHRy2Pr6QqN5taDLW6dEMSf+h3IR1oY9h3pPJjjcNo7jMogvWmDtaI6HyCd0vTXkGwPleBxT5wPB/p/XDa/6KbICxqFlgO6vHDvWybCdGoTpNO6EcBc26qjO7rGr9dsRNW18FHP8g4MLW+zyq/S/Uk5lY45XZhQ5Q6r24QYey86yrXtR8aF8/4/AeK5UsSj0nmJbWgB1kEMRI896X20w60vqTaXnkjrleVd053jxXBhXPtcth4Zr/YBXY/Zk/63X7LGsPNVvR4EuqlC1hajbmiFY4CB4Rj8LIoCCX3/cemJWUS8KWgUhgRYDcLAlcia0LBhv/SSlbADMTKAs3QQUuAZZQU6oerTILu6z9vLoWp+DCXiq2RnBFJ6O003/YlRQC7LpecsChYIcRpgSUQGjHLpqjRvsfw8xNsdWVDZ+e2ithbv0hKLCDemHl5FbYuVplLdtEYk9F3cNlovAFftMvfnDT0uazqmQ41IKUUAFzL14o2PDwOM/qWoRzGihm+ftRL0kGnX/g6wcXelVx2qYKHSb2LSVwTEZ/JiPM60zQZ3N7PKRs12WHNNIQ=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(46966006)(36840700001)(70206006)(7416002)(36860700001)(966005)(70586007)(4326008)(6916009)(54906003)(316002)(36906005)(24736004)(26005)(108616005)(47076005)(7636003)(186003)(356005)(2906002)(478600001)(82740400003)(8676002)(8936002)(5660300002)(82310400003)(86362001)(426003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 13:04:27.8405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 095f9d23-0bc4-4b8a-d6b9-08d908b3d2e0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3479
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Apr 2021 09:29:47 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.17 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.11:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.11.17-rc1-g847f63d2d710
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
