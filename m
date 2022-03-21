Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BAC4E309C
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 20:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352502AbiCUTSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 15:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352544AbiCUTSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 15:18:01 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2BA16F06E;
        Mon, 21 Mar 2022 12:16:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGB5HpNLzMpVjkTFIp8PxNwGXSseElapBMUU4q3vvNOFet2MYA0tiGrVMgVgJK/fxHJK+bIOpAK6n8RqY2/2/0rjLaIXV246Pv9YfSmhEm3iOCmj/kgmwfVq069bX9qqE2gFz79/B5j60xv/5+jpXDCSUvvPo5uqB5oc4jtv5Zy7cDC4KqBvOkyoLQlWiQY3aYoo77ZTy/CDwhnOK/Wal8N05NrcRKrdPz/OqrDCzYYgvkswfe1wkbpdMHlWRUYZA8WRsUcz41nWH2C+u+KOwvP6yhm2ir9CZkWaG7jaEcSzPrCrD1ZTTL2HVwUAmse7lNapAjMkglFogdUzs16OMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+KNxdahgqkBqk6Jgw8JBIbWiyP5373HM7EY7yc/otJE=;
 b=MuT3y5uI05sb9o7FwAOklSmAQawciXR0nCGIhm5TMRMe5883OR1Zj3QyN/Xr0TxVTTlQJFLeWo4uf4YB1SUM0sunEM1jojUkxZ/6gOdDi7YI7h1I6CC+UuZBH0wtQiLv+hx5frl/emGHWRnImzSqCRq5NzXSwPMkynzJ0VRR4dEoU3PFIZhYBacH9+2Tb8tuf3XPPtjB5hmpOCGE4tBUcJVMU0BLj9pJHNa0Hmy52w+O44iVxxOujsu+o3IDovf26pGbNdSTotT9Qbg1zju8xcwhkdc6gsd3fircQR8iWMSAjam5xMMWnnKx0RkSGxJ+UoWdhJ32e321ii1C1qMTcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KNxdahgqkBqk6Jgw8JBIbWiyP5373HM7EY7yc/otJE=;
 b=G6eyJ7D9SAloSCM7sFFn0TPIH+iDaPxDxyfPw0GD9vFYLnU73i4ZhvjQfhpjfgH7mYIC1HOm6OSjk2yM6jrD8rywEUOyyKcSOKmYvr24gReGbQpQ4su1ANHrNE7FNymegBzsJqFvjeYkB9cg/3E0F+xgLDqUSJEgFR2q78KTHHAOwMCFUXqhhYovrBIhVAlxybBAawS6AAYJDY63acA8BAbfDPSjAzzQLWcWEBBEciTQngeIpEi5HznSgB+n8oCfZ0Umsf7iOcQyVNbwigHZ4Z/8SJuicapI/sLn0+oNi3dONNDsW0DFDFB/R1/73Vore9osG/Dcys/6aEsLICQFDw==
Received: from MW4PR03CA0315.namprd03.prod.outlook.com (2603:10b6:303:dd::20)
 by SA0PR12MB4352.namprd12.prod.outlook.com (2603:10b6:806:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Mon, 21 Mar
 2022 19:16:32 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd::4) by MW4PR03CA0315.outlook.office365.com
 (2603:10b6:303:dd::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22 via Frontend
 Transport; Mon, 21 Mar 2022 19:16:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5081.14 via Frontend Transport; Mon, 21 Mar 2022 19:16:32 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 21 Mar
 2022 19:16:32 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 21 Mar
 2022 12:16:31 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 21 Mar 2022 12:16:30 -0700
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
Subject: Re: [PATCH 4.9 00/16] 4.9.308-rc1 review
In-Reply-To: <20220321133216.648316863@linuxfoundation.org>
References: <20220321133216.648316863@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <41dcf2f8-49fb-45da-826c-065fd45fd96d@rnnvmail203.nvidia.com>
Date:   Mon, 21 Mar 2022 12:16:30 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5836713-6ef5-49aa-39f7-08da0b6f4f3c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4352:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB43527C4A627146C8361F2023D9169@SA0PR12MB4352.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BPeQTcem1YJC7jobaqfWWFEicLxmhvBeOKbgJMtEVu0IUuey7m1oMG+vxjBIF0W1KWfApZar6qWvOHa7HjTvmDws1iq7aJi14muzK+KSBVnVjM9kuxshfKrOzIsZX/RroG6mXR0UBht0dM9vF5cKp4JSAiN1BQrHzwfJlTNzZZoPlE6D721cvp/xUaaAfu6kWpUx9vjL0O2WNK0KgHWY+LRNxjX1HD7nlJPidTE9melfD7doD/Y8PNwVAZGEhE11sq48NHKKZjVJozD2NlwCHr7V9WNF/SE/vPqR9IxLshD0L1jEQL57f8byu1poDtKRGjEom1X+DpguMXXl4qtYglSV0PvMz2eYf8xdgp9EHP4jDWNgQ2MD/SHmRnNX3X08WVlNbIHzoctI3lz5FhOnR0hqNvw3SAk5QBxRiFaj/YoGFaJoxQ+kgjLWbuv7ZbJDZCw0VnU6ks4DC1PCda+fLVx1pCo9XHpADZGh7ctQIX09Na87VPgHGeL8/mVPhF+VNx9PaCdfbWEiQpJ2KuPvL9FE8C1g/wMZgIBTQth9dSedyPK+gg0II2Vep1Rwtp7KfCiObEVq4nB2v0dmGT+3BlbehRV8fglh/vS2NzwwO9At90kQARazThG4xz9lNMd5icbECRahqk8xhqGFzh5a/Lt1VlapytZOR/yoke99omNgeohn8gYKrfObd6anvhgsl9gxt3imuh+qTnQF7+W/UnuF9e8gR2ViFlpRgV/Tw9tXrysDwNVLoYzZWWwhXXDqHUHU3mlM3viuvkHGHxPR5CZhDeA+/sBy2z7PWKUudIE=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(54906003)(316002)(6916009)(31696002)(86362001)(966005)(508600001)(82310400004)(426003)(36860700001)(40460700003)(81166007)(47076005)(356005)(8936002)(7416002)(2906002)(31686004)(70206006)(8676002)(4326008)(186003)(26005)(70586007)(5660300002)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 19:16:32.3562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5836713-6ef5-49aa-39f7-08da0b6f4f3c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4352
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Mar 2022 14:51:30 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.308 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.308-rc1.gz
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

Linux version:	4.9.308-rc1-g9edf1c247ba2
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
