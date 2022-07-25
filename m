Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5973E57FAEF
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 10:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiGYIIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 04:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiGYIIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 04:08:22 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DAF13CF1;
        Mon, 25 Jul 2022 01:08:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kbt+T32MMC40ZITfnrnSKKrwIf5dWSsM2kD5dHiw6N4GfNmv49IQf3TdzfGe+0R3RSvXGVa5pmfTErIokXTX/Nh7h6g48swp3Smu/7PFz8JLkLc52fa8oPQ2iccZGgszZmw/y7fTbyYom+LtqED1CnBWES6kcinbVc28dMU5Z9xzLS2U9atHp+LxiZ+ffzvi/xhQPCixVzbIMS5HCkdwNkX4KPDmcsPA8MPRuGdY8TEjG3UYac7AYoAGqTgFGMsY4ams6oxtf+++D2SNjQ/HKBFUjdt1B5WgsgQ+2KJSeu7Pxe/jRIwyWc+icmYe0LTPogVd0tGH4DxyAtquc6+yIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqE7q124h6rC7g38JMDm1RFCMywI7U1RQ5sqfAZx8tY=;
 b=ZRn8JhqXIAx7d1qoBrAVOxf5sh+DGDq5+cUzgMNZsKadCa+KigQVlJviuzuj1pgc16pNBK3innZVTSKvN7qPgSABCj9CnOvLDSwqoEaqXV22L4mdowcwg4hCRZCoM1zSXRw2fc8g3KsU1+NwvN0PQqqqpg0pJPwyPP1BQ6aA0IU8UQDfGpY85rzmuEXdTY3EzSrSVPOIW1Npa6w0UDnCi+lly3B+XZJ9/HRbbtZUyRCsMiY0fBPll6lKmDve1ZckpURTR6SmdywkWDZCt5uoQbUbgAHyphSb5gMK4h5RdTCgBFHCdm6Ig6TuwthBokHdFPZ7hXiH4GYMmAwlJGrsAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqE7q124h6rC7g38JMDm1RFCMywI7U1RQ5sqfAZx8tY=;
 b=BvNJPnGfQYHNgN2m4QUlCKWKbgHXgvWdPJq5wYq1obKEZHyOxsSHlP2sm3xvEPcLxfBhFXbwr/k+nDqsVtuFB5LerL4PluOmuCtfKS9AK/5r83g6xCLPW6Bi/ClJOUtrMCmK+Ak4I+U+TDhcmMBrOWshG0GS8VKo7YaNnWTu0cXNLzdqciWI+A1wnI685qTCJnIw2b79hHBjRPcKpF3b/+kVXR93JGhUkD1cikojRltsZmcZ+ZJFl4UStafpibBXB0FsFyYacaWzynqixkZVp0FWp3YyK1LwIu2uA6yoref6qe3lNjsa7t8NRYOqDFvBnJy5yYX5Cv1RGtRGsuA6gA==
Received: from BN9PR03CA0747.namprd03.prod.outlook.com (2603:10b6:408:110::32)
 by CY5PR12MB6057.namprd12.prod.outlook.com (2603:10b6:930:2e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 08:08:19 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::c6) by BN9PR03CA0747.outlook.office365.com
 (2603:10b6:408:110::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Mon, 25 Jul 2022 08:08:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Mon, 25 Jul 2022 08:08:19 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 25 Jul 2022 08:08:18 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 25 Jul 2022 01:08:18 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Mon, 25 Jul 2022 01:08:18 -0700
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
Subject: Re: [PATCH 5.18 00/70] 5.18.14-rc1 review
In-Reply-To: <20220722090650.665513668@linuxfoundation.org>
References: <20220722090650.665513668@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d9943f2a-e207-4f18-8898-2ca2f6dca040@drhqmail201.nvidia.com>
Date:   Mon, 25 Jul 2022 01:08:18 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59992422-827d-471e-2212-08da6e14d60a
X-MS-TrafficTypeDiagnostic: CY5PR12MB6057:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OgfhP6HVsumCy9FmrH+GfRq0ZrzaTdC8/W50UDEpD7qzX11yS5HqyVbTC75W/nW03d66kpi+3Rv0uI5ZOnzGxIxf5Cl4sFiw9hosS8O0kpsMlrhz7z3Zc5BXza2xW0bUA5sCELjh8QLvnCzV4kUvwn68y6xUSTS7Xcxg2PChIZbrMPg1dPhhRP+qHLqgOR4hjh6mw3eItCrKix0YFveT3oaRB/Tz8Sny8XBG64HjeFZv+c9atsycOQf1lYBM2MYNXMrgUQ6P1fL4QLRWWcqi52AFy5ofN4wA31tS6evwaKv0bG/k/w85laLxjCVjZBItvevaUzHNj0JGcLms8kmEcGWyW3N1Ix4QwWhBpBuO4oKyfBKx11/lULYi2wnXv04DgwW9KO+5PT2xkbQ0nqu/VvsjP6WLlw5adtUMqosMjl00cqrrodxvzWSQDFwKmXoOf19NqCZQ/h/iSq5htYUP2Bob4FNmA/bAF3tkbBaTqbSwZx8RvcmtHMVHcflpUzq0oM5zi38xAwuu7ZaT5TQLbL4G4YH8f03DIyWUze77ty2uS7tEqB2fpNKnM+R/S8n8xmHJ3b5YRzy7eP448apvBtE1X/UkJyFYXvNCXsJfQLiAcS7pFuen7bXXn/x2f0RiS9ObrMoXrmz+wnERwRDUOpOoMkb/91/BSBPF10xSTraNrF/SLhd1h76eh1IzNcsq7ZwcP1f74WpFetp0iJ8SD6sC9weLiFMSEGtbJSnVA/OzcY5hoO1FtMF2PaBLiK1qVfUpCnLEMW+SVmSzyB7BaY6RyhAvAe61mB78IdmyUaJ1Acle2A3MSGlhkH3Qa/zvx5STQvkPaUVdkAYEdimEVeadvvgVs8889BH+OjUkPjJwjoEfZkYL0B+SENDdPXKWf9j80PdJXFXibsC+kimxgz43IqJs1fS62UIqdHOic+8=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(39860400002)(346002)(46966006)(36840700001)(40470700004)(36860700001)(356005)(86362001)(31696002)(82740400003)(26005)(8936002)(336012)(47076005)(426003)(81166007)(31686004)(966005)(478600001)(54906003)(6916009)(41300700001)(316002)(40460700003)(82310400005)(70206006)(186003)(4326008)(5660300002)(8676002)(7416002)(70586007)(2906002)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 08:08:19.4173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59992422-827d-471e-2212-08da6e14d60a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6057
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Jul 2022 11:06:55 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.14 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jul 2022 09:06:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	5.18.14-rc1-g4142b06492bc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
