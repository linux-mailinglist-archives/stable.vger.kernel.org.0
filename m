Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C11F600BD3
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 12:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiJQKBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 06:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiJQKBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 06:01:38 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2053.outbound.protection.outlook.com [40.107.100.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95894457D;
        Mon, 17 Oct 2022 03:01:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2ZM4Nwl3SaLOGEvI+6mUTByjG5DWAxlhGF6fmFSrqaKntlgFLm17gpwk6WAT1Gd9ufjoOk45cUHI3hfShkYrg4Jix32PQS/KwLxx/+bstLMuPa8nl92Dq7z65OxaJPYJkxMa593vXlc0LuZpGZ84sqMkQxcFDhba8Mv5R9o4yRUlYaOEfZOg270Lm+vehVcJ4PCSIMST6qP1I+kHs7REtnPJOMK9n8fuA2bRphO1XoArTG7XNk2NtZgGrnKwlY2K2d804ZVOrk6QfHtkdkcf5cT8jLwhmDMnwgGRDta5xbYkbni01LHGNUe1FrLaAgfFMCUjhFCj+RCsvmF1CltXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2FaGAFSw0D3Sx+5KwTIwWCIua3tAkHjjxOlXDnJye5g=;
 b=YZ/+CovMFtofkc4K2Ci+UN09ZSEQI0XlUumWpgQTVL7T2V9dd0+dYgeB52owRfcaLiM6qCTkWqMsr/59gzpeDIU8pPgWKdxEDzmBcIHAd46Guz8Can7ozANMGvf5lQ1cQ0X2ZVo7aRfMNxAr0VD2o9+/ICk6Q0k/Ec/m+yzb6rPFCMzt4f7u+kKI8BPSzGkZAjXkj+DpT2IW0l68WXPkHlaIB/1RTFXqemPXYC1qf9N/M9Utm7KZWfsImvHiSmGR3WtHywspQ8bTS5vbXCylPaa0jK7PCGHdDju2cb3OgZGk1pqykXmoBGV0ZUU4L2vW92ABlZWxevWI45uDHBL1MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2FaGAFSw0D3Sx+5KwTIwWCIua3tAkHjjxOlXDnJye5g=;
 b=W0XH5vDv1HmFc68DNT0lfr08AnRvWMTBgx2n91duQgG4q95GhIU46NT1zun4wYBBYbQvRTLEJnNlmjHJQYDGeHjNK4ucexdWybcZEnkYnRl6KMCZQ4hNi0qZJfct8p36k68+EMnGV8OBPOiMMZof7r7hgko/KHVBViSQwvU9Z1xgk9xPhsPJg4kU4tfKelXc2+gt8l0e1dB5PQH0lp2vUUznco9/SpjaLFh16s2j+5ZMaD10ZG088ihRW8+sU1fepE+JkzKUF3Cd+sOiJYM8IpEXL2Zdb/hKWjPvrxIIzdB9zlLGO0GJuhmK+30X0kYccJ8UbpimnH9AxbAvA0YlBQ==
Received: from MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::12)
 by MN0PR12MB6342.namprd12.prod.outlook.com (2603:10b6:208:3c1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Mon, 17 Oct
 2022 10:01:34 +0000
Received: from CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::22) by MW4P221CA0007.outlook.office365.com
 (2603:10b6:303:8b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.31 via Frontend
 Transport; Mon, 17 Oct 2022 10:01:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT073.mail.protection.outlook.com (10.13.174.196) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.20 via Frontend Transport; Mon, 17 Oct 2022 10:01:34 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 17 Oct
 2022 03:01:32 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 17 Oct 2022 03:01:31 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Mon, 17 Oct 2022 03:01:31 -0700
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
Subject: Re: [PATCH 5.10 0/4] 5.10.149-rc1 review
In-Reply-To: <20221016064454.382206984@linuxfoundation.org>
References: <20221016064454.382206984@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <65fe35ec-2eb8-42ed-b85a-dd6574ffd177@drhqmail202.nvidia.com>
Date:   Mon, 17 Oct 2022 03:01:31 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT073:EE_|MN0PR12MB6342:EE_
X-MS-Office365-Filtering-Correlation-Id: 96c9b1a2-391c-483f-0263-08dab026929c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q0CVQK+cfYsQ9LzdziW0r5R7b4KoagbzPaG80aXJsdugc0+dTZUnSHKFrk3klmC9m1NahiBQvyK1qNZHKRXj14+rGqZrcN6kZ+eYJAxq64aQJwQ/WPtzy/6u/qytBJtv6/RUYCS8ESG0PZ56HiLTiXfooo6gAeY1d465rXiJWaVFtqrcW76GtfzzFGmZVMh9ov8glUrbPSA7TmEfLzb9XNxgjBgBM3UMLc4y9My29h0luLMfeNpTYqxgfrrZjBCW55A6yJhxuGW/YkBBIsYo62aTH0iVd0/otwX7r0DLiXm6vaiL0Noiw9YrdVYetDsDiFzg25t0Aby351f8shX8CWZEdych0F9kLEX3xwU+TuuUmjFQEPWkCSEphiMmRhjLOIwmvE7S0DZnpbHbnXUirUrsEiX+deT+xMO6A3GeNd894My46kyNl365sSwSzEoriJmWlNaMBqkiELVI4OxT6hJ4IL+yZsBi1QG1rDyH/KBTbJjy+0qMyfH5uoX7gqlzAErqYQhLfEspoHd1qjBHE8pI+wFtuLbXBNqV58YyvbLsx/TqBtcCGMh7bsji+xz/FQFEkWVCzBrsxG70fi0lUJBBK3GEUoJq/bGvoZaq4rGFWnEPVqS8on/NimVXfHDD5Ky17VXyzIH63+lUnH360/U6MB/lLcL/0+KCzhdNLk19jcBwBQM2Ks0bIaUkXHo4VIKGkR12LIWD6CUhji5HjPyAFPEA/ZgWzxMqQdR96NajsES7gZvrPfI2huEvxGJpZn/fuwoN6cGXd2LQxxwwEXvkh6D4QXVAsHBHFf/5bLyb7np5ykpQj3D2jgvAWXMnYliYNaOwlERGKBHxtfdKubkAyaA2LO/Z8NFPRJOZj2Y=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(54906003)(6916009)(70206006)(8676002)(70586007)(31696002)(41300700001)(4326008)(5660300002)(36860700001)(316002)(26005)(47076005)(426003)(86362001)(40480700001)(7416002)(8936002)(40460700003)(7636003)(356005)(2906002)(82740400003)(186003)(478600001)(82310400005)(966005)(336012)(31686004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 10:01:34.0196
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96c9b1a2-391c-483f-0263-08dab026929c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6342
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 16 Oct 2022 08:46:10 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.149 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 18 Oct 2022 06:44:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.149-rc1.gz
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

Linux version:	5.10.149-rc1-gac0fb49345ee
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
