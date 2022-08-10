Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A47058EE46
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 16:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbiHJO0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 10:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbiHJOZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 10:25:51 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF4415FC8;
        Wed, 10 Aug 2022 07:25:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fscg35pF1L5dH8Vtr7oOFYWxlaJ/7Y+WKZIVfENzblmvehU+dTd/IJdjgzwlLoxC8gMD/g0cPbq0FeRaRIS/rYEwL5hB2QgiPkOx+rbhT80Ef+0QqLWng8g9LN92TdCnm2t9sCDQ4lkuVjXzzvYOhOTe/4gN7leBQK7ks/DqmBI0IXEVH2BjJWqbJjuztZ9GCaKJfd3oW1Y8oamVayFDjF61+bem5SK5/7OZbrLw0K1FrMx0kd12cwGBK4L7qgSd5BUkhFKWfzVkTLl+EvudxqQ6jE35BtSr3M1DUvGW0PhYWT06JqmM9DYQW5fSGXrggWjW4TXCw7AZKHY++Yd7KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EE7UGJxcqZXqQTn+Id797/EaLZSEvRlQOSq+Jp07Ceo=;
 b=LIcnLIq9+2NJP9+S/vcnNm3EGvv686QhkogkQ3kUwMsvSuzDvIvZFjgo4mT/v/2qb5/PEksEH+BtX/l//CWH+5QyyhHRmXHx/NayhHBajPvi6TtYOTh5N1bC9fk+mHnPY6yOoXUEev0CeTJk8M2UkQAVLqEKeBZs+z7qnwPPQKebk09vQfcPlKdM79V0JXz9rp7zM5QpmFinUHSSWZhwJa8ExCYhbvlKQPFtX1hjtGnwq/5xfh93OAVJcwwtn4EB2KwCQJ5YjwK65/aeipstR5ovwOKYpNV+1Ls3IvgB4s3wVAAs55QaqSWEk6HoQNKZ9WT11v8i1KptgrWPIQPmIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EE7UGJxcqZXqQTn+Id797/EaLZSEvRlQOSq+Jp07Ceo=;
 b=hDZhsYfwHprlN3XOD/gLacvjUqTeuY9SSX5BPySPqMw8NbPI1lewnECGUjqx1HtvJnD0p9ER8tBS2nKzPIcO28xMKN+3zy8RjDbkeSU8T8k9nwABLo3aRZWTMEXimemsqr1WjRhTobGE7ZOUnqQT/suPjBh7czQ54SD+1NLP8YfKavBtqMCQgw1climowdoUaLSFzTyCM5WpIAcfS/QbtsK4KfXgqKha+gXuqhr1ScKmixoGbyCGd9Xbgw84AUWsA5d6FZMPPJDk30c6LyUadL55TagWOD+2A/gIdlcLrU818RXEkBgKYmdhhILL42A+BkET3aAn6nmcRftOd9VNyQ==
Received: from BN0PR04CA0185.namprd04.prod.outlook.com (2603:10b6:408:e9::10)
 by MN2PR12MB4653.namprd12.prod.outlook.com (2603:10b6:208:1b8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 14:25:48 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e9:cafe::29) by BN0PR04CA0185.outlook.office365.com
 (2603:10b6:408:e9::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15 via Frontend
 Transport; Wed, 10 Aug 2022 14:25:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 14:25:48 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 10 Aug
 2022 14:25:36 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 10 Aug
 2022 07:25:35 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 10 Aug 2022 07:25:35 -0700
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
Subject: Re: [PATCH 5.4 00/15] 5.4.210-rc1 review
In-Reply-To: <20220809175510.312431319@linuxfoundation.org>
References: <20220809175510.312431319@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <46b883a8-9720-462f-b0fb-76a261d1e150@rnnvmail202.nvidia.com>
Date:   Wed, 10 Aug 2022 07:25:35 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64e5f95d-234b-43c5-6609-08da7adc3851
X-MS-TrafficTypeDiagnostic: MN2PR12MB4653:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FCZhNvaR7DWLl1MQkH9wLqWFU55JbB3zS+OuPspnQ1DHAiWp+ZBbzN1POK1zExVz0YhWVAph7/uAMyNLnLtGGVMYbHQnKVR5CNJMmK0vEmDvJjebHKK4USDGpRj50tFIKeo9UblEz/6b9QGPWmLcO4BqP1/j2FWQ9mWVqQSIeo93kKxsBdW1mtKhvEirCwZW8Cb0Ftggu/K5nztjsGqefa4S40KJkKCV/piv/IhEMq6hq3s4CCV9tSUvEzgGbTrBAtCUjH5kGi32Paq5TQ85R2SmglxpZGac1GESNhBgeZ8alT7OOQ+j4h9pOPuACs2t0xkOsVwsFNuHGKzsLXLOmDVkEtwdrAES46Klv16RLFY7bvDVcAIfGqorUffuerLvAS2MDzjw3GXVKFk8H5QXiid3QePAKO+vYSwuQOLbSMRhJN2f569ITt+fOBOSSbtu7oC7066lT71J3aG1kU85h3lZV+V6FJdVd6v7PpECT75/ZRGr12WCzLP4Lda6Y0qPWsGBwfm1v8ZQw0l4xpHJr7TyLKC0+HJtFUlitgTKmH5BL99xu4n6pzET995fP4i8I+taCyeZrU2CiHB8qxE2KWTUsDoVNSEGhdJxK07TSlWgnequt4OdfOJ5t2+dDYO5STlGlq8Yj2QqcGtsSrHBEGf0qjk2zx1qe+ZanGEOhT+TNcGLgqnEHBskwlfbk+A738Vuzz4tIi7pRajPkUBD7neo6Gsp+abkWnIaOzWfmWukCNE0p1fowm3Vu+bdfyyfWpEtkpZ8YKDgvciKiZhGxzHUiKuq6ha/GfML+wu5PfO7LJQT1gYCWYSzD9VvEXOS6Q0/9aAaLkIeMmj+mVgnfyCksjWs2zfFKDQJLxadzEE7I087brTs6+XOTO3Jlnbe5+fKBzrnNF7LSK6RLRH8f8j7cLOtVozcMs5FLEjqHfo=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(396003)(39860400002)(40470700004)(36840700001)(46966006)(82740400003)(41300700001)(82310400005)(2906002)(426003)(336012)(186003)(26005)(36860700001)(70206006)(70586007)(40480700001)(31686004)(8676002)(4326008)(31696002)(47076005)(6916009)(316002)(40460700003)(54906003)(81166007)(7416002)(5660300002)(356005)(8936002)(966005)(478600001)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 14:25:48.0724
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e5f95d-234b-43c5-6609-08da7adc3851
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4653
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 09 Aug 2022 20:00:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.210 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.210-rc1.gz
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

Linux version:	5.4.210-rc1-g0bf8828e9254
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
