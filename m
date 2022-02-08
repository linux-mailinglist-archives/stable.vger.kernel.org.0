Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D0F4AD36E
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 09:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349745AbiBHIbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 03:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349663AbiBHIbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 03:31:42 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A476C03FEC0;
        Tue,  8 Feb 2022 00:31:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7EttpPvubhUGnr46rA3AFnJ6EfLOHX4hFZKcqhSwg3G0fVJIfRk2LOzIgYAVmNmUoZ6VJx8LFvwwVHckrkWaVR/XHi09aceKQqZ+HwnYzsD6tzQuLE3O+Cv5c1ehUSZ+NZI6Bv/BaMCCATXx7IlKzc1nRqxQoAnwXMq9x3vu/f7CZxtU1XTWSURRcMB4S094J3cEPbgPpCJ82TEXVSZddwc3x6/hyOjgEmR/fFaDSurRFSHW0SMz+6kaqM0o+GKnxABYXTQRvpBj4znPZeyX59A/o3sBpA7VMxm1LGdbqD25P0XNgebrX3ghCa0sy2PWJZc2Mkmd6T5p3TcOk+X8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=srwmi31XThHQZ+RG9RGWD+ghJnw6vfOY81e0CWAB6KI=;
 b=CJlLdhouY9A0ELEN2P3xVMi/a1ovc7wVNpk4CtckWAnM2Rp3Y7UhQ8cdljX8LpBtn3uRmIc6Z6TirDkZfDtfqYms10HQoxjYR8busUnZ2TJOQPRDKJBQX+amkDQ5zUXz3E8Sa211OGGkERWm0YZTEW9ncKJyaJ3EwAWRZ2M0sWneBFSDS91MNrmC83JFYNIzRULbLIR7qrm32buv505M1ehE/R029nFQgIHF2JwAwRhIA8ChIOZQHNcrMOnsjklvkxxzXIr2Ijo9HKYydoHmDc1iEisNsli+oq2clrgW1OxNp5HoMkuC0bU2ym3V4EDQyYqqjQWAoI0512L+iqSDWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srwmi31XThHQZ+RG9RGWD+ghJnw6vfOY81e0CWAB6KI=;
 b=nGAiF/tJgWZD9bTJQ4l414fpqXSaTV8S52gWn7sSMJbi3/HGqurgJGBYSb0Pm+7FcMt/epcDLuWv8aESk6Ji3/KIE6f9gAP3YSVaeBnsDTWsfCQdvTpiyAiwlCnkPYUHJSyunww906IyFyA65Yzr13LWAwDTmY5P0rUgmSYgdnNRJp/HleMxjupRa/+YW0wug1Fd7B5opYDyq+8mjxoMeIw5fowNAV85DJuCRej7KVE/Q2meVloSGvcM8IadJ1wTkFYMsXdAy5pd8KalP2X0EwNBwqXU7k9n+GrXhpRm70rtc0c/uGyjdA+xH1rAAdX1gTRSHe7UL8DVGNZ5InT8Nw==
Received: from MWHPR18CA0042.namprd18.prod.outlook.com (2603:10b6:320:31::28)
 by BN6PR12MB1267.namprd12.prod.outlook.com (2603:10b6:404:17::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 08:31:40 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:31:cafe::86) by MWHPR18CA0042.outlook.office365.com
 (2603:10b6:320:31::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Tue, 8 Feb 2022 08:31:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Tue, 8 Feb 2022 08:31:39 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Feb
 2022 08:31:39 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Feb 2022
 00:31:38 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 8 Feb 2022 00:31:38 -0800
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
Subject: Re: [PATCH 5.16 000/127] 5.16.8-rc2 review
In-Reply-To: <20220207133856.644483064@linuxfoundation.org>
References: <20220207133856.644483064@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e2e79eff-2e9b-4d9a-b487-45ec167e6924@rnnvmail203.nvidia.com>
Date:   Tue, 8 Feb 2022 00:31:38 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 655459d8-a029-4d51-0a6f-08d9eadd6dbe
X-MS-TrafficTypeDiagnostic: BN6PR12MB1267:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1267CAE2FC95DCEE710DBFE7D92D9@BN6PR12MB1267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FrPJtFBA9bZEhKCTflQejC2qLJTIwVyp3tAhW7mD5Rh5fH0ox7tr02Rh+Zacoz9FEkCe8LEDpkIc8wbbkrrhGVGxDKF//rcWoWm8Lu+V3C3ZRGdZEU0WvznbDU/P9fTrOWZJzWpMo0ZRoD5JLlPbFkBOlNQ86xfg9o6dothWaGx4KTn2Wkm2n8msH516wtKNyYWUllGXPyCAg0k8rdE1xcJufpTSyddjEeihMUpOf7seMqFyHREj6LtDesVqIubqwGHlTeE/KQnjY/ferrDfgPrxGSzaLy9VmFV8W8MlhYYYjMUQmbKirORqxjJT6qCQsthMow8bkIO0EN1MVQVbzytxgWxrXp0Rn/ak8u/a1UiEMhV5v0/9F3VVGtu6hai9rOeivUpTi1Cr4Q/ZJpngalxmhEbV8rzqcClFEi6oHoRPM7UfOhvA94vHDJAqDrJvKphEi6FkJn3jp3bhNK/eI+tx6jcDGp+Mr6c9USV9faP17phckEP7kR+ByK/Ofi+cIb1HxAPinQL/i7fuQBQJL9v1v3khLeqBJVK2E+44VWfXy5rFk8NwfImw6BTw+7WypkyXio6n2ymaYyB1UijEozxKksqJakuHSKhCo/lPXP7kgHZoSqLq2+VWDdvY1A/Zra5Gokg6aXqqlwK4qMSHacEqTKzK1GtIdZb+nV8aeCfK3WXxBbyoEE+wu1Ejvtm79/bzBYPui+02dgUi6fE1vBnekC858oAarAbzGg1ZbLvnxwHEcaLSdsWY6dP187p7s8+fFUsXRlNRf9PE0mort4eX0oJLqItsvcnRYOu7WYU=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(8936002)(31686004)(8676002)(70586007)(54906003)(316002)(6916009)(508600001)(86362001)(4326008)(70206006)(5660300002)(966005)(7416002)(2906002)(356005)(426003)(31696002)(186003)(26005)(40460700003)(47076005)(81166007)(82310400004)(36860700001)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 08:31:39.8385
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 655459d8-a029-4d51-0a6f-08d9eadd6dbe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1267
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 07 Feb 2022 15:04:44 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.8 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 13:38:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	5.16.8-rc2-g87d888a197db
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
