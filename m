Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF384BF7D1
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 13:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbiBVMIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 07:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiBVMIU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 07:08:20 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C698B2E2A;
        Tue, 22 Feb 2022 04:07:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZECHeHSk6vaHUsNxN9pR3i1WOrAFG2zZW7MFzT2796LezoJEcfblrDkjdsFppZWXo73toR5TQ2xF2HooWL5r58latRGYDURid2K6b9HRlCzVwHHPd8MkCnUAUjOnovZbLAa+Uh4EhPtI0TtUQjNX1vY2H0Ko/ONAnTQn2tKBEjZV++jsPwUJ+0SmpAtMoWPwmYok53wlsfm1PXcwH7eVZoK0EzgCmAt5GmtCsDt02at7xs6aI7mTIM6HhHcPf3GsCYHZOEF8pkYw9hOJ2a1OS/J+tsyFBBUuxlBLTh747joUL/TuqNDGAHcl3csPH1Z1GJPwfWh+I9JAoz2mn/sWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9eUr9YsIntYYV6UCAcXCCebb0j/mk8bGiibt9ZwSsa8=;
 b=QX3Di99BIuKWwOXGX+Znwv9J3EQXlv8vU6ZGO8uB+0f0mn5DgKAH5qddEobxVB5jTl4loqblsYAStPteB0iUmxTGhX4etHUoSkPFuENPMG25zQoPOu/cu8qveFWpVuVjD0nrRZBbFB6WwyIHQwa/N2SujEBO1kpJTOQW0aM+j444VLv8UlsUYIqZOnXtDWjm3uDxIA1Dl5z/hufYm/xMUgpPNaK7JMwY2D8X//9OqL+eVtUX5QRulBo4HMUfI43MNey3kq8w15o8WvURWS4Abj8w+yglI1zEXxQPvlcfeAbwhjHv4Z9AufO3Q7sKn11HBmtGkZq/qPsk9nWNfHydLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9eUr9YsIntYYV6UCAcXCCebb0j/mk8bGiibt9ZwSsa8=;
 b=a+Ukm93PBZ8A/w7pP5iTcLFik/Ibzy27YYJIcDydjIW+72S6OV8cqnNHBU0l4zx1VQ5zcFP4UF9Kh+P0GM/VF5iI6d3Mk2zl94DEyCYCbcXmT4jjuTonjJgOiOT4dP/dur6ZSHzR7S2YgFRVGbxNZ2P35YWfyYQuI7MrQ/gsUr3kEnUCECbCMqrqSMQ1+1Zv3iFuuWkVAVRB+HnaSb+HhIOtqOIjfTSKIv6pmxDv0EMdE5rTAJ+ZVBjUMW2dw2GO40Jyw3Dw5TxC50Etc1xuaR9PupwrVPZOufs4dISlkdaE71vddt2ChPZGKE8GdHdwWyaNrsy94GECGZqrOWS0Uw==
Received: from DM5PR06CA0037.namprd06.prod.outlook.com (2603:10b6:3:5d::23) by
 SN6PR12MB4672.namprd12.prod.outlook.com (2603:10b6:805:12::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.19; Tue, 22 Feb 2022 12:07:53 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:5d:cafe::f8) by DM5PR06CA0037.outlook.office365.com
 (2603:10b6:3:5d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Tue, 22 Feb 2022 12:07:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.20 via Frontend Transport; Tue, 22 Feb 2022 12:07:52 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 12:07:52 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 04:07:50 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 22 Feb 2022 04:07:50 -0800
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
Subject: Re: [PATCH 5.4 00/80] 5.4.181-rc1 review
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ab55323d-00b3-4f62-aae5-1503e4b6e037@rnnvmail202.nvidia.com>
Date:   Tue, 22 Feb 2022 04:07:50 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a8b6ee5-d21a-45c2-1b41-08d9f5fbf41f
X-MS-TrafficTypeDiagnostic: SN6PR12MB4672:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB4672CDB5745ADDCF2C78AE93D93B9@SN6PR12MB4672.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NfduVYkXkuC+PQ30y+qEiCIpFL/6rJlkdwpZGjNv3qiUo6CxxTi2aMqj1vL19Yu6HCA+Lp1TQx31TRy5hGDo1/kxpX3AK7beobmxqqMu7z+5KU880h7xRJb3gj+zoHPEiclknfa7OP+L5GSTg8I9dUKXFejcIZQZRCupOJ5yWKt6z5xUYSXo4eDynahHKthCUHyWSR+XFug7/wgx79ZztVIZjidOTE5QBI+Bg0BQ0yK1a90v4Nnr5UQjv5NxZ25h/mY13ecUIfXXaPjZdGrwDLQUfzOITtnWrJZikLJSpUXRwy+sISQ/q4fUspkTKbYhRHx6HNmdSzrEPWuSkHoxHR5TLxqI9oPSh2sfjo8/sVTuMpeGFaYw715B8jdNRFqaAUahQuNtr/oRbrXB9uYd8llv6jzoPZ4zsBPF99yySMDsNoRoHX518AshkHMG7tsPCcGUrw87o1DUInLxjJGfFhiYemHIjQGjz9xV+4U4RpTJAVZte5RRfgf4TWp/bvEaSBYd94K6fiNwDXJgMtn43/WgYIzqPmRxIsBhePJrBVlPaOaKKjeDjv8nPpmHeagfp0NM/yJE1jm9U4RDHEWjfilfnN5vt3s1F7gnzb3GcbiSmMKvTTyA40QEwScB0Nuv7aMLzAjzMR99soiwPhJx1TYeYP++PYlF1y73TZYa0F9d4UdJNbeuzhicEuCeMo64P8qDKWYjcFLEX7wXvO3MlYdBu6TC7SsEOvup+AgUXhAZJMGSxvc6EzZVIetPSsJqez9gBPoSz0KscyVzSMl1TAaH/QXCi9KJ2Vw8CsYrZlA=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(336012)(426003)(2906002)(7416002)(40460700003)(6916009)(54906003)(36860700001)(31686004)(8936002)(47076005)(5660300002)(70206006)(70586007)(82310400004)(356005)(966005)(81166007)(8676002)(4326008)(26005)(31696002)(316002)(86362001)(186003)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 12:07:52.9661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a8b6ee5-d21a-45c2-1b41-08d9f5fbf41f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4672
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Feb 2022 09:48:40 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.181 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.181-rc1.gz
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

Linux version:	5.4.181-rc1-g04ffc48b9c61
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
