Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602914BF7D8
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 13:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbiBVMIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 07:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiBVMIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 07:08:39 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24139B3E46;
        Tue, 22 Feb 2022 04:08:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJbUO85q02/iKEo9JOslYRcBmjeXslptAkQFhRXzfQjICLloF0sUdbCoV5zO4J/66vr4Of2GeTYpVWMa5vj/YhjIM1iD+gvFFTyAEhMmWxNPdN8m+7RVCvKgYue8DcHNX5mdyLc9Ru4ZJ/wGykw48mzLs42MfWGL2Q7Fg/X6cvMq7hWs8nAzOxwiW1pk6mudUw8OIAu5ZZepUNK0DGKUU/IeyznHeKbsDCKwYWgfxAXh522XNXL3FMmljxskBql0Pny2L7YtQnDq9MXJJIOzfPEv3GjndO08kdgT+fZQdsllk9OisZPpJY6JIcKPxQWnv4ggs4A9SOoN81iigySsiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fCNuQDMgVO4XFImGheIUk6rPW9jGsYLQjfNLzmoWGA0=;
 b=UX/eC9+NL76Lf2VVwGkoCvTAwOOzMyK6bpn8UPAY9H51TcH89MnH54do2kNwAEz++jJjxI2HTUOXqnD0534+Iva7oKN6CwMOVDNrBqCaEpqXucnNNsz4X9Nqq55z6Kc60fM5On9icxfCmjNWB5RbcXm/Uy23CVO4W/Gmw/T1om0HpGzwESYMGXMngwU6ZG7xWzHAEvaBWMoZu+VwBb8qR2Cu3AX0grs29E8JRtjYwnEeaxbHTZRBiyWeDWC99RLU2enZLbIw4MqiwAJ2DsKdNGSaPBorbmuL/jENpbjpskWeEgdEkhD9Bq9+UHL5fjbUI2QvanKDS52CNZ5GsLsB+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCNuQDMgVO4XFImGheIUk6rPW9jGsYLQjfNLzmoWGA0=;
 b=OxmeTBWWkWp5vI+DguCUriSGgDyuWN6+NXpwERcaIjyBKmnW8bdtfN/MOQyqcqjm/AeLM+wN4Xvrjvk2u+h5s+sf6434gNkJoOCw2NaxVWHeT073dTL0vWwLwgQlXiRNmgxMnwwDkupLu5dAZ2Z1VcCE3P5wrWN879ntR8ExHE6gtQVBfmImaiIeJ8Sh2RcEHyR5NGWMJOz/8fq/8ojKO0cCA8bQ1mR7LA9Paf76UUc+gmdVduAzCpeitW4SAh5bjXWAVFxU9+hFI40EnYDyuwC6V/xtXVoA1A8PnN4c6T2PlFFw/Gf6DnnN+teSCSkY09bx/PYX8Fre5vw0xrVhaw==
Received: from DM3PR14CA0144.namprd14.prod.outlook.com (2603:10b6:0:53::28) by
 BL0PR12MB2482.namprd12.prod.outlook.com (2603:10b6:207:4a::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Tue, 22 Feb 2022 12:08:12 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::2c) by DM3PR14CA0144.outlook.office365.com
 (2603:10b6:0:53::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Tue, 22 Feb 2022 12:08:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 12:08:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 12:08:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 04:08:10 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 22 Feb 2022 04:08:09 -0800
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
Subject: Re: [PATCH 5.16 000/227] 5.16.11-rc1 review
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <69ed3efa-68e5-4450-9639-6b9dc707cab5@rnnvmail201.nvidia.com>
Date:   Tue, 22 Feb 2022 04:08:09 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10335793-6e97-47ef-eab2-08d9f5fbffaf
X-MS-TrafficTypeDiagnostic: BL0PR12MB2482:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB2482428840B104965A07187ED93B9@BL0PR12MB2482.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GtLbTDg7HXsrpmtakA7+IDz+pgobMz3ZLrHskBKzr6sH8lO+hbKGf0trL90rbao+7IwxiMVpx+JGr1AHrOueOZi8gu8K7E1/w+z9d5PompmPRvJyMZVAXMHpyaRJMyNMfy7CTf8g/xp/pqHosXcufJInrr/7aZfT9Z599/chrriS1dZBttibiF1b1QSkki4Fqo+jrkaaJk2nisakqxkdlujEIJkvZMUyWHxCk8rTwzCQeUG5br9T9m6che3Oz0Ibxm1Ot+NJGMeulXmpwmJved/Uk52+1qH8cs0xMb9eY2AD/AQTXq8/yeMrh/5Y2+/Usx3nUfgRMHPOR32il62La/tzTYBfMDJsxs7FSwOOIfjzlfto81yyu6wuxsQXAwnmsTSwgmparjOVHaDv1SY7oDuvL5cIDZ9/IuKnDXaku7FLEeJnBDfJW6y0N2KGCCnGt7cx5upL9xkLUfaD3u3KFVKzCX6IjXpSFVRjd0zwI1/eYCgL9GkRvAG138UmRKrtaIkLhj8DciDA9Ju29B/hrqViwrsPG8wOAUrC2cR+1mbgtYYlGQi3kHfii9Q40ZneLx0AxgkiRgsmhR9Zifs0lyYduMwcXQQ0FYy2xPrS2F/LLNsX04Toq2oYh2GB8Pj1k5wtYMp92cS1+ChpEitXNWHqAl7uPlDjYZndRpqLZ8QAgGnGd1Jbv0UCgYjSFzz+JFCL1I/Mw7t2hoNLT1Tl8So5q430Uyzy+1J7VaStnBaqaDqfLtHQ3ZNeOkUADepOEemZQswHoW9hPPY98vrA2mpKFQXMc4V8duKZXHztir4=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(4326008)(81166007)(70586007)(8676002)(82310400004)(186003)(70206006)(966005)(26005)(316002)(508600001)(356005)(86362001)(31696002)(40460700003)(2906002)(54906003)(7416002)(426003)(8936002)(47076005)(31686004)(36860700001)(5660300002)(6916009)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 12:08:12.3701
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10335793-6e97-47ef-eab2-08d9f5fbffaf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2482
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Feb 2022 09:46:59 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.11 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	5.16.11-rc1-ga75faa1f1534
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
