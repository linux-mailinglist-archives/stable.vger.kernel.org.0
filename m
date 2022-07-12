Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C0D571585
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 11:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbiGLJSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 05:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiGLJSa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 05:18:30 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889549D51B;
        Tue, 12 Jul 2022 02:18:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wx0H61zGjDz8pjVU/UzM4DkIjEasEPxHG8zjXtHW9P8TwhpsVfpc+7V2IqQVOyKG2KLdj/ctVTNCMDO1wxoLxt9jkPamVU5WAMxyO9szgRIHBkJpWUhGLnDOY2mfVi0PlVmCZRF+XiwOXLETiczSHV/lDRbkRbnJA1eAiXCVrjaVlA4ybAuwt5hamHi+Vbp89/qtTrICcCVRiYMveMmA0kRebURaWswhU9G/5WtjYShsei0KYyAuVSXqoJRdy2EpLvHzznoKFl4EMBf/PZkjlpoyiRztr6XhBKZNqtjcS6NMMDgU5N1j+3h9aheUDu/xSycA1fniNDrjV12gLTBOPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DrAg9FjDtAYX/uC5/KN3bWpvVsKQcApUAMt/LfHlstA=;
 b=UXpRcPp4MCV2pgEyIhb50Bytbrpeh5//zd8zhcUvtah0jyFdhC+sTOz6/Y6ACswckVS5sm5VcxpIGUphl52COrNemnKqwrHrwxO14xGyPCVOoXQsla4ap+VnodYYpmsXZjSRcCUUef03SLJzOAUVArdlMaxK+IlpzV3WG4oQudW+8bPonh8Tk+ZdGi+xzR/CQAgBo+eQM5aXxSY06/bKSiXZxy8PbyRjFCuqu1WnJKZ2l3W7zJrWPUbOlV6hnoveUrVcy47O8B4rlwSJjGZRa4zSuxfEvhUA/TPS6FAIJHUKvutagCnnzySIFjYCHlzccjK0M7q56svU/aEEjVd3OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DrAg9FjDtAYX/uC5/KN3bWpvVsKQcApUAMt/LfHlstA=;
 b=l/6pcXEsW1yAn5V1cXtlPFb6gWLH6eaUe8J+PF511wABzNVqi2J4S6RioAnPmhGipu2zwxA3yJ25Xrihxil6zwXEeSIKzg63Shnyel0/b7vJyA5tVkz8eDJZBJ2ipZ3XSQB+pjcHdbYBZVK05d3as3amymwvUn2By4GC2cGun7I502QZWSbUJyTzk6cJdOYp9XMTv0naA2r0nPp3WByvN2tzGy6pSQyhoVH1lk0uSzw59rnsVtfa916NyGt4Dmi8zBN2giIxOkZrjRkOQfOtH9Drn1UtP1KF7eChtlin6Sgmt/IaLkgYTliJYET1zM7FszFSaZNuee+QvLzHrpXNfA==
Received: from MW3PR05CA0025.namprd05.prod.outlook.com (2603:10b6:303:2b::30)
 by MW2PR12MB4682.namprd12.prod.outlook.com (2603:10b6:302:e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Tue, 12 Jul
 2022 09:18:26 +0000
Received: from CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::65) by MW3PR05CA0025.outlook.office365.com
 (2603:10b6:303:2b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.14 via Frontend
 Transport; Tue, 12 Jul 2022 09:18:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT031.mail.protection.outlook.com (10.13.174.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Tue, 12 Jul 2022 09:18:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 12 Jul
 2022 09:18:26 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 12 Jul
 2022 02:18:25 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Tue, 12 Jul 2022 02:18:25 -0700
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
Subject: Re: [PATCH 4.14 00/17] 4.14.288-rc1 review
In-Reply-To: <20220711090536.245939953@linuxfoundation.org>
References: <20220711090536.245939953@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a2863b5c-54c1-40be-b4b7-e9e1b6fc206e@rnnvmail205.nvidia.com>
Date:   Tue, 12 Jul 2022 02:18:25 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13d3cdfc-6dbe-4109-278a-08da63e77a51
X-MS-TrafficTypeDiagnostic: MW2PR12MB4682:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 959Al3CKQkmEOEyaW6IVEk+PhbI9rQz5q7d3F0Zeay9yIQEg1lwaucHp34Aorxt9p+F+r2s2XN9B2teX5ClWI/2iehtDWmdRNdb9mibvC1GonjkmUZF40f+hZ+obltY4uJ0wsngEmp7KDthm5X1PEO/39Aq3yqaE19SZWjSCOLKktamSaArkqtnTSC0ykiamNFmogxqsJvQ9V27FHbL4dOisPdat2iK6hdu8ktEojB5d5dDGLQ/czvV/4Y1TN5Ciy51nAJBIyC4+IJZfc4PxZDPVoiX/N+0z8JqC0rhWgEQ5g4ue2/SUn6eKp4Zss//tQx8Oaq0A9MORCm5NJLJJNRchi6KRDA2ybX0UXfeSXvQ2aoo9SHOkQnMgPhQx//7NazvRjAnZU5NAndcNVdYsrVQ6Kfa93oiP0uTzJ+j82oHyFRlFPR3tA34TK1zAHvTJpkmj6TQ4joESbdKR8iKHvvUQVrvR6j65AuAGDcWEUzyhaY1DC5D1QJmiYLE3i11gaIk/tAue5b0+7VFUEuAnuz1xZcJVBiWLSNSXxbVDSet3RSaUOGNxK49Z+BEdW1v0Ccv6006ZFuKad4fsGyXrVfacy4nJf2Hm+PJhwCBmYKVwBv/RWIBIlwKjcEHlWWZzASKLx/nWJQVnosGVV4u99nkYkj8aFvTt3wSoqIAEmdoO35HCKxm+mCxRJVaa80JmLQ7LdAj2T6HmfPG1lZq8A4kGLtmhEcTVGoHAkvxD048gNMq83IChrJSompVVvrVUPrtS5g/vtPyfpEqEsl3iPHxjqv+wgLiXXrAhqXanEE185Hyp5vuBxRQ5JfiUcjTJhfvxKTwEs22F20a41uM22Xt2o69PLI8LG+V2NmHXvTl/3j85z0mXkCWksKpeosndvUiBeCZdIKxDMnVFm1KJeMJVvuieD7eo+q/kU/JeO6evHSCSkJgsrTDyn3NHwJms
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(376002)(346002)(36840700001)(46966006)(40470700004)(2906002)(26005)(356005)(40480700001)(81166007)(54906003)(82740400003)(36860700001)(966005)(478600001)(31696002)(316002)(82310400005)(31686004)(7416002)(70206006)(70586007)(426003)(186003)(8936002)(40460700003)(4326008)(8676002)(5660300002)(6916009)(47076005)(336012)(86362001)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 09:18:26.5830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13d3cdfc-6dbe-4109-278a-08da63e77a51
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB4682
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jul 2022 11:06:25 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.288 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.288-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.288-rc1-g0dbd49ddbfc0
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
