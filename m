Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A75417A04
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 19:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344157AbhIXRvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 13:51:45 -0400
Received: from mail-mw2nam08on2046.outbound.protection.outlook.com ([40.107.101.46]:52960
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343935AbhIXRvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 13:51:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIB22S0kzuSmyBTVmgKxv+gRK7vWPTe9Oali+kcEwtyTKvdjXZ8oDNIpTfRkt0Bgeegglr6g1vzARh1tyRTpHy98qjV75U25wvlMvRqUx21ThMs5FB4d/mSZlwtThyQwl4UlA4ge2wSaW4B9rVWbqlMbnB/CSNQHBCjtuzeQPEAW2IRVyhU66kzGDKseSscXgeg9QFWDmuXpyXqSUtrsfbgk2i6YQqt5cv81/Wf4N40RvFB5RSO5z/vxoNjBt2pcpGjgbQX0wCBRdV19BiStS26NcZS2Eu3AHL5wVLVBvlCrRyAs4tFoskn0L70knRBo0fRvioeOHvZDE66/bmjaMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=OYHbSM60Gx8XdzlCdchp7iQTRH6SdO/muvijIUtfXBw=;
 b=QBfuJbDgAaqAp1ZCwtLw5WKxFcACXAo/qFTfTI7J1hxYZwrEXaP60xCwZP48O3ZwFrqEjUcf1OKrF0PNJ4cY4EMVPwoTvVtwvyUI5pp6Kf0DdPsR5pJ2Y/C6cQbG1mNWrGRp6udR02G2YKT14dQhA62m/aTFELpgDbPAttqviTHR1layABpATNvAK8p4FgvAgdAUANm5Fj9juw7ptEnxNeGRMdqyULCITyhq+tawV8epriUq2ue5vkiT8ibg1ccGaIHixq+OV71XohuSTL9UQ9AaiwRtIHHPISFHu3eFbS9DaIYcTjaXbBhteMz8FkALmUWBT/0KJfWj1DNIKC5bfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYHbSM60Gx8XdzlCdchp7iQTRH6SdO/muvijIUtfXBw=;
 b=E3WInVhxb0+YOCc0lNYlpaS/A3QDCDnDJD0uDFKxg0vXF0kYP2W4wlegJJiMmHjs3b2ZjIz3qxmdtgyXKis6cPgFScaJeANNkN0cacXyTX96onNkrBncvWcKPgAFA3NiBA3WTd3xvE+7Mu/4IAzu72XDXzCSlPW60JCDqYpd48WNJoy9JvrzBB3ruPDx8I2izrO3W+MTKE0nvN2/UwNPwkSE6CjCQTQB5NQ7m4ay9rp1J7zCuEffDZazyJpFx6ZBBSgAfYuFotX+jB4pyCl+ZR6YeOsfGVJXpjQDoInMWX9BWeahM0uGGTSQCMa0xFsQHgdc1uKqU8y9blMKNQvlnw==
Received: from BN8PR16CA0028.namprd16.prod.outlook.com (2603:10b6:408:4c::41)
 by DM5PR12MB1484.namprd12.prod.outlook.com (2603:10b6:4:11::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Fri, 24 Sep
 2021 17:50:09 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::9c) by BN8PR16CA0028.outlook.office365.com
 (2603:10b6:408:4c::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend
 Transport; Fri, 24 Sep 2021 17:50:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 17:50:09 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 24 Sep
 2021 17:50:06 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 24 Sep 2021 17:50:06 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/23] 4.4.285-rc1 review
In-Reply-To: <20210924124327.816210800@linuxfoundation.org>
References: <20210924124327.816210800@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1839ccf9e6674185b772a648758da8d7@HQMAIL101.nvidia.com>
Date:   Fri, 24 Sep 2021 17:50:06 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a503bf2e-53cc-4f21-070f-08d97f83c05e
X-MS-TrafficTypeDiagnostic: DM5PR12MB1484:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1484086C8FCADBDD8F369D5DD9A49@DM5PR12MB1484.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rykghLMrLP7GoLZ0IEh589LkAM+hN903MQobd2bggoyQYO7uPay1JTgbzXJYprlsPQrll3Wv0XtSSuk3lubk2FP3POctPk1TcpV3hi52Mf4pWMFR/N+AubW0bZDt/z7RqI+93lFEZfuvQpYLKvqzB25x24VAI3Da4/n+7fbrCqTjDDucg9GhuZ0I0KuPky67vQFoP4W2uNgi/J5i/YyAFK/wi/blCKq022aTx0oPhH1OP4pH3urx0YZWMKUAUsaGG/b/7UvQOpAOQuuyKauwy9VGwb7fIg2qKYbeQAvGA6gdzCb061ZHmPT5sjOCo3YcdPe2GhPe4MVkKfvOzXsmXA1rSGAa3QRP3wl1KzfLab/VcCVAX5yt0/SWHJ+2YXowqgdhYxI9T6kAgHxbvjaaUxaQZ6zt/FbEMIGoDuzVzLzOJCDIapjb+vyVaESdsrNQ7MLvOTePrdc70a+sw57ec7xfCgI9YIEYUdqxp0mJEPYI5DgR+8pFEOmH3hWLEA1kYuwxdoGBE4n2UPCsqZ/TimHQRdgRgLCutPugBHrmwMROoBADCZd4FMSQ1tY0VY8u2wL4Zpn+ufj+sHuNkXALlqRwll6JyxVthVwOq+hIWJxryBUcuR7fsptCe0KsblvdBXt+Iqx3i/gYeOxTbC5YzbvwvaTYocW7xeKIsREQcnxHxrCgFthmXRl2zcFLdAqpOeHgv2jj6OupHg5ZK6YKzRDqT6FdatkjS3gSrWfzsNHoV0sVRvYIJFykreGprhvmL/m3bSWg4NrxGWrBlvK12Pj8CwBT5nmG0Yd4kSGfjmE=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(70206006)(8936002)(47076005)(6916009)(26005)(7636003)(36860700001)(356005)(36906005)(336012)(24736004)(316002)(108616005)(54906003)(966005)(5660300002)(2906002)(7416002)(8676002)(82310400003)(4326008)(70586007)(426003)(186003)(508600001)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 17:50:09.2647
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a503bf2e-53cc-4f21-070f-08d97f83c05e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1484
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 24 Sep 2021 14:43:41 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.285 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.285-rc1.gz
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

Linux version:	4.4.285-rc1-gf0ff061a858b
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
