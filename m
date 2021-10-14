Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BBA42E157
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 20:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhJNSed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 14:34:33 -0400
Received: from mail-dm6nam10on2064.outbound.protection.outlook.com ([40.107.93.64]:25814
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232277AbhJNSec (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 14:34:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQSAWykflXcQUPolaR+Zmk6TsFSQbII6cCk0sJBxoHeDwOhiP2Vx+qa57G9F4FTUUQK0gi1NyFdT6go3U2FmgAktg+FnBW2PKSSHrcg3llJWYoL47rWzYPMhOoIBgAEy97uQlT4+CT1mTwjjfCQgT6UcTjJzym8MSeM0HN/98lZqqaVwQjBar9ECE3aO6uhFSe8d/G0iy9eqiptCJdf+aNffDowzm+8IV4+Vq7P7RzVJflvYfHkGtKYmrZbfUPzIPnLpy0YT7crgSs1LqjNIeNEmeorCl92p6zEHV6SYlVXlxHJHzNhY9JrqT75tP5z65I2qglLEHssVoqPgt6nwrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0dPGRUxCsIApZiWbiT6WQ/WLJ00QI1BQMalhBHcX3a0=;
 b=atGwGIR2q2nRMKhNaneNwYTzHz0uRO8YXVuDe6VsmgsaRN28m+EyOXkkMT3vH+2BBMcjybJwMn1AtKJKio2BmcwrROyXua4vz2RE9fKrm1B0kr7Pjpo0X+CEu2M44gKuiwJ9CkT2dvhF6yRziwIPGtSYZ6rKoCAfA7Au6dc3U6SCeHlenIrl8hG2Gt6oEeCTWUE7JyqY1YO/Pggbwz31G0RUV8rQ/VNVAl6kYFfWwleINv3GIUM9YxLUop1wIeIuB1fc+KTk5Os7lUalaExoTmKGYDuwNVj1bYpfJKw18Wb5qNaAF6ZbqQHZO6+KylD2vkqm2f7Qlq/Avq+r5LqofQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dPGRUxCsIApZiWbiT6WQ/WLJ00QI1BQMalhBHcX3a0=;
 b=hoCx2JVyEaZlBn3nFq/gtJdueGxdu2ke7xAmbr+4lB0ytgnprXIoNU+lX6tpWREjEPWd8KCtNbRKCZw+XYDoE7AtdxtPh5ncnTdvIIV/SRUDVbee5Ojxy/So7hrlFecDcCRcKnZWbp+2ig7Q8bP0qXn9cf77fDGZKmtO65hTGwl5Xc6n11Of99tlXbmbX8fioMj3+sN/g9HegqhrroE06XcamYZQ290OlQ6JA/a+9C6yrKdlhQzqAyPKjy0d2Kj5i64OxacJTIVIMUZ04KBiTzanVGPVlKfe5WkyNAoL0jevNaqE//X70jU4ytR2MJrYqzV6xFw14um7JsPXu2Mwlg==
Received: from DM5PR08CA0032.namprd08.prod.outlook.com (2603:10b6:4:60::21) by
 BN8PR12MB3282.namprd12.prod.outlook.com (2603:10b6:408:9e::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.22; Thu, 14 Oct 2021 18:32:25 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::18) by DM5PR08CA0032.outlook.office365.com
 (2603:10b6:4:60::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Thu, 14 Oct 2021 18:32:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 18:32:25 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Oct
 2021 18:32:24 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 14 Oct 2021 11:32:24 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 00/30] 5.14.13-rc1 review
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
References: <20211014145209.520017940@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8b02b94576394f16b8c0a8ecf1188776@HQMAIL109.nvidia.com>
Date:   Thu, 14 Oct 2021 11:32:24 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a3a54df-cb63-4a8d-bf79-08d98f40f831
X-MS-TrafficTypeDiagnostic: BN8PR12MB3282:
X-Microsoft-Antispam-PRVS: <BN8PR12MB32823E4D8917DAD986D968A2D9B89@BN8PR12MB3282.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kZKD1gLOaP26kPS5YCLgQyvJ1wiXs7gecB7xBE1mO0Mh8L1IrJlVZ70JxRjAHjvTJUJj6N1j346A9+0SxbdpYDmkKgNjGAY6NxqNJGssYNBFWGI/yLl8pTvFmZanUQZyGYVQVJL/hjjsaguw6bAAZdeTPhiH1iB00nyjL/OjJu5z+ZIdyugIJoUyh09TIEI93dRUtf9YAc1sG4mrgz3GQxU7uRUJY6kby+xX4YRfQVML48tmDr2JUWSQv/iIsG2hPX2/WscaPZUfC9Jm1I3Quyk4rN7Y5YFo5HwKwmOahTQp2jAsg/rMvYo3VaJ9iFK9iQZhT+F05XKBc1XCS1menhhU2H1fZDNK6lzLdKAK/aqsg8o/G0z9Hb5IyqSFc2c/QlpYEPGPOzURteyneteelxUdf/ezdV7U64KkhZewEElFnXqZ7u0WnCHO/fzlIQPh4VYkzv5FAM6L7MQlT4zbmDdbMZChHKzNI5MnTHoBWD4XKwf+G4FNkWPQC4Xg5Kj7MsVqyRTqxOYc/F0IJnks5JFpo5gZxjKZTa2NfW+PHvFGEU8qY96vpzTBgXvjLaMnMz9cx0kyicNsaPSEyhStCu/692sqaSMessEmNXPcjiWQ0zDh2H70ymC6vtRcspsClpr552bd2K/NCUSb7x8aT5NiFHCJjyOgwk05rYBV84c+ODPsBRycjjdTr/HbfEfpNWLYq810Q9E5gNmJ64ak/saHPkx+I9XGLwJ62F29BT4Wxuw59S6u2PzAjBGzWmtKMBALTKt8Adv6OFf7WWFDQd43GVABDtESyXf3qBVCqcA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(186003)(7636003)(4326008)(7416002)(426003)(54906003)(70206006)(26005)(70586007)(82310400003)(8676002)(108616005)(316002)(5660300002)(356005)(336012)(2906002)(24736004)(86362001)(8936002)(6916009)(966005)(47076005)(36860700001)(508600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 18:32:25.3325
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a3a54df-cb63-4a8d-bf79-08d98f40f831
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3282
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Oct 2021 16:54:05 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.13 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.13-rc1.gz
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

Linux version:	5.14.13-rc1-gc19d5ea47e55
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
