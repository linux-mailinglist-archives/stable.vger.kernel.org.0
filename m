Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4963A1040
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 12:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbhFIJi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 05:38:59 -0400
Received: from mail-bn7nam10on2053.outbound.protection.outlook.com ([40.107.92.53]:59632
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237993AbhFIJi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 05:38:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gi4STuJsiSllDzWO4c00SBgmAAQ4GJePLCXSUmJU1ZHqeK4OSXQGGFl+02NT9lxA60cod55WyUlYNaGmmW+hWU/NRUdZIvrX4cWDsZiCPOSABl4PuX0lpy1Hv/8gY8z3TY7RZPosxFQqIZiihu/4obbQhhgAYekNP78iVscbpSyxGZtcBepfhfeWp1NjyJUNUN+1IFepU84/s9NDXosgRGM5adNaQboWJ8tFB+P8b4WSt05vPQUe3gZIYOFnOIJR0OwQNN9o+h9q0PF13FtmAoBzAZfL+fR4hkzVJB3Dup2s2UJnxi6VrFvtaxu0NhL3fVNgeejsAsc2pd9t5xlDjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuB6V23FB7h7O2/jbgTsD1YN4eXXeYxLlsw/Y1YlPUA=;
 b=nRxS7EqFPkgfI0j7bNJ6936J0BgQwUGpZ+allCzIqjQ5eJahUg/Q/IPy0MYNQUeajCQJSri7HrLECgN7tlAYOW/RR79+SYdex6dli1e/rQP7TfofLYG3EqtKP9GaQ+Rl+B/r+nX7Ys8bgIhEU+9UhkjSYgKWsb+vLkrOA+LSLjA9DsOdTkRojjTTI8oHaA/o0iEBTz4y62cCjU1mHGVz4NALK1GGl9aiDGEzxBE456soV6MtKmwtzRJ1OOlksj9RG7onC8tinlBssJXW4imfyY6DKhJgWvippjzPia++QNOR4SE6EMcSZm9eXouuFwVDTlkIj/U2+/Gy16yJcvvNBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuB6V23FB7h7O2/jbgTsD1YN4eXXeYxLlsw/Y1YlPUA=;
 b=H2b4H5NNGri3WiUsvEwBhkAvtZEPvSxOYdF7hYxFg/y1zj+d25c470MpL5LVNGIdFC9Sh67gYCXMvLnDNsRNszFs8nd1C5ntVpqT/2wd03CebkKS4Zs++T5XU2l3lWRsjK+OaGs6GJwvLSuwfImf+YUKnh1ed0yAhHp76YLZgUvbRf3ANkS16k2CSZkNySj25em0ycvbCOug+otuePWTaiM6af1h//7hyn+lc7PGEdB1cIBJQIWVbzV86pbGLBehhuPMWOV6fAZA8rTj0d7OIQSKRw8LTRrmPjT3huVfVCPGWyOSU+AnPQWr28afQOI/aQ0EYU0rGgtXR6h+S8Ce9g==
Received: from DM5PR16CA0042.namprd16.prod.outlook.com (2603:10b6:4:15::28) by
 BN9PR12MB5210.namprd12.prod.outlook.com (2603:10b6:408:11b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 09:34:06 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:15:cafe::50) by DM5PR16CA0042.outlook.office365.com
 (2603:10b6:4:15::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Wed, 9 Jun 2021 09:34:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 09:34:05 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 09:34:05 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 09:34:05 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Jun 2021 09:34:04 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/57] 4.19.194-rc2 review
In-Reply-To: <20210609062858.532803536@linuxfoundation.org>
References: <20210609062858.532803536@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2d9387567d014625aeeb05fcd179db54@HQMAIL105.nvidia.com>
Date:   Wed, 9 Jun 2021 09:34:04 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79daa2fc-063c-4c3b-11c1-08d92b29b9cd
X-MS-TrafficTypeDiagnostic: BN9PR12MB5210:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5210C58AC1491EB589591F68D9369@BN9PR12MB5210.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NXN17hPor9a8v4PGCDyEjApjK1tT23ANVuSk+vmf41fnyTxDWty3k6Dox1NvG+e61QZAcYFuR6zpkDL5cRJ6sx7kjnBd45zIi6dwn3qQBh/gdDOsAjNEiCgQdObwFRFYjccPRLjai+fPK66W+G0R5hX5boNnTrp8lj3EmaPOAMpkE/WA0o7Rs+YmZpl3+O9sLFiIr8tlBWWUODJYaxIhUv8bKVgjrxuvdyPf/yqL10Sz3Q4rkRF0A4BYkVuKKpVB8S1xFBAE1eJvUO8ObmKTirS31RKlnltf5GVpYp7B8RIfWfhFIEW5FOz/uY6e3Hm01qx0f2CPxLqhyaXDd5Kyw2KeaNA/dXEWZBlrBxF3A8sWRe+Jjr9NLPFQpKlAXiX6on5hhjflSR6/Uvei00ZcIeQQOimvY/2KhY5NrQNZZ/tGHPgWPmQdylAT9nQOIKL5Wj7LyyjZygicvsAnODfSTz5dkI/LKRiOmrms6/De5/Q65TmSyhgbLkkmn06DQNrYxWci7/QXtrlMiRqQ3NhrYBHHPHyRvWK/1QUQHtJ49AqXOt1hUcrJvrZa5Iv9kg7XQpsd2U8di23f6Nd2uQ9TetTfAW8ch4scdbwlap2Z7IECZVarkkAF/GDHk3GeP0ITdoBLY7geleG9Ti4/jYNVfHBHBoUeLqhMV8/C0rzWAwvokC6inGR5i45NooCzXlqEkwQPPMes4s7D33d0FdqjQ/xm7eqyWvGjRXYObUSdOufJRQ0qoc6DBxWiT/8kLi1IJj2MREc2TRQ8B6w6FSObrA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(36840700001)(46966006)(86362001)(82310400003)(70206006)(36906005)(70586007)(82740400003)(47076005)(7416002)(316002)(426003)(54906003)(5660300002)(108616005)(26005)(7636003)(4326008)(24736004)(8936002)(2906002)(8676002)(336012)(36860700001)(186003)(478600001)(6916009)(966005)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 09:34:05.9414
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79daa2fc-063c-4c3b-11c1-08d92b29b9cd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5210
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 09 Jun 2021 09:54:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.194 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Jun 2021 06:28:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.194-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.194-rc2-g3a6c65ec05c0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
