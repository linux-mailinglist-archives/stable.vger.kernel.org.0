Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1A460B4F8
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiJXSKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbiJXSJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:09:40 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on20603.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF936DB551;
        Mon, 24 Oct 2022 09:51:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jNHP3Mat4JMhwWJz3hATa+1Rpc2dsdyu2+QK4/U37fvTnb6s3qskl+lS58N5XLt/3kM3Q3HdaNsOT2gcDMmssCK9rO6bX4HM9q/qVarX71fN0RQUb5cMbDPOE8IweanrbLoFdJvqa5JI//5K+DHmxM1M0qLAM+MHWfCDSiNpEImCffBXt5bdsGsLBhxR5JbT+3A5Xt+R2GMCtRqMeNyOdTiMGfU/vci+ctXz3R6U09zy48hd81GoXTDJYaSYZYqpIQDSSrrSpGIJFk0pT3hxsQTTdsFF7dVwPb1pjoKSSt4NGO0oeztJt5tbh4VSyShRbqV2lcNl5J0/gMP+p78Kmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Iztak9th9dR88lNvi5HKkRvjulvMvyZo0uFFBLbIeo=;
 b=hxEqM7kADrixU9cx2Rc/7ZFxKdovjT8C2T/zRqkgOnNhHa3YEGtYb/PkpEC5MPxVJochSa1C3OpiswAI9kZ823Tss2NhLsAFTe9AoYLbVESZIEU+p6aTlvPFjTfMaXJ1U3W90TcUOQB6hbcxLOIENi79ITM/nqGDBMUBoi5TFmQ0AFr3KSsnd9IqL/5Fc7n2wwVJLa4YUxIw7ljTBvW+g+uhmYSMyGzAeeEHBbYMOaUovOMrnqD5P992dZoG+kURwb1K/wCDkdVGbfYqchKmGoVDKyAc/VWiEKbVI2T6e/NGRsnNERgnUzM0kfu/LSBCIcd2lbMd86SuKSYM5V0iBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Iztak9th9dR88lNvi5HKkRvjulvMvyZo0uFFBLbIeo=;
 b=oRHmBUAuVUKfdYcERtt2Xcr+0zYwfdwJUjFgqnm3lVxD/M7jUpiuVpz4SAF/0pDqLoQq8W4vPCIukcHTIBwZ5IqdFu1XLESMIeAY+lBnkstDbaqTqnaaoP6krCnJPqXMdBo4YMFAtIRk4QcDKYsktIxiDbuJNKz8RAGa1M9nr+8MF1mkNA7k5PyyY7K2hZTD/xGAjnshEhQ0jR4gBLgRk6n71njzmUByvcI5WjntS4iVZVVGMcXZuRMzpOHBNR1LLelZOI55JUNDFx0e3Xcb7ZSN+UeOeGm7418uYui8SVNB00eN0Vn88CHzKti+Y3/luAdAzr3Hv9vBHQevdS61EA==
Received: from DM6PR06CA0027.namprd06.prod.outlook.com (2603:10b6:5:120::40)
 by MW4PR12MB7216.namprd12.prod.outlook.com (2603:10b6:303:226::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 24 Oct
 2022 16:48:58 +0000
Received: from DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::ac) by DM6PR06CA0027.outlook.office365.com
 (2603:10b6:5:120::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28 via Frontend
 Transport; Mon, 24 Oct 2022 16:48:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT112.mail.protection.outlook.com (10.13.173.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.16 via Frontend Transport; Mon, 24 Oct 2022 16:48:57 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 24 Oct
 2022 09:48:44 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 24 Oct
 2022 09:48:44 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Mon, 24 Oct 2022 09:48:43 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/530] 5.15.75-rc1 review
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6616529a-f32a-4a9b-bf4c-e90e0c00f221@rnnvmail201.nvidia.com>
Date:   Mon, 24 Oct 2022 09:48:43 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT112:EE_|MW4PR12MB7216:EE_
X-MS-Office365-Filtering-Correlation-Id: e0f8c1ba-2ca2-433b-2128-08dab5dfa52e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KsEmpvlluccGXz5w7dnsq0iE2SnzHNjk8KCb0vBuq6zFXDc3kxe7s9oypLE02OePC01wFA0SZMN9FPvkCcmqu9RXea/TxQXVEGOyQhaS9X0zaHXxu44YBlzLJgPq6QG712eX3J/ld6Qa8P31rY/rMTaksdf2fOPeZzdYgqJpCtN9Bae4vboi/1jYuMnv/giCW/40j+ysikoAhm+YIzPOzJC60OO4XMTaw1yZpST4IEY8LdSTreCPsV5BJv5jJAdoPsWqa7KNhqeoxqektVk/bsx8FhpWrwwc5MP9Ees3qNXvahFhcu9llNe008ASwARyarXwbuuDlorwgJxdH+y33Q/Rpj5AzHnNBABmsxeCawp7nk26CY6gPUeoAthQAta59WEKH1+InmuhcpCfJUW6z6YLjhGfkUTK4u9N0/zaiFR+Wuhst0RSxTYWiVEEbV1UNHJWUzXTIO7Fj7m45EI6U+/OJi3XTx2dPKYNnXf23lf1RI+blb1cmo82335PPYUlfX/njUxVsXqEX0TORDHuSkqhxi14/6z9cNwrs54gDzj2KCn8mZQ8bnKjjuh5Xj7iqmgwyPD37jnot2CQltCbdQUJQM/hAFzX22CrbwaMmL3ZChHrY2sghao0SmbaeIjzMHT7j3LNourY7l1CKqafQ1qG+yhr53apPZb/D5t7gVu2TBvXu5NzB4e6jkKkKhFhJIICkuklnVSeDam30DxDA7cuz5WzAK6wXk9iPUQpzVaUexBGcqmq1gk7Z7EvnKDp0F5HX9L3MOiUM14gdxMe5jj7aPcwG1j7KkwZ4i6/tf9SJelLkBwsMZIRg/egdHoCPfedpvxUB5ixkcSNUTmuNhELvTsV5JuAHDElJiWq/Vs=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(451199015)(36840700001)(40470700004)(46966006)(31686004)(70206006)(70586007)(82740400003)(356005)(86362001)(2906002)(4326008)(40460700003)(5660300002)(7416002)(31696002)(40480700001)(7636003)(41300700001)(8676002)(36860700001)(336012)(47076005)(54906003)(82310400005)(186003)(478600001)(316002)(6916009)(8936002)(966005)(26005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 16:48:57.8382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0f8c1ba-2ca2-433b-2128-08dab5dfa52e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7216
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Oct 2022 13:25:44 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.75 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.75-rc1.gz
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

Linux version:	5.15.75-rc1-g98108584d385
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
