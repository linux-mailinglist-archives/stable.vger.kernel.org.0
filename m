Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937B14E9964
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 16:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243798AbiC1O0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 10:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243796AbiC1O0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 10:26:36 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B251F60F;
        Mon, 28 Mar 2022 07:24:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Od7N77NjW6Ss1lKqg6scBMmQVvfc/y6rE3viZ7bslds9IQ1hxUQcj02FsYKP2e+KQS5VcZXbqXmBjxArsg2fGe7/X9632Z3NzkAbJyU1VOsz8V8u84SBHdZSJ+GXfzCInsNyAi/E3QE+CZdtrm4tCK7YTIlHa3K19oMpOs/hFQ/L1PmMePBZJbJBmPLSugV7v9Qw7pO1dtDjcIfE9Xz4OSlu+3l/VQ34XnnYQ2PmmZBrgAqndPC+cXO6KC3/aiGqmVoZb+WByWvgwT8hUST/G04CXV7WRfJ5SsvS0WvYG3WkPlqM0akJW2SWIviR/SAIlb7B9wqwx5gqW0r0TS7qvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n31+3rbPKJU0a9sJ4V7OApXDRF4+FQybcODkz6OnpNk=;
 b=H0EWv5tYqrSI4M9ONnk+nhiFftncgh4oXNfeOEDT6HgPKdurMMYQ7ehcTEHOHfQXBVJn+QySf0XvvB1g8tmXZNpVro00B85fNich7ZGR64Bk5PmmxTNmfRTAlS6ZydZPiI4tFr/9kcgEEC37s88dZSwGdObvCVEh01eeBwOUeioPN+R/OBTQIimlUGcM8P5ruUadIrRdm/Xsx3uM3LqLExi9jxkjG2vdVkCofiTbugYozA2CQXgoQ73U6PhMTuqIuKNqEe55EDnktXegnXhQdGX04RODsvjB7/R13GKNKFOjMS3DNQqN9PfPDva4Czn0wQKTqWPXA8kAVkL8058TSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n31+3rbPKJU0a9sJ4V7OApXDRF4+FQybcODkz6OnpNk=;
 b=dxPtutsIkNXMhRiwD78OsKIQBYBFjKOvsJwOGfUT03d4FEI8qIdzbfDYSRpo9/xwke0YrcRhtchcRTzS9UUVhiGd4o97KPMo6VeUryXkd9hORgb6P+DQOxdjkPzRek3v/8R8TgZymH8UfDCvcijNoWpS6Mk27Ec1tUO85Fqzr6I3E/ievihxOeiEEvcknarWuZ8B0iDn5GtE0etlPdNmVJQxdspveOjDoKTuZODx+wLc7wkQsFRex1fqjPoPhg+fOJUAR/FK5+uM0updk7diyh7OV/SKLpGYwaYdC/jIKeqMCGFzl0UawAfqiTTKFIq7jRciO8OFQZNN4dOiCFJc+Q==
Received: from DM6PR02CA0094.namprd02.prod.outlook.com (2603:10b6:5:1f4::35)
 by SN1PR12MB2413.namprd12.prod.outlook.com (2603:10b6:802:2b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Mon, 28 Mar
 2022 14:24:53 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::d6) by DM6PR02CA0094.outlook.office365.com
 (2603:10b6:5:1f4::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17 via Frontend
 Transport; Mon, 28 Mar 2022 14:24:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5102.17 via Frontend Transport; Mon, 28 Mar 2022 14:24:52 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 28 Mar
 2022 14:24:51 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 28 Mar
 2022 07:24:50 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 28 Mar 2022 07:24:50 -0700
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
Subject: Re: [PATCH 5.10 00/38] 5.10.109-rc1 review
In-Reply-To: <20220325150419.757836392@linuxfoundation.org>
References: <20220325150419.757836392@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c7c53e04-c320-4878-9580-e4feae2f06bc@rnnvmail203.nvidia.com>
Date:   Mon, 28 Mar 2022 07:24:50 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f748df5-d0f9-4cbf-e80e-08da10c6b976
X-MS-TrafficTypeDiagnostic: SN1PR12MB2413:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB2413A912C2F50FBAB16BDED1D91D9@SN1PR12MB2413.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LbV1fhPH/klImO8F+TjbG9sULVbSt0Z+oGkZAtzgPxVTW+s4LbAU6J4JWyTCwEj/HnkDLY610SVX4EfVZPMafl3LsPH/n8S6ozRsack6gnoG0VW3dz+hiZqLGY3IFKuTs5Kab0r3DkMpgG+lLGhYjOdQgXHmY/9bZPPJ1NBMlJb7BGonYe77q9g4uNQFUvBM5GX057ZY2FXigwfzRJqcfbJvG1cqxC5hhAaI+BWQaOQdilAe1ZRU7ZWZCyatnEAGT2QtDvTfsENV0hco+eCYxzm5meKqQDatQnus0wcTqH9RakfOfles2BcrBj0iwbVSUvV4dSK6Tdr8CnPNWTzeC6+zmHvH12mEqYqoogdvsrLbbzUUh87rVEHvtai4YYaLKRapIvLu1tCIrjlk90GclnBhPnbJxnjPx5Xfn22SRlZUIQhseiEs1bQXSpphuHziveiGWosdvD8qK37GF3zFZW3rtmeLb/KUD/D5+/vpNrO3KmmL6fCgwTJWIeQ5MTRYCyEQGBVgYQpZ9DIZalf6wjbqbeUJMNjyCgvoU7071a+0R1JP2QsITW5eKcXqn+a+8V/70sotxEsDGsvC7nthN+cHLMNuiu4CG3kiwtkDSnsLntwyKkN1l3obaRh19mZGAbRf22clhqJvvdstfVwVQYDJ8ljNZnbLV/DF/6jkES29gi5ccdTZINm4bYt5yr0m2rGeXwLjqZ7pwBm7WpMrOoYwlgduazIf35qy45yEbL1uHUfC/RBb4LtgTkEl0Bx827cqBSfg92eyYScsBGmcbnzZ9CQ79S8Gb0nQAYgvPdI=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(47076005)(26005)(186003)(31686004)(31696002)(966005)(8936002)(2906002)(36860700001)(426003)(336012)(5660300002)(70206006)(54906003)(356005)(81166007)(70586007)(316002)(82310400004)(8676002)(4326008)(508600001)(40460700003)(86362001)(6916009)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 14:24:52.6399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f748df5-d0f9-4cbf-e80e-08da10c6b976
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2413
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Mar 2022 16:04:44 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.109 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.109-rc1.gz
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

Linux version:	5.10.109-rc1-gc02fc5f9e70f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
