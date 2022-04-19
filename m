Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46AF506C3D
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 14:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbiDSMYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 08:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352245AbiDSMYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 08:24:47 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A95835DFD;
        Tue, 19 Apr 2022 05:22:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TomnvYEIOHP1fnOsP96F2IUzNEdx4e+riBCRQINgbPsLovWGVqRpj2z821ObBLDrVyHyVDgSCFQqHIThAvtTT2Rb83QN3y3h0fJ2nSLI/QawPfc39FwkNg54Av+o10EDuxRLha/bdmVEnaD9vjoapXFKwTG+77JBRO+SixIe/Y0hyKtCprb/FE/JAS6/Z7jCnLOMwymU6BviR4m/4dicfTURWN5B0+70PqZciXxy7lu7/vAkTk5vE6wWAJQHlS8VUSUWZbRqLhoBqiftxbJXKBv07xqhWXm7tOxshS+UDxiYF5u59om/eizqNdSAmV1UwfgJYkKuLLHsqAnlnNE8pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sOgSjXnUvGoofdj8RlWCykO+O+9iOVMRwn1yofrMnCI=;
 b=e+vSlOG61Pk5leEilriFb2Gwj+irZL3+oMkja82XNBxX4h//q5hDh3zqbe/88PItzLJEBakpHwKrreta/37+6OT6WG5EHQgb90Dk8P2I87pZw4Pa/8nWFxCeCVNjCxm0nqHZ/Dw4UeVZe8Ib1adoo7Pqs7C72/H6sFmGUqjSvavn1v4aUc8HlVUdZTUxU2rcx/KHU6FBV7N+Y7V3cx89U+oIn2RCVaAKvlxmi2EuMi57kv1d39jMwcShh+7BTVpnVg4iih6WXz0odbuDJxfnm5Lfb2wEKVzJSVVqpv3ACjQkqGrFCmwuzj7Kr8/Kq1Ha6D6SB61LN+LHOF1pQbsjVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOgSjXnUvGoofdj8RlWCykO+O+9iOVMRwn1yofrMnCI=;
 b=GyClQQ88wBosdqcLOTxfIw4vMDl/sHTpj2LAQWHiABpCkKz2yQq9toTbufxCR7Se8WoP9kbGauXMt4z4sBiYzmmRHrRoaBgDoklnnkAP+21ohxu6O3jUU6Fv6lCZhKz90ccLgz9pTOboOTw/q6igCf8+AfMNnmX4L4V5NFUTDJzMY/CiwZyuqUFGEZgWVIAoY56ZR57RihVedddwdm+o8WOxCwBKp7Fai6AM6W5cU/PlHvOf3HHD6nM6kjzgBx8Qo8VEnFicx45GEXxIUMwJUXKnX1Tt0Hn/CLc0MtrU1JF8vUavA9JLc9XI7pxzk0yoLDmVDZx35UIVvAf+ArFAtw==
Received: from DM6PR05CA0047.namprd05.prod.outlook.com (2603:10b6:5:335::16)
 by MWHPR12MB1407.namprd12.prod.outlook.com (2603:10b6:300:15::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.25; Tue, 19 Apr
 2022 12:22:00 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::dc) by DM6PR05CA0047.outlook.office365.com
 (2603:10b6:5:335::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.12 via Frontend
 Transport; Tue, 19 Apr 2022 12:22:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Tue, 19 Apr 2022 12:22:00 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 19 Apr 2022 12:22:00 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 19 Apr 2022 05:21:59 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 19 Apr 2022 05:21:59 -0700
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
Subject: Re: [PATCH 5.17 000/219] 5.17.4-rc1 review
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8a6ba3d4-8398-4994-aac1-8d46c0efe0bf@drhqmail203.nvidia.com>
Date:   Tue, 19 Apr 2022 05:21:59 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 745dfd82-1eaf-4c9c-859d-08da21ff3482
X-MS-TrafficTypeDiagnostic: MWHPR12MB1407:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB14073A31D20D34A1C5F44CC0D9F29@MWHPR12MB1407.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p7kHlZlZG30FOEIhCSHkR1ur8XMRey31nVwMe+ezHQucjdYuTKXH3Tp+4lde+Kgx20ML/ezB3opr3Hajjf+wxgAWBRR81EAjuZz9Zu9vLHNkKN+Z1zejJInzKpJEg8U3SE4Iww9gJM9ihh/FD9eSFDRC3cl9JzUfUgAm599ocP2+DkAwgxxYbTE3c68OOJdoBA0usj6F9gIOCge4wgcrlOOJ2Ebgxw8aMDItUW9sRlPY3TdhEo5jCeR9ShEOhwzm0yVjkirPASIYsqegJmhrwQF56Fkf/ZlU1ksVJ5GmfLxCM48BgoDWr9QfVoUv2EKjI6k5mAWDebHad1J0LNfuR8TjxWb0Fw+HNPgESmxTTYwWffubv/Jw2wfDZuxZr9BkR3mMc3UPzDEvvfvosm8P5vrKQFBf+Ec9Flp137fmhCPOqgNvl2KRXuqJeeBOFNo5iEUGsJdTQx5kIqmIUrwK6ATZD4rSk5X/seE8AC3jP+/Txz4+OHF4xZoqLFZpgK3Y0vHde/phTnKtXLRlOKjr9UBdFzbMtN4roJt/TgcJDjcPpHkO9LwpLL4x7RJeMFvsdiUzc+gzrG9wJO3q3wObtkRoO8EU0XTZHWvhGzmutiozZbk051K1mLD3M7vptyodfiYqqVR6TpXe0uNxGZjU+j1BQVD92UqSVq4ZNC7SAjwHiT67NjHpv1iNrp7t5a+TPGEoQHCCm6mricFZKHRLgYHW9o4nU40dpPa9fB8FaspkuoB+mJdIWP/hkhf13GvuEt+7ajVerBKxWHJkd0ABk5lqh3Z2ginP52pRko+DNPU=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(356005)(81166007)(54906003)(6916009)(36860700001)(31686004)(4326008)(8676002)(40460700003)(70206006)(70586007)(966005)(2906002)(5660300002)(336012)(86362001)(426003)(186003)(47076005)(508600001)(31696002)(8936002)(82310400005)(316002)(26005)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 12:22:00.6442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 745dfd82-1eaf-4c9c-859d-08da21ff3482
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1407
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Apr 2022 14:09:29 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.4 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.4-rc1.gz
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

Linux version:	5.17.4-rc1-g12e5bd3d0676
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
