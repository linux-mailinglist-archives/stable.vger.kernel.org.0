Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72834572EEB
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 09:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbiGMHRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 03:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234682AbiGMHRS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 03:17:18 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22ED66EEB7;
        Wed, 13 Jul 2022 00:17:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbUuBNAHwghmLDYujp47MuGMvP+r1bHqyGOx8bfDbbVR7D5BQ0aag4J8IpTVXcO9wJDbHZRwkJkaoRR4/Aq70B+tEQfPp0DHtgkrPE3qBPmRoTKbLl2bvUhOwseknY/mR/rm0cTdsW0/ZFhBly2Z2NUTHfhrij6HgW3+t4g4I9Eo9sLHgm/rntfgoBIrlngKA3jTsiw5kf2+rt+A7Tz+cs/C7SaF1lEk6bvmz1NzawymfDsZ6n1uO4HEiwg/mh0JS1vxXcjDAAO102FghxFefH6ssu1RI5BIXRzMv4ZO5jt/+4ZvP2LijeHyKATCELsyDWB0Oq+TrJq2f2j+bBYEog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ynrGUgm5m7JbAKx+B4jvQK04tldwRyOVLjF3g3G+dxw=;
 b=kvIIPsX2IO7Ud6OP2CiAecPQC3m/fwbD2ehmRUQlK5n21fj8qFwMfUG9luSOxnTj9Xq0kz8UwqVXg0V9TPX3VX7AUKkNlVrcBUS+SbpsFNlsP7gCYb1zLtvGZAr1iP/Maa7JXVMhVM/pQ6Iq/+2D43U6S1yehCNdwKLiGPg7jvlx9fEI7zbuZZgWG1ebeWLvZR7avfjlZUeZoS2eLMWCrlh6qypVhxl1fFuHoVWGb4JMtOtCgbTxoA3RsJVFjHokr3rSPpaYuj6f+jlxWBvzj/bXUVGtJ7vbhhBAJUG6b3d9npE0NLYPsfQQSHhhNafcQbZD/z2cSTpmbFHTB2bgBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynrGUgm5m7JbAKx+B4jvQK04tldwRyOVLjF3g3G+dxw=;
 b=CNz8boIZjgcGyT4P1K9jahUeZxi+JFnqvR9Ch41WxZiizFn73e+sTzU25/Q4IcNGa2/kQrQcH33yPlOuft9kelCp2c5sEaezdKDwibC674ewZf6iORLIwqXLVt/fZGOhvWw241vs0le75/dRd0mX4gMISoh6dO9To7ECLTMzOi1eiwum9HMvbyjN8WhSrgFveHrjPL/CrWhevHDcpKLt553c/BggLcVlSPwK8mFeDuSYalrfZ4d35Ldx4Xq8tSSkRzja713WGLA7+idUiZyMc0VQmTNmakWSqZ/FuBoqbJ96AMv69Ynh3hAZ3EgXGRciooUqK2nWaPtOXPdoWUG6hw==
Received: from MW4PR04CA0046.namprd04.prod.outlook.com (2603:10b6:303:6a::21)
 by BYAPR12MB4984.namprd12.prod.outlook.com (2603:10b6:a03:105::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Wed, 13 Jul
 2022 07:17:14 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::4d) by MW4PR04CA0046.outlook.office365.com
 (2603:10b6:303:6a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.24 via Frontend
 Transport; Wed, 13 Jul 2022 07:17:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Wed, 13 Jul 2022 07:17:13 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Jul
 2022 07:17:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 13 Jul
 2022 00:17:12 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 13 Jul 2022 00:17:12 -0700
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
Subject: Re: [PATCH 5.18 00/61] 5.18.12-rc1 review
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
References: <20220712183236.931648980@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <adc51b65-a74d-4925-a710-9129b57985ed@rnnvmail201.nvidia.com>
Date:   Wed, 13 Jul 2022 00:17:12 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fe4c477-acdf-4718-e6af-08da649fb5f4
X-MS-TrafficTypeDiagnostic: BYAPR12MB4984:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VQRKeYWMcigOzELqifgoqPs+Vy97mDxwg8KSB9btJs2YNJt2AMZ6aRRetRn7EcMSjFIGKR7TubXzNBiu0ynKF0bBQ6QeYw9Hj4C5pMp6vZSW2Lhv/9IcB/seGWvfzv5w0pxBmB00EEmweHgi3BFB8GgFxzt7gE5OgC8qQZt007gQt7ZVaTaDzLRF74PE+Lt2VAzTub5lQfliniGoGRFrCTvPvE53ydlEn2fuVg6pxlvGNml0+K9MdKfVT4rqnOx4qQTs5Rk0guWZtfSvcIokH/2QmZlSq3gFZuXYZD/vpN6TirgMWgdOs/gPQZRIXa81oPx6mbj2owCLv2q9o6kFt95y83zznBsCBKn2QKinO+t6HlnyeaUV0l+04mCl4nlwxWOpk39v4DdJf8VNyC4rsZ3Jnn8uLhcOm2o6vND0OYvm04BzxzVRNZjSHCxXvGNJ8vX57x6B6S3zIuvbm3n9XZwWCrqtKT7UDSM7IeRU1VHpGpHPJ8yW2haAxzXLHaMBzKVogBamkshpYNQwywvjUHwVmrceQ+u+FYKulWJB6dbkIHJZ6adl4YzDcpiBQCZs4ktMgq0o/CmJXRfRuYOXhne9NJ/+xRPoaDTvRrIdzaqonpsY3cIzh9jfAkWT9p+zkYxl9UGGWBPBpn0jBLWJ6ajG7yRKKSe/TklecmPWds0A0huGKnUeOKuuvW7E7bT3LVfp2t5Bafgn8POsJrgu3Hgi+rgb66Ir3gG3ZI/2gYlIQ4zuYIYojCLeRkrZXM++jS4H7fuu/aDsghM1Urya6QYyI1EIRHFZo8AavdMu76MA8j6ZsWTOVGiJVXQli3UoJ+db8QOW1MyrWhAG4Ygz6w2FRDIFezBz/4MskzzXTBNM22zLUUAMEIm2CESzEHGoqixNYY2NCGZdYMdg/5MqQtoJ1LSXSQyN7ufNujtAHpKK6M8CBL1kG7g6oIeUS2oB
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(136003)(396003)(36840700001)(40470700004)(46966006)(54906003)(478600001)(426003)(31696002)(966005)(6916009)(86362001)(4326008)(186003)(41300700001)(31686004)(336012)(70586007)(81166007)(70206006)(47076005)(316002)(8676002)(82310400005)(40480700001)(40460700003)(7416002)(5660300002)(8936002)(356005)(36860700001)(26005)(82740400003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 07:17:13.9462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fe4c477-acdf-4718-e6af-08da649fb5f4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4984
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Jul 2022 20:38:57 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.12 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	5.18.12-rc1-g18f94637a014
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
