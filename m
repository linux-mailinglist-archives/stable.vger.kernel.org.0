Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5BE55969F
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 11:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiFXJ37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 05:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiFXJ34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 05:29:56 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2089.outbound.protection.outlook.com [40.107.94.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5D629817;
        Fri, 24 Jun 2022 02:29:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFTugo54yKAFArF5oFErHw2wwj+DZZOskWnx0m01YmhPYF6ja2cSQmrpvfjftZVmY1Uw1Jov0rSo/53NjFU2WBNheourgJNaQhWWCi1EK6gbBNT64gRpMAcYeCVbmedc0p10L9k+zisQyvaaLBlRku79eNUuovSe/wgiEFNWPytesX9jQOHndjx1ts3xrDU7ugni/rMK7MUFW/snzyRnNFg074mMR/Tx+lLNTV2j/kRNdALOqfZNL1799ysr7APtdL+DXVwWea1Q+7Zj3jZm1lk7vETuqaW7ZPz/8b/7S4x6NbZhhqLAGwLIxgXommkDDuY8viJzQ64gZj901h9YXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6q2gSTEnZW1zEBhQuPdB0aMJJ2U3yzrpWRIxPRnNULQ=;
 b=WiVTEIp7uAERHVgbo4bBn7Lg4FHRugdXV4+BsKAliR1NGKGJc0VNl9Ers6PS8wbwz7Ya2+4UVJ/iNpy7t0evx9udeW/ADvOkk68u/G/ABQ9Kmv/bSqNXeMGy4gF+QZ809wTCv6iFX67jtH+z0O2doDtJswgpZExnr37/ip0Y32EHF3h3XyPERcRnHyphNuiJKPVxa/FhIWdr3y7P3lMmyl1zrIbHTK3BicoSpj1KOWAbU/Ph4/M/K1f/ABd0h/68VQHGmSy2L05HYXfZT5kaETITrSK06wZJMH9gyyO7zEMe7YS3HRtVRb/B9P5XQfVR29MvdUEPAqa6Ie7CUj1AiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6q2gSTEnZW1zEBhQuPdB0aMJJ2U3yzrpWRIxPRnNULQ=;
 b=ss9lN7sJThqLbwtLeGtJgDu7OQdMXcs+sUHsbYtK1votfky6P97OHQbJloV8/N65XMlacwWAshyYmCDut3a2HmEZCIdeZIUEhKpDr7fCaiqO0D5L5Z+SVKP2g2goD6wta3CJ1lyWx7cKR6hestXWMI9Krqn1nVWu1gTMt8i9J2tcZJpTkpMDMdyNoKMoT/KrynJb2hzNAhnoqMRtNovi5YrV8iakSbPuI2/dZ+Zx6sXkSntp1YlXgTWP3is0TL4A9udje/uTRVP0OXa1cjuAkHNbRrFlGeXux46FdXMXr8jq1l4Bj1n30pV2uhfRKIBgUCRQ8mVNstlgaTYUV2YH+A==
Received: from DS7PR05CA0074.namprd05.prod.outlook.com (2603:10b6:8:57::22) by
 SA1PR12MB5639.namprd12.prod.outlook.com (2603:10b6:806:22a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Fri, 24 Jun
 2022 09:29:53 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::ca) by DS7PR05CA0074.outlook.office365.com
 (2603:10b6:8:57::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.6 via Frontend
 Transport; Fri, 24 Jun 2022 09:29:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Fri, 24 Jun 2022 09:29:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 24 Jun
 2022 09:29:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 24 Jun
 2022 02:29:51 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Fri, 24 Jun 2022 02:29:51 -0700
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
Subject: Re: [PATCH 5.4 00/11] 5.4.201-rc1 review
In-Reply-To: <20220623164321.195163701@linuxfoundation.org>
References: <20220623164321.195163701@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <48ebfe90-4a36-41fc-9b36-096f52fc77fa@rnnvmail203.nvidia.com>
Date:   Fri, 24 Jun 2022 02:29:51 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ee93a50-ef52-499d-f5be-08da55c41833
X-MS-TrafficTypeDiagnostic: SA1PR12MB5639:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /M/9cPdaCjK3/dPC8Al089tZAvAgT2hr3GUi5wwYXf9G0gKwp+DAp2TD6GlQpV3ZajlsDhyXVz9zKUIPnWekSbVY3vFtUpSrOcAHbEpux8OPOTZUwulz/V7eiz14IHRfn1lgB1fJATHJ7l9F0muCrloBZ4hKkLhZkfgZpgg6c1HCFBt+fNhC93Jn7wfRFLmr6SQ3TdpXZ0zW9SOe5j1x2tDtSY7D4Czcykq+VSZtjw3Vex7pJvALB6AR7KQR7/vv42MmbQQ6jviPQrpA1cF28kg0qs1iyfIywEspA0DgiP7piW+J1Cvehf4OLJPR34N/nMf+IuF9+oe1oNWTJI71W1hGkomZjct14CtPnte1HGeXSAGv9teF5hWsxdb9X5y8AQnmHOo6SnSQi/aHh/6J/FLbrcaRwSmVgSbszO6YrzzUeltahvhsrtRQoK83BKMFKN+CljZvQVATnmOHcAy/OamXLBeRQ7TNsb2cbhHi7HBKNbS9f0MCvaYDJJTtkwxtsZvtwCtO4pIBcbc+MxGFRbW8Hx73gBRshBrZEOIPXRboN1jjbCpK2SfW4eZ2tV1ZXVKMrduP4S/5yq/thnVyL2xmwro/XNa3OGibo9YpJE5Yklw2oukr8Hwh+x/yOiGnq5HBIVpwiMwPQvNCgwdmP6dWipVklfXhUGNBsLTQC1gYdkvFuTTg+FuTMD31Mzn6R9zyICwI7KMOmIg6gMG2Bg1Fy5OW/MIfvU7QyYKWgpsMvofcGan8b0LHfCG7TtXYHJVnJQ76LS4/r+OjB7K/4xgl+vQAHRjY5Xep7BKg9+8iceUhz4yFocs27yXniNxRgyDbuv4dgd62OgGuN+O6dW4gbF4VwgymZ2E3YWw9GY5xtG5vZ3eLFewYfbBuJmn5cOSX0vRbh5E9/OVRnr3Xymp/ymIAV2WG9wJGODTrZek=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(346002)(39860400002)(46966006)(36840700001)(40470700004)(966005)(2906002)(41300700001)(86362001)(82310400005)(478600001)(26005)(70206006)(40480700001)(40460700003)(316002)(8676002)(54906003)(6916009)(4326008)(31696002)(70586007)(47076005)(426003)(31686004)(356005)(336012)(186003)(36860700001)(5660300002)(7416002)(81166007)(82740400003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 09:29:53.3262
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ee93a50-ef52-499d-f5be-08da55c41833
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5639
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Jun 2022 18:45:04 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.201 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.201-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.201-rc1-gefc2c248e276
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
