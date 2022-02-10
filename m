Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028124B086F
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 09:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237564AbiBJIdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 03:33:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237556AbiBJIdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 03:33:39 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD5B21E;
        Thu, 10 Feb 2022 00:33:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EV05awxuuHEf2R5RMXtu/YvWD5QDeRlt5cOsTFPEj8cKv7Br0BDQh3Z2n7e/xFE6U+IIPjTtoSWhoBYYf9N8jeDF1U7JJdzJGhAdPFUeBj1jdmPYYm3kbaD8k33MMeUnV6hXylTWV0RfTD85nAVRgLCjVW2WcXQ0sXdOfUNdi9B/hAAGB/qdJQtMBQH1UNvqrYiOTwRAiOfoHN7xB8ZHSsGyUTwpZ2wQIODoeWtl3kEhKeJJSxnxRnLWPdedLDN8aKs9xHrfEnAe46ZAYtPE6tMIqQoJMyD9DMfvOZpadL/aG3+av4SG5OkiPFyvNSxpmNB25c0Amqjualu88JjyEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zk1lREzuzLrh9X3XA8Dimtuo/xiZyJWmRqHvX5rMr7E=;
 b=mjnd5xIDQTThOC3nPkVvyAulyemWsgkD+2Yi4Ut6x6tWBoQcG1pO1u1B68k5O7UcG/hVuWFqXWVfBgprcJoKBt1W9g/ZrG5LQ+Gko4TWI5FFGL4KFxFBFY4WUS+fGUsCRgjevcA0S16r1gX6Z0LJKCTGzz/CbTTbNlJda15vcdLnXulLULp8LBzdEyiQICyR801rSQ/W3zkddephTKkzBlGgfPwdOgGFirTgabp726kmBIBoU7xEujxnknPqBL/zKwIkYjXAqWvq5EGMOpaaYz1xnpbTekzsN/wTViUxKZf3vK2mxn/XHclIWtbrv5i0HEQU6QSAxcn2zfnIQjimWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zk1lREzuzLrh9X3XA8Dimtuo/xiZyJWmRqHvX5rMr7E=;
 b=aD8dKUe5pPSeh6SxqVVcJlZpe6y3SqZBRvFTRTaYj776yRRcDGyap1Y9EdqEtdiMTklEXXJN4y/puLhHBwziN2VfYzLH3FFaEJq74c8zlCnS/F+LCZsZJmeAMW5klASJynu1l2HQhmy+kWwa23bZhFv+IESPuH0BB0JjAwyYDd4sFTwTZE06rJkDrNRxOtUJ/MQIs8Kr54Q7DnFfyK20yRm3vzTlc7CiOV4rsR8+KDeaRRUu4Gl2ct9a5/Wo6GqIzy7dQ2UfcQZWv8M4XM2b4scAlFa+1KYULy01jMFT2sY2vQ/eFYuQETHN059WqJnJoEj1xy2dazcHT7lFqHsNdQ==
Received: from DS7PR05CA0055.namprd05.prod.outlook.com (2603:10b6:8:2f::15) by
 DM6PR12MB3516.namprd12.prod.outlook.com (2603:10b6:5:18b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.17; Thu, 10 Feb 2022 08:33:38 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::5c) by DS7PR05CA0055.outlook.office365.com
 (2603:10b6:8:2f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.6 via Frontend
 Transport; Thu, 10 Feb 2022 08:33:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 08:33:38 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 08:33:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 10 Feb 2022
 00:33:37 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Thu, 10 Feb 2022 00:33:36 -0800
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
Subject: Re: [PATCH 5.10 0/3] 5.10.100-rc1 review
In-Reply-To: <20220209191248.892853405@linuxfoundation.org>
References: <20220209191248.892853405@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <545cd6e6-75aa-4ba8-919b-ef0d4130900f@rnnvmail201.nvidia.com>
Date:   Thu, 10 Feb 2022 00:33:36 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 172442e8-3bb6-47cf-0fc1-08d9ec70092d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3516:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3516DC1E3951A06D020527A8D92F9@DM6PR12MB3516.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7DjP47MjAkOo8EBFaEobzdrXyPyUGLt/naoWw9MfHMy0bXt2ttTVQDKpO6hh1WN4kaQZIERNLG6/azGB0+doaAoia1CR8tKX4EZVs6Hjw8VP2lWOXXcgIlv9y+ozi2NXNxPOB5nh3XbgSXdvjJbFtPxTWCM6rlSxhMYqjnRH8M5Oi9Gs7Yyiiklzfzx1sHPiwwPuS5HFPWQyr7GWIXEmotJy+T+wlfLqKymwDL+aAKrF0lpfNal/iLgIXtRvHiN16vT0JdA6ErVtkBhZLHJC/5a7St1+mGCkpQu4VRTbF0FWRmFt1YSQXU6DcWYf6hqb+UEqYUqt0G9ug2LcCYu93Nh/vqfRE5cC84VGcdPhP9OL1PIKlsYv0S+uyO1fQmkECBOcEdluvECZsbPzyv3e5JFCjcfRM6+VpjxVIM3GVnD+EvlcrLypVkKPkgBFV6wG2TjJyngrUY4Rr8uJeLqfAu7u/lWiQKIlZvprQP80SCb17e34vBXK204+fgFm/EOo3QJNiMO+fDcXwoWfD/5juWSKBtfOfGD5mGVECdsoJc1KpiwGQbwV8nc3BTrJsyyI83qYGppLG145XypXEh3zY6YeCVQbHnrcQuVhWgr0AR+GxXiYMKSnd8wZXYDUaprNOT7uEF/0DrPWR2eIaoJxlN/QswM7wAlLgXpoaZAYqXvzCAdm/ixCJBCocPnLhgjAoKFEKMiwTb2obkLjA4YXJExwgbcwoe7agEwoUxd9xncTqDsDhb0vqm0pszZO+OIPVH1+Ulv8utiOviDlTND67JH1fqqbo/9CKO4yBXrgPEA=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(40460700003)(316002)(6916009)(86362001)(82310400004)(508600001)(31696002)(70586007)(81166007)(356005)(54906003)(966005)(47076005)(2906002)(8676002)(426003)(31686004)(336012)(26005)(186003)(5660300002)(4326008)(36860700001)(8936002)(7416002)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 08:33:38.2982
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 172442e8-3bb6-47cf-0fc1-08d9ec70092d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3516
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 09 Feb 2022 20:14:18 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.100 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.100-rc1.gz
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

Linux version:	5.10.100-rc1-gf1b074cc52b4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
