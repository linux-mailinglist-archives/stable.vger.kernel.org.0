Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E135ED786
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 10:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiI1IUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 04:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiI1IUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 04:20:01 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2081.outbound.protection.outlook.com [40.107.100.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F131818B30;
        Wed, 28 Sep 2022 01:19:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQ8N0pB47+3JeY2eYysS+Ick2sbLTzMF5Pb6DaCNU8OTU3V0Fz/uAKCKeD8ESmddWCSfbcKLa63QERe+GzCikQ6eDMYpnLKHUCD3UJf6kxsRkr9hSN8lg/60/3SWnUvhFAW0cGSkAXB81ZBWNTbhgcOcvMQuWJHZ1xeDhhQ2k7WTYzd8L3J14VTo1pbbnCsjp9ZdaR98xNcYQEPHMsCawZuIi9+7Zu+fFq98VDG0o8vrx2akIGXt2EykzUGy/Rnt/xS9qFU0WO/1xwCwq0gHs2dTU9nn0OWnV3Szs7NQeYvIul8ZYMcP4br25ni1Vsp/f//gmbtd4ETmPXpoojdG3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X9zlzH/F2yYETCwThCwOkni+NMvOHTJI5gtQoUOqStY=;
 b=BS4lFYCM/f4xAgQXRzmCKY17k+G1MQfB9Oa/EzRGcV7miNoo3Ki2TlbZ5nfWiw7w646KNF9FVvZ/4GzFzOE7C28hpFlqiaiWNVN9SEE4E5d2/IfywHA8zGBUisgk7elVfWQMEJ3rG5G6trrVToN5YegJYQiCSIKvdik6ua6icwbFM7Nb7azcHeCyJ9VDGiRfsBuzZyKkfm2nPGbR7F9rWQcOmiNpgXG8440GBpwqKjwmmdkfNGB5O9m95EuYsH/stL61rFSTuPJr3VE+GOKOeMnlzCAfD0YsuCJxNMY3DH5mdH12+wM4k/w2H5Lv/opDJB9HRTXNhWKxay+4jBcYfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9zlzH/F2yYETCwThCwOkni+NMvOHTJI5gtQoUOqStY=;
 b=pUIlzX3H10BkUznM2NCkCaM6fR2zCo5QwSRuPcGTu053sskBOKISLA5rtoERk3sh4lRjBj/NEjWx3PCgbFlrJoJ2H2qKR2hjTqRJfGlD+USqAIV4cLXRSWxzyTE1B2PJBxyZoWe1hePs/JbK0UsuHWCSFftrsrg/OzpevEblsBLmoyBhx9E1/NihHEfaSoNqZu0/AxYR3vwfaVFiJfS/JYhG7fy8pniJQCny2NMHZYr2BhrJPL2QR1EBEhwJWzMKlIeQocf1L9NASnLVlDpSTMwsCkJ6QAmyhDWbbaw2i6gKMpE3XIP/ys1xQhVXGQrg045yiYKctxWHXx9UNpFeIA==
Received: from DM6PR17CA0027.namprd17.prod.outlook.com (2603:10b6:5:1b3::40)
 by DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Wed, 28 Sep
 2022 08:19:57 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::b6) by DM6PR17CA0027.outlook.office365.com
 (2603:10b6:5:1b3::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17 via Frontend
 Transport; Wed, 28 Sep 2022 08:19:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Wed, 28 Sep 2022 08:19:57 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 28 Sep
 2022 01:19:45 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 28 Sep 2022 01:19:45 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Wed, 28 Sep 2022 01:19:45 -0700
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
Subject: Re: [PATCH 5.15 000/143] 5.15.71-rc2 review
In-Reply-To: <20220926163551.791017156@linuxfoundation.org>
References: <20220926163551.791017156@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <52a40942-4b98-4caa-b704-ef80891f204d@drhqmail202.nvidia.com>
Date:   Wed, 28 Sep 2022 01:19:45 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT067:EE_|DM6PR12MB4516:EE_
X-MS-Office365-Filtering-Correlation-Id: efaf73ca-567a-43a3-7672-08daa12a3aaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: niEGbXGnEZiFY/dVZxxatvjKzNqbrADnCU/iPHsIeSXlt+epMJi3Ly/PHLESWSeap9qcS7vYjjw9S7dalZkftBBLi+PRlf+jXUQXu99W/p9R3GLFr3x9X4Ijx+0htzAgMDSNR+AIa98nUCbPpBflFphLiDI9SzPaDOPVo8vLoaFYo289JVT7zDNoir4w+qAGUqiAky6uUbAChATS+B3DSx/l72nQKGlp8LQHqK9dXiFevWHtlTDe0AcYfscAAGr98gbOul+DBwDwRHhYODUt0lx9uDgPw8sFXohZYMcVqqi8tqJc2vn0Lwsb21EqmW1HTUnyBRRGuNCS0shN1rYWCogSvMI6iWNbxCpvx0FAHxjMAu+bFvYoRi5yNNlgrLkTDtZqG9YIrOn4vDuR1xTM2y8RehBLUZlCeLeuI5R+Oy0fRn7HqVYUR8KpkcPUKvFEGh5dBwvaBWiTmu5w6gyKOoOqUDSLdwCVf4W0xa4Bigu/T6ZueSZ0oHXm/KM5l7tTRvc2ZShzAcULjibU2mqO8iistkH+WZ+CzuVpyy8WncppxmHVYyrngsRlmTYeWYVhBGygM/UZg2yjhqP26dG5JN/UbjAbp+bqxzjLuChgMOSaVtJLQDLNjJCpCBvU0WqZ+5OKl6b2lxLxJjC9mGIV9I/Baff5YzuVIeXs9tybdqPkKkVdzIlT/BP0EhLGy01Z9tKOux4hBgkWdlYkKsreylen2IIyLIl6rmiYWy2H/FNAokkm/baccdkIcv9yt3nolqfq7qtIhUoTiWhWQ4hPzBTGL0sS2ClKNSEGVR01gweAgzvqU0A4FRUTDl3+q/lsaMKfP9yw282AV6rt0XlP9SFpYbIHGYVP5VQwF8nZXk8=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199015)(40470700004)(36840700001)(46966006)(8936002)(4326008)(8676002)(31686004)(54906003)(966005)(186003)(6916009)(478600001)(316002)(336012)(7636003)(41300700001)(82740400003)(26005)(70586007)(2906002)(40460700003)(7416002)(31696002)(86362001)(40480700001)(82310400005)(426003)(70206006)(5660300002)(36860700001)(356005)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 08:19:57.0216
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efaf73ca-567a-43a3-7672-08daa12a3aaf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4516
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sep 2022 18:37:05 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.71 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.71-rc2.gz
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

Linux version:	5.15.71-rc2-g0b09b5df445f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
