Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C02483F66
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 10:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiADJxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 04:53:11 -0500
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:24736
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230272AbiADJxK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jan 2022 04:53:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CzCLDRIaY7+t2ZAEF/fDjS5YIFOuXvQFAcM8xwlRLShM2ZrXm1VWNUIF6THzcOYQ+tGmj23i4jzAT/lzeFlxpTKIaMSnuO6fzMEyOLvbqT0/1Obk4FLs9JhD3hrDPYVraO/w5+e4vGzWj52vz4T4SzaBhEC3tHGvIaza2eBonaUtuc+Ha/znSwOuXnXIIV5cwmMDTnNchRUTDKoTtQXBoJpY7ohgrTQjffNJQyn7Bhorh9fVGDaw4uE0n0tYvL7fNnAg6629UA533pkLvqSwWUUid6z+yzZvgyZaPKThrD8btfozo1AV4xCzhm4THyAkzB97VRo3N8OPDkgtwyWTGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mbq+7aE2OvXdF41KDiO1SzZ4p53MSnozYD8Ve1CWN1I=;
 b=oerxfCSTtyF0nslxWcEJvWW223DBCQ3wbrSqz/6A+35HsLIKHUYVHKbcA22R9MRVrGxasojsSkYE92AAvxh8VCDRTGR1gtwQTVRpDWAvzbxcMwTRuG016Db4p3ke46RMcEe3ZeR2pZ2AL1EYUdHJHR6urLYYab1JD4HR8aIDpjA/BOQwot1B4l0ly1SPoyHjnBtqWcsMw4VdmE5H5WaL+pyImroIi6KGSfbe8Dhi7rxOUxc4F3YG1aI1USAex+CMZ4NvG2ZbJ1Z9g+/BiTilC/ITR+etAjsQ7xKXeOGS158fDCJ7N5nzFAYsx68XGtRem0mx0tDj2oMzog6RMTiokA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mbq+7aE2OvXdF41KDiO1SzZ4p53MSnozYD8Ve1CWN1I=;
 b=f6KT4nHx/U554Y0Fecy40pkd3ViqSgkvbdMBLkpHQmXip5Svo3cCgHVp4y312ZwQpWmBajARwEaKtfwQWTI1GrzgADm0LvDY30hrQzYMglhvPldCn333UShNIg9lmsqDTyDD9b6CYx3zYnGMMqD1nHInf+X+YNiCN+N/NIzjRUiHfMHv6vU5gI38NZQChRlorNJJnN84quXoIzprx6G6394dQzqGBXYLS9YDrfpYvavwgUSpyAfnrjhAUJUR8MlAx/svC9cx3VKhGrFSKUzWi4Pmk7pxxxbzpjizIw2OcPRWjxsTgrbcnpf16jan6FfN+DTt0Hz8AHGw9vkRbjp2Zg==
Received: from DS7PR06CA0001.namprd06.prod.outlook.com (2603:10b6:8:2a::12) by
 DM6PR12MB4418.namprd12.prod.outlook.com (2603:10b6:5:28e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.15; Tue, 4 Jan 2022 09:53:08 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::11) by DS7PR06CA0001.outlook.office365.com
 (2603:10b6:8:2a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13 via Frontend
 Transport; Tue, 4 Jan 2022 09:53:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 09:53:08 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 09:53:07 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 09:53:07 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 4 Jan 2022 09:53:07 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/11] 4.4.298-rc1 review
In-Reply-To: <20220103142050.763904028@linuxfoundation.org>
References: <20220103142050.763904028@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e8c7979f82ef4b1bb8a8379576521395@HQMAIL111.nvidia.com>
Date:   Tue, 4 Jan 2022 09:53:07 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19b8e95d-05ae-4b02-11a7-08d9cf6802fa
X-MS-TrafficTypeDiagnostic: DM6PR12MB4418:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4418E166A00423DFAEFC348BD94A9@DM6PR12MB4418.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YWqZC5d/oGYJEp0zke0gHKQCEXI+3bZQTYGrMni75/PzUH0ALnUVaTTz/yetD4UFT9F/BtpEj/VvfR01t0EX06hkylPZdvA/6fcEK0jE9gbgAsynwzNCqRPutV1qXBVBht6ouRCYS3+AQ/GYFcLYPR+lP3JKV27D8TyFDeeFDdyJKXIatHy73K89fDR4AAuJAgPv6avpBSQ647emjh+gyzTHqR8jMRufsV3FNovZ7ELm5XrQhRUextZyr7G+VQNaW8CQqm30ZzhowdeiG+uH4knQ0SL+KWlPKEPdolSGo+GECDheiD2gPpwCp1gKUkTOccQx9Edmy0nzrQ7CXifkKOH+bOfYCcVGkBrz/hg3D0OX8hFfyWFtHng6Lb1Xna3TQijJtJ53A3ADmaxbnI0rpqExorN5z6eNJbAvbp3TRhqGU5Tf7hWP9mqgdhcUrYOcb9owUBh8Fxg8pj4RZ4KGH4f8PcVhkgnctMhDUPU+MdFp8E1qYJb2yCuf+j2foVCi7HfHqte5kRTuaGadJxYaEIG7Aonxvg//5gLDjglFcg+rghRFOYaSrmWRrSLehLFQWrE4RYKc6AFfsHAA5vdrCOErPv1De8A+iJ7X7l34Z99lbQ0eZgcbJU8tdMwgiHiEFLojVlB/xuXPKDfzlHTQoDq4NbU6OCJwfmqtWbcIo5Ns4xzeO/CrOzcJ3MBZSJWZ/v6aC38CKmpczor18fsABaKGYl9e3KAyfXXJDAY9Py6ENZ+Sqh22vnvrlAkyGxxUMPGGhwIb2AgLwTgbbx5M7l6R4qnYOG+hoQxh/bCDdVCkOok3PlHfFcUDf/lXvnKhIzDVVfnmd/5bAaoNrhu33KCzqpQpC6r0yIviTG2z1yVElBv/7f/NYRuGXVXgHqGq
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(356005)(47076005)(508600001)(336012)(5660300002)(7416002)(966005)(81166007)(36860700001)(24736004)(108616005)(8936002)(8676002)(54906003)(4326008)(82310400004)(70586007)(2906002)(6916009)(426003)(26005)(86362001)(70206006)(316002)(186003)(40460700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 09:53:08.2033
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b8e95d-05ae-4b02-11a7-08d9cf6802fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4418
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 03 Jan 2022 15:21:11 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.298 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.298-rc1.gz
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

Linux version:	4.4.298-rc1-ga1c4d899b501
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
