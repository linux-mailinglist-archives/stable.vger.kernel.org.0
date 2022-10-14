Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300CD5FF1CF
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 17:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiJNPz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 11:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiJNPz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 11:55:29 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8325464E;
        Fri, 14 Oct 2022 08:55:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OYCPjeW4wRl2vHXiJXERGZV0qPTNULyVy5ZhNwm9cYvkvj10cGNF3NAue99uEjJ4w32C5xk3oxW2DiD0uu3HNxEAAi4VJVKCu1pA08loA+Jdau3MIVMU+LpU+R+Vx9r1jSu01e0LZuqmbTJLzf1JNZez2uD0Y/I7yXoabVQo5hw1pLLOCJL4+hy2J9fA6UndOoepoAF1JOzVCDsOKO9HMXGmvD9ybyeTS/cHKoj7VeCNcY2WTZrmyViQk1fY1tn3F8XkXa0aUUmRVFo6SC4xcPtq0+dKltEI38P3lBuDf4iHaaPt+Vn+RYF7IluEN9KiX2X0Xx97MsedIJiUV/NteA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7Vfhqs65D3NCmn7ZYJpalv0sw7wBnOLv4/ZgSUQmz8=;
 b=eBUne5Q2lM7qYY2iSDq1e/txZsZ7IR1BvK2C+DknWDTy44HBJetEl2uD5epKr0+mCdrX5RpFbPcf7NwpGETQ836UvcXE+xxLRPlPbDYCoWMYxG4AdOFNvTddz5YgdOI2VUEqUb6ie8hc9S/y3jlg/frXPsw35bSHyNDb9+dCbzMuMATVuNLX28kBu6f7bxpzPp/ZYUbxa7/i08zlr32R/QWBvDl0NMcuXukdN6O0aBpiW8UtpwgGgyjV16CZRixl57TrygLWZxr9aMpL5uOISwtBIwTP+tzPTAArXPUfHYu9sJwvUIUN6oBEeNrPqRECyETsaWjawuWp4lya/a3Cgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7Vfhqs65D3NCmn7ZYJpalv0sw7wBnOLv4/ZgSUQmz8=;
 b=Heuy6dTBqNMJKK7ldgQg4O4D5GmULZKT8gjzObat9cZh6Ctrqp32f4OPl79tOGDA8zSi2D1KpflplfQRtcw1qhwL61VqsuHrGu7oCiKr5aWggSY4wp3mqB2e78XuY3AGjeCR2k9Mk0PCxQQAvwvZbSLyrUYr6Hn9KhoemXwmo5xPsZMD7XAeevOHotpTwvTtiJMEFVykkA5aUgu7fqGA2VcBTgcn6jCQ+DD9Ua4ZryJvJRqqzrKgi/XhzN5POcokQEeNmtTLrWIJZMoK4V4ZyyqbhSL6XlNVRV/zzxPunXMfWY/fI+YCQAbzrA3TT8KFzY56/KPygW0sYi7XmUSW4A==
Received: from MW4PR03CA0054.namprd03.prod.outlook.com (2603:10b6:303:8e::29)
 by CY5PR12MB6430.namprd12.prod.outlook.com (2603:10b6:930:3a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 14 Oct
 2022 15:55:24 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::ec) by MW4PR03CA0054.outlook.office365.com
 (2603:10b6:303:8e::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.22 via Frontend
 Transport; Fri, 14 Oct 2022 15:55:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.20 via Frontend Transport; Fri, 14 Oct 2022 15:55:24 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 14 Oct
 2022 08:55:12 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 14 Oct 2022 08:55:11 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Fri, 14 Oct 2022 08:55:11 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/33] 5.15.74-rc2 review
In-Reply-To: <20221014082515.704103805@linuxfoundation.org>
References: <20221014082515.704103805@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2a3cd68f-c3bb-455e-996b-af0bfa2aeac1@drhqmail202.nvidia.com>
Date:   Fri, 14 Oct 2022 08:55:11 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT068:EE_|CY5PR12MB6430:EE_
X-MS-Office365-Filtering-Correlation-Id: f3e99319-a8b5-4363-178a-08daadfc81a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eHYA4L0g6inU2Ierac2GUTDZODRlSyAYIBfcuREcwtRlm3ZCFTJULG+1HmEZD1Jp0Yo8kuwFqCPgI+/721Q3hPGuLxwhYnJNfIneo5HuWv1KbMzWKsvA4lICrxDHwmaUihK5P5VmOYmwrAAB8Yrm/0KD2sEVkW3tw3/XzXQ7NFMjjEmmkTl1uKNIcyVooQfgLKpgAF7uyP5ZBZu2yGrh0n/codu9a9fLHh7KztOIyECcDrH7NeHKkQdyFdbbdsk4rjhSnN47t5QL6R/lSJzu2KYbUPujKqcMYsJJnO+CfhUZO/ICu9ogyGQgczfce+h8tS4kmgWx3GkUzlTyMD/wQ/dRotw0W+iD7ZUFKdCb35q7bno33JHHCx3AEOcGgW5MDmpM/L9yojNEoDD62ZmEti/k7H5qHvirmsN3Ap77XgpCngZ2lNRPfWMtMUI6gMVIUfeNWn4vk94DYWErlB/jNCgPyJ172aYXw637oNqUosKNEH4d0PIZI4voZwx5GreGCqIVxGSLvqOmbXx+g3xrx9HcQKY2vXg2Re6jqtv6DRcT5kgtcheMWa95Ea/P9pO6+9NDvuP2TiAEvqLWgwaAQ7dy30ViFefBDc1qvNetxaMKKOXSut0gvCmLRFvB8QmFvPuNczkRscVm5+7SB0oD9rJqsh7LM7AlOYGoEHmAvf6uVrvRK3TXvuuefPb4VYhHBMu3snjC9v96RlQCJPXvgom7QZshn9hI5q9LDdosa6j5DsiaMlubgR7JsUsc1slaDmiiEVTW3XyABNOGRMxm4DmXohPULZuk++ZG5SsLvwBHifIBDuyDOO3F7yS7f+WfIji+zaQDam8b1Fd9R7wbHKGjc8qsHrkIQehiQmlEDsY=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199015)(36840700001)(46966006)(40470700004)(31686004)(966005)(478600001)(26005)(54906003)(4326008)(8676002)(316002)(70586007)(6916009)(41300700001)(5660300002)(8936002)(186003)(426003)(47076005)(336012)(2906002)(36860700001)(82740400003)(70206006)(7416002)(40460700003)(40480700001)(356005)(7636003)(31696002)(86362001)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 15:55:24.3722
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e99319-a8b5-4363-178a-08daadfc81a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6430
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 Oct 2022 10:26:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.74 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Oct 2022 08:25:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.74-rc2.gz
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

Linux version:	5.15.74-rc2-ge3d8c2f74886
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
