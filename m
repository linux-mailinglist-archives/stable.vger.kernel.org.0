Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C337560B4D2
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiJXSFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbiJXSEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:04:47 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20623.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::623])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6300B1BA3;
        Mon, 24 Oct 2022 09:45:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJ8ShgWdbAwpHs2O3Yh1PsSoqOqGSX/I8l/MGJetpVpUkGkamaQginu2nioHiCSJVixfZWwW8LGWwTVH9SSOrOFTjRVCJYN0dunYNgZoxvJxkk0uDfIKJ3wFlTHy2qBDbbAnO96LtSro2rMukuZjaa6CaqtsP4Ld+jAnICQSEiFrE3SOTTeZPVF4ypghol6lDqR+0EdnlyI8hUhHGagGtHixnDVB5u/QcvKhk9UDqaAu7YTqVXQd63DlR22KdAKx+ArX4T0yCkp0yeT6WpZMPgMpZ1OAYda4rFTVbza+bhyexT6JkzOuAW13Sqbuvm5wj04sEZTzAIdN4D2HkmOwSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L+YuTWiASjKVSFFgzI+NbSnjLIZ9+XcSJ42guptZ5ZQ=;
 b=TOj9R5Z0bV5smJ+LnvUuaS9P2Zx/X7Gzcx+fOoihfHKOllH3ZawdFjUl5ke9hcNa36nGqdDxCFgVNFhBHiGb6oDPfHZ7Yyrt1EJ4r8AhjNXEuaPXxdTw8/bAiXlEmlMNmPSEA/vV46TwBfQhM1JuPfG1mqZX3fnRg4XIp0vPuXyo/ApXev7jbi8ufvsqWupJi3zV0sqdkS/QwMxtiq2+IMtptnKiwrDkcyW3sM7xWQJ+81r1v74oLqcso1/1rEmKeaiXxJNklS0MuKanIMPoOEJEeN4hmQ3I4xIrewRPPXhejRM71d9CLDTxXSo+smScfiSOoacFLwpJM8gwKkiTeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+YuTWiASjKVSFFgzI+NbSnjLIZ9+XcSJ42guptZ5ZQ=;
 b=FfHCiH8r/G+K0PDAPeuvmOfQunwkuLiQspGu/ewA4HL1mn5lZ7BxZaYZGWbeO2MF9A2+JpqMsxlHoTSLytQtmfpJS7/QmdZtY5Gu90JdJ9wzivPcp6nJggUIo9a5ohywwUSI9y4hXuR9QKk4puDMdTtpTsy7Xg5O3BAFgEQAcbNQzIVQKsiGX1zdJH/QnCRWiPX9PgLdF7Vcb1Z4MxdfYanYcU2oFhWzTB7JKRTEK7wwKAXzmILzTp1tmUoHzJ2iGIRMRQtD7y+qFs8J/gF9KPyTtwiqms6uWj4UtlO50dnR73a8YHPYGzxiJAbbCvV0KE1HGmwLuewaM6znCLLHZQ==
Received: from DS7PR06CA0045.namprd06.prod.outlook.com (2603:10b6:8:54::26) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.23; Mon, 24 Oct 2022 16:42:01 +0000
Received: from CY4PEPF0000B8EC.namprd05.prod.outlook.com
 (2603:10b6:8:54:cafe::33) by DS7PR06CA0045.outlook.office365.com
 (2603:10b6:8:54::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26 via Frontend
 Transport; Mon, 24 Oct 2022 16:42:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000B8EC.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.20 via Frontend Transport; Mon, 24 Oct 2022 16:42:01 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 24 Oct
 2022 09:41:59 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 24 Oct 2022 09:41:59 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Mon, 24 Oct 2022 09:41:59 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/229] 4.19.262-rc1 review
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <508422e7-8a31-456f-a67c-f2e021876de5@drhqmail201.nvidia.com>
Date:   Mon, 24 Oct 2022 09:41:59 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EC:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 06b19270-a603-42c4-b00b-08dab5deacb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YvhV+F9boem6OrcmLDmxv9J/P3LfTSSBK1ipJzoaesyWZcxxnRFHCfkVucEPM5bJeivG09umsGcWRoPBZOkekgk9UuMKYrhMIMxLLzWV3w1YTBmZn1oo4him9gKMhx8zaqWCNukZw2yKoIl4KSa2TL3l5ixW3tCNNXFZt8J98CvPqp15VniQode4Hr1iIaYBl5Pxcgc9BaxICFeKsRl4d4L1qN4jq1Z8Vf4NM/ojRyWUmc8vCwMgGsmudU5GhXROv6dnO1gezNiKF7394HL4pMxzVT1l31cWVNVbyPRwEhbSRnuNZI25v6Cj+bpBXsIFwILbZxJXIYVJoEbYOkKVdS22FHyERoEnkz+/78b86J5VAkfXhSCy5dFMKv2W5MzJ6iLN/gVPTv7P+1VbSU50wkcLlh9LYBinwzTT13E+UpGoojThiylZPlVg5UAWXM/oJb1w8WYI4AksCx2owQFKKdsKm960bLSAlI6027A+hhE5JdBNz+hO8543zff882PJND+771sB8Y7b91TMWz4sQ9W71C03t0XaNNoDxUrpcrUJ++tLUUWJR/mcoDYKbvbaIU858sfullCSrE7a5R1HspVuXLy13B1aVmiVawnkINwfZpm7wRSxHk5LhygLa5WXkTC53hDdw0VjG/SP7/yxI0EjjszmC5igxOXmLLMX+rTAFgAxYFCEx6RfuReU7aBoPawE/M6kkqylufFiNcAaR78Se1JVy99n82fnsPV0HeL9OEM/GKpyrojM1jR2D0oRUhNqPSScyCo0LN2hLB/ow+Ruy/+DnzoiUAQjMj9opT21ILhHrLkjS4NkiOOjYDKL8AdMpKikKQEj2G0E3sBunSHhPWW8sYNS9O7wlbUOIp8=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199015)(36840700001)(46966006)(40470700004)(31686004)(54906003)(316002)(356005)(40480700001)(7636003)(6916009)(70586007)(8676002)(70206006)(4326008)(36860700001)(82740400003)(86362001)(31696002)(40460700003)(478600001)(82310400005)(26005)(966005)(41300700001)(8936002)(2906002)(7416002)(47076005)(186003)(336012)(426003)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 16:42:01.0011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b19270-a603-42c4-b00b-08dab5deacb2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Oct 2022 13:28:39 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.262 release.
> There are 229 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.262-rc1.gz
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

Linux version:	4.19.262-rc1-ga838554008fb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
