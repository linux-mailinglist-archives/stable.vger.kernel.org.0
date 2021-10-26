Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53BB43AED3
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 11:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbhJZJTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 05:19:03 -0400
Received: from mail-mw2nam08on2046.outbound.protection.outlook.com ([40.107.101.46]:62273
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234241AbhJZJS7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 05:18:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+lOaZX6R8U6lAiaHvvJtHMOTMb6vRdn4ebL8WR36eXd5/cnNL8AsKkX/jl+QDVKdR1RBD/tGQr9KUzRATa5gEu21asJNarGVjPfPfKi7bSi7Ly2rOH74xbX90A9TNvqX2j4UQDP8Sea5TNRD2wAHJZup1KiBBT+lt45j97zI3tsxTb4x3sc3ETP0EtkkIeqy7CqLRtBbCGnMqgjfZW9XqHFxso138M02GSqGVZW3ah8bf3kdUWOfh5Ehi7jBmTHqzupZHRnQFPtpts2aQ6eYMwjCZ/81rWJHUoRvla+xGSq9mTWGxysgF/aC1KY4m290anoUxh6czbAMJ8vbLAPqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ck+QfaehUW13kHxfzCzEsdT8mleryb2HInkQmT5tthM=;
 b=Z48Bu66lSU7fiMTusZyN/ZYXMs1CEyFXWorGXE0VnuQ0ieLkXurp+uz4AzMj8Sh3oCf0yR0k0mA4x2pxQdI4a4q78+KRfgzAxS4zgm5H9yF/iabB1nX3CkOmQOKWxUqMSjfXPE3P9jeI/WpsxJSH5IJ3rIz9Ox6Hp8Ipo/rY3p4WWfVKbA/tk81c0gUaS6lePHCo5+KY1mlmdlJs/4CACMayM/JG0hUBrIWnJetv4OFRnS6XebmFuh2zQXKDcFFvyqRr5n4jeI5uBxkJRDmMIzlqCGBqeffhHaQ+W40JP8gxlUzstPvNKf77TGSbNxZ3t1WCTNFEjE1rvgZWPaidQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ck+QfaehUW13kHxfzCzEsdT8mleryb2HInkQmT5tthM=;
 b=KPeY8OZeQYTl4bcMPLdwxSVurxaWpIpnzqc0TNaB9xy8hGoWcrtz6Fc6hOmNARR0kQpRpXYKgla2yWprjNiN5+Q03IcovvOcTNjh2AOT7n4dSCC12YiwsM5EtH9xwqZxJQnUeiindele5TphlH7jnE0brjRNrqKtwzK85uvnmyt0es08bvxL30AWEU7bRpVgKBzHnE4FNlnECCKd5oPbwwJ3WfpmnPXFDOaZn7U2Ju+i7tuRp2qsvzbPRkgJ+C7KKoAA3bqvoEGW3FIWOc0cRvuEtUL4wZcC0vYXugiCHcCiF/oUY2BaKjdyeai55o+aPjQwJvFn7QA2OMCvyczzqw==
Received: from DM6PR04CA0003.namprd04.prod.outlook.com (2603:10b6:5:334::8) by
 DM6PR12MB4546.namprd12.prod.outlook.com (2603:10b6:5:2ae::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Tue, 26 Oct 2021 09:16:34 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::a) by DM6PR04CA0003.outlook.office365.com
 (2603:10b6:5:334::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend
 Transport; Tue, 26 Oct 2021 09:16:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:16:33 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:16:32 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 02:16:32 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/37] 4.19.214-rc1 review
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <90dd91965c1a44c39e299ba538fb72a0@HQMAIL109.nvidia.com>
Date:   Tue, 26 Oct 2021 02:16:32 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed3b3aa0-70b9-47ab-4025-08d998614df2
X-MS-TrafficTypeDiagnostic: DM6PR12MB4546:
X-Microsoft-Antispam-PRVS: <DM6PR12MB45460B3C18A84DB990212CBED9849@DM6PR12MB4546.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5K1V9v73BoQnImsUVyK1wf7swycl6nvpxeTcN/aqqjUmThQZa11syrG7ExE4UKj6aY5VS6A0tx2SmDGPcKAUoQnAPVFQDWcANSKaAmjbYG+eBE1QCVooF1mvVWuSBLSkkbnpec5Cf0zoNSevTuhVL4b06sWM+/jutZkFLMtHfPznP0c0Tu5UdKnU0tEVraFOgXFv8zondevlMsFwvJsxTtD1dNiFVjQtwO/5Bz6e/M0ii52906+gbqEw1yIepYD2HI60/0EmM4k+iGw1NG3MwSLCvc4cGbTjhgnxZXyjZ0pV6WrehczLjSSDJODloYPMABDncZy0UsUI06H5CNDenVsm+T73zteoM0ayWev58CHoBezUi1YkSRjy7puW14nSOd2rBijQptMjkCKdLHsE51ANHAAJd+OJrk24JGhzDNsQ9ZFI/Q2nwe69u/UW/Sme3O2GpbieL21qkdshHSEesfFoIIqaqu0OcS4L/7fZIKEEHvQyPzb5j1Xb0HyYQlndnNKnVIlUL7PNSiI26Yy+NocoD8AOar9NYp1xaQvDgJ3ZdFOntf72jydMDK5kwNBNNECNXjHN0d4SEmK7h/WzRZPc/xNT7LdkRpoNxXktMjEh9L3NlQs3xTvbRcQSXgBbp3LVJBs/hzPCVSc1LZ/WPMASdxI55lRWKCrIRTlmfTtNapGGTQlrrA6phEgFILY6oA3t3CS2NYQHgkZdumNNxXes6QoNj1t1RgRydwj1FUKmB+6XMFPZrihwIukDOEjZiiUc0vnjlhcZilbCwMzYcjopxTx04MlYra9zLg/+OWI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(356005)(5660300002)(336012)(70586007)(7636003)(426003)(108616005)(24736004)(47076005)(316002)(7416002)(82310400003)(70206006)(54906003)(2906002)(6916009)(966005)(26005)(8936002)(186003)(4326008)(8676002)(86362001)(36860700001)(508600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:16:33.5467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed3b3aa0-70b9-47ab-4025-08d998614df2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4546
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Oct 2021 21:14:25 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.214 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.214-rc1.gz
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

Linux version:	4.19.214-rc1-ge9434cadcff7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
