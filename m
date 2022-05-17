Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2460E529B1A
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 09:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241960AbiEQHjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 03:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242133AbiEQHjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 03:39:42 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE26F49FA7;
        Tue, 17 May 2022 00:37:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axoNwC9IAETVptt9PbFqjuGZBxSnUJNzOb6wK5IvPuX7rI5GZ3pqWUTlV4pgnXGZi5ARMKZUrEuJBAnr6UptOAGSropMiJY9vToilkFi7EXImjExdNHlrVL5/L1TtYienm1y7W+rof1Hny6y1r0Xq2vY4p08n7Rbf/eBvk5DWPH/2mzuBhg+M/RVvFwtcACR3vV9w9sHVB4+hi4Y0QmDy/9SmFodU1A9/pZvro6NiaaYtJquhr9aGyQIxttpkYCSdza3hdfw06eDmYZa5aFgTYtwugHHwGGUQSr4OnbYO01a/9Ga4IRcMd98xWTwyU3xMYMbGzVoH/oLMBVYh2Sl5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JUSozKopfAwoHHhKu9A3sNOnkRfFmFG+eYd4Ha5t8l0=;
 b=WgZ6JeEiKYUungLrdaXOMFQISLZ1koE+u1yr6952rIYQZE1Ey3KCZSkQi0usU4SZ2H1mGc0BENWhTAReaxD46tceCqUuFjl7Ym2MxY1arXd/x/vrqRvEpdY0X6rR/G+Zla96qGBpmJOujBQvH741TBCZzIyiAPeCQhfww/0tuZ8zojyaFIfg1PI8shkSL7bTeef/c8ber2rS+LDWIemoCmU+VzGVeZ1KVcJEnJUfHw596WEZvZNilz96/CzEHzLmiVK6Aatj/HT2v7fUjH7DWMnGCSIfi7qCOcsaLc+mDoGXx/x1lusm6GKVc/q5jpQ9uJ3hfXNsG33lsHkpghpqHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUSozKopfAwoHHhKu9A3sNOnkRfFmFG+eYd4Ha5t8l0=;
 b=l/fJZVGM/QiwcCQss6NAkiLHWfvKecevZw1JbcXreh493lHf9qCDVdn3C4aO9EZMmVaIKW7tWJRUnj7VMPO0AvWeaRp+oeneXGIWbql9xEXlkb/2hAfWpk9JGj38XtW/jglEb8VTPUCU+zn0gjyfQs2qID3aOwXAaGszR0TgifvaMXxGEdOxa0/6vKbf43oq3SHQ3jf/fK02xOcLyPsFfUjhCf2wWfYjgTgi1bX9Qp7Uqa1PBq3Jyrm9+gFHWlaT6q/aDOZzPUVoHO/o87UGGbWUWP+oXp7D95OB0CCftlOX91I97IUuU7LdifV9ZSmvAezGDZ8PZ4+KHtzbJm9aMw==
Received: from DM6PR18CA0033.namprd18.prod.outlook.com (2603:10b6:5:15b::46)
 by BN8PR12MB3442.namprd12.prod.outlook.com (2603:10b6:408:43::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 07:37:44 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::b6) by DM6PR18CA0033.outlook.office365.com
 (2603:10b6:5:15b::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18 via Frontend
 Transport; Tue, 17 May 2022 07:37:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 07:37:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 17 May
 2022 07:37:43 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 17 May
 2022 00:37:43 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 17 May 2022 00:37:43 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <slade@sladewatkins.com>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/25] 4.14.280-rc1 review
In-Reply-To: <20220516193614.678319286@linuxfoundation.org>
References: <20220516193614.678319286@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <62be0368-0fa9-4b06-8796-dfb1a683ed5d@rnnvmail204.nvidia.com>
Date:   Tue, 17 May 2022 00:37:43 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73195f62-8c48-4051-a99c-08da37d821d5
X-MS-TrafficTypeDiagnostic: BN8PR12MB3442:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3442E1106FD600FA2AD79452D9CE9@BN8PR12MB3442.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vHlDGNcp0z4a/W2pFhUD2uO/I0o6+RRvPjY3nrJmvs322RaXvfBVRngrUt2Y4JRZyd/XkuXhYwKlhFQIu+rSYzHGbP+g5Tp79zfAA6CIj96D/irq7xLc0mmBx01NNGydXxy6xtNUfhCAxWugEYeG7tULpim1Nqob8E41orMDuox32djM9kkFwr5oCNivwPsU5NyfcLMFpLRisTKgaviFq1hhhFzMWsstoXG3s5TcwHsZgtfkQ73/wFSsKlKmpHdKfmY0F7cbgxYhuuglTsFkomoT1Qati6O9f7cbJvWVq8ThUGiEvtfqpBqJRRm8jOGyauHUHwRgT0wfP9AXzRQXHwbRnAKDTZz9XwCCJyQ7vPD31tvvZiIqhMVQpiYu45ziMRH+ETyQygyTPDD6Mn75QON3WiG5Es+y9YeycMd9qZ8YjSVPEuqRWtTsLVkXa2oKNWucJXkoUGrqY2q0+2seHBnkV2Rf7hR6Fl1gzEDOnKwmellY9C1gJ+mt/juM8JdV3st6+3ngm8aHVl7VyjQoJQrXt9ojiE6XvLYKtL2X0Kasbt3CRe9Gp7q6UE8oGLTr8x/IBqWUgF9Wppoz8rqUS9FwUxI2ykGEYCUc60glQu+uug0ya1Z/9a56QkQoxCNS2YC6W1Bk3eQp1FL6kiuICN9bP54/mh1ziv66ZpZUwP1/tcTYOEJ/Ddy64NU0fHb5kA/ns6CZA0iqk7Lj2G5HvySl7StbrkcWd0GZikXt+ncQoEwVN0r7hvVXLSsck++GMfH5uhMnE8NuGhfQilfbdzBY+IKNtjdCLVdgob8mibs=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(47076005)(82310400005)(54906003)(356005)(40460700003)(31696002)(966005)(8936002)(31686004)(186003)(86362001)(336012)(426003)(316002)(36860700001)(70586007)(508600001)(4326008)(8676002)(70206006)(7416002)(81166007)(2906002)(6916009)(26005)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 07:37:44.5367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73195f62-8c48-4051-a99c-08da37d821d5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3442
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 16 May 2022 21:36:14 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.280 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.280-rc1.gz
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

Linux version:	4.14.280-rc1-g371779ee7c34
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
