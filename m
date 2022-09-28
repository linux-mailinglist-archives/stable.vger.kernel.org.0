Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B6D5ED783
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 10:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiI1ITj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 04:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiI1ITh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 04:19:37 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B99BEC;
        Wed, 28 Sep 2022 01:19:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D57AlMfdwqLd+SAJjCh/Lm1RrtXCYfiyE7q6EhL9ukeolCF51Ow2uihTyV8/V1KnzpEJD337KuILyE+KN+lNiCAGz/Tp4dxwkhbfUX0Hbnib1C5fsKHApZofPLecX6NANvILszFL3Oca4Q2RybFcwbkn3qGeyjzFJBIjkdnLL4Ji8mnjU3vVjI9aHBv81en4Q6u9hiIrXfzcDlfhhRqlN1EMKfma8+g69YSn84pki+y2/ZxSJS+5ooKIjnDTaQazP55IUoEiqA8z/IFS0/fo+HVx+uXXlBGgv/LLGyEXGlo/RHVFpQKy6KthTQ7oPUUH2SxStwaCHHMy+g0DK4wd7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xh4gF1Eu05bs/a9dUWKZ1Zme0hAV1vQL8PGUYjgWk+g=;
 b=FM01+ERdtf0s9x1JXwo/cyosYjOmm4rZ/kLn29isUMorqiPhYMy6OyUaa8sGpdt0Ap+Q3WZ+CWdiq6Q9Hc0RcGF1DHnHg0oR4MaMLjPOSkfNE5gTi6S3P1wHlKxrGGfb6jBObk/th3e+nH3Sd7c/4HBXD/m0saNyZO9yqNxLJMiN/GPLkE9XQDW6VqW+ZkhOi0jFbXtpFh8XyRkdpzAW1JeEsIUhsc6oFozmGvgcX3fY1ADtQG50cmQInE+CLxih310RIl2QtDWZ+usxfHulTVWbzx05S88gA4ayrVo0Z5RBwghtxU8VETAZ+M893tit0PxfHA/UazA67WPp3Wis1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xh4gF1Eu05bs/a9dUWKZ1Zme0hAV1vQL8PGUYjgWk+g=;
 b=EdiL5lwBebl1ThndFI3o8cN4ZUuTh3e/ju1cAxsIfqXhwLxeyzW6ECZbgth8dLEsCbV0nZljtsM+cVSqp+s7OButt63VVdE0sq/IG+1xXCDPT0CtNgWZgHylBIldAixk6AIeSvnQqSuLYMat3w5UNKAj5Ry27NMpQS/TS/W1D9mZyR8HdNX1gjrAMSSRDx17ySq6UUJvv3kRS2ZkuhLiZ1qOJwJLAg84akE9F9m4QIpO6rOSmyxGgjo2me79xwpI6sCuM25A7F4JC8/PN+xjUC9gwPFypK17YbLvAEjjqkexsxSpVi2NUzo6/Dlj3cpA3ckyVSG+K+0N5Cf7e9LS+Q==
Received: from BN0PR04CA0114.namprd04.prod.outlook.com (2603:10b6:408:ec::29)
 by DM6PR12MB4578.namprd12.prod.outlook.com (2603:10b6:5:2a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Wed, 28 Sep
 2022 08:19:30 +0000
Received: from BN8NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::41) by BN0PR04CA0114.outlook.office365.com
 (2603:10b6:408:ec::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17 via Frontend
 Transport; Wed, 28 Sep 2022 08:19:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT084.mail.protection.outlook.com (10.13.176.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Wed, 28 Sep 2022 08:19:30 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 28 Sep
 2022 01:19:14 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 28 Sep
 2022 01:19:13 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Wed, 28 Sep 2022 01:19:13 -0700
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
Subject: Re: [PATCH 4.19 00/55] 4.19.260-rc2 review
In-Reply-To: <20220926163538.084331103@linuxfoundation.org>
References: <20220926163538.084331103@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fdeb6f9e-8c2a-4509-b5f8-5cce23244fa0@rnnvmail201.nvidia.com>
Date:   Wed, 28 Sep 2022 01:19:13 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT084:EE_|DM6PR12MB4578:EE_
X-MS-Office365-Filtering-Correlation-Id: aba17256-4b59-465e-5138-08daa12a2ac4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AVzBmS2D+Jo3YRx+O61MgntKMFQg++Ga+6CgAkrSkNSCfwT+vIxOEEHH33ZVo6h+F6uJl2SFMeaXIwnMBX3re6y4hSYr4COy+hn7sOuuz7e/uP64JtvO96q+W05HwDU4HYVzX9f6HbZpNi1AQyWLKs9AyYrj/B+cKtoFU/WQlAYklPKonwClTjD/TKn21rF6CDK4hYtCKPJDNTv+TDCMROZYIt8+clGoGIXsFq2jOmjqanLq4q7kowNtjDpJtoI2PhgW9uJxQttHToRnBq/EgPe3Q+P8K0kWnXkgcPKuv4eXG/jYvGUDqxlmjTgRvQT7JaIYaahwKKl9SmFmt/Ld+0daL74zNcPJk3U9d8ACqX/AgfRCR8T4eMOOrhpGqCKO64DrhDVp6XnZ/vDSV8bdGRIy7i8EcbzyQTakQxXAgVA4ufP3oyvSG4ltD9Su4+3OtNrOW8bHvE1bhiUsmXEimNhQX9ctw+h+T3Um9ugXtmGMIOFvKoO7m6fYw4dgiCwG6wGGP/XcXmyXBUPk1hXzaSEfyn+5WeRfAcqm1etHFcC9MW1CuUV/a01AU02g/h2wEDra02qNilPPX00zqDE2qv+QgzXic3OhqqkZ3dcbVMYmwXu+Fqj1LSyaBwcM8Kg2Ra5zV3fZZK+eFQ/9LMBnX5puJiTk1FYFkCV537bTsazr8Z1go1GEq7LN+egtXiwUTelTN+cgQwIuy8OuUHlbsKyns9sshDOtsO1L2HKSBjnw71ymVHMXRPrfapbvHmRVigxNy6jxyQnSRnwSB5G68yCLB77zvCoqX/jNqcbWms1Mai0LjVVdCL/gjhKOsdpKuAMHBcjySFhAFtJZzWLnbJSg19qvFTZfeX3AUkhUHyY=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(346002)(136003)(451199015)(36840700001)(40470700004)(46966006)(54906003)(6916009)(8676002)(316002)(40460700003)(478600001)(356005)(7636003)(40480700001)(5660300002)(7416002)(4326008)(70586007)(70206006)(41300700001)(8936002)(82740400003)(47076005)(426003)(336012)(36860700001)(82310400005)(966005)(86362001)(186003)(31696002)(26005)(31686004)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 08:19:30.2366
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aba17256-4b59-465e-5138-08daa12a2ac4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4578
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sep 2022 18:36:43 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.260 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.260-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.260-rc2-g210639ab50c7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
