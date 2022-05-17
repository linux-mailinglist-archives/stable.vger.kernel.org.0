Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672CC529B2B
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 09:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241946AbiEQHk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 03:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242335AbiEQHkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 03:40:24 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A2848889;
        Tue, 17 May 2022 00:39:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=keAfk8bvCJmy/WCmpdPhzEzazsvL8f9CAnC/cS2Vtn946y8kWVZ/s//r+7pBClZ2M7W1dxcdQPacSNCOCFiEMTTUJaKd5yMrtThlYsxmrZ40GSvTWyvvJFsjxlF5m/WK50a7RKHfdTOaa2rdKBOS9v4ycXOEDAO0l57/+AdN4GOSOMAo4hOtscECFGHZJHpbB2eD6aMgnAxqWN3biIRB3GUwcLXS+7E1V9Xfiy9mun7sn1d6UsG+OAp+SOmJRfnUePdVuYeSBP3x5PUBqMXehgQYCN5Y0P/o1DVyFSUc3e3VH1IMlJunmucBMzL9ZtsUOmC87OUP3LopF4Xvh7JQtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TTqw7XzfOrYA5sQ3Nbc/h/5u8/C6w4QlXv+v+3EYoG8=;
 b=Iu4YICc5Ty7Od74SLNtsBpNEkbgh3RtPnX0vdyDyyO/65NMbFpdLtcaRnZ1465fUm6bRdkTWlN2vCbAstwhoPlL/zXa/WAaZ/yBdFOaroIM3ldruiNyTIZYOUUoV7qhtlISZMOpd3079XCSTRM2aB5GIHWbGZGXFj1Xx1d801V57Hu0wotqyurOGs1cqkQH1lAtwKE7oLNIGx9OZ9s39kzMZviQjYDQxs0JMuoFf8GsIqJjEC//huBY+V8kBYP2eYIJCmwEpTz/B9zYlbNfB5jjWlPDIQwSord9GDFExC78gw+veDkc4Q0/3cNG3ETk/hVSd/jHUgf+9spyC0sZmwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTqw7XzfOrYA5sQ3Nbc/h/5u8/C6w4QlXv+v+3EYoG8=;
 b=UgMXjYtD7x5QcXJ9xCP/KGPKEwQeWWLkNLKwdc1H4phShtmUH0JKs6MiLoQ3nppjK3shKd5Pp5O0zyzKOH6NtljrIOdTGYWKSod/BCTEN30ZRPnysGIIODCsf0JuDKywE3VWUnJpasQjbP5Idn3NBZieWKpvVX6eNaIQprinI4V5spDReZD2AMCT7EjY7voM4KFlLAPZh5Aa3fQtw9W9LoTBxvJ6XoBjllLqwhdZJ+6oFXL2GC5hhAg3YwHB8Pg3fPu7OFBs0SH1GiivbRSbtuccnusCb5wFwAdSpEjN5vEhSutE63yER+q25pbEJ27UAl8VmK4zolt5st8XkFiJrA==
Received: from BN8PR04CA0035.namprd04.prod.outlook.com (2603:10b6:408:70::48)
 by DM5PR12MB1500.namprd12.prod.outlook.com (2603:10b6:4:11::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Tue, 17 May 2022 07:39:15 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::36) by BN8PR04CA0035.outlook.office365.com
 (2603:10b6:408:70::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Tue, 17 May 2022 07:39:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 07:39:14 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 17 May 2022 07:39:08 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 17 May 2022 00:39:08 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 17 May 2022 00:39:08 -0700
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
Subject: Re: [PATCH 5.17 000/114] 5.17.9-rc1 review
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2f66b048-7698-4b37-9d19-32467c2cee80@drhqmail201.nvidia.com>
Date:   Tue, 17 May 2022 00:39:08 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e995478-45bd-45ad-b8d0-08da37d8578c
X-MS-TrafficTypeDiagnostic: DM5PR12MB1500:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1500F21CE52D2A27676452E9D9CE9@DM5PR12MB1500.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fk4qaDSy1om7qdKv+X7mZkSiFfNnNtKpiqoj8L1Zu5y5ibwYWAVmDRnqKe3NqmxaPmMnaV8rcN3lP4C+1opjT6/yeQJev2Ki5NnA/u63CtR3FT+uRWz40xX15OwoFL8enqRgnFsx/JgQD8CjnrBuU7nTay1F6xmUHpNeEBE+A/5nf/ivfeDbJExZcK8rWEeCJOGpm9IF5GXPEHIxG4/1EzXc51ANPgytezVRr0vY+u9YEacuY5Q2HCmCOUfPb8K5rlTVHCLpFnzaFXcWW8aT+galXnF7Oj45w2L3ZnssgVxREPAp4m8zq6OO9OSYICm6zVNsRGXN27cVzy3gxYzrCcrBRzK8/P/+/0QmGrJdICfYjbK7YCE7p+3+KmH80n1iF7tcnbzw2I2q+dUDCch87PXPiPWxx53JokZR9pxfIRH4hPgrCEHuFcOeNoM/cKjyvZ/C3no+SRbINFamq7OGA3VKKxrjHqef+ZHfXyiTGbczuB4kfs60+qWG7wbC8TeMf4wLjW9TP1Hc2s2Iwt4INIycXFzu55SLx1/mdzy0FSYkCE68ODTnOkh+a88lBCo5fsenPOkjfrJ9Akuoj+NqX2hO5TtQ9M2iuZ4xQChbncyhNOLlQYyysCPulGu14fGVfmCSuQYWcNkVuGCU1aoR7pG/qVggJ6h8IaHevMgIM/3GCg99NLnXovS/8fUrJ+AMljSxKuXbydeK2OZ91C3q62ScA7WGJ+bQILksX6leNWD7FBfB3FmgGcmJJmkO5Q88b43bndAfItQrTwcOCVLQ0wiBZSCWrgiGEzVgHXY6peA=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(5660300002)(356005)(8676002)(508600001)(86362001)(7416002)(40460700003)(31696002)(426003)(47076005)(4326008)(336012)(6916009)(54906003)(81166007)(31686004)(8936002)(82310400005)(186003)(966005)(36860700001)(2906002)(316002)(26005)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 07:39:14.6087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e995478-45bd-45ad-b8d0-08da37d8578c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1500
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 16 May 2022 21:35:34 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.9 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	5.17.9-rc1-ge1382731ef4e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
