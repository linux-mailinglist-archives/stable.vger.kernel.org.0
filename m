Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B121F4C877B
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiCAJO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 04:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiCAJO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:14:28 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65EA54FB7;
        Tue,  1 Mar 2022 01:13:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2Dv5XG8s3kqs911za5mB1nm5H2MB8O8EY+CpFKqjMgaAAod/FEj/0vw/Edvc8YNa8SDL91CuP+f3PMjRsH4FrPB4qRqTqT6POz1VsvwFlsdFJwIQN0BsHZwuGSdkufEDxUmP6jk0+kbJ7mBUmavhq+eKtoVFbhyAkrnjf4pNu+LfK0cvrv9kYsnyaH5lCRy2tXeT2SIoDDlJk1l9Pv9z9uFxAu8dXs1JnH6C5sUgrt+E+RNh+1vx3moP7K4r46hHdIxQbdsuNKvtOWd1pR+4XLs2R1WvtGxCrDcrdnGEkxH8aabikf0kB4JmqfYeoZ10JtNvr+5ZKLv2ZpBJjWKjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUhBTCFBgpg9qZusGexbbifUS3EymRRC/s3YI+ojXKU=;
 b=lgfsklZsXXqzR1tN19h7K7bSBSLDzAKlwT34qdQhPcQQFcoIPKtTQpfxuI8E6qSpR4c+wnBqCb8hLOlF7d1lM9j8A87B2u1Q/Ozc/q/oDwnhX/pnc42fQaUNc/xOw9aXl6MCNkEyj3X9yC0KbTI3E8kAi3t9b3xj+gaYqPVx3UR6/aQWvXzPiXo5wQ0Sakwmt58COatcV4KqAhfhuB4/YfulFBp9/KqHqpjAoUm3YnwotVMi53J5pbjSW9gRCgghXrOV0jeFRAZkV99nOnq8maIMK1hPipy2LHYFOyhdqd1UEcYolLfi3ypValcEpeZfuO9rfamPiWUoXHo2O/wsdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUhBTCFBgpg9qZusGexbbifUS3EymRRC/s3YI+ojXKU=;
 b=MEmhO9iccV4ySkAQHWj7qZUs1Y8bwsH7miFPea2tDWjILsjLChE4SdxUe16ZorLi/0aCq2KmMQj7eV49CBoHh/uZ+q1nPuupD+CVpydKiKorfHgMh5F2xE8nz0JzEFoGPOWe/Bk8WnsmNIfx9CWeLvKy5jYtSuigsJ2mHiKgXaEZEQN6wXP6myVAlbpErz1SkGB1tnMafkiuG65qIvVc0Wike2JsVpXYJeho5AlvGa/sczlwEvN3ao928yrCZy9zleoRAy20fPwEd3TE+O2U+4Iptm7H/YlZMU4QUUeKskcYznNHB9ky1vB+efB3EIEoCb9Fenqdvv9/D1HhE5w9lA==
Received: from DM6PR11CA0017.namprd11.prod.outlook.com (2603:10b6:5:190::30)
 by MWHPR1201MB0205.namprd12.prod.outlook.com (2603:10b6:301:4e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Tue, 1 Mar
 2022 09:13:43 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::7e) by DM6PR11CA0017.outlook.office365.com
 (2603:10b6:5:190::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24 via Frontend
 Transport; Tue, 1 Mar 2022 09:13:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 09:13:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 09:13:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 1 Mar 2022
 01:13:41 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 1 Mar 2022 01:13:40 -0800
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
Subject: Re: [PATCH 4.14 00/31] 4.14.269-rc1 review
In-Reply-To: <20220228172159.515152296@linuxfoundation.org>
References: <20220228172159.515152296@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <cc50cd9d-3dde-42c0-8dad-d844598214c3@rnnvmail202.nvidia.com>
Date:   Tue, 1 Mar 2022 01:13:40 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6d837d1-a05b-4fa4-203d-08d9fb63c899
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0205:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB02057F89475F20F81251BF4DD9029@MWHPR1201MB0205.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xfYPjS0WzKNvN1LhW+0k3g48/8z5oPFWdSfFVidJGSc5TZiszZbPJkWWMsUX1fQl8mZpuhlj5t8f1KUxtNAwvMl5M1GpKuRWEBmHcUSwk0yDUwcuFEqcFj47t0cLWi+iF49v0QUnFSt08TNOiyYGUL3dIWwr1PoBvKVqV9ZwWzq5PIKN+wQpoMaIT7ibtSQGr/vwhBF+9DS9jCBkGzOpgg3tDBjPJgq0E+a4HffGPHvCzKkcYqS0Bw7yD0B64tnkfvBzSOeUMpMXdcrzDMqu31rX/UiJSvz5knJg/ghSVAzkFtHCAWoIyPH0dtJtBbh4SBgDfYi0/Qa2P7pYiBiqKSinddKMJDtyGOjY3cSflvo7wNykCRicdiGyk0GvU+UNxemhfsTg/yMc/dXynQWl1s5lajKQp42CKqGDwXF70d42JkUloNwOOAisoJILNRsnr+0rvhHmumKppsKulh+tCwKWO0CLm8KlCUPJvfEmIyowTtaP8Ni3gYFhlgX1Q4hwpwE1fIHgZvbtf3ZT4dtzbJ73w+9tVbePza8d3Kt1539SXzOiMWJauM9HfchdDJjcawHa0FmMN9bbvsioQBN/hv5zGAivXc2fUgZQStVSSCjH48VSeGF8N1GI6ppqpmZSLgNnnj62Y+73YxUYEF/dm2P/cfHG98WhXVtgTacSMRCbzQQuUuYTCJuyi8fleY/6x0I37EGQTITkzbnMdWD384fnkFlT21Uei9Vkjt63ghrh3eZ/oruUJs0QrilOVcecvQprVR9HoomfTrY2f4FCxEsuTSH3g++RG5sLECSs7/I=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(31696002)(47076005)(70586007)(70206006)(31686004)(966005)(36860700001)(86362001)(508600001)(4326008)(356005)(8936002)(7416002)(81166007)(6916009)(426003)(336012)(8676002)(316002)(5660300002)(40460700003)(186003)(26005)(2906002)(82310400004)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 09:13:43.4354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d837d1-a05b-4fa4-203d-08d9fb63c899
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0205
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Feb 2022 18:23:56 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.269 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.269-rc1.gz
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

Linux version:	4.14.269-rc1-g43ab82ea0bf0
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
