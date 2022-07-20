Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5EA57B315
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 10:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbiGTIkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 04:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiGTIkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 04:40:01 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F314066B81;
        Wed, 20 Jul 2022 01:40:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=In23jF9/yKpYjVZq4L3mRVrB5wc2r/P8fPgARgXB89gUnDBxqBYm/j5Trrrfip+XIy2cvXKNgJV0ip5eTE3XiE+Bfh+VWInA4iwqolhr0F18HjD7lZRh/uITBpd6drAMW2m3WBeQXxw4UHVzZfi2w25YixBuVeCjtl8MEZsbFbSQIDCV9ts99Cu/SSYzJcVAyUJn65laxcGLskjGhD/lxisGlWYO6rjkUruaJJ1Syr98Yd5ib/JrUZhjg9Cj9BCfXtJQjpFy3A/LiUWgv3Olq/rgfvVgyAa2If2orRx4u+AG0P/e3SBxdwqeDtwbAOOQgb4r8b1tnaj5HfTiOT5xoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NWViGAH2ItiGNBnhfQa5HNZaySr7wl/xDsf9/xv+ZoQ=;
 b=bPypxWqxSjz0DgRIrk01CbFeLA++HCxaM7Q+fvRALmzS2EexgmKaFuL3w92ZmfCk20l/0Kih8mAEsb99xWQDGj/ynFukj9k/zvTLF0J5DanYMLGi/cygXroG0oUSE3nBPK8ys7kZdohW6IQwyY/mkr4SUguwl8gs0Pb7lf1WRmaR6q7aXIj/PbPk3mSi1BV7OSeGwyv2wONO+APfsCRidiqeO9xyOZUdcdluVoX8vr4Xh8BZawFyVTQmhbp0TfJqewbjr3QvPiLdHq0mZ/XCpKqzlRcD1HzQq4BBQ7gen93VickGvxst8s3nXrzc9vJXMOBbXSS4LdavaRNIyYsvKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NWViGAH2ItiGNBnhfQa5HNZaySr7wl/xDsf9/xv+ZoQ=;
 b=htKvTxs+N/+rRqqlqShrQII7x/d6AIBTMI2K6WzH6I6d/wQkHDS7cJI1lVpE6uIYfx+uXl7gxJRBxFNsogFm5cxbnWtM97zRfOpYZYpsIztj3auo7pZXTzZ8Bnq2TfhGsRibkje58kTmDWQJIDT5qLB9CTkds9WkCCzmc0IzIm7aiBeZh7zTG939mi+qpl+dPKLfoofn3g5qb+KO4GDStUhdUkwq5jFM3vagsqVT8ve/uoK9KWqxOcykKIIyB2hP8H72hGzPfd/RGFnzrGxCaQt0JgLwJWHE6BjYtZPv0xLWQx06vnWZM+2ifsUAjEGHVs/Ge7E8MlE7plBlV5vtqw==
Received: from BN9PR03CA0343.namprd03.prod.outlook.com (2603:10b6:408:f6::18)
 by SA0PR12MB4560.namprd12.prod.outlook.com (2603:10b6:806:97::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Wed, 20 Jul
 2022 08:39:59 +0000
Received: from BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::ac) by BN9PR03CA0343.outlook.office365.com
 (2603:10b6:408:f6::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18 via Frontend
 Transport; Wed, 20 Jul 2022 08:39:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT016.mail.protection.outlook.com (10.13.176.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 08:39:59 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 20 Jul 2022 08:39:58 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 20 Jul 2022 01:39:57 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 20 Jul 2022 01:39:57 -0700
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
Subject: Re: [PATCH 4.9 00/28] 4.9.324-rc1 review
In-Reply-To: <20220719114455.701304968@linuxfoundation.org>
References: <20220719114455.701304968@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e1753d65-de4b-4396-9c58-1f30008f8ee4@drhqmail203.nvidia.com>
Date:   Wed, 20 Jul 2022 01:39:57 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57f9cd61-9817-4b55-6706-08da6a2b6e73
X-MS-TrafficTypeDiagnostic: SA0PR12MB4560:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wnol8VE47B4t8TZSCUuQ4AHG+BQxt6p7Po33Ko720YjEg9BPE1AWj54RSwjO/sDvv1iWyhsgJuEtQkpo9nJF4q5N5cFIRS/NF8a2W4HGoyUfjRc5J8GrvdLjvwxqpAuaao4KuoOGZ1PdJIhDMvib9ruO24SXfDS44XufWs7w1MxFVteF5NeLZGMf1fYZrfln8HWyyNlQgv7+tyqxLDSNbP4tjfxrhMOFyFBNVw1hb2yr/j5TCvb3EktqEwWSL9gAxKHv0g9s60OiZNH5ZDepvX5ZZoQTWY4Rex/0ZmFqx0UCuy/xNrflPxAaXlte4Lvcf7ne6jVJq51RZqhwdppiDTSi4OlrVVIPSpXHNkWK8ABbHSYT/f1eh3tbr7p1mrPv1lZNNm4trCQ+1WwLHzADP6d2WpAx7Lr6SIxxTtCYvljJTOLHZbLhKwILcygmLB3hP2BuOJ/COvxIAiH0dHvjMIYJv/tjaAnErjRauZazwcc6v/iqHhKqbMkQwYK8QVc4pAXaHdt+1XMfdBBHLjjxxnOgvhmXvP/ybyylAoliZX8mgVqudsYlHjV5L1/TozoTp0yRuDb1sy2l3o6ree5hC+vcEHKcDBEBxQLB4o0wrTk+W7yHIrOoz3aZaJlW7jrdjvNmJpo3JWb/C41vRE8+GaKnVfXManc0SIoF5HcfULw7aDDWXJHxMEDlcC0xmGvQVdy6146xTKiO1ocRW+j3XaTQIFRIAPlNWGF0lBgNJZAEqg9gTuaynXpJtSQful3UUBW3XBzgXa5IIe+VzIr9ZuZVbW0Ri5qTosTUXDOTZ8ouJfGCjEqU2BTtrNMcHy7NKIqM/MWeX9UgnSHnrIYiStT25IiHQc/quZRBDE3UXmqB1ofmVJMXtTf9FWOZ7dtSaTtTZpaaQLaR1f0Ba4SkW2EMizlqSzFEcORt7fpeZ6c=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(136003)(39860400002)(40470700004)(46966006)(36840700001)(54906003)(478600001)(86362001)(31696002)(966005)(41300700001)(81166007)(31686004)(356005)(82740400003)(6916009)(316002)(426003)(336012)(26005)(47076005)(70586007)(8676002)(5660300002)(7416002)(8936002)(70206006)(40480700001)(36860700001)(82310400005)(2906002)(186003)(4326008)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 08:39:59.3822
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f9cd61-9817-4b55-6706-08da6a2b6e73
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4560
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Jul 2022 13:53:38 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.324 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.324-rc1.gz
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

Linux version:	4.9.324-rc1-gfc1589ab2391
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
