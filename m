Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE094AD372
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 09:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349407AbiBHIbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 03:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349386AbiBHIbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 03:31:13 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11EDC0401F6;
        Tue,  8 Feb 2022 00:31:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=acJQVp3nPtpNxAIO6H1e3dX/gQbNBI7RiIYZKdUZKhPG066P2jw16MY6Rq2JsXgLUF1WQJgamtt40ez74un7pVoMz1Y76qruoh8eghbYZd5kEmfRp1miDFcCmvNwWem1lhM892qSGMPEN+BlNzDa2jI4bMAMR9p5f4yP+29RZ9aeEk+obV68n6A5MXzZPhDJZrquvs+10g5LeZbZMOilQPq4JQcnXqOhgeyJ6zcSUvvQWcQwJ+4LFK0caE9hllUZTvVODDRaY62QeDvHS7bgNTmSMfAfELSt4k4k0XGWehB7dxPXetKRlMr9F18t3WNk5GS0TeTo4j9W7sh/2yk32w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sj0XFbRGc93owRj84gZAsKFQtoADb11MpAtJk1OKhq8=;
 b=XkpfhkTJDHgvGDwomsMzA2e0Szr6jxWYLHEu6SG+i4d+tVMb9JJsaEtXg4W+XLt9Oao/zawzsORycEKSsF0vYnhZxCuqkCCCSciuihDQFqQud5vh6cN7xXvKh4ayPAlxZlDWuKCCC5SFSd++61QtNd9ahAZltFy1JZCWnMo0OMSjmbstXn9QHsrybZsQB/lU7q0aa1Dt95IsEWWlXaQ8XEmWvy8gz3sCvDkPutSfrQLxqGBG7/BJ910EmMkbX0m3jAVdHU7ObYalrs/fJ/wcL9wTsbdrMsKbXJHTy5pXKgVF+nHd3aoOBs7m9fJU+EGuvon1f95RfwcdFCt2un3eQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sj0XFbRGc93owRj84gZAsKFQtoADb11MpAtJk1OKhq8=;
 b=pPEzDs2T4i4N9X6My75GBQmbCUvWkacj8lKg+zbq/myXAUpA7o1cZfZjQYfXNsLN0H0NAsOc7EBLu3VGga9PYf+du2PJ1bTMIyITAEO40gt1MxFUywyw5a/gWhVH+Qr+YjbRhtrMgoR5yclZn08MruyZCfK/kuaOpQCgAYg5FYe9JV71lE8ARk7pW+SLtR4/03OVMYk8cxmvVg+TgqBphxNdoiytPbASY1tq2vEgSroX9czEZ4ajXCpQ9MwxYhVqfeakxCCHAK01l1cgaelzpFezERQiv52VChWRTeI2+GJJ6LyJVhOMtJukskiItA8r8oMOvL2eR8+6Lu1ywS24Bw==
Received: from DM3PR12CA0059.namprd12.prod.outlook.com (2603:10b6:0:56::27) by
 CH2PR12MB4118.namprd12.prod.outlook.com (2603:10b6:610:a4::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Tue, 8 Feb 2022 08:31:11 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:56:cafe::be) by DM3PR12CA0059.outlook.office365.com
 (2603:10b6:0:56::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Tue, 8 Feb 2022 08:31:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Tue, 8 Feb 2022 08:31:11 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Feb
 2022 08:31:10 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Feb 2022
 00:31:09 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 8 Feb 2022 00:31:09 -0800
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
Subject: Re: [PATCH 4.14 00/69] 4.14.265-rc1 review
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <91f8b075-6755-4967-b118-bf173bae2498@rnnvmail202.nvidia.com>
Date:   Tue, 8 Feb 2022 00:31:09 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10903d44-f1cb-484f-9b0c-08d9eadd5ca6
X-MS-TrafficTypeDiagnostic: CH2PR12MB4118:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4118C5FE3BA495E0FC9312F6D92D9@CH2PR12MB4118.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x/YgTrvpT5acKaWBlGUTNYz5z6miv9lJ/Q6x9bRdQmUSHN6NARjLDFsets7XphNtnSYcYsJsGR9z309wDNIfYEaT8wRRiNVScJ3uUN5X5sDoD5dm8sQ8eSEjk+P6hY6AZMRLyEg2hMJKjS90CT57dpUBm6qq/kBXn4BNAoPR6TDQrU3wQZHlI9uBTyX99n3F6qPgEFvArzmKwT+sQ6aOqxRl7GLHgmSjEsLWe/uOjox7zzQn4jDl6ALUlF36iCBPu2EqNvHRlKieEU3geo0gb+IkJy1RfjPgkDu61djM7Nkgil8jFMH9IhlKtk5uTgVtuU0AfolEKqJNt1wcAdyOp33hlvPXJUoRGLqiVpaetmqRTUBVpOJpIFm76t1B+w33rfnPD2JEzDPPHgPlu7+FAzboKtkp65MUGJTekfgmNBeA+AEDO1WH6AH2iomkSGY4pcYIxUhNAB5B6yE9FlA5BJqKxJVsvmAyYvIECYlvQksYTUR8tUBWmyz60MCnyqALfIIHcAnTkTCieHlsSbRJZGgg2R2kqiLGCFdfo4eY+gmEjnjd57Tmg6S6sNS9wIvzw3inBq5hTVfNgHEo21fJuvehnOFbwcZcWpSKfX2TnHRFhd4+zrXlqrwiLgDiadRRHHtSuFLaeNwOI1wsLWU8gJCGnZD0JONCpoEId/DBvV6eR15chlmfZ/npa+snOI+pOmT/fzgZMPWeRHZI5kugDd5moSG+C22h7wfJszFxw/V55YU1ailxQefA++LXqwoInWY/j90Hsmq8SD7ogSWwnKZs5wf1Lu+laN/isPqypWg=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(31686004)(8676002)(4326008)(70206006)(70586007)(36860700001)(47076005)(8936002)(31696002)(6916009)(5660300002)(7416002)(86362001)(40460700003)(316002)(508600001)(54906003)(966005)(336012)(81166007)(356005)(186003)(26005)(82310400004)(2906002)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 08:31:11.1480
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10903d44-f1cb-484f-9b0c-08d9eadd5ca6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4118
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 07 Feb 2022 12:05:22 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.265 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.265-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.265-rc1-g1d3edcc1650d
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
