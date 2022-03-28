Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E674E995E
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 16:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236994AbiC1O03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 10:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243782AbiC1O02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 10:26:28 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2050.outbound.protection.outlook.com [40.107.236.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E3B1EEDA;
        Mon, 28 Mar 2022 07:24:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpZO9pK953CWCRKdL/2f5XW2K9T7iSwFGw22X7/ks7yveAaYh3ckFHF4UgrBQjCY6OHIJL8mOyJR14EGbQxlSzFhiG/skkLDJS6KpyYxy6tNreiwsnRiBocLOPsWvh5K90xfZ6VwFkyJ8LC5Zdel2AkEBTv5GZgsD/QbVYYk+bGFax7Df30Auz2SPVBLxOL8DpKEAiKcOKzUJwQbyislSv0/ssWRmV7P0ja8jOsK9NbzGiU0p5Hi2DipQNJZD/TZiGhRgxLh9XM1n1LU61aM3mQPwR63O+qT3mKeGJkrxZDabe+P2wDivTi/NgxrWjJ/k5EhntqhNTOTOEgAHcRgfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CGEwjCJmDC1lqeDNbKC1zdw7dfhExcO9JEjuF7EoCUA=;
 b=ecu7ZpVs9bwiP0qQ0OZitvaDB8yNZWk6zRtPYWDew5Wc0t3tHeNCRT+ouf9qC4KYuVVzhmoxofhAMpmcydW3hnLzkSsk8mF/cYEFPGeyd9QHIrFqfI/OaQybiIXSwWSKWZ4Buy/70FBCd2WYz9+vdcT+hgpSks0Ipp+8+5FW3bfcXbD+OuWHVftz+aqIUMvH3z2Ku2nkF/LzWrNKVKPyFTka+JQ6D/FtTTKHdwpwsEIaRzh3TMWUJB40L+QF4LhBxQO7fQE3jEVh4wU/Sag8fGJm0QfNChHxq7hraDRlJrQBhIlRCvNzY9XBl5vanAmnCe6geA1/1nSQB/KN1k2ypg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGEwjCJmDC1lqeDNbKC1zdw7dfhExcO9JEjuF7EoCUA=;
 b=Y+BU5GPXyj69DuGG20UONm1V8jl4iBFwklzYKov6WIeGGdBEPFvT8GhhACelGn8XpMDSQan3ZOotcERw1sS7Abi1yx3TSXkZxkHAS9uIwVHH4p+xQ25EYFVxI0RxBIepZgZHY+ULWDUiM2Geuy6CNv6kx2aSbIuQtL0dguJuUgZ5guJFxl2Dki7T/DQ5C+pZ8XQMWygFtdFQ9kLNhx3jtNvWfOWH5C7a26sv/Jr+cUV1VKy7tqotQRcxfr+shlI7c76qK46wVqLX1lA65NI4ml581QS583IVTPjMBbZqKlcIY0mpo6GnIZvEFavyi/djPFCwQK6GrTK76fgNnkxdRQ==
Received: from BN6PR13CA0023.namprd13.prod.outlook.com (2603:10b6:404:10a::33)
 by SN1PR12MB2445.namprd12.prod.outlook.com (2603:10b6:802:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Mon, 28 Mar
 2022 14:24:45 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:10a:cafe::14) by BN6PR13CA0023.outlook.office365.com
 (2603:10b6:404:10a::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Mon, 28 Mar 2022 14:24:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5102.17 via Frontend Transport; Mon, 28 Mar 2022 14:24:44 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 28 Mar
 2022 14:24:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 28 Mar
 2022 07:24:43 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 28 Mar 2022 07:24:43 -0700
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
Subject: Re: [PATCH 4.19 00/20] 4.19.237-rc1 review
In-Reply-To: <20220325150417.010265747@linuxfoundation.org>
References: <20220325150417.010265747@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0ea9fe04-7593-497f-86c4-fd547d722089@rnnvmail202.nvidia.com>
Date:   Mon, 28 Mar 2022 07:24:43 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c1abc66-c107-4f89-dcf3-08da10c6b4ee
X-MS-TrafficTypeDiagnostic: SN1PR12MB2445:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB2445A1A780908CFFFD9563D9D91D9@SN1PR12MB2445.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QEYrrLbM9BYSBuUfiAx+OL391wnY8xboc1sTpDCluqlqOdBzyy6uYMfHdWzlSHBETCgdMuh7DL5BAIIUH8XeJ/TeROv6iuBuceY5gUgoctEcqTCOPAdSxzDTTeN440qzY1H3zirvlJP9IA0Br8pf0Z8s9rfu03PRMxkd8SH+ur5BTR1KSqBEElIW1ANb4Tmx+5oaixtyFEQb+ps0z/bKpf/Zt5/bCwWVO67VU7nVmiS2XmUJZkUP7CTOduYVPbONaNFBFmzYm7qRQUqozvKM7mOiGIfCptivjeC14/hs41PFQxdg//+1B7UbMWzkgeu4gUn/faYBDkUAoTgen8JbWIysrGmZS1xIklDiGveI0S837+CeihT3zaTNitP40sklmnIQM+bU5IUjfM6tikGcyOHkur5NrTJRQj8rDct8bcGXuVf0V/i9IySqmTNY2blIMlt4bQbmFIqATYnm8Kp0RTvE436wzwQ0oehZnTJHTHt1iylYuOh1Xx1Fp7eykq49wK0ENZNxgjejbjZZrbSqD16R0zOyR/qU05Z+OnnH7tjrpJvee3irOYDbQhd7wS/fZQWJa+XQWM9op3299jakdM6W0hhT9VHNRfK8VYeVdIDjfCW6DLu4X3Lw4r2jnLxlbFuhZi+SvHbMgC35DD5ZijNFjleWSyGAwRWdYAFPvQOP11FY93gWPcsTHGCoTxEyZNTzdiy4m3GMXBrb6yoM8lllNO9qo+5moFMT4Vph2yqbCLARb1VtDKfa53rBFEOAjvVPqpTSM6V1rRHEx8tlhdTs3RXddxMut04x3KVx05k=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(2906002)(7416002)(5660300002)(8936002)(70586007)(4326008)(8676002)(36860700001)(81166007)(70206006)(316002)(6916009)(54906003)(508600001)(40460700003)(31686004)(966005)(31696002)(26005)(186003)(336012)(426003)(47076005)(82310400004)(356005)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 14:24:44.9749
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c1abc66-c107-4f89-dcf3-08da10c6b4ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2445
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Mar 2022 16:04:38 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.237 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.237-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.237-rc1-g3a6a22120113
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
