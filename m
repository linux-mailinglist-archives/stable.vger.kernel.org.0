Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0160A586CCD
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 16:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiHAO1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 10:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbiHAO1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 10:27:00 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2630B27B19;
        Mon,  1 Aug 2022 07:26:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OhyeZHFTYSgmIJL7hEa8UI1VOuF4EHb1DQTcb2sZIBpxNOiA5yir8XPjDAsjWXBWnd93WLJQs3KZUHWd59ysP7mQjwQ/T0uabFDPzmK/9/9rwXReiKGY1/FSwLRvHxLSCqMwRyqMEhhwNsi6ARUighnkFlvy2v20JRwcBjlwd25qe+VP+v0CF9KXnz4gciMIh2i9jVZqNzHAwrqqBMubPrDrscjKj8WlAlV28gIKgNMRo12SmdYTD2NHrJWxiUSu5jpt/OU+kPoi2yrtMM6/5J17SkEOenIZMfgxwa3vxIcAwWwBN+kMglwjncn4HMJIp1nXDrDtYtEmLsPZe9yd/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=41qd5m3snL0p5Ba1+1XhSPMOB83HngSy985phCtNRjU=;
 b=Q0987hsTL6A4Z3+c/u5j0zXu2q9SoW5ObUIs1VGYUca/5Psdp0K6ARK7ufz6ge2l9cBMF0jvBz61/5kHlU/6Y2Rgw0lLCpjB6khqKMlE1O9EM4jr/JVgkQrCSbeXItufTsG7iLfLOxmGiX0sJ+OXDVKph5h2D2PbRYNCLXqs6GRRPlfUa5GjgoVMw7QXX1beyAxQ1ge6oQIxDJV7W4DbOeWGgH91wxBNefmBtMue1Xop46vGHXr+R9rQiLnC3JBYDBgrvJnhwW9wNALFeUGHYeFum2ZEjQxbo3LOfb4bnVquvoLP95MgRK1l/3tGbogu/XSRhSNd6iLr+qxZhj+x7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=41qd5m3snL0p5Ba1+1XhSPMOB83HngSy985phCtNRjU=;
 b=Mkm2tbYOYSpupUSSw9xl1RlRJdP8lZBiyHDTyyiT6w7ghSwnCkE2ER4R72S83Zte0iAdhLZy95AX8OMGEBbdcnb2sa+eDxbiBGbk2Y+ZT0oJWxfY685zsNK59EFuJnwAjQapSbgov5+jew1wsgOgq7uuBl9D6jGQpIUzDAQX+Ck3EV+xbCc6Xx4D+24zf+hUNqkJ99FhJyxuWADKz167bnh52Q9UbnFbmXyNkCGs3n5deVEzK3aXCWE/S8DE9Avpl4jGi6I72MgEPNZj8Y98htokwSBa3ursA19a9tr3kHqJUwqFflO+X5TxU+A9M+0vXNiA9A2l363/75UdWdPsrg==
Received: from DM6PR07CA0122.namprd07.prod.outlook.com (2603:10b6:5:330::18)
 by CY5PR12MB6228.namprd12.prod.outlook.com (2603:10b6:930:20::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Mon, 1 Aug
 2022 14:26:56 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::86) by DM6PR07CA0122.outlook.office365.com
 (2603:10b6:5:330::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.7 via Frontend
 Transport; Mon, 1 Aug 2022 14:26:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Mon, 1 Aug 2022 14:26:56 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 1 Aug
 2022 14:26:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 1 Aug 2022
 07:26:55 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Mon, 1 Aug 2022 07:26:54 -0700
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
Subject: Re: [PATCH 5.18 00/88] 5.18.16-rc1 review
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d61fe398-70af-4ad1-b893-be05ba6cc82a@rnnvmail204.nvidia.com>
Date:   Mon, 1 Aug 2022 07:26:54 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 779b89cd-a44e-4496-d89c-08da73c9e359
X-MS-TrafficTypeDiagnostic: CY5PR12MB6228:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RM8YOefIqGZ5WS/GfWJo+UnKSv7ye/yeD/P46zQ7cIZrxrsXr+KNI0mCsQsw+U6WESGyWSmX2jGxAZWZA/qihS224jeJqiTq2fmHBqTAaaeZUHj/SKMOF312H9nKi0cB6aXLY0Gpge9BQbqFymdx2uUi/6SXycdn1Ip9D/EXkGLyp6bC3AvHE2nSyOdMP6IzQ0WmpKwiiO4Exr31SQKDgBU/KYeOB9GPDR9vYZi2F+sqOQUcqfWh3zEukgIcNDSZYomSFLZiyUGqdeWctO13bB3NS8ui9U8Fq8d1qsPOnbExtCy3GXNOB0W6d5Cg70NUHNvplwNH5+T092GgMKz5X2nLledZoSxMo3fOMj99iUlfoeD7OUCaU4ZJcPl9ksgmaqYoDvShhFdVD02I1q6NzrGSLq2NkfgKTPtrgVnLfQXt/l91I7IPovZ3TaE34oi9oT64hXhLKYFSE5bZT0zvQ4uSIODREjgMkrJS+axU2/ZwSGRJ4eT11Xin15RtkvtuyTXviq4BDeJM7CUJ0e9qJLZ6+8bHISIwDRLhjkz7HTyUwRxEEO9lyWrPNircA370eeEFdCvgojN/Cp6sWIv4rV3+ULsLn/ozl0Gl+jPYtt+ZRd+CU9a50lrtHxCqOvdaoNyk+ufcTnX/449T0xGnMMVrDn/JP59XuZAn1fx3azURmurE6sMm4y35ZcSuFDHAGL9497qcQbq1rTqPdPCWVSnrW9oCvK4GpDc053N4ZLF1iTLbSOrsgOVQsjwrZjj8wJdEm6iHyYp6lZUNs4L82SiDl8C2PUiOjA784ICz9iNNgZgBxSwq6CGG4ygh26pvSvhiDfHp0GHdQAAssfXCHMjyUsolNY7Jn6dGpH3JWzJFIeGYqn4RoiwgWRT3wzp8ZEDPFHS0zgtrKs4q+ZRQEwuY60xJ573HDkz+ycOi5+U=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(136003)(346002)(36840700001)(40470700004)(46966006)(40460700003)(82740400003)(41300700001)(5660300002)(8936002)(81166007)(478600001)(966005)(7416002)(70586007)(70206006)(4326008)(356005)(8676002)(316002)(336012)(36860700001)(426003)(54906003)(6916009)(47076005)(186003)(26005)(31696002)(82310400005)(40480700001)(2906002)(31686004)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 14:26:56.5189
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 779b89cd-a44e-4496-d89c-08da73c9e359
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6228
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Aug 2022 13:46:14 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.16 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	5.18.16-rc1-g7e8a7b1c9805
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
