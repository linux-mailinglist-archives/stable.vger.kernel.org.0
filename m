Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B950F526741
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 18:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382081AbiEMQkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 12:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382074AbiEMQki (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 12:40:38 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946D810A1;
        Fri, 13 May 2022 09:40:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T9xsrWhFjfk9FRschQQQJb5P/KVoLONISXb+k7Ae1eZBAtI6JejRvuIx/chMyE06eFVgIXKu1+o65cdX1n4n1eExMvTVZ7Av60yE3qG8Cj52wq4u6k77ls5wmfk28wWlTK+BwJT/ytcf8F4qWQoQ0R9d3zUqxTqHD0ADJd9/stVGyDaeBJl6OdzH44UAySuqiPqX5umRgvBlcLlSY6IeYyQO3wi8lkW3yYkObmzXwIF8sbRh71REVMnnUNYHVpSaNulzcETZ2JF3ZSgPn+qW65WB6oYM5IdQO9x+wN0prPCHw3Gh4SXBF0S5IlQzQyO0DoDCIvOv2FpMkm1hStM8Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRBpHYccKC5l8La5Md7BJzjdIFK4FKU+JjPnJBZmjjg=;
 b=k3aN171ChC53dIjE88989ANhdtJB/xm3+iMIYT4Im38myZV2KHDN34yyqNEnxOWwC+c6IZoJWXlKKzFeOz41NXAb2NltKMu8YliMLK3xNiz//JE0+H5OHfSt8QY90T4UNcVpHRJTPV0GUujKI8HXxAOFm4ub4LFIMhzLOmHtV4kalBv9E8wxjpeCOGyiht5c3ANi0yK4VEhS+rrimf4FBBy2Mw0daaSG9oGdVEYVre+f8BtANfbK3CbWtzZD3IWC/GqMot8Ul0aqJ1Ek0CKHCbSuzlofICo6PcTx3NhKoEAXJ9mnDxHvEFFLcLDD/lJi7i6PUxHk97vT6RjzntGZEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRBpHYccKC5l8La5Md7BJzjdIFK4FKU+JjPnJBZmjjg=;
 b=ez8A3S+xG2YBZrrhG0UHDwXQjg0Iru6+4/uLbg1qrG0vZrySfN0XvzUvm7Cdxj6ystOc51IJ7g9GvoOKiRxlNzpl+fV+4Ge5BDCvM8Kd4EN08rYKB1EWSKX4WMG79dmDFlS032MSqhNiA6UqSRM/Cz93QDmu42Z9vdm05IVpWR+E5uwOcAzWgTMBNHrawATRBrEgFW70GwweULPMYoE4pmIS4iULEjncoSd0wicR3TOS/mdsee1VNBcdGr7ZTwOC06snFc48fWhDdxHUk31ELY9De4Pm+7PAmiEp6OYdmLGwB8eQbFxaDrqMj9dPw0f9LagYeZc+fLR6BMWLXvX40g==
Received: from BN9PR03CA0704.namprd03.prod.outlook.com (2603:10b6:408:ef::19)
 by DM6PR12MB4340.namprd12.prod.outlook.com (2603:10b6:5:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Fri, 13 May
 2022 16:40:35 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ef:cafe::d5) by BN9PR03CA0704.outlook.office365.com
 (2603:10b6:408:ef::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13 via Frontend
 Transport; Fri, 13 May 2022 16:40:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Fri, 13 May 2022 16:40:35 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 13 May
 2022 16:40:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 13 May
 2022 09:40:34 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 13 May 2022 09:40:33 -0700
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
Subject: Re: [PATCH 4.14 00/14] 4.14.279-rc1 review
In-Reply-To: <20220513142227.381154244@linuxfoundation.org>
References: <20220513142227.381154244@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f7c2af8c-10b7-4131-9d28-2a80dc60d9e7@rnnvmail203.nvidia.com>
Date:   Fri, 13 May 2022 09:40:33 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2407900d-c3ab-4b48-0d1f-08da34ff4e14
X-MS-TrafficTypeDiagnostic: DM6PR12MB4340:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4340372DB47F99258583BF0DD9CA9@DM6PR12MB4340.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iIK92BKulrf+ENICmB5g2NG9e2QX9s9V3QHDOIbRrgxr72r4/cZ9w+agTkRQlLbZciKhLqIL5q8OjKfx4LY2AGS9txp/FX5h5y6O9paoBG3MxgajKcAsG35Kz/lSV9jgtbXkSd+l4kiilqe7H7y5/SN7HQnVKvkibrEgi4C6rfGkcHlL/Nruatvg+APQ7VqKmF+15J8KAMuz3zz/Hr/0SAf3wjxn3FCod9hKq3RJy8jRV0smEvsVIdQHoaMIwiRyVQkkI1UBM2uhZIjNHGHnYl8CSm/owPXJzCgAjscUliMTXFMYaEOysrNuFzSURO1pKBh6M4vRa5QgM5d7qLisn32LkkC3+q88rGJZrDNWP4g0GmEZ0y7RpNqPniI1zekL2dC4lip+K/VDA6hJUX4yY8WWBMmy0/iqls9NkHwqgoLl+ZrbGaZzmgqco+0XJej8iBcwtkvMYQHPzMI1MhR8M6kNaMPSA/EP15M+vQOwilSsz9ZnGnQzUOxhilPCCzM58cKMtPhPHedtTmXfd8IghqXgeW8n6xNyd/cyBwfNHmZKUHzvMjeJgzj6DOk19MQ22NftF/u/HBhUuQ4mjtAobV9P65gFRSUxRaBXDnQzP+9N/0vGbyJV5m2GnvCbtv6OAiliJa8JJp8PDmTjnTt4xK9kKAR2URCLS37/oRxEJg9K9Sa5PzNMRozJ0QNZNgqOEDwgF27HZkGibdmn3tQDEyYSZnWMzH6BIGaZxH3No/Hq3viStLJfokuFpFGfAwzQSSkZF1GiMGXWExWFuVOpFYaozw0HhDmajBymEB3g7RE=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(6916009)(54906003)(8936002)(4326008)(70586007)(316002)(8676002)(356005)(5660300002)(7416002)(31686004)(70206006)(2906002)(966005)(81166007)(82310400005)(26005)(86362001)(31696002)(508600001)(186003)(36860700001)(47076005)(426003)(40460700003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 16:40:35.5869
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2407900d-c3ab-4b48-0d1f-08da34ff4e14
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4340
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 May 2022 16:23:16 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.279 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.279-rc1.gz
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

Linux version:	4.14.279-rc1-g4477341b2b19
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
