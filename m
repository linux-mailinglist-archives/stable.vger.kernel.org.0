Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04D8529B41
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 09:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241648AbiEQHmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 03:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242881AbiEQHlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 03:41:50 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2075.outbound.protection.outlook.com [40.107.100.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46FB1C1;
        Tue, 17 May 2022 00:41:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvLeoFhvrfCsyi0zJ9NJk+7j3m7k+PYCJlYFED6P2iLForuU+BtJF96jdJqXV8huWepETmBWfDtVzVCO77N+uqn1gHkXV5H5o3XX6K64sIw0WHHJ1P3zTPFJx8FxWVbivQxmIKRlv6hJX4xNP+WtqtxOQNtNaKdapaBioEZqA/RHk0AjgECXsqeUHhlVSnB6pN0m76hSmA7mr7nWPcX8pE8l3MyWYfT3rx7AGBYSJ0gB9r4XCLDZWwGqJ6fwlVIISlcCUDem5jYT8YN71MmCWfjzDFq4XXhovw+xnr+1XbWQGMvIfYT/E2Q8Rg7ubVU7iu1eLASkcoSIhC/EnTtFJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRFwHJxz5gZvYU6VwsBHAST5Al2IzlWTwG5ZYkkrbFg=;
 b=dzWD8Rrf+cj87aX2d8W8utO4CPb4wquHtGS0nTYL+ILcZt93pkvdHNI3w2Fq6qwtnjceoQj9gMspvpug/p/IGEiU53TX3fiCfgSNjBP09nDHZSzzBUHT+dpwVqZP7eu1PSJS7se606IQyvf4iom68jBBUM3pZPNolaiI8GR2bYrkDuz14f/0QdF09et4+xxsqtx39U7GL7LB8EKOInuucJRHX7unnomx16S/QJHqRsDO9re8jWaz/R0AWSJzHSA3gAL5Typ1Cj+pkgx3WRvP1VedUCXXNka/4/2S5cbmAV7gc98kbiZWSUZbD41k6YtN3Qf7vigOAqC0TGB6FlGeug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRFwHJxz5gZvYU6VwsBHAST5Al2IzlWTwG5ZYkkrbFg=;
 b=rcd7vaTujT0EflU9FpPKKGNqIhT3II8009WJGUmbsM6w957Ayu4UC4y9hb5dW58xLrV0alK3LYkQv48HDuJNfMSLB2ZCe/Sk83jTuOiC7GY8X/BixWgNwOKNlZ75cegRi0KwM4KAgYwDnlEy50V/sn1Rv4XMyZdiIXgXwYJTW4WYcpCHspBCEdgrN6/aACevwrFYxA7He3BBOEMAufpMPERB4ftNOZoul+JqIRosbJg3JRY++M081zkH9XlPB6XRhNi1fSom4NjBUSpu7ZzliPcmqYN5gfOwegnRDhWI3LkWGGphEodrpo3kvJ8jBfxKisY/IEXNO6NIp3VT5S8p8A==
Received: from MW4PR04CA0288.namprd04.prod.outlook.com (2603:10b6:303:89::23)
 by DM5PR1201MB0106.namprd12.prod.outlook.com (2603:10b6:4:4f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.17; Tue, 17 May
 2022 07:41:47 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::f7) by MW4PR04CA0288.outlook.office365.com
 (2603:10b6:303:89::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.15 via Frontend
 Transport; Tue, 17 May 2022 07:41:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 07:41:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 17 May
 2022 07:41:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 17 May
 2022 00:41:45 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 17 May 2022 00:41:45 -0700
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
Subject: Re: [PATCH 5.15 000/102] 5.15.41-rc1 review
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <09254f41-17a0-4b89-a653-0161251b31a2@rnnvmail201.nvidia.com>
Date:   Tue, 17 May 2022 00:41:45 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13f85377-9f24-40ad-b890-08da37d8b241
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0106:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB010605FA34B1499701CBEB3FD9CE9@DM5PR1201MB0106.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nmTveRZ3Y3yYEtm9WVIPE4rtHAcCvtzhbB+IX2WkQW6zP2Gw+A4FnLQEBfU+LYjVXSP3WSLjQ5otG/U1bXy7crYVuV3pc3gGeesm8HgdNy3PxyFKnkX4m5TVikLaTIbYY3Jd5kiFYRXEXAs9cpLOFH75/Jl73knEh0M8leAoBYqKDEt/w/Hdi2Rw/NdZUCetcVmxM0hEdQkvC8WPrZ8sdZV2VkEgu6FUFGov5I3WJabLVklnS5J8UhM9qr2d68DM4Q8gJB+15p5ULWrZ27Fdp+pATPeEfny1UcTKvfuES8YoZeR17vHLrbiQ9w2wwVbrVdhxdr4PdCKFoTlZdgdeTNJAMI27WZd5kFBFfyFgDuETqmlV7voBNi0Na4AjUWz0zPuPz5Pz9YCoYJP5fs+6g+zzHKX4ITktCaV+JFEP2HOJaSU9AvHXHnletpmLHeBzPeSpjHh6ThkNPGsXH0tKwtyq3ktgTTr6jRvqoRx1jHKyuIBC2+cT+CEnaPgrQYO8f4iYkRQzOt9LVgLwm/QQREbqwHEZeShusQtXtlXMGZvbyoUxsbc2rhVsLdGEmOAAoguUpQ3ND4Jh+5fj3Upb8waDd6N7F3hSCqXMY2iy4MYG+MVn2RCAd3Ws5w0JTnQHmlqCc8YcRKjUEuz0b3yhoUsb2p66wNvYO4VTS4qRd5QRXRyuFozu0EI8qJBQ1htaYI9/ZeB0sMWuLRqgnVltUIMhkoFo7FYcaMlu3At8Xj+d6sEl3WJ9ei8DSJ/A3USNpvhMb0Av2xF8RIChgdN/ZYJjUmctW8xx2lkk1yXFbwxzqNP1vim131mGtBt/+E2rMnP/LaAqntLLhKQtAoClWA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(966005)(508600001)(40460700003)(8936002)(26005)(31696002)(7416002)(356005)(316002)(86362001)(47076005)(54906003)(36860700001)(6916009)(81166007)(4326008)(8676002)(70206006)(70586007)(2906002)(31686004)(5660300002)(336012)(186003)(426003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 07:41:46.8367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13f85377-9f24-40ad-b890-08da37d8b241
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0106
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 16 May 2022 21:35:34 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.41 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.41-rc1.gz
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

Linux version:	5.15.41-rc1-g4aa8770e7dfc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
