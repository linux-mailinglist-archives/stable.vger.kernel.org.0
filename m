Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7329D571583
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 11:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbiGLJSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 05:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbiGLJSa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 05:18:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7411A5E7D;
        Tue, 12 Jul 2022 02:18:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJFDCkiwXxHGkwYf8LferMyO/pXTjmzFKfSgmTMZOUCy93ir30Ov0jPQWzyTUDkJQTtI5CeFAMT7KtSwls1mQN20Ft3gjyF2fxKflipvR+I1TWs9q3tK9Y7nVTbcSgf74zWniDRFumXNhUdNyirGo+e4A0/CN6W36SLIl2JlWfOWjfd0HqVHJz4ZSCnc0sC3gWax/51HTmEkxrZGXYtK6d7dnGIu8CgP9HmGFvRMa6lYgfX2GheIZ/RtAg3k9WdEDvxbBfs5RsFZyhQ7NGebx+5DVEyCdoNxe8wsIL5wAfG/q7BNSJA0BKFdRVtdBvP/T7fzVJh0Rd9TKPdZVqo/jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BiPgsb3VYHq+UH/wBEVMIwCdsaLqlaRuT1aQEio1onA=;
 b=NxzGW3ys2RCyn9Crdw8O7m7OL4pT5XCx179osf0RR85ALJ3exe7lPdAkveKgqqrs/GzHGrmzZ/MG3ld1oL3MoWHA9iF+IinMwKRGboDXHEY3X7NYEaa9CyCGsQMWbBVKkXjwc92NFlbofyvxjioo7YlwHYvS/5JMoQE6VkLGq+6GwiGmO6YrvMYQQBMKyMv2plf9T44yNshKyhZ16X0uaPPRZOBMjrSee2tmrRi10/4FD6q6Js4V1EBuHNB3v3/DDgKEex5G0iHqxHktNqMm7MgwPGIUzP7wHnNGF6Cda3TbUMXl0bop/zROWwUFW3oxVBT68qSH04lE5Pvci/of7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BiPgsb3VYHq+UH/wBEVMIwCdsaLqlaRuT1aQEio1onA=;
 b=pA7MWoVnTM1KEmial1Ofn6azG/1jkzZud5SHD3ROm9nBsMJZRQ8eX1HwBkmB4bW4RnSNzBJDoepiqMIKAMYpIAtaQ7ew50IcAAe/rv5pubjRozvTylYlotP+7HdAVhUgFD1N2WssEUSyxQErmKLIyF4U83zCzX6D5tsmjzF6mCZx1yu9D6oqb3B7cme386lzyXfoxc9oR789yOiOccy0Jyomc8BPUlnDqUpkw+KbS78eWt90SEOSz7PxGM5PHO2CZboVzun6zB/pzT8Ru3MKOYce0X7kQRWH/PnthNFPpqbMus8tfBC1rfEkyTp4DFtf3zPq0W3Mra7lbHbIgb7hjQ==
Received: from MW4P220CA0002.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::7)
 by BL1PR12MB5708.namprd12.prod.outlook.com (2603:10b6:208:387::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Tue, 12 Jul
 2022 09:18:27 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::1d) by MW4P220CA0002.outlook.office365.com
 (2603:10b6:303:115::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26 via Frontend
 Transport; Tue, 12 Jul 2022 09:18:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Tue, 12 Jul 2022 09:18:27 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 12 Jul 2022 09:18:27 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 12 Jul 2022 02:18:26 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Tue, 12 Jul 2022 02:18:26 -0700
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
Subject: Re: [PATCH 5.10 00/55] 5.10.130-rc1 review
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
References: <20220711090541.764895984@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7da4cb1b-2199-48b9-951e-fd5f4c5fd284@drhqmail201.nvidia.com>
Date:   Tue, 12 Jul 2022 02:18:26 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40616cfd-e454-4fb5-6210-08da63e77ae3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5708:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: or+tWCAA3NqR0RZ4G443jIzgixbUSZ4B4eX4tkaL+dO1kY/cdBamLk5SzZbfGW82NDWcKBqnN8HHo9t1brkjESRhz6ozTOyg26QirYDs2iEOxJDpRYpt9XYYuMRH6PCdxOX6NQLJnqxDMGaLs+RaYRZ1NI89ilcCf7c2cd9jY3kvGKPH4OyMcwQQzr8SiuyVcwjsr3YzUBim/rphRXRC5vtfWkPoahfeJqCqYBw0qqikuL5EsKr6arBZ9T17vyEScaNDXNqY16oeNRfHaPIYhFNZOEtRXVC4uNTP7hhhHve1tOYdpVPbxN7txgLKcsKdX2LhepAOZuWMftwz4G015Uh3NfdFafe2SFnsvSXMbB5UzUwNm2RdD6EgqtTdyPDHSR0j66d8VtIdX9iH4eoppiHM3MQEiuX0cph0R7hWOHhudyp7GXHqgT2kqevPhJUEjM75palu7DTDoWUFTBazbiClsVnw4HvxWTWJdIIDoNO4psKzOuEkBLj8FSQN1EDasf4xIgreqJ46VHFEsUu06ruBBDzcldk6Hze5G0CpVrR8ZhKEhnn/DhMm20PX/oorAcvfqscMDE9rXz/A2Tc0gmRd6rUtCB2C6xHPlNhjK6SyeRhZAYQuC3yvo2xdT9WujpjatWRnr+rb2QA2XCYzLeY0SYiOf2BLwg2El0LHTwDJwZ0PzlwaYLqt+c1MES0zhimn8Hol/ptZqSGs4yeqazv4JfMIWop5OsJS+DK2tm2K2pTmtqO2cc4rI9zGJ0c/o/EoLh8sOwPyiLyg7lekRtXbeCXNuq2I/qEFMqbT1a052+Gk0c5V5MDIAOmSRTIOjQ0I2MEVN/Qjx4m4TUrT4gekWSF1z4/OHZWkXrlaeF9XB9f7lQA9vMV9EHVjMzyYNcvFIgbUJjQp+bBTDf2lT1PDmIWAmewIEoTcvo13P7Oj7bT2HrZnPjG8pwG2zAqn
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(396003)(376002)(40470700004)(36840700001)(46966006)(2906002)(40480700001)(31686004)(26005)(86362001)(36860700001)(6916009)(54906003)(7416002)(40460700003)(426003)(186003)(47076005)(356005)(70586007)(82310400005)(8936002)(8676002)(70206006)(966005)(5660300002)(4326008)(478600001)(316002)(336012)(82740400003)(31696002)(81166007)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 09:18:27.5570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40616cfd-e454-4fb5-6210-08da63e77ae3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5708
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jul 2022 11:06:48 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.130 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.130-rc1.gz
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

Linux version:	5.10.130-rc1-gb344d768cea4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
