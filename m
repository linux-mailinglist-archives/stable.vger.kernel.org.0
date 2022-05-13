Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F3F52674A
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 18:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382431AbiEMQkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 12:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382437AbiEMQkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 12:40:49 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD5E10FDD;
        Fri, 13 May 2022 09:40:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiqCCdY1C+D7TLmubbyXNg7wX092kUEF0H0FhpaMVJFfm3QW0HjLbgU8dRQPblMgRdh41l7ODbjUE6EsNBUnxlnrDKO4YFgDt3AkwKusyLr0NbHZlWSFcL1mMg79b9ii/JyqHMfkUokhlcTQKcTHV+pr3hDSquogKlStrSuU2hYiLWQ4FfD7x1ms+47hOAbK/7Kr0VPWeZpEYfK2yuUVorJxLL1d+8EMj0Hw7kYXTfIQ4Jq2T0JS308GWObwYecmk9+ENuo3zKoVQTK5UiVKf2NB5sSRcCxUOB5MXz00byopM7k/yQZkOTod+1EaaNIjy4YslYK8LQyZAx69LVo1VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SCC9bf/A/IZ78ECwdSMwtbobuQMgmMlCqreBRQ6duYU=;
 b=KeNmfWdqrSIgaGMwhR7JZ2JIGx2bwAUjd2wBzdZbP3rg2ZPdWnGJrz/50gDq90MTnkRguaXNKKohfgay+4pMkvqPcmE3M2A3rxUFJ2DNl1uCAeIwGAXwvPA0WhlQXWuY3qAxpJ11eKVXsp/14MaytVX8Xv26JMhcswBRX6VTSWzXp71k+Vw7sZ8ZWRWhFTrTmAjPuy1bCZg7D/Os+i/kZ27TPfJJ6Q0g8cN9WgNSw5Vfs+FwUrRV+43e+LXz0q2R3koiUzts77yo4MSyr6bIBOgrFJe+XNSnD+Y052NJj8xO1s7M8AWkHioK9pCBIdxdIk+Gi3fVXp0ktuQ1Yq0iNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCC9bf/A/IZ78ECwdSMwtbobuQMgmMlCqreBRQ6duYU=;
 b=IHtKnVCmCFqURHk+VBOQQiyTmJOrkpFzKZk0MvCaS7anAUZ2rMb3/7TlJ89UBrOAim7Z75MGP7bzgVAzguymTE6Z910YkvauI2/OOAnIB8KxVSRAN/Ip/nEgbeJK9evrnZpx4A+Gmj9xECvUCoCPUG6pJgi/We8eHBpoTzRQEK3WbFJVnTiqgWELG1hLfrUXDSrvAq0tHBFZOhAV8hpV5kCWWP5b1c1pMCxXGww/+dDCfXnDupq4GfKCE7+iBQqusgoo9vjR+D2qHUSpjC4xal9MWV39esHxVlouwlKI3v8FCFu4Yd9hbCWeKcSaPbgbQFd3zTSC7sW4pXHp3tuC8w==
Received: from DM6PR07CA0044.namprd07.prod.outlook.com (2603:10b6:5:74::21) by
 CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Fri, 13 May
 2022 16:40:45 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::64) by DM6PR07CA0044.outlook.office365.com
 (2603:10b6:5:74::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23 via Frontend
 Transport; Fri, 13 May 2022 16:40:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Fri, 13 May 2022 16:40:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 13 May
 2022 16:40:45 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 13 May
 2022 09:40:44 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 13 May 2022 09:40:44 -0700
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
Subject: Re: [PATCH 5.15 00/21] 5.15.40-rc1 review
In-Reply-To: <20220513142229.874949670@linuxfoundation.org>
References: <20220513142229.874949670@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7f406a48-64a6-40ce-9fef-79b9297a1599@rnnvmail205.nvidia.com>
Date:   Fri, 13 May 2022 09:40:44 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a7e0810-5499-48fd-9680-08da34ff5410
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB014994E7F79B9B130BEFC271D9CA9@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AHRNrZ9FVTo11Nw8hJUn1sVzy1OR/IQ/r7qasAJLnX+v8QxF0N0N93NFODLl2L21psBn8SU/6Yb8xF1JGTUATGW5rHf9sKrSB/4D2Joh5HQyAOqckgxSLcaWiMPc24I8RlTW80Ipy7TpkOwM25XCtlDT8nd/fbE6+c9uyso/KxlyMulRcJb7RCNfRmeRAC6+HQn0902E/U3zqywUXnp87A0mdDVUYF1YYKm/2hLEJsBzqbqEOaVpov6LP6GyyxikQPcfCr+bL19xspVzutNpNZtZewAk9Vb0Qx/OfBovj6TNl4e1SDE85NIZNwqpi0f7tIMkMruWvE808atP0kYMdGD1kq7KJgzIRMpMR1v4sT8e5mbCESm0TXzHXiW6WM7bWjP3ntY2etJBtJxxtfrhijO/dWT2WN2t9i44MQXw6g0BwC8lcyQ/94nfp+ilE1rrrsvsC1hcME1kWcqmxV9sM3aNY2WwqbObOektTrnG3Q71e+KHvAJSake6R9Y5VVtIb0s6fh552Crn5szS1xstAXfQpd+APfzPpjyNvDSOrv8mFHIRKy6IIuTxLn2evyuqnJllMHoRMTnNzQt5n4+eSQUOdb+L4HzFH6ja8cWEokR4WISSFuc8RNjfGoQpxxM4tWvmq6brx6yr4yXcZzibpoju5pdfmWBnc/yXHndte6ROqFzk2BaO86wTTOwrsl1FTfF+zsKh5DR2JbmxUEZqwa5QGOzsShNeZIKxBBfSnMvFuB+SX6342AyK7BDCKGc5kdZL6nKzZMvQe2vEhYFSfTXpwcD+sqHcsGb1eDVyF8I=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(81166007)(8936002)(36860700001)(508600001)(8676002)(31686004)(4326008)(70206006)(70586007)(356005)(2906002)(6916009)(54906003)(186003)(426003)(336012)(31696002)(86362001)(47076005)(40460700003)(316002)(5660300002)(966005)(7416002)(82310400005)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 16:40:45.6930
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a7e0810-5499-48fd-9680-08da34ff5410
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 May 2022 16:23:42 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.40 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.40-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.40-rc1-g13b089c28632
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
