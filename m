Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B64F5AB6AF
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 18:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbiIBQga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 12:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiIBQg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 12:36:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767B6EA8A0;
        Fri,  2 Sep 2022 09:36:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ID3ukcUeJ0ZO31FNgQlKFz1Tk/a6ItaIjWEAJg856JJX4QC0/Ycem1qLrlkjV2jcOoajNdkLWuClQcVE/6nKjxgivMNtK+AJgvWe1DDmGdHcOVBgnxWvHjSYaY3V7W+THOhyBb3o/zOCzbLZ0JXOb6Z3wU5XlbmBz9KFazVuiBgdFtDB8gMTgHmrWTGglzYxv9jfBQbsWDOoLMCIlZ6EeXJWxG7fkSwRhJkKpVJjHfY2o7J0VS/4PjOBNcHd97mqQTkcZ2rbXd9ze35b8KiTnTcg8pJKGxuWPsQXvTLpqpvauY0itXm8BzFwC/6vxdh/lT8QX4QdiWquCp5F4vU85g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nrZre9aRNXu66xKAJzeTmSZFObZnoz5/QxDgzFAEuJk=;
 b=E+2wveh+P6QWJOWuvAHeaYL1ctvq6Grsp7mpUD8GqxAIO8nHd5t8bIiuHgnKueZx01UxDBlmYs/yRvvmH97o//FWMwJRqqNbhJCldWv4cTOF3+4UgK1hQ2Cw1ukvMx/MHwGF9u9OCTG72OEymEjXPdXk93yyq/VkDU1iHZmCFWeuR85HtVj6xQBoyNrVGu2qHaN49BOxnGATU3QE+EGMJjRk1r/7++8dltSHAa2cBoT5Eum912W3LpVrcx5vyeNV+yVYDvLg8+OCond98Ci1z1NppVmasZZoLWo4/6qXmQeJrekB4BGK/FlyAMo3sfJIcuFRm2kn11SFE9oeGcqDHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nrZre9aRNXu66xKAJzeTmSZFObZnoz5/QxDgzFAEuJk=;
 b=NwbZfrgtWhZ2coh43wqLq/Dz85+a2ijokAAhhNZrL8Da1DjOieFDj967nE332HuULxxTIGPItH0vLpwHX9QZWrMSKtQd5QRAJJUENAjWmf/H2fB3qqcEXjhfjZdXz5J2In0nuX/ZjahrB5B+hpNP+Kl0pyl+tOFtctHJwVYWxlIRHNG647kmC0CTVDQ9mTXBMWZ40L2X3X4W3mBiEHwQWKH7/wfCV9lp1CQD/LEYzs2Uu0IsgT7r9ZTlgHnTnHD9nQlSzn3BZI85fX5j36fz9KV1WculohHE885LdHDFRE/y7egpuH8uK9vpxVQudCHPQPPqEYVvSwaE4BurcoFl+Q==
Received: from MW2PR16CA0028.namprd16.prod.outlook.com (2603:10b6:907::41) by
 SN7PR12MB6960.namprd12.prod.outlook.com (2603:10b6:806:260::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 2 Sep
 2022 16:36:21 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::5c) by MW2PR16CA0028.outlook.office365.com
 (2603:10b6:907::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14 via Frontend
 Transport; Fri, 2 Sep 2022 16:36:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Fri, 2 Sep 2022 16:36:20 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 2 Sep
 2022 16:36:20 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 2 Sep 2022
 09:36:19 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Fri, 2 Sep 2022 09:36:19 -0700
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
Subject: Re: [PATCH 5.15 00/73] 5.15.65-rc1 review
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <729a181d-e4e2-43e4-be7c-15493413be0b@rnnvmail202.nvidia.com>
Date:   Fri, 2 Sep 2022 09:36:19 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4551abef-f610-442d-f4aa-08da8d014443
X-MS-TrafficTypeDiagnostic: SN7PR12MB6960:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qe8y24LnZUjuPIxUcvDshJYh83WHVOraQodEXsXv5JKd5u2/n8VOXXjrn7O+i0t5hVcRjmTD9WACBJcT4rOWyVLfLXcao3wpQukaTWqs006Bx+j4jPD/SUkXulZTtRZnrnNoog7HbBKuLyECK/XFJDOeacZrWSeFYboCA+iGHsCmya9iIHPpzN/IHnnq9yicCTN1oSmnSIWv5RGt1mf7I9LV4dSYODONSglJuvNq8FZsL+y+ypxxEUo//9l6/+n/YLON+mDVkTqBrLfODe6mx+Xt9wvqEx2N05YdNJLe78T7BIZxh+zkSPU4gj3NnNpHvmWHxXTV3b4J2LU8e8QTfd9TyYXOvFqnZ3ZfONaY08/mwvwLfFFmVjdHwf4BWkIEmiTIztwn3gVk6MWFNG0Dl+R0xQkT/8MWNXu+VZR4peYorD9AQxgn23vgPe8f5kz0PS0/lcc9aJvQyk0DEc31GgRK0nrtmaCaCxQgRGfek/2dnZiFQegWFa0yoYUFGMVvss1YFO9y96FvDdlgGLkIv7PEaaHRSNprCVG4ZjKYgbwH630H6qgetomq8xBxXg0v4m+dnMm2K6wSh8VCI5nmiu9Z5g+pl76G5Qgxt88GINX4yXM7l5XoNEfuskcNMx4iNiVVcK/MAn+pr+nchSwfo9q2PqF4TVJvFVhZmMF5o8NkV5cfLUmV1p1yfQiG5OCt7X+LEDmoyeGnfh5lTrUuJBbgq3JLIUmOm+1TpcoYSnW2WEa4NK1zNt3vXf9dKnoY7DhlUFsAJ37senELxYVefEK7gDCZKu/9Ah9peIbxVDtum9dd6UbO31SBBJPLT3qFtDMfL90hewgClxJQSdiS+Op1KdlpGDrQ8yOzUi9GPAy9DLJP/MCd0oDEQTTosgmQ
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(136003)(346002)(46966006)(36840700001)(40470700004)(47076005)(356005)(336012)(426003)(36860700001)(82740400003)(82310400005)(186003)(40480700001)(31696002)(81166007)(70586007)(5660300002)(8676002)(316002)(86362001)(54906003)(70206006)(6916009)(4326008)(41300700001)(31686004)(478600001)(7416002)(26005)(8936002)(40460700003)(966005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 16:36:20.4884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4551abef-f610-442d-f4aa-08da8d014443
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6960
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
> This is the start of the stable review cycle for the 5.15.65 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.65-rc1.gz
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

Linux version:	5.15.65-rc1-gad2e22e028e7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
