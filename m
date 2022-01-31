Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7164A48FB
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 15:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377344AbiAaOHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 09:07:02 -0500
Received: from mail-bn8nam11on2055.outbound.protection.outlook.com ([40.107.236.55]:5998
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1359088AbiAaOHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Jan 2022 09:07:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXcnHg7eFVERBP1tsjv3uL8nfu8j9MhaXcXaWaYcDBmI0OET4+giTKNBMtDcRUn20Vr+B9FS1KnYUtTkUeWUKjXE7xlQj/hIHEAT7c2itb64Y4G51O9ySnQQ3YErVGl1oJMXYzhzIr6yEibh8yTVNQgd/aM3q2nRjmp7SobgPpj8ETL7QNZXme7DXj+2lORppRd4bbCzCBhecvZuh22WfqIWxaOXO9eKdoJ0EEsKoWhuI0jshZzbjvgmmBjD3eHO55ynDh91hM9Pi9R+XuIJ3IvoAg3Xhox/IfGuEdDYfcCDRAzGAHkmt+REfvESpSzYFeEFmonCmPXzgWcvOIXlIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mbuB7o0hJpbPSwefEvT5m1cbYHdjzdruihCpuwQmp6Q=;
 b=i5UShTCqR2sQdOJcrNlWqwu2iv678z+bv52UQ7ePCGQsEZatQ/LjWzYv41RwA4mA3SMIOTVHot2z1gFjxa1zTVyXRAPYyQkUzpoq8TMiDF9zHNC7hAvmIeVUh9JiRiyk8vXag5oyc8mSVl3oYlbBfJLOhrxoMe4y0xz+oH2r23oRKvIJUdfRh2TFjYHcRRn60mACtaRXd/pys+dUQs56ERd3DGKPHnXAvt683kx2j3EaYDoOtTX26CyknK0pWI9N1h3SwywWwQLUvILbSsaSqgtVxVOiJZj+NUlA30HNGXA70DbUUMCfALjI5n+jvu1Ib1lrZt5KBL5iT8bQvNn1qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mbuB7o0hJpbPSwefEvT5m1cbYHdjzdruihCpuwQmp6Q=;
 b=P/wpxWfwydT7TLkqOdj4QXv7Ocovd5xNI1Tzx/pItyfEmlxk+h34JpGdbtFB94Cet3tO/C8NQcq7TcLE/7qOUJsFHhZiyrPcP4jt4JeRzPtR8Momcuttr3cEprB3dVSeqU+qX6NE9r1FIXCF2NKcn/o/BpOBefZG3pBiBQRKxIUQ/VgcaZ1+v3u8Rj1tIhMDJ68seW9kfL3SrlumE9NjlcqihJQFC9S508ESL1p1LyKMwGS1RgUQ+Y2Pc8oPkTVoPB+zD5oSYJIZ/MkEbpusLBo6pKBKMGJ6dOwo0Z/C4et4lirZ8rlvURJo1Tw9AfLof/prVmnRaL852xH7ZC8mtw==
Received: from DS7PR03CA0214.namprd03.prod.outlook.com (2603:10b6:5:3ba::9) by
 MN2PR12MB2862.namprd12.prod.outlook.com (2603:10b6:208:a9::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.20; Mon, 31 Jan 2022 14:06:56 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::53) by DS7PR03CA0214.outlook.office365.com
 (2603:10b6:5:3ba::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Mon, 31 Jan 2022 14:06:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 14:06:56 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 31 Jan 2022 14:06:52 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 31 Jan 2022 06:06:52 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Mon, 31 Jan 2022 06:06:52 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/100] 5.10.96-rc1 review
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <eb1e157c-d003-4b5f-900b-e316e2b933aa@drhqmail201.nvidia.com>
Date:   Mon, 31 Jan 2022 06:06:52 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 990b7ac3-054f-4833-22d9-08d9e4c2f0c6
X-MS-TrafficTypeDiagnostic: MN2PR12MB2862:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB28626899471D559CDC4D749AD9259@MN2PR12MB2862.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DVIsn4gcfMqKi/wZ1vCVn2x5WYYg0Ji6JrLVji/H9C+e+lC11E0wO3EwXf6JoIhyusPqPbjI1Ucc6D3qsLJkCMrrRhE1qWd8fmzGnxm4EhyrjK/eH2cfyMyeKu0IJh7eVpRWhSVe2mzPoRHZk+suvsgMTrqVfVu/rtjVrbBpdm8R5CHVdGpirzt/DzPccVgjkbMML9tT7FrEGPpG5EZ11CMZirTVECWoyjfyAWVsMZVsVB5odFr4wFgQZBk5EUqQRyugtbpVAEWxnl4qOpcj7o5tKfuZnkbMRlf1bjuBJfpT+uUFNVZjKYVAxYm77Nf+EoYkz6EzdrWhI0YpAADrkyNNfgYIfDl9vtSI9TsqLS9lNuxSxKDyYoAqi6Q+j0kd5lT8Yaf5NhO5HD17+IqLpPAiCJCMap0znP2hrFeXZuWpDn51bjTziKk22MGrVc3QepDWAdxbK3+Dyq5hRwq8PfKeHCs5HS2mxsWeDHCAyYMDuAJDYCkO3oaVN8PRASAvfpEfEKYPuB4KF198ahwOlUOVYDXQ02moBhVvg5d7smW+nOUi3uDloX5TmlbKY8j6n8672q5JqVNjHvTFE5FtAVS8UI6cMyTyL9kNN0QGImY00nEPxWVJC5P9bSYncIvVkd//2IJnjJdiT+gEGBiIeHHY5oNYjv2Fte+V3uC2QwyGKtKUJLShK4VHPUL7riUexEw9U73htqDSJGYe8w7f8IXmTvChwbZx+fMbCKJC964pIxl58BS4mix58v8lW5e+oHQidUpoMmYia1xGKxNLzXzh4l4E7B0kzAEX5cggq80=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(47076005)(36860700001)(31686004)(2906002)(316002)(508600001)(54906003)(426003)(6916009)(336012)(26005)(186003)(8676002)(8936002)(86362001)(5660300002)(31696002)(4326008)(82310400004)(7416002)(966005)(356005)(81166007)(40460700003)(70586007)(70206006)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 14:06:56.1597
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 990b7ac3-054f-4833-22d9-08d9e4c2f0c6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2862
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022 11:55:21 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.96 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.96-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.96-rc1-gbf18cfd8183f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
