Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97D04F5C8B
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 13:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237962AbiDFLfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 07:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237442AbiDFLd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 07:33:58 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2042.outbound.protection.outlook.com [40.107.236.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F19023693C;
        Wed,  6 Apr 2022 01:25:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsBRr5eR37rveFiJdVLa3tD0f4IKEH+FGyPw74aUqjK159mZv41Svif5vqcIt8NpW36sELCLZu25EFYC4zvKXFzBaKSANH/NY1Ug/eDDZh/3nZ+9KslwrtYtZWZOIwfOyvnq2eds4UDH+/AKt9iDKlhJuwBggHrjdIUpnw8+X0X4LRXEdNAfd/J5L7p/gbFp3tY0ksHizwO8Czry/b1t75rbQqzmlasd2lF2pS3O2k117eINodfO53rJBavr5H6BUHKT8FnXX2ADJ+H7V1EIGb8J27UbLgFHSFlqX3DRKA9/cPqVwcpccwx43EPQ2Wi0alIKXWiAU+zlDJczd4lEsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1YQ4aHByT92k9GoFA4s36sTV85z6wbTI3Qj80u10IVg=;
 b=OpJblFRwD/0nxaLkHchgzzcziq4qDpzyguMXy7yEuanmU+lpMMop3d/lo6CdOr/JnCTh8ofWMt6U7Bn91HfOleKmw1cogxzOzCHig7xq4a4bmNOvRzvm9bw6bz9aDuoM9h/VAHNAVS/673tWP0hfyzYyNXJZh6qewq4phVGMnNHCT7CP2Sb+XJtLAnZqJVi3tzMGz9P/vyobupZcf0Ul3p6Bxl7RaKW0uE9LlO4ju2PwCFLoLBkCiyjlFcYVK2kAn0Ga8Qf0E1ah4h+W0fCMmrw7Uv7jHV8hhvUPZhp6rFINn+MxXA0HgAvBVT62hAGT8q5SM2n5Q674jd7nQcGFvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YQ4aHByT92k9GoFA4s36sTV85z6wbTI3Qj80u10IVg=;
 b=oV/p+OiAxFeX7gvg1Kh5orGhiXALfin8MLksomgGCV8DC8S0vDmavIRA1QuAbh09OxY/aVOLfoOeVEFUqZma4+azl817oXO6/WY9dIzRjrhXqw59M5NAquZyNitxX7qqYqt8vzOZ14YwLMieH7Mv48+8sfiZjAlFTKExY96BUQibvv3w4v9zWZqwVSET239EIlFZbQZWfmg2SQs1aDLOlwXNYhCxjwEyL5CvAJIumAAKV/mtZ+w1fGeD6k4xjFtTBoatcULfj67pESPdE1If8V3HjpUhiRJqaJWMUwQoR/vFsEC6Ktbq9W9E7vO9YAUYSJ3GOCRnjPSwMSDcN8mXFQ==
Received: from MW4P220CA0023.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::28)
 by DM6PR12MB4265.namprd12.prod.outlook.com (2603:10b6:5:211::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 08:25:27 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::ba) by MW4P220CA0023.outlook.office365.com
 (2603:10b6:303:115::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 6 Apr 2022 08:25:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Wed, 6 Apr 2022 08:25:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Apr
 2022 08:25:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 01:25:25 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 6 Apr 2022 01:25:25 -0700
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
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7135dfaa-2128-4ebc-9a5e-21f6e2b46f05@rnnvmail201.nvidia.com>
Date:   Wed, 6 Apr 2022 01:25:25 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 033b77fe-10aa-4140-403d-08da17a70102
X-MS-TrafficTypeDiagnostic: DM6PR12MB4265:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4265198B6A988E3229DD1C2BD9E79@DM6PR12MB4265.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u5FxDV5l9Xju5WlZ0K3C4T0BFUPkDaTV1p/bgP6Ki3k8FxORPPNzVTXcUyxquLL76rqGVWPOqZO7Q2hwz4WJJph5sx1MCgNpqFGqH2BG2LOcILJyFgj25oSkBsFbbta3oHas89OxHOW7SExr4qfSsUJKvlGTG9+PDMom3rWXdkuEHYLrxlAL0y5h/4ETnQ1u3LlTh84KMF1Ln3yhg8FHd47W+OE5MtBpVYeoBRhh48M4OuayUyUls3L7Upj6llTC3cr5RuxMqMqogLMjddSDOTkA1wibUHO9Rs9V39cvuFSxo7z5BMoA4mfjP9amegdGJl1e9JgzZtB0MF3k53kFhM07R+CxRQp5MGQEQ+Vf0w6gZymq4YFlO+gKnc2CcIL4+0gxzpb9IeBvtYuLsFehjaceUJeS/7YRuD0in8Crz7h7lwyUHhQLB+MWFElaWqKT4S+KC4YTeAw7d/4ViLSOEwI88wStkgIZcUCAAPTNihaSKQhTn1VIF8VBJAY/V9RSkWuqzxF0dFbJ+vvQn7o0mpu5U0xX9QEcsBuISmnD35LWQeMS9FOPAfBkclPQm4seDX9DzXTTrv+5mbP9/EZykIvrfHudiuG4hvAudJgvh1iMrn/7jviQb80dQ64CDuP4ld/kNnN7svFbzMOtK8ammvbYn5FUNe0rBYi9o1AEVsCG58lR795EMuYkLolrUSWm1K4dXjW09N9jUN/X0hmpURmlztb/rw3busFEc4GlHRiChip+Hgt28NHxPRDlnteQYF0PeyCmM6cF47Kmwc5g/plfgVb03dCQ/dTrgLM2CrY=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(6916009)(316002)(966005)(81166007)(86362001)(508600001)(54906003)(356005)(31696002)(8676002)(7416002)(426003)(70586007)(47076005)(82310400005)(40460700003)(8936002)(31686004)(336012)(186003)(4326008)(36860700001)(26005)(70206006)(5660300002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 08:25:26.9154
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 033b77fe-10aa-4140-403d-08da17a70102
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4265
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Apr 2022 09:24:54 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 599 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.110-rc1.gz
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

Linux version:	5.10.110-rc1-g45fdcc9dc72a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
