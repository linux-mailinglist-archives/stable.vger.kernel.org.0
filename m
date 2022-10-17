Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8214F600BD1
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 12:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiJQKBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 06:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiJQKBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 06:01:37 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2083.outbound.protection.outlook.com [40.107.96.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87785E567;
        Mon, 17 Oct 2022 03:01:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9LsSLrG4H1Dmpnw33/OK42W8p3Ec0jES7RrdzxsPO3hLMsnvb7BgavfEElXaIz1C/mV0WwzF/D801SilNx/XvVJb7bJC5luyFtBL5q05wyF+iHQ/jYIOCCj/tjNU/TJSGA0XDNjQ1u4KnoBqcLmp/NeqHurBNAnIf2HcWgDmg4WhpcPVviFsd7RxLn38tMiL/HXJiy8Fh8p3wwGEKgyom7d5rHte9X088jaVrtlHGeRBo0dpbRen8kH5JOiVMx6qUFd0W138AWRHf+jdq+OYh4lIhzZcxzhrItWiJBgDStgMxm/pp/MAt1hJ7ZVywWBxp8xiVtZUIiAZ4G6d5Dwtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLLQULzJg7/mOuPU+X/lWNjsizFePMvupZ0RXYczpIU=;
 b=Ic0b1KK/RAvQ9IPCqcqw3+1q8gKcAbzbeviy+Io1xlQpUh6nDm/Azcv6f9amt/h/Dffk6UZAxlj02b2pcUuZpXr0jNJ0wLQfojc53SpvskJjw6qpnabCHDGObUyfkoFuDpDuuiSS9d9X2B6W/+tZzrxzcM7EYKvvaVSlfbL2SF+McJ+0+6Qu4WiWEvPF1kz7ou11U5Q5vpahvajADaK4vh9O/7ApjOSQRpdOg6KSZdSGG7odaAy36Z7rdRYwUsvHFDT3EoCZwvNick2UaHzL1bfBweihTUkKuptFjksSxEojjkBRnruY5dnHaMYViHMaiVKl8UvBbJSS1pmYVAkk9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLLQULzJg7/mOuPU+X/lWNjsizFePMvupZ0RXYczpIU=;
 b=KujudbESxKukkhrbrtM45M6aM4SsH6axszhnE4W6dNQtmDL984TL52QLHhB+RhhSIKQnIMyurjqx2SgQQE0tdEAPLKGI9r/q0mr/AW3nuHT0+u92HYu+mgs0tTFJyYjwp7yEY3W+q6j7UWloaUap3r7kQ32jElvWwmCNU0LvXUfMf4D+CJjxXjUeDW/xg0vKHGtzWUSHPWacS/muxl4IWkICEAXCVHJKKFPk1syOIKCyP3Rnjx1R4MjAOuz2qPtgDLzpNHs4IU05i4deZRExJ4JTlKYl/qYsdQqkZfj0EX5IZWEzCtM81V+fVhPST3gg3CTP6iTaydCVaK/VkcaKpg==
Received: from MW4PR04CA0132.namprd04.prod.outlook.com (2603:10b6:303:84::17)
 by PH8PR12MB6890.namprd12.prod.outlook.com (2603:10b6:510:1ca::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Mon, 17 Oct
 2022 10:01:35 +0000
Received: from CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::b1) by MW4PR04CA0132.outlook.office365.com
 (2603:10b6:303:84::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30 via Frontend
 Transport; Mon, 17 Oct 2022 10:01:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT082.mail.protection.outlook.com (10.13.175.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.20 via Frontend Transport; Mon, 17 Oct 2022 10:01:34 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 17 Oct
 2022 03:01:30 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 17 Oct 2022 03:01:30 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Mon, 17 Oct 2022 03:01:30 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 0/4] 5.4.219-rc1 review
In-Reply-To: <20221016064454.327821011@linuxfoundation.org>
References: <20221016064454.327821011@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9643154a-9f3d-464b-a981-5a0e7b2179bc@drhqmail202.nvidia.com>
Date:   Mon, 17 Oct 2022 03:01:30 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT082:EE_|PH8PR12MB6890:EE_
X-MS-Office365-Filtering-Correlation-Id: 5035e081-9b56-4a53-92d1-08dab02692fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AhzpVxHb1GmvHvwmYBo9ebvBK+sF3zJpBXcsAbxxI/l+WSeyLzfUvF0wmOedrQgvx9KkRZtk1zqxq0jh+h332SZo7dj+tIQElYY4EaHaDH8g+g02xY6f1Qn2UixEtqcQy7npj78gSXD1LnG2iTDVJRqf41u142E30BIxydYnO3W/vNsv7ltWr/WAcXm6oTzMAOJtVZXbDSmwabBZPoDGyaXAvyVb2MsxJyniIRkoGhL1MxvEn3STGyvHjxg4wYrn4nlGZel+7OUojZbwJg+VpCbpujxda6oEuvBK/Ohq77ag3JUsvpbQtS0HtFTcpo76nY5eucRS8eXKO/Hvh15rCo3Hnj5GPmYSyPznn9JKdsyBttBWt6eVr3bLmN5CXSkOUZHXGwM9+/g9K957dO904a6TEG3YWJY2rrZzbP4Ie9mlaFOTJYs8IqVKUuxJAXYSkjtsHWAC683rc6dtgVtxQxj02yHy/9w5w9mVbSC92IBfZwTlLFopuaviCJ6vOy06NG6pP0VtP4c3SMzRPdJAQmNaF5dyWSJSJhEF2Tx5gOHC6zCvlW7as9lK0z1wHu76ZG0k1suhk3r+0F6+Um+uu8eiViBHhtdffiPE8x8Q4Pp+4L2vTT7xQ7KyHMbjtaSn46NiOVthDNNWs0/cqVkhdzvKU4FZdxt4pII1QpTtmJDa4Be2cNVQmCEjBwrWWm0oJaC8U7NgLYRUApiCAaaTLxv4twytyrnZUefdjXvAX/5N9dERn0pklvEEPjiHv587FDMAAxVtsTz+iu4o9jQhD9j8JebwI4KFQo5tFMPQCvtJXrsG5wy3Br0c6hMO7c4Zhg6+YYKNtsxVjBFhCT7c4H42aJlIrRlVm5OR0qQx1h0=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(54906003)(47076005)(336012)(426003)(186003)(7636003)(356005)(31696002)(86362001)(36860700001)(82740400003)(5660300002)(7416002)(2906002)(41300700001)(4326008)(82310400005)(8936002)(40480700001)(8676002)(40460700003)(478600001)(26005)(966005)(316002)(70206006)(70586007)(6916009)(31686004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 10:01:34.6549
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5035e081-9b56-4a53-92d1-08dab02692fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6890
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 16 Oct 2022 08:46:22 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.219 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 18 Oct 2022 06:44:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.219-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.219-rc1-g5a1de46f7e74
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
