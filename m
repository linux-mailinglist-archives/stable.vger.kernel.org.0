Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7D84BF7D6
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 13:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiBVMIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 07:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiBVMIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 07:08:35 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2044.outbound.protection.outlook.com [40.107.101.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDBC9E57F;
        Tue, 22 Feb 2022 04:08:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cj9FKvFnEB0SzwFkiQFwAjxz4Tjz74HwkUNu/EnH8KKjxjwqvJzG7bFN32Begc/PlOZdmLDqZn5e4qiXOG+3F/lRejxq+e8I2R6UPoEFbwfC11gjsoDQfj9CaIiqBO0yqwVMVCccgRf7JYGt8aIzhREkNe5XDn2hkdmezHKF5HHsJp+yAnCSaOnTA1lwhgCSBK0HPDwF/62xFgTjAI9u1jITrKW/LVp8Y6TH/INq88dtenn2iM4FWNbJojaTzr+mbMzSNav9ENqfEpKUKQtSo+EWAXsgkovoCDE4k47U0NLsWJrXFyIYZ0J8fEbkQUxqXv6zZJUjA2i98raASYiF4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oLdD1MnRznB/3Q4Df6wIUtx0tg0qI6nCFDLgk26xuow=;
 b=aNIhvKO0N2shQ08/QG3Fu1xyjUi5AleCQdNhkYsvWNYUkPyS3p8wRAsPu7c/CLR9lW8lJeCqosF/7MRYWMpKUyQ1wXdOVsC2C3IxfB+xZdYSYmbdWOc1+ODVFFhdQbLNSqR8UTlEYyFp3E+pclfn4gtZBevBcpfbFmEh5Dwc2feMXHxbD83/l8BA+hZd9v40+OBnd6+YRa5M+HG+IFSicjJj2eIb5+mIvXSqGX70B3ivGWsgmcVLYYbU6LluzErWVS8F2+aNk5gTHIb2ksFhITAJpx6cv32aznWFQYXibCS8k7MbXKm0lHjJghVFz52h9zcn4lmIwKX6O7/+Bkl0GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLdD1MnRznB/3Q4Df6wIUtx0tg0qI6nCFDLgk26xuow=;
 b=S2BChB4zEuLkNV5gPQdqoKayWpSZExYTiFFH2T0pQd5KswVu1Rvt+T38ANaLh1xfku+26DnVHdlK/qdEABm6MMv9NQkf+WLBnfcowNFxjuAkypxhmjmyIQEmbabTE58s8S60TB48yUQS8nHsYAig0UYFTBTVdz4LMfHrNb3XIMBHr31AHcnx1WhRHY7eHIiOJMB0spMdVpU07npVZehiHMqXkfkkc8YMKoMGCjO6h+MgnaNkg2U5WSR0k22SdCxPBxi9zKaaW8BtXMpeHfkj5qbZjfWLxkuKG0BnNQvk4i/u6zELDmmATcyO5fa92kugThED4grl0LJOnuuJKGIKgg==
Received: from BN9PR03CA0438.namprd03.prod.outlook.com (2603:10b6:408:113::23)
 by MWHPR12MB1341.namprd12.prod.outlook.com (2603:10b6:300:11::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 12:08:09 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::4c) by BN9PR03CA0438.outlook.office365.com
 (2603:10b6:408:113::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Tue, 22 Feb 2022 12:08:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 12:08:08 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 12:08:07 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 04:08:06 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 22 Feb 2022 04:08:06 -0800
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
Subject: Re: [PATCH 5.15 000/196] 5.15.25-rc1 review
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9c9116ed-6a6c-406c-9831-480ef055b5cf@rnnvmail202.nvidia.com>
Date:   Tue, 22 Feb 2022 04:08:06 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e85980ee-1a2c-470c-4730-08d9f5fbfd77
X-MS-TrafficTypeDiagnostic: MWHPR12MB1341:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1341369F7E48054234857638D93B9@MWHPR12MB1341.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UyD+DTLbdWGhJ4I3BV4k//5p+VM8djM11NzDnsnL+q8VDi6+i4TNef8sLcxdjZej6Dzm7LVUPPt50NF25BsA5Sb2EnVMvll0s/p7+HFRGX4LV38vBGAz/MYx3zDNcv5nSCnXrYupDP4btLeZBpPxc7RinNtlk28khS6bT/w+i1mAo0J2N5dJIx5O9hYskvKmhgrgNE8jwI0jvZffThbu6bq69PVHsuRnr3h2lF/F94BAK6hQdO6OmvEjmrYk0QZU45YHGrcZGSCuCQ6mP9Eqh3/cxIvh0wzV5xvAMDUC/0G4hhlxLDEKSAOAEnmKpV9iDb1G+2RMK1U8iYuYq0azkV8gbJGSTTFXMq8DixooKWMNswrcg8poqC9mx5ADNUMP4B+Klp9BEiXLyH9BHrlJdi9Q28/EWNXUo1JFlbxkeaL0e4hA8ytQvgbbU4p4lO65JR171pqa8eW9MLANIzRH5BC/pVdkSixXHv7CYRjvsJ3hTtuIJNn0k5Cbw1O48lvaxQvx4XJtpyC4K26nZs8hOlwjtaOhor/gZctH/AMLuLQo8t+Ettn3EUfUODv7c6tjFpKIibTOinu9tsvq2e3SVRDFcO+liRUy8UsV7/LgRu0XiCBcOl/Q7qbIw4clthCkq9B3Msu1p6PdgkCpzJsFJgMAxkffOw2jI0IeCTsZf+bBel9ylSv8JmEu8mpxdUZGI43KNxFQNVl1u2t/znzW3qCc195JnIzNRwO/LG3WG4bmQtPI9FBDuRLzfpFQLqOKJp+w+9fNvOpC6F6EZiE1e4max8jAslUIa03+rH2gSMc=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(70586007)(81166007)(2906002)(70206006)(8676002)(966005)(356005)(8936002)(82310400004)(508600001)(4326008)(5660300002)(86362001)(6916009)(316002)(426003)(36860700001)(336012)(31696002)(186003)(26005)(40460700003)(47076005)(31686004)(54906003)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 12:08:08.6122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e85980ee-1a2c-470c-4730-08d9f5fbfd77
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1341
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Feb 2022 09:47:12 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.25 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.25-rc1.gz
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

Linux version:	5.15.25-rc1-gcfc9ab013281
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
