Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B6E4E3081
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 20:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352443AbiCUTKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 15:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352440AbiCUTKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 15:10:16 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2083.outbound.protection.outlook.com [40.107.95.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC4823BD2;
        Mon, 21 Mar 2022 12:08:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lMTl8zmvlcR+Imtyxpsi0TOBnFi+DY7PQ+4QFhpFHxAOliX6lOeEVlqfw7P2Ip1iWae1e7h8ie9YMWe67heEgiNRYpVoSHGAnPQArHf0bMjuj9G1Wre80MwA/NO3bG2TuO13axllk2h+8puMvMLdd9fI4TFSDMvE6kl/BQTyBANuJovlEUP2OhEd6zzsK7zolT5WB5kq7exWrqUD4Rfj1UYQrDOp4VsjU0MaGYACn9d9/PEawCFld6o+IeuUBpCMO9AmWe7n1B426N8g1r5otUyUg0pcHbuShjUC1JvmT0E16D5Ub0hK783/CShl7Vs5LKO7XGcoe4ldIQK3NiMlPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDIkQAH60Duuk5sqlyqhcK/A0EBgETqZo7gWJszrnqA=;
 b=DUdxqSy7dlIVCbh5jb82Bykn4/SX7aRUB+0dNbjeugn+vwIvwCSdihSZUlSlvlwHRwCVm9TQPeVi/S/B0UGQnMLBiG94DB9JiGmbuoYI9/bYzi5SMlkxiCeOHmtxHdrJByNW762zOQ9g4MdZeDgREZMWcphEZiZtMyjYe/KokEcLaLjbeRl0xq4h3iTjFZPrgbawH6/zZF0zNDncRX1M+LhtEUlSFYRavYlc2Lxy8/8VsZLyMBKSOevDZEwfSFt/uNGdFAhASk7n/MYTlm2y2DgkYgevdmWWGAnru2O60q02MGxz3CkTgwJEdA9NYq3EGLRoY2POWZSJNWobTQEV8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDIkQAH60Duuk5sqlyqhcK/A0EBgETqZo7gWJszrnqA=;
 b=uVh004p7W2y5icyt8l7MDch7tjENB7MGzZu/+tuScqda+roHUVfSd2tWqAkzTR0cxF7o05RLQRokWl2iColnkV1yPGOR2DIOKN0AS05TnLcM7GtMHr1hvln+k4e3qhJiwzPYYiBoeNXqCZmDvt7Y6jEvnQH51MSxvr9tPVuKB8NnhHBMW3ZZ14Jxuq3FbuukeQzt0wmYb8U3RfnbJe/bPshoCcnSqOC6VOvBWbBKXJJDWejlQG1jGk6I+4fHVFDCzbiwkgDcMsPrsY/9m36VvbOxOV1gCnvL3fdzQ1vn92i95lfgHRCApXfHnHL8Urisn/bWfv9LDrKZDNErsoqGdA==
Received: from BN6PR1401CA0023.namprd14.prod.outlook.com
 (2603:10b6:405:4b::33) by MN2PR12MB4016.namprd12.prod.outlook.com
 (2603:10b6:208:16b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Mon, 21 Mar
 2022 19:08:49 +0000
Received: from BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4b:cafe::e8) by BN6PR1401CA0023.outlook.office365.com
 (2603:10b6:405:4b::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22 via Frontend
 Transport; Mon, 21 Mar 2022 19:08:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT041.mail.protection.outlook.com (10.13.177.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5081.14 via Frontend Transport; Mon, 21 Mar 2022 19:08:48 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 21 Mar
 2022 19:08:48 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 21 Mar
 2022 12:08:46 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 21 Mar 2022 12:08:46 -0700
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
Subject: Re: [PATCH 4.14 00/22] 4.14.273-rc1 review
In-Reply-To: <20220321133217.602054917@linuxfoundation.org>
References: <20220321133217.602054917@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <34439e13-3667-4c28-91ea-27a6c6b03096@rnnvmail202.nvidia.com>
Date:   Mon, 21 Mar 2022 12:08:46 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c71fc16-b130-4a72-3d0a-08da0b6e3adf
X-MS-TrafficTypeDiagnostic: MN2PR12MB4016:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB401633BB5DF2B8ED98EAA9E6D9169@MN2PR12MB4016.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BY3SvlpDFxcFLtdr/SRkgsC60LVWUwV1QLXMBnCAx6evYdbyW3NXOvkvNxCmmfEmk4ZRNRmqIgj3NJwivY68kz30lkAYFdvtxKI3TDLE9Im/xrfvq6JVBxxN5dxW8FKBb23QuN3tegQSZ6YKKQ97iBChfSsGnkPZgFlXeg5HXMLKY78gZySvjKMyxJ5Yy+5d6xAfsBV/FnPterDeXR0fSDgTl7dUVwced2HU5JJYouUjysCmfiRI7unY4y82Dwgq4INDIi7S6/ZHWZ9OyJVW2m5njcSIaYXIMbfTGvm8hOiCaRuaM6yq6wE32VE5nWsB/3k9+H9wGctunF6tupcE6PRc6f7rshtVRknX0qeW17Nc2aXYww4GXlZF9Vbi5Ri6mZMCbfNvvpK9AfYWn16NwaB73VULCiCU9GvtVIWcj72Tavwd781vyNsdfpEQBxBXzKMT/AKn7AdeyyCHOHlsNCRuwZpMhJhrMoxys6Im+G1G+gSoNuNribBUAcvSw5p3bIEnl7ha/cild3IdIRIn8y82DzgSZh2w/kQ9fNL0KiDLGqcgell5iYozjpQ5g9yPQG9hlRP59oMpvIKz02i3cUuNQbwnaabsETKv0PNqSW9kc3byqKRT2VwnEI1DNkXHRDV7WiR6sea6M5sP6qf/9aG7mDW2A4822nPFS06tOubMFhZqaUz/0S5HomPVQDnFwYXv2CWTha+qogBukspYoaAjkXsda3dyIJVZKEw8qCg6l7I6hPm9mAxV+AOaht2MXh5IfVUU8XnDoTTZwPIpiD/OISuF6Xj2KITdVFGKuk0=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(26005)(186003)(47076005)(508600001)(356005)(5660300002)(8936002)(7416002)(336012)(426003)(31696002)(86362001)(81166007)(31686004)(40460700003)(6916009)(36860700001)(966005)(2906002)(8676002)(4326008)(82310400004)(316002)(70206006)(70586007)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 19:08:48.6800
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c71fc16-b130-4a72-3d0a-08da0b6e3adf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4016
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Mar 2022 14:51:31 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.273 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.273-rc1.gz
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

Linux version:	4.14.273-rc1-g7d28b4c6f458
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
