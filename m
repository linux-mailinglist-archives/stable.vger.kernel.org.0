Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66758584174
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbiG1OfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbiG1Oeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:34:46 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2063.outbound.protection.outlook.com [40.107.96.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAEC73915;
        Thu, 28 Jul 2022 07:32:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSzL21OkFGhPT7SruwQ77oJfdLZEQGsEO5VuzWlwUH9rl6GM6keisN2KQ2hIfajVG00sv8d7OCmlUEJ+FEGym9XhwrK2rsDzMG306gLPkLjU5p390smU3oUKiStl4aGxFZcdyK+5F2UmZJMZjqF0BV8UABxggvxIi3ArTxiVVM40AQuNEYcCuXns7X0CC5McBNrMkEIbfER99vnzBOx4I6gFHyT9M5sT2ktSWwyeut5H9ej86z0NWsq9b2VboiZD3BWYqnsQBuEWahA/cal8fk70nn0g3YX4UDB38Ppji6OZhlJcrqOesO9ziel8q9ndV0wPvn4OvFPJaF9MbpuW+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UlNBHfGuFuk2eOvKukSa6szcUux3RAOU5itU+tOZg3Q=;
 b=VRD1HoaXtina6rfCUZpI49o0eXbSnrPFuJXD4UexP/R/KJcsJnhdX5PvNVwyQbuXnNCYIjrDCCmi38+b2QGN4jD4XwLKH3JjfP4CVbpkb16ha55A7KUEu/uusAR0mEC2yDV7HL3qgfiTNUYAzFJsK2U6XSnprsx2MB4t+tcQYT4U6XCouM/+jkytkJrSEFoRsTn2LKTGUAFw23eWYOkBKliLu6LkTbtyUPeVP9a4HL6KXOcQVQ5ZTzXO7RnmaFa/9kv7q1NHmqQpUr3HHP7MxlsmnqXfczzsY6x7/B6mHcK3DRB+0KRBvDMZ0sxExy3P2Q6oEO9EtGOma6WxhSpb3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UlNBHfGuFuk2eOvKukSa6szcUux3RAOU5itU+tOZg3Q=;
 b=tmTSO/+P3ZmJVGVudLDQKO/t2iqAP6DqOTUZufRudc+GHjofhOfZTau1fxD7oInsV1IHEFwGf1VJ/EqDm7m1XOILqGmJI9/HJIrQWHlsRBVerF7/f2NZ7+2VImm1M06EACUzwhIApSbC0ZZkDycPFRcoafrczYrYAMxdiXSD9RtOJcNWpScIrzr845P/Qw6cCBBsQceOSKic8PH8cIwKlbH0wpd506E3unPsuN+v/xH6/7mHrcasPArIw34C1eMI7EV/eKjBzuGuo/YNXDrWyREjeAyBF6N+boFO4US11Y/p+5KNkXFPTSWnfbqYRlaKOpXhBYpQB45FquNLsWb8IQ==
Received: from BN9PR03CA0375.namprd03.prod.outlook.com (2603:10b6:408:f7::20)
 by DM4PR12MB6328.namprd12.prod.outlook.com (2603:10b6:8:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Thu, 28 Jul
 2022 14:32:11 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::fc) by BN9PR03CA0375.outlook.office365.com
 (2603:10b6:408:f7::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.23 via Frontend
 Transport; Thu, 28 Jul 2022 14:32:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 14:32:10 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 28 Jul
 2022 14:32:10 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 28 Jul
 2022 07:32:10 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 07:32:09 -0700
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
Subject: Re: [PATCH 4.19 00/62] 4.19.254-rc1 review
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
References: <20220727161004.175638564@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1e0776ab-39f5-45fe-bbcf-df069459de9f@rnnvmail205.nvidia.com>
Date:   Thu, 28 Jul 2022 07:32:09 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c966496c-06f8-493b-ef12-08da70a5f52d
X-MS-TrafficTypeDiagnostic: DM4PR12MB6328:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FyWR5P48Gr4PtasV8sVhVp3/oMHC+rOrO9soREMX33toBy/mela65uSlokXivxTRe/gVm4VPakmVrLh2VrTtBUjHZW2Y6M5g1y8DY/7XufLBNjyr7/bKNVeTJPnNqAJpje5s9/mIos/Mw5yBrrfXAnI0JhwBeJhKdFfGEvXwBQ3hEsC8SQhaik7G0GZxeOKP1WWpQYcxcXHegIcMiQFLN4XVgF9jaSAfWEb5KPd6gvW+RQjOF60GAa+9z2m9+Lyeg0FYNv+z4S9Ar0kVEdHS2NkWd8odZxvLJycNyAfMc22WvgJqb1+Id2bzr/CvXwc6L5oBMOPCOm/GSNunvd0gsxYQA4v9PCkIVRJyBNtJa47o5E6I3lClv+JV4unZqu9rU6VBjg6AWFlDPXg8EhjlYoy7WgPY+Emgne73bsY2+7g4mec3yfwr1DaZfUESD3hCJWAqXHFSJCVdroUaXNeJF1plJ4wu6sMFouYRFmYjFzUHm7HV/MSJ/nqQCykYoiSNo2IOCPA6lWBB926NVyWKvs3XqsJmF53gaRXaDBvctINyxhVWiybwFzm3M5FRjEQGitm764VxbFCm1XtjmFkTEIGIVKaDA/1HrjKz6o2damQRn3rTjPBnBDw/mZ8jVqa5B46FiFd9xb3iKWkfCRehSQAuXBamxApKuFoMNBo9DYLTt1N+46wjnJKXVLRHmylvLVzNxKQ903Xg4X2xyDTjfy5wek97MmkKYdjmEWERMLBG4l1ZqX2ZN7GXlifuoaT2ikETNn5i5f2EytyTr65PYsE3AoshZqh+IK4myEGxUn4iqq5hGo9Kou0hZNUykENOH22llxv41PGFUsbaKcNs3HyWMl7WGRGggmM5Dm3FT7BaQ8agszLeRdkm/4EDBUHscS0ppufRQPaMlJRitiueY2Y7FE1enly1GrLvoGQFzPc=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(396003)(136003)(36840700001)(40470700004)(46966006)(40480700001)(31686004)(8676002)(8936002)(82310400005)(2906002)(70206006)(70586007)(4326008)(5660300002)(7416002)(31696002)(40460700003)(6916009)(316002)(54906003)(86362001)(26005)(966005)(336012)(47076005)(426003)(478600001)(41300700001)(356005)(81166007)(36860700001)(82740400003)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 14:32:10.9814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c966496c-06f8-493b-ef12-08da70a5f52d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6328
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Jul 2022 18:10:09 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.254 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.254-rc1.gz
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

Linux version:	4.19.254-rc1-gf68ffa0f9e2a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
