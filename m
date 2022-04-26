Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205BA510323
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 18:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352928AbiDZQXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 12:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352934AbiDZQXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 12:23:35 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D38C74A0;
        Tue, 26 Apr 2022 09:20:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZ4+bZdbDUHCoKej4O/z4TVD5Cu3J/I0DLaSCfkOZZXrk53PoBVnyg+Lrbcf3fHefhSD5Z2g2ELGxwQP3AB2pMHftRW+oN9mCbXbYGZ+Zk7AdeQM60H/EeNH2pX7Oiwhx+jvGAsEUKpTLjXpXAE3EFEFzE/ap9HxGlkXInnN7GteIUHtp7YWYaD6c8Nquo996IvVlz0rB0FErnHD+/KCcwZut+q1QMk0qvZATSst96iY84zTwPDXIruHT8GBtPjve8mJjfDkPidYHZAWdeAg2WAFJIaaKU/GejYUN/53mL07pved29lBP0Y4fZ76qBxSvlGz5Az5Zxg+fNLKSz9Umw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AhfFqVrg0S+JjkGvzxKPluDNw740dEiIvv9Y4Oz26mM=;
 b=LX9zW6Fbp6DrbbiMri6hj67fa/mAiouzw/4zgOwMkPNz1kq3P7TYH5WHE/Sh0pbvNOqMq6PpBjYXDlf0aHWCNAmz9ajTh5R+Q/4kZj4wJqQD0+soU8b6Cqw7sRbP9UG8GS4alaEreyBKKbNiV65BShdg5IFzIGbKWtR4unqy4FAZev33Lb62iY3X2hAW1WmNA9XoVfKF+Y+1t8ZkSgBTEPk1ze1/oZ4r8Da2q7CX7tizWEGkAp9xmom2CFCnda4JFJ4eyuzFHEJjBOPxbpSqxYxsdVTxxlGrwWEQu+rMOcuKd1ry65qsYG1407R2x57cFJpnj2xyejOZA8bYTBZL3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhfFqVrg0S+JjkGvzxKPluDNw740dEiIvv9Y4Oz26mM=;
 b=lmxhsvv6g51TI9NgGRD8Smj+Tt+sq3PpBxiVq3fUUBble2tM+Q8U8i/r21pd2NIK/+vMc9MjF/7sEwIR0bfbiGquJEkyKYfxUvcr1Jtyc2EsKbwdnsnnArSWyxeFaoCJ7fyLHEbDL+Oz84IUDVLBwCYBnB1EyhRnBz0UzypEIVETloEUcjxlE5+JolMMQH3U/Xt9lz1XPw9fVqoKLmcNkM1bBWVtEkx+ZhFA3LhXA3pryuI5aenlmRMjDafPZX/SrQm8xnTzuQdBHuV6tkH6z3mXq6/ef8vAFSX+1bkOkYpW7R4CE+V6xyYTb+0y4IP535wrIzY11mR82JVSE6Ce+g==
Received: from DM5PR21CA0015.namprd21.prod.outlook.com (2603:10b6:3:ac::25) by
 DM5PR12MB1450.namprd12.prod.outlook.com (2603:10b6:4:3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Tue, 26 Apr 2022 16:20:24 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ac:cafe::fd) by DM5PR21CA0015.outlook.office365.com
 (2603:10b6:3:ac::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.0 via Frontend
 Transport; Tue, 26 Apr 2022 16:20:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Tue, 26 Apr 2022 16:20:24 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 26 Apr
 2022 16:20:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 26 Apr
 2022 09:20:22 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 26 Apr 2022 09:20:22 -0700
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
Subject: Re: [PATCH 4.19 00/53] 4.19.240-rc1 review
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
References: <20220426081735.651926456@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <52deee3f-531c-492e-aa6e-c28d9f501ef5@rnnvmail201.nvidia.com>
Date:   Tue, 26 Apr 2022 09:20:22 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28318d34-8171-4558-990d-08da27a0ab10
X-MS-TrafficTypeDiagnostic: DM5PR12MB1450:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB145027287611D8E43CD6C572D9FB9@DM5PR12MB1450.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zfzrPWMmiWIeLv/e/1O4n4L1Xm3sBoNVS4sEBMwZCw96u4Kx0bQ6sbG3DN+CS4vn0OktrRmohlx9AjgvAOEUdF7CsnO3FU+Canqg7m8xwpbBr14AN8l2FcoNljK1lcCsijgZ7dIQMK7dhU8arqRyFX2ZyWT8dvA8uIesskS/5KI7gNV6lPpUetk6LtCeswb1R++0Xa25VXb9eZeI9yrTw7lf2cVp5u1NkW5fXlMzLXu8apPUAct66yxSkbOg9qpVhm4u/qjlhSulSW3Xh6e2ANjFqow4e4JvL2P+sPjThIXXAy2bksf3FCLC+zb4Z6WVNtX//waJs8SnskqIp5/ODf/3SN0JsfFWQ1KqW1q7vQn0vEmdnecTq8RFXFIQNxT6NLNte0V4CHpYgongrB8LucdIgEzck33BYff5/VSB6OvUU2negZmbmwTZaEGscIU49HwRIfEQPA53oUjq/JF+F+llMCHZqoXZy1/oCD2MbNlBojs/YuJSPUJ3B9K6fEfA2t63r9VUzrujejM1W7lP+rCqLq+wuYxsikaDVyCX1fn528Q14TU8nYPjE3Oa/LMiEqFUNiNF2rZGK3mSxqOasHlyKgeDWMgEg0mWsnDJhK7Kx34vn+p9SDNVY0ccZRs0HrvjVVhYnpq27O8L4PrFVUbONczV5LkFNYzHJG8dPPDagfkvSbRp+wfF+KA5VKxGDQxjxkuhMgh7rQIKoncaCs4jZAJQ0SZxk7Mu/hCCdVrLfulWAnitYxdA1hvQzBzYabJe8t8vHuGzvsSDFAjFw/nuce62oWNQwgSJBHIjsVc=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(70586007)(8676002)(26005)(82310400005)(426003)(47076005)(336012)(316002)(966005)(4326008)(186003)(6916009)(81166007)(54906003)(31686004)(8936002)(36860700001)(40460700003)(7416002)(5660300002)(70206006)(508600001)(86362001)(356005)(2906002)(31696002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 16:20:24.3495
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28318d34-8171-4558-990d-08da27a0ab10
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1450
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Apr 2022 10:20:40 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.240 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.240-rc1.gz
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

Linux version:	4.19.240-rc1-g5e5c9d690926
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
