Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19284D11F6
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 09:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237521AbiCHITz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 03:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344927AbiCHITz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 03:19:55 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7440A3EF0C;
        Tue,  8 Mar 2022 00:18:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUCFirQwxQrlr0p+J5u21P8lYnvcX9f36QCS36qjVp5vYSS7N1AHG2c+RieGfTfBavGRuvevm7ntjUILNgrCInr6VHk0R8+JqzX43nT+fFZ4LbT1p410Qgfy942FQ6SZq4sLre1rYFW2nrsi2/jo/oe/blCKzhYnw1fG/jTAslC6Ck8TtnFLHnRQETwpQ7s26KoLW4gMl/hJYOkk2RJkzqT/PyvuU/LwNn5bwjVPRavQuGfapz3Qo2rKKr3PjM52MeUa+wt1PobdkgfFfrUY1OkbLAX27e7jwmUbYgCujxNOTlxRb6cvSUc895ehitz7xU+4L8/z3WaNUQdf7/wEwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwxjE5pvR9r63cMaWSdju+tKpuX23DptaUZW9ZL5khQ=;
 b=GkpEXaJ9HzqOSoz0IwkGuuNiY/n5n0PHDSJV05+HU1yl54lgfcEs2geMY7E4U45WvXtbJoTZaAh5h47MsDNC7bKo4Ov4y+ignc5WlHpOsTBk/zmlsoNUO+fJKx9LlQCvEWSHjNYs+7Wd2an8g8MAnnHwjtmqCXuIB7Vvb0/bE0Y6q1obFR45yhVN4uxJoQWdzueCQZRfdECyi+GQtiHoCpPUew6HdtBH+yhfjPlgt78R8xcbQibeD1b5iVsCiseyAR9cO2z+L3JspaNg5YY+fqa+ozmZB0qfPIsD6EY7wZyhJvf9JmhMksoMsH+lZjgsY69jZeLE+WVjCiuC6zyO8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwxjE5pvR9r63cMaWSdju+tKpuX23DptaUZW9ZL5khQ=;
 b=Ne5b0qWNKzgGbN4loHv68BORCCHtMTpdT05bEwkl9RhovZpmd1EdA7RQBkZ/bmM0V+kDXH5Z+pjxM/9auDFrCuychI6o8sjYkLbUbRJIzl+omaXf0vW2B7GFoE9l9VBpmwJDlxnGQEWQjDOIDuOxPQKIdw2p3byfaBixQ+AvVnfAZLTl9UbxMdzJ9BkTRAtPfx4ubUCJcG6v1ueU8A929OvxkVsRlKwuxz/LghgvlfrSMFhtV2tTaXDzVC/wNylCxREd6ykOWMYl0yv1PQaX4EjCHh/I+6768gQOMzE1+zN0cVDEeDW0NP9Psm7y3i3ucGLBwsp3qSwq5B8uaM29qg==
Received: from DM5PR13CA0013.namprd13.prod.outlook.com (2603:10b6:3:23::23) by
 LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Tue, 8 Mar 2022 08:18:57 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:23:cafe::63) by DM5PR13CA0013.outlook.office365.com
 (2603:10b6:3:23::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.3 via Frontend
 Transport; Tue, 8 Mar 2022 08:18:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 08:18:57 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Mar
 2022 08:18:56 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Mar 2022
 00:18:54 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 8 Mar 2022 00:18:54 -0800
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
Subject: Re: [PATCH 4.9 00/32] 4.9.305-rc1 review
In-Reply-To: <20220307091634.434478485@linuxfoundation.org>
References: <20220307091634.434478485@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e484614c-8c50-467e-8cca-ccd5c2e8b96d@rnnvmail203.nvidia.com>
Date:   Tue, 8 Mar 2022 00:18:54 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfe5d40d-6d94-4f1c-fb6e-08da00dc4aa4
X-MS-TrafficTypeDiagnostic: LV2PR12MB5968:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB5968B05B3269E58BECF6D8ABD9099@LV2PR12MB5968.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZY35LAZYelLYy0YvE8zgt2F7grIpt106b8qv04dz51yCFNZosaVaOySLvmZM6CvuOax854kD7D+ZOdEleLvUkKU4bLeyTwo9lEiiPli0Jj9/ufB7Z9dqLjUjvN8hU9/BwJP+9cO9OyfcjJEDEG2Y1eLsTufwUGRmqIyTBeMc6/DMoK2g8aoaby4SvH/59zi505nnBocLPJA1Il9w4ihnBnNa/eH6z+UrerZPPawG+dMdX4yz9M5QfeO5hPYT3y2M0+JTJ++d5jKQ9HHwvRznw7YRmohiece0cy1/VX+9XyH5kZ0PZHLtiOtM3ZTu3KzbWUvWTtpUwi2mSBRJP/RtIB9oEGyY7vYvhROsZOaA6ncZ02mwiHR5ErEeZeR5b+U8NcozBy4Tno+FHseKCd5GjzWYffdvsBO1T6O5NKjh9670GpGh8TywrQNFw0l3WxzdAmdevHn376TqvHN6YhZ2Vi61uO7aQbPBlNYzyLKCzzhwjEs+Isb0lOmdBKXzhowJdqxLs+uU1hdWd62IYCszUrcutzq5SBEFf49i+3dACeAGviGZwAHEgqU/IC+jE7Ub6d6IGZEzCiC4j/oee9VxtngHo/dE4fzzdHhpLaltyROvJ48PJokEktg3obPq/gW1KOhPGYJBXg9KHdgl+JI4o4xnk3BpgPsIoOeGaxjjK99U296LXD0dhFfK6TnaQ12O/zKAJ7tRwXJpos+l4ts9mavJig/d7RlAWZWLZK2j0Aj7k/FgwtxluZvh7ve15ckQ802pJlStgmtHs1E5sc4jy6wXVxqIo59o/7RsUzY0TwyvYVrhpt8/sD+VbbutsOp2rR0NZQh9nYccPmkL9GUl03jP8cgkNwldR+OWYntToF8=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(336012)(2906002)(70586007)(4326008)(8676002)(186003)(426003)(31686004)(508600001)(26005)(6916009)(70206006)(54906003)(82310400004)(36860700001)(966005)(81166007)(356005)(8936002)(5660300002)(7416002)(86362001)(316002)(31696002)(47076005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 08:18:57.0227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bfe5d40d-6d94-4f1c-fb6e-08da00dc4aa4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5968
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 07 Mar 2022 10:18:26 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.305 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.305-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.305-rc1-gd3c7ac3bc772
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
