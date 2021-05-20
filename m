Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5BB38B32C
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 17:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhETP0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 11:26:32 -0400
Received: from mail-dm6nam11on2089.outbound.protection.outlook.com ([40.107.223.89]:27873
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235367AbhETPZ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 11:25:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYis3BrjqoTqeNqlX4s0CEMElpNGCfCT4kAj9DWmAU2YOzppj7HjieNmdK9Yh0CU0LZmldOAA+Jw1s9St2ZrgWil/5M18Z9SO5O4JPbPcEt9EYQsSHXWaNrwElAkrJIf/VsWffsb5yq+WJ+o79j9f4B7PId9lmP42zupIItJJ1//oDHVbkfWX5/8F12rKDBPIai4XJ+clpHeWDNZpHTkJtWgUi6bwxTn8XSJVxKKJ5onj6TL0uILcQGYBu+ziCqDXihEsTVEa+k9hVbkW1AdWEU/2Gq7uKQlAu9MxRLAEZG9ECfQSR6u1lYcLtxJbRTMgvNYnQ0YbQKOXcXQG6MRsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxJ03e5w0J6mg5zhGYbpVqQLQJmjit5EN5xXfm+qia8=;
 b=QbavBWQte+i9Za3wt5n1cpd0zVW4FWRiP64tcCumqpAo43BvS/GHB/SBDcNYpCsdj8G+332u4fHqRzQtZxbdKudidV4mlZmRTn5sHD1a87JHMpCSxwxFm4K55cpHYkxEUThjWjgJfDemC/VH6HrAmUxie17Ctn2xSheqGWuqxKcLMPhc3+LxniIvU98UHjZyfbVQCYYp0Ws+fDq63F4s4n+XniLxNlGJdJxWP3dxKU2zab6hH+Gueu/7S/oRqEv3BTXMOMh8tk1g+ULT4VvEBc32tgAg5m4kF5WPF7yP/BEv8dYs05PoxlMY2cEqcloGXIHuBWwh+2sjyr7A9XdE3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxJ03e5w0J6mg5zhGYbpVqQLQJmjit5EN5xXfm+qia8=;
 b=Pguos7BSKVWz2hQP9XbZu0MSKH6f/WnENYIt/xjR8PqVPKQZXiX4D9XBocxmkqCjX42BkScdtwLpLJ/KzUFzAgTVHTJlgvBs7czIX8QGpiscrrW+ERN4/COA8H/O1klNFq535ZrJAaXe4hUpNLBd1y5HXKS4V7gPYCBEmmvvzg66pNM9OoelL83orKmrWFJGcKB5RXsso++jbxD0ti8346oks8fwwF0QXl5MT4shmoXsPEvkYih9aSDWlCpUMUcEUpz9LchI7DM7KL0mcoOIxVKLxID5FWfu8faRXOy+3PJnPY2JGnlCwDFyOrRXF0ecueen0ZCYt5OHikQ7SDbFhA==
Received: from DS7PR05CA0016.namprd05.prod.outlook.com (2603:10b6:5:3b9::21)
 by BN6PR1201MB0257.namprd12.prod.outlook.com (2603:10b6:405:4e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 20 May
 2021 15:24:35 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::c1) by DS7PR05CA0016.outlook.office365.com
 (2603:10b6:5:3b9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.14 via Frontend
 Transport; Thu, 20 May 2021 15:24:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Thu, 20 May 2021 15:24:35 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 May
 2021 15:24:34 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 May
 2021 15:24:34 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 20 May 2021 15:24:34 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/323] 4.14.233-rc1 review
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9060bb7d40a54d7cad81f39d50e51374@HQMAIL105.nvidia.com>
Date:   Thu, 20 May 2021 15:24:34 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69d324ff-753c-4430-c291-08d91ba3601b
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0257:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0257A7C609F9EA1AD1373421D92A9@BN6PR1201MB0257.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BqJytGGU2a5wNJE1e3d+AcKhKAqMXgNkKpjwTXY8HcD5Exxq/VjLJ8+1l+z4I5GHJthMbsdmTN58IgNQkwh3zKUDPu8b1x0EoWEKJjyI69mZhQ40bVf2K7bFBxp4Tp8cSI3ASBwPW/HnLRkqDvhAfsG8HPwk/iDLs31AiDoUoK1hzSm8wmdiaAf33qHi/nVX+C/z3M6WAb7QzbdPonvTqU1j22JlZDr5Sg91RLsxC7dazdPYvD2yvxqNbT1BXGheGd7eXu2yHnrcKtKLHJ0QCSY8HiRUbPU4Y/bQJ08AVmSbyKpeQX2+OILr+t2bXPBheqaxaBvbHViRVsmMFDD3zvZAMdAz+h0JnajM8IstQhPfQNSuXnoKlBpjy3czpL6+b/WPMm4CgE0hO8kFb2/2NbECjjE/FAB7+xGw9cO2t/FZicQK/IWO1pvZaioOj8YsB550iTKwlAxGkkfziCs5RQIs/jB1RzcrKZsvbbu20kt4MAioX9i6N5s04XqNnBuboruY7ZiqbKYH+s8R+j3OjQ93bi01012Ml8wZtGH4NRINL4spm2JlKkRoBv86iQGgYdFBTXaaye0HYsQrCG1Py58tQAl5KgI0bbID8qNKr0posvW4m7XuvEu4Hpy+llEII1KxD+s0487h5eXkq0VG/iOXi8pNEWstlggKodo8BHKABXU3PlpTVn/E96fjjPuPpJTcCgLBSy8E4z/2+e1DnFDgMAv9s/rfaELSHlQej4pBja6GIJefTV2j7WgO5gKHvvbN3CgWNWCl1ISMci0QvQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(36840700001)(46966006)(108616005)(24736004)(36860700001)(478600001)(82310400003)(966005)(8676002)(47076005)(70206006)(426003)(186003)(6916009)(8936002)(4326008)(86362001)(70586007)(5660300002)(26005)(2906002)(7636003)(356005)(82740400003)(336012)(54906003)(316002)(7416002)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 15:24:35.4587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69d324ff-753c-4430-c291-08d91ba3601b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0257
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 May 2021 11:18:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.233 release.
> There are 323 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.233-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.233-rc1-g7c5a6946da44
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
