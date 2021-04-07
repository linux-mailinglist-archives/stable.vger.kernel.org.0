Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D573566C8
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237995AbhDGI1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:27:54 -0400
Received: from mail-dm6nam10on2048.outbound.protection.outlook.com ([40.107.93.48]:21961
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237618AbhDGI1y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 04:27:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqWyxIytIS7ebZgTYPhla2zoNhcPL6uGpiuT+RYAyjGX9cUFFQZ0J95qMmDvtR5ZyMZx4IUeLKEKX2hAhHRoXe0MMqvv/T+vgD0mlb/NWwE7vY6yznCafwQPEm/5k1kzRAV5mo4+88/JDWNDNZCIRKLyYr6NX4+UF8ph2dUuvIrjGc3J3nKji/al3yfuJxp2ZjODCCS63MOUT5y25cTxOGnoDHr61K1lj5K5eF21IyK2J8nlJN6xGqleX7VWJi7bagK8QKosirFAPgSXlQkMeeB0F5IOI5StkhwWi+EzjHNMuxZoj+PvZVcHSeO06j7hx4thTu66npABstJEnHFrOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwM8jaHrnE7p2P99D1PjINBIPQLu+96S1U/a+2h0h+0=;
 b=nc8NV+JwRx+eRnoO1nFpEjrfi38uHBKtP7J6URrnTK2YOlFPimI0ANCAwSKsDT84WMUt9bjnR3+sO2XNipbTspUZKlA2mp4xkyk20KrqGPiYIjh2BMwgZzlBVkMaXlKB8r5eSx9+LSyOnKC5McO0zId7VDB6hYrf1elO66r/7ObOjN/T/lHF9f3BmBNjnCWC5dC5BcKrOUR2fC+1M57AmTjnmaw7mJv4hMsJsWvNP8EghX1A4VxGIIUIxtgn7kX4GN2FMsLt5S209tCt38Eo/LXRGzFM8kIBpur5Smsd1Z7nB0v6zLwz0mfK653JmBGzqptBfdQuaZkdxLS53bQmbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=roeck-us.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwM8jaHrnE7p2P99D1PjINBIPQLu+96S1U/a+2h0h+0=;
 b=Seg6KKQ8H0WShD/cutHa7yHXPBknBF+I+Nu4nYHsYgfN8MlBAAsTqG5cusnfMAHY9cvcxiG12KZLXyqPts5L24KhQmvUmaj7vgPC0K0tbJpeMn1imER2QEF02jFZzRP+FQ/HiyZRvY+akBmsjm1D3jE5B3Vxvam4EOba4gIqQJ9eGOLsFJtAAvhLx+wWpKXczvsU2ryoqCRO9zIDzweLKJoUSrHZfXbd8SDoaLYE/2PpPU70rUkyoovEZwuclN3R6eb97wi+zZHwFoue7JNYToznylXpNiAaX4cNTPrr39xh58kN/mt8qlqDcDT9iYkRIhlAHWdja4iSHFO/vYT8bQ==
Received: from BN9PR03CA0274.namprd03.prod.outlook.com (2603:10b6:408:f5::9)
 by DM6PR12MB3898.namprd12.prod.outlook.com (2603:10b6:5:1c6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Wed, 7 Apr
 2021 08:27:43 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::23) by BN9PR03CA0274.outlook.office365.com
 (2603:10b6:408:f5::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Wed, 7 Apr 2021 08:27:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3999.28 via Frontend Transport; Wed, 7 Apr 2021 08:27:43 +0000
Received: from [10.26.49.14] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 08:27:40 +0000
Subject: Re: [PATCH 5.4 00/74] 5.4.110-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <f.fainelli@gmail.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
References: <20210405085024.703004126@linuxfoundation.org>
 <9d26603c91264ce4921639affafb16ab@HQMAIL105.nvidia.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <fbf7fc89-8a74-3a92-63be-6cb429360b13@nvidia.com>
Date:   Wed, 7 Apr 2021 09:27:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <9d26603c91264ce4921639affafb16ab@HQMAIL105.nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66f19456-95de-4874-2d17-08d8f99f03d3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3898:
X-Microsoft-Antispam-PRVS: <DM6PR12MB38980AB5CF0D7AC143A7AF99D9759@DM6PR12MB3898.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gusJPzHqgeXtKWq1RwbVD2lRIZ/hQ8qbC6tKnADpdsNZcZB1Gz7fmhtna7wYXRPd96yPv7sIYMpGJBVwcp54nlJiEtXMRLsXr/QxIQJZVr/3wFRMp1JFMKSB4C9zi4nIYtpal/blbABaZnvV4LFVRzp3eA7Y86/UmqvvKFoc+J/rOeCZa/AitkvSROYswT7gOfKUshp6MsC8Nt0Pq7wzNf336ThKQfplybsFREJiv4tHC9lcqvyFxRpSfimNktJsSpk8ouimw8Y2ps84xneEPYWc2dPtOxB0wCFdMGBlFNxLuNz3zhWT15J0ZPGfrGADl4j/kkAhk2Ae+YzELYSipFH4e9GJPZ2sWO+ognLfZjPEoxxL9cHdJVmOUBsj/lACZ8IdIp87qe9G8wZ/x/O+0SIVJFLGQlUs3HfWrKCUY6dWCWtkkJxMRTi1ZYuj/vxy4T58JT0ZdQkzb4gti2/95tst2U1n0GRvD0DR8kiLNbsjozeRou5YUVHqKrveF9KHZEgVvRkGc+oCt7TGvRztGrtnXAGXouwfEWTd0XY6XpJmK8dIRHlUlPLVMq+L5yqtnAGrETrRTq3LLW35rFjYuyyK95hUxRBII3TBI93JFdLchbtiqNLZc3BzO+9/aIL2uvks6GtqJ+49dR7RtncPXXTLB2OeP5XL2e+tu0+NzxqPTliQx0YB0hnIHQNzn6jaVqiDdSlfhK7OywW/qVLI+VzPvWGJPHrpFLIjo+d079UdynlB4+Il7K4jo5MYqrkn4E7BWiITnxBFnB399bJY4vlTJ5MoqKFPDxnyhYHVF9Q=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(36840700001)(46966006)(4326008)(2616005)(356005)(31686004)(36756003)(45080400002)(966005)(16526019)(7636003)(26005)(82740400003)(336012)(70206006)(82310400003)(2906002)(426003)(6916009)(47076005)(36860700001)(54906003)(53546011)(7416002)(86362001)(31696002)(16576012)(316002)(8936002)(36906005)(8676002)(478600001)(70586007)(5660300002)(83380400001)(6666004)(186003)(43740500002)(357404004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 08:27:43.0393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66f19456-95de-4874-2d17-08d8f99f03d3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3898
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 07/04/2021 09:21, Jon Hunter wrote:
> On Mon, 05 Apr 2021 10:53:24 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.4.110 release.
>> There are 74 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.110-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v5.4:
>     12 builds:	12 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     59 tests:	58 pass, 1 fail
> 
> Linux version:	5.4.110-rc1-gc6f7c5a01d5a
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Test failures:	tegra194-p2972-0000: boot.py


The following change ...

Thierry Reding <treding@nvidia.com>
    drm/tegra: sor: Grab runtime PM reference across reset


... is causing this error ...

boot: logs: [      16.166043] WARNING KERN ------------[ cut here ]------------
boot: logs: [      16.166061] WARNING KERN reset bpmp (ID: 89) is not acquired
boot: logs: [      16.166132] WARNING KERN WARNING: CPU: 2 PID: 90 at /dvs/git/dirty/git-master_l4t-upstream/kernel/drivers/reset/core.c:379 reset_control_assert+0x174/0x1a8
boot: logs: [      16.166136] WARNING KERN Modules linked in: tegra_drm(+) drm_kms_helper drm snd_hda_codec_hdmi snd_hda_tegra snd_hda_codec host1x crct10dif_ce pwm_tegra snd_hda_core pwm_fan pcie_tegra194(+) lm90 phy_tegra194_p2u tegra_bpmp_thermal ip_tables x_tables ipv6
boot: logs: [      16.166216] WARNING KERN CPU: 2 PID: 90 Comm: kworker/2:1 Not tainted 5.4.110-rc1-gc6f7c5a01d5a #1
boot: logs: [      16.166220] WARNING KERN Hardware name: NVIDIA Jetson AGX Xavier Developer Kit (DT)
boot: logs: [      16.166233] WARNING KERN Workqueue: pm pm_runtime_work
boot: logs: [      16.166242] WARNING KERN pstate: 40c00009 (nZcv daif +PAN +UAO)
boot: logs: [      16.166248] WARNING KERN pc : reset_control_assert+0x174/0x1a8
boot: logs: [      16.166252] WARNING KERN lr : reset_control_assert+0x174/0x1a8
boot: logs: [      16.166256] WARNING KERN sp : ffff800011bc3ba0
boot: logs: [      16.166265] WARNING KERN x29: ffff800011bc3ba0 x28: 0000000000000000
boot: logs: [      16.166288] WARNING KERN x27: 0000000000000008 x26: ffff8000114d9000
boot: logs: [      16.166303] WARNING KERN x25: 000000032b5183e0 x24: ffff0003e3443800
boot: logs: [      16.166317] WARNING KERN x23: 0000000000000000 x22: ffff800010710638
boot: logs: [      16.166332] WARNING KERN x21: ffff0003eb967410 x20: ffff0003eb84a360
boot: logs: [      16.166347] WARNING KERN x19: ffff0003e12fd080 x18: ffffffffffffffff
boot: logs: [      16.166361] WARNING KERN x17: 0000000000000000 x16: 0000000000000000
boot: logs: [      16.166375] WARNING KERN x15: ffff8000114d98c8 x14: 00000000fffffff0
boot: logs: [      16.166416] WARNING KERN x13: ffff8000116b9fa8 x12: ffff8000114f25e8
boot: logs: [      16.166424] WARNING KERN x11: ffff8000114f2000 x10: 0000000000000000
boot: logs: [      16.166430] WARNING KERN x9 : 000000000000017a x8 : 0000000000000004
boot: logs: [      16.166436] WARNING KERN x7 : 000000000000017a x6 : ffff0003ee17c180
boot: logs: [      16.166442] WARNING KERN x5 : 0000000000000007 x4 : ffff0003ee17c180
boot: logs: [      16.166449] WARNING KERN x3 : 0000000000000006 x2 : 0000000000000007
boot: logs: [      16.166460] WARNING KERN x1 : aa01989c70ddbd00 x0 : 0000000000000000
boot: logs: [      16.166467] WARNING KERN Call trace:
boot: logs: [      16.166474] WARNING KERN  reset_control_assert+0x174/0x1a8
boot: logs: [      16.166516] WARNING KERN  tegra_sor_suspend+0x24/0x88 [tegra_drm]
boot: logs: [      16.166526] WARNING KERN  pm_generic_runtime_suspend+0x28/0x40
boot: logs: [      16.166534] WARNING KERN  genpd_runtime_suspend+0x90/0x240
boot: logs: [      16.166541] WARNING KERN  __rpm_callback+0xd8/0x150
boot: logs: [      16.166546] WARNING KERN  rpm_callback+0x24/0x98
boot: logs: [      16.166551] WARNING KERN  rpm_suspend+0xe0/0x480
boot: logs: [      16.166556] WARNING KERN  rpm_idle+0x124/0x140
boot: logs: [      16.166561] WARNING KERN  pm_runtime_work+0xa0/0xb8
boot: logs: [      16.166569] WARNING KERN  process_one_work+0x1c8/0x358
boot: logs: [      16.166575] WARNING KERN  worker_thread+0x48/0x460
boot: logs: [      16.166580] WARNING KERN  kthread+0x120/0x150
boot: logs: [      16.166587] WARNING KERN  ret_from_fork+0x10/0x18
boot: logs: [      16.166592] WARNING KERN ---[ end trace ec6031475f7a0830 ]---
boot: logs: [      16.166670] ERR KERN tegra-sor 15b80000.sor: failed to assert reset: -1


Sorry we should have checked which kernels to back port
this fix for. Can we drop this for v5.4? Appears to be
fine for v5.10+.

Thanks
Jon

-- 
nvpublic
