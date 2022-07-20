Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A2C57B31F
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 10:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239416AbiGTIlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 04:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiGTIlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 04:41:16 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F361664FE;
        Wed, 20 Jul 2022 01:41:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWUG1D2b6YHieNlg5Qf1aunnVdPKLRvPulJNSLjhtVmWZZ533ZEfTfNS/qHT698qWy4gSQ+aXlnfWyv9agPuXNztHg4ZmrkYGYMR5Etkn95UHUALdyy4j4e42+p3H19cQZpQ/Bl4l/L9f0pV+5vivXRI24utDw5WaIyR69kIG7r464LjACnicvTuCSG2a6V+NSAvj/VwgiAUncbDVrYZ/kdRZgJogAm5+JqVVA+6EmIpo9DUSr//V1TCxscRLBUfx/Uq81UB14LiTmvcjJGBa16f2hf1ZclI9N9NrBJAYD3Cs4DQ8hvdI0nW8/ptlhi3erOoHtTDihEPabEL/0m8yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VetD8u3ELnVroW++GasM1fmt8wWx73IEyXwNnOq2y/s=;
 b=T0xQgRTO2/Xe/gJqbVaEaB2dCvRhHzTstjGa4ewTNLcs1EnflOHsxc87FjBLJ43fksBUSfJUblq//5JPfR4gypsklvmO4wlzAJMhbd25MZzy7eEymLvcXU+vLc8tjr1/2EvvCAsiG3miAH1SVQzChepfHfjJ4+AjYuL5FBWFMlE+R6P/mXmen7v50F8CA0A2zhWh32N81eGZkSAHOrU+BkbFVJhmJ7VBPjIqfmHn3y/7cahGip7lswxYawcwjcDRbhXOdwvKnqmaSO0T70Nw3e6ILqMGRL5PVELIqmxapvG7nv6x7ri6/zHnp2yGj4xm3HMMqV5gbSPVMpS/ecSgjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VetD8u3ELnVroW++GasM1fmt8wWx73IEyXwNnOq2y/s=;
 b=k6Gdps/hu31Fiqp3ZEBKaom/c6bYsjBttEQLzo3PxSZO3Qx/gDuakNjByYu2X9fDk86Dct60uNR/J3TzEWITsuJ/mbcXybetRlGhioTzofWXGb5CEEj8Z8jNh1U9tYHnDXOxrrukU9QR3yoy6ijRozOgl8fEE3uudYXmOp7AnxSV4GfR3ElayW3Ivb1boO6WSLSJcojABCT8BSko9ouaI+8+aQgjh4AOqvEsIAbvfpgTewiwAqo8iT7WqlXgmO46Tu/VRRSK4Qgj4DsEp6TLliUmXM4riXoYNSXQd05cNiqqbQFgIEZ2HG1CRaQb1oJJp6hS3jwMdbElaDbI1QHxhA==
Received: from BN9PR03CA0789.namprd03.prod.outlook.com (2603:10b6:408:13f::14)
 by CY4PR1201MB0024.namprd12.prod.outlook.com (2603:10b6:910:1b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Wed, 20 Jul
 2022 08:41:14 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13f:cafe::bd) by BN9PR03CA0789.outlook.office365.com
 (2603:10b6:408:13f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.24 via Frontend
 Transport; Wed, 20 Jul 2022 08:41:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 08:41:13 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 20 Jul
 2022 08:40:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 20 Jul
 2022 01:40:14 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 20 Jul 2022 01:40:13 -0700
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
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <da295d74-e4e5-4f7a-88fc-e0f0f69a9d87@rnnvmail201.nvidia.com>
Date:   Wed, 20 Jul 2022 01:40:13 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04411266-e559-49c5-56c5-08da6a2b9ae0
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0024:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fqorScckA/cFBbc31jPygkrtkJIx0xKpzX/G7SR5VNeAeT6z3khhI2zcbqHrrUFf1MyWnw0YV7V7czhXBhdQIIZ+WBQYTPH0lrl2Grp/S376eruny9l1O4y0El3cQYq6BBuEe5uHEcYNkIXqjVbEynZWPQTa8r2exnPkteZmwJFwnsyl7dc8fwHDrwWLGbPkum/viRZeNAJKK9wNc9c6aeDBO6HTfYpmpYNk9X6l+fsv1fY6B0Y4AaCU2qtk7qESEfynsl3L5/PJVi3eyfS2p60Z895reqMT2SnMmSNR7t0SKvgu0O0lutPXxhjzTZUlgvB7qyN9RcuWpFEl9qhysISABiopvR8/jz9tpXT/XmevwYmXLtTub4f9rEiZz5QEXyKU9E1U4KCp/+Tyy3uLC/czqrkZYW5b/SvxRhht2Zxi+rehc96s4YqFXdo3uYX6AX2QLK+f8XGU8IokWGATcAIoZuUg0roJ/VvBR9o0mp7VxLPyRPlbHv06hGmghqMb7usl/P2WrmJBDAEEvYCZLNP/DRieifP5yZrE/PsiXCVEkZ2db5BzzXmwByzcMDLRX9K0KssgmfTiYzdylIJo1GrOCsKuKPzotA/zuWu0pSEhWdwwkDq5sTLGlyuDoL/ItttdQ9rESt9SlzHl0U6DqyugzPVCyS5cYMcjKWrxQlLj11dFYgKS8AqicHCk0HafxAEJv1nBjQejb1nTa0Dsl1HQkOBmZFKv4CGwfRjsc0qz9+37A4cHrrynogSH3+oy6kJvOfZ8WqRYqhlW4V8dAzbsPNj+SsPb/8+m+HG39CbJd5DJjPomBTz/kXAUNzDlyI6Bti3euUA1W2L2Oxan1HMU5Bg4GfytjNm3cxIm7R/1j8TvPttU6r/EaLc9sS4eQukCnh57wstk2BzeIq9tS0gf+Ym6+YJDTvxvRqca+yM=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(39860400002)(136003)(376002)(46966006)(36840700001)(40470700004)(26005)(54906003)(966005)(478600001)(86362001)(356005)(82740400003)(81166007)(31686004)(41300700001)(31696002)(426003)(186003)(316002)(6916009)(336012)(47076005)(40480700001)(40460700003)(70586007)(8936002)(7416002)(70206006)(8676002)(5660300002)(4326008)(82310400005)(2906002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 08:41:13.9159
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04411266-e559-49c5-56c5-08da6a2b9ae0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0024
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Jul 2022 13:51:25 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.13-rc1.gz
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
    120 tests:	120 pass, 0 fail

Linux version:	5.18.13-rc1-ga04b1a5cb7d2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
