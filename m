Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677B73CF6F2
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 11:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbhGTIwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 04:52:25 -0400
Received: from mail-dm6nam12on2051.outbound.protection.outlook.com ([40.107.243.51]:19249
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235619AbhGTIv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 04:51:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3y03BNNQ+DHe2PfqBDtP/7k3uZZ+gjrh68ESayL/GlsMuGjhWA9g+GUflTLYk0VlRZg60fowUvS/UCa+/4STRo0rKXgasUnukZdTjkSpOoilwT/MH4uMmxRYoJNZgloTuZIVloIl36YIW1KMbNsYVHqohnu0gQY9btpKwphEgkcgrjwk0FQSN/lJ62r7JENIAgwe1bGrJZREIGFslrA+w0SvNBNPEgJKPBRIyantlMK+M9T5Tb891uyewIrz3gXMC+D9uxR7YYA/U83kvTe9qw+1hQZndaZSOZUAsY92MqvX0JrNHZ18Xo+o/PrE5x77VjULvKRyatR8wvoKgV5oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zuul4K2NvIIz173KQmz8Jzpoubcsq7PTV/1fgOFrRg=;
 b=FnaP7JNb515h80J+xqWvhFAuLIwP4WEx/QgZvz2b1gZ8sO1I+fWNe1DMHKKX8Rpk8TXchEq0QKC2YbxHuOcDE76WTJEwZe+DVXY13jiBAkoEphuE7aW3v4J0qP7sOk7f04OdmSOJs1xZve/yfkVhEroPtta1hscq5qWruCIqy0LHE3tiPr9WbiUGMSYS6wrq5AIuocriMp102rwxKcb60+3cXJsIpZcS8lHezRfbAn8KBcTNXt/HwQRlAdPaDmMmz2ZAnrIcyh/bqVWGJCPY8soeWoPW0rmdvmz5NyTcFk8KIcAgBzyD98ekIvCnoMsebyKga8P039pqHlH50vDIDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zuul4K2NvIIz173KQmz8Jzpoubcsq7PTV/1fgOFrRg=;
 b=Jdel8HxpoYF7TSo1W7IY6dr3fkAuAPeMf7uIp5HL5OOpj52hpxOixBs7SffCRPBeGEmRQGKvHpt49CpyE/c23jGZ+NiZgIV/CBVTXLP3Qh9dKqzBnPesb1vpDU1iQrnOKutUig/LWlLKF0iEzxyvcpe6aAvYxxPgDZx40f4/xXRjffbfu6nJ/sSTSeocRrDHWSmnvl3i1vksyiEIERROeS73Uy4lpNA4iOfwhukzbzvqK98QP3Tc9Rny+4QObs4NdOkW3FO/fOEJhsxKF9Uy9UuKAw3+JQOcpt1ylfPv5v2G46gM7iJQOQgQ+PtnN7OcTrFHnPErrndI5TaMoYNK/A==
Received: from BN8PR15CA0053.namprd15.prod.outlook.com (2603:10b6:408:80::30)
 by BN8PR12MB3539.namprd12.prod.outlook.com (2603:10b6:408:9d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 09:32:35 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::59) by BN8PR15CA0053.outlook.office365.com
 (2603:10b6:408:80::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend
 Transport; Tue, 20 Jul 2021 09:32:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 09:32:35 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Jul
 2021 09:32:34 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Jul 2021 09:32:34 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.13 000/349] 5.13.4-rc2 review
In-Reply-To: <20210719184345.989046417@linuxfoundation.org>
References: <20210719184345.989046417@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e903c07a1717454f9ae06ee467ffb5ad@HQMAIL105.nvidia.com>
Date:   Tue, 20 Jul 2021 09:32:34 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edf3d881-af62-483c-c5ed-08d94b614e92
X-MS-TrafficTypeDiagnostic: BN8PR12MB3539:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3539324EAC95692E49503D02D9E29@BN8PR12MB3539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: slHR/9W5ROUPidiRTMvb1+Xfnp3rBk77nHPP3hmHfYGWQVT8pK1IqBrLNgYbwixzU0WATlPVujjnif5ARoHJ9OyawNRSSbWogwSmdGYfojggKNYLCV17RhMshu2JNnMuuwh7garyY65wRqymFU5AuQPB802BRqPcxXbj+TKSNTdT09rDWEbEbFVFW2GqlbnZA1vYGopczQi9Ukv3X/83qiHYUJmXqxnspZP6/q6Y6vpMeOihao605UFy8o3VQYtD5Wcjw7FRwQNNlNNmgai/G6F9OCowrbFsahW22/wy7TCpgIV4TYkQGGm+5rp9veLyNd6nKkBadVcZ8AOXVZPXAO7fVYimsyNDw5ahRzu1UJd0n57tX7xTb+DoPeg2sQhIFd1rWPP/Sapdl7yuVkST21DHEJhM54Gp/XW4t8cFV7GKii0cH67lEQVPXaenmcEG86QKevGvz+nehEw4kyAzgL2TI9X9rdWPTU7bPkNZlqAKbUhwV8IANWTcm4qEPd3Pfm1bQBbM4UoISxndrhyEvf0nSir2dVa3/XQzuZgqrsn7ffUebHre71Lm8hF7dNTBcTF3lX4wquAMfzcK1t4lDt4gv6tU8ooM8fhtMmzagbSHHmq8zMhcYqbuDNycrZB6jwjNdCpDZI75aJk+PKTjFQeuv9MQkjGrFmjzA5p0IsvUSDhd+kbZgZuRK3FjF0SM9RuPvNocuUr/lWxj/O8px0JXqFDRqI6ZZaFxBGTeQlsigJzMlQQ29VFoAqfm8ablqYRZ8KSEe6X9NA9N/dEkZnju3bvIcqaVztoqb6XdAdY=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(346002)(36840700001)(46966006)(316002)(478600001)(7636003)(2906002)(36906005)(966005)(36860700001)(54906003)(356005)(70206006)(82310400003)(108616005)(47076005)(70586007)(426003)(4326008)(336012)(26005)(24736004)(186003)(6916009)(8676002)(5660300002)(7416002)(82740400003)(8936002)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 09:32:35.0179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: edf3d881-af62-483c-c5ed-08d94b614e92
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3539
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 20:44:42 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.4 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    110 tests:	110 pass, 0 fail

Linux version:	5.13.4-rc2-g1d9dba03aebe
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
