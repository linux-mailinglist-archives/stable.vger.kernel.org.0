Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94427510336
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 18:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352946AbiDZQYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 12:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352971AbiDZQYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 12:24:04 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31450DB4B2;
        Tue, 26 Apr 2022 09:20:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V7CMeVwusXopd8pKzwuRC5J37n3Oo/40zE3U11PaH8dTW3ClSWYkmNFB26ut9c6pAjg60k6qa52mWpExK8i0pL+Fl1JUE8H94WgEczi0kkZXDGv1YMKChCZeC+4cjSvnU2bFHkq5S5BLj2AMId14SK68q/31MchMnEa5ki3iNnrPOMBnwzHOIqyP6uV/lr43XTQ861/Kt1ZFOQVfZcTt/ma/hT2v/dBWNRtz37k9E32cNj3VIDN64nMi/mmaByfAkcZPb4FJVRptEa0YgvTWaeVcj7b4puwRY0MshQvm/mjgp0/8bcx71FZRRuL9aeAIymQqZi1r6OW/RPOopBdrxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gwq13+lod+SGrya6+uZ5jVZWvk+uYiV7nQdslXkyo9c=;
 b=jDuHZY+sFe+D0gtY+01Plq2fwbROLOMXU+Tj+97lv+aJeS62QNLaN99IzHW00n+IUnFsArBHCjHSfXbtRl0lxg7SPCz39NL4MKEVb9MCUx4IuJxqrRji2kgwJ3C9AzvF9Avwq017Ik14K7+M6tneYLhwUrlIffUqK5UBoQQXvwaI3TFTcxxGpCo4n3uv9qydcUPcmJgkd5PlfV48f8r+DUbw3B0zD4uL8b6YZNhfsjgv11EaZXu8rdSPs8vQTiq2by00uIBlwnwAdoygwFnRkja/mkzwDj/xSSo52pwq4XxDWWkie++tKVwneD4Dnce4ICwrWWPgt7ov9SGcs/44+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwq13+lod+SGrya6+uZ5jVZWvk+uYiV7nQdslXkyo9c=;
 b=FZfE+8/yK7B7O/3w5wCJaF9vV1hD+aQAswhNZ6piKRzT5rBlgLh2t2Kg8kle6MtZJ098bKxepmtrx3I6NZa3K/fwJFVzkplMZ94pBgXdCPt3J9J8R2nbMsz1WKNg7j5T7yCTBKEX+UZVdWUTnjV2BJ8P2tg2NHnQPSc0PsAWda29Y0g7OJG0rH15VLcBzDo7zbqYiF/IA++1AUHITkBCdFr84w1nEVFFc53t2NWGWwDbopFatp009Ac1xqY/uVXH9AhQM+YvQX/IObQ9S6sr1+IyiWWssbxaAl1LWR9GqrVWcVZYVCBmZZwfDxqZkCqchaKnNPbPAsx+OX5KDjCEsQ==
Received: from MW4PR02CA0014.namprd02.prod.outlook.com (2603:10b6:303:16d::29)
 by MWHPR12MB1439.namprd12.prod.outlook.com (2603:10b6:300:12::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.19; Tue, 26 Apr
 2022 16:20:54 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::bf) by MW4PR02CA0014.outlook.office365.com
 (2603:10b6:303:16d::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Tue, 26 Apr 2022 16:20:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Tue, 26 Apr 2022 16:20:54 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 26 Apr 2022 16:20:53 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 26 Apr 2022 09:20:52 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 26 Apr 2022 09:20:52 -0700
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
Subject: Re: [PATCH 5.15 000/124] 5.15.36-rc1 review
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <87761398-dfc9-4f49-b613-2b4248239ab2@drhqmail203.nvidia.com>
Date:   Tue, 26 Apr 2022 09:20:52 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7af2c3a3-436b-4aec-40a8-08da27a0bccc
X-MS-TrafficTypeDiagnostic: MWHPR12MB1439:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1439046F7051DFF6549C68BDD9FB9@MWHPR12MB1439.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q2Fy93VXWmRoVlXSo+zJpI9fVYR2CJOCzmV1q/7PvqcTWkC+0zQrDgWBcfJRM7Xjr0du6gjWWdUT1ktPJb3mH2wCP45GMQ7QjvEm+S4HgbV9p9NrkBFkH41YaVP4Xh4YHdpOZvVWOlvB0PvArelWh4MuUMz9ynka0ba5JZq6G9truiFISIcN4JF6DPoTtHa93QvSXIMb9GhY+YpEfn/IHs6NsEZD4YiVBi2OvXVudG0Qc7TfEYsRx1IJJbygeMBnb4dR5FrEK9v/vtNZ4OotzOISBCzGvRX2YIGJdKzBp+0OIMe6KuEkL8NvQhOA7PW87uZPOlq3y6S8pe4GMzltDuzOReZ2qgTIh91CQssyp8d4ajhvvPpcuHiqsCjvvqFoxlJCQk2ERGsVtpBE/Tb5g3G8rwmc/b+tx+HeHb0LV4yMZVRj9Icnai1GL5AuJPUArVfRXRUZFJ2/+kdLE2oTIpFGiy/VbofPeaN4KCr39yIwg9RMKLZ5ogr2vovBWwNKo1+qEWxQsPzNayRwB22v+xmx6AaQY93DPs7TEXnJDIIC/QDZMYMgSxqaHtUgWIQB6RjG5C0Fb2K8SjGoq8JNiqs+Y69IIomKP6ruEPT2Fbgplm46IKXu/TsGtXwNN7nyKL+V+6NE4831CtrZumjRXx5HsXVKlQJ5LNYCykK7CmiAWfyis+TXGyQlIar19X0m7AUGEwi2BQ4q+4BEo1IdArxDuF+7Pf0vYeH3hxNipdU1zubKFSDbkMt95JWe0JDlEdBp75WR5NL5cvD5cDZYpPQSO1XbugybKxMypEbpcvs=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(86362001)(31696002)(26005)(6916009)(70586007)(70206006)(4326008)(82310400005)(508600001)(8676002)(36860700001)(966005)(316002)(356005)(81166007)(54906003)(40460700003)(426003)(2906002)(47076005)(336012)(8936002)(5660300002)(186003)(7416002)(31686004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 16:20:54.1005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af2c3a3-436b-4aec-40a8-08da27a0bccc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1439
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Apr 2022 10:20:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.36 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.36-rc1.gz
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

Linux version:	5.15.36-rc1-gba92a7feb8d6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
