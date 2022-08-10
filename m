Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C99B58EE3C
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 16:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiHJO0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 10:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiHJOZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 10:25:38 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9106E15FC8;
        Wed, 10 Aug 2022 07:25:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBDUFJ4TAUNCky2v0xaZriOeZYxmBuac83WuJIIG6w18zNAiY8XRpTTY5FfbnIUCuMq9M/+T+cvHiVhnhXTrNwYEaO7XfR8AVImxjoXscCSsE7Hk5SThTbNkXRgnbPvoZHR0vIWbbTqwIjE2CBO7Hjf8R3XAv1IsLFMkj7KflJkyvUKTautQy6QHRDWZWPgtp6ykZGqJggifNRqndfOq4OQbj+7umBbB8hb1Z8LMNn0UNR+kEp2tubLb83a4qPndSYC/tmnubDjRCNBrMy4hEhV+KnR2mAYmhxgZqTP5GjqV731GPii7dGumHF8PX0s6MbR327Hq0yNAcPYMA0A2hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/u07r5QdFvWB2LMoPU4mf2qZGSgl//d/8/PXkbRnrao=;
 b=F90BzqyAGaugFgHp2h91V1E2TsmFUOf73gigtbnWkecJTWUvc0i89pyZy8ZUs2eKlmmcw2XdbMUDkeRDbU1aB9rdDz77VTq3KEX5hhAeB+92JxWKyfuzIKDA7mkp8N2tuXKrFpBSB25/UkOywzITfNGivGkseAyJ6Inqf9JqQDiDrg2cyCnjQnje2qkTvJAeHumA/2IiraS4CK9mSH5YWDiuu0IWZXsaEE/0mQPMBROlIFS49a4006BRz5+Mve4sSKncN6G+OPUsnAH3489pT7Ph8dOsDGeGEVV+gY7TBQmhbMvLqqWbj4JDUieBu5laY7tESbHipe82h4dUSdKQXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/u07r5QdFvWB2LMoPU4mf2qZGSgl//d/8/PXkbRnrao=;
 b=X3k9HdkcP1tp6HEFDPCWuPub6Qv3ycltmMZPhHNaLpD7BIyb+6BSjyKWFwL1tSn+kLyTHTTtqH9C2BKqxWuCVbeF0wADMxsGCo1lAwsiOUDoNOeNbakBvMyuixJGnFuLXiBQh74qfkQ6kxwngQP4MXl9Q1CD3NYEFjAQ0K47QbGjpoBqW2TC6rz4cJ27Agb9MHBfGxomtazANcT20aUwZpLfig3aErZCUNXaVcDXpKKjAYzZgJuQd9yCqFbPpoTRYnKD/pmUZUSjuR5u2rqnUTp8zmXCiotEF71S5oP9fV+28x+EnTf3q2EGTzSk5272Ww93x9y09BcXSzB8VWyX+w==
Received: from BN8PR04CA0033.namprd04.prod.outlook.com (2603:10b6:408:70::46)
 by DM6PR12MB4203.namprd12.prod.outlook.com (2603:10b6:5:21f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Wed, 10 Aug
 2022 14:25:36 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::a1) by BN8PR04CA0033.outlook.office365.com
 (2603:10b6:408:70::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Wed, 10 Aug 2022 14:25:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 14:25:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 10 Aug
 2022 14:25:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 10 Aug
 2022 07:25:34 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 10 Aug 2022 07:25:34 -0700
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
Subject: Re: [PATCH 4.19 00/32] 4.19.255-rc1 review
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
References: <20220809175513.082573955@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <998b2aea-91ab-424d-87ea-02347499b325@rnnvmail203.nvidia.com>
Date:   Wed, 10 Aug 2022 07:25:34 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bb3b878-111c-4a3b-47a4-08da7adc3106
X-MS-TrafficTypeDiagnostic: DM6PR12MB4203:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qd22+7KbvpyIHZRdtml9gYlxgInrMsRT+jElGL0WvyHjljt09OopmxOPkTL15e/GKzA8so+RYLNB04EYB710M/4Or8AYzKmMT2E9jf7ZzyskIlrlgFfSaBAz78ilArZoStZKpkHp6nOwzZ96AqGJIBQFFwfOfRgcMa81u8k77QRhfGzG+4To7t6oMJd65nPj+mmxsO25/hs/wYUgv7S/r6AQ+mLAn4ZzwvY8aNkoKWaSPvEQYB+LjORJ/AMMH8dDx6+1MpCRyWWJVO2yfg7GTTwZ8ED5mkT8PIRjJcIboApbARRstXvR9GcaMraoAtspGRtjReWXR+npJR02fzdjtvlIkosk4OkrF3AA70keZPugip37FRqobqsVWG7x/T1NJJpLsytA6xQUOSCX1ZPe1UNYUGeODfM7FfUW1M13xEFQmUkCU0nK3kt3JBYC0XFinWheVhVeu0iRY8oaKdZ7ORfeXzRPkgvZy3vYi6RHqZCCjrZO1SRekGjUZfEfYpAyJXaE7/jhAG78zLwj7P8y1P598HvdXUbPb0QJUGzeHvLn14FppUw/NxBtNKQ3H+aFsK7Qx8ys7D3Dp8JIU81fAcOIkSMeNQUuKknkMMqQZ951jDEi0yTs+HcSo5TyEJBgsZKUbzOim33Bl4dyO1MDJO8D4A7CskR45eirgJtxhaTdh2RlemWIYeADX59d0b31QJpAJrhhCcNwtO/ax25et8DBFO2FozyOCfueCO/Su99c0IMyYpBnCf23RWPm13ZjELhddXB1sQwOff3Gbt9EZwbXikLMCBqe+8NxlZwdq32qEXumyun+ZJdD4xOhZo67Y/R6fS/UOnQ3Uv3A8fO8jM63OSNKF+fWKwGyXPYOJ9/27/bH3Ic/SZT/TFccCU9nWEQl+xL9vbK6aH+9RyWXPtpHyopLaktaTGmLXaoMBOU=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(136003)(39860400002)(46966006)(40470700004)(36840700001)(5660300002)(86362001)(356005)(82740400003)(70206006)(31696002)(54906003)(2906002)(82310400005)(8676002)(4326008)(40460700003)(26005)(6916009)(478600001)(70586007)(81166007)(7416002)(316002)(966005)(41300700001)(336012)(40480700001)(186003)(36860700001)(8936002)(426003)(47076005)(31686004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 14:25:35.8516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bb3b878-111c-4a3b-47a4-08da7adc3106
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4203
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 09 Aug 2022 19:59:51 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.255 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.255-rc1.gz
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

Linux version:	4.19.255-rc1-g02c6011ece11
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
