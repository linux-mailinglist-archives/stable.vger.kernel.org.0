Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4878658417B
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbiG1OfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbiG1Oev (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:34:51 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061.outbound.protection.outlook.com [40.107.102.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC9A66121;
        Thu, 28 Jul 2022 07:32:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b4L6KvN10zXR52ywOEWIyM78FNz650wgLcZaexueQzzjvOi+x9Nj96hlzWfFH/8HwqFvziwnuOuZ2UdZhbrMd1I7gVm8/ljv1yg+6Im7XEhKa1QXoh8jGubk0LmFPg4RXH1flw8z7/JsS9LV6MKfpzbCK3J5FSO9OLC7YvTpJZNx5bdjCqjGVboRP4bsp6G0lIWj+3STzO6zeN0jLqNkKr6t6LpCzPLeeVfsn+8sFkvIJpla8yf46FN+jCGD0mkuTVr+EH/b97aVntRTDInu6AxP5NKZrm8KVwyrEvLmVQ4fI4thj5JA0GgXh59iuUhSWSg8knZfN5kQTIBhytUN9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ma9rdWX4Oxi2oG97DkJNUOVYYqkXxnqlKh0e5ccmDR0=;
 b=KGUyY6qIHFagQ7GHZt0XcpPGA2UIalcGQRcoU6mFyPoCc7O6FueuMYTGc74b3ptzQMXLfMs/Rq0QNH/GmENdX0o8iTrUAYsj5SwSt3YaR01syKDHMT34T1Xd4xIA9oPyH7+dp58BsBR2/Ggc2Tky2JeCgSP0TojBS9fxPwyTbF3QoHccIdsrFIn5vbZjJ54n/d42VfW22IUzTcGOYxRm4JSUIg916+xoIw2BC0l728gUVj2C0xPuLJ9HZBamWHOVQztDhFa174Si8qgby+tWUyTxvdTZgkiXQOIknG8/CWi+TVoeKDNTe8EfY8JgmSMfI/Hxfe5eojj8w/77SZh+fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ma9rdWX4Oxi2oG97DkJNUOVYYqkXxnqlKh0e5ccmDR0=;
 b=O7vSncS9LiAwZ8b6j6uMp4HpMxjcaNGzZUKoP+8p2rfyCoY1eTuL42uPvYJL4rKcIla6kiyM49e8OgBE2V2+WayK35b8g9xoU8az4Tej+rYn8sAfk+sMBwNkr5YA/tlJ5s7OXsjo2tAxzMlAqf/JWKMPKzhpM4dJ0HxOvSV1wLCAwdeEo5L3kXTdmifAtWx9uK2I0XkGKBT1kwXiqwwlWbhAuSCZI0R27AbVmcilDrWgcr8e6KrP9/ltDJTVaAzLlDJOv2yMTfw1eFy1NA+p4q4utQy36c/sD5NOv38q41GJfZyeaytpdG4bQPx1iEywAiga2UNHn2hRCTZuoumQpg==
Received: from MW4PR03CA0128.namprd03.prod.outlook.com (2603:10b6:303:8c::13)
 by PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Thu, 28 Jul
 2022 14:32:19 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::20) by MW4PR03CA0128.outlook.office365.com
 (2603:10b6:303:8c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11 via Frontend
 Transport; Thu, 28 Jul 2022 14:32:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 14:32:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 28 Jul
 2022 14:32:14 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 28 Jul
 2022 07:32:13 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 07:32:13 -0700
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
Subject: Re: [PATCH 5.15 000/201] 5.15.58-rc1 review
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3ca51e8b-aaea-4cbb-86b0-d5d21c227186@rnnvmail204.nvidia.com>
Date:   Thu, 28 Jul 2022 07:32:13 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efab0101-f306-4cee-29c6-08da70a5fa24
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3QFXffX77D7/fd5iuBSU5eKJd8JaDc1vtRQqfNxXWm2oR8dC0tHZ4a7YSLFLw4J5NqwUrHAln0aY6gfhOLCwcziIWx5uk+YOjZrRUwqUCcuazhpzT6eqkosUU6Z2TTDCH/yX8aPOzikca4RXAOZJiAgHQIxdQpeJv1XFVWluoyftYGBNkBnV0sXFmZMt6/0fLHtSgehDTeXDJB1xmwTbqc2gJ7LZYYXd489xUirXT8luYMT4hcLgCCKPSUdXXHYi+12QIdpO2fQ4TWSty375cb5M8JjjT94b5UBX20UbdoK4MEM6R3Ogfq8PpBbJ58BTLjJazN4Lil4geD6vf/2pKCpPTdzj/dEQ8tst1arWooMCzZucEhhP/QwSp9tw5AeV0b8keoqFSEMk6sFdjV0TcL/DqYH8Ibwpo6ttxFMylGn8/E5OjwvvtpeVJKr2Sz0XFo/NGjRihjn71dRoUoEv1AKCx5BcYrlSFk0Yw3yaRG8zRsvhnsZ26Z2eN0KIHyCqphPNRH1k8vfxYI2qiVCouWaghsyUzysMRWep0z9lN2s8ocmmC2Bq94WPxjb7lyPvwF3rmF21J24gQsn/NaIPnjSmyAb8RXrNYxDCN6yvDiG3fXvX6ByYu4mqjd5lHE1MMMs6Uq9xt6GGPtzFI4qhS05x8YFERaVDBvzUbfV7cvTYra/WmtS7oA7jdDVP3B6awGTtgpdMIlCVDoV/hqYnHx5xwIeo3JPi4k7mCIoTrJJgk5dWU+cuAnWOBJ/G6uNlKPS5Snje3ZF7lRpLBuafek7nhk82a+faACbFh1tJJSKSYE088SaigvtORidyWLWFdhxTFRgrOrsbFYVxEoTmXeskp+zfPxORj7A+9F1QOR6S5hZDEvXzJIDlDTuQQowlcYQTbd1ATmhuK9rAHMUUiH/WXh2lObZYhLV29KHH+9k=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(136003)(396003)(36840700001)(46966006)(40470700004)(426003)(82310400005)(26005)(40480700001)(41300700001)(5660300002)(7416002)(31686004)(2906002)(31696002)(86362001)(54906003)(8676002)(81166007)(70586007)(82740400003)(6916009)(478600001)(966005)(4326008)(356005)(70206006)(40460700003)(316002)(186003)(8936002)(336012)(47076005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 14:32:19.3216
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efab0101-f306-4cee-29c6-08da70a5fa24
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5685
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Jul 2022 18:08:24 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.58 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.58-rc1.gz
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
    106 tests:	106 pass, 0 fail

Linux version:	5.15.58-rc1-g6a9b4e0a656c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
