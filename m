Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E9B4B532D
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 15:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbiBNOWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 09:22:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiBNOWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 09:22:44 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB7349FB8;
        Mon, 14 Feb 2022 06:22:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+yQYncF97pp4Ct+jXVpSLwf5B6UfT0yqjmGPXQiwIlkIHCj3CqP5CBfrFr+EJoX5uQJD/XXEWhr2aMUWLT1vrUcd8Y3a4LdVeh6Ts7nrK0qJWfkms6B3CT4AgQXEGdY/2KEshqpjbx1yVMm/+AFW7Zmw3egOs9j9l06wXH+5nHrwgWcNZpZoaK/UqOkOV4jvgufdRTy8oofnKII75W3qslrex8xOdnxJmEXmsoGZ9/adbR657HD0AWXuN2KIyKgVqmt80x9jzyo8y3jf3xTTA4Nt34crCNyGl3y705+/g34LldVLi3+qhwmvvTVkKGMiEi3SkCKz/6UJXvEU2GJ2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6L8tU1EFhjGimfQoWGnDarrM25dwl6BrBUz0nSshfP4=;
 b=n3BBg+PxJUScU8q9Cz4/aCRECkoLenJ5RYZZ+AjoGovowROqXaLiPhRY041ifsZTTL1irzKT/R4w6DP3jbSxNPBbqjBcOk4nkeDutXfpoX4RICNl78FNx0yxKqhHfGDNdDPIFP5pQ0PO4wJ/NA9UZpO6PvXX5j3gbOn6QpbCjFaelgq9SPv+KRrMlTpTowa+9rNo3L3qVAX+0OqQ5Dhl1/4RB2yY3zAG8NzLTfwwD57nwImw4GBx2tkjCf3spFVlAx/LEDJdjmHqBUm3uEsQsOzTadfZd6BCkbaAjTB0ey56hziDKcgcyVW0NLNAxUlVUNnCS7wNgqxMd5rMCrgdFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6L8tU1EFhjGimfQoWGnDarrM25dwl6BrBUz0nSshfP4=;
 b=jqW/KWi8GegKw6TS4jS7dTuWQWcHEAXz9DRNeRanhbD7GGV3mFGrWz0IkYZ/fA0DPQOuYkgU91hb1tqOtGuIed09oBmeC7HifAryWQfMqhfGoICiLwne9M7s7D6DZ59O/Cp+9rhzzj49lZFibxOrlNrhaMNf6zO+1zd6so4JHn4zYFh4zmupVgTc4ykpT+7lbb7pYo4t+PXUftg4uAdqH8MCYVoMxSLH9q7WXZyRJDlkSjHotU7UDHIXUnk4fBhi+HJ3efeFnILtzo6Bgf+6UYJqqb14OcKDGNITd0Wyz2DO1VMkp4E34zXA8iy17F9xHkMJ+sVk0RqetUVK8pa4RQ==
Received: from DM6PR03CA0095.namprd03.prod.outlook.com (2603:10b6:5:333::28)
 by MWHPR1201MB0094.namprd12.prod.outlook.com (2603:10b6:301:5a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Mon, 14 Feb
 2022 14:22:35 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::11) by DM6PR03CA0095.outlook.office365.com
 (2603:10b6:5:333::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15 via Frontend
 Transport; Mon, 14 Feb 2022 14:22:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 14:22:34 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 14:22:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 14 Feb 2022
 06:22:33 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Mon, 14 Feb 2022 06:22:33 -0800
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
Subject: Re: [PATCH 5.16 000/203] 5.16.10-rc1 review
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0dd9ffc6-577e-41e2-87af-6deb1d863b0e@rnnvmail203.nvidia.com>
Date:   Mon, 14 Feb 2022 06:22:33 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 271bb5ef-8ef9-498e-0a0a-08d9efc571fa
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0094:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB00941890E3C35BB609A434C3D9339@MWHPR1201MB0094.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YknfjQOmPhhnRAQ5FQs6raM7qRlMLJ6f6vB7XJADgYo2T5VAxFMwtw51J1ntkXRQxcLyhi+WVs6yzwZIU0KwQhyuFmoL1Abdlsl9rZqGJi4z4sxk+4hLXFlhZ15JqiGJX+BEX3V4i5PUBYK0MG7xzXwcRf+aiY/0gE3pq+WnfEkeY867+PXpxwL9yldQq5G77hMmNvzIu09WsVuQZKemgecquk1itQQez3gIpqT7v+lTefmMXOsVxnSfRfxUW1bEDTuiDDTmv+caQxVvUphbOaeKtAHRfvC0EiEtTIJ4AFmSDq/9vo/nW8qLfKBIyS3WcMc5W+nVmPvERZy9Ii9hiCTBFfmcJh8hCDekdx6d+6CVcw2z57eDLFff6pE/j8/mXREiD0R3o4Nggii3UCVWTqTGKzi0JPXsOYmT+EV1bzzzpV4rIWziiNYdVTHqtNDWqx2BWjyc18mn0jXB9uSz6FFTPqtcG/wfa3Q2IS97mP+Jl7sutO06EP02NGHV5aMzPc4+dKVlMd4J1s/J97jdthxN9k2hFaQ9PsuF7luJE3q9Gft4Bw2nRn3hREh2GdyVc1zg4qUKBgQ7UgKPgzTgKfkPLoJ2pgET3BSnB67pr4DhzBfP0b6386pUYA0z5JZSJhS4/DQgN4HSGZuKBR0XcHOgxAADxWJhsWa2s2rOCuEvTtYfAQDy7eZsme3ChMyj/ayUNKwCzf9MugWYTIfsnsivuLrFCCFnnt5ZjnKS1VJOE6W61gu0RbbknOZP+laTcTeVjetpfsObnpPQGeqFCeIFXAi2uWbowrihff5glUc=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(336012)(31696002)(426003)(86362001)(82310400004)(4326008)(26005)(2906002)(966005)(186003)(81166007)(5660300002)(47076005)(508600001)(356005)(70586007)(6916009)(8676002)(8936002)(7416002)(40460700003)(316002)(54906003)(31686004)(36860700001)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 14:22:34.8349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 271bb5ef-8ef9-498e-0a0a-08d9efc571fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0094
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Feb 2022 10:24:04 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.10 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	5.16.10-rc1-g5c09166a84ba
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
