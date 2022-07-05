Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A130567136
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 16:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbiGEOf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 10:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbiGEOfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 10:35:54 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AEA5F4C;
        Tue,  5 Jul 2022 07:35:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ken66T4xl5TJ6CrgxUXrPR2t2c1qYJK1Kka6WmRGYD/bhGkngvLLnTY6cqgeBAg8advtekLkYjSjTi1NdZxcNK8u7a3vKowzEIeCOed0qg/C3axIuhSLazMY0qzm7PUV3LVLQmo0uAc4g4BNL8CLuLaaM6KSh5gAg9jl/9DbbKT5xAGsGNezb7JZuPwRSTjekSeJBvjdxkAAfphAGMk4Zlb38QAmDL8iKGtcol9YaKxhu051wzOKSbtcudXOp36oRdQQTMwchWNdM1xisTUUwU/2Cs6rml0a0sILcqpOW7V8lZJqs8qCoiCgviocJsWt0sdZhMVxEKD1Sgwgik9tmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayQEkELZbEs8S5/9UAZiclets5U7TmCSyDDR0MImb5M=;
 b=Jg6yfe/POZEi+lz4zj79vWD/5h2F2kAM909afRkh1sOWBGmFXmgNiossIripGf8Z+9umzPSCVXNbeHiL1c8OPR8tooinaemqK/rFq/QXhQ+sWZ+yUKdiUSVQJUxBWsrEu7p5fcYvIEnwIsQo+IUe/4/iMJoQMPqMOc0vj7QyRT6o/NAWMKUOUrXcAPNiUtcox9Sr9mugaZ5JreN3FEftA9kUPiBsBuxjfnw0EX80y3EDS7yLi1XXDwYubwPk2CeClCeW04XCaBJMD0+KQJGE8U3WU9gNSj+fyYYVJDm4qVCAZIRHoRi236kKFdvZ4G6NbSarNv9dkIybn0EMXeNZYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayQEkELZbEs8S5/9UAZiclets5U7TmCSyDDR0MImb5M=;
 b=VG6cHROHGrWJ7ZU4JibqLujalB+pIpWdfydJ3ZAFEskWXJeaEoO5Do3IpSr1Ku03CZW6wsbcLjRrIT+0v10g7Dr9shLAliGim++hSDtWOtwgFwH5Myy0dO1FproRXirbzKc3WxXguxOpfNbaFqXPn7aly6HIGdX7074/GHURR387XIZDrDiMCBNMDFfhGFJfpiug41YbqCtuBSuCBOErXNqESgflnRoDI078ft9M2eQRISmpZHSOAgVWbSGezS+MUEQObDKWvEOSi5Q9Oh/CBfD/qsNrZyMYfP69g84+TxUmjeYmA3SU3Y2aBERE6dWIyQ290h+QIFPzkGCD//spyw==
Received: from BN9P221CA0008.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::30)
 by MWHPR12MB1664.namprd12.prod.outlook.com (2603:10b6:301:b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 14:35:50 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::bd) by BN9P221CA0008.outlook.office365.com
 (2603:10b6:408:10a::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Tue, 5 Jul 2022 14:35:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.17 via Frontend Transport; Tue, 5 Jul 2022 14:35:50 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 5 Jul
 2022 14:35:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 5 Jul 2022
 07:35:48 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 07:35:48 -0700
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
Subject: Re: [PATCH 4.19 00/33] 4.19.251-rc1 review
In-Reply-To: <20220705115606.709817198@linuxfoundation.org>
References: <20220705115606.709817198@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <09de21fb-094c-4824-aeb6-cab7a12b69bc@rnnvmail203.nvidia.com>
Date:   Tue, 5 Jul 2022 07:35:48 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 648db32f-34d4-493e-58c5-08da5e93a84c
X-MS-TrafficTypeDiagnostic: MWHPR12MB1664:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OaJSzwzOLu9EB6mMz10Ym7BTAd2FUFfpjozRH72GsduFE52s1Y6b87wSsr5EZ/GQFA6hs1CUg8HGyBVO3t7S8er8xvOKz0Z4Pkr8yf29Yay34e0CrSAezFpgAk68i1qOxad/Y2FHLxINljs1QMK4ECCBjM3NLU7w17kF5PGWr8wVJNGwQ9Ci3XY4WQ3D0K15Xo4A+WBas/llVK47AM4lkPUf87UY8uPdxzru/Bu/L7/p3CSk8Y6p2oCrre6QZTL10Nn2gTB+0a+90eYXQ+8bTLwjLQ9no8hdGpbgYd2jMBZTErxdv8FQcBMdOuOn5l/JT0n8AXLZeAsRwK5wT0t0AQ9AB7yHMkJxyeQgYxi6kUrfe/8PBp+ClwAXhiyVIiChPbZe8p4ZvQNLRmlk7Y96TUqvo6v83T7lCUaW+ax3mXN6Vbd2d3q5ERkKAC9VTj6htS552hIdJxJDPdthiBFLkGSTXAtUK6sT4PYpb9rSoQNNB8Sildhu9ZJl4TnI0iH1RxO4CCLe8n63OACpapp7H2ke2SBTRDJwCkfPe8pP000Zpn1deelEbfEBYWShR6apnVfhzNh9KrYPlCCmqp9lSEnmf4X01kv28wVhqWK35TdLjaxTw9Zu/axMJWa2PXaXapT6XHB5cvjJNkAuclPjiVF74Yn7yXT0woykzw9GvehCXV9Qqhv0iAkJMb/Gm8NZ52lLvwRpg9B57rXmERQlp2twMVZenD+7ardmy1ulwuPF6hNGPMk+/oW2pp4lVL652htKsveaOCmgE8ckmOpf+0s4y3ZVtc4Lnm96UnQaaQWxpg03TCjjjDcYs89NsViRSXUaUSz2NCqgGapuC1fpvSAaWDnR+uwlpwl8r3ILvE690Q3uXpv1v9UnXOWWNO4cjzL5F4YuV7le20b1hoMHabvEU7yXpbQobeiSvwA1JzViguV90B7cek1bP4W66B4V
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(39860400002)(346002)(376002)(36840700001)(46966006)(40470700004)(186003)(336012)(47076005)(70586007)(70206006)(8676002)(4326008)(478600001)(31696002)(86362001)(966005)(7416002)(40460700003)(8936002)(5660300002)(82740400003)(81166007)(356005)(26005)(82310400005)(2906002)(36860700001)(41300700001)(40480700001)(426003)(54906003)(6916009)(31686004)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 14:35:50.1407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 648db32f-34d4-493e-58c5-08da5e93a84c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1664
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Jul 2022 13:57:52 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.251 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.251-rc1.gz
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

Linux version:	4.19.251-rc1-gb9f174a70c6f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
