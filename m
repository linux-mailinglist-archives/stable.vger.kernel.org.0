Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3AF492FB2
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 21:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345711AbiARUtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 15:49:47 -0500
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:35873
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344254AbiARUtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jan 2022 15:49:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qzeo+q6VgiWedBFd7+kUhKPefN8PF5xkmV+zMAjMGQgRyxbiiUJohb7c7XlLJ19/psoRvFqKafISimvzZl0nXSSgSlaYK5Ccra8bAzzb4ear4wpmf4IWtVqUJJzP1mqx5gjvZlhk01eUv6XjaxoTso3+du+htpwS76eseh8h4/R5MieTqadaFB2LNc37OE4u/N6aJdqjuWLmF3TT9kZxV+l5Z+SYgSpJrEj2awcxBUI4x8QMzsrcMIbzhXI7u87eC26EjotygKtEkwuHtpwauCOrxmEKJ+RLPfGR44S2L00vuB0cIPLLPEZm233jP23iXCezMtd2K5kIuBQkkqZlFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KWlTIulflvqRWwmrikGYebyM5eLkLpOq/E6QDtjvQKs=;
 b=LKKZnVot1OPEUqC+SrbL5y3A3SQaDSTojjtIz1hqwXYMnyUJmlbu+5oybTO2Y3lzpOyynLNKy4+KdYJTYvw+R+PMuzcPxXh9YAtiZU7CXz6P7SMEL1EeKly2uKgpwSQsmaKp9ed/oicXmZ5tJ5MYEMIGvIV1Pg6M4fO9ypg+q+JtnPpFx/3ZufK/42lHINC9DL8SncTVbRRP21JxNL2/CZmLbkY8QHq7KUavgk2ecAQCx+C3MbcUdoQlZBhrg3VUdYp/HXeNz54Arx1yhcBy92MAgUrKAW0thhCXH21V7PUOFjM99lUf8JGXAqxJGa1H8KnwofaaIaeFxvk7coKnrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWlTIulflvqRWwmrikGYebyM5eLkLpOq/E6QDtjvQKs=;
 b=Oh8/cxwSMe1hROQQ+zm9zkRXpLSQYVN5N9ZEI6xfERt6M3IKUCdslHjVXxPUjAerO5M1qulCtjERDi4D/C1Cy6zcWkSUP3AMG+Ls8ZxRsfoiyCjQvpjuFiDXLqu0w4h3mG4kP8FyWxobZgoCKX6/nIgjqr5tUUK91pM+md0xG0OgQPBphQ4r+WLZNho975NQwqqS6iZMmuf1nkKQLKtkMfzJAzXzgwL/GstkHDeQivqzYGbwUBp4acT5oGLsgmbBPjXjUV0jlmU8uFtuoeCmGh7FqvsWcJMj+GMnex16v4MpCh2jyRpObWBIg2Gg0UoWkrKqCQ7m5ysbuClRp3XKRg==
Received: from BN9PR03CA0685.namprd03.prod.outlook.com (2603:10b6:408:10e::30)
 by BL1PR12MB5336.namprd12.prod.outlook.com (2603:10b6:208:314::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 18 Jan
 2022 20:49:44 +0000
Received: from BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::d3) by BN9PR03CA0685.outlook.office365.com
 (2603:10b6:408:10e::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10 via Frontend
 Transport; Tue, 18 Jan 2022 20:49:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT033.mail.protection.outlook.com (10.13.177.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 18 Jan 2022 20:49:44 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 18 Jan
 2022 20:49:44 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 18 Jan
 2022 20:49:43 +0000
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 18 Jan 2022 20:49:43 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/23] 5.10.93-rc1 review
In-Reply-To: <20220118160451.233828401@linuxfoundation.org>
References: <20220118160451.233828401@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <96e52ddaff1048a3b750c7879bed5916@HQMAIL101.nvidia.com>
Date:   Tue, 18 Jan 2022 20:49:43 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ed3ac78-e7da-4531-d109-08d9dac40ee9
X-MS-TrafficTypeDiagnostic: BL1PR12MB5336:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5336E6A60FDDA193CF009000D9589@BL1PR12MB5336.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DaZDjzqN7XN4mPOAfpb1JpVEar7SMnESSyV5ONyTCdx5bO298txvwHpG4VURVC00RGUApk8UhnQ/Tgvd6YRPKwPzUehz086zk+mNMQpxNtrKZu1vc8qnlqJ0czz0XdkTi80XdSUGiaV5iAEhObou1pOQHhVYTU0ZLt8TA3vQjn6EdRcP9fcwH3L6hseNSeWsQoQVU7YQvxO/mRYYsUWbM2Ikwrbs8wPYpTkWrgE/fLj4WievsLwg/5Vg1LbL8RTzJyXpxPo9TDr5g4R/jXsJm17RgMCItVrp14L2xP7CM44y5oENrRL4ko0xNPcAfiQg1jN45WJnyh6wf83EtitW7hlmSQ4K+BfAlmcvZ0tg5iwrId//QgRXMv+YFA+idZCau1gummNS+SeaaqKE1F8XjD09PmHs/ww9B2+e4vT3Dko7R/V1hIHuhlnU+95LdakSbQPO+yfCMIeuI4PrQLx/qsi6RpmSNVYeSJZE1HcrNfsjr8p+fK9gLiPku+4i4krVRneS6ZIYrxkzdnWa5Lg9BRZrbV2iFVtsvQ3b22bw8r3rU4dvPt93KGcMR26xk7ceq6vnBFSeLPqoF16CCsmcNb2Y9+lZ4RmJo9TySbiycZPUFkRQlAnlagpaipuFKFHI9ZOvBgX+iSkOYmVkZCctOG6VxP/mVDZFSdIsW0FWbSub5uMNFabGfnTVURO1uP4hw4ACJdb6hEKncN3krKol9pHtEbHsj5PdoyS72ofgGcE0eSpaKg19Lwq2qINHpaj3ylf4l/TAa9AVYgbIxeP5I3cfqlfQ/qJ9NH28CNrKbyv1BiTqRdA3THuOXqCu1s5uYdOyKDfqYgH9CLz00HJA35b3Vsufwk5GxE86xb0nBrsm0/wDjfOOZ8KjsIwkAXlO
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(54906003)(356005)(108616005)(36860700001)(966005)(8676002)(24736004)(2906002)(5660300002)(40460700001)(82310400004)(7416002)(26005)(316002)(70586007)(70206006)(508600001)(8936002)(426003)(81166007)(336012)(6916009)(4326008)(86362001)(47076005)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 20:49:44.6410
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ed3ac78-e7da-4531-d109-08d9dac40ee9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5336
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Jan 2022 17:05:40 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.93 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.93-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.93-rc1-ge0476c04ea89
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
