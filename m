Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0910C5F2FA6
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 13:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJCLbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 07:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiJCLbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 07:31:16 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2336440E2F;
        Mon,  3 Oct 2022 04:31:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YpO4q8Q8RPTg3PXc2wS7xGZDBu5Ocp/ruZFFbc2xEGiz9y8TJV2a5SDDGqrHrkIIhXn667XBam3qceHiZ3iMOqTPVfkerBaWibJk8AiQv9xsMpzlRuqI57sLOGUyfR11yvb5tJZOe1mzLxClohIpHChcslfMBA1lwQYDZabxm7epo+PcAEzWNgb9HYLBzxSyaNRqDDVXHyYPkYu2POVl8JSxZbQHjVjSSuHX18gzw5DmWDKVzZqjx1EnhFUmuvSShdyjNOp/VwalXntMtKWYccVBMvpPAvkFXVcyyHaTA7IWrvY3gyP6zIA6hUJE61ljP412bZOMSNSUrk5EKcmBTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YTL8ktzhwYnXeeWrqNjz7oGbQuuKVUcSeSaGueqNon4=;
 b=Lffeslp1zpp++RXjOYWn3NQ1fW/9wqUDtid1TUcmTDkwcXJVZ6VmbVNc8+thorHBql+JXFI2cdtZ8ZskZXsvtBMWYGfJ8sLCJsP18Dq8w5X+tQhBii5AIY6siSynvOrwYxouCgTrzELhJaAOoku43JwQ6Xjz6Jl5wuFJkCuzFdQSmch6Arq1gP9NLt1+tk/iwze34E+BBpn7FHMQb5cX+2wPxQJIuP2MwzL0cMmBXwXVZfYK52RUW8956jVjRwlpyBd4j70wJBSzrWKe3MePmrrBsScqaOMpdI6y3SJELa3utdOUuKdMVTc1SLEZPMnxWsQ4QLBk9Bk0xPrzJlNPww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTL8ktzhwYnXeeWrqNjz7oGbQuuKVUcSeSaGueqNon4=;
 b=NvIxBs2+0Fge+FzG/Wio0bzqK9kuV+MKzNeUf2b4HgJ34BwC4YmZ48qsmyXvd7CaM0o7/h1Z0X06BdBnLpnyWsrpSr8+L+8EYGLIbFTN+lZU9hC94bbNZgAOFRPJ6LvPH3LuSdrgeMJ7SgI3TLqJv/3wWXmRk7fbHgdu0sKYKGx0FuVXKb0xeYkVT5XRaKDnskxgBJ7s46nDk8qYplod9sJXyffuki3V7lklBwS0fjp35B0HcBQ/wow+MBw/FmP8GmbRNo23Lz3nziobHcSsICK3KEQe+S53F+OeX4d8vLMEKd9KBzamBpJXDt+0H5TWQYnNVmm1J31fgT7tgsCI1A==
Received: from MW4PR03CA0001.namprd03.prod.outlook.com (2603:10b6:303:8f::6)
 by BL1PR12MB5063.namprd12.prod.outlook.com (2603:10b6:208:31a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 11:31:10 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::31) by MW4PR03CA0001.outlook.office365.com
 (2603:10b6:303:8f::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.26 via Frontend
 Transport; Mon, 3 Oct 2022 11:31:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Mon, 3 Oct 2022 11:31:10 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 3 Oct 2022
 04:31:03 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 3 Oct 2022 04:31:02 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Mon, 3 Oct 2022 04:31:02 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/52] 5.10.147-rc1 review
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
References: <20221003070718.687440096@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <392fab1d-7ecf-4283-94b5-3009c4926456@drhqmail201.nvidia.com>
Date:   Mon, 3 Oct 2022 04:31:02 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT010:EE_|BL1PR12MB5063:EE_
X-MS-Office365-Filtering-Correlation-Id: f1229f4c-940b-44cf-a09d-08daa532c550
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2+FFwW3CiIbgi1t2qHjgDz9g8/wfst12kPCZQJmR8GN68btXxWHom7Vi/tzpGBmhR6b69HlNqfTIPmn8oTOfOEUkAIiQN9yI/6k+kRBSZBaPlwyzgvX2mkVF89uBe+nW3t6MvW1c7AX8BUwk1NmP4H+c7fCjdQ/E30E3sm5bg64Ae6omaC4Hnj38CpFqIqYNDq1h9RytGIbbXiq2mqBKljrm4lKWAAYG+VLIqYAYwMyT1DKLmKyRX2YQsrpOMGEjnON5wJl2ZNofhNmEljuS6W5H2bV+3go44fHS6RiSeC1lNWUOpQF7ifnUKbNsgiJF9gQ2pa7OE4wJjhRqAaXCZRCYKFz42pTLvGgN8HB/K7gzzsGD1MKe+GJ6DLkKUs+SPCfsaHJT0iPpRI5rLOIj5znOFIu9RZkEcfOow5G7QIm1XLp88eal6fkFJmEh+7mTS5ipfB4TnjuOBT7DiyK/nWEy5f9HJqmFkE09jceipptzEtcZMGQ437j35CeJo+6kH7HqZD+I8fPjGiTGulzqO9+U72na5qi3toOVk/VN8wgxiMvtbhcuv5/NCxJlW6rqxLwRZReRdNHRBeH5GJzIYFsPAnwXTlp+GujPlKjEUwCsCqI+rZwdAturgELmVmyWmqnP5Rc0CvVv419Y81dsM6h+qeYmzzXaJBx9RVoWDAm6sbYrgSP4MF5E6Mr8xMq1HIyb3FO9dZLQEDDVDic6ZSn4OemL/TVCWws52xWDPDhV5v8a8YW5eRcosCLtWs8mFKGnVaGTC2JoXZ96hQ7bldzAsyTpISSpHnEYXrqCJexutU6nyJnIplF67ceLAcJjXexy2WR3BFNoBwhPuukPTbm4zSpAGjWT4srrvriuGTw=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(82310400005)(86362001)(478600001)(316002)(6916009)(54906003)(41300700001)(966005)(8936002)(5660300002)(70586007)(70206006)(4326008)(8676002)(31696002)(40480700001)(40460700003)(7416002)(7636003)(356005)(36860700001)(26005)(186003)(426003)(47076005)(336012)(2906002)(82740400003)(31686004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 11:31:10.2752
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1229f4c-940b-44cf-a09d-08daa532c550
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5063
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 03 Oct 2022 09:11:07 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.147 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.147-rc1.gz
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

Linux version:	5.10.147-rc1-g9d377edf70b6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
