Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE716432DDD
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 08:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhJSGL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 02:11:28 -0400
Received: from mail-dm6nam10on2078.outbound.protection.outlook.com ([40.107.93.78]:38849
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229649AbhJSGL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 02:11:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSCHFEf1Grv5A8rB0mA+BVRq1z6CL8+jcxynD4O0a5K9yvMJLkgST9EtXYaE1P/fxDlzvHllBIksJZk66xlZBwaUIDb0G5cyWpZAv+wpGfR4uuYpT9BW9sL52Zl7Jgvj/ZCxGCE8K2A5TDnKh8/u1xMAu64NjQkfuBOEQub2VxoudftOntax8bU+0dIqd6elooTd/fJKyuWE5Ljv6OuvKyM+SuOwOocd+UcV5sOv5Rj9H2qFtZZkpQQrVKsFlbDA816q0H1EE7HV6zpK4FbOn43Qyfz89zyOLk39KxpkdlEWYN05uYJCeFRS46yd8fuOQ7YSsl41k9q5eWTwqfKa3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nnq3ardrVjwrd2JOzj7nXIBZcNkhiXEqIiDg4svpxOs=;
 b=BKGKkR4nWVoqnJt3TAedtTQgxnWPZwH2qLQM1eyc0UU+ksxJVp0CVsJxzbSaDO/DGUMEC0UrtR8eDwPxvtIbwhVm7DEM2vPvnppjfLhBCOjln2d3v86H+mesQGFPb3I60mhQ8vJWrnzfr6uaXt0o03W+pl2jAz+Of2cKoz6Qj216f6B7/UfEavFVS1jpubJjgkE3sxVjDs837FntCLWS9VUEp/duGzcm96s3DuGCf7fPyB88raUJ5kiwhxbUIS6mC46mAyvVdOWvE/T8SWgtb2D5cmOhdx+02h9Y7pl1dHrCVf8smO9WHPfyRpAawYjovdbBlRU0HQCJnvH+zUg0yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nnq3ardrVjwrd2JOzj7nXIBZcNkhiXEqIiDg4svpxOs=;
 b=Lr6G7AY5c/I3AA9CJ293k/Kwp0C+2gAATFrEbWdMvBalt47wMySBFa/EmnbvlBP24o9ILLJgZhCO1KMt5aX2S59ZWwHEk29XI+QUXfwCC0qADKD6+1qriS+BHR1gkndkpX4934qQdfCtmetsrdaQGh7mKpdLLuCuMkBSgu3sSzkoh9pmR5RG1PH50kTeXFOIgwrvFwJXviO5+/Dev4s6lDi6BPEs3BM7s19Y5Snf2tuToJ3SjzFimsMjScRD48+OS0xgW8HDKZeIicY/jr4MN74iH/uH+78WDRMFQrsvTujNl0XAkI/wPmE8RiUMPacAdb8u7CPAgBWy8tjgWUy6tQ==
Received: from BN6PR21CA0008.namprd21.prod.outlook.com (2603:10b6:404:8e::18)
 by MWHPR12MB1487.namprd12.prod.outlook.com (2603:10b6:301:3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 06:09:13 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:8e:cafe::a5) by BN6PR21CA0008.outlook.office365.com
 (2603:10b6:404:8e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.1 via Frontend
 Transport; Tue, 19 Oct 2021 06:09:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 06:09:12 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 06:09:11 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 06:09:11 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/49] 4.19.213-rc2 review
In-Reply-To: <20211018143033.725101193@linuxfoundation.org>
References: <20211018143033.725101193@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <049a340caaaa49acb9cf43aeb704dd86@HQMAIL111.nvidia.com>
Date:   Tue, 19 Oct 2021 06:09:11 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff87c772-c608-47ed-be83-08d992c6f8cf
X-MS-TrafficTypeDiagnostic: MWHPR12MB1487:
X-Microsoft-Antispam-PRVS: <MWHPR12MB14870939D75171F3C7DE81EAD9BD9@MWHPR12MB1487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ZrPrPaa+i+enhhzXHniyDoCzgTxm3/gCLxjqi2R8WX84BSZaJHLAhq7tOAuTjFkAmuybXmFdV/BnFNvYfH1LtRr0aW71/0xFCDRS+o4kbS4hr1N6zemH5B0BUFweL4OGgb0vEh25vkMFZ9p0tQNcW1mJZJwJSppPQkpFKHobC5hJHXDwWAaJBiPad4/lSUVf5Z66VIn4jCSDyiWcvccbbh+uuP4DmFIAwfuitYZmPsM+tD+6/ZzxpW5rZ5rm4lb7pWAR68VVUOQlkSrML8+4D/1NuJLB41GfYmjLSZ0TEkIUM43L97b8Yw+jpp0AyJ6jkY5yNiQCGVVnRozqAro/jNvct4+0tfyOAV4h6kWybzmZqDJgfqE/oKkNhJD1DPKpzH2x4ASclTUFdB1L/PRl4LXKiTVD066EiubQV2mEmYvNUvw5wRTVrXbiW5OOomybO9EdJT41s2wca1nrEwTYwIpn6TeiaBZyw88xm7E/otEf3UVVYlYZ/uqRRWXwAxmULgBF48OhQEGElZfwSQLppS9tdPAdSsvNQoN6eymXyJzFAe+k8VzqqCWMgjRNME7LlCQ09+fKC01AuwLb26jTVDwyJlZ5p7Z9iNsD+jo51KTOOPCVfKq2l30QXTw0n2zstBiiahpndpXPKbVMaiMYtA2eFtH6qlbtjAFnj80wtjW8QsfU+9ZuIuX33snySTTv09d3RO22yeiNSQre2eaKS+eK39szNZd0Wq7GpdbntWepkOFcz/7BvdY1RNZD8Z+aEOgagDEbYtokEaA8crHmnAjH4OFZAcifIk9bNawG/E=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(336012)(356005)(508600001)(24736004)(108616005)(966005)(316002)(47076005)(6916009)(4326008)(86362001)(7416002)(82310400003)(7636003)(54906003)(70586007)(5660300002)(186003)(8936002)(36860700001)(426003)(70206006)(26005)(8676002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 06:09:12.3381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff87c772-c608-47ed-be83-08d992c6f8cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1487
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Oct 2021 16:30:51 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.213 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 14:30:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.213-rc2.gz
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

Linux version:	4.19.213-rc2-g30fdb0bbff04
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
