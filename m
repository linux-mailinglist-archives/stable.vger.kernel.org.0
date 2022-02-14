Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A038E4B5328
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 15:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355079AbiBNOWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 09:22:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355076AbiBNOWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 09:22:16 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C424A18D;
        Mon, 14 Feb 2022 06:22:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVWtAYki/Ucm/dQq2TRNyggAlfCPWwi1vhqGSNlRTsl9IMIr9ZygwX03qvfSzh0j44oTdDTJC9GTzy7vWbXsdpskzjVRU+s47KJ8+RZE8f6Llkak7tTTag0SVKjxu8MVyrsL4xWBTFLV1l8/hPdmf2Cu3TXuVOfdaVZuTWG4E/pud7t2hlqt2lI7cBBAVD17UWHEa2vKK5CAbyS5rL0X0DmBbo46wTKspVg2r1hAZVkb/nllxYomdYQ5hCc61rnRCIEPv+JX1PvrSu7li+n+03UikdpJwzReioEHwLhVw4Jrtw8ISR6ioX9HaDCU5DkRUHrOXMbNH6ExnJ/Ams/PhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQsZw6pabJOVOFW16RFPL3UZUs38V128+Hjz7l4z8h0=;
 b=j9YrW7Jl31uySz179ljKel11Yewc1aCgLpu1zI0jhLGQqhck4rcGvG4I/qfq9Orh4pfzUkHSgFIauji2ulbD6T0oC/YF4Zx2OWDbt0Pu25AyZD2tgfnWHLL3EMuTSNMwUMcNx6rPB//EoRm1wo2PG30TiLNWVCZw2PZYTFGU4LQx7pAijbwOAb8SAkCo0Rp/kKBE90kuJGOY08HzA8olwC5mNHyC4bZV+LgrOszpu7qK+yFM1hCLyhVyWZHmXDL2yrKYVfYoR4AMBv15srn/oVPEQNbbK/HSImSTeE+nPhfCeMfaaHiGj6Ofd5YXmsyrJV6QuMgT+zzEi6c9ufxB0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQsZw6pabJOVOFW16RFPL3UZUs38V128+Hjz7l4z8h0=;
 b=Pm4lLXP7pZLR8QMSgQx2JEg3tUskpr4EVbLz+bH/MrkPGG85NpzwtaqoTX0pGZzMv7XnaZ9inAzGFINzNcel8gxujFlFzulGvAXS2CKa49vtZXziJrGm6cGm+hgEKvxzgs7ymM8WxtcMYA9zhnWVSv9V8xlS+P7eNwdMquov/42JFufvDRNFGVfYXDBBxIrTgUGlBZBGf/Q67CIqZdB1Ntsb9Lpg3+NB9LxaoqL5cFxET4e4jBfbCI7Mv631BybijWU/w5YOL+FfcSkerjbzQpyVCQp0axmxg91eLw3lNKPrFp4vRpTjWFt5Fo1u/2ZMG2Osetu5EDJV0ACnAgrLqg==
Received: from DS7PR05CA0099.namprd05.prod.outlook.com (2603:10b6:8:56::20) by
 DS7PR12MB5887.namprd12.prod.outlook.com (2603:10b6:8:7a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.11; Mon, 14 Feb 2022 14:22:07 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:56:cafe::88) by DS7PR05CA0099.outlook.office365.com
 (2603:10b6:8:56::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.6 via Frontend
 Transport; Mon, 14 Feb 2022 14:22:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 14:22:06 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 14:22:06 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 14 Feb 2022
 06:22:06 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Mon, 14 Feb 2022 06:22:06 -0800
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
Subject: Re: [PATCH 5.4 00/71] 5.4.180-rc1 review
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a51795ad-f77b-44ff-bf97-d503bd54cd92@rnnvmail202.nvidia.com>
Date:   Mon, 14 Feb 2022 06:22:06 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d712801-9a2a-4c9e-3073-08d9efc56165
X-MS-TrafficTypeDiagnostic: DS7PR12MB5887:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB58875B5BCF01690D7D25A7ABD9339@DS7PR12MB5887.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hhYvFvi0zfqYk18MCjgta6gTNg+N2kYrE/jgbiz9y5UuDF2Yg7v0ZmU+sbdd4PDb+bqZXkHMRxGooVcHUJ8SXeFbsEFOlzc/f2Clxmtr32pplMA85RLIKHxcFrhy2ZibJZGGO7wMYSKCZ/MyxA5WdYjxCaGWt4G+vl5czPy8KiA62k1KHjpp3jPQRbf3V+V1from+eg9jW9d6RzIpinn8ML3awsEsbImarazw/97D31gzZAx0Wvxql5dyFI6mmBmMGYD/GtBFk3VOmZVFZyXTN7WzvWdYshNqSZ6Okoj2c451HbjC7hxkw7//kD9m57ycsDfU9cy3AgseTO0WpF1Jo4qfTa1Ic+gA955ZBvgE8rBC8Zx8ru6jQLdwCP3iKJMnw23x3y8aQKIgKwtlb3zX+Ek/uS4mU5DD0kU8fABmcEyh+Wa2YjO97S7nMEnjb2TkTPx6EnO9aWrIgjj0HFex2lgaWATxiXcdrODxpGJWJuwIdibAanQQ/q9E+OlEEFk1VOZjW1bzwQBnLC1PFj1XRR9HHpoNZxE9gBK2xdX8/+g22g3pWcNyc2AeBy+w0O5QEKZCTY4q5U5ZILfv501bmCloSda3UXBkB99U6VWIT4f4+fjMth10wd5XmPCCyhwKT1Id7U7Dr8lMe5DLu8I0X3aO97FBv6U/rKAAN1HH0UMGqBDB6MGtBxWDISqu5c2ZpF4vmKkHzyfgVL7lNQ1ZhSKZNZOu+8V9X9wQVfO+wYJHCd1lXPwuBVDN5ptdtYInErYC+vDdDJUFC44GIE3A6Nh5gPbPNB2AVxW8fDcNGE=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(186003)(356005)(47076005)(81166007)(426003)(86362001)(508600001)(31696002)(82310400004)(8936002)(26005)(70586007)(8676002)(336012)(70206006)(4326008)(54906003)(7416002)(40460700003)(31686004)(966005)(316002)(5660300002)(36860700001)(2906002)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 14:22:06.9221
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d712801-9a2a-4c9e-3073-08d9efc56165
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5887
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Feb 2022 10:25:28 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.180 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.180-rc1.gz
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

Linux version:	5.4.180-rc1-g9a94c73110a5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
