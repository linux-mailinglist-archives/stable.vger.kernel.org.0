Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5524F5C78
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 13:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiDFLkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 07:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233815AbiDFLht (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 07:37:49 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2047.outbound.protection.outlook.com [40.107.236.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187B65777B8;
        Wed,  6 Apr 2022 01:26:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdLojayXuj+UvRJsY42WjckUN6rFLaRtKjR/nSButjiu/pYhgqZRPeLH6Ot6/NTwpGpmW6W5Skzg/lD0UqPAt5KUR+UMGxABN03+ALvKlPZPEDAOMfPvruGww382eZ/uBpv5W6uaBvA0ZSosQxRU5veZkdVdRQq+PFPkYUsDwOs0Ou+C4yRTZIkcJCCERqg1ZSZN+oWdEF5V+THxIUuCWygD1N6oL70m4KqDJOov/0URdy6E3rnnKD7TZ6AxcR7nO46M8ZyG6zREXiS3Pu23KcUHJnupqpPXJv5bt9zgrvur7rOSbBjqwK5mpfBtctkK1ql64gtj9PGaBjEiJS02YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cuG6l5B+yJJ6Udu1GNxaFc7mg4TXK8BqysXivfnkF/E=;
 b=kGatIL+qKCbNgKFVXJD3FnYcQJGVwYhn9Kg7kjrc3rMP5B1bxbDK1N4v5aInmDAVw876+5465Bvte5w+H6tCh1S5dPL1hjMcThZxU6eJo+YfzLCO3lguIHvnVQ3/eXwfcbnjqenzFpUYDKB7usmeCpbxNyY0oqwSafBLAn1UY+cAc0ay+0aornaRVFa4VRghZbBuVVKPpcmlVJgI/2MW4My1pKwNXgPir8i4u8WbSufiOaCQy1vWYfdzBX856EYtqhUyF1hlD5U46/3bsuLTCHVrKaqImgN3oe6szKQ+tazInyIzdL8oMQ2g0pJnNVuW09t/Kqr+0SKlE98tf7XBZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cuG6l5B+yJJ6Udu1GNxaFc7mg4TXK8BqysXivfnkF/E=;
 b=q07/6jTQog4ujksFxrRoJKqoaOY07Bk/NatFTRS9ioAZ/hJdh32BO6QhJ1m06c3mee0cMmYbI/8uSCEAlMr1rshdERKu/qAhT+X/kUkSR6Ahnt8ZCAruI5s2UHNI49X0hbGmpcBl3hrs/C0BO9sTP9UnC7GkJ/6DYZugk0T+xSt2Bs+Xj3phvlLGqB0jr8UioXn4IZFvrGXdqQVN3xMr7V70gamK5DYxwNLAgCQFnzNR7P6BaBWTQmIpUKkjDBMRoCa0adZbwP4gsLO00Ai1BnAMY7sNSq4I0zo+075XSxwEP0tsGty4AhrAflevYa/kIKujVsJs2et4UfntClBdrA==
Received: from DM6PR13CA0005.namprd13.prod.outlook.com (2603:10b6:5:bc::18) by
 DM4PR12MB5294.namprd12.prod.outlook.com (2603:10b6:5:39e::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Wed, 6 Apr 2022 08:26:45 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::19) by DM6PR13CA0005.outlook.office365.com
 (2603:10b6:5:bc::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.18 via Frontend
 Transport; Wed, 6 Apr 2022 08:26:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Wed, 6 Apr 2022 08:26:44 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Apr
 2022 08:26:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 01:26:43 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 6 Apr 2022 01:26:43 -0700
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
Subject: Re: [PATCH 5.16 0000/1017] 5.16.19-rc1 review
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7dc78e41-1284-4de6-825e-c35cd22b418b@rnnvmail202.nvidia.com>
Date:   Wed, 6 Apr 2022 01:26:43 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d785451f-d3d9-4b40-098a-08da17a72f63
X-MS-TrafficTypeDiagnostic: DM4PR12MB5294:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5294C71EED0E21043DAF1D72D9E79@DM4PR12MB5294.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: THEiFcmZcTCggjWH9b025Mfaj5Kc43/gRU8UvbjQ4SArdwR2Xt4/Jz8Eeugh79elgAKJCoiTaxyXT7JdbNW5Hszr986Y6kKM1bJwOwmyAhhuHjjwkvfVuK+4zh7mBL349ZVRkwvyJglVDG0wPHo6RL+nE1MQYikFttqKOTke3GTChzaydflhInD23YqTluDxzp3xT5KvsNu0SSzFO6cRRYkNhRIE4rDXaexsL18SMXKrSvDi9Ryoc11Ya3XBjqtFDrV36Ud8F9/HDDg6L8/YBYYTC4d7XfKw/ZfAo/tuYmtEEuDGptDuNsRRTdzL5nAfi93nyv2BdOI5UAwhv9M4nFmbyw1NzBGNwxn11no+P/Y2ojEHj1CVVyA8aR3ke/gKD0MrryYfdWFShpwqkP5ohFNP+HHu0GranRjY5YuBmktFd/faiqlipYRpF0IczRrknP7doDDsPEkiYkqPzexH0BXP1iUyXk6RhcRzNn7BBARDdHBdZ9iTuP7rSHTLnwk4pSnjL5BylExhejeM83229zLEfj8hYZoWK0Y6sMpNTUK2uEIDbsCy1EYN2Ehchv9q9NsvT+5p5zgDiJcrsVuiWH+2q9wUXkJAoJeJCxd3yHBYqfJ6tTUVGQaWtdzIw2+GuRku+6OKvtv9gcIe/ZFEw5FtDxbgeuLSXNvGfMXv/sTvt3DnwTgI9fMfWUjg14Zrnm9QbxDAgH0jUrSLSGQkrxHsy3nKxqv7VscCVTDwMGZBOQaLnt5F7kZd0heaP0jk/v0oh2anYIsmfwnC8/elWeS540fj1flsKZEnTwAPsZ8=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(86362001)(36860700001)(2906002)(31696002)(40460700003)(81166007)(5660300002)(356005)(7416002)(8936002)(508600001)(186003)(336012)(6916009)(54906003)(966005)(82310400005)(426003)(26005)(316002)(47076005)(8676002)(70206006)(4326008)(70586007)(31686004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 08:26:44.7249
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d785451f-d3d9-4b40-098a-08da17a72f63
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5294
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Apr 2022 09:15:13 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.19 release.
> There are 1017 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	5.16.19-rc1-gef4d007f65de
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
