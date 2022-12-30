Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529D3659AC6
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 18:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbiL3RBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 12:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiL3RBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 12:01:36 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2073.outbound.protection.outlook.com [40.107.96.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20990647D;
        Fri, 30 Dec 2022 09:01:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2BN5C94dj3s0X4VRSg1nmt4qDs/5KjfuETaOJ/kOE420XFIE5UhW53p2mkVXVuEy7HYv5d6C6KZ24Bx45nDuyfK//muEB2AEi3QS26ZVNDVqsieUemRKCB6Gv6iuM2Di60ufJGb9eImBQ/DGBsw1sGfa7WeXAAMXX7NbkvxYG272bxe6Z2Abiv/8WpAzbPy7q+vLQ3wXuMCxePodvfQ5KaLvS4xNDoUVoFA1ueLuDJU3++4BEN5gn3791EwZnVPv7fPZJJLcMbTGP4dryl7d7KKsVk4UJOKBc34DCyb1p2xMD1s2YecTsicycu4zh5dKXXxt3iwdCxe0XxWx0Do4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NSDljnpU14brkfm81cLAac3jJvyyqi2h7yVEIhvdunI=;
 b=TnZbvkY7OFZgZ7SXp+SsA56FJ/g/rC6Q9RclgkXI8oHEJLJkpWS9ai6CYX7GlBmT25Hwh8AU5+rc3VHTwJ0LnLXu4p+tY6stwuW6QLudAfygWb4xqJcKadJhxpyKUNGww4fxrH+SX1Ok1SMNFammylJ8B0Bt5nFVVxZFRBVVELqKd6GW4LWCOQlrKP9av/XCs/y46nwXcK+L0pckkgHroINNLZp0tFNVhPc5rOiBCd4PA31kmojSgD1ywR+LP1rhH0CaQ2dVpSTFHJHT5SA9NSpEUTnKfk9GJXrMNDKvmSRxpJf1UAcTAmidzeGq5bQe9YeyLl+0uZnhEU21wrEEiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSDljnpU14brkfm81cLAac3jJvyyqi2h7yVEIhvdunI=;
 b=YrsWp3afDYEY5B8j9ZCY19Pf2X7ncPyAm5jrm+4bz+uIkasxXwOehEgzhSRNYaLG9Gfhh3FoGRxhZf7+jr5wNI27zZ3GsuA9esGAJNP1pzYm20Nc0KlQAU6fuYBPzroPrznCLHrYESFzhIbZj1rEEwOG85x4bpyVnbvD5/qUM4C0gR+wCQZ7CIU0AngAInRa25w64UaZ/U6IXtuN+Ei+Cs+GAC0MFrrPICcYjK5myy5gbd3595dCu4Ju/j5d+CqegHkNGfyhVBcajpOV+q7B7qSJJ6EjwTC/IK+fbDgvCX0cM7Mfp98LNm/9+R6dqPHaygDJ1/SnidtjdbAP7eOWNw==
Received: from CY5P221CA0028.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:b::43) by
 PH7PR12MB6833.namprd12.prod.outlook.com (2603:10b6:510:1af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.18; Fri, 30 Dec
 2022 17:01:32 +0000
Received: from CY4PEPF0000C97D.namprd02.prod.outlook.com
 (2603:10b6:930:b:cafe::23) by CY5P221CA0028.outlook.office365.com
 (2603:10b6:930:b::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5966.18 via Frontend
 Transport; Fri, 30 Dec 2022 17:01:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000C97D.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.8 via Frontend Transport; Fri, 30 Dec 2022 17:01:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 30 Dec
 2022 09:01:25 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 30 Dec
 2022 09:01:25 -0800
Received: from orome.fritz.box (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36 via Frontend
 Transport; Fri, 30 Dec 2022 09:01:21 -0800
From:   Thierry Reding <treding@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <rwarsow@gmx.de>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 6.1 0000/1140] 6.1.2-rc2 review
In-Reply-To: <20221230094107.317705320@linuxfoundation.org>
References: <20221230094107.317705320@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Message-ID: <c040b325-150d-4c57-8075-46c6bd6c5b83@rnnvmail202.nvidia.com>
Date:   Fri, 30 Dec 2022 09:01:21 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C97D:EE_|PH7PR12MB6833:EE_
X-MS-Office365-Filtering-Correlation-Id: bfb83e1c-2964-4cd4-c57d-08daea878079
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GPIouBo8RwNQvSN4yphr6YJnDmb5C7ehN3DnG228dCnBSLMMVvQfxu/pZKSFB/sYYEBf2QV6XHu78docNKSrJ396qjKQnogh9AhrASE0Z3thzQIuE2oIccWGidzPIslAW2iFVIajgu42PbAq/tqe1KEnPIvVeb4OXLQt3RD1T/rsMglNgAI3wbq1t7QUiijNChAgZu3rqBVE7R/dZCouvv0xqAzxsCCSvpfp5+/VkRbW+pQiTAIS473DBml5aHYSsTbYLkRGFJgFSjrlPmWHDmhu5gmdzOvZRIlz5IZ0StOjbzWfESI3XVZUV9lV/h13uTCqe5N6rFo8BdLBYFbNk+HMsJtZbxo/7/K/ysjId8Wce9VGJYIDUYLKDtdDdTtbpIM461516EuJCJiREgIl0SOcfv+XbR4ZfxzGGKGyr4muKOF8OFov7jQF2MnNQ39Vp4vvJ390URBr97JquIWoOLa6UA2njfQVJhv0wCOJ5SZ+BHqI5VXplpSap1C1OJ5nlMRCERoNlUyeS4lh7jXuBAXDr6pi8w42tFnTOAuHblsnBWZLp6dyI8mBCwu55xFuQH6c0ErnFQ3v4voFPVV7WvEqiR4i2YRoK8Nm6WXQrAmM9f5LMMOFmQgUCdU8Y44uStabEESAT5bI/h0CGjOM9XD9+D0qkN3kCKeTVMQLUdxc1NLWgIC1sObsA/kJvDac68+gQ5QMj5r9K7RCdvJHdhV360laii068G6Y9/1A5OXYGfcIP8qZ2HMXgBQC2sWqymMXguWhSJy0GI1zuSmA85Daqvq/zSAysCvkbRFJky8=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(7636003)(2906002)(356005)(82740400003)(8936002)(5660300002)(7416002)(41300700001)(31696002)(36860700001)(426003)(86362001)(47076005)(966005)(70586007)(70206006)(54906003)(110136005)(31686004)(478600001)(82310400005)(40460700003)(40480700001)(4326008)(316002)(8676002)(26005)(186003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2022 17:01:32.1732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bfb83e1c-2964-4cd4-c57d-08daea878079
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C97D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6833
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 30 Dec 2022 10:49:32 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc2=
.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git l=
inux-6.1.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	6.1.2-rc2-g9c94d2e408ab
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Thierry Reding <treding@nvidia.com>

