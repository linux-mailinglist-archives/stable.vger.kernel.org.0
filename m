Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21DAE4C8791
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbiCAJOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 04:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233666AbiCAJOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:14:53 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2068.outbound.protection.outlook.com [40.107.96.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F599580C1;
        Tue,  1 Mar 2022 01:14:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2jpK77Ocjvk5Xm+++bzFm4MP5H6UB6sz/gOSKQ9xK+6Pl+0W4I89R0LD+r6Cem0DTePnY8jsu686P8STH7R51F0RGJS7soutjuy76eypTpJMZRhVgAsvydyqbYMFTDdVZOW7ASdAPtDHnqApvIDlATnvX955zm3k5y0UxaBufDlsZxLEdEQMwDUU70UwoudTmcPSqRVqKs4QR6VF4E48rCOai1cJKoxWoBRYtzraDQl/H6eiP6bm0e51rQ8/uNqbQL7YZWWpeddBFvDwuxkWEqyAfrBlwSPd+FhxKweFNicDyjoJMT1bCT2H0Br2hnksJ1uq5r6qn9Uhf91JdDnWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s8WpVq4YCezQwXKAnZGu2ZthsazUY2OqzIAHn2Hj3fA=;
 b=UZcHtTfMkpvMrracK5nB+CgfJHI4hD+UpN9y/a21hRdNYU/xeCSZNBIXeqFrrIu3uxW2jDlsynLyktqb6ESvgtsHYqbS7HkfzrGbQJp6xaBsPLff0msZPDvXLTYVpmEB8Onm/EYBMbIFhpb0oOf4jfzj1Y8xqRj85vcP06hBZFXi0m1tGSvRdSa5X2gl6/6BkIpKY+FTfiOKetj00Vy6pzphVeQEE7jBmES47XVskjvcq2vWSDJCaii+DlsM1EW6VDqxeUJ2PoYYxeqbyATkcKwhd8Hcyy/6hsk82NlA75V5md0JiQDl/YBtdkcuxpqSO0gXTSjMZRudqRgv0Osbwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8WpVq4YCezQwXKAnZGu2ZthsazUY2OqzIAHn2Hj3fA=;
 b=H2GimEwMJ5f5B2qVHSOj0/9aScYEv+2hoQTO8F2h60cv21qznDshHTwOxENM8pACfgZIkmaQTFPvr48T30WSPcNsyCw+haIvF6x/xpk9PhjZNWxKSyPjntwgdXg5MjJp3gC6tFFElO5f6xJI4+cAGVNtl613jA5OAGAHJ9pFe9X3ree0alfg1IaYmCoZRCqA1V7ROfHMcbYAy1SbhNN3QRy7qefjlFO2Xpf3PF2A4e8CI6KfQtsvU6e7l8VadENbwiuWtUEyreoeKLbGseYeSLWMUWRn6nv7rNrEdV7XrsfPcFQl5UNK0+/s5gQPpyS3bZO8JSQ2ZWwPOxhlNiNEvA==
Received: from DM5PR17CA0050.namprd17.prod.outlook.com (2603:10b6:3:13f::12)
 by CH0PR12MB5027.namprd12.prod.outlook.com (2603:10b6:610:e2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Tue, 1 Mar
 2022 09:14:11 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13f:cafe::ef) by DM5PR17CA0050.outlook.office365.com
 (2603:10b6:3:13f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13 via Frontend
 Transport; Tue, 1 Mar 2022 09:14:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 09:14:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 09:14:10 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 1 Mar 2022
 01:14:09 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 1 Mar 2022 01:14:08 -0800
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
Subject: Re: [PATCH 5.4 00/53] 5.4.182-rc1 review
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <16ea31b5-cb59-45fa-ba84-65f5d1c64aa9@rnnvmail202.nvidia.com>
Date:   Tue, 1 Mar 2022 01:14:08 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24c97eb4-6b5a-4307-d882-08d9fb63d92a
X-MS-TrafficTypeDiagnostic: CH0PR12MB5027:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5027B2AA36645C153E987778D9029@CH0PR12MB5027.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Vmf3+ZfSBpJy3rdYw+ZJO3qI/InrEvcqh7xfeN/29ljWQDxrb1c82cfqsOE4Vwq8uUNhe3srWNY7oJmIsojuEAC6Ky5XvViLSApuSbKRBUlzeU6S3u760koGSEKfDuYid4dmuXHa6WNt6qoQThaYfgbLQrcPbn/LqiocA3m6gJQyZeMZLsaPgq46dsdFCrWrmjQKhBB10uXT1uR1BxpcH6f3VN3CteogQoP8M5OHvIl6VMrRf31ywM6fQy1kuWk4sYuDDrMFm/0R1hgosxQKWJIfiHIPiCeQBRflN025doYqPEZrquEwiljQfppziF8vTdOVk4elfvXfd8mXkVhoFQrOFuwhz6YNnmcSzdQaTN0Np9MhQUrpT+xkkA8r+nm1GWAVd3D0e+ZHizYUtW5G0U0EdUTt8vaatTlIqihGQwel4MippG4LVKtXpa7ljGYT8s/hzZ083m3U6O7X+XVUYPOxDY5BpUCzppiSiK6Tfr8KYniUu/nME3Q0Z77k7oaFwtpf0riFA96iDhg+BLMCIgC+ecVG3NzYv3lP9i0ntZyFoZF1Zyl5eyeApPECi6AJX98hWEGWk31ZeH1nGyVNnL0eD0RjNmi/x6XaURPeRr4a9VpfHGQixzHR2aTd8zdhW4cDaTvWWvGK0sFCFR4tYGPgTRXHMiH+D7vGO43mMuoH3uaY1e0wrO5XIA73XARRw6Fw0tyQ4R8V1lr9IKUOxaYBpOQQwiuCzpgVcFiHj8ZyxJj1d2StPCteMwxdnKXXaGZxc1MWJwdXIejRi8B9dsdr/lTcz+mjmMVw/87XKE=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(36860700001)(426003)(336012)(356005)(81166007)(47076005)(31686004)(2906002)(40460700003)(186003)(26005)(8676002)(4326008)(5660300002)(70586007)(70206006)(31696002)(86362001)(82310400004)(508600001)(7416002)(8936002)(54906003)(6916009)(316002)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 09:14:11.2183
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c97eb4-6b5a-4307-d882-08d9fb63d92a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5027
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Feb 2022 18:23:58 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.182 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.182-rc1.gz
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

Linux version:	5.4.182-rc1-gaa9d24e3c108
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
