Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADCA4A9BDE
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 16:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359656AbiBDPUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 10:20:54 -0500
Received: from mail-mw2nam12on2043.outbound.protection.outlook.com ([40.107.244.43]:31841
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238356AbiBDPUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Feb 2022 10:20:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXGm2O8MhELiE9EJPuGnUy5ZUyxscF/8haYprhyBkXdIvE6lZAS7S8tXSt6rjaywelR3LPphuZIK5vDKs6XMa21q5va/ClkTfjvaFlt/cy/JjZhmF2e9bpV27hsQsVpWEy+Oksum6+3Ekp6LsHYOTEwfD9qVhvVRDtUjg+5bVZMqF5tduJoVNup/bV1G/9Hu3CHRNo1vcu/wBCbihIyiE08ZdxwmekrPd72ZCszyGWNUNzdc0PReYvfKR9SW7HanTan3dJzfV5zNfH03yJlkUnHLQQG8c/JnPdhaXj/kpsrwTfEHC2EjrIqHFPOkyWaQ1E/uRnGwtUsLb2x8gHiG3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y2RsR3KSupacRtu8VXXouoh2KpbpTy98JA15In0jlD0=;
 b=DDjVSKNvUFMMTEyfuoVemSgMPl6RRaSA8RKCY/rnW726zqyghyNDxcr9shqWXgTVv22WdHZzCLYHqZOTghEuBJSO9B+rGOxIz+LuzvMIkTgQU56g7HehaXnQs4mIbb3RFacwsSg8VdIjwQLAwq4UqJXwhRQZpUH90yhQZMbJT6YAidGgdPNk/MjDuML1K7XxA98BzWQb/TdiAiHBHLe2GA2FTF98dhocIEZr556RP1qboa1ItQCUQlaBio8K2PEZhlb8mT/oTnWjfVEvMkslLXmlqml/E+58i4GbvzDw9HdyXtW3lfik66kqe1psqt+2hSCJOzHHSiJ5VQb8pFbhlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2RsR3KSupacRtu8VXXouoh2KpbpTy98JA15In0jlD0=;
 b=YOeBNsZD4FFJboqMVJ/NPtfJ12UsAlFxca2/mG1MISdYfFoSsHjsdDILLoZ5Rm/6B8TxnM2s8Ix+FcIHe1WFEJBfExedpAnzX3Fk41mgE8JlYlHOMt2B8ugyM5Aon6csfHSYUuWiO4Ik8gMYpiGc54B27E+YF3MM7WbRH++Y4xXpcKWPZtZeMIiwcgxFtMqOIDPbUu3dbLkU1Uy+TxQUYQHIjzmjCwOPEGQIcRO3vEjiWpbxxToXe7uyIFC69jzD2Ab3h+aIA05nD4rpTHO3QXckZuqLO1HA/d6fAl8aXQ7I3aiTu8peMvjJtIm3JlvnF+fWPC5/pekpT6i02uGaiQ==
Received: from DM3PR08CA0012.namprd08.prod.outlook.com (2603:10b6:0:52::22) by
 CY4PR12MB1461.namprd12.prod.outlook.com (2603:10b6:910:f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.21; Fri, 4 Feb 2022 15:20:52 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:52:cafe::8d) by DM3PR08CA0012.outlook.office365.com
 (2603:10b6:0:52::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Fri, 4 Feb 2022 15:20:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Fri, 4 Feb 2022 15:20:52 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 4 Feb
 2022 15:20:51 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 4 Feb 2022
 07:20:51 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Fri, 4 Feb 2022 07:20:50 -0800
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
Subject: Re: [PATCH 5.16 00/43] 5.16.6-rc1 review
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f488c5a7-3569-4297-bea1-5b8a0aff4d70@rnnvmail203.nvidia.com>
Date:   Fri, 4 Feb 2022 07:20:50 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b0a66d1-400d-456d-23a5-08d9e7f1ee71
X-MS-TrafficTypeDiagnostic: CY4PR12MB1461:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB14613EB9959428F96379B299D9299@CY4PR12MB1461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P7fMnhArfPFUWN8m28pDNs6G2nkzAjwLMxlX+jU1bU6qM+NmR7n9PL2XqJ3PeM6sz6dHaaxKAkK3r+HLWWT9zSV/wTp4oLpkRg0Tymku1X2XCFwKaABInyy1bo1XxExLzcCqDwFJm64G0IAQBJK5DW/IZ9iwNZdqe0Ktslpn9fFhx8V/liz+od00/M8DxufpG4a9Bf9k55/wxoRmvyHr07PgF7gH2W2mal0G3PHQDEweyGwLizK5eMO92YkjsJ/D9xuKCqtOXlBxp0WyBmJIJgHqbuLcbZggRRol5bU616jFa4apKKOxWyz8akNnJlFHthcbkEb5I56AslQ9q+Pi5Gdtirxb0SZx0WoNK007x0r3UoKxBkMe9UsOTFxjZJc126MMyMEAR1HkNggbCi4/wo+I6Kflkj/BoyW1M3b8auv/Y/ODpyA491oscCqaTW+4GTGO/QdAIHZUEQDXxcT4dn6Ba6Hl06+LgB1kXZJ6+Dq/2hec3EJxmJFggx/H3DEcXBd2jyL/lVwvx1uRbuvK/ApGWEOS/oVGL6BbsmCQnjXJDp5URmYbUDkaDdutjvG2rn2cgM3prALdxQL4yLD4SGAWUTy7Mar5tKTQkpcQJGeXvjpfeWAsuA1Rr5nPmp+J2e6KNDB+49MQEsjRfLJgNeulN6Gole+c5C2aoxTNhK46io1uqPaFJ40vyLRQN5akAwcM8Yv6jcaG3mAaSTFVj2TOJzAYlbszD6idO99JhkN2ltlEJcnJ91fL/DMdSU9iDUK2/agF/Yj96NAhbhAtkDz11ZT8XQiYKuCFcuXo7is=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(5660300002)(7416002)(81166007)(356005)(2906002)(31686004)(186003)(508600001)(26005)(70586007)(6916009)(4326008)(316002)(336012)(70206006)(426003)(8676002)(82310400004)(966005)(31696002)(86362001)(36860700001)(8936002)(47076005)(40460700003)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 15:20:52.1756
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0a66d1-400d-456d-23a5-08d9e7f1ee71
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1461
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 04 Feb 2022 10:22:07 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.6-rc1.gz
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

Linux version:	5.16.6-rc1-gf58321948b36
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
