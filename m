Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0EC413406
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 15:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhIUN1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 09:27:33 -0400
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:41728
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232906AbhIUN1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 09:27:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odkmIxh8bun531TpGuY/XEO9CYOfdUJXwMmoWp3iRlXEVGGrtsy0Qxsy5KO4PdZizy6DJjj9d74Z40joLNx+8owGgGWW7gVf5BepDArsZyPxXYQlLCm+6zlt2jifVcBkciXOZXISQctx1GSBCyZvuE9jlLKErSmTA+HUTd1tNWxJxEztR/AqEOwk3UMxKuYTY1HgbDwuVjUMSV6bwuvcxaaDrFhWCo28f1wWNmuFQ5QpN5qcH+WtSpuQXJeIEEN8Al/G86PzCmF0kFOlHrnf6UnzKQJD0mHvoj7cAcOqYPbViS4hfRzyCS0tGDXyVXsaeAZnEs42uNoTuZ37gexNuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=IARE5eO56SE9ABSPBsCjwROgRN+FSmkIWcbfzxoj//I=;
 b=jXeImFxWGRl2Y8JXV+OB5HGBFSDFvF2DvLCorNTLHdlsJ4iMnpSrrHnk8LKzAVlEH5IlFTaLvahGR28DhHZ3LTcGrXIx8PTurSh6o5LQXrU8Srn56YVBhtb9+4E56ZHxni430hEHWKlEoHmu/tGlwvLPwi3w6AesM9oPCq5hLzymXFYus8yYjHsckWTFkvsivmIZ/WvGbmGY4ohlXcZddOh2IRrhq69k578468X4a5WFWpkf+0JxFuuwZL08AWJ01HgI4fEjrPuryXKCBJ+WkgN2LpreWru93vKm4vz4ZkUHhJniiGOKsStg2KNK9LQ7B9JfFay6OMclrnsVK0i0Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IARE5eO56SE9ABSPBsCjwROgRN+FSmkIWcbfzxoj//I=;
 b=BZwGq1coRP/1aR/DvgZWv22gqYmDgzh5knAccXK8ocAGn/9sk5luRCh5xN+IxqZPCPX7UkC27ijTm+0EgRrvrt6C0jxPSftw2zHxFceM5/uwaJ3i6VZvKCDk1rkNEaiH6tya0BMTtjdI52tn4i4ZwkT0gIXNIu2i4bmvLm6IugouB5NXfDYx7i/74/gY99XuW/hcM+0Vv61uJMdZmsdTbE6oKzpFjGEa5lBEt0bCnPp6vloC/Ftw9r82P9eYaVeSJCy3qAvhqf6H9iyULXepvQEXv99AeTRL8/Nn1bg5HJLwNTwxdqjWqT1b7R511IqXyx40f2auS/Z39ivXnxuIaA==
Received: from DM5PR15CA0062.namprd15.prod.outlook.com (2603:10b6:3:ae::24) by
 BY5PR12MB5512.namprd12.prod.outlook.com (2603:10b6:a03:1df::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 21 Sep
 2021 13:26:01 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ae:cafe::7a) by DM5PR15CA0062.outlook.office365.com
 (2603:10b6:3:ae::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Tue, 21 Sep 2021 13:26:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 13:26:00 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Sep
 2021 13:26:00 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 21 Sep 2021 06:26:00 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/293] 4.19.207-rc1 review
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <93e31226fb554b098617ce5500309742@HQMAIL109.nvidia.com>
Date:   Tue, 21 Sep 2021 06:26:00 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76805bef-cbe2-4750-b6aa-08d97d035ab9
X-MS-TrafficTypeDiagnostic: BY5PR12MB5512:
X-Microsoft-Antispam-PRVS: <BY5PR12MB55123039E8D7606C7B889267D9A19@BY5PR12MB5512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LEWG9RLE5K3p23+n7/ih2baXR8HAnKVTXBi4lAuO8D6g7/SjlHPWE86yHmgKP6b7/E0Xng9juK2qyOu2TyzTSH84ZZp64jiSJD18eXeOQBQJpC/s/FzVkslm7Z/Jw7ia2xQvpirowfZVp+2zNHk6jQmueQjjyVODIkJZYrmqVYFepobFAGbDf8p453420ZvIeH8gQ+DVeM0ilSQOpxMr9Fg0+mbcWIRzrLAId2QSVeyJwdO3JI1d5lO62lKPdT+4XoBrFZzqGrJkUhlDVe7QTMdRecwtTu3rlC5MXT6GQ1Usb8B0ZXrBl8ESAoyQtLgOp4rP7CIqRosdS/diXv8Z0IcLRKGlZjuZOk8bCERqKkM1eBydmY1N32iXgpNqcLzdPevARF0QtuvrgprF6g9AMrnjjCS+O07+beR6EtCffxp+YIkkhjsVCyVOYlMZd33iaj15unwhtzSvcNHpClGgHhmymWXVCL9Fcv4+Fu+gWAWMf3xBF143+PNoFFaBxT4Ntp955lTjGaueAMuajcEiRGx+JfUOsfyYQIlwO+vG1KwkZvpWBcpYpzR6hJvIexplBPzePmDgf5fLSPWuMA0Xor18tpLUvm2H8fNgJOlvtYXCxGRR+aG/qSWprLjUDeB0EK6ipavu+NuHMjQVwFtO+wrYNBLKUeP1nIGAF0MdvH5rQTJJzEIwL/tVPXECSpR0kpScT/s8nBztuKiZbKTTfxDuFFL+dgK2Je+Ezv6bHmeIc+FgtIGFq0fw2SVWp4U9F8iMetStD/i5LlilOBjJQMm9jx+QM+lYO/SrpyfLdTo=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36860700001)(336012)(426003)(6916009)(24736004)(8676002)(36906005)(47076005)(316002)(54906003)(186003)(4326008)(8936002)(108616005)(26005)(7416002)(2906002)(966005)(508600001)(70206006)(82310400003)(7636003)(70586007)(5660300002)(356005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 13:26:00.9037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76805bef-cbe2-4750-b6aa-08d97d035ab9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5512
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Sep 2021 18:39:22 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.207 release.
> There are 293 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.207-rc1.gz
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

Linux version:	4.19.207-rc1-g9a707376d65f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
