Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC0049BCBC
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 21:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiAYUNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 15:13:41 -0500
Received: from mail-bn7nam10on2041.outbound.protection.outlook.com ([40.107.92.41]:45569
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231426AbiAYUNj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 15:13:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lj0iOuTNhNbQnSfqLvJLsHH71dIiFIEoNmhENNhGxFlletR4xq6+xPNQOLYvZQX3nxxBGQbJ63P08d4bLE6dd5XWirO147gH0GS+U1C7RtNnb2DyKhfH5RZ+ZXe/gASbBJmHoXTVOb1pNqkA914ukImhjrMXPM2VKuiqQ4IkqfqEfCNtTYe81zMyj5o2bhPlxLwl7WTb4V3x0yLSXXIw2Uty+rhqnwQrvuC6dU3YhjYZZ4QMuPlDCkQaG6AD+JAC268qpa6bzp2ERay5OFUv4n+UJayIHyhWp9GgtpwdtrKu0rch/oyfd23aBaIW2vaPwajdIjs5YYlpYyFcusr3dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U74no1pzdlfsYYlzJHIEXrMXVlGdJX2BlD3hckwmF/Q=;
 b=U3rnbVyqTMUASU0SbYYZ/dLjG73ksX5j8TaZ/+rEFg5If3dPFeG7SjXAICOG+cARzcmKsUO3sTvyG54fElBO66wVvOxZ9cYgYXTfdeA08rKoxzJnXXBRXeFOfePsM2JkHMKO2ZNCiXSeeHPVK8lwebxIfs6hsj3SDymLIgUntwbft7p844Hofgug6zN/DMx1tnK6Jik58Rxm12VRuNfyGaZDSORwPlHGZMXOU/NDruTFFdppgAklNnLZlDo+iiBiUTSV16AOXVGRrzr8gLRPhmGNndYksrOATCjOZyrSJFsUMc7d7SF5yitf8Wn2spJthN5L0iHAFfBgq/N4ULpADg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U74no1pzdlfsYYlzJHIEXrMXVlGdJX2BlD3hckwmF/Q=;
 b=BH01c5TcL4MCnNju5T5008qYm2urG+WG45V68HMjl7fiIcMV5sjgNcd9seIl6j62Csrb5++Hd7A8dkQRkseTxgDjOHAq9GRoraVrCjL39vkGAiIFGSQS9EE5P+cx5+Q0s0frhDSk+/yGr+XEuEIJB5jqYrkexPi3GIHDB06sFtNbFe24ahD7Psu96h/f7oB9okX6w7vKg3VvCvmuNddEwTuHvkMUYPbvaCHh6Wh73lrZZQ7JAjGIou7SZEdIOzGZr9gqMcjMiPuRXWS0GdSn8k+7ALyfyqlneO8B5Y+UKD8t2SipjWczx4aUlCqAXP1w/6O0fvsRXbekt9MdUlvwjw==
Received: from DS7PR03CA0119.namprd03.prod.outlook.com (2603:10b6:5:3b7::34)
 by CH2PR12MB4824.namprd12.prod.outlook.com (2603:10b6:610:b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Tue, 25 Jan
 2022 20:13:37 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::83) by DS7PR03CA0119.outlook.office365.com
 (2603:10b6:5:3b7::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17 via Frontend
 Transport; Tue, 25 Jan 2022 20:13:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 25 Jan 2022 20:13:36 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Tue, 25 Jan 2022 20:13:36 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Tue, 25 Jan 2022 12:13:35 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 25 Jan 2022 12:13:35 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 000/114] 4.4.300-rc1 review
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <adbe2020-8a40-4feb-81c8-5467ea50edae@drhqmail201.nvidia.com>
Date:   Tue, 25 Jan 2022 12:13:35 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48202852-0fcf-4f2a-34d7-08d9e03f2bbb
X-MS-TrafficTypeDiagnostic: CH2PR12MB4824:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4824B32AD6A9A0A21A151A84D95F9@CH2PR12MB4824.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pzPL+rqaVsP15H/lNBCxsV+O+xXJ9kO9lhPIjMNRvh3sBYvuTq/2LNZ/kZv8qmMK1zQiyeN7d/2w155y+Cw8h/hr/sax6suL/HIQ2Eowu+1XkbiZHiUfPxlmSyDLJAXNooTTXKTLykraXQ0eaotrcLAWGzZdEcig4NR3vBb6FY6Y3CcNBHHQBMeuvSpgZugxkLcq3M/Sh8agPgef5Q6Pil1V0LLMQvrDZmLZKU6btXsEvQWU//G28CWzgm4laZApwa2SQrPDMZJa75DLB7O5schOp/5LfmrgKSFaLZX+kpmK2x81Wb6tIRwakhf+YlgX2F0bFeVyk/MIhfk87/cK0QfjqjNVPSchjCuXFpDDOoDJHpEUQnkMW20GMCSWCaZUssazrWxj+UDyiQmg/B6i7eL3V95PH3YZnWT7wgQlU4s37bKUY5KKIGXYvH7FPdJWxERAC8OPKFwfqcVokSB96G6vUCu4ar1s6b/LKJuc+ZiZlv8zsH0FXlr3TOYg9E6ujFoul2fWngg9sFjq40YATWOrd0xzr+aOC+/CVJHPqllUP46vRAPDDrgAIbGquSE3cgj25ZvpJh0stbH6SEAcQvUbw3S5osS7CuE1LVvGQSbO3FZcu9W+gFX9gBs54i0J8G9dSCl00Mx1yPqu3VcyTbOL2gXGQ8XqmZnw3IJ08WAH9sGpCBcmU/3tir9KfY9Lmw7qxZ2cQZORxoMwZnd7F6FyjXvV6cuIISuvyzpn0lkKIH80xeuhGjhS4G3UGcmXIcW/x6Ic+L1Wgjz7WeHc5uSuRER6GqnbOM3+2ghIU0cstws8Uk1dLv8dypor5b06eq7LfnfDsLXkrH7R6vAuEKTxNboHFE8poMcdykYFCUW9+abvqeiSKQkTqEt2CLTQ
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700004)(46966006)(31696002)(36860700001)(26005)(6916009)(54906003)(7416002)(8936002)(316002)(186003)(47076005)(336012)(81166007)(5660300002)(86362001)(8676002)(40460700003)(508600001)(356005)(4326008)(31686004)(2906002)(70206006)(966005)(426003)(70586007)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 20:13:36.8699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48202852-0fcf-4f2a-34d7-08d9e03f2bbb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4824
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Jan 2022 19:41:35 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.300 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.300-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.300-rc1-g67ca9c44f63d
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
