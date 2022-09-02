Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6575AB6A4
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 18:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbiIBQgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 12:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236242AbiIBQgA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 12:36:00 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F8CD87E7;
        Fri,  2 Sep 2022 09:35:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJwc7BD9K3us3l3VGsax6TM3a0iWFEYhlfAmFB4zUF5Wz71/P+H/BJc6llk7JtF29rheDmPjrqL2T6WB8IERKt64lRQs55C6Ap5+xYe+HZmWaJiadRxe7x6rZd88oy0HF3SDiBCqo2kYQGQ/NQpE2jZYqwqx+1RHU0ea8H5cflVYp2a+0psZhz3XW/yftEW8dtUIX/B8Vy0CmBHDn28h0iMmjQp7Wxf0vKP1+zuAju4CvBM1rmrOUSi6Dw273c6hzn+TFp+SADx3BUA6h7pbbi8AsPv5c4Y5yIAUuoNKvlMIesu/Sh6cxcN5p6WaCH2PXRIUDd24+vfw/nUVfMJ0xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=10cvQkjVKqA2Tzrn/1CG5xIrvAUhDOLTtX4JK5P0nv8=;
 b=FFMhW3pxBoq4kFmYasAyCqU/ptZwlcPRk+4Q3RTTQcILeonDqJCY/NRWvpAL1eMRv3OKDCo8iddbg5afQJcxpitYcxCVSbesqz1WiBdylh4+qbqptj52xw0uaV1E6/Df1Fo+EB5Zl5aF6xj5l5yCKKlLttJPQgMtmGKdMtz622KNvP3H+4+r8BE0xA9Gr5k7IvBQwbJ55nVjynJQ6uN60Z8HFv6hSugl8usa5L5A0dsA8TK+9AP5G9HoAhnSFF+hYuctuvT3pdIBZ144bTHzq10yOMwJwMWDxE0k0WhWYLB3DHPG15I/qN/fXNgICooQ6AmzxdeVu31zLohsdsLWhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10cvQkjVKqA2Tzrn/1CG5xIrvAUhDOLTtX4JK5P0nv8=;
 b=eV4G2D3vrk3q2cOKjb6qqpvZs39qqVQ/5fa/rhXkVZIru6hGWWhk1ZxAn0+zVBBMpyEI9282yeP6JEvS3sNBKnktgYmpEqTgAbl/j761+V3sEPsMQoEbqG9yptkPiWYENpdeLvoU8a7SPjQGWiZXWzgVQKORgDjlpFMcorocYCcMbKmNsWofMiv+qlhf/ke6HnZtNbVSaCtw/mIjXZe/t4lm4UW5JoxndtenTv6KmVdaex2CMQ52seYvbQzaHWQLajapU8YoyMRRR9eB/GOjcLhjZeiSQIdONBDcnQUBpsFS+x9zMV34VWAARNd4Zuc+ohSqgD6TCMU5YW9LYDnwow==
Received: from DM6PR11CA0042.namprd11.prod.outlook.com (2603:10b6:5:14c::19)
 by DM4PR12MB6088.namprd12.prod.outlook.com (2603:10b6:8:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Fri, 2 Sep
 2022 16:35:57 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::1c) by DM6PR11CA0042.outlook.office365.com
 (2603:10b6:5:14c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Fri, 2 Sep 2022 16:35:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Fri, 2 Sep 2022 16:35:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 2 Sep
 2022 16:35:56 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 2 Sep 2022
 09:35:55 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Fri, 2 Sep 2022 09:35:55 -0700
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
Subject: Re: [PATCH 4.14 00/42] 4.14.292-rc1 review
In-Reply-To: <20220902121358.773776406@linuxfoundation.org>
References: <20220902121358.773776406@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <402bdd3b-d6b6-42bb-bf30-e88e9776a34b@rnnvmail202.nvidia.com>
Date:   Fri, 2 Sep 2022 09:35:55 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ebe7ef5-b292-4014-8ebb-08da8d013630
X-MS-TrafficTypeDiagnostic: DM4PR12MB6088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e8Z9KAGKpra/8g815cNcNVatV66DvbGXA3mwykGpWTBNbuUI+Msm6VWt1dSn+tMqoQlO6B9pmOPIi2xNg5MDGroq9Ca+ZNY5HgqEl+pqs7oLn0Mr8h/aV6VBE8wWfjKE4rkjy/hj4NeGnlS179aYSuohFYGtmbwrzRv+V6/t3ue6wNkVmUxLg6jXEAkDh9e2UaKXEFw7iNKgLku1/BBiX6IDodgUuzVU1g/nXtR3JOtpglK7PpzIvXZhGe3TKXqFpGAraI+7JXkhrHWG6dzqkXi897vPVY3EmI+6wDx84KX+QsR3LdC3fsHGw9qIOs/3UzuueEWwlI9h04CdE6CikH+zrfe2fo/W8KldLU8sm4W/ri1+3t616zX4sWVgzlxwj/0xnPmjADfjjtIgq808uiCN8pbXVvTWKDLMw75tHAYnVYzwpH7x5R9tcRvzeFaeuyCsf1XE1vqoAVueagydw8b4GlyDtOqHo9rtthQyykhpG46ldem+WUBDJmIb3h7fpAJNPnEgzfJTZNrPun9020A1D+QZ2BlRuCFjavZqp2dgDEGD6KTYoS8/mwJRrwT17GDqEhJe2Pqk1UlD5s85D5bEfpXkIhu5ddUc+5jQkAUpdCI52opCBgPpgse/VV46GdFuUdfuHoUKXP3ztcV12f5bY5IZS3GVe7DpwCUmWEfqpQgcPN4VJHVnZLEMTmgjpbO7ICsuR5G/ld22xo1kiIAzQRSw7f8yYpA+W0F8iiXF53s5445UbJMQX3Vo6PvVNQr4p59v4ni3lV+xHyV2c9kTtTsbDe2UcgmIVnlFHzs8P35VDngFWq1P6bSblA6HixLfHSgmD8Qn3p5Vq72i9unHvy24yPV7TJyKm22MbVfbhxzLuxhdmcqUHzGOgL6N
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(39860400002)(346002)(46966006)(36840700001)(40470700004)(31696002)(8936002)(40460700003)(86362001)(26005)(82310400005)(478600001)(36860700001)(2906002)(41300700001)(5660300002)(7416002)(426003)(356005)(70206006)(186003)(81166007)(336012)(47076005)(54906003)(82740400003)(70586007)(40480700001)(316002)(31686004)(6916009)(4326008)(966005)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 16:35:56.8888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ebe7ef5-b292-4014-8ebb-08da8d013630
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6088
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 02 Sep 2022 14:18:24 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.292 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.292-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.292-rc1-g3eabc273fb30
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
