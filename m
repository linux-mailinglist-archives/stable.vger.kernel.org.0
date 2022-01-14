Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAA648EFA5
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 19:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244077AbiANSJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 13:09:37 -0500
Received: from mail-bn8nam11on2082.outbound.protection.outlook.com ([40.107.236.82]:28672
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235405AbiANSJd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jan 2022 13:09:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QzLpcQ1DW2ltWSM8MMgIYSIHnWZN0a7qeItxxUNexgADDbwGZpi3kPt2nf+d3Vfj8CyJ/cLl5pYHHAkv/lFeKwGEv8z1D0ft0BRS6zB48RFd3bImyyibLQqCCBfS+zF6es/uubalA71gfkJ0f5jshR0UbwtJF0q2MjlQH8MyYke4Yp5XUhuxoEPikwQmBlQdy4b6ddVjdv1sPDMCAMOTGMqBR2g2/pAldmGoQxWHz3OYK4Xb8E/dMD8epJAv8Wzwh77GrEfyJ47YYtJPlOco9zuzRRidUVK5/p9K/5TjgCRJF0ZiuRhwlPOkrnrETRFs0grYo9AvQWjg/O5Uv1Xt7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j+2tEwYHCL0pCoxLnZnCafOU0nJHwXpES6ud/plXU8w=;
 b=RR5Q6Tzk78u3cZL+BzvhOAlqClu/N6i9H+jQ53nd/MPsHFKrEGwo7dj16t9Ik1E6yh1C9OBf7QRElG6TgaDyOdQ/mA7i6KlM8GnGaJI7nEeYvNXyp2VA1BDmJOimeN+OGEfHTVexpeYEtQRxxynAhobM6t9nvDD9a8SI7WkEXYyNuRQe81hzrijIgemMaFInhNZ8jPj9TiQH91uf74iVveg0pWXBAY+SbdfKNncwZ9ojx6a+AogvAzW0sUQ59kTfqAAlMS3zZDkWAlO63loOFzczgofFDxV8yQosEc1RAsGDvqdKO03JWih3w5C77IQbC42iTWAcC7jhHb7xaLMNrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+2tEwYHCL0pCoxLnZnCafOU0nJHwXpES6ud/plXU8w=;
 b=p+oKl1cHxTClmX5yN8tXI8n0OLWbhYcNPOZCGNHRdJwmdOsezSR9fjxDl2GqwXLjyjMJUNKdGcuHjOsQT5qJXVDd6jiej3Tew0AbqzGVJyhP0FbYA+XMy4FAx7IhPU6WMDd1LcW/jJsHDa4SK6UK7W0Oz5HOf+6FL1XfzhtjhjRQfjZHz1mEdm0wAmT7+iC3MOImILGhT//ASiZkByZpND0A3QT/m05PvRko4Z7IUaFgLPw02sSwYt3iQLqWQI10rPfFVL0PF/xzsV4wu+yhhZnsGOzEXmNe/LWx2rRKRfqkqct4n1/CMS0OCngXI5P5IBtSs19Ue3/cdDmiaDD1pQ==
Received: from DS7PR03CA0300.namprd03.prod.outlook.com (2603:10b6:5:3ad::35)
 by BYAPR12MB2918.namprd12.prod.outlook.com (2603:10b6:a03:13c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Fri, 14 Jan
 2022 18:09:27 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::27) by DS7PR03CA0300.outlook.office365.com
 (2603:10b6:5:3ad::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10 via Frontend
 Transport; Fri, 14 Jan 2022 18:09:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4888.9 via Frontend Transport; Fri, 14 Jan 2022 18:09:26 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 14 Jan
 2022 18:09:25 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 14 Jan
 2022 18:09:25 +0000
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 14 Jan 2022 10:09:25 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/18] 5.4.172-rc1 review
In-Reply-To: <20220114081541.465841464@linuxfoundation.org>
References: <20220114081541.465841464@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6e3687f2f91d46d6a54cf82861462460@HQMAIL109.nvidia.com>
Date:   Fri, 14 Jan 2022 10:09:25 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42c9db68-0551-495f-08e8-08d9d7890067
X-MS-TrafficTypeDiagnostic: BYAPR12MB2918:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB29187157BC4E9C5A5144EA0CD9549@BYAPR12MB2918.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wg3fW4uOOpSmhhEcYkeMvdj+iNxpT9+RFdCL676tw2Gjds02JwW5/8qqyIpboEB6xV6r9i8B2jgsZ3nGpmNdx5Ik6o3wqI/FDEFRpu37RCHpReO6NVskKpKqjfIv+NvspJtHD2NA+dvk9U8rPf3nM+Yd/M4IBcvzmVB7UkCqIEw9j8sSVwtIgCu5qlG3rGe67Dc72RiFZ08VI3bwW5Ftax+iPQEI4V17eW49WHZyMtowAF5LI+UZSl/s4vKIoNpkbMMjvOvBlEHpRraxYyuKzpmvBoD99HyuAmcDGnrcn60d9CiibSqnndwWhB01GqaEBGUoKNPjYpALqdzXtNxLCCldzb+Zj4wzLINQclgEXUbkue4x3wsB4+qdv7xR5s1hyyyMrZj9ALSFEXxHIxBa1a0e57nlQUdWEJd0ninazDnVVlza42nxF2sbI0r8bOIzUj1j7GqDNX1eSWW6WIChGvYkhieEjr4MLLpBK9HT9ve3t5zSXjQVWNZmFDstVzqDAFvKx9dW7jtWIyp4fLRtJwPDQXXzG6N9SRpvlKqPKnaQeIosxUboirlTCjaiUx8FOe5YrLa7tigWXNI+o3Z1r8N/qKsmv6gpebFmsNBP7eZVKL0Xp7xr36vdB1XnCc5qCUOy49esqN8xsgw2MrJIA5ZvVF9sMhkfZ1pnRf+y2fMkKHz5WChzN/167S89yFjncJVWB+Er4q4fLuPG+LpuB/vXB2ma0z3pbZZ00vx4IX2SdgylyzgY/k8MRrXHhblfleBFuQYnNdQ5pyTVTSgGPkGQh8p0oebof2j///M9hKOZeCr/ia8iNrzQlkJmKtE+lOIT4mfxp05AJCYNd/oxAqjK/W1WFVCsoUIyLz3J2sTrZGUX7C92+sKI9FaoHMYh
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(81166007)(316002)(4326008)(336012)(8936002)(356005)(47076005)(24736004)(108616005)(508600001)(82310400004)(966005)(86362001)(8676002)(36860700001)(6916009)(426003)(54906003)(2906002)(40460700001)(7416002)(70206006)(70586007)(5660300002)(26005)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2022 18:09:26.5629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42c9db68-0551-495f-08e8-08d9d7890067
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2918
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 Jan 2022 09:16:07 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.172 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.172-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.172-rc1-g8821fbf93a8f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
