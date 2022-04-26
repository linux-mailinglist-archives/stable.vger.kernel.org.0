Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC2C51031C
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 18:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352922AbiDZQWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 12:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352932AbiDZQWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 12:22:51 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F68AC042;
        Tue, 26 Apr 2022 09:19:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=POnkXPxrWEFQa8tgxOUgnrYUnTb9hiW/C47BgtICEqu3r2FABpArXwLnrYS5gxa63hbd8/uNbnn6KLomsQ1Cxrx9dXyGrvEnMLsqe341pnNYPaBef01CRc5bJwZ9tzTbVO4ysDNoqkn3+t5kWQkOJ3Yt5h6LCOZTWqD9GUVzN3DAzmz0i74ijuEFsOX2I7S+We11SUvrFGnYmhOXwm5sNjAAY1Q0YxmzkNEhKaQZoX+6Tx+INbz5rXirFlyDtQFgxrc8ecqd1jzJQOX6Nde9ZeHqS8zzwJaK/RiWaLatVW2CqBwRn6XXvHIgAyTXXDw63BAFVDVZIVfJd7MvywjWyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CoMXgAo70rQp8j2D2o8UVyiMCG2eLwGxxuodgcjQwDQ=;
 b=c0p/C5sg0Qx2CxpoaDFqekfFmEM24yeA+7/xc1HqKf5whV1NiOQFNWA8NUki7ERG1TX+Ef+FGeOHPkm0t2+wI18PcBwnGdgZc4EaQ4N3TqlmYeuZEoY2mHV4ttm+7Id6T7tqq0A1EU74YRyF2ZuxUxF3MbG7EVZpDnthqO+Ajw+nYDrtsnRuBL18GBAAgSYedyR9sgQZ8f7acD/n/QPrbthik628qOOnAEGkcQKj/wSoDKMK0xO9ckqen6nciMbR5ybXLwY/USVCdU/pC1IznwQMQZsEDVJPny7RY3yJrFDqubfvK0OSoodW4JnmhXAbf7VXpWRJRjtMwE2Us2PxMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CoMXgAo70rQp8j2D2o8UVyiMCG2eLwGxxuodgcjQwDQ=;
 b=ljGpEQBSt8l98EEfsT9gHMF6gtm8T7nEKinrvr/f40WXUH9kpFsXPEhH+Iesc2HB/CZF8ugPoH79yo8ZJVIUVJfiMuiKlCjyWvEgLGEFiMv6/GXqV7FT58MCBaGN8CHtfuAIZFOAU5tuzf72UgaUMByAsYP6q4LNrAVEDR5y5mf31XQ1biI0MTHb+isd2TRNEViZGtKj/FNgOc+9+eCbxrP2FaQ7Pt9z8H/fd5rxlSQiP4Li5mTQPDL2jP7VFxhOQT7JYFxdt3tv+LN0eS/yx2MBzQcpdJqLas8S3406zaNwiZcNdt2zC0pjHvA6b2ePWOWEa1uK9VnaVUyngMc2AQ==
Received: from MW4P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::14)
 by BN6PR1201MB0116.namprd12.prod.outlook.com (2603:10b6:405:56::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 16:19:37 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::31) by MW4P220CA0009.outlook.office365.com
 (2603:10b6:303:115::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Tue, 26 Apr 2022 16:19:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Tue, 26 Apr 2022 16:19:37 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 26 Apr
 2022 16:19:36 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 26 Apr
 2022 09:19:36 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 26 Apr 2022 09:19:35 -0700
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
Subject: Re: [PATCH 4.9 00/24] 4.9.312-rc1 review
In-Reply-To: <20220426081731.370823950@linuxfoundation.org>
References: <20220426081731.370823950@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0dbd7d5b-0357-4863-a54b-9cb7e2a40069@rnnvmail205.nvidia.com>
Date:   Tue, 26 Apr 2022 09:19:35 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88e0affb-0f0f-4b6d-89cb-08da27a08f02
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0116:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0116E10D2EF980A9CC74B4AED9FB9@BN6PR1201MB0116.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FilqWgs32DS1lARvYhTHdA+FPc5b+chW0ZKKtJ6HJ1/swib6Rp0OoEwn34QdwdNMh2WVb145xoGz2tQEUANJ4fLRnG/i1YRxUGVuXNWlGv87aK1ZqDZ+TV0XfME5wIhKOcfPUu+8kSZnR6B+qiXwarq6LGIExH7bdfcCuWnAIM3+fplPnCK1iA+lYVwKsrNjp/6yOfg3v5x7dnFbXuXVixTzKRQ+/UOGR4cX//N4CsgGe66ni0xkUT//w7PghiJkEvL+jk5v6/iyXXMSHJB8riyZArJO3OkfUuIUJFnQLOKI/w1vWyoe3UdoBImc8cDYgWFf0xG1ra8eHK8FPCzkpVfbNj6IfcBG4wMbsLN5bcR77M/qzitnoxhGrNd4z4YPGkibhLCBa9WF+Xh3CMLK1dWBWliEd36ywVllBl92FX3ji2Blj52n9Llydv1MxdMVq6Srf5W40jAbtDlA5c4gCfmks/2ZvBquvBNMenGgB9htU7CX3lB+tMUXMbl9mTYQQ8eUOlJLClae71uMUYUGlZRUIgLzs55QnLXBvn7+Vzu6Sb+vmUATrYdj0lVIv0Z1stqEo2wpvL8R6vzrQDR1zATJji28mIb43HYui0sDya4ThUov17CRvpFLyBCsLtMTq0i7VSZn2ddMhubur+emsQM6u8DCFOqidtBlZQiKo7cQM1cbdRPxt5pY0N3D+4hhfqYO0Vv3AoKU0lPvoVwAHgy/ML5CFqxP8jRA6+wcJkKwt1gNdOHLwFYREm26Wc0UTFSoZwW6OzgR2VvyXp9CVYzl+2FeK54YLv0o0lxeCoc=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(82310400005)(8936002)(26005)(70206006)(70586007)(36860700001)(86362001)(356005)(316002)(31696002)(54906003)(81166007)(40460700003)(6916009)(966005)(7416002)(4326008)(508600001)(31686004)(2906002)(8676002)(5660300002)(186003)(336012)(426003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 16:19:37.2811
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88e0affb-0f0f-4b6d-89cb-08da27a08f02
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0116
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Apr 2022 10:20:54 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.312 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.312-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.312-rc1-g73ad06e1327e
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
