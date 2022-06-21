Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CB3552F41
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 11:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345246AbiFUJ5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 05:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244107AbiFUJ5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 05:57:43 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2058.outbound.protection.outlook.com [40.107.95.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A795E27CFD;
        Tue, 21 Jun 2022 02:57:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vbi8AI+n0rj10Gai5h4gd/+vI9yuYVpq1+aVyXCrl+6WveFe5lY6cgbGUP8ls3a+PV2tyDrSvRwEoU7GORNIBHJKitIHyOK1+CAFVLu4jY54j35jq8Pp/1leh3gsZPLArQrk0XkgO/8AX7XjonX6khxLEnyfHoS7XDDGrcilQghTi/KhMno7JAzBCodrCeNPaekerxSiTR2Oed1cjnVNEK9r4VU9/1zlZs8MCv7tRZuLoFzc21k9CBDyleTr7Awfuui7omUsXGgebcuLrh+nbNeRDtNfqqFmrgPvha9++iWSdgUMkbaN//UJ5ttVnuvikUFuIDzkgjXV9XvnHLgG4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eMhNj97HwUOVn+CCPX5qJJDf56q1miUQWlZi09p3mao=;
 b=jmqdMfssjw4tsFnLIjC7fgN6eesIxQMsfHRdPL56WYHpnFA0A9Ov6x3EcTDYNpYnLTZn5WIUn6D9/Ja4cJu1YYvOyvA6yTKSyBHwOp/syk5PBs8THHCJ1pIY/weLKaptoMbyPZAhZ9+lW2Xn+fS1IH77S/D8U/zMQmYctEYo+q473TEqmlz2hiG5Y6Onclrin/1cXuFrpogbHIyPA6j8eaCWdXfz/RAKvjxgERPFejQnESMIHRBBAOuMg/79J6Ni2Q5S1NVTmrSyh61WDU47ciqkBzPR/5fDvmpVSU9LORFdWtpd9dQ0SGuTv/35VK/sLkiTCB0j9MYEw8D/ZpEQ5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMhNj97HwUOVn+CCPX5qJJDf56q1miUQWlZi09p3mao=;
 b=Ku6denkRq2kHaQOksBef8Rhmfko16h4hFJbwKJSijY8cp3IzSdC9q1t7sCK5YXvHjCgBA6FPHi1lVBpkRmn8nXDUUgl3RbkUteJ2E4maBSnNQeKBvrqwrBUknFMNMSn5DLyW8i6+72unkCCZnm3UrFKYOQDa+v8za+3D3IIiDDnFgBdbU+oO0V752+5ZLnDsbdt0FLJbeZBIFMA0sJaw5MwQKt5Esv5yuIY6BXQ/NI/WATiDzqxPlhmUO1B9wxJrWvoVkNTaWcgAbUdHxl80/KQ+iRCu6rZd+2trMobe4Peq/30VXsj4DKdlwtk6vVmog5NzgxvL6coiOn7+sUwPGg==
Received: from MW4PR03CA0203.namprd03.prod.outlook.com (2603:10b6:303:b8::28)
 by MWHPR12MB1869.namprd12.prod.outlook.com (2603:10b6:300:111::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Tue, 21 Jun
 2022 09:57:41 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::db) by MW4PR03CA0203.outlook.office365.com
 (2603:10b6:303:b8::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16 via Frontend
 Transport; Tue, 21 Jun 2022 09:57:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Tue, 21 Jun 2022 09:57:40 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 21 Jun
 2022 09:57:40 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 21 Jun
 2022 02:57:39 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 21 Jun 2022 02:57:39 -0700
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
Subject: Re: [PATCH 5.18 000/141] 5.18.6-rc1 review
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e2392994-f391-4e39-8c21-a3de8d2aec51@rnnvmail204.nvidia.com>
Date:   Tue, 21 Jun 2022 02:57:39 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f52b256-1dbb-4868-8243-08da536c7ac3
X-MS-TrafficTypeDiagnostic: MWHPR12MB1869:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB18690D13FEEDA5FCF3A0BEBED9B39@MWHPR12MB1869.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o50axaLr7Erfmz6zFRLg6jUV8/nZ8L2l7pGcvaZUZdz8BLm9BdTUasi6kxoEaMl1di2tcCEizWggVMsekhktwaw0x35ONxzhIPUE76Zh6MTYKzH5r4mz5ogFT1fwt2RySf0i4BmtkckCGK4GrNBhe2QAJncehHmgNo/DoNy35cN9RDXhwQtmq/G32nH+qhHYgqrG5zYQ0SMHk+bg0H1TnNEl21p4To+Pwm4Y7cIV/P4+ELcXUcpW1kPfRGxNXbbjjYcdtvFkqdd+hav7CjUo7Z8563LKoAOZsEl23iiLpF1vj3E+z/1W7/OtNEFkUlVVyIWNUHRVZ47PifIUBBieX8IWP+u032oaoc65ttTGTR/PUdHf5z3833ftqlxu9MyDeVsffM1O0Yepa1W2OKpK1qCwxiugdMFpkumw+qv9nQoeZVg1/yZ4i5XIlPx6AvTN1pjwPS5qbZWpm/e2e4Pd/Yr7zY8gcU7oMCeo47pWeteedGwYd7nI/SAu5QPsPJqCJNkI27Jw+J92rIF4g90eleWD+hoV04mlsh4eifxwWBRPCqkalYs+a8FIWT8o1A0pyeBmBNKulpgl8qGcQzYIeiZXhHqQSGlPDDNV3c4zxp9MofsEpInk+fJVzm9jibWxy6t3nDvG/AdPG0mAqTVluuTIZcfke3hrYcLALGD0zeA5LxtDXToS9HlwZYj/5zTpgmyYPAGxpQKgMXxxckxRHrV7lT+pI3CNnztABhVqmlADSAT0jK68+PQyfzCn5vHJnIskydoSkbOnfzAfjd8bJURcVFGRWEF4frYj6rYFHNMU2aWtnL2rUAtfa7cn2UZIM4bx0N3ZuTvtUU5TqrCMfA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(396003)(136003)(46966006)(40470700004)(36840700001)(70206006)(7416002)(8676002)(316002)(4326008)(31686004)(40480700001)(40460700003)(70586007)(6916009)(82310400005)(54906003)(966005)(8936002)(2906002)(5660300002)(478600001)(31696002)(47076005)(356005)(41300700001)(82740400003)(26005)(336012)(36860700001)(426003)(86362001)(81166007)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 09:57:40.6459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f52b256-1dbb-4868-8243-08da536c7ac3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1869
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Jun 2022 14:48:58 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.6 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.6-rc1.gz
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

Linux version:	5.18.6-rc1-g1cf3647a86ad
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
