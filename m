Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53971584178
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbiG1OfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbiG1Oer (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:34:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B576AA0B;
        Thu, 28 Jul 2022 07:32:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiWc0xrQtKbXHpo413k8CV2r5Gx6dA4rc3DzHiQH6PyvNAq7BB57uJ8Dl57N1pgdOLPrkbt33fRZX178DZN1pzlPDDeLzeIPtEReDjuvL4cDV/f5vHDVl7xYkPkepZmmEPMW/DGXGFzr9UglLJ/0bs+rM1CyP3owwZwPlASo4cLOR//U3B1GaO6MP7ZSDFPW7aIToCZm0ml1e1MJPdE8DcGq9GrcZxLaIeGBA9KJ4RrLP9DLJrgnHA+a7kEjfzMDtn8MhZtWXJgXvF56SYTuYT18/wvqVneYYpcp/sLLILtY43hQ+A/CxuxkPp/yUoxFOYiznDunQqdDRSkJa+fwmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bq0U8vJE1IGzh/ZD4lF6CF9Z/MM85cY8/JvpTnUpxOQ=;
 b=OtvRnwA7kfOArt16jW9Bc6uU9he6CT+aQ435rBry2x5YkSr8HmXPXd5P0g6VXxEnl/pX5o4k9ZAu6uI9sl+UfzrKYAZtmGEnx8TDJ7+9psNCk7aOeTP50P+vRqSJQs1LmoK9+QsTWQtOPrOQ9iIRE4GiFLldSRcHdgHFDP1ruSfhpceLpagSqwx+aQt5a22VznLlPwRtwZWUPw2Ksy1JiBOORmFZP9HBs8BQBEParg12mizfr3/UqS09pSgus4LAg5sKsP1i2Z44WX61RP/vd5mp8R/OGTUX8aXj31YvDevj4oKkb9mJiZktl8egVRnj77vuaEyA+1/CRIXQTn+TXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bq0U8vJE1IGzh/ZD4lF6CF9Z/MM85cY8/JvpTnUpxOQ=;
 b=hzbWQYxJsCr9loO8zN5FuUvMWxpmJE+yclqdrMpR8Hu9ER+nqabrReCtYA/JMwHKMP5kmOOgxSaSLR/VZBVI0bk4NEW/b/ogd7DZRtJI22aw41bbqp6Ex9OJ0waEJFjkupD4jdxCqF7vqEW/d2Qub3xZqtq6HXBTH/I7bOUekKfcKsDYkOKaO03T0bghFJYN5XrEAdxg1vJ9A1Ddyaxj6dLePPsrPvPgMvDB/dzC3SjhFj19wl9DH0UKqb0c5I53MMe8Q1dGaSx43jY5qV4MFjkEU3WAG3dYHb8TvV48Il+BE6GgzQObYEXgp6O+/rVMA4/ypX47jmlNC2Hl8+aMjA==
Received: from BN9PR03CA0369.namprd03.prod.outlook.com (2603:10b6:408:f7::14)
 by CY4PR12MB1766.namprd12.prod.outlook.com (2603:10b6:903:122::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.21; Thu, 28 Jul
 2022 14:32:10 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::11) by BN9PR03CA0369.outlook.office365.com
 (2603:10b6:408:f7::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12 via Frontend
 Transport; Thu, 28 Jul 2022 14:32:10 +0000
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
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 28 Jul
 2022 14:32:09 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 28 Jul
 2022 07:32:09 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 07:32:08 -0700
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
Subject: Re: [PATCH 4.14 00/37] 4.14.290-rc1 review
In-Reply-To: <20220727161000.822869853@linuxfoundation.org>
References: <20220727161000.822869853@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1a968f03-5852-4879-8cda-f93bf1bf78db@rnnvmail202.nvidia.com>
Date:   Thu, 28 Jul 2022 07:32:08 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fedfb823-da96-414a-a74c-08da70a5f4c2
X-MS-TrafficTypeDiagnostic: CY4PR12MB1766:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YTzvkB+HG8dzc5L5tLXA3HuXQJ1AT4y1nIdA8j74v1BKdhPONGIBtIJsmlZWg3mG4rpTwISqWBU5yNYp+cPUALTrt2u3FYRH9RnmQlhzDG7gmcxkkQso78lZxXIJm6fAD8J9D6OS6HKqpIhq9mvInVYUdtuWnVRy93RH0nGs0nVuPo7A31rooDlrDDpP7mrBUeRS6wjgdmTxfZQl4s6jWEJMiqcz+Dtlp4tAHjBUrRxyKll/ushfwQcrDjJEqeMzP1Ek5MSNO6xT1yI0QyvLmmDc/eAdzmacVWEuHwk23vzDGiOFC35XSPWRAS8aMY+WGDJFNi+BUEWGF5EHfng+NjEB2x5jTq1INPE8KtONqW+7gAtW9Ot0GgnBp1diurPXNnzibNnYlxOsV/45NJtaVwWvTYxuwCjK3xdnvGhjwf789zNYWnLKBqE/kqe8MWxx+67cBInj6q4HhIcZdQg5pRfbhS2Op7qXFjh0QPZFpRpaOYWWSNdkbDvRR7He8135BUtwxHJp2rscC7sMoa98IeOjPMaF06aMahtDxV1aJjzdS4zpBeVb6jPEqffvi0tLhTzg2wy1ilsKJZUvjEj2kTXIgmYRGI7SG6jfs0ItIkFHM0hCDrz/weqWKsZ1NrsI42tE+32sVfqnrIZPZhObikhGGD6++8JPvQt4C2muaqkYqur783SsIRU5WDjgOC35uLn4YRtpMC9NScaDJ7QTG2KlWbdavFEuxXfN0zCQNfPELdBcmvG9DvYkFkUO3Jma+YhjOuh+dAhQLbkg1ngSEmxmCJHd3s5MHvrlShHn37VXFHw9IQTpT0dfYv6anJB9/gdeJCzafJmip/HxRNQOx9rvon5DEGRTuurRvABeUtTCax5UdSrk837XI3sABoo90CA1wzO9dI3EVzJU7aqxgCn62WnwRyaXFAq9AiwEs5Q=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(136003)(39860400002)(46966006)(40470700004)(36840700001)(82740400003)(47076005)(7416002)(5660300002)(316002)(8676002)(8936002)(54906003)(6916009)(31696002)(70586007)(70206006)(4326008)(40460700003)(186003)(36860700001)(40480700001)(966005)(82310400005)(86362001)(356005)(41300700001)(31686004)(26005)(2906002)(81166007)(426003)(336012)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 14:32:10.2940
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fedfb823-da96-414a-a74c-08da70a5f4c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1766
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Jul 2022 18:10:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.290 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.290-rc1.gz
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

Linux version:	4.14.290-rc1-g7df53ec6e7ae
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
