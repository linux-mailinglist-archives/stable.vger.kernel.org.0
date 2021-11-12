Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAB544EAAE
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 16:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhKLPob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 10:44:31 -0500
Received: from mail-bn8nam12on2081.outbound.protection.outlook.com ([40.107.237.81]:45568
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235240AbhKLPo3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 10:44:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VIELqu00TpzhB1kg6kMZBS+gEeUs0ZM5eyNIWNv9qe0x4R2Rw+wMh6XUrjzosAvFTsdPQ/k6jIg97E85g0vhO5OUMXxyQWTrbOsz7L3zdb4p+vuB+S2pVFIS7m5Ws75dlvigFlMNl/DeeJlOzDQiZAhgnr0c23/HDdPCnkqtGdilwEsExwZ8eis2MpIt6VjYwBH/kAxetzYHDZLq7L0LWwpIQHuNRpyxoZggXeIK+A2pDkeBPJynguHrTNjSjnA2ti8aJs7Zh6g1y9Al+BjJCSMI6OxW4g/T5+IeoilmHXAndzhYgSz1/S3wwuySUqqgiUBZE5r73Gfoa34ZZzxCCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WbM5h4hvuHwNI2k6vh4NHRCR9GJkglsNfQc69m8o5DQ=;
 b=UUmHxdd8yfw35TTCaudGUyqPHHnPI3fPpdIks4Q3kMAxqIZRlPCkPF1jPek9G0wpKKdp90PEJdSz19SyFMm1VPdAGx09dbcSooFrApxVJvW4W0uDNt+DjLlW5cxd3EICkUF10FwRHk6pV/gW3AicIWdpW/Kcum5syc4a+j/mxzrrgt+S1vSNB8V9TrBq6Sd5ECh/ldDHue2116n4uc5kkvAnRgTHF4K5UHDWN86M7slXT8I2Ztzwp79fwnf7BUapmN6rSl4wuWZI4mq1BpSEmJuwuq1geDWUFW8D3MqwwE66XzXiJFZMbeW35ctg+nsJ27aLvqTuCLnyiYM2WYrFDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbM5h4hvuHwNI2k6vh4NHRCR9GJkglsNfQc69m8o5DQ=;
 b=gy83W3TFcD7LO0nuVXIvDov+A9E60z3G6rAISpnKo0K2X5n4tHC3ywgLDxym1qCeFTmVRpJkrDbAWbDZ2k6LfE38LyYjZvwQ82F01AbyMeh4e85tL1AF+L69xh8GlBaQXJt6qY3qXixGMpjGTlf4L3JwElG+2jy7v/ONvHq9da+Mg/Ep1qaHbqFRJJHFxDqySsUnYABtWQNPAzZnbO2ORgXyNKzoNGSNjexgp98rg+M2DgkdwQxYbCo3Pr62/JlvCn2XjClcSvpUzLgNmePqUqs7bDorGULjKGiAmUVlukFLAsxjyW4DEZHN8pPJLwGE09rPUC2vbkbPv7Z7NUt4Zg==
Received: from BN9PR03CA0948.namprd03.prod.outlook.com (2603:10b6:408:108::23)
 by BN6PR1201MB2512.namprd12.prod.outlook.com (2603:10b6:404:b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Fri, 12 Nov
 2021 15:41:37 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::a1) by BN9PR03CA0948.outlook.office365.com
 (2603:10b6:408:108::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend
 Transport; Fri, 12 Nov 2021 15:41:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Fri, 12 Nov 2021 15:41:37 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 12 Nov
 2021 15:41:34 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 12 Nov
 2021 15:41:34 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 12 Nov 2021 15:41:34 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 00/24] 5.14.18-rc1 review
In-Reply-To: <20211110182003.342919058@linuxfoundation.org>
References: <20211110182003.342919058@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4c3c6241a389449f8a5413cd4a67bd9e@HQMAIL101.nvidia.com>
Date:   Fri, 12 Nov 2021 15:41:34 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1eb02aa8-1c16-488b-5d16-08d9a5f2e9c0
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2512:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB2512A9F31064CFC8B708A84AD9959@BN6PR1201MB2512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IH+cm/bW14FEqxfzHYAUxCrngJcxtb0CJxS0C9MpZs6QuZsnl5RfuJRCjgrCNTkis8o46zV0QC98E+m7eHjajlehfSFNqVgapPOflut6ir1I/ZrQ3090ixrJ28/UDcWzusDxrtgbtujYfYyCDSKPNujC+y95theErbVf5o6OTpvAYtw4bJms4U89fJjYv7auPt5F6RJE3uO6Ul1oSVD9n6ZyVRPKFfZLgxaQ+Nwhguk8WdCU4EVcBK0R5bgJSRX9BWAot/BdYle/YYzq5Ndxse4o6NeWvavUFLeq7b4QdWw9n1I9mnY9RlUdkzxYQapbKvhA27p6VxUOLTHhcoiPsXgAXWl2IHxik+Nu+wd4EsAqKNLon7TFw7jlKU35VrEjsXiSVZ2uUyYAl5/eQPPCd1m1bU9VvX8QxFmMflSJdpItEdQifCU2/ZgxXerU9KaTJGipaJu+24IVJb/MsyBDXMFsJtsJ6/jeXfa46kLW25QQXeRv4dB7AAIwdfqJgaFr1RvbiYG17Hz7IbR3dMhapH7uyd0Rc/kCAjlEyiOzorHIg9VEKlR6b6Cd4eMi9hThm67AWmJWGzZ2/Jy6s/jHUJecFa9zv9igAmDKzRGPEXIZ8PJV0frKAXLUe34UuWPNvRglcgdeT5xJ8RsSa3Qf0OHh1csYnswJhIYevXJSdT72sxYxHrfafzq2k5Ck8Y+ihqNnGQW6cIrmcC5SB9tqM1JdKWQ5cz+V74kd1PD18dkz3bRBtOtrIdO44pvwJCpyyi8xAwW76p4kkq/XQXihGg4KkCxSqOLY//J8O0iKyS0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(70586007)(336012)(7416002)(426003)(2906002)(70206006)(508600001)(316002)(54906003)(24736004)(186003)(966005)(4326008)(8676002)(108616005)(5660300002)(8936002)(6916009)(26005)(356005)(36860700001)(82310400003)(7636003)(86362001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:41:37.0113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb02aa8-1c16-488b-5d16-08d9a5f2e9c0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2512
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Nov 2021 19:43:52 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.18 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.14.18-rc1-gf4613872ae53
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
