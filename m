Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E0C57DC47
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 10:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbiGVIW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 04:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbiGVIW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 04:22:57 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A8F9E797;
        Fri, 22 Jul 2022 01:22:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZ/BCAFPcBwIAp5ndoB2RHw1SDQ1LcDSmCPOQkhQsGEEjjSxJt/bQo0f3qRu/twN/s/iYPmblTgoZzAZLBQSP9WiXwqMnla4Jk6pwuOkkfouOtPf8g8zkXjyP4x9DCsQnlOOix9xk8L/fAjYhs/5YSXGBHF2m3HgW1IwXUqK7QYnvgcaaZep0iQiRE563fzfsJs2CVT+l+Q2a92yXes410Y/5f3/rPV4NqIz8pF/cx/A/WKM5UM2QOFw3dUSZPM67nw74stondJ2Jc7jGwIDJFR+Hgee2xpUCr+MOa9UjLc7s9rISOCkXgU97Kw2y3mnh2XnDODZg7Gbw+fHT2++3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=syMtTfehAQSvIiUNzZM1mOYBURFNH/RQN/C8B+Atf7M=;
 b=bbAjeKZ3Q0SmgajRW6XE8TwVzqUTmU2UvO0m8c+6BgVyWb+KRW6RRN9tfhxeZQ5ud6jx8rZDwgJpcGQxCnoiPm8wWbW4pmiwCipd+YiE0bZMPmX+BNI087g/vlbTN+/AcP5/isbliI8w2qtxwwkTKIa9EZpcFu0pQDj5qB2lnQu2eJt8FG1JPXQsFzHXkVeqSqA64Pp4HnRPLpl1Ffs70eSCEdh1IQm8x8KFmKQOYAUdoSMuT5+/pNY244VtbPoc3Q3vkiclsvRsNXXX67dfK8C63jmHbyRTTbBSktl4G2V9CWWapiXf29iS7jbe2NJPRVT+VGBD1YJh4ivFEuikjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=syMtTfehAQSvIiUNzZM1mOYBURFNH/RQN/C8B+Atf7M=;
 b=bXTcFBOpnHeftNv3jB27CmUXxm+qxtxJ9S+NO/0YM1JZ8mW7VrOBbrnUmwbk7I7H4QErSjMlqGcjbpDaKB6AS3/vznN80obIUyI77WMFedYhc+68owOODBiPL7bs1cCXs0wkRZeGpecFp4m+wX10S0S1QJx+mvORE3rDWPLNvlmdthfj6lZ51fWyFzo4YNmvDF8udQR3HHp4bPjYo9szYMggm7W9SP0/2AYER7CnUi0oNMDB1GYuBejdP6Wisb1Abs1qj0MNTS9YLBqPrfS9izAvOSmcSsDzt+qPgzNwxtYHB6Ywuw+MPM2Epum0p5KjGggy5pR4SihqyoWhyDr90A==
Received: from MW4P221CA0026.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::31)
 by BN8PR12MB2948.namprd12.prod.outlook.com (2603:10b6:408:6d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Fri, 22 Jul
 2022 08:22:54 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::21) by MW4P221CA0026.outlook.office365.com
 (2603:10b6:303:8b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21 via Frontend
 Transport; Fri, 22 Jul 2022 08:22:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 08:22:53 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 22 Jul 2022 08:22:53 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Fri, 22 Jul 2022 01:22:52 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Fri, 22 Jul 2022 01:22:52 -0700
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
Subject: Re: [PATCH 5.18 000/227] 5.18.13-rc3 review
In-Reply-To: <20220721182818.743726259@linuxfoundation.org>
References: <20220721182818.743726259@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3df5e9fe-5cbc-437e-8872-a6e0389ccc1b@drhqmail203.nvidia.com>
Date:   Fri, 22 Jul 2022 01:22:52 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 096a40b1-5c3b-4c6d-1d74-08da6bbb5fee
X-MS-TrafficTypeDiagnostic: BN8PR12MB2948:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pCaSUazoMOwxk5/pjHMzYHASPUNIf2h6czP/buVKEuJtfhiF4KBH71XKpU6E1Zxg6wk4G+m+K3XYmbeMebDxwzZmqy+QF4iF9Ucm6Je6aYrk/2CgyZ8S9UgVJWNO1IjnMzlaBAQdSBbNnQGcZwXR7rwyLB3jnXKmH6o7XVj118E6Up1Yfmuk655AqH0lW0OmEhHYbgGsEErAEJtFq3H7HBeUywgHJaogrh4hCo2En9UHovjzO502p+GPFtw7n3l8ClOdtl557VsE4pfSfYw+j3N/xsZflG+4e13JhH46k53gL2Afl13UoT85QF5XvM0k5RP7eaYhQJxLifuozwVzV73YdATL+QaLqxF6ttvxCtY6gT1+vlHwpyRYlwEbJC11qHE9zmveqd8ztFfhIINjA9fk1I3Q5Z6R6p7L03mywVJWYg3X0OqjsCOkwuCQWBw5ECKp/nZjjVrl04MsboqZzzB5euFSmaLLkAZHdie8VoTwDCfDOG8VJ2xiDDez/2t0Zp/5NnXjClpuOl0p0gMfiCjhqHoqnUdhOZEf7BqjUtE3cO/Y7xw7uTPdmm46lEoeUe0U7xPaJQ0jPE7wtyY5rmd30J4/ev4iE66MZN6bA3dGmWr6VodZ7OZIHKC2FEHrkYF57xhfhzWzWS66fGSUkU+yjDcFHTUnsz+s8l7rU6AwvDdzEHtlkUtasd/NPXRXQ7Q2DUmUEcFdATH0o4D7DKyevxqikGRHoP/m0IAt8Rkt1uDEqSFEXnNpDSj7kp6XRFu7nkGvBk0rM3zfdYsCNyo8RCyeJ7Purl0JCmg4hN10TRPhRaAmyeINT/xJFcnry6keZlV0Q0Qpiu49DeIcZZdIKBLCXJQvt6mv5GH0O5PeO3B6HWhTxlMlCIXZ6AW+Qa5MvoUbbuGJ+dVcuWMzsgk460g4O95J10vh1QN/3Z4=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(346002)(39860400002)(46966006)(40470700004)(36840700001)(336012)(82740400003)(81166007)(426003)(2906002)(36860700001)(47076005)(40480700001)(70206006)(356005)(31686004)(31696002)(70586007)(186003)(7416002)(4326008)(478600001)(26005)(316002)(8676002)(86362001)(5660300002)(82310400005)(41300700001)(40460700003)(54906003)(966005)(6916009)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 08:22:53.7593
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 096a40b1-5c3b-4c6d-1d74-08da6bbb5fee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2948
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 21 Jul 2022 20:34:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.13 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 23 Jul 2022 18:26:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.13-rc3.gz
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

Linux version:	5.18.13-rc3-g6fd6f57fdfe9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
