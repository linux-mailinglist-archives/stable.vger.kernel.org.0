Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1907437072C
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 14:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhEAM3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 08:29:39 -0400
Received: from mail-mw2nam10on2077.outbound.protection.outlook.com ([40.107.94.77]:22597
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231972AbhEAM3j (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 May 2021 08:29:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gnf6rPLBhusCWDX0Du/h2ob6ZNolPoWRV4Nvm4QMMsI0DAL16FA0yX0vrRRdn7iir4UtAiwqWL3FEmjOltzflyA4srbGrh1pCaJ6bzt0SgEgkGBRyCWLdIhMiEPti0QxDkbaT+MFdCOPsE++6kSAlJmDnkhKKwgFeJAXbeVphBYjM5U7m8ljY1VHyEkfBMi2emyCsNhzVpzYtOeI/XPE185PHyuK+cNkrbo4/3IYRgqDydWPog5uS5B24Anrj5pToHopyP3qP49oOUZm1sh76TE8wSvGLMMVcjOF4lrFhnnrcmq+J9ilIG59d+stY8KQ64SksZTMr9gk5VMvEjotwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLcZn+jXHrFRyL63gWXLZuHUzje/ncrgtyf5opJyoRM=;
 b=X6Cg3EkaUNcQCZhScKtMtDptc/ST0moxnxY3gKmw573Y7qQmspjl0oGAAZkFQb2Fz/hN3YidV9oynXXUpn8jJ/7yK/0MpWwj3Dg/EH0JA7RU2FF/+SlWz4WwFC7myLU31HTjmwQ840iyz98Wfm8CIE3b5I1hZ6kl0sL0T5Weq3sdHRCZfJQTSDh6beqtomyMD11o+ApRcLpoliQzBbGyQs3E37f8QO8UpqPuZgWvkpS382xf0VO4+KCast5LjY6TxihIWkcea8Hp7w9fCbpRl9DD3JiWCaVea/ev8KlqcxaK/YVIezQDzguqK7ykx7GMuBPpX3EV+iyIfraSIkTDpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLcZn+jXHrFRyL63gWXLZuHUzje/ncrgtyf5opJyoRM=;
 b=pVE+DAufUZMpjGI7E3CTOZTsfG82ATKfD7MCHlkL29znabLP0o4P2/vC1UDqxJScsw1v5WkqxocPqPGHeZunWaglVcxY+veYaAr4Aa1XDlGry+ZiP2PZwuSjw+laJFDUFg13NBbX4GLvdfM5YNEKa7FFuzLlrH+65mW0GX0TAhYDDOIKamEah11ajUz3r/Q0AZMCVK0+N3eohsDi2vOzN0oWz5r7fjXPFBn/p9F8wwXxNXmVc/noOzkrvP7t8/kjKHLwUXfhLigRtlGWXvmPwqhtu69a1SAIPeCwkBnU918djEk7Nu3Bq13ZNeWoZD1K7HOAuYRXQC05z/dFJytghA==
Received: from DM5PR19CA0018.namprd19.prod.outlook.com (2603:10b6:3:151::28)
 by MN2PR12MB3885.namprd12.prod.outlook.com (2603:10b6:208:16c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Sat, 1 May
 2021 12:28:47 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:151:cafe::96) by DM5PR19CA0018.outlook.office365.com
 (2603:10b6:3:151::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.30 via Frontend
 Transport; Sat, 1 May 2021 12:28:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linux-foundation.org; dkim=none (message not
 signed) header.d=none;linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.32 via Frontend Transport; Sat, 1 May 2021 12:28:47 +0000
Received: from [10.26.49.8] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 1 May
 2021 12:28:43 +0000
Subject: Re: [PATCH 5.12 0/5] 5.12.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <f.fainelli@gmail.com>, <stable@vger.kernel.org>
References: <20210430141910.899518186@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <70b6f1c4-6d59-780e-dd34-14bae71f026b@nvidia.com>
Date:   Sat, 1 May 2021 13:28:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210430141910.899518186@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f3d9eca-e941-4af4-8de2-08d90c9caae6
X-MS-TrafficTypeDiagnostic: MN2PR12MB3885:
X-Microsoft-Antispam-PRVS: <MN2PR12MB388564E83053BD93B304EB25D95D9@MN2PR12MB3885.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ookwzQHUW2edwYQi0zyk//lPyxvwKFEdioJnOM0LIDIq0Cz3Ym1L6bkew0P5KMI5y9fgQieK1/tCluC57+ZNCOiAHoaDQn4ymwq3Sjcu28vJ5xdLUQnHODKPagsk8A9HAisXXdCGYLRfBGgUxRTvuqd8bAFoBZOyRUkzRAppMDPPkVLNPe3WEDGSdvLuz5L6I0OZutlI0UnASYc96ufd7/wyla6tSg9czd19lrlPx4amvGYAIabUJBWIOhlVASiCLL3Zx0PjBQo72taQYMoqGqQxgFadVpR1Ks+5PztBsbCePt0W8LBzmzccNiIkFFd7s/N8rwqz961hJhH80U7x1U2M08IWhu3Rq+OX/9E5CrjJVOjlbIMg39Jjgti0iVqTlN31uWTeZTozYPylhVVBM9+PdzhA2r//zfHst3N3zCfmqUYU/I5AfwPTAjYhSD6f8paH1rFxfSalfNlfW9tnTE72EeekZvITH4hlHB8XckMLPvKp/p9YOc7XaX/zJQrAtwHsw0upaN+szE5hg0+iHexbLMUHmJEVS3LeTPZprJaZep/2POOksuITCRGRDEO2GhZefdhskPk1FcTwhCgS2gOf2YTPfGnqTBRSTxQcLzNhB7F5JCj6sAkuiOPi4dXOkWxEtDSc1ukTkiiC9EUNCi77dXL8LYY6uN44oN8UYi3uP1tiVWPLepYCHWQQwseJmclWFfAfMlE5C6atb7GUGwOWW5IiJzjlss2MBQpbUCuwihWjn07YYje1ESn95a5zkVCzSoH1sEctZp2hv0kGHg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(46966006)(36840700001)(8936002)(478600001)(36860700001)(86362001)(2616005)(31686004)(2906002)(426003)(31696002)(966005)(82310400003)(16526019)(356005)(70586007)(47076005)(186003)(7636003)(316002)(7416002)(110136005)(16576012)(336012)(4326008)(54906003)(53546011)(26005)(5660300002)(36906005)(82740400003)(8676002)(70206006)(83380400001)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2021 12:28:47.0214
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3d9eca-e941-4af4-8de2-08d90c9caae6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3885
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 30/04/2021 15:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.1 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


There is one failure for Tegra, but this is not a regression for v5.12.1
and is a known issue for v5.12 ...

Test results for stable-v5.12:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	103 pass, 1 fail

Linux version:	5.12.1-rc1-g94990849b4da
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra210-p2371-2180: devices


Once the fixes are in the mainline I will let you know the commits to
pull into linux-5.12.y. Otherwise ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Cheers
Jon

-- 
nvpublic
