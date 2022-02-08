Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A154AD36C
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 09:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349746AbiBHIbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 03:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349675AbiBHIbn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 03:31:43 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3E4C0401F6;
        Tue,  8 Feb 2022 00:31:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UEGjtoQ0RqzCgjmFC8hrtIkPTYXtYJHSrEsrAXJG/tl9jo1joCOxSYSKKQeFYp/J83K+wTZygYvg8wr8kLbklDYCJqlTHYvXYn5p3krLcrjF/PWY24Aph0dlhyjy8Yl4QV1mVQufdxgGsxGMkswXV1CFtK7Ha3amKU61c5SKkLJGMWGGvL4TffT6omkZf3JRMwZfKHZclz2kdNXTBCnkMPpNXPyIRZnIUeJcHkGpNZ8xL7mdxXDX2TQApxi9R5FSUV4r9QtvymP0uL4pw5ndkl+q/Y0ZWhMEkjb0Zk9axiJmCECsL04jT9c4IRDnd+JpJlQTNZiyhN4/nO5anvIqpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bIke43tJhjijo/LpKXnYUCQE69CjqriZB/oteTG5r+c=;
 b=gWltUvVjlkKJBV+T4hkpX2MFT3hs8umt6YH3l7C95yaAFwsesrdRxysiNOWmhw5roOExM/OtcdkDZ1+xkRp/iqrUJgrqbSJhRiC3P0Ey+GgXrkl80U+5+HE4iwPhq4pU56gjNkXe3Gb5JNCrmbVo6goOuejjJJpPjtRcPlKm3mu9U5lv2QAaO1Q1XbYEyB2KwMW+SEBlNPKRdIN9uZgK8OMzaO3N0RJ1/wqXu9w1Bsrr7aRoj7NT9vyfogtrjd7WE4AN5uRrdFtLJsZi+vFQgTFnIqeIt/AuoFa9kWQgHzzUxEeC4M71xH1AoxgXAik9L3zY1Z4vsaSCxOZPC0Niow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIke43tJhjijo/LpKXnYUCQE69CjqriZB/oteTG5r+c=;
 b=JCvJ0BVvu/AtCjHnLWC0zMWZGfZX3anNNYTDpnV5RZWpSgN/y+raoBdhM80xtAUiKrhBtFUqcZGY6ubWy5HzqvfXlfUnaC5QILC+VfBapcgqdy2QCBFFnzFUzW0nUapFM2yAHzHbidqOq5RLITJ382I159A+JxuewKjGSAzf2NpBJncet4ejcnbLTteXuJg2Ay1vRMUHNBC7cxu9WeFL3Rrb8jS28BrUbV0roeGEo2pGN0Q0OonqwXkrAo0rsMgp9kSziNDnM/pecEJDAJgtYKCRulWUtQST1lFmdrIeFMnazbgewtrRcopc/cASON8riIZKG6QG7aEP1YkzoaWLWw==
Received: from DM6PR07CA0121.namprd07.prod.outlook.com (2603:10b6:5:330::33)
 by MN2PR12MB4470.namprd12.prod.outlook.com (2603:10b6:208:260::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 08:31:38 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::c8) by DM6PR07CA0121.outlook.office365.com
 (2603:10b6:5:330::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Tue, 8 Feb 2022 08:31:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Tue, 8 Feb 2022 08:31:38 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Feb
 2022 08:31:37 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Feb 2022
 00:31:37 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 8 Feb 2022 00:31:36 -0800
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
Subject: Re: [PATCH 5.15 000/111] 5.15.22-rc2 review
In-Reply-To: <20220207133903.595766086@linuxfoundation.org>
References: <20220207133903.595766086@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8409397e-d308-4a9f-b47b-50f7624b75af@rnnvmail203.nvidia.com>
Date:   Tue, 8 Feb 2022 00:31:36 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3eeeb9f-8b9e-4008-efbf-08d9eadd6cdc
X-MS-TrafficTypeDiagnostic: MN2PR12MB4470:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB447061081F06E82F3AACFE19D92D9@MN2PR12MB4470.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F2H02tziLJDJuCejKsEAej/xobU6UyhRkGe0YGzxTTija2O55cxUwDHXCya0Xkm90+AHpx+862iMoTFVwHJufcDskYUHTMAllOq2hlpuGaqVhRidwSI/0bE19dNAtrvEjl6DWnTnd0VPElO7hHh4T5+/3QMhgGlWXbpzZU60rUxAzJ/7v4lb3pTAfyRxAUXE8IhK5jd6MnmP4niny+iWT2YBvuOoYCQRaU2Jcx/wfPHmlKgzs/DjoH/DW2+Sp4klYiaDv/vgRXCU5u8eZPSN3+BMhrslMhYmR6iciq2vrg5gUHFQYBiI3TE8TQMfn3ktIOqRTWxUCMVgYW2kily4+t+cQzzX1zRlmtB4uD0YS30LD1+4ImA1C+ryU/p3ylQyDXtqglO5kj+4k62SUO2i9wT9UYa3UdG/k+58rsq1sL0ve4krRZKqxzOinyVa6N/VIZ6HW90g+oHF5P2KJa7BuqvFY/sP2CeCqGq8QkBSPSQC3MhX6M/XXejiZYVQWDt4p6UaoBlpeuzDIkHYlVrg36My8AIdxT36iu+lJaUB0/gWr4eyFRMbakHCe16IOGdYwCh+Ab+us/KQM3LONFNKebX5VseWwxgvL9cNeuqzaS1vKSx564/DjhDh07GZAz8abP+WhVb+YKZAV+HTLexS3139jASShGaQkPUdkzJStBIRJ0yM/71mGROm22/t2F3rcmlq/uSjjXSwvqjEA6eIjCfP83IwVl8PSfQLusZGu8pR+NZg2RUsWEzV1XvS7ErI5udjF14lW7yhEKcbT1vA+rjY57wpVAWkKOUeJZxRlCQ=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(4326008)(2906002)(8936002)(7416002)(8676002)(5660300002)(356005)(81166007)(70586007)(70206006)(31696002)(316002)(82310400004)(426003)(26005)(86362001)(966005)(31686004)(336012)(186003)(508600001)(47076005)(40460700003)(54906003)(6916009)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 08:31:38.3632
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3eeeb9f-8b9e-4008-efbf-08d9eadd6cdc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4470
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 07 Feb 2022 15:04:35 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.22 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 13:38:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.22-rc2.gz
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

Linux version:	5.15.22-rc2-g0472630a5621
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
