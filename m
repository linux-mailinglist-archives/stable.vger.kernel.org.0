Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6980522F37
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 11:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbiEKJUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 05:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236591AbiEKJUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 05:20:07 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620629BAD2;
        Wed, 11 May 2022 02:20:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhBDgQjMLEOvQVfgQwm7h+sKgF8tmJcbMNdSSTkhVb8xVpIiH6o6WyGuQy9BGjP6KVbZHrEXc46WN8Co0mZBE5g82wHTZl+v56C29Li49B+EDat8wzMAEKtkDIRQ49eON1M+PwS8gqjCnI+QUOhHlFcHL45IjCTyJFkqClTv1+I6Czcj9nGgGfmNXBaa8YTPSIaWbyjpRrhncaprmrMrOoNTxfAB32zUdoVrv5nDlK7yhapGgisOlYTQg9OL12bm7t7xKV3lFZi/KgMQqjkxw6+IRY/PCvGgoJT+f5xZfAGjRFzmYes3oZ+RZpaLuiSURbqz/BUp6Fv+sDSUAA23VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x5EEldC6doy3f6K4Zc1H4vEFIiF7pn3C3PD+RSf4oA4=;
 b=D0cE9yt8zLBii4OxBXrqmLbwD5GC2G7hSii0Q7GaZkLt/CqdAQNyLlGyHs7tMnV2Rcix5nfdJ7mEc7WNC/xd2Dnx5qKJkOrD3sE82ILWuN/1mquxXlhaK1wOn9xV3zonqaRp/TOMMMJBn2rqcldDC3WT5gYxDkPmbMBGdnHtI49frgdRf1m1L2deajLdOlAz1zmv94mA2Hz7S3lh8/2AsQ75ta4PbgG4vTdSdm/Nch4kd7LxI+Zv3K8fV4SNdFRYhEs+Kd8AkACa/E8hiXqHphn2a8nZYrMBJ+IwynkFbCOZ9a8TfRw3n9I5AMKDBO2h0lXfJFyLwo0/k0G13GIDlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5EEldC6doy3f6K4Zc1H4vEFIiF7pn3C3PD+RSf4oA4=;
 b=n4mNK/ThNqLOOaXU/jcTkKWYq84ndDmAbPKeQYXVk7OD1AHTeVKrzDZ4TDSzl3w9cOgkTia/128VCh5qCaMu9Rk9i1WDe+FnlO1CZLGyJ6N1I1xOYZhV6ZLfs92aAEUIX7nfwoXbTjcxIBri0uPCdBSXpSVv/PqYLA6B1tOFb8KcEj37mljtd9m7mRnw38k9cKDbsZfAPgF5qypiexXoVQMYQ0c5oeRO+baDit6EuczCbtAbcCPl50oRFrMIuA1cfFVvgmFwpD5qwBiQQrlT903pzkJaiomp0fF+l2HVruJXwFSI/OjRj0mIbxFzLnlsBLLoYFqe6Xm8c5kjAzmj0Q==
Received: from BN9PR03CA0446.namprd03.prod.outlook.com (2603:10b6:408:113::31)
 by CY4PR1201MB2549.namprd12.prod.outlook.com (2603:10b6:903:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Wed, 11 May
 2022 09:20:04 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::c5) by BN9PR03CA0446.outlook.office365.com
 (2603:10b6:408:113::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20 via Frontend
 Transport; Wed, 11 May 2022 09:20:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Wed, 11 May 2022 09:20:03 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 11 May
 2022 09:20:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 11 May
 2022 02:20:01 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 11 May 2022 02:20:01 -0700
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
Subject: Re: [PATCH 5.17 000/140] 5.17.7-rc1 review
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0f7f65c7-3bcd-474c-b845-639c545fc3f9@rnnvmail201.nvidia.com>
Date:   Wed, 11 May 2022 02:20:01 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 353188ea-9c69-443b-bf61-08da332f6e73
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2549:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB2549B884075A2C1A7D9C425AD9C89@CY4PR1201MB2549.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q/ZuFiLz/t+puOpaXnze/V7sg259TJeS94TkBaYnTtuRoFMMBBoCtRf5lBJg1voZAnamCb4N5pjW0d1BHUMbmVrbrMf47cegqhwVDCKLD7CFeW2jQLqh5u15WmwSFeZp46ilIoueHiHMimb6zMpLAUZ5HZzHumtwmaGQlTJ1pUMnQgkg/6QSqEHtmQo/tNvZ6S78DgQSlc48mzQO6AwttbCFfYarzn7YlgeSB54F0bFL984ORGvb6Yx/FLSgQXPwbLLZvenQ8equf3HRJzlO6Ezf4ZT4ViWxlj039L+li674h/62lg/Re+Cc6evl2CmTG+1aiHBI4cgAiwPsP2CcFOPfg+EwCu6ATrgkG6fXBORCAb9dzQ4Odb0x6eAQpRLmUwxw4v1Djuxp/miyXGKyErMAilRiMw3mouW/eZBFTmD+orLFAwsfjp/u5Q4EEFyWr7rXX9M/Hq2qTrQuVGy4jluVe8auTOU5ySMARZJsxEN0NBHv/qSxC82QNnnUvLHoN52YD8qt1TXwqPKxeJahmpofMIV0g8x7SxYh7UBwU+idcUmGxt0Ia711mbYzzUwjojUaT5gX6K9CVaux+q3i4NERzLv1ZO7plHdEAdYU5cxMll+RtBGDCCDX11GuzOO2k9csln+HCoZBFWpNTTB/C8RVHFxZcsriPMRfHoKPJnNNGb6K65SvDJhYF+gpuaG0+rlOwK4/R1Gw4tXFCaEaAUM1CS9394ba9T+A+ilhi9YDyyMd7+9CwFXDiS9nDTeidBRYiE0AZPgWhX7jX1adyuUDTKrQc+/LNL9zISS/60w=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(86362001)(6916009)(8676002)(81166007)(36860700001)(4326008)(31686004)(54906003)(70586007)(70206006)(31696002)(316002)(356005)(82310400005)(966005)(2906002)(336012)(7416002)(426003)(47076005)(508600001)(186003)(5660300002)(40460700003)(8936002)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:20:03.4030
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 353188ea-9c69-443b-bf61-08da332f6e73
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2549
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 May 2022 15:06:30 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.7 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	5.17.7-rc1-g34d85184d6b8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
