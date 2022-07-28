Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A397F584170
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbiG1OfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiG1Oeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:34:46 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0991573912;
        Thu, 28 Jul 2022 07:32:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBscjmW/nTuutlJ0kItFCS+g8CfG8im053940YNengr4aaM3GpgkBXgdo6CEbkGH3qWM/DRJFjgy5veJXSBwr07AKEQ+XfhAeoIJUXLLX6CF4Y7laCtJuvSmNkaH/AYVWMWoK30uNlQjLKFdBlWgn5pWhN5kJpdlltoS15hyiXLS12GenUsTw88jSnix3LgPyXIOVxl6bSIO4CBDG0vwHh/h9Lfz7m9+Bi/7N2Y3aiCthq/AFsORZFBQRpq2yq/B85ZefKs951j+Z9jH0/EhmFmdVCwJBxuj6Z5DreWZSWXF2Nzi8x/zPTVat9UgYQnitnpDMHla9f9dnru1iqUpoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwVc/CR9w9iO68M4nd92IA/DxY43Yu0eRgM8NUE1Hk8=;
 b=fcVbZLw2/cBbYv1l/b7IkMceQwzlx3lxzjiiSMZcMwX5qhJeKbKXtmpBkrvF5YrllDreoYg4qNaBpJBtAaqSHwYzggJvoKG15akIIwsurZ2QCy391UF0j5eTmckkV9sspiBvC1GkjmN4aBHSJ3x6DROyQdlYpF/wIL3m/BCQ5L+plhbrT8u/k9KQZUquJ/madsRY2h74u8dFV/dcoHN2JKtdR32DQKx2MA9upwDCavLZZ5vggMcArKECYxmVYA4DHVhHNb9uxYGcd8kBWzy4tsDPZJ3Un+8NQPwIRYWMPfNG1N+H8mNN9xzhZOMKfEiS8WI+OWIaZLXMZ+QmRLtzPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwVc/CR9w9iO68M4nd92IA/DxY43Yu0eRgM8NUE1Hk8=;
 b=oo+Gv+sZvhsBb21uFsweHku2SmJ0R/nT0NPBekCHqvCVDDBIbQnvWjbcQOccFvgF3WOcOCHBDL5VutwFKGyOaqCB2ccbHjzPbSEc09/Pj2lhPYqop5asgcDkwqaOs3gWzb+9oZgfBKr+XGkAvoV0P4D81bdw+gfj6eJ1ODi76U3u9FDzBcQECp+Z106ravFtDfDeVmi7wM5h/c87CgYayF4BLj1p4LUmmtuzyplSVjThw07SVwApMpxq4f2GL4yP2kzCy0jmYBVhXdkFea9fDRc5g0j8JE7TRzZcjnBLT4ZXeEoV+IG7RwyRX5d50mjk8N5MSPUY00hmQBH43ljqOQ==
Received: from DS7PR03CA0239.namprd03.prod.outlook.com (2603:10b6:5:3ba::34)
 by SJ1PR12MB6170.namprd12.prod.outlook.com (2603:10b6:a03:45b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Thu, 28 Jul
 2022 14:32:09 +0000
Received: from DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::3f) by DS7PR03CA0239.outlook.office365.com
 (2603:10b6:5:3ba::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.21 via Frontend
 Transport; Thu, 28 Jul 2022 14:32:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT061.mail.protection.outlook.com (10.13.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 14:32:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 28 Jul
 2022 14:32:07 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 28 Jul
 2022 07:32:07 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 07:32:07 -0700
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
Subject: Re: [PATCH 4.9 00/26] 4.9.325-rc1 review
In-Reply-To: <20220727160959.122591422@linuxfoundation.org>
References: <20220727160959.122591422@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <db0ba0b1-d369-49c4-a093-526b61d772f8@rnnvmail205.nvidia.com>
Date:   Thu, 28 Jul 2022 07:32:07 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 422c0e40-1166-4fb7-2e04-08da70a5f433
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6170:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IjJZikkLCFga8cmmknX1HGMBY5MnU1CsDtigScZQOwbdO8HFzMAliIIylqUslKVyPiVvGfKHCs2VIO+2F1lWcw3258SlP/FM/c5HSC5TJIHcozSveP4omLbY92NybStv7wBMTXPNnW+dMF8t8uuS+TGqazhgdtU1up3TuSDX6jWKgD3Cm72IbVhpCImXS2ucBHfaq/qVA/QlxcmVmKHiyUKVwIfFMYA2bcbg3dlJQkqQ7hyPCMpr3jcqeYNcLDwyaYxy0yMHYAbXQIdeuEnBDhYfaBMXCD2zrZe2Jwz0t4iN3ydNK47aSXbnNFVK4ebUAI5UfJvKb9g3CyvUWMtNGYnjytMSR3FN5tI0Oz2UQSPNkd+UZOcDTokZi2ll89wDsMG6pXWKOxLB5SL+5mEsKDLqO2TDD833UXpKO4euKkmZWLqW31H0aRb/B/e1y3YyAw9eeTytErTnCkGTS/7Jr/XDMDW3G4P1bGtiuwbxGRb5K741/MdiV7fG5+NdywrUsIIX51PmS5PvWl3T9LprHZ76nvFEDhXWxRmZqSkFkcZUPGOYq+VLuWmFzZfTQ4QceAuNqJGHB6f+aPbQW7nG4RF9cxcB9YDdsfWGgYKDITGxk8vrqiU6l8HzwVzXX+NDA4IasP7DcleBuXAY1Zp0nugDzqM8RC4Clpa7loGgG+EKObKnPn7bdKaOKGMSPDJf43xwv4al1VlRXdfh6MRFqCgan7qXZtohfYC2MHbcIrcfTxu8zF1GMUcpvfJXU0bReDeVwb5hcFWmc8aL+RIevEzLCE2A8G2OZGxbYrQOwidZBFYnViMJid1DU+PpjVZSsdPSWQ4wkp54BJwRZzkqeXs7drWqzwC7o3j5xdzfZh3woIeqZfYutHI7xDLXj7N8UGCz1J5sx9TUO7wo5ngGj2YRQwRiBVeAuYuWIodgkZI=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(396003)(136003)(40470700004)(46966006)(36840700001)(54906003)(316002)(6916009)(40480700001)(82310400005)(31696002)(31686004)(86362001)(36860700001)(5660300002)(70586007)(70206006)(82740400003)(7416002)(8936002)(26005)(8676002)(4326008)(186003)(40460700003)(47076005)(336012)(426003)(41300700001)(966005)(2906002)(356005)(478600001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 14:32:09.3849
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 422c0e40-1166-4fb7-2e04-08da70a5f433
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6170
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Jul 2022 18:10:29 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.325 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.325-rc1.gz
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
    14 boots:	14 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.325-rc1-gf3e4570fb8c3
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
