Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888A3429EBE
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 09:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhJLHik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 03:38:40 -0400
Received: from mail-dm3nam07on2045.outbound.protection.outlook.com ([40.107.95.45]:27745
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233869AbhJLHij (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 03:38:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihr8HFZzdbBOkLLECVaq5sDKw/aimgE06HV5FCiz/DoKjewn75wPFaH5KG5nnQRD69WGOmmGneBKuUUeKEyVGO/Ov4K6aSLvAsVYA0192siodHTbQrEW92P4qknMUckgH83dnVTYmNN2wKdSuR+PsgN5amDFxXOfPdbikyPA4YStE7LEwf+LtHE0DOQtC6R08t+XbYVbs65LOIOknusRg/COUYw6pIxTLzmuyDS7SVLkuGMjVAjoCQQ4opoJTxsQKI5kxmhXEtXWUi1J76XpMWDsZkBTtg5ZdblCoW8HM265spQy/5aFRPErnIqwxczEWQk5GwCyMcrZmUbS3lrRww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJ55g7st7F8IBWGeuN46IFIKIeMdl9vwlPJjxajioPU=;
 b=J17XQboyMEpCnw2OheZmldNaLnnKAAp7oPM4G3xkd18G9RYVYfzINVJ+FFC2knuT9CRI1rd7hHlem/qnjFr2rnYowC4zmEV7fcrL3NbhrLdPX0hv+SKq56+vP4EWDVKrRF2bjE4t+7bK9JBafrGr5b42FS1u7qA2yKriY46jpwfDiq+cPk0JnuVxEJ9vRehH4jGE6qyFYRaFfBnwH70RkFGP2IvGispaYg6w6BSE6tMJM8oiwrSiFlsNad3ftw+Dsvoxu/lHzkK98HpiUCLmSp9WPa8enGdGiqUqvtiBi88R6O6oWItft0OaFe9fMVtKvsM4ncVsAaK4R47ToZV/lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJ55g7st7F8IBWGeuN46IFIKIeMdl9vwlPJjxajioPU=;
 b=Ayo5J7qlnxsb3820MqGUc39O3+QhWzibKkiH6e5EVTbhCwp8GwEkgqkj96gjjHVOsEAR/O1qQ0t+M3Ls+Fr87upgvvaiVZrDv7EF5kKu/J1V9hC67zYzTzTvBpjRxq0YQ0n8SYxZV+RCz6knHCohEXn9rYW06egzOKbs9jR8nhlfMYhEuZlG78pIxdXaSQg4BHGqJUQXkzRkgvlXuS6d4soKYoagrlMuBJ5VWsnPVToLKbaGkjid0+xKQzeMbOnDzXkeYsOnYUrIBeUBJ+fNXJg3lDQHuTcmekf+aot561FXTFTdTX+5HMCSl5NreN4DfLPU+N2Y+uWSFLRNsNpQhA==
Received: from BN9PR03CA0666.namprd03.prod.outlook.com (2603:10b6:408:10e::11)
 by MWHPR12MB1951.namprd12.prod.outlook.com (2603:10b6:300:113::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Tue, 12 Oct
 2021 07:36:34 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::89) by BN9PR03CA0666.outlook.office365.com
 (2603:10b6:408:10e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend
 Transport; Tue, 12 Oct 2021 07:36:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 07:36:33 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Oct
 2021 07:36:33 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Oct 2021 07:36:33 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 000/151] 5.14.12-rc1 review
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <35a168cdde184040899390bdb96d4286@HQMAIL111.nvidia.com>
Date:   Tue, 12 Oct 2021 07:36:33 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4696a3c4-7c88-4421-bbd9-08d98d53041a
X-MS-TrafficTypeDiagnostic: MWHPR12MB1951:
X-Microsoft-Antispam-PRVS: <MWHPR12MB19515E1F69CCC5C1379193F3D9B69@MWHPR12MB1951.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: owWkIJnL4H6aQSoL7KYLh1yGLot2SQ58LpAUItRz4m+jCdLBj3ra8FRnG1QE8E/cB2Gn8YIByNbjpM3Kofz1F5Crw6EkJItCOCpOL5NeGmKuqr8CxC1S0SlfejF+sxM3mAdPMQ/PCSBcuQmOJZQzgRao+5GthyY7rT/6NVhryLZWV0gcOM3sqi/wOW3/BJbtEQr9uKV02foCBS6P0xy21TP7zNgjl+sYfgTsf5mVZSv5eyOJ5HRguyqYm/Z7/ocEt5hbKDb+dzPrjSpBMy7JZNgo8Lm8h6cKcB45Oy0l/uIRNH7deH4/iG0XA+QeUNI9BR8gsaaLaZRwHK3SzQ2H8XHLx/Omxt9mbJRXjVlFb896QvQIz8IF7oPiV2kmtFulODh/XQlAZgzGV3Ui6dqHB/mGbyIG+PrV1seDxGU25ubTuf6mMekor2lC7fDx3qvGjIDndAmqefICuSjxkUwle12RY2da6sPf39JLvA3H5wcP0BgDBJSPJf1egNIcF3RRqm8z2m5ThURtadfnhr9LEzo+6hFjiS4WW+Fs8tgZhG5JYjqqauDIZD2Fce6N+MokYiKNb1B6bxsINJ7fzqa+Fyi6IsGq3wsTkY+iuGwyuMQwL1zSqMVJshN1dIGwThwC6DvFrSHYIoXgTGipF4sopn/AqPC3kGKl/IUf5uoZPRWnGI9ofAQ70Ykyh1k8NcH/I300SM97DHZrQJosaHKf1dhvwFeDHMs9olouhvoQMl/VM3R55E4T5XF0ZJvOPTHYsWHTib9z6NnZAfQX55rnMwttuQDR1QXiqZ+9/Sv/GU4=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(4326008)(316002)(426003)(356005)(7636003)(6916009)(36860700001)(82310400003)(8676002)(5660300002)(7416002)(86362001)(508600001)(54906003)(26005)(2906002)(70206006)(70586007)(186003)(47076005)(24736004)(108616005)(966005)(8936002)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 07:36:33.8669
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4696a3c4-7c88-4421-bbd9-08d98d53041a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1951
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Oct 2021 15:44:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.12 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 13:44:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.14.12-rc1-gf24b290ad7b9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
