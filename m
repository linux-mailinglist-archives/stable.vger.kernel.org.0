Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229DB56712C
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 16:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbiGEOfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 10:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbiGEOfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 10:35:50 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D65F38B6;
        Tue,  5 Jul 2022 07:35:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQgjSu3gqPX1ucE5FqJqFpfGSJ4vAs4OtsMWhmoZ6nd6oXYquFK6TZHXffA10hAFqCZdfyxDuL/CcIYGFIlO2p77cwGlMT2XcNw25HuQPIWyoJPBeoO0YFwWDQpcgPpxQj9/BycbvQ/U6RfkfUtloF4Nirz5fKZrUsJ8v/tW4cEWBK5JVEggMcoZmLq3A0CJpF46sHQm5awOg7DVRg/K0/dmmc86ljlfccGbetaAgqizTJ/a1zk7F/fBr2R9Dpzba+XvMn55jVPbtM6liey12ANLDFp9nb6Kf7A4jkDioNPt+CWPOK59qohGhghO0x2bF6msUWwgBlKzBx+1yLl2UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKXlQSoKcOPfbhYMxYaEcsj6ykNSLTQdL8E4It6h5HU=;
 b=mtryYt2/okxCeGwuEn/3ajJFUvmGbHIEKd3SlRAXjctxVyAieR8bSsGdfWBPAwOuXrSb9GGsInoqk/uVakxODqdjflNoyBMZS2/3qxubaG9FX32kdIHL3trlEtHrqSriAvytuPQDG1ixTyO3cqXcbtw0og2i8a1Zp+Xpsl7dXaSQqP+2m2h+ntl3KK6JrSpO8pwVTxFz6MwXktMsv8pu7RGi7TdnY8+JnVAg8crBPx3EJH09qLS74auluEfhS1sh2xCtEKVHPPA9b27v4nbKJSjAr5TS5gkVZmTib6S41qS/ncSp81ezsBqF65bqyuTQ6tcQqdV/vEsmBVS5kKI1Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKXlQSoKcOPfbhYMxYaEcsj6ykNSLTQdL8E4It6h5HU=;
 b=E2kHVpRSvXvm06/0OnEglumTiiWv1HnTaDY8+X9P84Qm1pkx1JrMFEC0nN/SgMXjvJzUN92FXVtu3q9mGYSmFM95drFhHFNlAvJ+SyaDGPm0CQoT95efuxvKOdDVvcZeEDxCEeHNWz3zj3YiqsPVvNMltffOsumFJHm/1lTAc1hJPrQMzjhO/sKkbtqjpg1b9DszCYHeUmhOi0Boa2gNQoyLQUPVWNqFU9fvCQpqmnaCnyrP6Rf1yGMf7k+UhwJygDcdTba0XzyJP8sQBcPgbwsHjJL5UQVO3W1P3RMIZePx469iyu6xG5bszcCu+OUN0rRmX1l7ga4jKIH0ZvxIWQ==
Received: from DM6PR18CA0016.namprd18.prod.outlook.com (2603:10b6:5:15b::29)
 by SJ0PR12MB5502.namprd12.prod.outlook.com (2603:10b6:a03:300::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 14:35:47 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::54) by DM6PR18CA0016.outlook.office365.com
 (2603:10b6:5:15b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.22 via Frontend
 Transport; Tue, 5 Jul 2022 14:35:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 14:35:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 5 Jul
 2022 14:35:46 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 5 Jul 2022
 07:35:45 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 07:35:45 -0700
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
Subject: Re: [PATCH 4.9 00/29] 4.9.322-rc1 review
In-Reply-To: <20220705115605.742248854@linuxfoundation.org>
References: <20220705115605.742248854@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <80a3e216-0808-4981-b9bd-9f5372afe6fc@rnnvmail205.nvidia.com>
Date:   Tue, 5 Jul 2022 07:35:45 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb180cdc-9718-4ce8-7f1d-08da5e93a67b
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5502:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HkMW7+wKxyPapt2mTyKzb1k75OQxxQ4SX2LFjCAQ6k5fh4f0jrEEZ8ytjyEbgoUgL/5HxL1X+Nm4ak312p+9MoHDagcwJUJ4ouVt2aCfhp+pgqDL8XKVcG2Lr8vYqIDqBIGjBlkEUtWkR64vAJw9FPhaYVaIR1eGztWVwY1MipNKocw6mCxYKTqCxYQ2tCyc/Y+KnYQEpIQvPn0uDrD2hpmdgt+m7Y8+tTPCh8C2yGB4c9bGG7mzPRcLPyRfS2j7UkcS3ajVFfB3soQAa2N5bY4SVRcZNum/OhhWwrwcflP0BqZd/CjLGdrzLhpNB77kYw+XO4WuqTeErYGOiD6a7bdL8UFn8oCska38Zj8YoWA1Pd7gBVY7YGWBv4ZE/t/Dmy5JY6xHPMMzp851U29glAHzav3cmFwd+zX8wbbLmmD7baSWyBOVA89F3xf7Ts7SXXYp69w/Ahqe4GdjSGRvE9RX8mVHkzXDsfZRY5HRucWL/4lmkQyNZUOEiaJeitWLM0iVltyuOAxQWxtlyW83KVxGKHU41+hw9n15LrrVvhth+IY2S0losLiwptQz46XAx3X2RWHnbhqJyGo0nrMUbKuJrJ0roZh+KiEUh+59MrTwdZMwLA9VTkiFQdDTEiciRkgwEC/wSn+mFH3hXdD5W+QNO/Xbrgcv+AD5uEdJ206QF8Z92bGUiyhFGrj3hEDrNENs2v8wv6m3yzE99pdJRc3oJoKuIC24GF11QkYEn/8pNz7ZCHTM2Igf/O8Qew7EZOxQIz5Jj2BU42AlXsnhhptNYNTsYFiYYzEav1dGnO6+bTVsC68igxicrSLw7opQkeI37juksftFeN5ab0AxDnLYmTE3qnqKnQky3/FGBkrgLpHJrpUGA32BQiaVrOm7iVSCmZ92o7Fglm4eeB34IrX4apuAOkvtREjR0r4lAVND4so1gKFztBzYnI21yeun
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(396003)(346002)(36840700001)(46966006)(40470700004)(82310400005)(86362001)(31696002)(40460700003)(36860700001)(356005)(82740400003)(81166007)(5660300002)(478600001)(7416002)(2906002)(41300700001)(966005)(316002)(31686004)(8936002)(4326008)(70206006)(70586007)(8676002)(186003)(426003)(6916009)(47076005)(40480700001)(336012)(54906003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 14:35:47.1411
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb180cdc-9718-4ce8-7f1d-08da5e93a67b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5502
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Jul 2022 13:57:41 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.322 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.322-rc1.gz
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

Linux version:	4.9.322-rc1-gaf28a1763ea8
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
