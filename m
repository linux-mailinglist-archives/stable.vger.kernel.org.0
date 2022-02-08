Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFDD4AD377
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 09:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345508AbiBHIbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 03:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349386AbiBHIbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 03:31:00 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2085.outbound.protection.outlook.com [40.107.101.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CA9C03FEC0;
        Tue,  8 Feb 2022 00:30:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqdF0RBH1PAA4DidnFripELv07+D8u7NmXrDdnt3UaDJ/ly0oeCCllJzbgTWNYp4JeGRwIcM2V8NjjnMxlRae8EtBVagt+ItbQb/MdEM5kcM+9TNg9jXP86fby/15Q+71K1ZkeEqAj+fwfD/JYn1+R4Ez7NUzCdNQUKo5upkUqpbF8RZSl1dFipe3LtTgAjSjvIUEp8rZNoc6Hb5tryuyXCTz+l3r4oCdKBl4TmCvCNZq3sZgorQuV88ULiH8zB8gYhvExSq3kNaQmrqiebSRvjR6ThcRKgP/9jBzCGrl6H69UOmyzr/1qpk39S68qESox5PxN+EN6Yg50iO4Ojs3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YaG4F4Nks4p9qup2EtxPPRVclOYxAZy55Lhc09xKh1w=;
 b=gdHmQY3pGBUWUPfdswZsutY/XYzmVtFxfHdjI0zZ8NzCYaDEyIFuC2Pgh6LKCx4KesNcbKkXV8nA24MvQSz7zQ0ve/U8uTgdKGxnl/d8y8Lssc3XfNSnFB3W/sDuKozXZRxCbiA3qxrSGmwatIfUoLNyMAk/j2bMfnsn85ZRL5US49Gdwox+81zNhlpCsZBhSssBxVkr69IUpQ4c1kse9GzHCOHaDBnbnyqBqIRthAZXhGMU3DsSPrdcUkfKHeI9BrWvgN6jJNPody9jl/7bLkyKP7weOrheA/b6pCSKiQUStFL6QUF0Fl2r6K2UrpgmVc1iFTmaXkLeOfy+mlg+ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YaG4F4Nks4p9qup2EtxPPRVclOYxAZy55Lhc09xKh1w=;
 b=Spr0JartlvPmarM9ziYmT0Gur00fKZCAup0Abefa9qM+PTSo9m333yJcWsa9bLjU5ZexI+uXzkER49BnirQPimrbkkhyKE0ckDQfpNnvexEIWYtRIwJ6c3o2xSzWJV3BdTBzIlMuI4M1joPG402CGY1O6IVpyo2W8oO6IxcRdWjVFPlufomYMBRT2VhWcLpfNSsDXSi8HXtxDMYztSWCsMQ2s4796dDHIyL77qZWVamwErHIJuZqPM6TAusjYeRB1ghwbFp3tyG/uzIGukY0WWoyHSVYP1AzqzeGM6xvMCihobhcK8qlqF2H+lQUnjePNN60NT9X1qP3XkimCXIVag==
Received: from DM6PR02CA0044.namprd02.prod.outlook.com (2603:10b6:5:177::21)
 by DM6PR12MB3514.namprd12.prod.outlook.com (2603:10b6:5:183::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Tue, 8 Feb
 2022 08:30:58 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::43) by DM6PR02CA0044.outlook.office365.com
 (2603:10b6:5:177::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Tue, 8 Feb 2022 08:30:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Tue, 8 Feb 2022 08:30:58 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Feb
 2022 08:30:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Feb 2022
 00:30:56 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 8 Feb 2022 00:30:56 -0800
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
Subject: Re: [PATCH 5.10 00/74] 5.10.99-rc1 review
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4f171658-0647-43e2-9adf-f29662fe3f11@rnnvmail201.nvidia.com>
Date:   Tue, 8 Feb 2022 00:30:56 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d4ed810-77da-45b1-d70a-08d9eadd54e7
X-MS-TrafficTypeDiagnostic: DM6PR12MB3514:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB351450C6351E19EC33030D48D92D9@DM6PR12MB3514.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sJhyklA7LNP/fRsoFslmuKqh7sc9r5GRadyQibScv6Hwdh5i7A72ju27Dta3/x6VvUlJ/1JerbpCvpSllYPh5tliXBREcKUunJB1mtOTatyXs3fH6OE4TRolOYF7ZeuBKlzUD5Vqdq9d/gByn38H6D9Iib7F2hkaAoY9pntlBv+aspcYyX7dEa/+JdRS8bd1X7D5Yp3CUL+l+1iUSbw7kj/fDPNeLQwubsesCbafrxS8l81dOHVhsvQgT7cmyIaQjtQP7rZ5nOiGvcUgml90F+4fjZRkjqDRTu8pvzk1GE05EQ6KOIPoT9jdJ+S9UUwAJLvwqnVvJwmQwfmfzXsoFvg0R5SJZWs2mYib26CJ2FjkuNbUnnng6bojjrSNCvBnGJE0OsnC3u1wM1ly03dLXHku5UwCzW8SrwNywKuZtXYgHc8wcJbXiuc15cvAp+eHZ/s4x0gSl3tQhrtxgLy26FnycXngw6SnssuqGrcrMKhvgsPqXc1f6uMPRyIPFupG0Z2k+S2vxjJwPQ6JDhxDxhZBH0UZa2XGKQpHYAczHhszCj6k249f9K4QiP3XpX4vTLJJUOEvVRvTpNhjQ0ypoYapGk8iCsKCyfXMTeFT/vnv4kf8kLBRrSVwCXyO+7dvGpSVqTgCr24wXEvnSwcf0rRqjuy3zqmudz9TNL1LzhD3JZ9+YXlwAqG7iUrjFZXNmZUCiG340dxmoenk2ykp4R5zkf0rpdH93u2pP0PxbLc3rf+Q5GuSuh2EHX1kZxTM9PigbbxSDnSpFwRlb7O4+MVLk9AnBnZxmkgpVtZIObQ=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(86362001)(316002)(31696002)(4326008)(2906002)(6916009)(966005)(508600001)(82310400004)(54906003)(7416002)(70206006)(31686004)(36860700001)(5660300002)(81166007)(40460700003)(8936002)(47076005)(336012)(426003)(26005)(8676002)(70586007)(186003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 08:30:58.1381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d4ed810-77da-45b1-d70a-08d9eadd54e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3514
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 07 Feb 2022 12:05:58 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.99 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.99-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.99-rc1-g9f5cb871ceb9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
