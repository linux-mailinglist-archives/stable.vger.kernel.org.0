Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827FD4B087C
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 09:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237468AbiBJIeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 03:34:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237598AbiBJIeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 03:34:11 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2072.outbound.protection.outlook.com [40.107.212.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4787E4F;
        Thu, 10 Feb 2022 00:34:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDSzBVlVt3sbfk9AeC3ja41h8Q4YmqctJKtr2WJ0piTRj3XOyjhh1ypvG977UfMqtD9lkmvJNT5IJZdkkzNg4kNHdDi9rXCvABJAjtL/nvalww/RQhEuWfk/IagKkmoVdli8/96Beq5ueaFQyh0kb6RFhJWaVDCfD4CLU5fx6LljCBiLubjnwdF8lztvq1tSwuJmaP81mVOhVTn1Ku4Y9Vz9m8HIqTJpoAx2CNn23p0Z51K9VIsTsdimUdz350vVfUZ1U4y4fm2f9IO61rUFnSw4BTyzDlXHgSh7w5LiO26XOuRvPjyjx+BwB+rDI+rRfY4fUUWIZwRWGTQXgObSOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r75pUfgE4iXaT9etV5rVav0w5bzYJzGD+8z98tTebXU=;
 b=l/FOETnwEfH5RBP9Jtp/22X+i0DsT2q1w8chSBfd9dvsH7SRsGZWUiFkvrEtMRD1rmOPwP9Icc40m++NCdVeTx2iZ+g2MVXjnlWbQPmQ2uhVlZ9W8xTti7EHdi1ocxjHlXzhvpNcLUFehPRS6quGB3ouBG9gZODjcd2EhrmHBK9TfmVZWH1BHFbzQqOuUEHufzndh/cz2LEVAphp2Aw41mqudMlwC1zqss8Bg2+8ulFE4xfuWa5gZ0W3pfOnRKkvEzThxqyToC8JbVJFTqK/vBEdGvx+XV0eTLfB9J5N69u5iZ+eFGHUfIhVFigCQ5bxmzbc58Raz08Yh1aNJiK35Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r75pUfgE4iXaT9etV5rVav0w5bzYJzGD+8z98tTebXU=;
 b=iwApzfbhHSe3AHTlZUtupY0il5GHxn61Uc69qandKWSxY3sUprSTPM7xK8SKQDQKDX/HEaaFvaPKTu5zgp1X2YYE6xpxy5QRRK/kLVLlyzHZX/Ra3C+DAoZCtDhQ6/rbH5ts4SMCtEdvv5/ZC26kQbQe0gElNyCS9PpOp6Sq/E7L9pw41bONeIFahXb7lKgj0wrM6BdLSlQ8BuZ32UZcgB7EAehyyPKuQeE9P2Q5SquJkIeuruSl0zUz2WmF2W1yjsuG0c2J/QI4lEFp6E2uKDrR5TkGapfdYuo/v/zoY8UMnffBrL50ea381kASTD9C4k/nEbD7JFDSh3qcE89ioA==
Received: from DM6PR14CA0046.namprd14.prod.outlook.com (2603:10b6:5:18f::23)
 by BYAPR12MB2775.namprd12.prod.outlook.com (2603:10b6:a03:6b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 08:34:09 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::bb) by DM6PR14CA0046.outlook.office365.com
 (2603:10b6:5:18f::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14 via Frontend
 Transport; Thu, 10 Feb 2022 08:34:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 08:34:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 08:34:06 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 10 Feb 2022
 00:34:05 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Thu, 10 Feb 2022 00:34:05 -0800
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
Subject: Re: [PATCH 5.16 0/5] 5.16.9-rc1 review
In-Reply-To: <20220209191249.887150036@linuxfoundation.org>
References: <20220209191249.887150036@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7dfac03a-31c7-4f23-821e-bc4ff9235295@rnnvmail203.nvidia.com>
Date:   Thu, 10 Feb 2022 00:34:05 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4793ce4e-00f4-40af-65a4-08d9ec701b6b
X-MS-TrafficTypeDiagnostic: BYAPR12MB2775:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB277586811ABB807B5A866037D92F9@BYAPR12MB2775.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5cvE87wLkPNBOB2ce3gQLSnBZXlHPKxMG0jto3+XvQXG3ICEB/tQ4FzjTqDsUSNFj0waDbnVuSbGI1tC5jqw6LAunTOQFCKyriClazyFNooZx95UWdZxEcV9vYSnEnNSCAGMedh/8JckUbPfIlm43/jBuO6dLxVfVHLPP/C2ZNikVWGzorgOykk2B7KYBiFHQJ6f/i5J4NDEb7spkbcoLcS2a/si/ZgMZ/7W/7nMKpMk1V7RS0LnckHSfgC6d55bcHCb3sfpuNVu5dhIcSIIQ8QfHOCoo1ZlQcNZZhw3kIoKqshWTXtqUQRGL9NgTamFxAMR66Hl3X0Cvn82Tqjm+TF7+VKTK08itATYKSLe1ImZbgdVLeYGWCzXgT75R1Wh1KyUXlKC15hR3T3q5Jujn2hnHZvAlMCxX6/VJ/TJ6KChmT8IYy6SMb4uNbLfKf8aVsJdOqzzfpLXnOCFQDmLlM3yNv8zAKacvWtMry+U8oxv2hGbPUPbvywyhGVGTwUBjB57aWkJzii4hh/GDBf+xVKODg/4hKwS4s1988Kgm2nBRCTVn7HJV2eE+VxERd2BqbgQSQp5cAwjv4LhH1xomG4XncLVrDx5KclAllVWitm6dtS0aMacg6/GJLWr/HBwdAbTAs6N3zYgfXfKIM3I63WzlxAUPs7Mdr/MShGpwZY7a+qOkvfE02D6eVcc7qFGcFn/kKN7zQClBJ14AwcALtEnlrlQS6nNOFRq4oOMq0LpuMJKQsSdohd8O5fkCqxye6t7XgrYr0jpdlvOPf5VI8DL7Olx11U77N22+KsdKys=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(4326008)(8936002)(31686004)(8676002)(70206006)(70586007)(36860700001)(186003)(426003)(336012)(26005)(316002)(6916009)(7416002)(54906003)(5660300002)(2906002)(81166007)(40460700003)(966005)(356005)(86362001)(508600001)(31696002)(82310400004)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 08:34:08.8901
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4793ce4e-00f4-40af-65a4-08d9ec701b6b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2775
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 09 Feb 2022 20:14:32 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.9 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.9-rc1.gz
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

Linux version:	5.16.9-rc1-gddf6ceb4eefb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
