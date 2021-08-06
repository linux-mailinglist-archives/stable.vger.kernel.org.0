Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDB93E2C9E
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 16:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239943AbhHFOd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 10:33:28 -0400
Received: from mail-co1nam11on2054.outbound.protection.outlook.com ([40.107.220.54]:54752
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239729AbhHFOdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 10:33:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFM/2MQX6trfoTcaCzzeY2pgZtmoRLpXiF7Mv26su75kBWhG6nLmTeOD3gZq1i7RD88JfK+igcaqvC3LIsVQKvp3WU44WWXmxLp3+qjcn1HgMVU6tC25C5WiP/ZsYx0kCOQIIwKARTMFSijHs6rHayEjdxKntbDhSXfpI/NiOlCkpY8uDwaafEL7xbcIyYsWzWpM/utwU+cul8nm3vHD3yqA3MfWjYUFDJ6llMz1na/WLudd/MhOjNcBFwxWdG5VMb0gMQiJgvIvXg/frEmzGgueJzZ9ak48xWyrxswIlRaWZghaSc9eRuFuFk9Me0j2exf+g3+H+mhxcOWMN8F5lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iViso4wdPVlRW2pbwFzwq0PK9W9nSJ0NcuOCAWui0a0=;
 b=EXTg5H/cgRzOCYGaYsz80ppjMF9rP5Y/WcE7QlrO3YcC+ZTYDuQ3rcBa7wzYGSiTPL6EGOG+gS/NmcpoxSo+3vjl1ZQ3zIfZvkrmJpYVMNq0gw861oqb7f6/PDgPjnLZC7RTSW4dtByxlGTTYLFHJjMAfRGgDyNMCqPRWb2Vmu/ZzwgXr8iuKbrQCtS56CjOBLaOyZLO3+HLQUbOOhoHezB5uJP+YmZxhupFOD8KDLUvfy499w0hrTl9gKMkJ1BiqLsgQ2Gextk6DazN9WP7KUtgTOhikYX90j9HZizsO4YykmNBYljj7A6Owb0QDZJG0Ko9qbJHo7f/x61my91Yxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iViso4wdPVlRW2pbwFzwq0PK9W9nSJ0NcuOCAWui0a0=;
 b=MY85K9fFXS1m+EhnQ+jePEQqFVLwh0pdJ3cMAyaKOfEeGG0C9WbG9gUrpwG88c3ipm3h9n6fejeEaCpYoBtw75mn44gvq++uTRNVgGodoGZ7DoexDmKNsyub7ieyucyXnklLxzBlPlxv0qKA0Ijyp8NRveBdaS4Dvq6haQJU6/H1EZ2zfeN/4op1MQRTvtRn1gmlBy8z8etjSt015SjsrqsvQaMsw3XhVdTcn9L5t6O/ucTHruIoFvFPDVxwgj65sitzpvC7bKpbV3nemdX89dyCoP9pXfrrb3dnEVn6gjf87xD3PK0oe23cJnbja7Xvj50fgsRSRmslWbl9zV23AA==
Received: from BN9P223CA0010.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::15)
 by MN2PR12MB2989.namprd12.prod.outlook.com (2603:10b6:208:c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Fri, 6 Aug
 2021 14:33:04 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::2e) by BN9P223CA0010.outlook.office365.com
 (2603:10b6:408:10b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend
 Transport; Fri, 6 Aug 2021 14:33:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Fri, 6 Aug 2021 14:33:04 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 6 Aug
 2021 07:33:02 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 6 Aug
 2021 14:33:03 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 6 Aug 2021 14:33:03 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 0/6] 4.4.279-rc1 review
In-Reply-To: <20210806081108.939164003@linuxfoundation.org>
References: <20210806081108.939164003@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <085ce35f599b4fd6aa08a1e028151cc5@HQMAIL101.nvidia.com>
Date:   Fri, 6 Aug 2021 14:33:03 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86ba9213-38d3-49a7-d3ac-08d958e719ea
X-MS-TrafficTypeDiagnostic: MN2PR12MB2989:
X-Microsoft-Antispam-PRVS: <MN2PR12MB298985CCD4598472C35DF301D9F39@MN2PR12MB2989.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q2+KUCeXORa4k1Gl/rr+WMZ4067JcP4wZmjioQ8YS/cctS6hocwZJv1WkZtJP7VbUKpc3M/tj/rhka3I1//7EMrxfYi3F6JAJl5aoA977iKW7fjV485zq7DwkGKTttvIO7KRsgAqQ2mgjjvD0pUoKTWcoDf9BWJTSAgoZbaU1rn9AEBaLTtpt8HnTzDr2jNaUjVRfFG0uMui2efdIjVlhN1zjvO8073TCbvyrCtfrkuwejuWrnwsx0ChgQ0gX2u48TPMleWUECKMIOcwibmlwFBJ289ex23oFGg+aVbgY/FLh5Dmk6oxDAA/2BEm+m7NMBU5xNnIaitG//3ZXvP6qxfvV26kbPyLWd/juvnk9lfNyoaSbRxviwOSGeUrlgOSsPoHsBE5r9muf1ukHCVec2Ymz/pkN1nRsd5BK7/hY8FhR8yUKw2UnAXeOMDttZqYnC9LAu0AXt7asDONDS6ip5p3djLO5Rx2U/ruQQLgpsVzmWb7VruJ3H5+dLncmQr+pZI/RGLyBhSpNKDKKKRlBSZtuCIAauABPLOsNrh71tcWYaXrSAm17gTOuSQr+fA0PQxYnufO202/f7yi7AsGe40Q3O+Kl4FgsbHiXpF8Gbf5x41VGuwSM9zViw1HEfjFmFf1J0pBkxY5Jo0HNYCMruZ/Hp4ZZA5ja2d2HKSFJp8ePJEe9KO/vF9vd/pIFn/Nsqbkiy465GJRhd+uKPc9Uaaoz85tWzOVXzV+fwym6MGaFaUFoTZtZI9RCA49U9NZxiClBpDwJAh7gY4uamPoxf3WdrU3aMEVJNTtflu/T4I=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(46966006)(36840700001)(8676002)(36860700001)(70206006)(70586007)(54906003)(82740400003)(26005)(24736004)(316002)(82310400003)(5660300002)(426003)(8936002)(966005)(478600001)(7636003)(108616005)(6916009)(47076005)(186003)(86362001)(356005)(4326008)(7416002)(336012)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 14:33:04.3446
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ba9213-38d3-49a7-d3ac-08d958e719ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2989
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 06 Aug 2021 10:14:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.279 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.279-rc1.gz
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

Linux version:	4.4.279-rc1-g155338eca25e
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
