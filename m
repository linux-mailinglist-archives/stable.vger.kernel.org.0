Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C07522F31
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 11:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbiEKJT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 05:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiEKJTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 05:19:55 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495FB95DE4;
        Wed, 11 May 2022 02:19:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSSzWqEiSnfZhNvuE280OWEzt4HzTjkClx4FckgyS7AsYh4G0n2yf20uKKcTBv7lh8WgyZ806OIv64dOc7d7gOPqHd0cnzKyrkPFGB4ttieIp9G3d7xIclDnnhLcGqTR8IEkYGOZq88yt9fNCXVj5e3sy/2V3utxp4WMTmsPghFvEQuTVl8af0oVm2V9XsXEVioFY8Y+7oohb38p/SlvBFMLJP5e3HXL42YqImbPtdof5+sSZW5/Xk3HzxLTUDMuYNt02nlSNH95pIyC2bIV+s5noY8MfaaquaapeSAanF7iS5bpoma70cNAyhkarlC1qEJqulUwodBtwyIK+7Ju0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i87TmelJI522NCpBklw85uH32I6O45Ee+2pirfflQ/s=;
 b=ZxTi3UX9u4gzFQZI33ixqFBmVdQFdjM1yhIJMWUqs+y1ifXiPGfVwlKSQIUpQtvfmMJX/nkMTd4q2MKVqkCaJ2ELO1eCzasiNsuemLyUX0uTM/Zd2VWyZDlJ4N19nSTAxaqJIr4bXP/AEWOvGi46VN3xVQj4MNDJ3ERF/Pj6IiVAUTYPw9Ry0cM4lD/Z5DzdZlffaKPZb50SGjSk7I987BtbtQfVlSy5bgqLCfIHULwAh15PQejVibS02CxVSeGIltS7SxkRId0FkgkGUuBrz83dBJsrVB2e6Dz3gCvaFTML7G2NmabhWikuj+h1knVu9qLqh5VQNQX1kygGlZoVlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i87TmelJI522NCpBklw85uH32I6O45Ee+2pirfflQ/s=;
 b=E6oK+GpZ4PO984bSs0Vhty+hkUfFDhYsfR/htOp+GGkubpQ8KyJh58i+Ov24FnlU74zd3qOHxAukOl/hZTno1eEnLQOtLNWvQ3oW/ppE/4WecuT9ZQcV7tvwF1xK4WXr2z6uW6yO3/9lHAqcnKVXl1hBUbnNKShzWHUu4oUxRmNebfVGB6tPqSWZ8NY29n6stygSgfY6V4DusITVOmdKZMSlXgrOSS119seu341ObnfgigOkVGqIdykzrJgAlIzbBipWg40veDj6TFXHfMFsZMDmbLRdlUrJNciVwzDwuEej7Ek+EeVxaDSCl2uWTO0vRaj/iYjtqVFYzv012HnbLA==
Received: from BN9PR03CA0935.namprd03.prod.outlook.com (2603:10b6:408:108::10)
 by BY5PR12MB4004.namprd12.prod.outlook.com (2603:10b6:a03:1a8::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Wed, 11 May
 2022 09:19:52 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::56) by BN9PR03CA0935.outlook.office365.com
 (2603:10b6:408:108::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22 via Frontend
 Transport; Wed, 11 May 2022 09:19:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Wed, 11 May 2022 09:19:51 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 11 May
 2022 09:19:51 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 11 May
 2022 02:19:50 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 11 May 2022 02:19:50 -0700
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
Subject: Re: [PATCH 5.10 00/70] 5.10.115-rc1 review
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e7116d48-6133-4e85-a57f-69b9fdb3b66d@rnnvmail204.nvidia.com>
Date:   Wed, 11 May 2022 02:19:50 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f31364d8-e82b-41b8-cdda-08da332f677f
X-MS-TrafficTypeDiagnostic: BY5PR12MB4004:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4004D4FDDA3B0520E9D16823D9C89@BY5PR12MB4004.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NhBG93pt5TJJv/fDmCqj4SnzGrhgfoYLRCTlm5x6iE7HZkL1F9BDIN4rP+BkREfQJFhvkL9waH2cQXI2n1o2LSj44I8pMCQOnXbasv8ghek1gK4Id9bZIJAicJ/0UqDklOXVOP7nlsURGw09c3qEAAq2tJraIfrkfmeXlgFxGI2XVo7EGBPYz8qV85Quy3Da6V8XnNeonduCIeCnHaGPAe4F9/6YOOzwa8MQ1yR9nFBxP0708dWQSfIclr62DvLasMN1XFQRroAd7NEM1EoRbuM/GNmirYyX3zzZtahuv/KkRpBNc7zD/1tYQJsbl31GE7C3/AtN3sIbkOgcRMUBYioF2PdHekUiIIVUEr/1fHCzvuQdjj0XkGrclsfOBHQQOo73x4Fc2fYMcyJK/yN37BViMlhkvlh51TZHwtRrxdoYhVuOBhs/OpY4X0NK1vATvJNYqq1LeEweGDymoRuiZluXtcZXfbY8Sfd0dCJ+Cl3DB2Z2WNWOwcPQfSnYLV2Sw3ez6XhnRSH/yBz36Xyj3p6oG8iBflUQuRBWbfUWn3DDb4iqwDDY0i6rbkBbBzesMuyqJH4Rk5WbDTMJJ/88emLWERpeYfPw7q5ndpbnwwPCl3crfZZMxr80UROoGzclzRiRS/tzOrWVga5d5HKWM/HfgOt5lEy9ut5Hzs1hRgrZxZpyBANoyykf5FcbVR3d8p0nHUxg4xmsIHgM4/i0WZAPo5AySwAWc1zs1gQ1A9d110T+X5KudUPJPPw8uzwKqAKAmodArNhZVK16UkkDNdJADgPbKPg88jV1hf1A7YQ=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(26005)(508600001)(336012)(36860700001)(966005)(40460700003)(426003)(47076005)(186003)(31696002)(86362001)(2906002)(5660300002)(7416002)(81166007)(356005)(82310400005)(8676002)(54906003)(6916009)(70206006)(4326008)(70586007)(31686004)(8936002)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:19:51.7536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f31364d8-e82b-41b8-cdda-08da332f677f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4004
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

On Tue, 10 May 2022 15:07:19 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.115 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.115-rc1.gz
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

Linux version:	5.10.115-rc1-gb2286cf7a697
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
