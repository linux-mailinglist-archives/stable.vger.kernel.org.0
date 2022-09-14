Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3538E5B8BC5
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 17:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiINP1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 11:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiINP1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 11:27:36 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7517E31E;
        Wed, 14 Sep 2022 08:27:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BiF9D97wwdSyFv5JehX3vzcsCBIbUn6kcEl458Ey6ZvH5vpmHotpQmAEyjjLsN3BiRQuKDw+Rv/OK3eITc1WL/OSb3aZQDVJxJ1K5OGrSqLmJ792076dKqIkAmzifO8O7E+JG584leKT4mXB3dYKWlaqOm8YHk+k4/eUsLue3AUUQnVRg/cqAlLn16W7JP+2658/BFk8eSQy4awHRm+BzXEnqb6Znj3Unn4UiLNP6qqkLLdD6tt+q3uwOWWLxjWSSuAFIXcD7yRK3qvLyFiUJ93JNipXbE0tvQezpaFj3Vz2I+ltY4OmO/h8lHH4wrkbw6+hlFMhESz8uS8y5FFt/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TpyJks73yJXvPC3581igf2xRcAk5Ohg6o6fKyJ9BvsI=;
 b=LwBsG51PhZcdL025qTQMS3o4dldQT0lfZqxY5i+yzpvG7NdyTdvKF2dqKQSyU3cZCAUNBvknNWLzze9B20HQG4hp3QrV7pp0Xbepvi/A3YLlaUkpelEq9Jnqm+qfmXRZiasEtmwHQxSpTYp4anf2VQfMW5aTpZiC6HLYxqs8vhuuewqiHogeLH9/fAvE0GXFQhvjLPirAkbE0+RfO//Eu+7yq7Z7LELiYfprCYwbCxw32beO+MtoGRbRy/uyMVRVDORj1kzfd8RJ804LhEtmpqnguYiCOL1t5foPmsVPecUIxxWDsTqfsha4AvBU/S3qYwNsgX8LbA+WCf3BC26wdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TpyJks73yJXvPC3581igf2xRcAk5Ohg6o6fKyJ9BvsI=;
 b=quSlOqXn3okwxHRnA9vf2IGiuOywDWODAIQAhq6a3jGPSdHnUE0r/6dkR+uobBsmecyzEyCUVzPRwd+SjPFe13MzvZ8yIUE7rNsj6NF8FbCn4RHArabokaiAuqzu3DQCs/o79McejlWWVit9NGkts7eA677f/slsDzwHK382jZBZ2rmoqhgBuSeJrZ2VwEZgQb/SKRrun1SudyYTa083dfOsUFdCPLi19ZBpshYbBaFRk7ImGukmYf7Bt7BU2Nw9oK4Ke8X2WH0Bf4U8j1wpLvMGLkBcm1mFrAmWKrFe+8UJEZ6J9ij+MbOXQFvS7z+ke432kyuEKIfr+SUUql0vdA==
Received: from DM6PR07CA0078.namprd07.prod.outlook.com (2603:10b6:5:337::11)
 by MW3PR12MB4522.namprd12.prod.outlook.com (2603:10b6:303:5f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Wed, 14 Sep
 2022 15:27:32 +0000
Received: from DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::a9) by DM6PR07CA0078.outlook.office365.com
 (2603:10b6:5:337::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12 via Frontend
 Transport; Wed, 14 Sep 2022 15:27:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT088.mail.protection.outlook.com (10.13.172.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 15:27:31 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 08:27:23 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 08:27:23 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Wed, 14 Sep 2022 08:27:23 -0700
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
Subject: Re: [PATCH 5.15 000/121] 5.15.68-rc1 review
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <43941273-a025-43ce-953e-ed9ead207aa0@rnnvmail204.nvidia.com>
Date:   Wed, 14 Sep 2022 08:27:23 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT088:EE_|MW3PR12MB4522:EE_
X-MS-Office365-Filtering-Correlation-Id: 277bde31-6685-4bf3-e816-08da9665a46c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MQCtbkzOQGXMq2nqtTcTMyuc6Z2D8iPnIvNxIyFxNRap5YbuAfbRBdfapKq5XPGSOP0jFP1ORA6e0dnoKqN2F28TuS+anjXgyWtH1ZAGdpgjERGLvFDdxlUZkFSfdBhVlu2XIITXh/sGbcYAb/x6xVBur/9vB1UR0DEu4/LLTGkkkThEpRWw2KglVxUA6CK4CbGldjcAxfHE4akpbyS1vFgMnBaQ1UFubLk0F4SNXEkYPtd9Fl0OjQXsYSX5ombKsCjAr0cL9b99M87H9hGLWcVe+WIxEUFtmNBEvtYh1RkSVx1PzFsRPPrXe+cUpyEGuGZNhCkxqQYgcQKc7ABfe5p2aDL08zo/8qHkaEdv5U3HVC8jzC6e1ez39NH4YF4As6PgcdKLQBPFuj4lbOFty55mNNYWgc18SMNcWTxpIo7SR8RKuAdLE2KAIAz5k3rwJDG90xbbsNN85EhnUOCdXb6sfyDp3E9LEHSoJshMgI1QvKjujAKtnkTieo2UVnratJCmKJvH++JkK+tQ2vScxMUOaikj48Nj//5kDKo3IlCua+44CZ1B6K3DSoaDAI/vEK6rhPP0o1DTaACK98j9StB3XGGEMpWTnNoBAC3JDWDOdWvcG7AKHLU6Dj70xAh+LwWo3SV7J2fKWg/W3KltN8+42fp7MbqpX74jKtFZijhvRCFUPxsa5NZQmFYh5zkyuPE5ntx0sn3XXXmHLHxj4C23waP9EPzA+cwA2A+wE92WEYHKiibiXFRnUY0FtPkYFoAhZXqSS5Dx39Y4DX4x2dU8jSmRUR3hLYJWlI8hfgMvHM4cg2QyVbC/QuiC4hum9QX1Byxr9aemPpgso/fJNkIdqmrX5tOlqqodjHOKioM=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199015)(40470700004)(36840700001)(46966006)(8676002)(2906002)(356005)(82310400005)(7636003)(40480700001)(86362001)(41300700001)(316002)(186003)(7416002)(47076005)(31696002)(8936002)(966005)(70586007)(26005)(336012)(5660300002)(54906003)(478600001)(36860700001)(426003)(82740400003)(4326008)(40460700003)(70206006)(31686004)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:27:31.9248
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 277bde31-6685-4bf3-e816-08da9665a46c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4522
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 13 Sep 2022 16:03:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.68 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.68-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.68-rc1-gdbbecf1f4a70
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
