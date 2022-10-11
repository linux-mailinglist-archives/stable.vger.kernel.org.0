Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFF65FB7F7
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 18:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiJKQIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 12:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiJKQIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 12:08:32 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20630.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7719F53D32;
        Tue, 11 Oct 2022 09:08:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0M0Zmmkr1RuBwc4t83qWApTCdID9bdhqJmPw/Xj1PYi7WbMTZnAj7YIR8znZT4j3OWi63mQqlZ544+KQYysgtR508OOHw5sqviMlNJ/90cfULbSCLJJPCw1JQ7BrxRUJ9h6NdA9eP5r9w1ZJKI5XCWSCU7SXfDTezg2zFBgB5XSjc+Bpp7NbDqZGsjXg/RO+VS2Him36GH+ii8D4PVMh4HKaGxqQMTlWMcS/OVLc5aHeXn1SuFzv4YAeMYk2F9AcFDMzGFfrcDRM9nOnF04TYD/bjKTB7dkpZKWwxIKglwUNrmiupoDv/Cjff3/7lIRlkRDYraSY9ZVMretkjgaxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nElGiXX+SUO/vxx32xfcKugUwn6/meG/8MxFjjRROSI=;
 b=k1m2UHsfLip58Je0UFBoxJIlMoBfdU+HIN/qxAxERY+a+ctqPzInxejsdUymjCueOxjW0Prgyvrvi4kvfMRpknlqwHRFkySM7d7loUarL0ALtX8kKMeIWkp6O8/TcB/ivs1xbfr4QYEkle19WieI6sOciHfzE8WCiFVlN5RfId16U3Ahumgk3WzfrX5aBG84Ko5UKSRA7zU/i3URjb1OiIvrS4rFCQIOwqbrc+eFVqo6k6cX20GU0FlFkENk7ByhTJSJytcG+BUokgssKWaSMpbxde2nhJQtNDqIl0t4rfKsPDGRgImzA1aNMcQLYa32bheld9S0zsB9e3LJTcfv7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nElGiXX+SUO/vxx32xfcKugUwn6/meG/8MxFjjRROSI=;
 b=fKx0PnkkN13R5UsN1Y00cgJfFZoiaHmwO9+yOZh9t/78cMpYl1mj/bf3oPm+tG2g37zuoW04a3LKyj8RcKpabg5U+wHAdgmF2IWv7IuBptkf6/KlVoQ9niHgfj82gbGSRstmpyWaz/GrO9n7dyNHzTsBF4QrTUx1frywo68lsMC2RN2w0gueNT4GQk32dl9bDzKObtgltPXmB9uCTFwZFsHP/iU+2BRaeAEjDx2ceK85PAaMbWtWV/XiaGBrykdqQ/TonA71o1PalyOA9wm3QCNWPG448RFN8Tz6IcSenZbqnnvAMTLyYyUfZ32GyLthhmhYkaPc4EeykPMMcFmT2Q==
Received: from BN9PR03CA0754.namprd03.prod.outlook.com (2603:10b6:408:13a::9)
 by MN2PR12MB4253.namprd12.prod.outlook.com (2603:10b6:208:1de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Tue, 11 Oct
 2022 16:08:28 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::14) by BN9PR03CA0754.outlook.office365.com
 (2603:10b6:408:13a::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21 via Frontend
 Transport; Tue, 11 Oct 2022 16:08:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5709.10 via Frontend Transport; Tue, 11 Oct 2022 16:08:28 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 11 Oct
 2022 09:08:15 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 11 Oct 2022 09:08:15 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Tue, 11 Oct 2022 09:08:15 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/35] 5.15.73-rc2 review
In-Reply-To: <20221010191226.167997210@linuxfoundation.org>
References: <20221010191226.167997210@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <30fdeee4-86a7-47ee-813c-32094de0d8cc@drhqmail201.nvidia.com>
Date:   Tue, 11 Oct 2022 09:08:15 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT032:EE_|MN2PR12MB4253:EE_
X-MS-Office365-Filtering-Correlation-Id: 3efb0129-6938-4006-4f00-08daaba2d58f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: APGhPi0GLHapl7QtAv1ckk8spYvjru49JiiQjlvNoxAEwXNKiRDErS2aN7PYsu4+vzfODxo60gVaVe6+vXulk50W/HjeLqAfswlwQCc2dxXTcV+MR9wScPuur2AjHu8qwnWrr9XtQiacX2nQfnUId24xq7GhSO+U87mOsMms1z/ZZP3aM7DTMR2bhRwAudWipQ9XROY1EE7lNwdzwDYIlEO8quyFnDgP6Pcj9F/uuks9AyBz2RfTsp++Cb76LIval3742+uAS4tYPvXRHLP9FpVWG46XQfK6U7ffH0tAC74hS4NRIowMsJDiUOmrgpojg+0C7HbommmJKBSukRepbwjtzx7P1+vPEV9Z7XGS56YgbqDA6jsXm7y2FRcmqbjiZmJRRXc7SZjZ9bFkpEIYHcn//F/fQcVhBhKWMaqYKahExykQAEZhcpnOAFU0pSacwO6ZBFR5/irVyJ5wmy+h0cqdXPbBD5Moi2UG+gyhGK4/HyfQcg0S1T/PvpNmTsJSm+OP6Pp/8uG8amhRUmfZLv9VuXQq8rIM9OFGDf1YfGSrXUtCv1vNVMecJYQVZJR5GBeCklGQWjmeuPFp++fDJdJnwaZEy4kiVa4rFZNAAa/SbbyOpfYlnlb5cpJcI/sMt6nDEelsNr+4Zvzfhu9fpCD1Gl6qVYJqt0gsX2SwrlD11CxBNaDkZis33Kq76mBXT7gHO/khDk23Bve0EB7QdPv+7S9f4RJkZyrvKv1NXk2uoNOOAWHlkXYQ69STsfvwpl4/zlMKjnX1F4cflV9FOB8Lry2otM8YutalpRPuK0y7KCK9c7IGCDlUkHH3jz29A2zuCIosf9BB1xjZ1qi55APnxNk2KdTWD6OJjLbeJUs=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199015)(40470700004)(46966006)(36840700001)(26005)(31686004)(6916009)(316002)(40460700003)(356005)(8676002)(54906003)(7416002)(36860700001)(7636003)(31696002)(86362001)(82740400003)(426003)(47076005)(186003)(966005)(478600001)(5660300002)(40480700001)(8936002)(2906002)(82310400005)(336012)(41300700001)(70206006)(70586007)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 16:08:28.0462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3efb0129-6938-4006-4f00-08daaba2d58f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4253
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Oct 2022 21:12:52 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.73 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 19:12:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.73-rc2.gz
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

Linux version:	5.15.73-rc2-g197d9e17aabe
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
