Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDC0572EED
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 09:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbiGMHRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 03:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiGMHRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 03:17:15 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5796B25D;
        Wed, 13 Jul 2022 00:17:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGI710MDghX6ZYMqi12gEiysyofokEpKJjYebLLyVaRLVGsyubr4hSXhLJwXXvbDjYV4xyVZf5B4Fz9FuJyYcOILfzOMFV+jWAIwD/J1Ptwi+4WWcy/7/X/aezgV6JAgwyMxeSXyQHwPSweXgJBAHr2Vbfq7LnSscO70ckPrHYmII8qHEyfJHBJBGSx0zswzSMTaX0pZE2s42CBJRD46+NYjDxfXEodjiPY1d4ySkJEWOIhbVngiJ1NlDiNf9dtlMg9yBZhWVvTsiH7M3hEKmKQt+QuEepcObKxESsr/ipIFMpQsLpjCSDtRC49LDgMPA4C21FL9VNvk9jy0UGjRiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQ0rkwvP1MFSUstEJ9hr4xtRDfye1jZ9SYxX7w1NLqk=;
 b=LopSNiuWVFPcNHXLJ8vj45Gw4sBe6fxtOnwIVS/9eUqrptvW7mKP0XPD62McebDHZ1YICAXiEpY4TRlnfuuSsQL/aD4wFe0/Vq7O9brEtJVFQ6FyDNC+I1XJj56p33pCOj9sS4sayBZ6Xt1aMz0g+am4moRWJZrWknU4llkAt/iqxfiO4z4/FuoOFWI8p9pidwylJ47VJkCSqUAm78KFx03FsZ+sLl4TI+Wg2vikpk2QFSibjG8UpS0Liy8FdLQE8QKNbRPdVwad9HXdkTeXnHBeDNA6uWK7xGOSOi5lEdN6aHylKpHV4AmzAENLzo+z30NuN6T6VmHGr4lmPnRFLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQ0rkwvP1MFSUstEJ9hr4xtRDfye1jZ9SYxX7w1NLqk=;
 b=B7UkxRU375S3/rk+sZ9FGeV2aCkpHgVXrB43pkL0c19Zxwbi5RT5ZXDo2D4lpxK3wromFv4IL5P1Pv8GE0BqQXOh0UKrTCwNCDVTWRN6OgPHeAJH5D0Ff4cFu1uJnXOkrGhWXvPTXUFe8/igUQjqEyJscfA8yqOBKcorCyupnKvS1MljR/rB5LToS+DKlrxOPjQ2b3yG0z5eBe8HOuNt9BTmiEzELlT8sMRVWk47sYiWMQYpCAdJCf+44TXB5W7M+WXUQuYp72K/QXrnvjto32QmtV0XUZd7AVRJXBwcl27Gacm/3ERa4oC9aIhfMJVh7YVWEal8Kz/5x/WC8YbQDw==
Received: from MW2PR16CA0040.namprd16.prod.outlook.com (2603:10b6:907:1::17)
 by MWHPR12MB1597.namprd12.prod.outlook.com (2603:10b6:301:e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Wed, 13 Jul
 2022 07:17:12 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::24) by MW2PR16CA0040.outlook.office365.com
 (2603:10b6:907:1::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26 via Frontend
 Transport; Wed, 13 Jul 2022 07:17:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Wed, 13 Jul 2022 07:17:12 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Jul
 2022 07:17:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 13 Jul
 2022 00:17:10 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 13 Jul 2022 00:17:10 -0700
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
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
References: <20220712183238.844813653@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d8db0f0a-61f8-4f8d-aa61-0e4c3b4dda47@rnnvmail201.nvidia.com>
Date:   Wed, 13 Jul 2022 00:17:10 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd766f3f-5a9a-40c0-6b2c-08da649fb4be
X-MS-TrafficTypeDiagnostic: MWHPR12MB1597:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YHkKJvcElURXcbefcjkZXSS0oks7N9AVkQDlsr2sY0z4DiGj3OtkLdjtfOFPftYjIIHOGMacGtt2FquGteOA4ssJeVZUZUimFcztuHmOinJ7XS5FOTJSrlqSfAUKjs6DaqmHpBSTwg9ppjB6QnbrR9rZGG2TFApCNltFV63mgFifpjgqBuQTa4h/NJKXWj9EV57DCNp1B864aoXWPZnsn1QHkOmqQUX35bOnTcr+esWDxG0mLsSxeDhKP09HHH0peFj0gwBKlVOaOir503PK6lUdnfUmESyB18XIvJXsc+NUBi7weBhDS5d6AzaEKUs3eFGdx5a524uAo5JUB87XH7xhccgAzdU+Fcq3G+GPf3h1245nsCJA0LukR1oS7HzQXXx42IE1SYWJpoTd9Mu01ccHYpXUGn9VUzRCVZPA9VZu3dA6mH4rPLiF2HQ1JaZd76ZSCjCeStITBX/FJv4HNO1/LTHTs9dFxzA4GE3BaMJEbHJ4UnipXWhnMGO4LuKsqmJfykh89mqPjXyQmYmnU9S6xfWBc/S/2peDKkKWpWP3ntuzVlh+WgqbbFz6UmwSPPdr7baeqlfS+XH19mUHdLs7000A482NaQQXiyW4kHRl/RSjxZcwXLlhqZK+vx81E33r70CvaHNMIQyr3OnfGWaQX5YaWYifj7dA41UzeUJjghqUyNAOk5y7nNG0cQXk6dXZb9L3e6J1L0azKl2mkCJY6u2Yi4nqSTF1oXiqFDoyEtFzi/FudOEiO4Y8q41IOa5nYo251YpDuL8tcXVtabakI7n/lMgJiMtbOLq06zufTfu7jKnNk06Rl4Ja5yNOThTYlg5xv+kHwiT+OYqD3S5nw5qhdb4JeqCupzFCYCi261kIBOeYmPFdjHbKZd7369NmI8onXB9/cWHs3zY+wlo0jah7ZRrP1x8R068tn9OMxDvhqjKOfNQMhLgBVenS
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39860400002)(396003)(36840700001)(46966006)(40470700004)(86362001)(70206006)(5660300002)(8676002)(6916009)(70586007)(4326008)(8936002)(82740400003)(7416002)(41300700001)(31696002)(356005)(54906003)(316002)(966005)(426003)(47076005)(336012)(81166007)(478600001)(82310400005)(26005)(31686004)(186003)(40460700003)(40480700001)(36860700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 07:17:12.0208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd766f3f-5a9a-40c0-6b2c-08da649fb4be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1597
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Jul 2022 20:38:30 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.55 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.55-rc1.gz
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

Linux version:	5.15.55-rc1-g0fe4fdf9b1da
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
