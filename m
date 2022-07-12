Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868F8571586
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 11:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbiGLJSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 05:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiGLJSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 05:18:34 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F9028A;
        Tue, 12 Jul 2022 02:18:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFm3QK+9441S8Y2j3fqB3KAnDgDLbniyTmjFwk/tBm9jAgwJruGNL97Rh0iUhInGCeFbHlTuLM/XOFhxdIbPQK1K8xyDqcmcYTOssYjDY3/C8MTcsvNUx1hbDwyv5VaTTz4C23k/0sJrHmoQfL5nMLOFcOo3MhK26RJlpEAdAcsBu/pV8IvPMyYBe/OtCBlgUXiMU0uj6U5YaoNWFEzmS33BIOUR1wsGI+OIPbTYbj06hVJ8Hw2+mgVBkchpcsks8LTbU3GVC0C+I/dCtXCL9OjpE2fyC86BBUVgL6bBqUDOlwIXQwTW0cgvQbgCkKzOuCPp+d76wg8xokP3r02mDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0y50jfpALtfOASZFXbb65eZBA2Fcibarc6fyK4d/S5g=;
 b=hzpzWei+9+S50U7cVjefPzAw0CPAzAzObA623P9M0iwAGjFWuOrXQz0Igl98U/t0XOpFPTjroAjRX9LzGxF3Gop9QwB/hWB+zZhWf9CEKFtlRueY8/CB9E27OEQMDfK3qzQ90kGeIaCRB7edMOjhqp8RdrC/KlzwYzpetiuCvENdFEg0mSVgjWSdLnEq7zZHgDE8R2Eq2xbQ/9KDeeSkfbJsA6qK3yMpHlsizggylV+mTHT+DD1DE6pyUzJVBDG5aXzQW4ac+r2DFeW0cqcmEPAD1ZsLfRlIqZ2easzF/R6qnY9cpx+opbYJdZMcZzFRTkq1VJyeff54SYrgTfaciw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0y50jfpALtfOASZFXbb65eZBA2Fcibarc6fyK4d/S5g=;
 b=ee1Eg1FsmRiHCqJehEaJjoii2/lBBswVL/HLFzwvid8hQ+Bd0UOgVr+MdIDKew5H2a4r/zhtodiwmlvQE9ztLpybre6KKNAA0V6W8o211LYeuXyQrL31dhhOryRe4+vurRipy6pm1B6DFMmpaDGPB8nQr4anDJsD3YenBVdE0WTGyQ8h1JLPbaefc6HmvIbSGRo1KR/eC7QI13+eh/S8uS5ZhfGL0eHA3H5KCU4cOlWEeIVDCm6wuC1f9KkumCRz1IykHxIo1RnpT9rOfSdnMzOmpVdSTem7a9/c6unloc/+3pivbO9FjhJj+11UAd/7mgfSjRY7c+4zn8KgKoAVoQ==
Received: from DS7PR03CA0072.namprd03.prod.outlook.com (2603:10b6:5:3bb::17)
 by BY5PR12MB5512.namprd12.prod.outlook.com (2603:10b6:a03:1df::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Tue, 12 Jul
 2022 09:18:29 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3bb:cafe::6c) by DS7PR03CA0072.outlook.office365.com
 (2603:10b6:5:3bb::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16 via Frontend
 Transport; Tue, 12 Jul 2022 09:18:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Tue, 12 Jul 2022 09:18:29 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 12 Jul
 2022 09:18:28 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 12 Jul
 2022 02:18:28 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Tue, 12 Jul 2022 02:18:28 -0700
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
Subject: Re: [PATCH 5.4 00/38] 5.4.205-rc1 review
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
References: <20220711090538.722676354@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fb30ea8e-4db4-4d7d-af21-a4fd0c1347c4@rnnvmail205.nvidia.com>
Date:   Tue, 12 Jul 2022 02:18:28 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3915a161-05aa-4f4d-c1b0-08da63e77c01
X-MS-TrafficTypeDiagnostic: BY5PR12MB5512:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5RclChlclYrvqHYYwI4ULRjk3KQdLxmRufFa7xVns5bAS+L0UCSRyb3BgF9I6itGIKcLu1J+cjyiVU7xkzaqfJbOD0r5o9NtKcMf6jExhTD3QPmzNcF2RUNx2+qjt2sHK8B2+xj8iUUyOzCXK4mkjXZA08apVB4CeYchpFNdsLKQ8KD6wOHbgzv2YtIxWw4y+0WbFcMTPJ37752LJx1I8XkeXFMGb75QfOlP9tTrkTgodYRs3twR6Plp5wBeFGW4fvSh74RLysvN17NB9NGoootrL8IfVOGbCB+YLJUmWzYotaphXWuAL9jOmc7npeq1qEYLlX9ZW7GVLqpAvk05a5xaDjfmZxmmxCkoBVbXtK27RiUKy+ClF9pEufNO46ktx2rhvbmw4qCbA42i04N0Eee8X2PTtxhZ3lV+nP5eCS+1fzhDXc4d4CnCxm1SKamVAcFGZN4UjoboxkwJJjgPGw7mtkKPwfGHmrNeYOlUCOC7d0CY+0uOH8CsOhoparmiU/t4XYO1CJ/pp92Z6WsYaG8OnzeW2+9++eYZ2R7WaFD3Rj08pqKfkwQcck4LX5i/HbA6xosN3mitTW51Xhsr2n2rjssvN88xah1tnz3dvaDgDHlbFRStfbrHlnfmlhXJMO3f3XFKZdHIa+DBTyOGI0k6yJ22Ro8aaNg6RoeM5y2rqD7Fb57C8M7pJGHI7vpIWkXp60OH40tKp/WCPOcFAHx51BISCNz+WeDFh8pkso6Xj3q9jUBDMF5TQ548R6UMDV9m51e9ZU8eepF1THs80UVxphPEXj8J0H+RJjm4ZEEpSwMSVFbWTQT16hVGpDDqnABh+xvqG5OoYel4Z73yIJ4LOKqh5wpxRlNMP7yTsxyoVxigHDOy+fb+f3Q2PUctYG03ABrcsFPOsEgSb7F9Z6vIPne1bxXftsheP3aEg749bHYITRKWcG25Nf9I1ZZz
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(39860400002)(136003)(46966006)(40470700004)(36840700001)(40460700003)(41300700001)(4326008)(478600001)(8936002)(26005)(2906002)(966005)(82310400005)(70206006)(86362001)(31696002)(7416002)(47076005)(81166007)(5660300002)(8676002)(336012)(6916009)(186003)(82740400003)(40480700001)(316002)(31686004)(356005)(36860700001)(54906003)(70586007)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 09:18:29.4181
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3915a161-05aa-4f4d-c1b0-08da63e77c01
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5512
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jul 2022 11:06:42 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.205 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.205-rc1.gz
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
    59 tests:	59 pass, 0 fail

Linux version:	5.4.205-rc1-g75045bc7e7ba
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
