Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB868584C8B
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 09:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiG2H3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 03:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbiG2H3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 03:29:06 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2071.outbound.protection.outlook.com [40.107.102.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5932780493;
        Fri, 29 Jul 2022 00:29:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foQT/ksqTLppHMrH9k2WSj+3gGHO/TsiAxWKO4fVyUvW8mYZzGQLNMs8dP24Oy2Ev5wuf3DdroOZURWQ6BxxIoA67jDwyFdX1TsTpKuaiO3c0Jx0I0O5EI1jeaI+F9s0BhzirdnXb49R0hwbYIVF9TD37cR3Y7BJgX9DVlvrFPUJpNA3c7tOpRDWG+NylEos3CWfEUePSknZIThnQYGp0RylqXzCCIWkI9edouV7YZRsQXwPJsEeD6URwl2VJMujS9RThq3dTUI7fxm/lnhaJ9ziRKOR9M843ip9zU1qZP246W1clWcFFfNRTBf8GnC6oIrZ3eHo47xUs0g/mK2hBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GGfkHq5NmpHwMT2dF7NeaNGF4BeOAVPGc3+fRNCE2P4=;
 b=NOHr32q0u/1xpPEDqCGllhbSeq+Bly6giJ1KrV7t3xlId8HBeyc0jjaVtiyMIa+/MwNVn96HUWRxgv0sH2mGHliTOIz3g5ls5lXMbeUBSrhkIcbr420Dz8Q604m1/o/DfIjyx0uts1xvszSnlVgpjCuYHgcrRQbhVNMPxhMwQ5XQz9rEGV4qIbIw9gxu987ww8Uhlkd6GEnXwJweH+sa+KJOKq/n0JkgqC7Lt91yLEgOIRE8XdhHq+pugAjklJF3XWGfKVOT70gbOIzPQbDxiuGnd2jWt61vA9AHrsvhu1cJYnSkCoUnC+nscmyHq0nma9tHbpHdX47TEi5J2BKmog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGfkHq5NmpHwMT2dF7NeaNGF4BeOAVPGc3+fRNCE2P4=;
 b=QuFDpbtI3vdyDBp0SBY3FnDlvgJcuoBGTBQMitTLJzUE0DdY40z1VMxaEtzCq0r/DMIyPoCedoxmGFTn/6B4OvyJqktDQPL9NpuYXoI74I5fkUHDlyAfJ5drv7JM0YDQIICJVAEwEQEPCxWZqi62f7wFvvGzOHsp0xWzI2ORGNcGMY6brJFkxNuzxAijSeIISyrgdO/c4VjG4ZOXzBjIYvCef5NVdiXf+tMJMn24jehiSp6xCdlxC99hYR3oAl0xWr25WNUCPeye4cuphrbmg9MXfpfVP08G9h9FoX/96DuIWIBZOtxiSMMK6lqBQ3DINnhpKZ5GTBCHEMrlgFcW4A==
Received: from DS7PR05CA0045.namprd05.prod.outlook.com (2603:10b6:8:2f::7) by
 CO6PR12MB5411.namprd12.prod.outlook.com (2603:10b6:5:356::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.11; Fri, 29 Jul 2022 07:29:03 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::ce) by DS7PR05CA0045.outlook.office365.com
 (2603:10b6:8:2f::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.7 via Frontend
 Transport; Fri, 29 Jul 2022 07:29:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Fri, 29 Jul 2022 07:29:02 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 29 Jul 2022 07:28:56 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Fri, 29 Jul 2022 00:28:56 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Fri, 29 Jul 2022 00:28:56 -0700
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
Subject: Re: [PATCH 5.10 000/101] 5.10.134-rc2 review
In-Reply-To: <20220728150340.045826831@linuxfoundation.org>
References: <20220728150340.045826831@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <38ba67fb-5765-4973-bfa2-84acfa50555f@drhqmail203.nvidia.com>
Date:   Fri, 29 Jul 2022 00:28:56 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 954b07a8-31a4-4f6f-285e-08da713402e2
X-MS-TrafficTypeDiagnostic: CO6PR12MB5411:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /hbWboz9mtxE04+Cx4Z+K7KXIyf40xC44JOa2W/8JLhNAbXa7HHWfLMYs/f2ripUQRl2s1LaGdYG/IwiIYCTdLNR9OqEkWWIgCT3BsdKHeQjEmsGyilu07m18HUk4x/K6dTKF7wfjz4jqmFaKZB6NLxtD7/EqTBynMf+htrQs2jcc6F9sZhgJ2MyqktajMD+UbUsTC9NkOe0prUO9BMUSI7pRvG78j4E2siQ+eXGMGfpfr9OWUVtyvrUXbKmAS5h2A+34cZhhw2okrBQZ4gFmSEwJTMAS57XDwd9cCfARLs7H2rB2xshjS1kEuzMOoWFN/cg/xb7doki73d0mYM8RE9SywqoFxCK3CScm/KIiE3sVpSbVPd7pQ87QpBVhs2kW/lmwVD0izSN5hIynNgMaL8mfheOoAAqNoX6M/MCov2kBCepEdH5nq1VBHfx/tTLKwJlvC8iX1rN6If9VhFRXlTTOOxQPaeyf+bJTXwTXgnLMN0MZtCA7VxmXpMiIarr8ND42ozXfaZx2cbdamMkGZQKfXwnl0fg5Bb/ha86odwidaGnzQEJ+by+q2qGnGrTAPOKB5rXULhLHVHZCPrQMxyopvUAJ8EwUf5fjQ9LPJmgAhDbftbRwFLU3ZsMfbnPw9j8QQAPW1r0ApmuubTods/SHHtwzYV7x5gEU7m+8b3B8LaeIJVN2Tg97CJtyfd+/RXXWs4myzsD/sfGTzjEDh4lX7tAnBTx07uhCypTVwsZ08nCgxhCLHLgamyPD3F8rmRbEMZsj6V/ZoZOq9tDyqgwfheohCdLgxr1+MktLKEsJ0eB3kAXErYbV55rbcEd9MnRf4qyLKKH4bDHWAV2BqdaqVGtcM+FP7kjBmzDzFExatXOb7raRhmn29SolKS+rjptCRaKZaKxmdREl2jmZk02YmzXQlBezBW1/cFYIlg=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(346002)(376002)(36840700001)(40470700004)(46966006)(966005)(426003)(41300700001)(336012)(47076005)(26005)(478600001)(186003)(36860700001)(82740400003)(356005)(81166007)(2906002)(7416002)(4326008)(70586007)(70206006)(8936002)(8676002)(31686004)(40480700001)(82310400005)(6916009)(54906003)(86362001)(316002)(31696002)(40460700003)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 07:29:02.5866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 954b07a8-31a4-4f6f-285e-08da713402e2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5411
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 28 Jul 2022 17:05:52 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.134 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 30 Jul 2022 15:03:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.134-rc2.gz
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

Linux version:	5.10.134-rc2-g3dbf5c047ca9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
