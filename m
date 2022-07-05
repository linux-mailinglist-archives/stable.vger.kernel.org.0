Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B748556713D
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 16:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbiGEOgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 10:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbiGEOf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 10:35:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20616.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::616])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD876143;
        Tue,  5 Jul 2022 07:35:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6h4kJdgpVP1T9R0F/ZK9/XrmPTpYN1TugNnoiMSQ9SLTuki4b2VazsbYGKihgHJXKAzzKGuZhsMpRCaJy4QMXSFjEhnqjPe+gms1uTH6yWHkvGd9Yiu6gKiZW9d9gAJHr3t4OP3+Uj4XNEkPKqBa6ePQwLS/Dh6W2F78uaHcxqbP7KtyUd9at0O0uI6VHpmkXrDQpYIvAXqDNTMBM2a88F5bao85D31HeG7AaMxbflwZ/NAADbMyYsz+2lQupE5HvpeTdHkoqiU3tJtAPHX2E0YPZFFtYExGdhcr5hsS/IBT9HoLgZQFenHuSthCMD5iTZVmfpC1mys0XR0H450bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lrVVxzXkbQWcx2tUA6nexk3uZqq7absbgYSYd0smZnY=;
 b=ZF/GgLGF1C4QnebAovTAbSDaGkLBE7m/dlri2QBI6AVD+9XImFSW+7KlNbdILjPZJB+Ak6cBxvWnSgqEEmMY8ZldxUde6Z5n/4+JuPKo6jsnaG4muUR6R/bDuKhIMHJ9NutdpvRDPS5lL1HJm5im0wlkr4xBR7G/vzn5SYHez7RU6+PK+TJ+rTqNGLjlYuRtpPzahBTjiT3Ij7an3Velii0tKhMTIrLyKVu7kt/aV2DmXJny6Y2Uk3ADoSV9YiFozBNO2QKGHS8oogWYJVk0+e9mtnhS/qaWEA/orsOFw88ImB6gsU0ee/iJTb3pdBvC3+iIRaTEjwhmh/mI5lZSWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrVVxzXkbQWcx2tUA6nexk3uZqq7absbgYSYd0smZnY=;
 b=TXuC0xVunJhjvlZ88eb+/JUkrnU9FD+E/KDnv66cgHe8SzyWfG5MlzIJ5A22JaMY5EHVd/RZAq0dkvVwJKUT7ksKrveexdjDK98Y7QXgkt5ykYZve4oIhUkQGTDpqSHFFBGxCvN9Ob2+CUl95lBeIDZyO/8hcYe+Lbjl0BfGT2f7u6D30gx88lRyu5Od2DDxoAudU87ZHfzLbCPkq7V3bxIsARyVT7ruJHhocEVYyTc/1T1Q7Cg5citSxbBCS0jW1Gk95Do6qKGut88hg09MARoB//K+Itfj9dIjxla79eFUmupKb2hL4qLDBm0nrohHghql1uDxgPS4TEi3l/qRjQ==
Received: from DS7PR06CA0034.namprd06.prod.outlook.com (2603:10b6:8:54::18) by
 SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.14; Tue, 5 Jul 2022 14:35:55 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::b9) by DS7PR06CA0034.outlook.office365.com
 (2603:10b6:8:54::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Tue, 5 Jul 2022 14:35:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 14:35:54 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 5 Jul
 2022 14:35:52 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 5 Jul 2022
 07:35:51 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 07:35:50 -0700
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
Subject: Re: [PATCH 5.10 00/84] 5.10.129-rc1 review
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a7e55568-1fcb-43ae-93bb-24b091ec7de5@rnnvmail205.nvidia.com>
Date:   Tue, 5 Jul 2022 07:35:50 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd693242-8d38-4813-61dc-08da5e93ab1b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4510:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FxsETSByOQSUzb2dyc1Nbm7ZzJfje94nCL3nPBi1LiX1LkUXYP9LhtEcoLpYcrJw3ChUvW+AlxZbraNHFVapiPb0TEK7NP82Th6Wu8wjUIGoE5FOI4P1NdOxWR1D5S8qTgkvmspHrz67/vU02E4XMkkOCNUQeYohDQ4f51b9RqZCAhCKhtx+BiMxFA+Ka489sHr9Un/StAipTk3NarDWwrFgpNhrK9/HPTpbaFU+Ul+UaBx+YpzVlNmKGQJ3cj2nXsTJFkejNWC69yUuGBWIG5Sv+eIpzeFMceO53Nx5mRanzAFaAz/roOtIhRUaSj58VLgrk4BWNCgckj2S1RemgkoX1ko6J0qgC7LUDz/qJdYnGi+ha0NkO4WWsVPjwCl+8zx26n+xgaJBQuCuFfisc+X19JIhfT4VFEa1Kznt/d0Al9AQmpbdSHIeQr0uPh+SRbjJyF4PbRWrOnWfW/bvrNy+3S1DZM21wkQbJbLPAv1R60zN3JHmxZGxo8PqHklJiY9G2Q06JS/8WDIyNpruKId5lSnbEtWzXP1x5V5d3LOr8JImjJIc9+uZ5UUMMUH7unKOQuX5cU7ZcIXED1fGuQ4vrDM57+XmNddOIjdknh0MRawPflbLC4phr7HAKIDH3epbdISmst2MNesO0Vyn1BizkzPuA3tSDIvxCMZrEaHkVGtAzQy8BHNkrRrkqDsoAxvC4ys9AvS8g69BHErZUtyFYiTlIFe31//zuk5hyE2k81WzyxSm+aj5PL6vLjnlSYM9xTZ/MGYg13+9FJFtlJ9hnhfRI800D81S47y7rMlKjmzyNl50rrfkkB281K5rC4uTTFsW8D/P85yTFL+FAr6Y6xVFZ2v3ZGFNvuUi1qaLST5Gx36+m9C6ljx+m12hity7z2hxpvH2UyQ63y0MFq6wtom8Ry6z6Y36Is6zgQvpsUCt1NFrwCcWUeDb5kSB
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(36840700001)(46966006)(40470700004)(47076005)(26005)(336012)(426003)(70206006)(70586007)(41300700001)(2906002)(8676002)(4326008)(5660300002)(966005)(7416002)(8936002)(478600001)(40460700003)(186003)(36860700001)(31696002)(6916009)(54906003)(356005)(81166007)(31686004)(40480700001)(316002)(82310400005)(82740400003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 14:35:54.8998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd693242-8d38-4813-61dc-08da5e93ab1b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4510
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Jul 2022 13:57:23 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.129 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.129-rc1.gz
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

Linux version:	5.10.129-rc1-g29ca824cd19a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
