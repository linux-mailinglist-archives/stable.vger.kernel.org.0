Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE44506883
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 12:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348636AbiDSKRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 06:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350592AbiDSKRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 06:17:03 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347782AE23;
        Tue, 19 Apr 2022 03:14:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9xcXwu95b1m27zX2GcTYmeu2rluIpH0QXa/ZcCKQIoOLMSXE1MGSnqcANilI431rbr9Sggcx8kp3Sy4j5y9Ibc2CeQcwWXbr/AQlkSyHKhNBDNH+mYo1YMJq+TEy2H5Hv5eFeb3+T2rCAzUIDR3GyEwzQOFR2p4HYS3Fr2p0g7rDx4uaF9LkqvRELZxLsVvTTMEAnsA6Pl4NewFRVsxaDWTvpFSI79FA3A1Tj0yv/W4aCTXOvzrOiunNd648HkVqR3EL3ehFRVrLDcr1svO0bD1gEpS93zzYGiqUOns7YMUxfSFLHohUsyNIogEHdKrAjS18OBy7ZdnHJ2qifcmdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bfzFx42HIljYk5yAAx5Z0Uz4buz8o3Pfzs05hqrheZM=;
 b=PcTx1SuaikS871xDg4ptvwMbYva5QrjR6v6MdYE9WLFBT4VTe8OBKROiZSVdg7AfQ6wF3kFWb8oQnxf4HEDLetCCaVqi8KhOghMFu4OsM8sSVvg7j8UJFLtbADAjFZS1jtn5USEM3PZkEdicgUteEMVpS+szv5FsYz0qoGNmh253w9VV2Z8K5EJUhRb56WYxp4i6q8EsqQuqx+eq70h0NrzgcLdDOlm5tHzp7HAbdrU9XLWkNzxJEhHjH5ADaMX2tsCISqPJQQeEgFcXRKWTtnNHIVcUvtdym/7y0Te9RPurMFOMw2b9ciUJBK9R0/AgG+82MaX3Ulb8c1Iem9sO+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfzFx42HIljYk5yAAx5Z0Uz4buz8o3Pfzs05hqrheZM=;
 b=cT4fCZFNV5U/OKghwHvncx0/geNh65YWGAeqonz+AQh0LDmv1vlliAzHEafCTGT3h6lS8tEj6bgYFQmWW0wA2IWMAbC8uyPsHnvmEBSRI8v5ktGEl1QNiJchyjMPWRnqjy34m7DpkfkKNHnKCwU8TmQ3LDpOXz3JJyNwDDRYRqfxw/uUo6BDAtzTwLrwxb62Tiye/JFSc11HucLhHOBqIDrpR5sryMfEt+4wQ+DsH8ndzUGHRgEvGUBKm+4gVNCsHTEEOnugJvYMRKPZfVvkWZitVFqsNETPeacK+tt82frq9AxTGpiNJvTKjprkznjvxxUp6R7XJTKZ3CStbJMaXg==
Received: from MW4PR03CA0225.namprd03.prod.outlook.com (2603:10b6:303:b9::20)
 by CY4PR12MB1205.namprd12.prod.outlook.com (2603:10b6:903:38::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 10:14:18 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::b2) by MW4PR03CA0225.outlook.office365.com
 (2603:10b6:303:b9::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Tue, 19 Apr 2022 10:14:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Tue, 19 Apr 2022 10:14:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 19 Apr
 2022 10:14:17 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 19 Apr
 2022 03:14:17 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 19 Apr 2022 03:14:16 -0700
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
Subject: Re: [PATCH 4.14 000/284] 4.14.276-rc1 review
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d54068bb-8a24-4681-a971-eacda922c19f@rnnvmail202.nvidia.com>
Date:   Tue, 19 Apr 2022 03:14:16 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9354e811-75f2-4767-a78c-08da21ed5d6c
X-MS-TrafficTypeDiagnostic: CY4PR12MB1205:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1205F67CB042BDE3A8605151D9F29@CY4PR12MB1205.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y4TMQryTKz9fbdVLePlIIPH0dlPBVZbzXHdI3GgacBLVduRPOEDbLLTIWy2zDig1ng04SMe8cr521p+0tsfTjeQhvnwADDXLL4BSjqgM99AOJ2BZETpOVdJQINFpd+2MzvrnU4KkpaRRPdF6SO952AMBlMqyKnOS+PAyAgAugmTHj/pghfBTL6mOePypUPPs5wyynfq7qQumjT5rNwdyqeyqVCZfVdaO6dltJS4Y/aP/GnfxR57XYWL33zjt3uE/uG1iQh17T/b27OaXZMneh0h43ILj0CPk+9JSgLbQJIe0Yz4xqTM/0zNxmHRHYfs2w7Nm/pFAM5rsWj3toCkm/ojGsGiDfS30PCgFcz9qHmtobT0xr++02MGqiBcB4bqlGI3LF/x44aDfsTR5bihLGdwHeBIGIpacOemHj1OhumiQQXIC11FHxL/vOlLTjw+icguR2trKOwPzwTHNy17QG1cpRiWqAuhkXQdyTvs7ougUcGXx9bkFBl5DnMpjb29z332rw2ziXtiA296VK1os9AV+ealYOSjaIaYDEhTdeozv9YLFpJ70729xXgAJfzrZWpHIxAqhHaidCNl+t/HQrH1h6BBTFe7AdC+Ou0O2mXvPcpv3uelZ5uPfpxpUFTU+lHBDgD6cxIAlJkocXEBAVVRssymnUMn2iSVTxTA6PeS5dRHBfMneVRuYWhPXfQl30cjTCfxQDigd38uSefLJyrjxEY45QedmCJv4XzXMLGbU9gzn1EP58cV9FDD7uoufVO3FDq6MwF4De7yGmSS+RDx5fLU1E03tQO9LKTxRwD8=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(31696002)(426003)(26005)(47076005)(186003)(86362001)(2906002)(70206006)(31686004)(70586007)(81166007)(36860700001)(4326008)(82310400005)(8676002)(336012)(5660300002)(7416002)(8936002)(508600001)(966005)(54906003)(40460700003)(316002)(356005)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 10:14:18.3776
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9354e811-75f2-4767-a78c-08da21ed5d6c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1205
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Apr 2022 14:09:41 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.276 release.
> There are 284 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.276-rc1.gz
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

Linux version:	4.14.276-rc1-ge419aef383a1
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
