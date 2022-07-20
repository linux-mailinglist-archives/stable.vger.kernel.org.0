Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F1C57B323
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 10:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240293AbiGTIlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 04:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240314AbiGTIlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 04:41:20 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45866509D9;
        Wed, 20 Jul 2022 01:41:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lthpQxBkQWIsF3WSqMRQ3ATYvkncWkziA8AQrZxep/qb9/ORBLP/5iKr2g7hvDI3WXeqg3+8kGe1E3BN7mWjNi3JfrWn/ziNdwOE75XXLcW1mxvMfjs5lS8Li59el/cYr1jN9sBzm+fXsnvK4qS7Sq7le8+R41C7+vKlzIBGoOZwEMktVyFtnmAKrEXr34hwT98/2soggDGDpVsK/TUIvELICu9bp6Qxmx6Ym9rgREVs5FCr3rY1RspySeEuj43Bqf2ZwEA1bHLPJNjrnGklMCtcy8exKX721ZQypyCmku07kQb410iqyfPEn0+CwK86Tu0FIIRi+hOOKwSkxgosQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Tp6g5fmT86PxmWdc8JsRPj345KC+QmOahd5T3uFsXg=;
 b=gSSaOwwh7zOMjo2jvjIL2oOJ+GNtY3e5zpeX7R86OzcuyZtJsG8+AYIJwESD2x72rPRUL3f2UAFJi9fhShwVID3fGRdmv6Lufj0wu3/GPthI5tGH0HQ3fxPT1MymekQu0QNwLaDnD7LTNkHM3/Bmjj2LJmzYZ0qgDgSzUZU96QEDL1yWVJKQqMXgrQwGZY9qCwflfTqcjXhweHewXCcSgMPOHof0xG36I4lzFnqKPJ0HkOk/fqH3JCz/OzZVHI7eoDuMWYwtMqp5ekS6GkUDMQZDg7LZ0nkk8JTCWdNgXOeiaCBdh55J1WZE7utyJw67JQd4FIU2QMlZF9Ss7fU4qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Tp6g5fmT86PxmWdc8JsRPj345KC+QmOahd5T3uFsXg=;
 b=ZFc83by2anIdttq7A1eeoERw8vZC2MA/kMGZ26v5mmWGG9EoDq8gs4AoiBEHoV7uK9OK4n+MNohFH9Njhy/iBfQG9YD3oOKiHZB5I+KG5FyboV1UYEw+aK+jDlG3FN1YTD4bMmAiV2vk+oR7/baUK71+tPY9Mq7V9b9L5JSmjbMWcAloL3P4cBcVdqlGqUD6SDljPQBCFqP277yQeeo3XyLUiOXL8TVKBARpjVuWed4eOduZ86PYNEwcUROzUgOV2ROU1BAk0C1jTpmRcNwQHQnJD26lGzvs/v66+QJcEnODEratK52ej6XlP20taCsMS3x+fTqdwqp68XZsl05Y1A==
Received: from BN9PR03CA0808.namprd03.prod.outlook.com (2603:10b6:408:13f::33)
 by MN2PR12MB3965.namprd12.prod.outlook.com (2603:10b6:208:168::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Wed, 20 Jul
 2022 08:41:16 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13f:cafe::fd) by BN9PR03CA0808.outlook.office365.com
 (2603:10b6:408:13f::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19 via Frontend
 Transport; Wed, 20 Jul 2022 08:41:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 08:41:16 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 20 Jul 2022 08:40:24 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 20 Jul 2022 01:40:23 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 20 Jul 2022 01:40:23 -0700
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
Subject: Re: [PATCH 5.15 000/167] 5.15.56-rc1 review
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fed74db4-5259-4279-9d38-d4fd03492d45@drhqmail202.nvidia.com>
Date:   Wed, 20 Jul 2022 01:40:23 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb6f4c29-7e78-4522-a099-08da6a2b9c56
X-MS-TrafficTypeDiagnostic: MN2PR12MB3965:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0zHuig6wnzcHygq309pWCwnt+N0+P0mB4PqQENa4Gc4XqorYZos9Q19jtRJj1kDULtIGyDYXg/O6LjT8+JlThUIbd5mMPcH0g8z02z4XGqwMn+xSopNaK9UCtY7pNoWBa3kO7tVuk//lnrvH3yZtwqMDlJatgGP9r6SHguOhvX1988FDf5zmNk13hGiGbc4JaR98+F2vqnTbFv3EAEyodbnfEyO86ZdPcvod3TEgF5b8Jp2MS6zfPNaNyxASyLwpRFqTpfBfZNtnzJtaOe3taW4X3BIh1kFvLFST50xPrB/ayF5zmvO0mseOORZJzNYMijGl4xq4r6qwi2oQLFbmkK6QVVzbc2ePumX0fPHTdCqIj7552u4BeouwnXsmTgqLtNIRYhoii7wB09HnaDdJFuA13FBAouScCbseOIAClo7GXt11fm0YwPkmZAzA1QqguD2TntcAkBZEth6dcpdZtWmtPzpRZ3W1oTCFYagauu28Ef2GLVJOVnrWzdllbFzEnyhL41z/iVi0AMxS1NeBoPE9W8ZgT6R/UMLlqg1cirQ+GpLREGtxxWKvGi0t0mMUK9300pyspLRMEcM4PlMbP9sbXt+ffIlEZwcLmqFPiJID3F7sqqYNhLm95/alU64Nfh0YG4znQfweH5NRgmvnVpOSnf9Anw9eSS/bh781nJoB/TaL3NSETr/0/vc+2cOcyqdewgjNgj6g6hdZxDasr0ilkcOPlsLyQoMC+y32JBNGmeTjJzyv8cdNpIGQ8FMFAwK3RnFizwkc/YMrpUBQtv3jfaO1trTcUIvgBEsaz+EeynOl30H+Du+Rc4sJQ1k+oUohhOJz4tdepe3UX2br/QrxF8Uq5iBXEwtG1heWld42YNqw0HH+nY1RlbwuntXMZmuHBOQZXzU5+lBYYaXz+63MfnE1gXHm/pufViJLVIU=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(346002)(136003)(46966006)(36840700001)(40470700004)(41300700001)(426003)(186003)(31686004)(966005)(40460700003)(316002)(26005)(7416002)(40480700001)(2906002)(47076005)(5660300002)(336012)(478600001)(82310400005)(36860700001)(81166007)(8676002)(4326008)(70206006)(8936002)(86362001)(31696002)(356005)(6916009)(82740400003)(54906003)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 08:41:16.3688
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6f4c29-7e78-4522-a099-08da6a2b9c56
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3965
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Jul 2022 13:52:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.56 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.56-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.56-rc1-g91c6070d5ced
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
