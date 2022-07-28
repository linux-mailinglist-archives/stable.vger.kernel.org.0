Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F3F58417E
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbiG1OfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiG1Oe7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:34:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078A767C8C;
        Thu, 28 Jul 2022 07:32:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVGMoHyqSi7f5dadzuIWepwhpViVrl0Dg8KSDS9Hf6Q4ENkpozLP8jmIKHAeBBLRkRc1owVw42I6K1aXsAUPeBls+75i78ffvjd63shew57cwvyewf9BiJUTJI+pS6rimA5dU4GiFVmcLlFBx4B7wO//l3Plz45uetH7qvVxSDnEFrWnAUE9D0H7u8qgmksn9NF7fObZbvxPk+lBjEX1nrBFq1sl5DrDsl4C5mBfa30sYp+ccZplexHiEYUNJY3HoR/I0MR239TBX9EQY0FR4zxlADp1LQNfXX6lpNvX2uRGNYEJNFwEPY3YzQCgU+qm/3/GAkmR/CON3nF0zBngAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JUAUdUcpCyalUdydb3848SV69KjwOCE6BNrxVpaY5bY=;
 b=gE9bdgRCf1XqSaY15KFQBNfp4Db96UJ5ZuZ6jOnTjd+0vT9wpRpbwmxpxOlt/bxm1pVgfLwR6R8uQRyNGUU7hb/F1hFfnZY1HVftkXhx1+4ONQs5GT1TmotRASrUV1Z9guToVUF0iMHDxeoPlGXVwme/AskFUVzdycTFTFIMEh8gFGxQRy1wLw9FFkieO5eM+yVqmmC6mOj7UolMVk/gJCW3eCOQdwu3LcMQY/IeiKE8BYlO9X4NMOTXQjh+WLcuqwrtovZMg1sMOKXKf4tIoA0GHuDPsHemN+Q8Xa3jR8Ie4ELRDTz4nA4LRs0mmzgHBxudMTOzD97N35AKeiW2fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUAUdUcpCyalUdydb3848SV69KjwOCE6BNrxVpaY5bY=;
 b=YYuMwf37rXuy6OUpSkDs7l3vidnNi2hb5hai6fjktuyq2UQ4Ja8deTbEvAV2E45qewXea2mbzuPKhZrsJfNWr4Xiw35xtjuPTGx/zfliNxj7+qgJ16VP3tdm1FkxxzFtDSSMQOMA07m4hMlll1rL5wulzH40BwDYWLxgqzN/GBzlwFe1kDOdmcwnROzaggBCAaUR5PV5dDB4154V/14uKtAo4vxoxMtEdNF1Ai2RomYLqfUqB+4Xkc/dpS8D1wK26Sj0zTKNgW6QUlbsSgiA8crRjSOLxlKF9lt+VU96oZCqXXLJqAzi6AH0UukkGV97bb0tvN7Ox87mEz/5pUqFPw==
Received: from DS7PR05CA0067.namprd05.prod.outlook.com (2603:10b6:8:57::12) by
 DM5PR12MB1305.namprd12.prod.outlook.com (2603:10b6:3:75::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.22; Thu, 28 Jul 2022 14:32:37 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::25) by DS7PR05CA0067.outlook.office365.com
 (2603:10b6:8:57::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.4 via Frontend
 Transport; Thu, 28 Jul 2022 14:32:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 14:32:37 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 28 Jul 2022 14:32:36 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 28 Jul 2022 07:32:36 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 07:32:36 -0700
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
Subject: Re: [PATCH 5.18 000/158] 5.18.15-rc1 review
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <810cd8a7-dc8d-4698-bfc6-4f0cebba4807@drhqmail203.nvidia.com>
Date:   Thu, 28 Jul 2022 07:32:36 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85946c29-c2fe-49d7-b49b-08da70a604bc
X-MS-TrafficTypeDiagnostic: DM5PR12MB1305:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0A8kjOk/rGA9cj3QXV2W+hTikv3Yai4tKnohq/DhNnk0tkY4uIYj3G3/QFN22vcP1COAKOUEiH8aoPHEbzgAWF3aTq8R77o7GWZNXwuljDH/TvBX+xST1hSsav8p46TJsyrVhERxvx+cOOEjx6hPXnDPpRN9UbKbh4WT1PAF5gdeXEIAc78PheTnK+Eu+NpiLG7efBKlRZgms3plqPnBhA9GQzj/Al7K4Gv4yD0YfQwujzZLOOvvce6PcTXFOvLsO6sTXTWmKcsZcdR6piUMAtu4MFZxcYpLFJBM39ld3p93ra8uUvDHpMIqhgjagoGwHD9G07PFJmX/RjQjoyKNi+YqRqzaEW3IvXDFirAzSPiimsKDLD3pfw+y5elEtdB8BvyCA2Dq265LiKaq2uvGwVx7Exd0KI1WiBunLX5i4bmOVEBDgSND9fPHr0MkulEExwven2+lZRDtoji7xsMUrq7i74S6hFc1WFSRjaMuyAUjPPRsgALeKcD1HkImOnO0hOlANWbh8aSvCFSSLlnGmzymNLSkWg6KOV4DexZIOewIsAUi7TSlw1l0R7eiKc5JQo8PshApJgQwVEAAbuWOX5ySuaB2a6oUqWOy+W011iXhmZtmodoGVZqUzqEoWApDUQ3kKgSWjb2OpoqTp76+fAKge1UGpkjUkT4S1D5fOfsGOsW5yyytO2FweoqLm91jwOPmBYOf+J7vK31VxeR2fBMtPNvFGfpTzZaw7zuIo0G1sosSEliMxqeRt52NHuGekXxDqwrLIxWaRPMUjdaI6vPBv1OwWHHZ5PNWvP5jBeCpygRtl+X6xU8VWiK0DTrpNqn6AykChFQMdP6H7LHgs9HWOK16Xm2IqEWthPVQkUlqmIiFxcgVQ0T6EVaVP38UoT2fCg6keppkJuzN/HZMyigKvATvQVdznddujEk+A/w=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(136003)(376002)(46966006)(40470700004)(36840700001)(82740400003)(31696002)(7416002)(8676002)(8936002)(4326008)(6916009)(54906003)(316002)(70206006)(86362001)(26005)(966005)(478600001)(40480700001)(31686004)(41300700001)(356005)(70586007)(426003)(81166007)(336012)(47076005)(186003)(5660300002)(82310400005)(40460700003)(36860700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 14:32:37.1610
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85946c29-c2fe-49d7-b49b-08da70a604bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1305
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Jul 2022 18:11:04 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.15 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.15-rc1.gz
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

Linux version:	5.18.15-rc1-g63d1be154edd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
