Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AA15E5C57
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 09:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiIVHZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 03:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiIVHZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 03:25:50 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47167AA4EA;
        Thu, 22 Sep 2022 00:25:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYWKTE5qe+Y+0E3U4qTjs+pEHtOTmPLNT65olFZJeZExWX9KC9oYJ5J6gtiJH2ZEJ3Y48ESPrD21C9pAgfZMCHj5BIqry483NHIv0GAlZKWm7qg6aaWphrMf3tKb1gjieiJcqIq9jR9gl1kxHdl986Qjjelp0k352JGZSlSzMEYSO7zaZzUAU7tNuTI6J7TjDOHhhgdCRKsLr5g5Fud6GMyXJ3nEHaZx+cTeFHoJ2XvqgB//6hEX/ss46Ie3mV+ONevjJehk2wSDvtcywygcDsvZLK04POxAQGJYSZxRgm+ZZfZ0GX48JszYkd4yS0uQKotUQch3TLBAqcB59DjjaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gw0voim5hysU4fdkTzHsVgOlZQ9zyHfq0Hbb7wypmgY=;
 b=FXmLhHzACC+H+69ryDyzavffpDWHxKN8lJ2diq7z3nRZFoLKHqFPEVWBNQSuTyOy5QQ7PNEjOlZ0GSPnQemfbeVzb2ItNmHroa2oNR7ntJ7OltxFtFwKoXkLcPMo4vRkJg5EagJ7XbqtL+MRf1/hpNFvgsHdY/mdZ7XnE1nFxW/D2Dcn9RWJO+TL1todJh2HIIXlkLwTlDgnyf0BFRAiqJUjGaj+PTz+YXsDboneW0qi3tGQ9bDZ8nBuFAhaZX7B7FelZ0toK8+CXHdLb/u5Ej4/ZO8iLoIah6M01A3Q7pznnjz5gTiiFQn+UqP2KGIej5I9GmBScFHrHqk8gy7/JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gw0voim5hysU4fdkTzHsVgOlZQ9zyHfq0Hbb7wypmgY=;
 b=FptLtT8DjGhhoT9bgl7WKlilfVf4ABDBCMFNPfPSwBlC49L9cY788KzWELqHJ7/HjTO9mv0DlJInGp+XYB5nJVWOlzQ1CzVg5Kba4YqfZULGvjCssUaD8ti6wH0AFkNwtZiqy9JZNOXRQOMjbrjVTylZXU7onyuYSi9MTOEuEGMaUOhcu2sxAd7qFnPrke3aNIvoVj9Yl1DS5EC3plZifsbZi7GcaBDL81yZCiKj0CrPo5BriOO1CJnk7NoGMPO/cvFLGrlC6k2BXpjYhoCJY03nZSsY9EJ1xxU0PUvGrlTdryApqDLyBZMZdu4up3A2dWI/z+yvisEqEeI93xfvkQ==
Received: from DS7PR05CA0003.namprd05.prod.outlook.com (2603:10b6:5:3b9::8) by
 SJ1PR12MB6171.namprd12.prod.outlook.com (2603:10b6:a03:45a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Thu, 22 Sep
 2022 07:25:46 +0000
Received: from DS1PEPF0000B073.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::f6) by DS7PR05CA0003.outlook.office365.com
 (2603:10b6:5:3b9::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.7 via Frontend
 Transport; Thu, 22 Sep 2022 07:25:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000B073.mail.protection.outlook.com (10.167.17.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.11 via Frontend Transport; Thu, 22 Sep 2022 07:25:46 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 22 Sep
 2022 00:25:32 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 22 Sep
 2022 00:25:32 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Thu, 22 Sep 2022 00:25:32 -0700
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
Subject: Re: [PATCH 5.10 00/39] 5.10.145-rc1 review
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <af0a96cf-4acf-434c-9703-b2a1a16ddd40@rnnvmail201.nvidia.com>
Date:   Thu, 22 Sep 2022 00:25:32 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B073:EE_|SJ1PR12MB6171:EE_
X-MS-Office365-Filtering-Correlation-Id: 304e11d6-3080-4ca0-8fae-08da9c6baa7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Nbe/mJdyN6zdhNAJQS2SznT3VXBoY5nl1hv6zepIBTeCsrHC2kLobw2R3h9CAjz3bXZpwjx43A7kVdCuFCUp7AZBf17Lzi2EuFwhF9Xz4s1jGj04RhDt4OyTmYH741Rjczva3u0GrFY9cFyaaNIo3jsQlXpT4YNsXBNai+tETSpE2uapw1gZwiTPaZOAUn6lyDFZO6mpyT3pnbulyRr2vpOZFIHT+54ijfpgxdj9th19bSuVo8xUXLfqwVu1x1UVJEObBXKG2AaePirmfW9KhvzJ8BAdqDMysA/zzOazp/+WTob5UDzw94orYLsHxzDQ9QlwxxUvIRSvPaY67QXdLfZXA+KDQlGelYff2I8TwWpa2MH9zbJtrRi/TUp9j0DcaiA8XQSGDJycu1yCT1Mlui7xIqTlKTTQc01+8FAUK+F+OtVRBwEnFTI7y9jYvP3LhB2x5YniCTgMV4s4MSVdCfOQrHX09yNMnquqMQoEPugDjzHp9GqWUSeSDmNnlOVr7uEFs/+aRk3d1wIFK6Xle4iViQ+A0UOzh5xYdTvvwbZZSEeog+MJ6zZPms0vC+JTdEi9gpAdMIWE2NVJRWvVtY6CrI/Pci65ogw6PIfkWLcNWK5Cd/SGfAeRIx0FMqEvYpwGKr6At24rRip5gm19kCMAiSTw1Y5UCWXypFrxWWhW1fRGmBbCY5Bv7tEo69nvWDIFLbuBZujt9yePy2HPrDr0aGQbiI2U5Uph/6GFaZ2F/1BSQXKTpAgvzngTKPckpNJaUDEaIc644gpJQQpjydf2N5pvvvpKrOHrdBoKw6fr0LAx/Zabnp64OX6R2y1r9O/W7e5JWzgXrkuK5B0mLkcgy5pDgIpkDTX80btLAg=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199015)(40470700004)(46966006)(36840700001)(186003)(47076005)(31686004)(426003)(26005)(336012)(356005)(40460700003)(7636003)(40480700001)(7416002)(70206006)(86362001)(31696002)(5660300002)(4326008)(8676002)(966005)(70586007)(478600001)(41300700001)(82310400005)(36860700001)(316002)(8936002)(54906003)(82740400003)(2906002)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 07:25:46.0573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 304e11d6-3080-4ca0-8fae-08da9c6baa7d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B073.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6171
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 21 Sep 2022 17:46:05 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.145 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.145-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.145-rc1-gca8291e3d06f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
