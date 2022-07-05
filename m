Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7760E567133
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 16:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbiGEOfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 10:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiGEOfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 10:35:51 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2065.outbound.protection.outlook.com [40.107.95.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ED555BF;
        Tue,  5 Jul 2022 07:35:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJ4gQFAn9dwC/WggKcr2Ailue2jnKSJJ1nAJ8bCxXdtIN/JFcaLd6I2YAtLk2V7qNDE5B2PV+Dt/GZFdsvG+Oe9FjA1Hv5dak+JIoh/CkycQqNVzwGoxen0asP1K058bkMyqUDE3aTI4/7qOZZJ6b25i7zFSXmubE6CouzhEKI7G4yVUzTHVEkvTwDcIkXWnORUTs5gZtzJKfhjmjLi0t6Tpa+KejSeOZTx2s4SwGuKowczjrAdYTCQsIaSnfsDktdv/Yo6Ztsx7ZsG8rizxxis151MFe9BVWNhji8tdE922mDC5A5CDacyklvmdQnulz0dpp6paCuyDoRChr0r90w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yx3I57YTAb4yBMf2qVEmnDct9qksDsw73fiz85TYUUM=;
 b=XJw/p8v+Gi07abG3hvsIwUDySxJuS51/zfRXdkNXgC3B6Suv+hvVa4Lmw4je6mLZ3aRvf+CeZ+j6EaDyVTYvbBOB138NVEV01Vf6u2oAcgJa87nnJDSetwY6w6PxJGrB2S15QBw/dtcxmOZDiBzwDK+ulTQEi46833oqzFKcwx6MuPyBUwxbe++jCbYD2eqzE4rSObwZYO1cM1lWQimORBYYn1TMh7s2SY5vwsXU9UbFKPEUoVI/y8WjtAAmHaR6B+hDSigmkz48v3wivV/jOxJDkn9L1Bv/bh4s9LeWvk8PL0KFSNNDgF1g9rJuC/C5jOI0L7tUJpNVpwY3NRBFKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yx3I57YTAb4yBMf2qVEmnDct9qksDsw73fiz85TYUUM=;
 b=kT4zYLWvHEQAhL//0UBbCwTVcXBL2jcyYoPAGNXqxmMhANQwseAO6BUQmSKSaQL5jTE0l8OpaQNpsLIz2AfAzJnd4XLFMmpiNOIclOi2BPrFu9w3N5wHaxdZ33QobfERrGWAyWOfi+LkCvrNzm1yz2JCn7lJgCQuhuYqXoPzRfriKy7GRUMT1zzVfv7DkUBXTPWrOP95AXjkDj8LkYFJyhJtEvNVr3rwUYZ39DKgV8/0Lnd+qfexDFFHei2DQm+JfhmUjbrMRQ4+7tNBgPQe1G4x7UJIphbJT344Xb3UpdzgxqJEq028C1Cjng5grwQdN62WiQqwo2JMy2o638H0lA==
Received: from MW4PR03CA0072.namprd03.prod.outlook.com (2603:10b6:303:b6::17)
 by PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Tue, 5 Jul
 2022 14:35:48 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::7d) by MW4PR03CA0072.outlook.office365.com
 (2603:10b6:303:b6::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Tue, 5 Jul 2022 14:35:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.17 via Frontend Transport; Tue, 5 Jul 2022 14:35:48 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 5 Jul 2022 14:35:47 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 07:35:47 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 07:35:47 -0700
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
Subject: Re: [PATCH 4.14 00/29] 4.14.287-rc1 review
In-Reply-To: <20220705115606.333669144@linuxfoundation.org>
References: <20220705115606.333669144@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <57d9821f-a4bb-4179-980e-979a2110e8fe@drhqmail202.nvidia.com>
Date:   Tue, 5 Jul 2022 07:35:47 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd9a05fc-6862-430e-cb27-08da5e93a738
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ox/1OALhozJkP9W+gy7spbfvuYtjuk7vt/tgXZjNtOKIXUYs8scY2CX3FVn0LT7v0gKiTG1J+RKVIfVF45KmVQbUXWCnw/ClbhSB+qdbXQQJwnShwpOYYMkQeC/RbIwyyR7QyB7ZXfE+FVPVZD4I5rt1KkxTIatxGZjDA3O1T5XSJwTdnMiA4k0+qRASSX6l59ZvscFkLa71kw7ZLNSedHmFRh0ltFnVDKJNTMj78v/ffYS4wvXO0cTZw51W+rf5bhnZ8FjZogIidhOp4VWyyCpGX6EPR93FeVQonEuRq58KABAsLD3Sr2Ijn/Mn/oVjVWvp/XEVSL4fILD/odqO2CYkcT44DM33zd0ItQFdvy7M6vL8+Qxk141uWOTXPsB6D13um2MOA3W5fclWE/Rg52bXR2oQudHCuL1735vUJMhrd2qZ/MZRzchwWPApDwAr+msYNJoTlOjpai2e77OeGtg9I6QOAegWHegyKYkmzL3fXWgnFm0vYZl7MfExcdYex8TVihTHjfU4C7kh0Ycg0XwXTl6zukNvf5kHUGwdrOzAfo29yIE57pfmbmF5JWV1Bxlvq0jpqmEv8Bg/dRzEZSYAmKHkqEBWjqcCypCITfWnDxir5kHSnbbxZF2Bfv7jQktdcvHXYB673IqYg8QRRaFyKEkkXzuxmZSSZ1nK0nKoHOXJNIDHrVctQz1H83WZrw2EaP65vSc/0ChmMTOoEklmqt647gdl0M2XN5LEx+QkYF8JlC/4tiWAhjr/QTfWcqqcNQ6kP2vqhVm7yoHJGIXtnSRNc7Rf/Q6gsUTHSiYIxToi+aOFe21ngsZ52MxtlEKbGMaS1/Fnhsjy4mBfNHj43e61urmPH3vngZ67KTwlLRlbt/yqK5GM+d8QA6b2glUiVjWAjGE8WqPoFGXAj9ky3Ug8ZDA3M+iSs4rrloxcdh0xeObFE+3bU9FlUjQ6
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(39860400002)(136003)(46966006)(36840700001)(40470700004)(478600001)(966005)(31696002)(186003)(40480700001)(426003)(40460700003)(47076005)(336012)(31686004)(36860700001)(41300700001)(86362001)(8936002)(82310400005)(6916009)(81166007)(54906003)(316002)(2906002)(26005)(70206006)(70586007)(82740400003)(8676002)(5660300002)(4326008)(7416002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 14:35:48.3973
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd9a05fc-6862-430e-cb27-08da5e93a738
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5629
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Jul 2022 13:57:48 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.287 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.287-rc1.gz
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

Linux version:	4.14.287-rc1-g2e9431cf011a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
