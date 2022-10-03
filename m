Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC4F5F2FAB
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 13:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiJCLbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 07:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJCLbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 07:31:24 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28403ECFC;
        Mon,  3 Oct 2022 04:31:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVtpwTrOFR9K4ak2uWQoTjhHejJMELsosWMLazhGIJBVKKy/g5lyQOMhGw5GcSVArhuVK77Lx3FDtkknydMYYkISfUE0maa7xk9tsVxpbRISkMXLBfA5lkyQNdEQFVXGqUAs65GHsJJNRrbXrlBZ8RCeWi7HZTT+aEg3en/AbJeqRTcx5u3/zg+bNAnW4DMh3A9YkgtZy0ggH6PHJJiSev2L6X14sPDXsiB43Scdvr1a5Q0W70WI96flAhq3Z/syggo7nw3bidIvN1UuSs8RqBYnh1crNjfjHuy1M+a6qcM2n1FYU8sUsLZqPLWrQiBq1au9NrTy07ClnD10CVuVsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCC037LyoR+OeUKwRFBewE8AgfP2dD3wUvKhT4+wydY=;
 b=DVhw7KEGApFCs4QEo/ZUTPeNEtE62W+XRrLKTZv9liXxU7wBy4OPtzGfD40AqM1GQGviw+/+dfxqi/n/IwtU32N/tucDNh7SK3ZSZckJ8xw0t8cZ8+29k3VdqrdMV7rZhvJ/4O6dhUaDgwESgquzJCQNSDfe88YisAyw7f8zASNnMCEDFOlVRUbLPazioYp4szRHO934VUauL54DUBNkS8FUyF9bcBwWx1IEoDyTao/rPTrIy++R8bZBzsp31nPw8co8Qobtd8cXiHGN7bG+jXY4IBLZ5JtNuWHUMr93VVRcG7gRDnYa4XJJDV9P3O5Dc6mUm9iTtXqhFOUJbzjSjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCC037LyoR+OeUKwRFBewE8AgfP2dD3wUvKhT4+wydY=;
 b=C0qhdgSdxMYxOQiMHETUA+R4J/R3KswQ2zoxcBFuY3+uspziLAQwqIEvlVG7yyrOOHtZPp8kT6TmNpdBaBlMU0BtwvI77Xv9ATHB/zyjKfU0TEQdZXnhbGeIa2m8VRzL5PkB+UztXlJDtciEcHofUB8VABgwwawZythy6AABKm9Qo7TF6MIP8okpM6IWrp0ZcYRuJJvrka3zgF/j5AdC7uA8qXSbSWJbbUr/mrAZSojpF83VsMwv6nKhZ5LeLxj9hMUGpr8CuVTIPDw6yI34n4xhDBpT9gy44XbQgcxFTJoRT+4RIZ6yJgSS49OpD/OfaKPq1iDiNDFsGOlFJ2oDiQ==
Received: from MW4PR03CA0316.namprd03.prod.outlook.com (2603:10b6:303:dd::21)
 by PH8PR12MB7448.namprd12.prod.outlook.com (2603:10b6:510:214::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 11:31:22 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::92) by MW4PR03CA0316.outlook.office365.com
 (2603:10b6:303:dd::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24 via Frontend
 Transport; Mon, 3 Oct 2022 11:31:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Mon, 3 Oct 2022 11:31:21 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 3 Oct 2022
 04:31:04 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 3 Oct 2022
 04:31:04 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Mon, 3 Oct 2022 04:31:04 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/83] 5.15.72-rc1 review
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5232a0cb-3b0d-43ab-986f-c0108d8567c6@rnnvmail205.nvidia.com>
Date:   Mon, 3 Oct 2022 04:31:04 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT051:EE_|PH8PR12MB7448:EE_
X-MS-Office365-Filtering-Correlation-Id: a91fcd0a-7292-4299-7260-08daa532cc09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vs1QtQFJXuASa2dQzvmomRXcu/bmdZ+bW8LEv8JvEwLCIHT+WqlxRXrQTyne/akyRV/sIQlNm3sxpX6QiReLYaTi7h/Tq0hAfYQvsR/EGn1ZxQdEs8YEnNTpqbA9+3IYfVvcFKzr2jwfaIc4PxmM5Tb69SeK7voI3BZNvXXI0yt1y/zAxvRV+0cs8lvhIk3nsV5jRdZlGvkbou7WXNv52FE0CrXnUPJphguXs1eKgmkEx9/iaffKpmT8G8MkvBnZhIYd48IIGj5QJpx1OY5E8HT7DZ0vtdvwXrlXaqI+/z71NAT6fPFyRQIvWMmtoboO3BVTEoMht8VwmKOxCPpKQO1P2AGJHKgCMLozYTilJxVFX9gxm15KwBTNHXAYODmfGm7s9ILT/Bcng01JE7wlei02kAcQu5Upl49DXp+uF9Y6i9egkFmRqWjjLnqb/EHoj9gA8HAzahsJQJlD0gXeY+8/TQpJ3zE9rfK4IBwzCPt5sFcUAqDgs+c124xQ24ufHPNX6Aa/KKe7n30aeURZmH1i16h1+7nQFWYBa1UxgyIAFJivYRXsBfAVnpGxGOoUnO+lQObF+LZ8hfGNixkBury+VCMGyko2SZZ725X5ZGMg8EuQmjZhxOx6FPlig9jyTPpgW32Ve57a6FrhVsz9CFuikI2WDUckbpY/qJXm8Vb/NNhjacG71nXXiEGRLJXP5p2FU5fmdUcZS0cIzAvtLwxah0h6u6yvWfj0Woy+gqiYz1WSuJlfstebnjtM4hH/0izfFjKUUAJgUtgRn5YipCSuTL0/wcslIGZeFBxOCJC5c0avoDL8I/CNg0+BFxdRbaVmh5olUuOEY7yAL/83oollB631UUmEYi68z1eVH4M=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199015)(46966006)(40470700004)(36840700001)(336012)(426003)(82740400003)(47076005)(70586007)(478600001)(70206006)(4326008)(40480700001)(316002)(54906003)(966005)(6916009)(7636003)(8676002)(356005)(40460700003)(8936002)(2906002)(186003)(41300700001)(26005)(5660300002)(36860700001)(86362001)(31696002)(82310400005)(7416002)(31686004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 11:31:21.4903
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a91fcd0a-7292-4299-7260-08daa532cc09
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7448
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 03 Oct 2022 09:10:25 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.72 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.72-rc1.gz
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

Linux version:	5.15.72-rc1-g6b8312581f86
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
