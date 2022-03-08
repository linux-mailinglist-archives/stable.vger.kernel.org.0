Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A814D11F8
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 09:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344931AbiCHIT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 03:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344929AbiCHIT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 03:19:57 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06123EF21;
        Tue,  8 Mar 2022 00:18:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWqs9yhACrJ/7wBlJtuLxMiRsDlNvprPE6AstVVqB4lRZjkMu9VvEPULva0GkVSVgOPg6P1LSdzdyrlB52ta08Emt/Q/sZs0wq9ce9QolYjagDNyyLjgfVH1fRbgqkkX4P9y1fNMATjEjTjJmddqU+4VFUanxJXfRh/XHup7hzCmu5uBMDBlCZZSkWuXHveOIDKX1ejbJauiNcurxV4Gup/p20KDpYQMK8qBhZ8WpogHu6nEtyOeVsCKA+Ld0fcAil2wtaoXxNcWa8eNUzRwJCYZEsM+DW5412bP5meotvBKPRkhb+rf0M7mWLrPzfMdVLQwY+VKBJM96M3UsdZ1zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1S71vB3G4AuSuvbyV0T12yb2GSmb1AzCq8kh85CyNLw=;
 b=WU4Ei5tD0guLlX4O/lwM3/mEm8a086NhtpHsA/laNsFULaxYEP8HOLaoFa+5pcKqQdHvPm9vn++fPQYzx0G9YvKcAJy4HdtquvRdpANDDFfPenEhODCY16yKiRCMeNJjnfJtp6F6SBRYbbWptxpXzRZ5cMORCSsz8lvkjhcanIkMtMLvdWqyNMBFsLFHkEbDd4tpnzIoOo9tiVUoo602NoBn4Y7qG9YJZ9Fbjp34UR8i221PhmCE05uXmpX+DA2LuIb0g8GCHR+LPQrRZ0wQIe8lV3SL5q+0QxrP9LHgI2Z4J6O6zUZrNbFZacblurGUb/aYWIxipj8Ej2q4ThcA8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1S71vB3G4AuSuvbyV0T12yb2GSmb1AzCq8kh85CyNLw=;
 b=hXrn8hxeTmc+01Qdct/c6wLc/tgrIdwHUDdKv27OfwZrtoUqrT8vgzRJcJBLlBBdDy6yxZn5aqoykK5JrUd53y60t8EG5dnRKzpuYK/ND8gCMW5Mj86BNA+bJF5hz+iFYT5TeJVGkGds6WRaRa5o+epXQtUKns4nIDMs5w6E1LSzTrdyX85UXBv04z/wgqEf8UsiW6wckgHdGWl6xL4WMqdtj45PusxO/uOHO2m6GvOQrcUxOaxpjitUuyQtfMcP8wbmunEju85BUoc8RVh2Gzkiz7BxFXCUdH6vmArrOHABJHM2uXCpuleqylvTUrXkJI3Ugi3ZuuC6gV9qkxT3wQ==
Received: from MWHPR14CA0035.namprd14.prod.outlook.com (2603:10b6:300:12b::21)
 by DM6PR12MB3419.namprd12.prod.outlook.com (2603:10b6:5:3c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Tue, 8 Mar
 2022 08:18:58 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12b:cafe::74) by MWHPR14CA0035.outlook.office365.com
 (2603:10b6:300:12b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 08:18:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 08:18:58 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Mar
 2022 08:18:57 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Mar 2022
 00:18:56 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 8 Mar 2022 00:18:56 -0800
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
Subject: Re: [PATCH 5.10 000/104] 5.10.104-rc2 review
In-Reply-To: <20220307162142.066663718@linuxfoundation.org>
References: <20220307162142.066663718@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f8fa6104-b11a-444c-ba97-e951b03b4799@rnnvmail202.nvidia.com>
Date:   Tue, 8 Mar 2022 00:18:56 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9afd3e5-98f0-4a53-71c7-08da00dc4b55
X-MS-TrafficTypeDiagnostic: DM6PR12MB3419:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB34192CE6D8E18CCB7B961305D9099@DM6PR12MB3419.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sM7rxNnAZs1QWlXSctKndvx4CkEUepm++zV9nwe/haEnzuwMBU9cMgqif7vHj6nDMcD+ejauIz3S8SvyUDSMLZbaZFz43whd3cW/MAomMEkG35iQs3OaatKnQa53pCVCmOEa/TamAEBC3uQkAtsTDwTr/9jhjmIjBazUQgOlEozb5BhlBSqJWhH9T4b5B0SWtQOmP5Qqjk21LheILcNG1ykuscn0E9QSkgh+kCj3G9v8YIxoX5n10Fmwv1cWkRfkADPxSzgh4mzctnBCy6R1Fo715E4tJT7oRnJbqw0tmaVpIHODDuj0eaQDWppsrNHm18/U8NSaWQYzsDVQH5fw61Ol4dJ3WTqqLEJxfCsfd5tKXBj1+z075ehNElSIQcWLQDqL1eZ9dNYBWeXVnQySxzdUWvLov8BZB2PyYQvveJUH9h/kSyw2XiAOisZ9HIwowVjTqRcam7k0RtgDdkmNQzO10mo1KIKJ6paUPX0bDxXR1zvcXoYWIoeqL6vIfH2M9xXHqGV0BRXKLaKFrfdYuFRMchokWzvsUHObOMAxBCdG4QRRxER3qh2XV9YvGwyZXp8v/r4RikAaYOJzx7e5sr0HzakE2s+GH4F5lDDTzlF1v2alRuyAb2GXpnD0Y/qNH2pTb+ezGYQIwSrdlRetZr5oypAnx+UzFenvNkKnU0vQGrR8LWm/dQLDUKoMbfTtRfWoOTWWy4wzZxKoCqnj5iAy7pqOEMZ82ieM248oFAv5rymfsZ5MGp5k160oCmt4sef6FaF/yQNuSYtxO6kK8pj/fmBrbjVijOU9kWpgF6o=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(8936002)(966005)(47076005)(40460700003)(31686004)(316002)(54906003)(6916009)(508600001)(70586007)(86362001)(186003)(336012)(426003)(82310400004)(8676002)(31696002)(4326008)(70206006)(5660300002)(36860700001)(81166007)(7416002)(2906002)(356005)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 08:18:58.1948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9afd3e5-98f0-4a53-71c7-08da00dc4b55
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3419
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 07 Mar 2022 17:28:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.104 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 16:21:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.104-rc2.gz
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

Linux version:	5.10.104-rc2-g79bd6348914c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
