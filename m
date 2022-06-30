Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B2E5620DE
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 19:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbiF3RJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 13:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiF3RJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 13:09:55 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0546522509;
        Thu, 30 Jun 2022 10:09:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoyGgEVO3WY3nf9WBlKV3O1JOXmH3p7Y6p721s73lSiDFv5fqz0xIJKeLZ5ecW9vjrKkBGrB/QBlwK1ryPsOWu7w89UDlejIYIEwd95eX9rnko9wSu/s4yanD2wwIka9oW6+wGsShwra5Swgj9fyZPyxwcfpKpPpUPaAP75GLzWNUuJgKpfeCnFGtjWlsynqmWRLOCRpnNzjwEQVT/xqgfb9LOiQFu7uyYaBe7IGkuvu3yJUlbQOQgvSd1Wq05Dff/9INwq5a9YYiB2EsowgQBIMwlqFG7B/YeHc+HtLJ6XhC+gDbL+xRweZhfXWKzd6vhxkU9O4K17aTEjO5uEvIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQW4U/W9jT+oYSEPXRLXqrXCIfNCZe7kvPWu5mSnHCs=;
 b=Zrt6GKWAozdV5OWhlayqhVDh3TfIrd/IXkmZk4YxczkiMzVsuQEJKEyRJ7mDkky9vBglXWRhUGbFkk9rot+zdxmmb7d/B3THN1bDFvpSPndFc3Kfrk+tLipBkv70c5qkZsh4a4pN1ThtZLtAkc81vExqYFDQcAKSu4r8HBX3iYY7G4GsWMv1sg+Ctbwrab1LViT2XSS4W/fAlxdx5Buxhd6I/DP/6KdOiLAVLFOihTZuzinrqyJnzrGSKoHwsithK3I9KHOXtJ1V1kW1Eeovt/AxqMDUDbGgqR3wA+oEI7WZU2J41uB1Q1BPI7QaMrJEHUWty3lSGy0LVC2J33S6ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQW4U/W9jT+oYSEPXRLXqrXCIfNCZe7kvPWu5mSnHCs=;
 b=PlMj19eZs0IYfcwnYua4aVlhTUro5MYX1s7oZbfjPA+2f6mdXOlK3Ku2qh+3dPgg2Ba3mGQYdgXvaunqjjm1yCAAk82jXINay3ZjbLiRYebMuHLX7BbXGowsddUeRCCTLIYjhhaMhMsJsqvmw7zoAzXqfCWYbuHw9x6ybJlFJBX96epmpJObBkwg5U+vk8wVls/OAThF3mnkKwBhKTTmFUF2T/qkL+pihXe3yFMcQsJRbULJGkCewqjot0mmEpqnJ/FlJnptndL8PylEA/9ujfL0wkQsDpklRC2bp9VFoVUrupfIsZzyGs5sAUR01ntQnQVLqGNisb/ZTYkVLLV/tw==
Received: from BN9PR03CA0956.namprd03.prod.outlook.com (2603:10b6:408:108::31)
 by SN6PR12MB5693.namprd12.prod.outlook.com (2603:10b6:805:eb::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 17:09:51 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::bd) by BN9PR03CA0956.outlook.office365.com
 (2603:10b6:408:108::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Thu, 30 Jun 2022 17:09:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 17:09:51 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 30 Jun
 2022 17:09:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 30 Jun
 2022 10:09:49 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 10:09:49 -0700
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
Subject: Re: [PATCH 4.19 00/49] 4.19.250-rc1 review
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c699d96d-d8d8-467b-846b-60827f6be779@rnnvmail201.nvidia.com>
Date:   Thu, 30 Jun 2022 10:09:49 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3343db1c-7cdc-434d-3a71-08da5abb5875
X-MS-TrafficTypeDiagnostic: SN6PR12MB5693:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r2bteFjK8IjMPyOGNUc08pZF11T+Me+a84ydBDYfZTffQcxfBVD1N2kHH5zvfBWlnGuWOU3nirUMu0hjY65nY/ZD2sRxgn0/N4dielV9FHstvmfX6NvkbfKKB3vPXYhT4psqa92cVd7RGcX5DDJX5+8liQM5mKN8I8VQFJ5yAQJZeh+AtRpzLSgH7pVeWTqJrpq3F+lhUHLc17T6GXVnMic/BjBoQUeLTXKy+D9OAmNd7LpOBp8afQ7ssd/Vw017MPaCOIVuzDbcfSPOXA1wiglZMjnmO7moZhhuTXgZVHL+hoI+ktqU3dzM80n21T4/Fl4ceowoRUdE/5rQaGTghrObQIEO0oePxXi2KubGRoq69/2p5cXywbVmsekE2mTRzN9ll+R09wo7DB+0N5GifAqQkaVznbWnB4u3gjo144k9QZM6NdjGgILmCwOqplPVvjcNGdZOnZUxgJ5mtqkrNVu2kSG6YZr+d3zk5RQKXHjXbhLlcU8bl0hJW1KF/FcBaqs9k7UspP3Aml5Q16/zDu1WvHJkWa+CkxO8HWXp8MaOz2yo+Vjq+TS1rqcg9eqKSKJ6lJYa+8zsdJXc6Uasd+kZZYqOlRKz1A8tD3SWJKj3hgFM9j4fW0nUnrdcqtF/9iyxUg5ubnWX+45wpRm/LFaL//ZZolKp4l2c682cHdBwLhpIQT2PFrAKTlLn6560qIFXQht/+a2CzgQB0bziT4nSZ+RzyUYnDy7oxSq8/UM1xyXxBLX+iwiqe6Na0qqiz0WflhN7gUE/FUXIc0kK5FpFrx3T1LCnKyZCzGIKGoBDs9Ekqba3uR9BsEtrwOCsV+G9ZtAUZEcEx68cKJsdQ9D2hJJ3EstllTO6dVJtByMVto7GEp+q0JJlnyUYbXMQPuH+jgZsZX4DRpN6RTg5pa3jWRSezeOxFvkl6RhMrffqRp1jZ3j9YQGn8Ve8gOOD
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(346002)(136003)(46966006)(40470700004)(36840700001)(7416002)(40480700001)(31686004)(316002)(4326008)(82310400005)(40460700003)(478600001)(86362001)(70586007)(5660300002)(8936002)(966005)(8676002)(54906003)(2906002)(6916009)(31696002)(26005)(426003)(186003)(47076005)(336012)(81166007)(356005)(41300700001)(82740400003)(36860700001)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 17:09:51.3933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3343db1c-7cdc-434d-3a71-08da5abb5875
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB5693
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Jun 2022 15:46:13 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.250 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.250-rc1.gz
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

Linux version:	4.19.250-rc1-gfb9bc205ce08
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
