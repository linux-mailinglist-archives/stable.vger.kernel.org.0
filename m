Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8451D4D970A
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 10:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238396AbiCOJFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 05:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235860AbiCOJFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 05:05:00 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F74101;
        Tue, 15 Mar 2022 02:03:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YzC9oQvhnmLLtY/yAZeqzvEwFr310fvZCz3W7u+KcdqN5Ps6VMBkqbjQpx6kXZXVRaJKZuQpqnAhGYq0FWdnaUiosK0mObGWB160tUJex07BbPw+8lsFGeLs+ayTwL8zT1zXvRPV8nfkYnxnh4XvB2IzZxO+v6BL0ZxqF9OBpXWidZRiB4RqLoHTuOx352XPWg10OecWAbLuTZIgEQg9QQq6AWOYKyw14MYkAozpi9pUQmElxsxdZr+8mmggBwqgdYvtI6jAesvLHqaSaplzdvFvXtp51FeYaYEoEK9XG5pW2jkF/kWmlMWCVahhKwVn7SVMAJrk2rhv/E9cCqqWxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uC1vK7mdE6Fmdyn/yxsmD4urcIlnxd2ijCmEJYgGbis=;
 b=FDUIkTW/KyxaqY5GdipXNo96PY6/Q44W0biehSOvkNnXDONKJN88WWucsvMLc3eb+ws6a3o4e0dc0GiW9zD/WkFiHmwLjFsK0kzCUCYrzyQQErbxSyHwx7MgrGvenTkaQDNUx9AuP6WC5NN7NX3QQXBlsNEwqFAWmJXJl3/DvRcVM9QZQKSl3LEKFkflDPnrZHNMLQk/7MnsWJ+IPeHvx/QhBWQPFtqafuZZbJ5RUxD59zsU3VhT+/OBtgdd+tRiqsEw5PjJObIbffVokzNDda+g0kbA5ayaCd3sSvlLRMDmMM/kMP4kNcBq022hYcKb+21t2vuihJcrwHTuulGs3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uC1vK7mdE6Fmdyn/yxsmD4urcIlnxd2ijCmEJYgGbis=;
 b=AYVXgwVZPEo8tQSKLSS+5nkZpsOIVemiCZ6NkGthr8I+Dw+KiaNRvRHUhAvNlDPwqRUxDd00Mgjdxg4C9uRyiHONCubhANtJNnANnjhYaDARDNyOvoELn4ldsTINJZ7AvN9UCnm3wcjKR+/ubMbP64wQxZeFWg99gKJQGlShfpN8N0PD50QN4ImKO3C+gsHrFJ+RnP7RPTVGdmn/63eWcjqwGnZuxaLfS545vAVV2HLYnM4nEZtOF30KDA/8dpxnUkCxhPK1w1Nk7SUkiJgfBsdGHyy0/CH2/JPiNCJlGlFM9bnihOhTsN16vMlUZCty4NY6eVLMP0Ek+6SsAsnPSQ==
Received: from BN6PR14CA0010.namprd14.prod.outlook.com (2603:10b6:404:79::20)
 by MN2PR12MB3343.namprd12.prod.outlook.com (2603:10b6:208:c2::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Tue, 15 Mar
 2022 09:03:47 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::23) by BN6PR14CA0010.outlook.office365.com
 (2603:10b6:404:79::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.23 via Frontend
 Transport; Tue, 15 Mar 2022 09:03:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 09:03:46 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 09:03:45 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 02:03:44 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 15 Mar 2022 02:03:44 -0700
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
Subject: Re: [PATCH 4.19 00/29] 4.19.235-rc2 review
In-Reply-To: <20220314145920.247358804@linuxfoundation.org>
References: <20220314145920.247358804@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1ef24d20-fe8f-49c1-a01c-9a35f2562e54@rnnvmail202.nvidia.com>
Date:   Tue, 15 Mar 2022 02:03:44 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 257256c5-d8c6-4ae5-e2e4-08da0662b6ad
X-MS-TrafficTypeDiagnostic: MN2PR12MB3343:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3343CE967AA183F35170BE40D9109@MN2PR12MB3343.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UJpEDZ0SpDakc5Cfj4AMCdsqcfqkGrP5VEQyrlbYXD1pjm8VIF4e2rJxHOicMY/lZguXjihSQDxabaCtc4N9Lh9daXo817UUHz41CVnt00U3sEuMCIYlNHz3Mm7V21y/IBMtSL70Zq1WeJ/iQmDpL16CcjB3hX9PgLuCTXuofV1K2+3OxSXvA9GAX9aSJljfqQDrMLtvWDpigJv2wNjCVBqtlg3qnjX3bzzJnrTD9TxOMA90hm+Aaif4jaAdP+qND3rPNLQZ1dlViJG21bZfpa8jtZEjXSvGeU91cX4iR6nxBHtDcKWPpXK7C7QHYPhcudGrTCAG5oRml0Ff0vwP/r2ZGLiTj6rOp32HRaS6yz1XOh0Igy8w43gvtcG/2FThPZBCv9mA3g5hoXtZpWh8yWxU7CISN4ofW+3ZsbOLx94Y/YfOxz5s09kZEtuuFugJqRZVozrSVBSyL8cMSnZdhQHFi8ArzpCbIViypXPoSb/YidC5cPRdfB3dE9E+otVMaQKAA7scfvTy78XManoB3YYxDJiUg10e289EjX/oQewOYm50nk3wE3jEIsubkRaoAv8vZrS4YX3NimBHKwQ21jFa5D7EPSOFYP2gtVkQsF/d6wUKVGvQmzxeTqlIrRqfpbkpxuVoWdwKTCI8b6stb31SbdoDoHjgYQdtEybqGu/h+3xoW6RFmSSJAoB/6YRF591WzD2rURQjh3PwC3ZM9w7cn85rTSijJQKqHyL9q34DXc7lXuXa/e5K+A1Z9hvD37GOrDg/OVMm/EhZZlQQzDuookykeYhx6NUB71K2R7A=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(40460700003)(47076005)(5660300002)(36860700001)(186003)(70586007)(70206006)(54906003)(26005)(426003)(316002)(8936002)(7416002)(336012)(31686004)(31696002)(8676002)(6916009)(86362001)(4326008)(966005)(2906002)(82310400004)(508600001)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 09:03:46.5882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 257256c5-d8c6-4ae5-e2e4-08da0662b6ad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3343
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Mar 2022 16:00:14 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.235 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 14:59:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.235-rc2.gz
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

Linux version:	4.19.235-rc2-g4401d649cac2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
