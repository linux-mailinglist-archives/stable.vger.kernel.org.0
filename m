Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9959657B322
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 10:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240085AbiGTIlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 04:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239928AbiGTIlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 04:41:18 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361D166B85;
        Wed, 20 Jul 2022 01:41:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LeiqMIUgEAsIzHZPcPJRolLzJcJCShQ11ue6Uq8KHgTNRvNCBVNpeGqDX7lIGewd5qerGNPeZsFAikjhjdY6MArS0+vigAo5c6GfJqZpWqv2UkrjK2AO0ZZpMXHybnTbK7WhOqMbgjgJeeDzoT/EfqHpjFOwcVve6uCED7ePOjU2vIhBbqbSeVsVkHoG09cSC1p/c7G9ITO70YrQlWHbrzaCt4waN3i7Wi4ue1kyxONIyCTaMU/4tp7hRsBm66NG+hYXJuqIvppxP2dQGrkfpICR1hcjW1OHXWV7zl9OeOoPdpSGusXPj66pN0GL0Wh3grN2fdsQPqjugtYcw1YWMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qek6jv+r6pUxUIcOqZtOat0QREvwVWggj395kYPBukk=;
 b=UrlDXCgUQiXa54RSCQ7u6ZaaXzuNB8xWABGYJhIV5qmWtj/D+V9m0y53HZf/pLgYkofzTzKjCCJxvHWGz79cPM++mes9AVcDK3DPtJbyvCT9bGNRL9Z6GM3USQ+PB3vdWhob5K6ZpBNtu3YGi8JBB5o3beeEdzNffUIJwA+WgIdjhM60OaDu106Uff+Ylybzo6tU0Zji21jMGvAxFA23as1cGnhVsuSBBdx9wp1vhN8WQhV9XKesszTSXNguAKGeJDM9LkRoTrWYrx+ipdL0e46yfEL511iM86xwxOsJHM3MoMLd/j4IA20BdYdmpf8d6jaeiQ1M0AYzd2B0OCMiug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qek6jv+r6pUxUIcOqZtOat0QREvwVWggj395kYPBukk=;
 b=s2OZiGv9cbz71Ex95HT+HDFZfUnW/71Aazur8CVdwI7o/9/96OEhfykn92LSzYmA9CVjXbwI+36Q0AFkYNAYnJeB26W7I2k1UJB9fI8y1Pz5/J2UjG5p/vLghrZpUjm5X4tozKNz3chDDLDpDl8NyBwKcHYXuGG4fU6zTTPCmoyxfespBxHxjAi1LsWlELPPOlIx2aKy9IX/9Zqm7aOpGHNlV7e4o6XPrqsnsqFiBOdMqfvhx5n3+m906pAa0jQAjUKUbtwehi40piWbVY/T0firwNi17IWF4j4ViC+57J/4owbkFzB7qAxJdGawXjIZm1kK6cAeVD5juPoOc8CvPQ==
Received: from BN9PR03CA0785.namprd03.prod.outlook.com (2603:10b6:408:13f::10)
 by MW2PR12MB2394.namprd12.prod.outlook.com (2603:10b6:907:f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 20 Jul
 2022 08:41:13 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13f:cafe::8d) by BN9PR03CA0785.outlook.office365.com
 (2603:10b6:408:13f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18 via Frontend
 Transport; Wed, 20 Jul 2022 08:41:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 08:41:13 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 20 Jul
 2022 08:40:12 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 20 Jul
 2022 01:40:12 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 20 Jul 2022 01:40:11 -0700
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
Subject: Re: [PATCH 5.10 000/112] 5.10.132-rc1 review
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f90aa9d1-a3a9-4582-b4dc-139c4946d328@rnnvmail204.nvidia.com>
Date:   Wed, 20 Jul 2022 01:40:11 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a08658a-72d3-4e8e-fc9e-08da6a2b9a61
X-MS-TrafficTypeDiagnostic: MW2PR12MB2394:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I/HJ3RMn6I7tO2ToXkQqy9hFeeU7HFA8elBZGZQutitb3IJoBnQMjp/z12ssTcmnJNiywPpZRTdW/oYIUALNDNyBR7/QLQxkT0eEdxCu9HBsald9/vLHH6PYJ5uWtl28ls76yIS4cA9OQO9wHZraxtDVVu9HFByEes6WFQX27pH7y2mwdlTwztXyoU16jSG0WcIvR67HGYaxzrSs4Nbd9BPp+5BjAmh4FvXHwkBxk9o7UXmdLJrwzyRp/12LxqvF+gW+TnieWDM/Zr77Tpj1zvlLr917jmD4k9e12MsueFSXAI+7nit2UFj0Xmf5aGN4b7gCnHg2QA2FzSWkwHajZCjae9UvBjlNq2hJn2nDWQTiLv47QJub9t/Vxcigz8gb5Vd+pCp5eGo8KVlxoitBWtkiWT/ALpkFAalmHeyqM0GfuG2XsXRQPhuO69gkllYsXZVLSjXFQfWdEsB0N5X7qrlC/GJzuhAQMa1sbi3Gj+OOKmr6a0X2YImC/i2mGL4z5E7KQ2TaG0uJa+C30F5/r58Gb27ni6MFn/iMxT9CLz2R36WNIBAfGHvcEAccdicI1veAg6vzTNLjrGRdvOVT/rpOhGSwLZ9CZluEsVyGPfKrA6lOVBBPgC2uPaUZB+O2WtGxhTXxlG3BuUYWRLRTXbbCCS0NXpDsKtUYXG/TxH4d6/QlOvIjjlOSbF0WXIvrjtiWtLUoyUBeYVlx3TiCMqDg+MHqTLI8C8S6GD7+HBNxe7CVEDS74y6zKx5GoSXy4CgEQDwm68er1Y7icUcdarB1wGIvZamwcdF1r4hu2wUiHDUsfdwh8c50ACOqP9VSDxeoU3Ln0o7hNVxYA7fT1Kcy4/TQ0GjNcn8pp5wlGcCcm3e/a0HSSVvn2+SUjVz+JAo4keaklvcc7s4jk62+sQK9u72dvooE207rzwEhnX4=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(136003)(39860400002)(346002)(46966006)(40470700004)(36840700001)(82310400005)(47076005)(426003)(336012)(186003)(54906003)(6916009)(81166007)(82740400003)(8676002)(316002)(40460700003)(356005)(31696002)(86362001)(70206006)(70586007)(4326008)(478600001)(40480700001)(966005)(36860700001)(26005)(41300700001)(5660300002)(8936002)(31686004)(2906002)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 08:41:13.0878
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a08658a-72d3-4e8e-fc9e-08da6a2b9a61
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2394
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Jul 2022 13:52:53 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.132 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.132-rc1.gz
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

Linux version:	5.10.132-rc1-g024476cf51e8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
