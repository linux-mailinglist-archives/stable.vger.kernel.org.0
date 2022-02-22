Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0888B4BF7CF
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 13:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiBVMIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 07:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiBVMIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 07:08:18 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047509E57F;
        Tue, 22 Feb 2022 04:07:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8R/QBjoMXNcwUfv6MpUjOzRJWra5v52zRWDZC3xMdgjXsvq/egqEIAT4p4K6MGA3MffSytjcxjBnAPDIbjuPpyvydWmYRQ+e4OrG7Eh1B4LqDg8ccXkBj8wCJ2iX6CT+Yfhoch9HsXomRwXaPsf+H3KjWRXNFIDIfAD7YAhw6sIJwABFnSKBbx7WZteoHFop1aBJUGQ2B/WKDPy/UmM3nGCQw/CtxA948JiBRX0yxEjJa+f1/wpV9jE5dhHMGgKYQTt9m2T/b+CGNudXnXte+dpzl0ZNug6MdtFsEiN0te0Q3ZbopgG4s219P7CHobyXaRGQCiW4orZSJXt44RNug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+9BTkRs4d2sChbqu+RjLvnXTvDtmD9Ux57arV9kY+gM=;
 b=YfmcpRcprYysriPNMmn0WzZFEF7fv8Kbo9zx14onvXO6QnyLmfR63qKUbfdh8rJkODZVXJ0U4c0zWwSWD6v2e7Ng1hUlMi/H2SPbIPi364TF6B0WLO+xDr6yuXCIrSS/8eFePVLPOE5Fovarffuxd6+Cq9h73f4NHjTPghmNQFeIzKhQlvEBl190GbBe2OiHhUNkVnpHhioQecdRzUTOj+XmUSUR0WvR7nwj8B04MlKErabYxqS7pZPBieV5XP3KiUCCpSeb54fnDnmsv8QQHFk0tYSVF/HBPZ1wRVts3mngPuqLsTe5MQZRmayo1+BLV+iuqczqv4KvheDAFIQXaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9BTkRs4d2sChbqu+RjLvnXTvDtmD9Ux57arV9kY+gM=;
 b=Np2Chk1wlvbzCXpcRKZ7a2+jte2FijocLd5eX412m4TJK1Yi1cAS96f6vpf9qEGU9dAdrk6wMmdL0b+4leUeHPRwPhZw445paM0vv5WxMoq4lnlKPGooQsEpczuKxss3K/Vorzi8AcSWX6VHYjvAJwhh20+2hwJ9YesQ73X19eNWTXbs2FuCIEtg/ROlj/PF4KbaH0HdANPKW+bsQMM4yoZWv9wPIFrmjQFzh0TZqtFA+QQOsHJfPg10nfJRsVHhkYlghhAW/kpeQHRb9AeC+oECiVtShQEKeQ3oK9MexpSs+iAK0CxHSwXbAyJC4FEn4fMh/oIF+X9RAErwU+M5wg==
Received: from MWHPR2001CA0017.namprd20.prod.outlook.com
 (2603:10b6:301:15::27) by BYAPR12MB3320.namprd12.prod.outlook.com
 (2603:10b6:a03:d7::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 12:07:50 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:15:cafe::ac) by MWHPR2001CA0017.outlook.office365.com
 (2603:10b6:301:15::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27 via Frontend
 Transport; Tue, 22 Feb 2022 12:07:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 12:07:50 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 12:07:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 04:07:47 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 22 Feb 2022 04:07:46 -0800
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
Subject: Re: [PATCH 4.9 00/33] 4.9.303-rc1 review
In-Reply-To: <20220221084908.568970525@linuxfoundation.org>
References: <20220221084908.568970525@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6fdc651b-9a6f-4e1b-9d77-5e3deced3299@rnnvmail203.nvidia.com>
Date:   Tue, 22 Feb 2022 04:07:46 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 972fd75c-0308-43da-f8f6-08d9f5fbf25a
X-MS-TrafficTypeDiagnostic: BYAPR12MB3320:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3320847A0D611F0F3C1E0414D93B9@BYAPR12MB3320.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b7V4ETFpaJ224xarmFh29RLWwS708WJNl+zY+qek8VfwNbM5PY/s+9utfhSdMmCGqH2Zm9x+u8D8ZVbrHsK5Tm/ur1pZt6Rkcwj+tClTIPNDLmh1xH2RAmXgEhZiMza64lHUWFev9V/IykcJnl6pd2PQTvoTBmRFYAa2YyQkNQs3B+XMLhHsbXeaneK78U//NvBlYUPam5tYNHyosEDK4v80drGFPhbPstQIzsyp9v44kCqAZJd3Zd6BhC58X8f4bEs1Ht/Sl7kNj0kEaTOQECs3qLT8Mwm8nKyitO0Wxeo/vZhuKWO3FQwgvv3SOB4VUU10ceKveLUPWma0CV8A+39FO/w0uzWT0YGU8mj1kAKZvvwv53w5lyzIm6jwjGDXA+pFuST5A5+DUn+Uy/R1VIZykTfHRkUxe7zyxqRJ3KpGgXpBIs9b0rlKkx44G2NbEs51h/i4Dt6hL9sa8WePATr9geZEuB1kblH+2Qlq/XFPrltKpNFhnHXevlsLrv+4hKxVoeo7sbVeGXG77OCoL6Iy4WsC8QlE+NBErS0vLCohgUOKW/TG5Q3EM8WzsX4oCWzyUVTSyztXDYKWBAlQUuSRBaPZrGgwl7tFk/mrUR8zT+VkchJAQ4qJdj2IpiiA1YKyrijTJMw1XofS2ucr3FnMoIJMa7cqjt9LEX7uNFDRSnaUQIBp42aTXOq+MaFmuhL3RvBsIQ+W+2xVsIROF+eE41gzM8c18vlCYju+UZ/O0sJTMf99WxfxaaQxjSHIsYowcoxYm2bB9VLKfn7fF4zmZSe8Aeqo8huBfInfneM=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(70586007)(81166007)(2906002)(70206006)(8676002)(966005)(356005)(8936002)(82310400004)(508600001)(4326008)(5660300002)(86362001)(6916009)(316002)(426003)(36860700001)(336012)(31696002)(186003)(26005)(40460700003)(47076005)(31686004)(54906003)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 12:07:50.0186
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 972fd75c-0308-43da-f8f6-08d9f5fbf25a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3320
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Feb 2022 09:48:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.303 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.303-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.303-rc1-g6686f147d38f
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
