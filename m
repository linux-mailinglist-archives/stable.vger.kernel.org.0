Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2F54D147A
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 11:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbiCHKNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 05:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345770AbiCHKMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 05:12:50 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E676F427E6;
        Tue,  8 Mar 2022 02:11:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0HHlRjoDULlHWO4GJa3u7qvPFwXY3izeR8lpE+tZQSeSO0GYRd8Lk4DbV2doVt0DzNrm4783WfaK9UNuZGP/0xDAMohG3ZbwR9dhO25EqbnDDmNKT12/u4OVisrDHZlQto5wx7/0yJKnpJa0MOKZtnKPYlqsdPwEwDRbmKcrynzQ5nHkhM0KmXZpnA+0q2EO6qeIl6SPGQHAxegPHllPRh90nCKYVBfYPRie48gFvRN0wl3nWg/ScbLjosL6LlZbjlOgIrZE6F7e0BtNvqTAS8ow07AeH7neiTTmr5swB1aGGBuRihWltWvr/os7CGEvXJ15y1uV3+1y4iVKnt5Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XzDA9rHuiDi1d10uPd7ChXkD3gfEhoBY9/1yZJ9ZFBg=;
 b=VA89tLvUSiECmQsuK6gmagxqCCSL8lb5kYALSZSWZIIeY+XNkAsxVhW8WDse4+UO9VVowv/fr22+wbfyVROp57x/9hhNbXi+e+Hqnp9azG12pH9cVAmjQllj5YROy+eHue6boTp3KMMDbXW6q1TjaYJa7VEFgKScHJ5UJuG8fZDBCN4pklh1ZuNq3HZ/nxc4MYyGkNKdKm9KgaFJtV55PnYRrd+D+xap0K/5pyFhHILJpZwx5PXgHXh8uYrIso6cNGU/HYzaMHBDvBBtcDvHeelQp1Ft5Mm+9arx5vfg18rFmyLbkop0Fw5VGfpk/IsZmbMQve/9tfRVAtqk9v+6cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XzDA9rHuiDi1d10uPd7ChXkD3gfEhoBY9/1yZJ9ZFBg=;
 b=H/pk4jHiIXPbOPOqyQ5efElPSyXknivC3eKqBf06rDwxxMXH6f8Hbmxri5VQxyLMKgav8B1/Q5e3pU/qLdmYBDkKKJqp7fTd1gw4+TPZOD/3V+g3W3b286ul+VdH485ggJwR5i7K/u14MEvystkyKlloH5Lpx7cFywpl2MJZvyCc9m1LnOLoKLgJqQdUo7GrcGr1m+Iz4lTZHCw55g5W4xIhjaI+7uu81GQn2nT8/BcyNzAFA9EpFzhMARwhsb/AjbKuvVVFmVbygdtQUwT0l3QNP+3VD57eIAhjXSrqlXAVPSuhRxb7LEloeDaRtkQGY4Sxgede03BL2+R4fG2BtA==
Received: from DM5PR05CA0024.namprd05.prod.outlook.com (2603:10b6:3:d4::34) by
 DM5PR12MB1388.namprd12.prod.outlook.com (2603:10b6:3:78::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Tue, 8 Mar 2022 10:11:50 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::e0) by DM5PR05CA0024.outlook.office365.com
 (2603:10b6:3:d4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.6 via Frontend
 Transport; Tue, 8 Mar 2022 10:11:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 10:11:50 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Mar
 2022 10:11:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Mar 2022
 02:11:48 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 8 Mar 2022 02:11:48 -0800
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
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
In-Reply-To: <20220307162207.188028559@linuxfoundation.org>
References: <20220307162207.188028559@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d501d50f-13d4-4a6b-b3d3-b126d4325caf@rnnvmail203.nvidia.com>
Date:   Tue, 8 Mar 2022 02:11:48 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec5fb7a0-a870-4dcc-55a5-08da00ec1000
X-MS-TrafficTypeDiagnostic: DM5PR12MB1388:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB13886B517A476B50309FB896D9099@DM5PR12MB1388.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iID0mRoXxG9yfpO4B6WdaRNNtHtBZMblW1XrnGTXxaMjf+HlrFY8mC9esgltl95w59wc38NIUAt68ltLBIGGJqb1/P5ErtJQvSspfttO4Q1kaEKJUJrlkaTv6p4YiDk044lx3g+MP5OrwfXQ68LQJDewLzqnBDarS5sD08Kc/FpkrZOIbS/ZaCRYnYuoB0BLw9MFaGXMIZ7yIUeN0ytdzxzahDibES3uZTxFpf++d8jFRK6h5OeHZXSfjZabCvGJ2QJJ6hXrjay8iB6tKg8duqa2iWLcNeynzn7draqC5FnLPNWuve3zdQddQuLMoot5AuoXzDy1W/jLNub8lXfK+j/jy9BoZfDhx1zIBF5QpD1TEYg2ovw/4qHMK2uGPQ09cLm8yY0ZqjdDXdFonYqb2lfM60iHvqY7doEhIpSUu03nXGFG/iuEDZBZm9BKmXVSdeCn26gmIzbXbHfuKbw/u8tmjs+xBm0fCjRPpHGc8rOWcUSIvkW9hQVkW+Ie/xWuwxDVUxHes3VFL4unyNfTo49ewuIgu3LSHQFFs+ilFwLYcXWQTsdgWHMEpeljZMw7Bgeu3E7akoFii9i8at6ArwKSXlZ1/lQ/B+JbXfwpKAPY6jTWxWkTtliWsqUpLcBe2Eg6pQa7c5kaf3UyWH1JUY7BDeODB5JUUeaRyFxL9B7UwZJVuEny+ks3+8RNtdbCLVl/FudBUwkyrHjqPhx1A6/pLZ+fA2SdYKV37l0zXl0rKmaAbXlKdm6Vrm2zjNldlzEZPYNEs74IJFiwTX7zwB+ajaoaAOyuktZwCGBUgco=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(31686004)(508600001)(86362001)(40460700003)(8936002)(47076005)(966005)(54906003)(6916009)(316002)(426003)(5660300002)(31696002)(8676002)(70586007)(4326008)(186003)(26005)(336012)(82310400004)(70206006)(7416002)(36860700001)(81166007)(356005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 10:11:50.5992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec5fb7a0-a870-4dcc-55a5-08da00ec1000
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1388
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 07 Mar 2022 17:28:50 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.27 release.
> There are 256 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 16:21:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.27-rc2.gz
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

Linux version:	5.15.27-rc2-g7b9aacd770fa
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
