Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB254E309E
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 20:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352503AbiCUTSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 15:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244022AbiCUTSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 15:18:17 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2060.outbound.protection.outlook.com [40.107.95.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E7C170DB3;
        Mon, 21 Mar 2022 12:16:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4H7Ltc1+Jm3Z6f+7I9t2C5kWmdDx9rY9oKpvg1fYgTmSjFOKtAU2qyHf82HGyIVzwCgHtzWBjN3opD5fIA8nGP7mvUncB2vzsj/B8xrVM3P0lNB54QU8bnjWknUmKIv8gT6woH1tDgOGrTkDpqV3+i9ry9eulcZ4T4SzkUQgqhvuyyen+8u0WEFvfFKioz0XxV7E+kw4pPa7zbgQ7c+WAIWPcF+S5h4fVCRwMmPCE5wplj/Xehl1bR1R37YTw9TSzZnLfD2QJYENtgZMGnF6NWj6mK4ccIWrxzRxM75ybCk0Irad7WE3jxdEWynNRLvrDexLAe0Br2zikqoloKryg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNb6Hhj9as7hJTWRgxKCU5k8hM4Rr1YVlDY7oP0MTh0=;
 b=j83kAZWUu7OHik6mJhwe41W3MX6tx/2Fc5jZ/t0nwJ91xsnsKgiGj/YFj3ehDMNUuYYbK6Tt7LWzi/nJiwL1kGUY+L2RC4xiUDmPOMrK31VgIkkyrEy0YSmw4Nk7F++xBbhgDgubJIUhBpY5rA+kUiFnZMgJsh0xx+500HwBsfUdaqeY+rj+Mq/hv2g8yDjc5biuFGWQed8Vf6qoXNuc5lO6G0SgalNNqMj6sWTioakf9eOWyQ4hWIQv3nOi8fHJ2sDBMj0K7Em+pIJ2gHAw6PD8AOA06p7Y4MOH5n7dh+LjtXEsS8C1TxL1Gddn9zKMpfi30Elf66jR4gE9RXMDqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNb6Hhj9as7hJTWRgxKCU5k8hM4Rr1YVlDY7oP0MTh0=;
 b=SfcZgfAGwtt2U6pPTqDVsIQb8WC60HIMr5VytlSjZuD4TEe4GH3U4GVk4cnkAhEYUMkf2pQq7KHMWu07X9ZtWV+U2d66hL6rIZ3sZL5QgizWj4VeOPLLuj1CSkbH+juWY5mYKH/FIKKhsCyQ6GhD4vDLVJjOLlCLxFQkRkmQMEIQmztEEshFBit5nzm2GH/COtvzpo0ARld2R25T4jpERIT5rkvY3uSxZZnoFpBffVPbPOwbZULRLIyudV+K9CjXUzzvmgHlJTFsJKDN26QGAQD58kekbGFwfjC8QncCqLt52zZqTeSVyX08tUn58Xn9ZiLuDOo9m7MQfCwQawTdvA==
Received: from DS7PR03CA0269.namprd03.prod.outlook.com (2603:10b6:5:3b3::34)
 by SN6PR12MB4733.namprd12.prod.outlook.com (2603:10b6:805:ea::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Mon, 21 Mar
 2022 19:16:48 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::c4) by DS7PR03CA0269.outlook.office365.com
 (2603:10b6:5:3b3::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22 via Frontend
 Transport; Mon, 21 Mar 2022 19:16:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5081.14 via Frontend Transport; Mon, 21 Mar 2022 19:16:47 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 21 Mar
 2022 19:16:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 21 Mar
 2022 12:16:45 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 21 Mar 2022 12:16:45 -0700
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
Subject: Re: [PATCH 4.19 00/57] 4.19.236-rc1 review
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <caed1d61-0178-45bd-9834-525039248db2@rnnvmail201.nvidia.com>
Date:   Mon, 21 Mar 2022 12:16:45 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a093e32c-74bb-4460-d858-08da0b6f584b
X-MS-TrafficTypeDiagnostic: SN6PR12MB4733:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB473317A3F800529D681D20D4D9169@SN6PR12MB4733.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q+gOJlkXx8JzWou55jhdqAvyjG1tBU6pryIMfDfMgw8j/us/u4MmQGSP6exjAcaagYCeKUKjKsehPLsPaS1DaXdSmZ1p+muo+VsMZAa/wsIsQioBYfRRK7h+u5x52dLAyktbRkK/1grA02Feab8JnpXrFIRaEZH3lsH9okeCg1rOtQfyt45qW80277jp2LzK04YgCI24xjPlcw4jtogmMdV1NgP47wK8ToyzjFHxv4Xcf28XUJTF43W+OYwFH8TQxZhDEyc/8heARsywjeNGWCjK8CA8Fg0rVhbBwHPFMdGdFV31gzPg5WGtfaSMQDDmtGKHqbggj97SFyucX5GgSB+gFXrmkh/I0oT3Xndrtn3pR5l9tTw1NqUCu7C78+jHjbUGBE+afj1EFnJvH6SPIKTHg3Rn7hO2J7kHjButAVZtJS1FpQX3dQcZTGkhnacvfO2FY6PFexF1yQZnp34JreRGfxFxqeXSiFhTCCZsGV5n8q8Y9CI3aLwX5RDietfLltYyIVR0ze74SwNwskAneaPbevK4Qk3aLmk6On115h67B7RP8wej04dZtUUvkZFJ88cMyyuuxEB7PE8FKh3+98DUUariEt2ElQ+FNdRLKIOpS7L4+BUzG+l/8diJFxO8JKeMxholoVa0mBGRuSKGOwq2zIg6qfwwMVJGTgy5rSbBPu9BaKrtKnxi5wRH0tyVynXvnritcF2HNqLzbRNMODYu2Om5Bm2/UVBV32Pba30beOzZ498CjMG8r4DWBXkcuQjnBer0lyoCFUOFjfP8wq1UGCP7jIXO4agn+6QYDuo=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(31686004)(8676002)(4326008)(508600001)(316002)(6916009)(86362001)(966005)(5660300002)(31696002)(336012)(26005)(426003)(186003)(47076005)(7416002)(8936002)(2906002)(356005)(82310400004)(70206006)(70586007)(54906003)(40460700003)(36860700001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 19:16:47.5893
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a093e32c-74bb-4460-d858-08da0b6f584b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4733
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Mar 2022 14:51:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.236 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.236-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.236-rc1-ga78343b23cae
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
