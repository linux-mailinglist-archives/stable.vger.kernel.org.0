Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25288441C13
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 15:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhKAOCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 10:02:55 -0400
Received: from mail-mw2nam10on2046.outbound.protection.outlook.com ([40.107.94.46]:48160
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231693AbhKAOCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 10:02:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1BSnX1ndEbGki3EGOhNWkVb5YZcXMhCNGcVffvdi80P0e4fnw65fXE8VmAk/NTKx9LwusDpmXdeKAsRAC2guf1puEYVvVvdqfzzyc2h+tHlhO0Q6HaYbsd97XXXxusNYMWpoV3MQXJhvDTrgJBL9f7lWofKnmzR6DzPsJ5mv4LI4em9yooG39LprjQuBgrUOrbEXoOSGNsVEm6mHtgEN9mQ2y3jtRvtDwSUZosw1R6fQ31F78qhPE3Z47ZMRK9bbeWSwICijPK/EB84khFspdcitokpxVV2IVDHXULQSLezm1uJOYQGlugIFp1tHW3m+MGGhvUj05XPSyBET+o/4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MIJ4fwqJVEUaI8W+DlelSd9XaFhNTad4n45yUqnOyhE=;
 b=KXt/EuPRZvuYSRqMEBaWvwE51KhLqR+wmofSqWz91GwxeYofy8aSTF7w/ZQ8+EmIqrg2IZS6vxtYstwnqWE2anxEv9uYZE56Eek1JxtBWSvsYpbX8WpGt2KbPiqZHS+fjb9uwiAhS/mO0h46pGZF5dc+pS746TJJBABKq6/ouUzKSf/gQWF037iqF2yd+pycWVTQhjSxpcOsJP9dk4KdYvaIBROBD3ZhiclOr0qHzOFPamfIZ81iRoxtbTeZHUeoPrkKyaPdJy8ROtVc8STWVUkU5JkkgLNRNXx7ztPWjFv4hMZsbEnD5wG6B4q0g++lya5+GZKyoqPIrpe3r/Ff8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MIJ4fwqJVEUaI8W+DlelSd9XaFhNTad4n45yUqnOyhE=;
 b=AnQcVG+atQNJj2mIF9r+NuV+8RwN/ZwDgn2+kyM0vfXxSw4iKvtPLmV/cxgHcv4jw0Gwk7km9H5CCkldHYc54LBssi9jqXGfczXX/ArFEx1rDbQ3AibNZ/BROvmPNREw0fX3W6o0S25i3I+ikQV/kBTCaCZCErR3yyZTHMz3/SoTT5eMt8twFMJwNXBXBd8pSm5XU790eXWq4Wtcvpu8eDzDAVlZ9Xm/9c+6sfdILMG6JqyLRO4YIg/ro6axEyDTuUrfXlc5jmc1fNAv7R47M/UL23zTD6QLfF6SgJt/udFpx9PymXrR4lntyW+pwnslu4dCBrFT4NSMhuxGv3MjHw==
Received: from DM5PR16CA0032.namprd16.prod.outlook.com (2603:10b6:4:15::18) by
 DM6PR12MB3947.namprd12.prod.outlook.com (2603:10b6:5:148::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Mon, 1 Nov 2021 14:00:19 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:15:cafe::81) by DM5PR16CA0032.outlook.office365.com
 (2603:10b6:4:15::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Mon, 1 Nov 2021 14:00:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Mon, 1 Nov 2021 14:00:19 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 1 Nov
 2021 13:59:59 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 1 Nov 2021 06:59:58 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/25] 4.14.254-rc2 review
In-Reply-To: <20211101114159.506284752@linuxfoundation.org>
References: <20211101114159.506284752@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ac212ea4708945b98ba7302b02dfb23a@HQMAIL109.nvidia.com>
Date:   Mon, 1 Nov 2021 06:59:58 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccf3ec9a-6120-490d-04de-08d99d3ff075
X-MS-TrafficTypeDiagnostic: DM6PR12MB3947:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3947A825E6C203BE705BEF90D98A9@DM6PR12MB3947.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cGMynlFxXtJvT2fr3QSxqyRfwKuGgzkgb+PR0FBC89zQuhpowQQ/WzZ3nMFqAldkFsT1aBpSltrWIjL+Br9IYi3mji8XyP+SyxEXl+q9LsfZkQfE1mNwyuyfO3vrNyIPZbaMukuTms/Kf+avf7Fx9vsNugJn+XLFEJTY4WkYiJvr+8NORhRvvkEiYrTpUhXQvC8SRcr00YF7yhn/jD2sJn4E2bhGBPV146u/+zA7Slmmrf5HCjT8SipWk2XHIDAV4gGKiIbsASCHIWpF4j3EPAejrzX2oZXB5myDNJm8jp+q6RG482sKv1NObn0WpmQ/T/CY4A8tlvi5hgE086lPQaVBGuL1uSsuBED7YvKTWbzy0WcG4dJmetzggBGG9eRzs8YStHo5lZkUusDgcP/JN0a2l8rbrlkYIDCXN07VBeuGgFRzZXf1bXOXm+an8+ahIkPHBHMf/I2jLL965/aAG/5cDZfPwClLWz+7ssa1fZZxMQUUHlTxdEANaFdahZGWSieYr8spbRukkUkOPi4zbyAFc7VT3xE0phyotmTUc1j3dAa5ilbd7V9HZ9cLSazYxZTvWEqK/VROUp00OkLNZZkiUzDAwshDf1K+92+hKTLSlYkllGGHE4xu+BAOkMrVhwIkOApDtD9ubF0Mn2xBZDOQA1p9qgO6ogR7WRCUZnmjyZu/cjS/1EwFukL58M7Y/Xbkf0CkeAMzXSeXxFX1KNBvWGZ7rAbdo+x3vEje5QqqxHw8LXd7JnSUbjVeS/Nk3NAcH3NuvIiNDVSTpgCEPLrv/mbKBKCUR9a+ONdL7wM=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(47076005)(36860700001)(316002)(7636003)(356005)(54906003)(36906005)(6916009)(70586007)(7416002)(8676002)(2906002)(426003)(26005)(186003)(966005)(5660300002)(86362001)(508600001)(70206006)(82310400003)(336012)(8936002)(108616005)(24736004)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 14:00:19.1317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ccf3ec9a-6120-490d-04de-08d99d3ff075
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3947
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Nov 2021 12:43:20 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.254 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 11:41:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.254-rc2.gz
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

Linux version:	4.14.254-rc2-g64fad352ab39
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
