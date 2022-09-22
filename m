Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA105E5C5C
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 09:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiIVH0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 03:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiIVH0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 03:26:15 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A932AA4D5;
        Thu, 22 Sep 2022 00:26:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gs8tB6jaV8TokUQEfLdqQCIoByGbPLl8v3xdh6vj0FQFyJ6S1gFsebHLGBBK4E6QpWChO6ox0gdcBRiPUG6PbI4kX+DfvbBAV3LtmuVlxcoc9ovoIetXKL1xI+ISZ/n5wvaKR2FHyLV5Z0sCcEb1W2zf0x3Xv4yZdVRfuC9W0kVg7SU4qgNQWTVzDwYCYbxGgU2m8tV2YVqscX4oofgZMymbIviDSj6Eofq+N49Q+Lv3fTtH1sB2SD60U0oJtem6DPrW16puTprlgxgKGZwe6vp1Av7wpOUsZ1NvSo4mDtLoZgjU/gWqfZauHLtcZNos8nyaWRcYX2zLcQYlIzEavQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Mvu6ADgBNUG/2EIZNDyI90FG8Vc0S52YQyYbsIcClk=;
 b=Jh0G+AvFlP1lcwEK2W1M3ISiUF5PjbG/V1l6PXCVCV41H08O840ftOZ7sl+vBCNTC5dsHtr8G9Yd8JMnn4R+ckDTz6e8aSsAmpT+w0xsHfG6zfjklw85e9TldHefIlMVhZaLZ1e59LJ6aclaWFpMh8auRIFAMLyKFn8IC1/J1HsfAVJ4MCUduR6jKgt0SmVZ9MTmZOHPMs0TQkAXETH0xhw/ej6VCsryi7J/Bm6YaBsNxsIK6x2S1OLswy5dMpTEixWGCZ+9jcPlrDDe+UkNHS0l0+w+TQAEGp0HnW9x3sagECuu30SuD++ovpPA14T0kzBe6sPqs50Y6LReAbFXoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Mvu6ADgBNUG/2EIZNDyI90FG8Vc0S52YQyYbsIcClk=;
 b=YrPmREZVdCVjWUpnHpWfAFPM7By2ChJCeCceJfpVcaSUUWY6L0W052yOI9+zDdmcQzR/yayxsScaUpTDHkouCvCz/unkFAFDqIcuXSDgiiSoJpIpEC2txa/fm9DIOQr57drZbqyFaUd2aMnS5Ye31AUFV+cYLugu/PN74iPtTr9Xwu7C6E22afK/55qFmeaY8yZ+tOM+DxZhP588l/sYE6mOC31ZxhIjOD57v8uB7bKWLnLHBfclQ7wiXiOdVGuIcmxFlF506V50UEi6qTZrf0BaRdWKWhc/zs9yLuOqq9IDOZCwdkAgkw+8+va1kmf2Ex2zKG/b/WB7pOIW7gs0zA==
Received: from BN9PR03CA0263.namprd03.prod.outlook.com (2603:10b6:408:ff::28)
 by SJ0PR12MB5664.namprd12.prod.outlook.com (2603:10b6:a03:42b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Thu, 22 Sep
 2022 07:26:12 +0000
Received: from BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::66) by BN9PR03CA0263.outlook.office365.com
 (2603:10b6:408:ff::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17 via Frontend
 Transport; Thu, 22 Sep 2022 07:26:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT016.mail.protection.outlook.com (10.13.176.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.14 via Frontend Transport; Thu, 22 Sep 2022 07:26:11 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 22 Sep
 2022 00:26:00 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 rnnvmail204.nvidia.com (10.129.68.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 22 Sep 2022 00:26:00 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 22 Sep 2022 00:25:59 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Thu, 22 Sep 2022 00:25:59 -0700
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
Subject: Re: [PATCH 5.15 00/45] 5.15.70-rc1 review
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5b238cf9-c969-4cdb-a344-8ce8ef66e287@drhqmail202.nvidia.com>
Date:   Thu, 22 Sep 2022 00:25:59 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT016:EE_|SJ0PR12MB5664:EE_
X-MS-Office365-Filtering-Correlation-Id: 66fb7b02-cfcd-46b9-cea1-08da9c6bb9e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eADPvzY6lbWr/v/+rfGCCnUEbxg8xDteocsVU9buSU/huHu1airc60GKLsc6LpE9PQ2MQN+X2sgiOT/T5xY03yoTIHf9N/JA+oKmqMUb9EcDysk7PKZZj/yQ+eN+pGbUPj1CjiUlfEbINX+8kl+65WDLjts+DckDk9YhfzoCm0sGx/qUbXl3OHHNmTV57ljaoeSN1FNBmemNA3TJ6tsEYgD5WExP7fk+MyKWpnFhdN2d2AxZfQi3bJBFxJj415XUwzwNhuEaiFNKpyG/vQJz1QbF/95baSTThnSaxLANMgAufNf/+sW5B446gSkX6ZhWNDDy3UJvF6QKTrezVhxBzZ4k5u+clbDsjhD2BtXVCaoHYcz3ZLd1h+1virKEfWJGz/jbxr9Q8DanWwW1dr+QCDVVA6lH58B65wt8i56PUPM2L9e6/m40F5sM0VgqINJI9CXA/9u39Y3Gz4Tk1jT43j9zXjLqf1lUhPYb88DNEVLSJ8SbeQ3xP8e6h89tastG5aY8aI+00Ao216R/rATHpzFmWo20VjDgxALCCRUcRtPoC+hb7pXR/dOOsmA4f9LDaG/cK3C5AsPx+Ps9ZX+1EUyqiIjxK6R69nEtr1VUKzViub6pz8gCEWJg/huhLisRKzACbzcR7057w8G54EVZLxcKEGbYSgjEppR+tSHR3hY/IWn79fk4qY7cg/nRaZHrG0CJ5Qasxx4jK8maSNrIy/Yl01n31TlNnrJIyIZfyBc8Ij0x9nxBdARmBL8me19ugNKcFbyJKLe8C77hS8tejyyKYew4djK3P3J4BOsjpd18NpmdqaRAn3SX0wAO3mrFoqx013XH+kHkF80pGAiYW+bRANXmHf6OnYQ4vSIOYLM=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199015)(40470700004)(46966006)(36840700001)(31696002)(966005)(316002)(41300700001)(70586007)(478600001)(36860700001)(7636003)(8676002)(82310400005)(5660300002)(40460700003)(40480700001)(86362001)(70206006)(356005)(4326008)(7416002)(82740400003)(54906003)(8936002)(6916009)(2906002)(186003)(26005)(426003)(336012)(47076005)(31686004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 07:26:11.8529
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66fb7b02-cfcd-46b9-cea1-08da9c6bb9e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5664
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 21 Sep 2022 17:45:50 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.70 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.70-rc1.gz
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

Linux version:	5.15.70-rc1-g16d41e601858
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
