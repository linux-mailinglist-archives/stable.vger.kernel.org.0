Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8BF84F6BBD
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiDFUyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbiDFUxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:53:55 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2073.outbound.protection.outlook.com [40.107.212.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFF25C36C;
        Wed,  6 Apr 2022 12:11:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5zXX6NHTA+ut4n+FXrOMxuaSYxdElPhEsjvjhv3PYl40qWhWpxkzMIys1fMiNZHRKsei9YRtDDaKYPI48JrYrUzK6jtDDVBmuGvozDUdpbUo/gf4IJkqABTmrnihO5zJilnSU+75K+j8SNTOgSDJ8Vf7lQS5QMQNKdMBOyg0yzmi16x9rT2KNCm2rcSdG0DBM1IyqtgscZUpxeHHX3ebH0hGS71Anydpsosi2DhZCEpPqnAVcGfNWbea8sE7GvsmhGBs971z6iFMQo9I7YGbclEE7R/kV6qRgeTLrqCAbZDv9F/d6Af0tsV0y8RSI71+QsNFzje1B0IvYo17mVB5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hlka//4Mxl2tm5IJKIoD9ZpJxDxaTzSsoZObSYyr5iA=;
 b=Wase/AbSX3WfQ7Be0lOcbm5CF8RBnlAhPDd1PAzNJL6LWsjuKTvadTrpxTyfReQftFS+QjhbL2crIRQnlKncZhPeSVXD15XEYzpwTpx0wJEIpveOMX2Jmfi4jUHW0HSZX7mH/dni1OUFEulngQeYanZNfQp2myyudB+BgYppNOzgcCpnCB0nd1RwHtS6fS4aetDwObZsklb2PLAIplP6SYPMUHte4NbtTFGpTuDgk70qrfkQx8OBGfF/OHZ4JFHKVNyho1Bf5abvV3k4LMVXOyEwlierJrAZMXwwIQxO2hQ15CoTi96XHQKSLnnjM4G1tZdt+zv4qGHq9Jzrp84fzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hlka//4Mxl2tm5IJKIoD9ZpJxDxaTzSsoZObSYyr5iA=;
 b=qEMThgpd1jT0GbFxRbj470//U7LXkfxsRcZy/tr5YSbstMqiUqC65Yp3xLH3lqPh3z7OqHlFTdUpXDjPo95Lo8M7BcFdwNgP9ROHwHoqR3jpz0pE+cMS8xusL5DNKvosNY6KHjQRqgCKw9RhbBzHvuUudysTWHX1YuoC/rwfBSpp2Um4pqdPbxuA0SlY/xVNroxIFzLpyWAeySe0rb/YHlq1hJ1kKBxNQ5Te0LRY96t9WO3W7tMX1mo3e1vT51JLQc0AugZOjaVG9IdDdL65oASSbZflmXWjaL4ljdlgRKweWp8aL/Fit55O6+L2PEDgScU+6Kfi3f226kU7mBzL+w==
Received: from MW4PR04CA0253.namprd04.prod.outlook.com (2603:10b6:303:88::18)
 by BN7PR12MB2642.namprd12.prod.outlook.com (2603:10b6:408:26::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 19:11:47 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::41) by MW4PR04CA0253.outlook.office365.com
 (2603:10b6:303:88::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19 via Frontend
 Transport; Wed, 6 Apr 2022 19:11:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Wed, 6 Apr 2022 19:11:47 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Apr
 2022 19:11:46 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 12:11:45 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 6 Apr 2022 12:11:45 -0700
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
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc2 review
In-Reply-To: <20220406133013.264188813@linuxfoundation.org>
References: <20220406133013.264188813@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d412ded5-7d3a-4e02-837f-95a7b0885de4@rnnvmail203.nvidia.com>
Date:   Wed, 6 Apr 2022 12:11:45 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ed6dc6e-35cb-45bf-4f8a-08da18014bc4
X-MS-TrafficTypeDiagnostic: BN7PR12MB2642:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB26425F7796CDCB0F83CAD1E6D9E79@BN7PR12MB2642.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2H5Y+LsTd2ilr8hfyONUvApGOjYJUnF8yabTZutgWQoJVH+ycwLePO070hp4mWzVdU/IdYx7kDX7q4o/Ujh6GaN2gCocrrxKkzb5AAzI7oSli/DKpvNXlP57NvItYr+qqJ7Ky7pS9PZkj0b9/yNPoBv2FcIKOaLBubjfAm/mYNzedJf8CRN2zXtjqajZ8QSM/8deU31V4P0t7FH+KDKm7KD7i+4JoIQqdnuq5sN6Ah75lB0wxHK4R1RwDsWbQnqvoSsk9F8HIMCCWmNTbViHNYv0aZ4ySmpPwCD/EVGrDNy4LBWJtQr40MoM9q2OATTXVq8Ob2U0SvgV7aOk6jvPcfPSJIzGVkiHH5Efddo5sEfZAaNkqsVLpIcYofO36iEo0U4ahDm90k03HNvu5NY8Prp1VR+JqPPbwp+FLmnxb8VlnBl0AG7rHyk93xabxew4mhcBocDOaNNh9zy8RFvyrg3QZ8DBtW9++VfwcEROoCLLH3YKjSbiZFp5oQ0lXWSg4d5SGgVaMG/UMgBjAxOy6WAk1JxAXyRXEpztY/qR0ZyIVpFpWDDDsnaoFJgehgP/ApnnRYyhSLVfMPN+qCmZhCyrRLP6hoFqdpxXwviXFhz/xtXfxQa+wpoOTKARVdFTddQgoUva3vSWgDNGkz2KpZD+fmrS6R8OsC6lkBUJJaALsJvq+U2nlHq7UjtByRNBz3UMFRi1S/mkZJqKUJwfAi83+nK7aEsyCXtzlu9VbCvKnZxYFoD3xnXkaAebb3qcfbevUvhBjzlg6SL3lxcD0AAU5BuBcntpeOZYBdz3jIQ=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(82310400005)(47076005)(2906002)(336012)(426003)(186003)(26005)(40460700003)(316002)(81166007)(70586007)(4326008)(86362001)(8676002)(356005)(5660300002)(508600001)(966005)(31686004)(8936002)(70206006)(36860700001)(54906003)(31696002)(7416002)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 19:11:47.0599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ed6dc6e-35cb-45bf-4f8a-08da18014bc4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2642
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 06 Apr 2022 15:43:51 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 597 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.110-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.110-rc2-gf8a7d8111f45
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
