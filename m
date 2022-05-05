Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E51E51BCAE
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 12:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiEEKEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 06:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354775AbiEEKDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 06:03:48 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4160E522DA;
        Thu,  5 May 2022 03:00:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDHq36ySjSGA5qU7BwSQsEn0mazTtm91RthdgMsRHzCXxpbHzF02Lk5DdA7fQ3sFEx/jBnLdwQZYPU7VGFiyF7atbySogOB1hyn+kyu/AhrDMd4Zv3I86i4vBVm/ykQv4YNeGxrwu+rjHc9skDRFztGD6G1jUO/I0dsP9teWZvkz2zISJUi/Pgqaqv/zmNxFLISYkdOGRrLPRgX78Z0GZi1hlT/SmTZQKHxdv5NgmcWuyijlqQAzjz+Z+KVpllN6uWD3sjFgPEIQVnsAvAQYl+jargKHAtEGObku/3+CnABckD5OL0YPBnYO4521LiOsmjhcdACSbLmcSKn3JitpAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oCVuCsYsdf9Hb+s391I5TVM0xMYqO0tDMk5JsDEp+0c=;
 b=bd5kPUonoeUe5LdNP3kUrnc+vKtiw2tTS+UJdAJMTIt07QtHonLJwyqL0z9TWfjsQ1J5OEmIrnfJ2cHcmPI8LCLHJ+GfyF0vIWrkh4wzPmtMtSevi6602PHqQWTjt6zchxOqfODw82H0n4bpDds6KiHwlSg7rJrpAZOsayeWPfWEFSxbqJDtI4Fk/xdXC8jTvVjq66BXoq20KY7/tFQVXrAaNxXBZqpA1W9GlMj8+RkuWiU1/Ibu4ZsE6YTdcVkYIhY9jy453Czo55X/7WsFQXR0360CSJ33UIs+bbax/t7ZwQU6P0yRnWKBeuocxFhVSxjtHJUYvLPoLtu1ocvGZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCVuCsYsdf9Hb+s391I5TVM0xMYqO0tDMk5JsDEp+0c=;
 b=YW3NRlonsDhTGsWxAG4x+mnzdnHVXU1rZW3l0sbagDDjSd/oysV2GhLZmK5c35HRCNy2GeePrJsIHggQyR/TZeYtLgtjfw8TmIqmRdcxfix7NHjoHdBUDteca5eU1VMeZT02xLbc6QhEGtVqp748jfH4c8prJJkLtW74uTetaz0RguI4I1wJyfop8xn4P1i4lQ+5/hiAEAwA2gJafZ+9fLfospxhOS5zm9Qr5Z6jbtFwIQPY9m8aHuxZHeSoV9O86EJQ0+A+GWUTMAL7Ceun8FvItpaocEIxQTQGJ1yiw1FnP7stwmojdPzWM+paIIk5Y52gJQONynTmrbMOOkwhSw==
Received: from MW4PR04CA0335.namprd04.prod.outlook.com (2603:10b6:303:8a::10)
 by DM6PR12MB3786.namprd12.prod.outlook.com (2603:10b6:5:14a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 10:00:02 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::d2) by MW4PR04CA0335.outlook.office365.com
 (2603:10b6:303:8a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Thu, 5 May 2022 10:00:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Thu, 5 May 2022 10:00:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 5 May
 2022 10:00:01 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 5 May 2022
 03:00:00 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Thu, 5 May 2022 03:00:00 -0700
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
Subject: Re: [PATCH 5.17 000/225] 5.17.6-rc1 review
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f6316e3c-6c1a-4361-bee3-cf40dd1b9903@rnnvmail203.nvidia.com>
Date:   Thu, 5 May 2022 03:00:00 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb948280-39cc-41ce-e6a5-08da2e7e0575
X-MS-TrafficTypeDiagnostic: DM6PR12MB3786:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB37862B080AE6239B974F4660D9C29@DM6PR12MB3786.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DnvbHId6Sp4Y46WTAjg35fcivVV5wxWasafXPHAH8VF+1ik8x6CSBVXb4+/U8CBuQtzojFVyqKa7v7XZjYJBBkErwpPnYfhg7uoqN16pQn2ZeLwhqxdvWKLAQzKVpf8JHAG5MCRMO7NT4Q+qVcD4GhmcR2TunhBfBbNIMKJQrl8xhr2dspLPBTgv64JnKLUyqjR+ve6HBPRGkhFcdRRwTbbwWZWizC29Daon1NEHS3+A0tD86Ov0UextkeOiRC9G0Q5AgeFAUZF2bSvLJ7ItB6oeERqpZoqNlbOXADn89Je+8+xvitTyxKqC81wBKiBkqnlSvTPWxgFFFJK/z1i12s6PeSGZ1gQ+V/1RR7DZPR1Brbo+WfYo0gBEC7xPG6010QJuY0EGjRaYzWA62ohp8NrertuwJfOWHCqQ9bEDNhIT6YSmPl0rP1/GmtfvDswJ2EVXLSsQGMH1zd6t8lF+vvxJnve3RFrVyDnDlvn5G/sKSX+46OofSr1noQaOCb9EoUpYzF5kQWvBJ2r/qLIKM+xs5XhpllmHoFhqC/GIAdmw4csoHUFmvx6dcaCnxeoOWEILKjabdLJm3mYVHnCcxASOH1El6IvxZhKPDBa3VNuMCpKoxamXymLsEBZIFghEJvvWCCDkV8wTEz29fdvb4nJ6CKAz9KqJbAqgVwj1fk2FHLHRTGH7uca+/Z8ySBgtemKUlQzjxHnrGZ1VOUx+rtm+JVXRB0nQ/1nmJoRKmjg82QPvEE6PkYARqqE15IClND8iuLO7ywOwuyGKu7plkNLIa+ZDZHmje/6kasNp6rY=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(31686004)(356005)(8936002)(40460700003)(70586007)(70206006)(966005)(81166007)(26005)(6916009)(2906002)(426003)(47076005)(54906003)(7416002)(336012)(508600001)(86362001)(186003)(31696002)(316002)(5660300002)(4326008)(8676002)(82310400005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 10:00:01.7622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb948280-39cc-41ce-e6a5-08da2e7e0575
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3786
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 04 May 2022 18:43:58 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.6 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	5.17.6-rc1-gd7a932089173
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
