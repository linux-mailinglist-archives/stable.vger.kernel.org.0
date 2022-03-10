Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1D64D51CC
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245594AbiCJSts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 13:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245589AbiCJStr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 13:49:47 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2E94D9DF;
        Thu, 10 Mar 2022 10:48:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LwQpfK1oHBdgxp0SaGy9nQwmjg9UxxeQ4oyPBZ8P3SZ/lH+mNUDjl3fETct8jl7aTfQLC9l1n4w7yEjSc6BYXTzJoiqxuGbWJGbLO3/ncadrJpkd4gmT13om36almEJOtdzm2JRXgQc4hUXL5XGitOpiyEqkSMbTnvtsKhLu70GocIAAh9+M9l+4Qdm7XSKgYaKMGlksqZTmlRoQn3bw9GUgKGkEKUBJCaSUO/1I2nPmn6Ou82Gk4/RvZZ73Nc4RwI23drHsWqSfTufxhSXmOCc7C6imW4L3yErERO2e7ystJub9SwBX4gnGvPMAs5hWcnOKx1gQ6NT3TSZ2mT9I8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Y6zEdrkLTQ+D3tpNCjBxGimuzJAVb2nK8sdSZ+EJZI=;
 b=Ff1bLj6hbFjUGQqQ8VV8siiPBUBA3OUMragTAk4XaBx2YGrrPUBepMEQ08xE1p+gNFrkGMBEYDV7T4C+DlWHZUY+IpnXR4Qg9BplaQHjxIKu2jG4LU6aqoxKy0DbL9XsFbC8lhgZBwxEoA+MRXnKaiArOKSqVisZU9UjppD/GnOCJy636XWrwr/bQShxKzahZNcCzNN2rY+ns4uD5JDxprbmReDBcaleXlufvLZFaKAsrXxQmJX6nJABgb90qeGDI27y5jQzT6j+OeX4F9RhLmbiPMZ7sQdj5QXTg9TXxEIuGU8QXFb+sJd8HnEVb+FZ3CNOhtTHmB4I4Kd/UyB/mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Y6zEdrkLTQ+D3tpNCjBxGimuzJAVb2nK8sdSZ+EJZI=;
 b=TvxTEq+cDX1xpHwKlIv3++VA7eadrRvpbb/gZH+tpJB4xMvYY1OeXdMnYvUWQhzPnB2edsP/aL8e4gRP+lZA5DM27Vic/rFKEE/gjbiA01Tls1BkiUNtyE2AStgTKdE+b6y5mriQqPuBOq8sl6HM56E4Vt3UoBVY4ZnQYQU8UK7XAN6Fhxyvv2ot3NqBTyJsEhT6PYZlP4NyAhi0mo2pafwVxdsWJtiBLpnqvYxi+Aa3WJxC8JbIG0K8HTQE2xApA7LObAM8D/FTE2AGIWVOc4RpkUxHq5l3369peYrmzJaVxf9G2R86gfpyJtFSK1+6NmaoQPDojvki2burpE5wBw==
Received: from MW4PR04CA0300.namprd04.prod.outlook.com (2603:10b6:303:89::35)
 by BN6PR12MB1139.namprd12.prod.outlook.com (2603:10b6:404:1d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Thu, 10 Mar
 2022 18:48:42 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::d7) by MW4PR04CA0300.outlook.office365.com
 (2603:10b6:303:89::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22 via Frontend
 Transport; Thu, 10 Mar 2022 18:48:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Thu, 10 Mar 2022 18:48:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 10 Mar
 2022 18:48:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 10 Mar
 2022 10:48:40 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Thu, 10 Mar 2022 10:48:39 -0800
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
Subject: Re: [PATCH 4.14 00/31] 4.14.271-rc2 review
In-Reply-To: <20220310140807.524313448@linuxfoundation.org>
References: <20220310140807.524313448@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2d2f2085-f868-4dd3-813d-9584006aaa68@rnnvmail203.nvidia.com>
Date:   Thu, 10 Mar 2022 10:48:39 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60217a00-a1aa-4d8b-3d87-08da02c698f0
X-MS-TrafficTypeDiagnostic: BN6PR12MB1139:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1139C7525279EE7243F901A3D90B9@BN6PR12MB1139.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 55t9bLVd1zPSi5I1i8ZnFzZrZummp5/BsiVjm9Y1hJW41IFXRG8JPG50OAHf+/vL+LcDXLgAlEcjWDvYcMh/yEV9FEhVp+4B/a8yJ1l87pLXtaknMO4DMOBg8x1FMNVOOyTnvOffVc98XuLLRhzIK2+W07PIflA4N4Ebi5e2rX0M2yZK/q973W9RJX+ij9PEYaYWm4XBF6zXPOdfp+pEQUo/2Yr9+3Y1V54A4F55UmOR8EuYrAJ3dJpOIQBmce3i5KR4fCFk+u+8HBFRJqgTxuckpAv9X4eBnWoOEOOFXdl0I148mlqe6NomoD++4FrkG462JlZA1zIxsxVouIpSzyKiEzznwD/qrQ8nCyo2ar91vsj0u8KdKWHvLSQHgiotfxKy8rBvoR+wyfAWYwT92MNTSjxCr9heDuWeaz+0aImvbVKRRa5ovItEa0n+7PlUXCaDuAT/jiTs72vKiurTUptdbXSSFclqY+mKz7zlqWcnYOpenblO51aeaEKfBAOT1Hh5DGxf0VYBlUaqewtjFKDpKfnl0hLWPvI1N+0ReLlFefKSPM9A0SD3W1MLRVE/q9GJhCoEiO0oANDasV8mL2Xtl1EcDxgexRDUiEGdjr7fCwFD+xC3/yEexRCtrp7Vi0cS9VkHcfNkdFXLlmJ7rAq6Myam16EVG5v04tev+Yc2ojZ+r5hRHKKwoMiarP5fNPY8XT2oH3pzRDZ3CJC49ISBZpm6lUUtsp3LTeObImVnNppyOg1QO40O+bVMEoaCu8w9PBcI3FM0JD/E1vQl/y/RMbDZzKFTLcndHlM9eNE=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(86362001)(82310400004)(26005)(31696002)(36860700001)(336012)(966005)(426003)(186003)(8676002)(4326008)(70206006)(70586007)(316002)(54906003)(6916009)(47076005)(356005)(40460700003)(81166007)(2906002)(508600001)(31686004)(7416002)(5660300002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 18:48:41.8382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60217a00-a1aa-4d8b-3d87-08da02c698f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1139
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Mar 2022 15:18:13 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.271 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.271-rc2.gz
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

Linux version:	4.14.271-rc2-gf497d213f361
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
