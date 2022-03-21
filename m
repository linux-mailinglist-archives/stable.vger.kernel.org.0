Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BE64E30A1
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 20:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352506AbiCUTSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 15:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244022AbiCUTSa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 15:18:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0B2171797;
        Mon, 21 Mar 2022 12:17:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gq1p17X58t804vMTA2BzEasN+uF/I+J2UavlBH9obQmVpfd8t6uuVn5YA64SgaMg2hQ9u2Hq4QPnfNz+T+FPtC8jwH3+05tiwbRKeNqyAy42Q7mebYJgfdbjEpvtVfCDTbruIaBYYG8GGqOcqRJaS98k9WYTldt/5tMo8qxvW/8GVfag5g5ISeDWZ6BXLVo0tQ6mgm3Aa6xHuTuHnuoBe39l1mQ04smVCpLWOSefZ+kIi08ZCeAvtMt3LtK7PjOtiPIzdkx+FeqF+Y8LVo6RPfyN2TyDfqK46H1gfJGNR+93uKHzQLC0PPCo9AbIqFbFokrKRpw8Vo+hESCcRIk/WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lGIsVbmO3fRm3xR3Nnt673WQW8TB+8+xM1vQbjgKGdg=;
 b=KoPhstog5/GZCftGJ6aX9gUVYfwkcVdsJJptFRSs8NMZMpGRdGnFtpoBxszhSQg59/gj6T9IAAq3ShwJBn3mGS6MbOzEDZk9vVQFfpe+kllhel4N8U0mmouyFouiRrMROFmYTvGIOhIbbQ9OAxwBYBtt61I3jf42zxNmkPImPJ7tOj10R/HXu6bbz5B5FHSIL/62kZBzC1iZDRFtcCm8SRYiudhZH4Y6NiZ6rnYs0FPLlkxbhl/spXGg4++jUkiZc/1uGKhrkegCCWiL/WU2hiPV+SlJl5+PikAWJOoXNbIUpqb1i45h7HOobMQgcgJgP18U4aEPfQnD4ry+YLnciw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lGIsVbmO3fRm3xR3Nnt673WQW8TB+8+xM1vQbjgKGdg=;
 b=bpsIFGod2XqsWzy3bd6Y71fh2X3bPAruXKu/4PZzYAaSVjHFWL5Hnla9+0KMWf1H/Jwm3m6YE2gqzPU1DH/LhHuGtDDstMlAr+Cc8Y8VS+20LXk+WdfVD9NEXwSWh0qw/JnOQGMrtZFSyihQxwSUp3xdnUPI+GGnbr001DksM7cVpDWEMbMbd/SwayN73octhyOndV10NAoJd0gGeI7fks+ovTb+0qNEYiatIb2bMgxAnSEa6KOHz3PZz3KAeqC00VEh6dNwDKd+Dpr2wUw6mUrT1wy0Ot/6tLpBNoZAeYykSRhpL6em4/gtq/Jys6+3RUn6XVTH9amcqFVGitqLDg==
Received: from MWHPR19CA0088.namprd19.prod.outlook.com (2603:10b6:320:1f::26)
 by BN8PR12MB3507.namprd12.prod.outlook.com (2603:10b6:408:6e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Mon, 21 Mar
 2022 19:16:59 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:1f:cafe::7d) by MWHPR19CA0088.outlook.office365.com
 (2603:10b6:320:1f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22 via Frontend
 Transport; Mon, 21 Mar 2022 19:16:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5081.14 via Frontend Transport; Mon, 21 Mar 2022 19:16:59 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 21 Mar
 2022 19:16:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 21 Mar
 2022 12:16:58 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 21 Mar 2022 12:16:57 -0700
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
Subject: Re: [PATCH 5.16 00/37] 5.16.17-rc1 review
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
References: <20220321133221.290173884@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <370678b7-9d95-4bfc-a595-359df1c2ff4f@rnnvmail201.nvidia.com>
Date:   Mon, 21 Mar 2022 12:16:57 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00167b4d-32d6-4dc9-2d48-08da0b6f5f53
X-MS-TrafficTypeDiagnostic: BN8PR12MB3507:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3507F28BE2CE1426373A94DDD9169@BN8PR12MB3507.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KXbGUIJFYI8dH2lzX7XW2MfYW5+wCrU/7lzItoUsWWyidVWzyzIGrgB0uwOgS3ZIC7mEQ0RWvJzqaywFjzhOYJhpc4Jt4esriwbycUw9E0Wcfix+1d0LmCegXcGKUq3nhpWrlOxEukb0DOWMFLFioQoW5Yv9g2hy0oa6V/KRtDsAFwXcanvr6yj2h/46tuqX9SkxI7HBQ3zRjqbehzTEYKWupfdcra2hJrO9RecO3RgybV3Ajo9OtoeIPXXjop/LKIqg7OlI/et4Ta03eOvgSrO2SNlio4S8fMgXjHI9jKJ75+PGxCt6nV6mXxHo73W0k+OHbfKxLLK5p7Mp/RgGNJGXA22SCqbK30eBArbcE/LQiueSr/yutG+w3z7UZNld7dqAlLl6sRbfp93FBfmmc65/V8+F+1/KoSPI+aCuJKdTmsg0zNseJ68YPpLhX3TJ1V1/6BZ+gRB/JOXEuMl21a0Ztn0KBZlvUdvGmg+kfmSlN+L8x3uGOhIQFXdBO+DMBy8NwbLeN9Rm1Lr+58VlsPBrXIIk+OXsK1zi8tyEHIl22XJfsSsOOeHWATWo1U5paj2zqGCnw5nSW4+d/IGBfij6FfO9j5YUlt5qPWitYFsVJZhIaTVN74dJL3Z/vDdT2DF43Rd5zL0VGBPmOnALvu/guCoBYk5Ze/OkqRNrEoqdJnj5stO/fySO2SneR8OYW+aIu2vRpRBsWcH3QC+FjpjoKE1bx9gJXvZvLHotnrBALw47S/ZGR8aAbOa85VAGjstsiIT9AVbvI389c2rpd4IVBw8M/gVVNUHiPxdc7G4=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(336012)(426003)(81166007)(70586007)(4326008)(2906002)(70206006)(7416002)(47076005)(26005)(186003)(8936002)(82310400004)(508600001)(966005)(5660300002)(36860700001)(86362001)(40460700003)(31696002)(8676002)(31686004)(54906003)(356005)(6916009)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 19:16:59.3814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00167b4d-32d6-4dc9-2d48-08da0b6f5f53
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3507
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Mar 2022 14:52:42 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.17 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.17-rc1.gz
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

Linux version:	5.16.17-rc1-g578d4cc6b157
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
