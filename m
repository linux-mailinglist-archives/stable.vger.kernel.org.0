Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A754C877F
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbiCAJOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 04:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbiCAJOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:14:36 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2062.outbound.protection.outlook.com [40.107.236.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A26755BFA;
        Tue,  1 Mar 2022 01:13:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJg90qoN7K/QB+I+dn3V2cGLaq6kN5O0IYAqCtmq3PY2pnLMgiUUTZDWSn0uhNiKsk4FmHjFTM8qU4sDPh2fGAbVzI7fOcuYlbE+dV0klw1BqOoc0yLfmoCeD3+P+H31EsMZjfc9IWkXETj5djTsYHz6fR4zXW/RKxicQ11ZB7iOScQjh+XubCo4Lv/9Rmjs7SG0WqXo2B/DG9XOpKlf4T9RQmqEEbJxvO7PM8XBMfdF6aJtRAHGH5b9CcKVZYpieDhyjj0iwziMmrv4U9L4wafGCoPjrerU/ldhWJazmBdGcpEq2mU2SFjR6LdExZZj3hM8e9yhYBPtaWjZoQ/MHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+BQ4Bnr6mvm/nr3AZgm1/KmqgGcpDpoQeocquI2scI=;
 b=RuIvLpvhYanICtVmI21hQQ2imfCgcXM+bKWRBVmzbRuqtbb/F7s6dTUMlA9UTxYtNyi2VPHIMGEWAx1YlfSp6keNoI6E9uFgC5kgdjdWRvta74CFKkU/B2DxWvHknsePSuzDiVboVyYvZIclRzXygW0QSoVTUSQMYE9aKNjRlN4vNkUodccmfOFqgWAzE8ojNpOrTT5y8DqLNwvQ8r/EXWuA1m4VRFzxi5eN0M2Lt+IXTLSwrQgQsfdfOpgf8tzoEYNB2fhF5EomZw/qubCl8pYPdEHmyaZLN1EtxKmIlfZhM0FsXjQ8tCiiagKfoxnPmAUoEkFsan4/GNToOpfl9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+BQ4Bnr6mvm/nr3AZgm1/KmqgGcpDpoQeocquI2scI=;
 b=kJFILblKq32q9bnJ5fiaJ8L8/plNsdMXi24qoPQpTxx1ETxbzBOaMP11HeeZsn1R1phkAJvufnBABw9zm5rV09TciQkm8sbLmiO7jOlOMjw+myUnziCTJ3DIe8cwMSE4zhw4bC2qbu+MBvdqhItyLkOZuh70+7ab5yo8FjYj9JzYCgcbic6SnSw2Tj2pN5pUwUd/uG3zpN45qi1c/s/SeQLSs8VMHLDTTZQa8UJHA7+drJ32t1bK3lQJMQGYjMAOyRaCece1/dwbLxP65zJ64/p88f9dtHMN93lbMe75kbyWgLEUs/I670kG84J0sglyLNHAP/JoHRhUJU+jJGZunQ==
Received: from DM5PR04CA0044.namprd04.prod.outlook.com (2603:10b6:3:12b::30)
 by BYAPR12MB3127.namprd12.prod.outlook.com (2603:10b6:a03:d8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Tue, 1 Mar
 2022 09:13:48 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:12b:cafe::1f) by DM5PR04CA0044.outlook.office365.com
 (2603:10b6:3:12b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Tue, 1 Mar 2022 09:13:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 09:13:48 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 09:13:47 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 1 Mar 2022
 01:13:45 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 1 Mar 2022 01:13:45 -0800
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
Subject: Re: [PATCH 5.15 000/139] 5.15.26-rc1 review
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6a59f644-1498-4a60-8c9d-076785abbc26@rnnvmail203.nvidia.com>
Date:   Tue, 1 Mar 2022 01:13:45 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed878e85-f3a6-493a-320d-08d9fb63cb62
X-MS-TrafficTypeDiagnostic: BYAPR12MB3127:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3127DB6EE64DA512C99DE811D9029@BYAPR12MB3127.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ecDtJ18ng5H4QPSUgppr1cT3uqTBnfMa9VuKYio1UL+xUtC7wnl3gCG8mK/I60GlZqYEIYnnNmGWntziuOM+JzNwUI4lB9sdkZY6cFUF282S7+TfSi970F0QF8YhXm7i1IJZbCzhfizU7gyvL363wh0RdtAnOV2BZ/i08qLgTth9B/5QoQa6TDkSYClgRNXuC5/t2K6wv6kCjNjUz9ELSdktsKLL42joz93+FS71iaRnC/Lrtqne56P/hzIQT4GQWIWziNLMcwjnfbPZS80kUBY5Ot1YHJyAU6SeL/BA+X8PGxjycp/vFURTyVV1DYfZvMMsGdWlz/xKzCJCeeiXjoRRqqot807r1A46H8R6WBOGECJwRfvEAIskeeiopyb/rwKAJpJjWcP6vC5EBtI5ZLyN3V6yDjD3L++MZFraF5nV5xYvRGJf5aDjVBMx797obIGnIKcOgU6EOwWaLLSgxUac1foS/m2JKWc7DvaJjl9yK2Ns+uuKyVcOsJJDZHtuaEGEf7ozz9j2n0Vim9Mt77H9R7dFKkVB9gI+aCWZWlpGDvO3GSGA5s0qnGD6gZ14OBifN78Wkcp1Zs65QCCLMP0KLEGCI81JoMX5cC18RH4M87ToWBvCthTH3HpC0mfeTMXsKeZGbSEtONrzykTiWUVs5z7PCYdwUBWIPx4L3L/FzGTiFv2sKeEbLF4+F0e30386YOgR/WKTVxfNkNFCcM38fAsaE7KbAzS2FUSaHMdRAIpxDdbrhdzWF1WL9ll+gbjpQlHSYLRVys1avdr9xPa8pF9DmMlTTCMsDhuml3c=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(356005)(6916009)(2906002)(31696002)(31686004)(966005)(5660300002)(7416002)(8936002)(82310400004)(8676002)(508600001)(36860700001)(47076005)(426003)(336012)(316002)(81166007)(54906003)(186003)(40460700003)(4326008)(26005)(70206006)(70586007)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 09:13:48.1086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed878e85-f3a6-493a-320d-08d9fb63cb62
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3127
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Feb 2022 18:22:54 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.26 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.26-rc1.gz
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

Linux version:	5.15.26-rc1-g798174743716
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
