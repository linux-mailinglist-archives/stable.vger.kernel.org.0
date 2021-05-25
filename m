Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1E738FCC0
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 10:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhEYI3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 04:29:05 -0400
Received: from mail-sn1anam02on2049.outbound.protection.outlook.com ([40.107.96.49]:43747
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232292AbhEYI3D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 04:29:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxi6N9cfamRToJsrVrWMuBhV20izf+L3j9IrRJCcTdA//sMcATnsJ1fTX8c+gIhGm22a8MdSDtcHaKsDsaVFWP/olOiuHJWZdwpb0gu9erxTYVqg8jS3kqcUfNmMQ9toSHc+lDZaFXo98FK/I7QG9K6PRBTpVsrIKUtoOQ8KWVZRSW7lt8uvB2LlZToROxLnk9rK3QBYxHvzPtjRO8Pd21FEasnyWFEzl80O+MZMVLBhEjf4epi/lK0BV7UJ6jBP/fLVOt1oK7hiekw3Mx9mcBSO5o7Zaa8KecWNpVLbkOhylOGIWKF1NqwQwbrLuoZ1FZ+jBCCzR4yPsltWd09tYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXiqVzsVdH+41ggL9rhTdgWyBDCyY//UKaDBx1weHh0=;
 b=E+NMz5jwMB/ZPpa2RE61Sj7Ey2yTrA/LEZXf+asASCJAGDsS5MqEgZCsjJyn/RvuZ7pp1GwasVyae5v0XTMiZzJBt3w/ryjDqIfywd7UdX82gSIDNzwik5TfYdGwWwIqj2NfAEXceAAuP89y3or645QnZxeStV63MklDHU8hd2xPRCSmHj1T5brK6R0aY1PhNhAqn42gGqdVG2dPWWCcj71iUN2KlnTFMPgm6Jm+YJysEbY6/1gDKfaoTaQZSjIosXyEq7DU1XAhyXGAeJi2a4jKjrnea3OvYQU41yi2QxvehzOY1TUdlfmpOkH/bqfXH2O8Zs/x4nmfie+ESz8rJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXiqVzsVdH+41ggL9rhTdgWyBDCyY//UKaDBx1weHh0=;
 b=NjlqwG7TpFdh4QiG8kREZTLaql/u9yH4CL0am9WgNwqi90RIBC2zef62h5m/HEn8GBdsF5BoiHkSUwJ04YvOucH88hQxtxE6xVMIG8j0s0YhPlp5k06VlYc2tQ34D9X48w2X/6xKHxkJucyByzPYfv8J+OTJaHu/1mvQq5yMHFgv3wDE5+46ZeQJLjlGYjHDyRBN8wLV6U09Cy6A52gZ3q5JHTGg6TsZ/+relHewQgPFpi84FGw0ylcewygea36q1zvgDlkL59cIM1TGCBvjzVQR6FvyLMz9o88CcG82wLb/VH7r+qY4cb7hwYTX7mI+jZk6n+lRw5T/BAy5XfTO3A==
Received: from DM5PR08CA0042.namprd08.prod.outlook.com (2603:10b6:4:60::31) by
 MWHPR12MB1374.namprd12.prod.outlook.com (2603:10b6:300:12::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.20; Tue, 25 May 2021 08:27:32 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::c5) by DM5PR08CA0042.outlook.office365.com
 (2603:10b6:4:60::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Tue, 25 May 2021 08:27:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 25 May 2021 08:27:31 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 08:27:31 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 08:27:30 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 08:27:30 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/37] 4.14.234-rc1 review
In-Reply-To: <20210524152324.199089755@linuxfoundation.org>
References: <20210524152324.199089755@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <013dcd93cfd54fde904a1c74a7d1f0bd@HQMAIL107.nvidia.com>
Date:   Tue, 25 May 2021 08:27:30 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86ee0568-ba78-4ba8-0f5f-08d91f56f0f6
X-MS-TrafficTypeDiagnostic: MWHPR12MB1374:
X-Microsoft-Antispam-PRVS: <MWHPR12MB13746EE2D5EF3DFC68B132AFD9259@MWHPR12MB1374.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HFXTYk8d0SW1olJYKK6vht7k/akcnYAegyLGNE1r/5nrWSc0dUxTEQS5OgIrIIGe3oVXU7gLBhBy73bTC/oFWE0loIPDu/9fR54DFl76AF9I/N0OjVlgtY3lRmzpOJfdankkR+ziYb/St3EmDAcgrMfrujm7+FItldQb/CzDClBRVfFnrdCeqy6MQq27/PV+0a2tVQbaPPWiNNKT3fWW2334FKbQRr3p98w5Uz52siN0HQFs8SeboBa50PKpa51g3ukDxbQIGiz7FlzYe6abRwGthA18TjMHNz1muEPP7GI7mVQiybfSHgLelMZuzQIvXmlg1VB+iv5uDF+qqRWW66FFOnGi5whdQpIe4PZXtyAUWEzrxhINgyaDhsyxAKxZhHmkLQBkg8reQD0OrY9eRh9j7G/DEqD+nBmhErkev7wC63EYHPwUnA89f9gs0sIxo6/oDBCCDksmh8Hqmgho/PUSPVn3Nle58x8FD6Z+aKB6iL/xx2egGvT/75v2kSqcKpBoqeSaBXyQP1h2VPZrRMp+pIOPzOEHBerSL2e3/D6i2bi4D4R+cDLfPrqGdgPQFT3F4T/mfb3FcjHHP46J4W+VO0UtrsCnQjZykvN5oitix87akqWF0L69nezCQra/7PTta4cIYFn4+j+uyMCNF/9OPs/wkofn3S7EI1k/z8xJSwEZC0tq5w4jwj/1/xt/CGtR6NQC85yyYClf9VhoGKinqd6/uuqxHoAu/ed7Cy0YFuOrETH8JOb+smnJCbfq7RUkXKm3aZ38zTjKwIvZ4A==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(46966006)(36840700001)(26005)(316002)(36906005)(36860700001)(54906003)(8936002)(82740400003)(82310400003)(86362001)(7636003)(8676002)(2906002)(4326008)(356005)(7416002)(70586007)(6916009)(5660300002)(24736004)(108616005)(966005)(426003)(70206006)(336012)(186003)(47076005)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 08:27:31.8742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ee0568-ba78-4ba8-0f5f-08d91f56f0f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1374
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 May 2021 17:25:04 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.234 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.234-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.234-rc1-g535f9ea88cc8
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
