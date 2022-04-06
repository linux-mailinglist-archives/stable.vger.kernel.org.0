Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708D64F5C6C
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 13:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiDFLlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 07:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiDFLja (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 07:39:30 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2088.outbound.protection.outlook.com [40.107.102.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24284578E8D;
        Wed,  6 Apr 2022 01:27:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWcdU3by2cGGDRS4OpMAXoF54FG3ry+gnj3qd40slqUkWZg8X3kL6VW3MqMB3euSQcyo19cVG+DOroHjEGjvI7/Y1wvj7EjqCncIod0qhKk6mYDovZbgVPBmkoDvunwIS/OkYoJH4lsqLJrB+gkwx/BpvuV1X+tIv8zaJIZOxdh1KhqnY9MVCNfISyraMEDDDAFzzimeNCaH4dyHT+bOHPItkqRyN3kYbJJGYo3zHa/b5kTvZbpdUegvyNtXVLS4qlmlON0Se0MZC+7Sbi7qADWrzu++06cCEemIAmyQZlqRhznDXHL4OVtl98K1qMUfQ0VLKb4NU9EEDwDIi0Ltpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Z17GYjZFfOsQmUhf63H2+epiO/rMITAyVxJJQ6YF88=;
 b=aDP3BoNxLAWC57bjlEp3K3f9k6mmKLsnbuESchz9ob1E9+8CQoO50G1eywRfEytR6lvDYlx2MEylCgBPB8TYfFbysc+o4rGiiJSHhzoNJKzFNKUHT2cpFZNO48qSE9CyT2B1xwnCkueE7rikEmhoF2aJM8o2HAFjzUcn73z8ZTIcm01JhJbHWSHvQN+xwERqK95ofBSqaSgVo4ZUJRSYsN7dEWn4aPuaz1Bgkenuv162wxdWX2dxSYKPDSsRTDaHvkqNfUBKbOwiCzgAQPM3J2mxwRcvMdm2DI9WJItvn9xlgYTnU+tpImkErPnCMedu+EqIdKHgwO9SvflhgLtSBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Z17GYjZFfOsQmUhf63H2+epiO/rMITAyVxJJQ6YF88=;
 b=a5AUTbzKN6aJHaqEpKm5Tp3nj94ijiiK5lpU4XLAsfVWJpYNyBMiQghK1ZNmY2rEYu5k9CcxbCY/Bg0qreNM8y+j6C8UdpkQSGuVbHhUwm8XojZ3yo46CuImmR2ezCpMo8NZnYbBk5ZuEIrHtuvJBDtX6R1xwZMUDyP3UcLgGENHwAj6/ilEpXlXozMcKPtPBifWdPxNYOsXhK8f9P6XsyqGoKPva5RANPoJ4TicnxYLYjPTp0JKA4J87zltRj3cQmBcKs0hU7FnDiHKKCRJeNBd0zJw6lvWf0RzzsdeVZTNSJiDGssuWWTWmoys6X3juF08YNEIO1nCKXeKg4Jr0A==
Received: from MW4PR04CA0195.namprd04.prod.outlook.com (2603:10b6:303:86::20)
 by BN9PR12MB5382.namprd12.prod.outlook.com (2603:10b6:408:103::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 08:27:03 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::31) by MW4PR04CA0195.outlook.office365.com
 (2603:10b6:303:86::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21 via Frontend
 Transport; Wed, 6 Apr 2022 08:27:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Wed, 6 Apr 2022 08:27:02 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Apr
 2022 08:27:01 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 01:27:00 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 6 Apr 2022 01:27:00 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <slade@sladewatkins.com>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.17 0000/1126] 5.17.2-rc1 review
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <53ddb6cb-78f8-4331-9ae7-bc238221c9ac@rnnvmail203.nvidia.com>
Date:   Wed, 6 Apr 2022 01:27:00 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 908b4769-771a-46b5-cdb5-08da17a73a00
X-MS-TrafficTypeDiagnostic: BN9PR12MB5382:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5382A812D959042B44FA54FDD9E79@BN9PR12MB5382.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IqBZJlvYToGUwcT+jcOkLB7NCZ5ttRez/zLSoiu7qIrCrHx1b3CnGV+FZlzRUMkqgc1aRachOwsw+QOG3HjqQ5rm+VduNa17v/D8M7v3byOkCN9tItFFSV2opouZwsp9J1swJB1a8ZmE4PTZRWmhorvAvozpgpxri+sb5M2Pp5frtFtgoQb9tt3EYGIbCmFj/Aann6xOOukSs91Jz9YyRWFuZcdOYivxgrehWhUXSUIQoNnHypwWgTgepHtNRZe2ZRJQV+0Rce8xyRMgEtCsDOJWubHE3NXuAa/GjI1UpTT2GlxWEJr+bzUJZaVXjBBpi8QdeFvdzapiFAKQOaCcIlcUh3DhxfuPjS2mac3JqU0HfC5n1wFLxVjkxSkwu9/e2JtwwVmxu7lr6ryOnjS0O5qZ61kriuqADyrOr5N/dpcvU9zMxE4/PQ71vruJde9oQP3atPejTSDF1tSmOm7js72GzwYLMun2z1J3n3KDqzu/8SJ5zEkARQ3Uzyy4upGu8Qo4Sr6sunBQNrGKMHGv1Ip6P5HquL4EYQS70P3/BsowjTxHfCGqpwcL21YsmcZmsJMQRKHImA9/5ig6Ex5pdFZkBZbcDGWCw/DvWrWdvhvORSTwdiuIxCejwjgIyYtNtezBzuROpPLiT+wSB8B48wsmC7fzYi7yngNXs6GldivZsmK8MMhd4NdpMgX006C+++YNhRzYFetdexk5/3/SUEWE2DQLg0TIiLOM5iPe2LbiNpML3Ylf+VeWaYp59BxWlk66moOijQ1ylPQc4WztNyIQU1szrKko2EgiHKVt5Ls=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(6916009)(966005)(54906003)(7416002)(5660300002)(356005)(81166007)(316002)(508600001)(40460700003)(8676002)(26005)(2906002)(82310400005)(336012)(86362001)(70586007)(70206006)(426003)(4326008)(8936002)(31686004)(47076005)(36860700001)(31696002)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 08:27:02.5361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 908b4769-771a-46b5-cdb5-08da17a73a00
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5382
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Apr 2022 09:12:27 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	5.17.2-rc1-g9ffb4937f7d3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
