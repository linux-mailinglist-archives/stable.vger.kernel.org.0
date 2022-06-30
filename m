Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0045620E1
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 19:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbiF3RJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 13:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbiF3RJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 13:09:58 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2043.outbound.protection.outlook.com [40.107.100.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D218B22509;
        Thu, 30 Jun 2022 10:09:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LyOOGJzAnW1ZSc9lDAvsPRY9RRyVtocR7lO5ZQ6s8nyOP8oHYXYbgTwTv8/2Q8+ilXSVZctnUHuub8AN4zondGRWiPBHJt9Aed90l1Td7teauy3w37Kp5COMz7EA1KiTXJzSfdg06y4+xmv3tx7Jct9al1YZZKSyycW5YnJMYxdFwjtWQ99f3h5yCkkFvxHLqyXVSqyVYlAm+LluuZBHZBJIIhcOpY2VvNbtXzZ5A7qEtCzd/tyQ+GBh8mJL7HCY9D1zpt7XaYWWxhUsme/dKnA22HS1qAgSJEiUFaGmbpoEWA4W/v9VwGxllSDSgksVCRF0UwD4cT4ByT8HzjyZ1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MkEUwaz8OPMh2aKIyOdOsVm+jIJxjxZ/BYtP87I+usM=;
 b=lVG0jFjs1herkH9YS/UU37/56amvX6xBS2Rkpmtxw15UYv64FAp1Bf2fQ1Xg4snbrkyqKaM/+AXDbcm2Ks9JAPS2xABeLqN+x7u67zcnkiaM0w6mRCM2lztOc9xDnoHe/VNiku6EYHHtN3IuEhruQn2sScWBGLyh8VzSHE1zPmyA5Xn4eFdw9ZlNMBNCp7uqDT+SCm4AsfvMBQ8kNrcliUQl7Sjn0+p+GK3HiR56e7Xr2kXFTgOcBvDNzp+gV5KXbKElAhNbAW4Nu+I8dNRihCUcbwVQi7p5Ma1eiddwZpJrXGb/SOfIB4XozPeHzA3UXf3NVenL7VOfU2UKrIBE6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkEUwaz8OPMh2aKIyOdOsVm+jIJxjxZ/BYtP87I+usM=;
 b=CYlwIalr5eg+obNMz70BVursoNv7x4yeVSRjM8Qtvvv5hUuvU7LoMuI4BFt4yBo5kwucmSSpu3vHBhk2EqfP6Kz1VTcu+WNjzfxNI8uuzPcikLAyUIwH+rpwIZiPVDCyzdpFKgdCDSxvu/RLLZp8Ky4xDklAhnRp7+2T2Px0T+GvreNSmoE5fgoIl8xLBGzzfCV/9HVxob8hLNKjL4YoF40klXzQFQHj7NfNBEAplHdYxJlP0Z4svFabekOwdNJMgbCwRaen7U+8sa+6Vc4/iCZDHnG/nVwVJxn1F6SEHQXHvbjBIrJZlK7bIXyHHiX+MAdI+ojSi+S4Seozf5JsEw==
Received: from CO2PR04CA0129.namprd04.prod.outlook.com (2603:10b6:104:7::31)
 by CY5PR12MB6624.namprd12.prod.outlook.com (2603:10b6:930:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 17:09:55 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:7:cafe::b5) by CO2PR04CA0129.outlook.office365.com
 (2603:10b6:104:7::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Thu, 30 Jun 2022 17:09:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 17:09:55 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 30 Jun
 2022 17:09:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 30 Jun
 2022 10:09:53 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 10:09:53 -0700
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
Subject: Re: [PATCH 5.10 00/12] 5.10.128-rc1 review
In-Reply-To: <20220630133230.676254336@linuxfoundation.org>
References: <20220630133230.676254336@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ebb93d29-abee-4693-a52d-20e82f7a7e11@rnnvmail201.nvidia.com>
Date:   Thu, 30 Jun 2022 10:09:53 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ca0ac8a-461c-4ed3-9c22-08da5abb5abe
X-MS-TrafficTypeDiagnostic: CY5PR12MB6624:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mQhz9raCXZii7MiBddq4KJEj+oj40X206eApYFXSGIGVIUT9SoX2Fsi1YB5JUmuw0Ze8TW7R801pIloHJDTmC/o+SBykC3cJoVj0kjWgi0LXSczB0u9Dz6fWRq7FELGOSSJfA8yb0reaItkEo+BmvK71bQFKIcIqIhmnfAAURgmSFRiMobNpFaF2mCKzv7Bbg9LAcvZUmflQ8+xL93nZWknCSCHboDhLX/wvbpumOd7LJp/SklFdV8F6/0dNyPXMXApvn4q66AN8ApJCG5bW9XFxvrSkbmYsb9cIgWimONFguEZEFj8FLIXaFGMw/XbZNHH0HCbafae/Etjx9dFNZilLupKSBeU0K0Oileb/hSXJ15WrK2eb+Nib7nQuCzC2e75KzaG9J047YDaCzQLTjaOwHJWPTrNG7332/FjuWRuoof2WRAr3cBu1OJd8ESKiz/j3IlvPgehesdvmPr7MTZEheXVyxghT4ClvY8f2MLr5l/sQfMJAZ0cjScSZvqtM/Is0R96GlIQYIlPr89VYJxlohcppHWrMEjRlIj0i3c0Sejd/k8vmQn2vI4/75l2S8M1jLS/EKqi2wJ8XtFHcUnZbtmD/lGnsJXzGnzWNW/rHMSmOCfJ+v6b8BN2hdUYPhMKgV1A4to7CAnIqxTd4NKs60+pArGk7e7lUEUa7Ky07B6X+YGrbVuNBynZMLfM4c2NEd7xWCXNe1Hyqd5NCbN4voqs5eov95iMNPkNKhXS97AWwvfnrPLcluykAXlklUu7GCfFQj65zaR5As2AvjY5rjXztxyB2/H25Ily0apxOf7e7rM1ZrbXNLHtXc8e4eQcbaB6Y9cQSBxW3t2erbtML251OrrNHTp6YNZXoByCfRqwtj7pNBRDj4ANuJKsXy8TEIrMGE39ScWF4pYxNsifwxmKJkYrwXFVXurF8GDNKbEWPqj9l2Azu87z6cTFr
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(376002)(396003)(40470700004)(36840700001)(46966006)(966005)(478600001)(81166007)(86362001)(4326008)(70586007)(8676002)(26005)(47076005)(31696002)(41300700001)(31686004)(336012)(6916009)(316002)(54906003)(186003)(426003)(70206006)(40460700003)(7416002)(2906002)(8936002)(5660300002)(82740400003)(356005)(40480700001)(82310400005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 17:09:55.3078
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca0ac8a-461c-4ed3-9c22-08da5abb5abe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6624
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Jun 2022 15:47:05 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.128 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.128-rc1.gz
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

Linux version:	5.10.128-rc1-g929b4759e471
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
