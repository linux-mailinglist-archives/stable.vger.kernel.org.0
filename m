Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7E04D5181
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245591AbiCJStu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 13:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245590AbiCJSts (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 13:49:48 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2049.outbound.protection.outlook.com [40.107.212.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC57F4D619;
        Thu, 10 Mar 2022 10:48:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBvDFEpenY1xRZGoi9TcR8+glGbpB3M9myJXBo7W1v/JSynA3X8vuw2dK3hL0olCo5+YS7G/hu8186q5hiZYMn5kYdpPluWxtwyorvuIOGj9ppRKzM6QmZLyY2omEGs45ZG6FEGySh7Jr0luJQE9fDqDT9zq9I19NMnrQ+Z6OQcHC+CsTSCM6UDM4563ejyvoATHB7yVjxxUT1RKUg7VEybtkkvkj8xvBwso5UzcV1sx9OW4h7t0bwRVJ3Cr+shftHl/4i9bZNC3zHc5otKsngR5WGM3RpEcqO39XpsJQcDx69zuMuJ4ua67CaZa5UA/dco6yxFjkyUiHODt33PXRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9GlC4DkwDe7pqV+8daN5Iq+74wdxaJkCJUW2SbdF9M=;
 b=hv6tI7j1K403JCPOlGA2Vzc36EHNnwN62csnHJzLEgxn2tYsMN5D66L5ALQubCkY4rwNZQdxjusCUfzIGVIOjuGiaWic5RBmEDHTzOa83JEEyFnls8+iRDFR8+KabbjYc6HKS+uvzJB5d8ky/DPMvAoA9gbdzCAB7ZjobAH549UMSqMsVOC5uI90L2lWyjymMx1am7cQRjK2sS1Y3W8rDT8ma7UIqdQo/GVZgM/UaTsdi/D0aP2FRxPzu2BOzvU1loA57Dkss2AIlFA3Q1cCX67zvyS7MzASiKb5vRDMkh1FI9s4tP4S5LddtPYxWcw0Y8Y5ZVWMA9PWH7NoPzgtmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9GlC4DkwDe7pqV+8daN5Iq+74wdxaJkCJUW2SbdF9M=;
 b=LeEOVFTAjfyO/2MWfAoMnkZm0m1xpHScQn7Ht+7MERtKWrOXEZanDSquHzJlACJifO0wO342nFnk7FL7A7IWzJQubLQyG53Joc566tDkpIOYItNjQLMfRap4kRQT+bOfLyjva+5emkN+CU+rn41xoYysqxGF6ujlxLIRNBIEUTYXrlmgBWZ3lcm0mlh2XKcPBsbo3V6V7dP0SxSRvQ4hNBnXbSbs6ysLv3MOE+wzOSZb8N6nwhu2e1wQibbBuudURJCurE+Lb/knnUNI1Ou/oRwv/gl9aC3gAzX+isa8YDNMA93pf1wRn5z4KSOIItsA5Ff5XNkuF8r+Ohyx4D6fIw==
Received: from DS7PR05CA0062.namprd05.prod.outlook.com (2603:10b6:8:57::8) by
 BN8PR12MB3379.namprd12.prod.outlook.com (2603:10b6:408:42::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.22; Thu, 10 Mar 2022 18:48:44 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::5c) by DS7PR05CA0062.outlook.office365.com
 (2603:10b6:8:57::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.7 via Frontend
 Transport; Thu, 10 Mar 2022 18:48:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Thu, 10 Mar 2022 18:48:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 10 Mar
 2022 18:48:44 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 10 Mar
 2022 10:48:43 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Thu, 10 Mar 2022 10:48:43 -0800
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
Subject: Re: [PATCH 5.4 00/33] 5.4.184-rc2 review
In-Reply-To: <20220310140808.741682643@linuxfoundation.org>
References: <20220310140808.741682643@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <78ccc961-6054-4e4f-be55-10dca7cad8a7@rnnvmail203.nvidia.com>
Date:   Thu, 10 Mar 2022 10:48:43 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce4bcc9e-bc7a-4d01-20c4-08da02c69a9a
X-MS-TrafficTypeDiagnostic: BN8PR12MB3379:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3379B970FA186DE8FFD4E2EAD90B9@BN8PR12MB3379.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +s9sa44vsLqhiwoNm7HQTqFGUnmoea+i0DQwB0CHyTxYuHl+dkID/ayVVc5vV9SAa34E9dJmxQ1rpDwavVBKQAyRIZlXuhby44Etp3PtzwixpaEcHq+3lxIIiMdnEzRMjfwKs4ww1cj6G+ABmBVPL2nAK3I7U6ktstltJmfu8U5KZVaprteMyM/Wv+l0PGWb9i1ByCji82ukAj0HXyvmXIDfvPrb7xkf+1b9uPJ0rdYhG4jkQk/sq88VpXwWk69D1AR6lxwsOhe8H3TaQWrkjmaKmpdkDbd+5157t8jPiJoHHCfxjMQKhNigAIeQvAZ8f79B013zExLSWW80U7axKbj2wtZKmq55iQq3rwThzKk0f+vf9coe8UaQTnUXiGr5QnBvmZNr4V0Zs8ICa+QiAsLBdc1eomifcvHh4FqrwL3Z67u6MiOIknBAezzmKDRQjU0Dz/LlWS4rfKAKqw2J7Xwd9J0S+2cOo9YDNCMZbH81oZSlGSdpQqWXO3qJ5IwXaiWNOEr3Mb10rCg0s77KXafGZ7QBaF5vIqrEAFP2YIXyfJU6YhhKYFCIBOQljOp09CHgjrJfkdzANiHutBKVSTFRFS1XSg6qrJLZLIIqK3N41o0sa4Sh9C+P9bxM4jUvTbDoVtliyEH/cgFZGiHMZ0Ap0+gviFatlkNvgocFQ2xpKzmp0+sTZLqP2NbtdC5wsGVxbrmRLThB5lC3O3nCuGZ/PW+IbHpq0bUndsEYI4cOaYBXiJ7WtK8onGsMLRwzVj2Fw1svEl+esFYSCZSTX5UbnAC2vaIGRe2gOzMsC+0=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(7416002)(5660300002)(8936002)(82310400004)(2906002)(36860700001)(508600001)(47076005)(316002)(54906003)(6916009)(966005)(40460700003)(26005)(186003)(336012)(426003)(70586007)(70206006)(8676002)(4326008)(31686004)(81166007)(31696002)(86362001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 18:48:44.5668
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce4bcc9e-bc7a-4d01-20c4-08da02c69a9a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3379
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Mar 2022 15:19:01 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.184 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.184-rc2.gz
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

Linux version:	5.4.184-rc2-g10576140d9ea
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
