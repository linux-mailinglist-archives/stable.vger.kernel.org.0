Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DCD36B3C3
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 15:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbhDZNFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 09:05:20 -0400
Received: from mail-dm6nam11on2060.outbound.protection.outlook.com ([40.107.223.60]:24194
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233508AbhDZNFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 09:05:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJqmWF6l8+Zl0AgWkpwSJY5WIsfelu90hH0t9qP1h6bnO3pWkJJ2fLT+lHyvg2EEZk+O2z6xw16SEAe8D1b1ReCCzmO2L/+3Ch6L1HA+Ff43e22dXmrnU+LeP2L0ZxSi0J86dMsg9a8OZCL2b4GozA6OYPccpX/LKszsIVPOMlP5FbrCmn1MBwrCI4sGQEAwVT38qkWEQWTbi6CcTR2OunFhm9QN6Penv6rWGvl39qW31cDtS2OgcQ+LkUl0iACfnbbtW5AYbzjxDHv5IHJapgSvFpYcmPrtTZMPGICQZHWMVAD+r5pfoAmTX91Qd4xcnuHobLoJsmFBGlNwiABbfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cTIrXnPXbLQwRgYWzHPaW+afjCHC8IfGdci828Rq8A=;
 b=Nwr0MV5GC5WUIs1NjEhQAVS5ft744HYyQs5xEpsCATAEysYa87f7tzThLK06scAXRchlNljaIW2vNm/keSLvxYn22UkSfUuEV/1hXojYnffRQ+s4MLxuNPwLNGXKZ8OfToayBx2BezqZIvM8Zy8fTmKGhhTZAaKTc+qaUKltu/xEooiv6eRjEJrKCHsrRcH36Qoc0w9azNiN67fefEO5skYjd3xwUSN/2jqO8Jr6+wIPcF0ftHwPQgiCHQbiRx9p1RPZS33VW1VQhsJTp4uZDixJg5IcAH94ZFcWI1+8eCJFgwIvqKuMNC9E7lh+TN5EknUx3l2oEjXJrupeTuY5aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cTIrXnPXbLQwRgYWzHPaW+afjCHC8IfGdci828Rq8A=;
 b=P//wDDdtzk3du19vn9X2WAzPdV0QPyy79xKDm9kOyHq8PacXHKpCLiFLkzipzkgAr3v585iljvkSqF1frrSldLhUIndQ38uqTdudxWEFCSdFYdwUaXZ40l4Mz08LSkx+8WK8q3Cs7jwFWMQ5R+TxNXEcYUdXEX0RjPR9Bx51pWGNet8twyV/TT5bRfNV0MEmq5mBAWEcR0MHQyjd2L2oMazMQKb1Lb8JGPT9dZ0E9FoTMtu7pTZDpaqhGTJy4fCN8b77thDl8Qa/nThE5faLO+bVbQcl9U76Xef/AtDW9vbJovg7Mblm01fGIaEzoUBfSextCeQP+Fu+C9TP1rPR+g==
Received: from DM5PR18CA0079.namprd18.prod.outlook.com (2603:10b6:3:3::17) by
 BN8PR12MB3171.namprd12.prod.outlook.com (2603:10b6:408:99::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.25; Mon, 26 Apr 2021 13:04:36 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:3:cafe::1e) by DM5PR18CA0079.outlook.office365.com
 (2603:10b6:3:3::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Mon, 26 Apr 2021 13:04:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Mon, 26 Apr 2021 13:04:35 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 26 Apr
 2021 13:04:17 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 26 Apr 2021 13:04:17 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/32] 4.4.268-rc1 review
In-Reply-To: <20210426072816.574319312@linuxfoundation.org>
References: <20210426072816.574319312@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <bdd34758124d49ebbf162a4565a8b5be@HQMAIL105.nvidia.com>
Date:   Mon, 26 Apr 2021 13:04:17 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b20c4c3-fc24-4f0e-913d-08d908b3d7b5
X-MS-TrafficTypeDiagnostic: BN8PR12MB3171:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3171755ADA13EBCACA202780D9429@BN8PR12MB3171.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l5OuRUNoJmj+JIZmAr0dKNoYpKWHk0ex1WwrRvCHabOU24mTefPZrCXkQyYT48TVeFU/Pg8Nz72cIS+KvLkczjCx7tdPmK3GUJNaPUj4ygWr4lXAZAbtPbB6x/ghTzH4n+TmGR+P4KvEOo4mYSjnH8M7uisxuTKdWHv+CPDZOg8KjN3llH6SDbLrg1U/R+NKTIyT2bSNt/pZokumc69BZvfYh4P4TMcduwM4C3ZlmoVRAnj7M1JniLkTuOXPyjegEhUdslxFvBesYFH6GRNB9tl2uuzsuPa3VXnVcItJ2dDRFl18DeDf6pcRQqVyNj7qKZH+ps0qjTnPod4YA1YMLdCHfJn2uut4pe8fxGOkAro52Lhp35ACBy+Er7ICd8cfsmGrPKUQeNXxZ6zcZD80jt9SAUfgB3W7WfHEGswjBWU2EkQsimzIUtmfStRLnayMxldlLZ1iTCJNstol8GCBuRo9jpSp+7zFftxbL6hqByPLLe+raTS4floWa2v9BfCb4uehiaioVsVaSdYMG80rmwGKh+1OhcKoN1dvXq2MCE4Nva3erIcRHE573Yse+kgIj4JxPt25xQnwFgTT7sOFz/wkK86pOdNosoaEUd/1vqsG0AkufeWjW7SREomOdoIU/UDE+nPJ/ejn5fgpoZx4nqH7LUrFUid8jmC0qmOrL00f4FJ9eDuSQ1zl2HuaUKeg28EKCbs6a/woPlRr9b8qIMRjU9SMPtPc27BjKGVX62U=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(46966006)(36840700001)(7416002)(70206006)(70586007)(82310400003)(316002)(54906003)(36906005)(24736004)(186003)(336012)(426003)(26005)(5660300002)(36860700001)(7636003)(47076005)(356005)(108616005)(8676002)(8936002)(86362001)(6916009)(2906002)(478600001)(966005)(4326008)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 13:04:35.9725
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b20c4c3-fc24-4f0e-913d-08d908b3d7b5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3171
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Apr 2021 09:28:58 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.268 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.268-rc1.gz
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

Linux version:	4.4.268-rc1-g78d632f91b0e
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
