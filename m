Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDC545D916
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238089AbhKYLW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:22:59 -0500
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:47043
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239874AbhKYLU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:20:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4n0E2J+cIUqpXnNTOeUH0/E9D4wzcgc6RU3Wgpz3exWvAtjK7GQFZ8xDPSM863Lg5T8npIwSZO2T3WYo0xBT2RVpT2LG37ZHmElwdFqLV/XIYYSD+9CHnUxBPaR1N/0ag7B5AQg8lODXK8IjJERMhy7STegvnmBIG17plVP48KixmNaZlGY0HZtCEUs0pXraO8VF3/PvDu6PWhcbhPSL0uIZZLS8oq5Rf86akhfx7taE4fG8SKRJkoCmm0FxcdLU0KxxiMTM/n6g0J2tDGWJwoIrblKiMJqWI3i7VHD41/eYOBH+RJeTlROejf9EpvMNyfDsmZKYkEMOfKYOBHCIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/Zw1sxeSBM5OBAN35aKMQMLZnAy5r3FiOgMRO9kj50=;
 b=T/lBhXV8DIBmg2pM4SlGW+ylg4sZKiR9Ik28FUA8Qy5i7CblkQM2UmruReCQJSWuj2jCEcaCnDFANR9aaBsVEDkk3qF89MPxHbSLZhAy0SRUKcskchzb0ktG1I1l+IQGKeBfRpht6Pi8nKcpIcjKxV/U+ksumbejT6eRSa30dtlUAgqWnM8K5EVSjVwk/bADyVZYR4P1A0hE4puFh2s7j6lwXks+tGwc/OC4MhW3Qh3XyvXQpVUflO7oauxixCzcWkyfiUGKSUxqOPktTnckvt8XKaQd/n6AnC0viUDV8Ackf6RX4+ZPT4F7FJA1GqohS2a/sDtcGyyosZK/b1HYsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/Zw1sxeSBM5OBAN35aKMQMLZnAy5r3FiOgMRO9kj50=;
 b=iBvVzO51gAVMRV2fArW4qxXbUdzNhi60cccxqKAv4J6ZIZAyGBV3bgmmgsgVvkAIZiHfbuDQ/YkqiUxSr6qZRqTC4csDoloPpWHf/JaXTBPn0X0h23PlQh3QNRLFKd66N3+geHEPKv9lfxFOIOyrFkurQPyGxa3OX5wCXhPJevXjLY9gMvOU54fQ/ELe+v3JbenjQljPHxCKxk2FfoQGO9EWZIhVeE9FHOoYlf/UF3XwVcCfHjrL0/bPH7twMYgJh+oVsMjl0FCAEaBUEvZ+yMksPv7erYdiaWTLNHOhSwIDwaiknWAFv33yTaUZqMIFwvk0auqIkdhEV6Xx+C0eBg==
Received: from BN9PR03CA0214.namprd03.prod.outlook.com (2603:10b6:408:f8::9)
 by DM5PR12MB1932.namprd12.prod.outlook.com (2603:10b6:3:10e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 25 Nov
 2021 11:17:44 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::36) by BN9PR03CA0214.outlook.office365.com
 (2603:10b6:408:f8::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Thu, 25 Nov 2021 11:17:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 11:17:44 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 11:17:43 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 25 Nov 2021 11:17:43 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 000/162] 4.4.293-rc1 review
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <aee7a5a2c7f541608b5ee7ed4c3d0150@HQMAIL101.nvidia.com>
Date:   Thu, 25 Nov 2021 11:17:43 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f4aa0e1-4ad3-4313-1f8a-08d9b0053419
X-MS-TrafficTypeDiagnostic: DM5PR12MB1932:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1932AE64B32FFD3CA5670176D9629@DM5PR12MB1932.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7kqExmCEqQA2+wI+pE5E34rz2qF7bko9Pi90Rser+7cJtihN8VNGeEKX6wElTpDefghmMMZkKjWQ2HoCC7sVn6ACxSxC8unVE0I5NwsT1wfHcDRrVEqXbHBkzPoc/qJy5JcInSV2Ja7CTHfeM9v0ktFM2Jxiz3jm2/09vWtmkMOq/Y3WQY3gwPRJJh4FloxX08Wn7VfZykhsejftwr/4hmt6q8wwTSU/ckqVBvsZo8kOrIpP9YHGv8Y0wLMfJuz+5MXyNOn7X7tTRN7TPP1oqvJKiPfApbebz2c5zhjxOn1C2MQ0rXh3/xN8s6TJb1rVr7LtMLucW2Pz6txuCk0pcTFAMVwbcem9Qu4Fu/9Xyc1FRZNCEXMHKLCadHBjI/6oJe271xoPkpVLDH6zQNMyXEN/zD+nqUD1QB8AGMVcde9Q1ARz3rQhRycKiXzvuoQj7DevdWjyBcLpXkW5FO5PG2UnvuccgnQLP/F6TFegrvxZYPv6hjqId40qr4DXY68G6g3ds2PVotLigCI3+VNNrhq0FTn31N5g832HqtkRJJJXNJCtla60HHxaEpd8wsZ0jBQFUgv9+d/Xf9dUu5No/cpF1UNgkxO+Smi29vx3NrDqHfMZMxjQtMh7Ka7cMRzfE9GkmwQrPwxhvhG+I7cnxDINF88TMr5aeAuhKEfGgwJqU4v59MSjXPriv/jpmCwrGpeiC3CAoc7EKZmw+BtGSPcety2p9j+2jyyhS71lg8gmegy41vm6/42SIK7bqYYv0OmuhRHM/G/oSWWRRAMih5Se9YKu7lzWgpClcp/oV/w=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(4326008)(426003)(966005)(86362001)(5660300002)(336012)(26005)(356005)(316002)(6916009)(508600001)(108616005)(8936002)(24736004)(186003)(54906003)(70586007)(70206006)(7416002)(82310400004)(36860700001)(47076005)(2906002)(7636003)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 11:17:44.3323
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f4aa0e1-4ad3-4313-1f8a-08d9b0053419
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1932
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Nov 2021 12:55:03 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.293 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.293-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.293-rc1-g7ef2d8bdf4ba
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
