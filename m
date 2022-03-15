Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A994D9707
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 10:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbiCOJFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 05:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235860AbiCOJE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 05:04:59 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E3F101;
        Tue, 15 Mar 2022 02:03:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNAiT7bm2S2Y22o0YMMW1K+Mgz6J4ZFPtK3y6CdyP3RAgNUUNY53RZXKYLSS4YXZZxUFIIliHU314XFflCBWXyfqIAJz3c87SLyPPOGUsu3+Uv8l5U50AVJQ+a32Utq7uSBfo/fs9hukjNKjfcMQ42vcAtUrnmujaIITfi/LemyKJNkGGow2re4iJWSRLmrwtlGXlH6BGsVF925jJwP1843AupNtWZ2ufkYO4jshqOPHoy6QKR5Z0D8DbQj91JZSlMZ2RyUG04VdXg9UftvXbr2D/b++Ja9+SIY+vmP6/uDFmWFQvunnuv9pakDUXTsHuDpTdp2rHKovcCwtF7wG4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cpz7d3sfrSrypfqszRBSJ5sbgUwTL6EOpxyvfQd27vI=;
 b=fpJG1qoPhCoyGF0JuMzyErxsKKt9XlLi4tttI6Mlh2ZJH3y03TbXzwbfcS533S0H8NqQkJopz86/wQnCgf9+gBQ3O8BL0s8fD8rRBkqeE4qUBshYuIQrSy95ZN7mkjMxlSxVKBCVDLFOo6TU25vcoZOgfOKIcwzWswXCV6uGW2x1r+XR+0Q3Jm2fzEz/iQDdNa35vie0qn2uKDAn1QZjOet/j+vMQjHdfXPXJR8lucobjLdE9bCKEqRfZ27sMLzoEP8TIjU2aCn6nuK3xUyIduYAB8UVmY4jc6w4MQghVFHQLdGdtCmDMc2wEy76jb8dvZ2gfeayyjdMbi1LEeJgJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cpz7d3sfrSrypfqszRBSJ5sbgUwTL6EOpxyvfQd27vI=;
 b=QCFEDyS/mb+BjfOoy2MQRxDITxYqzxugbxgUcAFrwkwFHGOcpaz6cBmlNutdut3cnaQKXYKHKlQLoAWcLtZCorE5jQ5fAVLxZiTU31pym2YjMY5vvlUQ7S6AAyYX5D9ibgzEhsUJPuZt8q6aniP/Q4P6eFHOor2r9Fc8faVALQtOQSA/UF9XjrTjkadONE4zL5F1+JsuX5Wk0nnkgaiU8b8cvvFpddEzV8K58u/KTwCHpnfwBqJBv+idVkIokz/QGtUFv+9Wk1gCQnPQzipsrc8iIOOsHcbZraK6syq9beNgbD3Lv+wu58jh658XMzX60j4nFUthTuzxzxU+dKvZ0g==
Received: from BN9PR03CA0202.namprd03.prod.outlook.com (2603:10b6:408:f9::27)
 by MW5PR12MB5652.namprd12.prod.outlook.com (2603:10b6:303:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Tue, 15 Mar
 2022 09:03:44 +0000
Received: from BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::27) by BN9PR03CA0202.outlook.office365.com
 (2603:10b6:408:f9::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.28 via Frontend
 Transport; Tue, 15 Mar 2022 09:03:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT042.mail.protection.outlook.com (10.13.177.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 09:03:43 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 09:03:40 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 02:03:39 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 15 Mar 2022 02:03:39 -0700
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
Subject: Re: [PATCH 4.9 00/19] 4.9.307-rc2 review
In-Reply-To: <20220314145911.396358404@linuxfoundation.org>
References: <20220314145911.396358404@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <19437b3b-9262-47c8-9839-862bf0fc959f@rnnvmail202.nvidia.com>
Date:   Tue, 15 Mar 2022 02:03:39 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4063b834-aab5-437f-c56c-08da0662b512
X-MS-TrafficTypeDiagnostic: MW5PR12MB5652:EE_
X-Microsoft-Antispam-PRVS: <MW5PR12MB565257BDC4A84AE1F8990976D9109@MW5PR12MB5652.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jdtVmMJhF18Kb+MOahnyrWIDIE7sGGyOqxumFAC02Qh0rdTjbfGG9egfZ36Pn5RMRtXudmqh5Nf6ODmpUYRMRXd+OyT+nmPKtqukWAdcQvYXAYu4Gkz2jxAkfei7OrBspPBqN5uALbeQOH5P7t3PZM0O63uVhRdKXoKZKTjudr7xKqyTRkIO+SXx3Fxls+YTkE8kf8xYFdQPpBWUkI3Z0kK3iQXzMxogW4aS8ArYnxo/GbUIZFvMMNXV1EsyCSNo+HNRkKP+bT85aTZD8qTl7YVv42GchNxYV+Wn1pb/jL1DbDWFjEsbdXHbyNl4FDTHZYYrDiEFTOjFz3GDskuGc7D//lrKAnAcpGXEhB5l+NIVKYKbZw4c8abpbYrb64dOCF/ZFh7l+vdlEed0IqyUQSUg42EQyzYMHG2rJua+fIf6kNwuqOh0jRLcNHx6t7u3LF6slH8IPSaE7rH/W6MwqW2o3XodEds/l3MUzE1qSl6wIwVue/VgK+uRGmmpbDn8MudxS0H1XtArRD67dXlWbPVJ2H0kmfO61LqI8mphA0Xm74koQYYzmhBCq9lKJa/QHXupGHj1SZWCmybOV7/iqtejWJfLjkpfLyvzyNV/XSHz/lESHSwRIoq6P9TWl+8s90EkLk48PLQtjLIKCwb5T0y0uAVBFHOjmxJrH/6eJy1NmQfF1BcWJZrZidpXlOeGcb9djYazWSPu+MXVPc66ENoUMMlLLz91GF9WlJoRZnOg97FQeqNJ7ZKaTO8pTp8lGOWmgNTuLLmJZrma/Z4itRa1nk3h0IQNn+r3gy9H6xE=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(8936002)(36860700001)(426003)(336012)(2906002)(82310400004)(7416002)(47076005)(5660300002)(54906003)(316002)(6916009)(966005)(508600001)(186003)(26005)(8676002)(4326008)(356005)(70586007)(70206006)(81166007)(40460700003)(31696002)(86362001)(31686004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 09:03:43.9095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4063b834-aab5-437f-c56c-08da0662b512
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5652
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Mar 2022 15:59:59 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.307 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 14:59:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.307-rc2.gz
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

Linux version:	4.9.307-rc2-gf465fd2bef70
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
