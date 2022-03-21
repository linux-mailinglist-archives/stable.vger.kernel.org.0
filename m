Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16664E3084
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 20:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352457AbiCUTK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 15:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352465AbiCUTKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 15:10:25 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D0E26573;
        Mon, 21 Mar 2022 12:08:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+2xAvHRALUo5WFretrYsOnFIOkicLg9/bXrcuP6OhevP8UIALMt4vzWJPxL+XHuE6DoTI6UxFKA5RtrAlnjyd5mfVwmRq+9SLMpDKrWsDY78REqrjMINWGsmMIsqEh3smZKxqcniDS7E2/fWpbYZJsep7R3QjKxtiRTe846G4IhoF/Smb2PPBhFrYbFFTU5XBYSGdquK5OLAR7pqyXWq8TgOusEIDJ2ZfMI1VPmo8i8EIPWHOADwusJ2wv+bFAPiBzcliGpVhbhBTxdCMQv0WqRWHXUkLGHud/NKk/IeuYhils0OJKjy+YmwALJmM8bf2wKmvVexTs+ZWMcFYXeVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WMzEjrwpi67qnxmSMX+0Q0pYQqEZo2YMmXY1mVFKwPY=;
 b=I/VX/y2UvdLv4mjWNd/UpyT8lMBQrB+z8s+az3hs/P8qGgL+Z6YFdgURHWeeMA1Bo3/f/w2WVuMmRJwgdhJEqxMwVFmGrTov5Lwnm9uxj9QKhy3oehUFFqMjhmlZxof/qjHadAzK+OA+gPRODr4xkCR+YSoOrc8hwY2YkDb4mQuEfUkX+B0fF9+23ShrB34Ht0HAgfg2su44EgW8PrMHUr83Tbi1yn3u/8ofMNiSMoq0sui8CRvNXCMmnl2BOXQ9HFoz/QyIDyl5e/GjEkRimtpi7yKuNWw0QHPBgWHSun9UEACOI6yWgrTw1UZEJyCRQJVEQPnyAXUM063mfb+uNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WMzEjrwpi67qnxmSMX+0Q0pYQqEZo2YMmXY1mVFKwPY=;
 b=hkHTFlK0lkxQy0z4eE9VSy9IhiwJWavysWfPH+W23ibjbvlcJnxCOpivP9GFz6ybT3R+uxg5ZWeR7HGZVXAz0/TTpm8YMok+2g6dofyXCuydZJe9HK/knJeeN+AMi+xwRCXBlc4jn8ZmUNDhMpEmvHSwy0OwhzRBvRpM/Cqn6ov1eooDF7HpSTUuURjgx+YrNKb0f+FCxP6GgFE341HO2kOInWyuS3339R+LQVdoxXYlzqCdaWHiilva8BeQ44cZvCmxOiPm/4m1HxA+LyQ6drJ66IkG33jomtSQbeC4hIBJuEX4ViUKn2v/hm44jGnW6sRNJC8jpBXIZEx9XdZYew==
Received: from CO2PR07CA0062.namprd07.prod.outlook.com (2603:10b6:100::30) by
 DM6PR12MB3548.namprd12.prod.outlook.com (2603:10b6:5:180::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.18; Mon, 21 Mar 2022 19:08:51 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:100:0:cafe::45) by CO2PR07CA0062.outlook.office365.com
 (2603:10b6:100::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.21 via Frontend
 Transport; Mon, 21 Mar 2022 19:08:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5081.14 via Frontend Transport; Mon, 21 Mar 2022 19:08:50 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 21 Mar
 2022 19:08:50 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 21 Mar
 2022 12:08:49 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 21 Mar 2022 12:08:48 -0700
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
Subject: Re: [PATCH 5.4 00/17] 5.4.187-rc1 review
In-Reply-To: <20220321133217.148831184@linuxfoundation.org>
References: <20220321133217.148831184@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3fdd13bd-ac50-4f08-86c7-52a666e91801@rnnvmail202.nvidia.com>
Date:   Mon, 21 Mar 2022 12:08:48 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 513f19b8-d244-4b69-4e2c-08da0b6e3bee
X-MS-TrafficTypeDiagnostic: DM6PR12MB3548:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB35483A5B9FA4B48E3DF46F48D9169@DM6PR12MB3548.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jJdoIkNUvXF9DRwZyJ02Kuijz+vUsrbtJv3/zwZJ5RnuR6XbRdcESgQCYyo8nMAJPFfgOiwBkVl/Q8K+tLD3Ob2z6CwBiK7RgMRMkmalUHF9eStgNXzcuaIgV4yWuBLPKSLflVBhseuv6RQ0hgcAIWgnOYOTi8hMIhxCrRqzeZezLIU6/XU18IH+wr123pq9yENRZOTXX2RvVuivn+4tGuvsrjuotmRCfM8LG0s9YaVvzsCDyoa3KX+7DJWBtFaPpSJlsVxQ1wHlRyHr9v4BjI4B6t1n6mP7lyazF/R9/7lMl7ptibmx31wzgFY7UyAcB4zOkpBnnKOz8t6s2v29LuQZAWkXYsTN2p4Y7MXCggeGrXPZBdZ0rKvQO2gwJgeTKA7Hdl2QlolLrZMz49ACmPqdLoRy1XMAvQ3ioPIv0COINNe8SA0sILMxOVCPGIG2q4EVdWHlEntQVsP54FaOircdH++VSehsXKGiy5UFEBZPtpa9p+P9ZzIwwtFUIe082m7D+WY/Cd3+BlQsaJTfOeicoyAWhiUmh2XNu1dPhEXfZw3Zzqjc0Bb6RmSDzuAW4lWbV/BvJ4clSEkQfWK48WZaW8E1Ir/ju5ZZZNMBQBk20lJB0qOn2a/9B9CkU482RkwymDtLtdP35gjK5oK1szsaLE2xbZstTmYoK7MyXsHYVvFOjfKAQgF20jXcZo/G7oYmxP2EDhG7NPyKMEWvCx72Z+t63ykEFqtemAb0Bc6r3vWOM9MMEfcKWtDpKjmJwNJCBoNORZYMt8n5PPZE1fXbSw30tcwrRSM6L+GnGpM=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(82310400004)(70206006)(70586007)(36860700001)(4326008)(47076005)(8676002)(966005)(508600001)(54906003)(316002)(6916009)(26005)(336012)(186003)(426003)(5660300002)(86362001)(31696002)(2906002)(31686004)(40460700003)(8936002)(7416002)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 19:08:50.5034
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 513f19b8-d244-4b69-4e2c-08da0b6e3bee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3548
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Mar 2022 14:52:36 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.187 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.187-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.187-rc1-g7f44fdc1563d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
