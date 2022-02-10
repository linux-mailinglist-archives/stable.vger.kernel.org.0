Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CF14B0867
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 09:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbiBJIdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 03:33:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237561AbiBJIdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 03:33:38 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB36D8A;
        Thu, 10 Feb 2022 00:33:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ey/XsUUF3L4yi43CFrPdSYorllw3wWEOkOF/6rbzqDbnrLAvrBgnDICNDdj4abjDIgfBBZbWri2qFhTF8IY8+6m700zXjx8xgA2sLvTQt3N2eBg4OaTqjBBRVbrLGNaQfMcwqTGAEp5H/YE1ToGyOvVj8ITMxilw13SPtFRPQMe071N2fD44vjsVnNDhHj6lrVxDhGzXWUEzKcU/uEx3GzBggLFagAahE8m9xsyvym95dAaedjl9klQBvy8T5acXmayBnMNHFhYyVxjuAb97VZfFoYvLSYpxvCPVQVIlHKyg+vwN6W/fxDEA8ttLtD+vMToZNt9AznzQZbXnoEQafQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0LEpGzHqWd1h4AtFximdBhY6B1eWS5Xo4SHMmgltS3g=;
 b=SioCQ6yvJWiUi2arMbKGwEo/Iri53oe/xl537kzlR/fnB/6H+x6/vInYQjiizKuDSK1muaDZJD8oA4RTHdvyvcnvzaSV700A+0pmimw7m3fiW52a2H1Zly/qEHavtsoj8PaBYfEEMh0fmKty5473ppSElf+g4hmckLzzh7h2AnAZ6fjDjJVypFOgSmmh7dhLvTViMusWsn2A2Azw7MiiMvEsSseh1SEtkaEoNKSo34ccAQ3ZlCH0RBXqK9QB32FR6XsRG5Z3hezQCc3ZgyYNVsA/jbAtzsb/h12xTkYTPC0ioFYd/DZzcR2MNAF0UiyANzH1ArzV1NB1962Mf6McNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LEpGzHqWd1h4AtFximdBhY6B1eWS5Xo4SHMmgltS3g=;
 b=s4f344a3lkHF8UvwhA54JTl9xJYRbltwTk/qcNNRgHbTWXQJj4h2NkT2ChrfSrAjAk45awTBtlH4f3QIwfuvR3S6MOgof+ZV32LvzWw6EEExClFwEUw/vzNvZr74gkQwR8Aq5+9RlQT/5UH33ot9fraAEkBLfzY8RAiodeoTrIpSv+8FPPj8gfjjgSMDe0Ot+QogbwiqNLvtcuFfElGCiuzUbgqVyZL9ByC3C8XPWinSGnUPTRmpwrMcp6WIvTiv7J564ZAVDHUjwHQoUX27bHTvULwFXkCwEP7Kq3Ze/NfriUDINCCsa01IsU2aWzMRg0yZBkXkSZxvN9uGgGzfLA==
Received: from DM5PR1401CA0010.namprd14.prod.outlook.com (2603:10b6:4:4a::20)
 by MN2PR12MB3759.namprd12.prod.outlook.com (2603:10b6:208:163::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 08:33:37 +0000
Received: from DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4a:cafe::55) by DM5PR1401CA0010.outlook.office365.com
 (2603:10b6:4:4a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12 via Frontend
 Transport; Thu, 10 Feb 2022 08:33:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT032.mail.protection.outlook.com (10.13.173.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 08:33:36 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 08:33:36 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 10 Feb 2022
 00:33:35 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Thu, 10 Feb 2022 00:33:35 -0800
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
Subject: Re: [PATCH 5.4 0/1] 5.4.179-rc1 review
In-Reply-To: <20220209191248.688351316@linuxfoundation.org>
References: <20220209191248.688351316@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <cefd8d97-5807-4f8c-bdeb-5c10f347f082@rnnvmail202.nvidia.com>
Date:   Thu, 10 Feb 2022 00:33:35 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f221fd1b-f767-4f2d-2c77-08d9ec700828
X-MS-TrafficTypeDiagnostic: MN2PR12MB3759:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3759C1BDD176F9A32344C6CDD92F9@MN2PR12MB3759.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cXFPuheGrXfoIW/zwKvXDNStEkmVKHOsnR17+gEv2N+x+4oKjowL2tbe4suIQtbnuy0/qHEdzQTeIcqsA0jdB3ZJZCYMcse7WPb1WaWL71zPEg5UlXvx8Xd0igW6xs25FgAx6dFimP9rqQJCHeLiDF8RTdld7gR5JOtWm2crefgDrXJZlC/n5ii5XRN5IQBSkXe8buWJTZN8u/SnLQITptydxVGUZSDz74nVoanJkDA10C4zg0BAVQIqkqAr9hReZ8EZ/W58uBNEYBnVFueAGKQ59uyUJTUxdmoKF25ujmEVlGNgIxm7cCgkqpbPaWJttmlVxvf7sqq2ZCB0X0hgd5twfXQukqHGzJoxIDXbmM6NvTLoMWC30I5p10h5jraqvI20WMy4NInRu7iHcezL4QQEQ1YNi4nHlCUz1elWq9FyOuQvWFuDcObbk18i18o0TipP36V1UXJ4uwcxPZDxoadAm2evVt2FSKZ2y2u4g3Fq2N0ZpccUGQdQwvwHHhspVdaS/LwVLWAPDto2wNJ74rNzKTpiN1IrFbStVPok9avXbQQEYGfEg/E7qALGEOD2DDcxR9k1nW+VUkUWCn1sUR+lnYJHDlg9bCxeBdwqW05rTJXj5fSMvRbMdNNyIXQdr2dG1Pp44PI7Ci+bg08vlYGhSGg5mJfxdnI2Cv8NCeaim1krlHosRP1S8mNil31kCQp3Q5zf0ZCmjcEExa+EHPrq4Bpta9y2YDYHnwFcPcx8ssZ0XkTCkvbg7NpJFWgTfxHQaMxT4YNOJV/Gklz1gPn47Pi5RQsYo82F2aiOx2o=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(186003)(54906003)(70586007)(31686004)(316002)(26005)(70206006)(6916009)(81166007)(336012)(356005)(47076005)(8936002)(508600001)(86362001)(966005)(40460700003)(4326008)(36860700001)(8676002)(82310400004)(5660300002)(426003)(7416002)(2906002)(31696002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 08:33:36.5728
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f221fd1b-f767-4f2d-2c77-08d9ec700828
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3759
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 09 Feb 2022 20:14:09 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.179 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.179-rc1.gz
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

Linux version:	5.4.179-rc1-g3eacd9fd7c98
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
