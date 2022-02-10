Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690A04B0876
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 09:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237572AbiBJIdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 03:33:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233988AbiBJIdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 03:33:50 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1887D8A;
        Thu, 10 Feb 2022 00:33:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NvFupgzJdyy5U5qkOsheip0gYjIgWN0MmvjoiaayaoM9Ou42H+U4oyQcoz6/6WERnTbQpMLNRLHUA/hicD1rC8phia/CeHhQWSdDg36GS4Aw1xCR63GwWygMl97Dym8UUlwo3HaXIGIeO3QjpUugyU6Sj22C6BAZOh3DqBetLoqU0Y2dK3Ifn1quwAiWNTDCTgj8HI6i8R/dCpJ7KTY0yK9JnOpPPwCH/jW9oUShz7OdkmMiLC+STNFsok7pxWj/5xM/ICmPHWpK3pvQGZLufZN7F6wU+IJsvCtiTJRADboD5M/Gjyj03inGD6csem0KCt9cBEjSNs+KgYK6h2sYQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FpiLfm7nD80b8bGUMvtwU9Ce2pwhNY5tiqB3x6RhRpU=;
 b=nJ1je6Z05OWnJ4F4MNLR4/pUNpxdx5AZsiVyEl7zLf6Wa1yVXHXHVEJvpHA/c32ZRvam6SQ6bUXLS+wxndqfuEIiJXZHXKGCF9Jx4586rJTOsYQkupgvtV7ELfDCS1KRSxyQdNPGVKC5FgHKHrHXrJ9ve1kly6HbSC2ij3RN2cW1W5rDe+2IaXJH/TAgHESHU/ynlZhj1wjFSP1QdQ5ZrGA4PGFH0/A9yNUjcB1Lbj+KAMAocWFcE5WiAhc40a0g3hcFzvXpf7/UNQO/tTgVjh0X9SLEgMNOzh6QVDUgdCnIGjgxrtcCdiIqBEbDHWxCz9ug72vVjOztdls98jdy2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpiLfm7nD80b8bGUMvtwU9Ce2pwhNY5tiqB3x6RhRpU=;
 b=Pm9rAR1L/0ejp5/JKOULLeUAX/WYbuJ39e794i9dUwWteUeYVvZ7sB/Pfg7fDADLnyCbTRFWZiioRVjGbIFwHEC6aOrKMA2rfpGMLvvzpPMyH3kPcTqbf8mcK8+s6hNbamMN7XXGmojfxdiuJ4OxlhKQbIt2pRZ4mbqI2efob9g8nMtTgUb4VSAUgGEOLvOoQcoqwRDpVSoIjOtH7dRE42CWH1rIWXNf1uadwY+ZMw5CFiwoNsMiahc7umf7KEf19udK3cHJBXC4kwXm4yKDl5YvmqkDFTSjGuP6/8hmvjIU1qm4gcmFldl+PRqyA2185RdJmeVQh9iuG9ldeKGQkg==
Received: from DS7PR07CA0001.namprd07.prod.outlook.com (2603:10b6:5:3af::10)
 by DM6PR12MB2825.namprd12.prod.outlook.com (2603:10b6:5:75::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 08:33:50 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3af:cafe::38) by DS7PR07CA0001.outlook.office365.com
 (2603:10b6:5:3af::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Thu, 10 Feb 2022 08:33:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 08:33:50 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 08:33:50 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 10 Feb 2022
 00:33:49 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Thu, 10 Feb 2022 00:33:49 -0800
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
Subject: Re: [PATCH 5.15 0/5] 5.15.23-rc1 review
In-Reply-To: <20220209191249.980911721@linuxfoundation.org>
References: <20220209191249.980911721@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1dfe70bd-1efd-4da8-bc8b-c180e9a25665@rnnvmail202.nvidia.com>
Date:   Thu, 10 Feb 2022 00:33:49 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41df5b15-7f88-4adc-dfcb-08d9ec70108b
X-MS-TrafficTypeDiagnostic: DM6PR12MB2825:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB28258939FDBA364D1D65AB05D92F9@DM6PR12MB2825.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: saTqJdeXnaEUpWkiNdI7v56HzhQUzrKfCi5MNFSC8f/fzPEAP7XbNBLC64hGxjakyoJJsJ3Gx3w2FQNfsI13LmY1yF1HwnDicaGZShJk7Jj5sX3P+8YD5Y5WkqW26F8q7Te9rB910rB2CKPae7o01q4hgR8DQktoxkrFhWmK3SbkhK1hWiDJQJcAjeQFf2ylFA+ehVL+C/WQl0B4AC+Q5aPgjxYuEUyMXr1us9VCNtrHTIasyTj25LNpBLTa83ta3Q6jOvBxcg1nkpglllrAvT6FVOSa53K1/FEJohuhLm0SympLAuex/O+pwyKerDmX8G+oQU29H2YibPHJRr8YNpnXHQ6NalX2y9aI7Ia9G/xUvkEgNeiD0oZUW8f4rCMsafnbntA2RLGEFjiwqxcg4tuE4etdJLz+jRwnUc12E8uVqEO6gxgAnG/xZii9k6uGNaw/wr07wlUM4ExqDAWzmd967DH/sWbT2WHWYKBMiKR3yWtqdX5ijKSx5ICNEjZFaBwADy6tZ2uoLMLJsM8TXeoRkVZ+SQsoubiX9vv9s/HdIVKOaSnxLci9JSeb/jZjTVLjSXeAc4ZZoa9fU72/U0/Ly5qnL4JEWGT5cbhjXuj2ufhiMx9TXKt1Jaz+5xZiwg1qRm3o2WhRA8oOullqa3sVEZ59HHJ4KCL3dzXAk2aUEiPmKTmefEVjO9udRm/vJQ1olYJNBScj16jSWLAVbJMZWM7mg7BLcKsxBffYZkOvukFi6RaEFH+xYy8qCC0AaBNxfopvmQFPGRhNXm0N30fX94FILhJUsfl5/kS1CC8=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(8676002)(4326008)(356005)(8936002)(70586007)(26005)(81166007)(5660300002)(966005)(186003)(47076005)(7416002)(36860700001)(70206006)(508600001)(6916009)(31696002)(426003)(86362001)(54906003)(336012)(40460700003)(31686004)(2906002)(316002)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 08:33:50.6636
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41df5b15-7f88-4adc-dfcb-08d9ec70108b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2825
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 09 Feb 2022 20:14:25 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.23 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.23-rc1.gz
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

Linux version:	5.15.23-rc1-g722769939d60
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
