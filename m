Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96AD4658A1D
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 08:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbiL2HzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 02:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiL2HzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 02:55:01 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2074.outbound.protection.outlook.com [40.107.100.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAA6F5AC;
        Wed, 28 Dec 2022 23:55:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RKNivkU2XqHwkJ8O5Q4s6iNBxV+Z3m+vn9m9EjI6btQEIGIz9TxQ6o28fRsR2f7JpMSdnxh09tHZPOC9oGMwOzM2+bmL7YxwriRz4vq/NAfY6w/v2y46xO6raAtIgQAlCXZaDHnqhoJoYjK2vDyj/4IPplzMqlZvzSOmCIm6g+YA3PIWzO3B4VflX4e9xGj8DDNHnB2oY9jfWvVonhfM8TB+8hEE3cAlkQ/9Wx8GExz94/qb5CbYnimczBGS/2P1BDvh4+meflSWjLG89EbDj+e1aV/9/a533xxeuB2Av+v/+eUz2bgUJq5hs8k0apO6sRg84TqkxOfrqOBFA8o7vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3CbsPL87SyxkevnyZw0QBoY2ny9iwqqDFXcnDc8SGw=;
 b=bqEd+nTPgHv8X+G9XgZzHcXcqMTGxnAjf5lSAPATm57zsX2lWonzF8ngx+zoBd3uYeSMZ8WuecOoWzGLoaSPepbnt8rDVolrxKsru0ZdoOCV1qUPzd0GO3zVYx9V7KBwYa1bnG+CqeGbDgqCC+W/mXBHlCE88wA5AUt516ajkl7QAExK9LEmzhrdvbdm9fKRduhQgWvRTX8i76Pp7tUGucWoYL6g3zeyHvpw9eOEiMaV33JWMS5poBOq8kDZHTWTHUO0GdUhixbGzUlDULXJcPrgP8P088XfVFv/Qy5gzNEHwsRp6YPbIv4m6qGYdNyR6n5JvdFeY6D/+QcAZuKNAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3CbsPL87SyxkevnyZw0QBoY2ny9iwqqDFXcnDc8SGw=;
 b=g3dZUteYmUg7n1eDbbJexE6xekPggAbxcSl3+BJZ67pi+q/hBkdRqSAYLV2nakM+lrRYwoz7Z+9PBadYmZUITC/I+4pyvlE8eOkpNgN0swcXWtGmKfPCUnqt7Kg7B6kTsQOGamXL3fGiSBy6atUp0ZY6/yY4LYHperkiMiBer0GxlBX9Rc+fHtZrB8OpTeDQmD7moN5S/VT43YCBxAfee52jcTluPK0uJ2gITZJCvohi29Qe/hA7aFNRtD60aqpVS1G9NshYPHewWbTsqYxAWWI/X0kggbUpR6WtR7rgL2q2zqhlQqsJowoMkjKZYFrapH3F3MuWyq1vcHFsLehWwA==
Received: from BN9PR03CA0729.namprd03.prod.outlook.com (2603:10b6:408:110::14)
 by SA0PR12MB4480.namprd12.prod.outlook.com (2603:10b6:806:99::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 07:54:58 +0000
Received: from BN8NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::bb) by BN9PR03CA0729.outlook.office365.com
 (2603:10b6:408:110::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5966.17 via Frontend
 Transport; Thu, 29 Dec 2022 07:54:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT101.mail.protection.outlook.com (10.13.177.126) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.17 via Frontend Transport; Thu, 29 Dec 2022 07:54:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 28 Dec
 2022 23:54:39 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 28 Dec
 2022 23:54:38 -0800
Received: from orome.fritz.box (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36 via Frontend
 Transport; Wed, 28 Dec 2022 23:54:35 -0800
From:   Thierry Reding <treding@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <rwarsow@gmx.de>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Message-ID: <100e6bf5-22c7-4cb8-b7f6-2b0221613ee9@rnnvmail202.nvidia.com>
Date:   Wed, 28 Dec 2022 23:54:35 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT101:EE_|SA0PR12MB4480:EE_
X-MS-Office365-Filtering-Correlation-Id: 711b2a18-49c4-4e1b-71e5-08dae971fb3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RZ6WEkVchMGjocYDs+x6K2wbwArVCafGNeXTffzDhUUb+YfccULOedXX/C1n8rrDnca/5ibHpXZjEtmN5aNy1ias7yBn8y0chR+6dmSRbFqf2oRKQ9btB9rbddOQahxRUQQNesFTz/TDGYLBxtN0zQ8HzNISAYV9L0xhk+ChpRVN4fkyPt9JjN0O6Cseuh55JuJcq6K+Vy2n4OADyRpVTef88l8VGOGZHIRxMIC2Q3CebHd+fzI6Bi0mxhXfQky+FAHm7XYk9ybSeDP7H1LMgjMKxIVaoLq/myHE3AtwUbfvOJnCGHAXP2bF5vQTKMMw2MFIyuW7af1JJEywUeO+HjkOAxLo6As2d8dY80Z4rRMwIPwOFo2+zJFtPiC9ffGTojXsoUfImJnCdrREs88aG/XbQn0pxD/CwNNtMZ6Tz+rAXhHJnB29inuA32K/7NsEUa2RvamEmeH0opHu0frQPR19kMYIg71k+oUcyu8p8TCST5Yo4/Xezu2A2bJG7jfA61dOJNTSjXrNg2qYQOkDnMQAW2yrqJAbdP9SGEJS0dzLqc3cYGHHNcOH6wwayfDBFJVNf6R9SfNH6JpH/s+8UrsYKvAtb7aAKlwWmMk/LgL2kgcSkBPw/34dSmgBq2NMjrxP/Ey6nl/F1QGIRfPBAfxigYKsx2whulgr7iXzbx4SYN2KgfYyq5gwh9cy+FbA3xCerFXblOtAJvZKzkan6CgvpCwMRT5x+UJl+HLzmYHTPclcl4McnB9ZgslQRfawCNWQvc1Jt0s4fMLAtOHOr5aEqJKZgO086I0DNGe9zI4nnVeFtw1vDAntMgWNRuQaXw2U6pjRrMM4SZ2i7Os+ng==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199015)(36840700001)(46966006)(40470700004)(31686004)(82310400005)(41300700001)(8936002)(5660300002)(70586007)(40480700001)(7416002)(8676002)(4326008)(31696002)(86362001)(70206006)(2906002)(54906003)(36860700001)(7636003)(316002)(110136005)(356005)(966005)(82740400003)(336012)(47076005)(478600001)(26005)(426003)(40460700003)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 07:54:57.9712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 711b2a18-49c4-4e1b-71e5-08dae971fb3b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4480
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 28 Dec 2022 15:31:47 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 30 Dec 2022 14:41:39 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.86-r=
c1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git l=
inux-5.15.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.86-rc1-g87d5d5cae7d9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Thierry Reding <treding@nvidia.com>

