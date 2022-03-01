Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7122A4C8784
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbiCAJOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 04:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiCAJOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:14:47 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7A95623C;
        Tue,  1 Mar 2022 01:14:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBH/9lfvu3lSTmZkfXKhcdRrrDmgMv5Jdvb4MThE75wgKh9YC2yr/XTK5CcjE0roHnPcSF+SctOlNq5VGVdFIhaGfDF9+n15CDYlkFoYOzu7aLlCx2h+Xw6tZBLYHbFjuHolvFxz3rSDqRCKIUjiMkHotl1By44iWflOD6zn/0a+iviaERooQKmbKGpEuJ9eelH0vtVsJlafQO8X/6iHNS/nPeGppt+IvGMBR+UfCgyBySGj/Wn56Igoz3PW0nI87Qf4Qdf92UiI8r3aGoTVTJt/SRWtyCY7yJRAr1ck46QE6Z6IRRVqlXjaRpn7VaD6CBBiw9AzasWwFWKUKVUioA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sjvkzwwtetg8Q5xeoeNOO9CYCjpjP+p+qgef0YadULk=;
 b=ly9BkrHqz+Fq8t0N+lONloA9dGAlvqNwi9NcqGKcvDgYZXAtd2JMVdefm7FU2oj0ij3cLej0N7jSxlZImvfZELlViOA1phdmxOV+eZnQqyOx3nQRwOk7WuNd535gxz5IKOgwYh9eIUhTEbAS8kz73VAY5zT62CNQ9d91qdUhRE1VLDIGm6+Glev71X5YRgZzf5VSbhick+Nv2G1seNjUKE1RsFJEtTBj6weuyG+NMeSoYYwH4Fn9G5mNeoVBIHDpcAp3+Fix4lhN5VMbv6KKiZfN5UA9E9QFbp/1iF1igojXtEyRsWwldPkFh4J1gSHrSSGzjmcz3SopwWdriaGV3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sjvkzwwtetg8Q5xeoeNOO9CYCjpjP+p+qgef0YadULk=;
 b=NmvGjEsxNdxAGudkQWurcu1MGwDqR3a+y27JA6+S5wkgSkl+u/CcJhfzRJLhXWGXZrFn2XsCV2EBFyr9ePLSUpysCet9XB0kwFz7DoSC3rfKEZkkoAMP9gwISmXiZ16nHd67nMLB7CeO19ARQy5ZfZ5sNnCmUfsjrZWZArEQ243u5CSlAXlDGEOBh4tedioI27VzVTbMQq4f86tPHV+x7pgQ1zUxrGlMZ2Fm42ak1WhEiLDT/qhY+vCpUIY9elXkuV7bCwUwW4ZVnMKrhxOtw4CdJPG+b5MduD57WCd7P3lith1FUos7RUUs5XG9XvjDU1D13PTeEz1FJyf49i1QvQ==
Received: from BN9PR03CA0932.namprd03.prod.outlook.com (2603:10b6:408:108::7)
 by BN9PR12MB5100.namprd12.prod.outlook.com (2603:10b6:408:119::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 09:14:01 +0000
Received: from BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::41) by BN9PR03CA0932.outlook.office365.com
 (2603:10b6:408:108::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Tue, 1 Mar 2022 09:14:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT003.mail.protection.outlook.com (10.13.177.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 09:14:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 09:13:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 1 Mar 2022
 01:13:47 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 1 Mar 2022 01:13:47 -0800
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
Subject: Re: [PATCH 4.9 00/29] 4.9.304-rc1 review
In-Reply-To: <20220228172141.744228435@linuxfoundation.org>
References: <20220228172141.744228435@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0ea9fe93-a4c4-464f-8b66-044443e7c7ed@rnnvmail201.nvidia.com>
Date:   Tue, 1 Mar 2022 01:13:47 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85a35807-3f8c-4118-3c04-08d9fb63d378
X-MS-TrafficTypeDiagnostic: BN9PR12MB5100:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5100DA682CE29D50C361062CD9029@BN9PR12MB5100.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W5dP1/KQ/Xggi4E/cYEoRFM12xws5km8xhkJhXJYQZLe/Me1UeQvO4yqHWxXUv55+/YUp20yhQYAg/jq9ubF1isdaIgGgbLNNgbT3FljdXsyZ/w+l50lCYdf1LMybmq6xJQGGYdY4yTSH4rEA2YAt9lHvw9v514/ojMNe0x8yvvaQ72qEQ3X9mpPVKjBBuEIS4jiHMmHVJqWZxOquTnewMyfELZUXD+cnRkZ+fErxqfbLzd3jLrLkbK/0BtcWpUSr3A7jsKkJlMEOBRCMUP/O2YALHjlyY3w/5/2MTehEEpHllSJ4otU6aOOEb9EZWh1Fg4rGqF0EZZbr6+pa4BdRPbQlOnUIpIHqyPlOTrrO37Np9Eedte/KDLke7oCiYlJUBoxUk8wrSdbo1ojZxNoj9zzESj4tTuSpeaFPB2OebpoE5VsAgTNG8BPWX3cokcw324YAEVe+gPJnskuyCJJK/LeW3cPyiXk5Ksck0ybGf135Zrfk/LJ6+zATAAWnDArbo4SgUr8jST/03tK3gjCNOm1ltUZly3CKT7ndIbQhZwbO7ZnBESmn7ee5dHp5sGDl3NEXXnMf83/Qw+ILa4yR9R91SiclMATneQFypDaZY98X/h6xMWSWAPMIfKbii64rZKijURjQ0t62IqK//MCpcioyqzQJ8j26FXegvZHv4iCEfKdBgg7WnjkLNZaFdaXwOnQft50J8VaAJk6l6DTZ4X0oNVwG6nvnnzct6l36jGP6/c2q1QJJBHRC0ZXQ1NK1Z1PqUzHK0Qp1hVgifRMr1SZxl8pvFsnDLVNavKSKv4=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(86362001)(426003)(70586007)(70206006)(40460700003)(8676002)(4326008)(31696002)(356005)(186003)(26005)(336012)(31686004)(2906002)(316002)(47076005)(54906003)(6916009)(8936002)(82310400004)(508600001)(5660300002)(36860700001)(81166007)(7416002)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 09:14:01.6123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a35807-3f8c-4118-3c04-08d9fb63d378
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5100
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Feb 2022 18:23:27 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.304 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.304-rc1.gz
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

Linux version:	4.9.304-rc1-g796b7c82bdd7
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
