Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169604E3088
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 20:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352459AbiCUTKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 15:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352043AbiCUTKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 15:10:20 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9521D252B2;
        Mon, 21 Mar 2022 12:08:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jdx9JIWIyb58AdPgKF+/M8sDMXwMoBS0E+EV3MK8LIK8i/2CpvyQ3LZFUocCDytHgrK4JjlQSuIBI69pLdOzWI+4BMgISaMXq2EpmI8mLXd9D46vI4g+tBHReu6YiWGFTb91irsEtu7yNVJ3LONzdMdE6UcCan8Sx2udNs6QUWN3KpwdURv6KcPEjj3WXsIIqyy49kHxTx8HhIfz2WU2jxNVVJrW+tri/lO1tTnImwTrbKyErtSAKjYDjMET5D3Ftyt6WRoctvwawmjxFPPM8cTLPwtvugo305IRpYLQPv1FdwhGgVVays4WCg/e5oZrn9ZwuuHm/cbMvVyLnQRqLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8KlOfMCS4B8Uxyxqi6GrA2Nk6rknyKNQufrZGDzfOwM=;
 b=R08CyOeonU2zEkTl5j3yaeBmNU/aUamnICiUb4eRNGqBoxu1e9iuMUb1envQ73TH6FBSv/G4STBY/BGGrwjHSUh3L2i2Cka8yGuaZFuZqLJaYIzCy2hcIgoKy4ku+h85/R6wFOKDmQeFzA0stnjTqUVka4sTexCNCPPS1m7a6q1WnZ50RVzFR3ssZnBOfDR9PvjeQ2fsHhZWaMdhkUmSaB6HFD+1gsZu9q1GIUw11SsrvQiC02ZRaV/16uSmYy7iOgyOjuHtogHxeT47pfG5tLM/6ShCJArGf4ij7LgcV7iMw7YaVrCCXgqtLnqOzJrQVLaEUuG4PwYkHcyeTJPjyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KlOfMCS4B8Uxyxqi6GrA2Nk6rknyKNQufrZGDzfOwM=;
 b=nS7iQW2C1MD4AfhcKuCrHSpzt+rrjqUXmn6wiCmojrWyMWDZIn1KSbf507guHbvk+Dp9dzcs3nGU+qrWm0fpVh54e2stML3y+UXjuaIJyLMI4IApTdXBkSxCrxoYWMxdBdyyQvUlpVTAt5WSRkEPRh/ycQyapTzvbTKMGrzeP70uD9jY1NyBCy1PQDk3m4h1VCyHuZMYHWMJXmhVqTwFl3ZG5vl75xvfgUKCQ9dR0DEv5DPNhd1vWt/IpwpYN11FJeJd/cM8CSGiKTTLie5C2acVM0KnLlfTxy6AnJ9XD/VDVmXtC+03VhM5DFVBO5Xp5QJ8o+9nRI1JIvPo1Tz3fw==
Received: from MW4PR04CA0113.namprd04.prod.outlook.com (2603:10b6:303:83::28)
 by CY4PR1201MB0246.namprd12.prod.outlook.com (2603:10b6:910:23::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Mon, 21 Mar
 2022 19:08:53 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::cb) by MW4PR04CA0113.outlook.office365.com
 (2603:10b6:303:83::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22 via Frontend
 Transport; Mon, 21 Mar 2022 19:08:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5081.14 via Frontend Transport; Mon, 21 Mar 2022 19:08:52 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 21 Mar
 2022 19:08:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 21 Mar
 2022 12:08:51 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 21 Mar 2022 12:08:50 -0700
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
Subject: Re: [PATCH 5.15 00/32] 5.15.31-rc1 review
In-Reply-To: <20220321133220.559554263@linuxfoundation.org>
References: <20220321133220.559554263@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5062df39-a62e-49a4-b98a-d1df7cec5479@rnnvmail203.nvidia.com>
Date:   Mon, 21 Mar 2022 12:08:50 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f0c9e00-2092-47cb-39b1-08da0b6e3d64
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0246:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0246CA196D893473F5125171D9169@CY4PR1201MB0246.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 88J3I0ZReBdlu+j9ecGE/mlBLz8zohvLVoeKd+GuBqS8oofVBiM+/NV5E+xKsJxKYrt9Hsw+G2EJfoent6Slaa2bbCK+xRz3vx+vKe0AmhFzqhG3704IH8C4AK/PRQoHzKumNJrgeoz8CMvZX4oMuE6AN7nQepOGmJuVM3AM19bij7CesnJeOVCk42Nw94lVME9c9oCl+RZRg1/nZyg8xvRQUGLfIJ1yrOJOgrJ5jeAkLZx25LoLpkWGCQas/uu5PCNhF9EJu1lauUvojAxR0IpBS9TG9aCWMek3YqmVxarD5FHOg+1WCY8lw5BSSQj+65KwmADKszObEUWh459hsID3HDVEkMWu3Fzwyh9+jFTvdpNlHJn978/SC0IP9dDI1VvV/BTnmBTHBEkdpStbJeWhwZkqQEk31Tkr5Zhp210tGw52EijYUWu2zn7UwDmAviXzeUttBsjaaVc93K+YsPjJeabgb10lUMBqavhJ7ADR/IQ0jqeBtbZWLygy9tM7G0mT/Givpaf9Koxa+9aAVDLEWEyq26H6aoWPDpFW35R7qik7qSQ5i0CovYcq7KX3DXvUSu876JhDCQYC6a7IGX3id/a0fiCQZ3tRw8AozNriYjOCFkMN9P8i6olbzBzjT78z9waM58q4Hn72Ay29jS/IgCa3zJ+fP2nelu9Wo5oZRItJGPDEca9RRjYAN3LReW8JyhGiT5ycPL1sfmFDeUaOW4L6Mz+hpib7/VGkYvZRplqc0ijn8WNq1hSObctnLijzFs6+41N7erfn9ckIh1koX/0LChHpi/f05hnewBE=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(356005)(186003)(26005)(86362001)(426003)(336012)(47076005)(31696002)(40460700003)(82310400004)(36860700001)(508600001)(316002)(54906003)(6916009)(966005)(70586007)(31686004)(70206006)(5660300002)(7416002)(8936002)(4326008)(2906002)(8676002)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 19:08:52.9383
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0c9e00-2092-47cb-39b1-08da0b6e3d64
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0246
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Mar 2022 14:52:36 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.31 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.31-rc1.gz
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

Linux version:	5.15.31-rc1-gca23d8a1f1ca
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
