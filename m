Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA2D4D9713
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 10:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346364AbiCOJFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 05:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346359AbiCOJFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 05:05:30 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B5A1D33B;
        Tue, 15 Mar 2022 02:04:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JMi2hRj5eKOEZCsYxbcKjy6KgMg2GidWVktz7knOasGT2LQPG9y6OVgjAlcqmu02UoH+NskeJH20RkXduL3qz2dNzJoibrQjXC79rz0FlxCKs580U5+Vul3VXKq7UeXpXCcThXD15wN/b2LyWtqE05/OdFy3HWkl+3a7wXx1QuyQ5SrrebCBUrTZzqdZGya0BnZmeIG1fEkpGatgrR9x+5apWz9n0iJp2Rg6l3T/ydr/pgo4Q1wvVU/iQTEyNOq7Onkb2+B703KUHMBk10g4j0RxjoBWKKO/3WlUgBigWIXMCXuXmnPLmV49AgJDMlQ2+mJSYQ15PGD1+KD3WqQBkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TgdZOf5vFjbo9P+BKxFWnEzVUZ5tCh+AYxTwnqO27ug=;
 b=X9nUsulmEfBHcoftFMtBzAn0U21pR3VDq8lc9DnmfPoDF6cfk5C7bGplBrw1ClyfhW0A1hTHzTTFZEi4E3EkrnYEfP6yh1NfyFFlHa69PmLKMTGe5OdVE5JIYH5nN7SQQ2RKFyd9AYboEdTvFm55EOnlt+hLiIv7xivppVsO5Y3fbdVCpyOMDenZSw2cyk7Sz4yx1DoosQVc//MbkB2GlGh+Z9uzm43NaWIYfhboCGhrfMRl0YQgXzW34U37yDPMTeix0B3+zxIIXyH5neWcWukIENTsdngm1te5XwHiGS7bTx+aCWt5EF7Czxi2uPCu0DVyHVdRxOlGVhaEeI4bjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TgdZOf5vFjbo9P+BKxFWnEzVUZ5tCh+AYxTwnqO27ug=;
 b=q9J+1nmatIcKbktnjkAl0aKZAk/QJln7EkBrMxsVZ6/rOW5Ar2wcgOOsjIMh1VvqA/bbCZ7mrzThk785gS3aqczQIr3RS28SXzc7yT4he5ioa/4d5UWgBCH/yLn5P9IhmJiG5+yDp+2YX31SimyDMWXTMhSTnqLcISlO12f3+D+1b799BzmyhjkEmHRTDJY8+HwI2Cepq3cz7QTulfXA4a3E7uOVpRXdJuTXupz2Yks1gPwRa0Xy91UoxbjlqLCnY39VHtkYxypungl+6MM77vjz9WRZ1eJoi/hDRjPucPk47RPrHsjlKIGkmk8eQ5QE9mBhDgtgsoJEFSRb/P+34A==
Received: from BN6PR21CA0002.namprd21.prod.outlook.com (2603:10b6:404:8e::12)
 by DM6PR12MB3945.namprd12.prod.outlook.com (2603:10b6:5:1c2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Tue, 15 Mar
 2022 09:04:17 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:8e:cafe::61) by BN6PR21CA0002.outlook.office365.com
 (2603:10b6:404:8e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.13 via Frontend
 Transport; Tue, 15 Mar 2022 09:04:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 09:04:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 09:04:15 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 02:04:14 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 15 Mar 2022 02:04:14 -0700
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
Subject: Re: [PATCH 5.15 000/110] 5.15.29-rc1 review
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <62fdadac-8b68-442b-b8a1-48d8d5e8a4b6@rnnvmail202.nvidia.com>
Date:   Tue, 15 Mar 2022 02:04:14 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c7abed2-f616-402c-a3b2-08da0662c8ba
X-MS-TrafficTypeDiagnostic: DM6PR12MB3945:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3945AD2E1F3F736C4BB6BDA4D9109@DM6PR12MB3945.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IGXI7G9vxioutmZBxwP566ub9ukYfZYotlj0uFb96+2C9ZERFFJLnDzhVguxGT2CJmdM68zrzYqbZE2Nf3rIa0A7J2XJrIa6sVXVPLw542vCtMFl9Av8DkrXKTDdhWbGzmW1lMKfy2Yy2paIZ8r2Ez2kqbpPI5lGGkT44AUYFKGqqW1NR82sWshnWM7Wv+T4PgenxU8FwOo02HtX2eB0P42keKuKp1lmaAUUzDuthkUripmuFDDkK44/rgwA5oknClmQciDjLdBc4q1QxioEm/oaIuMIrGk1IZgEmzo/rsKwjYsEJ1Fp2aoZ7pzpN6Zw69JKIWLqICxn0kPVKTiKNvRUkDOWeJmUmdVhkdfaS+omC71IM6XAzGqbVUpqqXUe3uWbOzJbnBmA/2vfckDvcypL7GNGQ/i9+jGtY+dkmVcUBZSk8VZI1HC56QH/vblquIhZLTOLUEDXjrkHowEdi+I1f2JX5t+sRuQRiwEofoXqIPuDOo+tCUtA2VnUxZoMxfodRjn6OTRYQKzJUh8pWTOMkfsBx66I6tBfwxU/OL401QG258g7Tg8Cw6+Vp3C6tcmBUGhC1NoXTbyZianW3+dovmy601HugSXf5rSOQyyRVRrDQlFh24s+BOCCanL6Uhpe1QnQH9LDFQFf0A96IK1YMt3mATUxCOkxI/HyzpWs4ucFLEOD7SfnYrrZudfO9q+iuNMgDvDLUeTKcKeCRI6qVoKz7R3FoJNaWDwqUm9sZ3Fdp+Z3tIE9KqF1GtBB75TKb7qH1TfK4+/CZxOAxi4Mvfwn2sSSNaUISlaoqUM=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(82310400004)(86362001)(81166007)(186003)(26005)(31686004)(356005)(2906002)(54906003)(6916009)(47076005)(70206006)(7416002)(316002)(70586007)(8676002)(966005)(508600001)(4326008)(426003)(40460700003)(336012)(31696002)(8936002)(36860700001)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 09:04:16.8864
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c7abed2-f616-402c-a3b2-08da0662c8ba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3945
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Mar 2022 12:53:02 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.29 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.29-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.29-rc1-gb411815a8fd9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
