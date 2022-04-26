Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5227E51032C
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 18:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352938AbiDZQXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 12:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352944AbiDZQXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 12:23:49 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A87FCFB89;
        Tue, 26 Apr 2022 09:20:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLpfklqt8s9sRA8Gn30LVFA8a3v3R8TsVm8gO4Gy0LzMjGfg2R4eY9JPGjroOttPU1rYw/9JU34/o6+LYs2mWFGarAWxNDvh4WwQHaTT6VAR9iSBPy55Uw3KxmA8aBYmcmKmg5JJSl04V1jbC5a4mVlnLHECTMd8oGhtqW4QDa+P6GCVqLguC/WeeIiAG/3zESevbk07sA76JviQxTopvEPsROoWerbfGW0bIawwnKXPeAiI8dUZF/4blEF1H38rU8Il+9KzgG6D637rCCj+JA/NdZSe74GxavNuZRzdUASgswIdPGzcaGUqkUazsMNYQMrPofERyLOhwjlKGSMARQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3SYNT3Ls6DkOmTpOnFc0pOq20T+pQMGDb03+BF7wmLQ=;
 b=R0SAiRsDXVfpv0I4YOLrPR5vmEFKaaNdkVhDNmQdcNyKaGEmbIQuNH5xGjSdKT0rAgKIuDzDJFpik3qwxUG/9tB9NombvxOGcCGCaCZtb6qsjuHvH0D6RQ/YxoODytIGuKCbnI0UKYS32vX6UvGFlctbZpa55izCSCr4I+MdkstFesHrIGNi2zNVAjuHSC0fWS9Z9Nov/UuEdyjn5DTMvPOFfhR4BUO9yKRBT1OAOrdE9fx1kRt+mUzQ8trt9ZdlyRKNjm/wU+Q3W+lmuYi+jQtOHT1PwYdZ+lP8XdH08fkjAKtJ5pDyX25GB3nFJqvf/U7cOIPJQRZano/em6SVqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SYNT3Ls6DkOmTpOnFc0pOq20T+pQMGDb03+BF7wmLQ=;
 b=XpUZavW8/VEY73Nb1eHQqAd5b5yIfl8RUYoebQX4uQ34APzo4t4BlWsUcPSFnbxu4cz4a0/x+VMZR31Idap8ongefXCLQYvX6eyBe2ZAcVhqa/afgx5aUNUR29Iwp5xsKvClWzSdXHo+hJ5rk9YkYwdgzNfU/G9bpm1UrpheESVbZHdj5Mph8hTPs+JQ73/ZWLsJvyk20TV6cmwkZM3ImVvSWP+8up90T3m3tkKjry/CG1vDKKlucRy7MU+PtuqiC9NRmkNBTujne9wgEKEcQaauzAbS4Rzk95OOkcMmSD8N34IuNbiQCI/D3SppozRPTOV2k8b/bmfM3fUeQdnvkg==
Received: from MW4P221CA0002.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::7) by
 MWHPR1201MB2492.namprd12.prod.outlook.com (2603:10b6:300:e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Tue, 26 Apr
 2022 16:20:36 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::e7) by MW4P221CA0002.outlook.office365.com
 (2603:10b6:303:8b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Tue, 26 Apr 2022 16:20:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Tue, 26 Apr 2022 16:20:36 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 26 Apr
 2022 16:20:35 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 26 Apr
 2022 09:20:34 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 26 Apr 2022 09:20:34 -0700
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
Subject: Re: [PATCH 5.4 00/62] 5.4.191-rc1 review
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
References: <20220426081737.209637816@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8be9ef52-6ac2-46ae-8132-0f80415f7049@rnnvmail204.nvidia.com>
Date:   Tue, 26 Apr 2022 09:20:34 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06fd3d4a-ffca-43e5-57cf-08da27a0b27c
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2492:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB249252EABA525A04632FC303D9FB9@MWHPR1201MB2492.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hx/W+jAcBiCIdl4b/xLV34qMNR/8E+DJxJzF6UaBTcsz9k5kDUti+qUWwvfML43AAXxOrp008Wef5+VY8aNUlO/OcRlqPdtYotZvcC628mmM72TNH83LFFgOq/AgoKoKhK3x3RrGlPV3m6DyyqrEFkyrUUng6xPBLSDbLZaBk5XtoApuQcoCll0isc7uqEDhe3kBuonzZOhzAYN7CsfoWigc7kBCtbc5knIoNHq2D5egdMb2CN6W72tsp+jPgQwAItZ1Zs1mXeC5TdLuRu6hbswytnwgRbrGBfkiXAWOuf8qrSQPwHgZvmoyaZKiEH3KZij4pBcn0HDgL0bz1jnh0Lu9SpXQaBKvuL0GI4dW73UibqokNvrR+EgFnJ1DRnB8XeHFbJbqlfSRhIiEJTGeOKqaSo1hr6ZyNQ+sDjA7aqPekzM0FwkzMu5og3+7YjWZD3lcokYsCDD1kVo2n/SZ2fRJKuj35jT5DkJqzyGVOLI7+9mRV78oSaI+JNWzAcch397u/YW4XQWsP2VQQXZ4gyfoajnhZnsx/iWAg2uItBPau0A2tJZ2yjS615n9zfQxhTyyh72/LQCthCNTcQyD8vLUUqfomEojzjB1dPDMG0hbrRa8khqXtdABCoXYmcpx0tY1Omte0d8Kric5sppPLhZ7kPXuzEoxS7NeL82qM2V+ew6D6RBKIKUoeHHJePZne1wrZDPVK1bljLhbq8+/o+JhICkCwTVcaSB975OSOe2RfYRFUQEbiWOUX/bhG9hkmtpGqsGC9VxvgR+b4hh4jGpw2c+is24IIK3YIQ3u90g=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(356005)(2906002)(70586007)(70206006)(81166007)(31696002)(82310400005)(6916009)(7416002)(54906003)(36860700001)(4326008)(8676002)(26005)(86362001)(40460700003)(966005)(31686004)(8936002)(47076005)(508600001)(186003)(5660300002)(336012)(316002)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 16:20:36.7996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06fd3d4a-ffca-43e5-57cf-08da27a0b27c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2492
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Apr 2022 10:20:40 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.191 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.191-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.191-rc1-ga511897e8ed5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
