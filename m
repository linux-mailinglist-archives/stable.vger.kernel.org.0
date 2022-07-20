Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4EB57B324
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 10:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiGTIlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 04:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239822AbiGTIlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 04:41:22 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2055.outbound.protection.outlook.com [40.107.100.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A474466ACB;
        Wed, 20 Jul 2022 01:41:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FI+3tzZ9viN+KC3agrtaUfZZdI0N7ccw3PvlwqbrnOPeByQck2Dke2kJlvS7IjutPXHqwhNwaunQWxSktWg8aOHByUr0rmeQabySw3dk82lR/qeQZ44psSDKYYxg8lpJmoPatPdoep5ZODXIAqLrlQGbW8PSGV+KmYkx9L/M6uDSz6bX1zgKbTl7voBSCHDUB9eVayqaEZDepsiMdSXEE9oTcCRJEsYoPNZAYGuke8RJaHWN5sHFttTflLzcscDyIE6EZ1BPrvXaar40sXVN1QD4AIJ7eDCmwijhGaPQsi6OUtS4YIAhZ31r2WiI6ToV8c84XqrPYt/vglgEg10FPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i2Xi3NueyYPFHh5sWMRVYHsz1E2f3CoFQZHK+kJA7Vs=;
 b=RXeohRPs1r2akVi55VArmcFiun86aHLDs0zO/juRtoNcnO484T/uymWOukvW/v932yXn6ahCrjwRF5rgOfxotXNSsFclTENAymcA9aMpmNeRb8dBWAlxzzaq1Pw+oDhcoFBwNkPHFcFgPhMW27ocOFfWM0NTjYl3Cgjq0FgWUkMGbTJB3V/ONKChjwNFC2Uu9TZBnOoxsbM5r5fE3zBLEu32O+s/wD6ru+IAfZSTonuhKWjVth3O5n92Ftm9p7DQ76kto16IrnsUTI8uxpGnGkAVIFcg5Pvm0q2GgL9+JQJCsCrGrxs205usM7rc8Pb5xgI7f2XrnYUhiQeQxa85NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2Xi3NueyYPFHh5sWMRVYHsz1E2f3CoFQZHK+kJA7Vs=;
 b=Q72Va/8VMliK3HkMMVMU9FMFDf/iRcKusoKvvrSUBglVyWClDhWaTDmWjVmzycxr3OAJQpF0NiJnIm0nJrWDWMIkF97mzbuhW7eQ+Y0BucU23m0QDQIoF41DYazH15x2ZAifx8pxQ+DrruQDze2bSNto0mqgsM/eDtKUb+0KlFS0Hkn8NULk4NlJqqwDaYx4HbZxwY6ZouHLZn6Al7U62KQzgPMzNtbS9Rg7tx/gUcybEZHPJ62loTj8PW1SGBYLiW6m0UCw2vmd/XLFAfVmKg7n0NxYFYySVgBA3digF0t0xLvHz18VVuOGH5jx9g8MpjuUCUcVlYR0y6cWKXzvaQ==
Received: from MW4PR04CA0262.namprd04.prod.outlook.com (2603:10b6:303:88::27)
 by LV2PR12MB5774.namprd12.prod.outlook.com (2603:10b6:408:17a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Wed, 20 Jul
 2022 08:41:18 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::7b) by MW4PR04CA0262.outlook.office365.com
 (2603:10b6:303:88::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20 via Frontend
 Transport; Wed, 20 Jul 2022 08:41:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 08:41:17 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 20 Jul 2022 08:40:18 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 20 Jul 2022 01:40:18 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 20 Jul 2022 01:40:18 -0700
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
Subject: Re: [PATCH 5.4 00/71] 5.4.207-rc1 review
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <cb55ee49-9936-4ee1-afee-788a92470c76@drhqmail202.nvidia.com>
Date:   Wed, 20 Jul 2022 01:40:18 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff6c85ba-6c1b-4795-c3b0-08da6a2b9cf1
X-MS-TrafficTypeDiagnostic: LV2PR12MB5774:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4fwRzCV6CwC0W0AmQneVL5q6anEQ6NbnXHvYqsX9hF416RrPTrD64/yphOdd9bBwui6sAjrgomi053Ovd/KJFE+4Br6xtqywUgctaggv7+PB6+OahRkFDhrtyUoQPgAZSmrMyF8SaFTeqC0KG5yvfSAE3Xob7eBfdl1SnV7INqH97oQ4Qlgdh+CuRnJqhKxWK3sGikRSVDKjL7wDNrkbrio8ZJhhspfNish4T/5KeEKResFidRinJJ9CmCLpcNo9hheLHFWW21/NInr/4l3hkAhc+GoGPt1kC4UTs0mRt2jpwMdqT4yaJD/StNMuv5Wem8EMHMpEVwAHmDK0GmQLqESxgl8SJp4UQml9uuKukdnCw3KnUn33P6f+lMVn29VeuGCvkCwuFxSQS6fcMh3J+goe6rzWsPuDp6mShhe8ICbnZBfRv34hiLWY8S0LCnqdPToZwsVTqH/pdcDoZUUiSHgTnwWx/1mTSSxQo3u0+GV77zhpvdyv2mJFl9EJAB7uxGhczFYGlqvPWa9pBKfJJH8sOGZBif7RzBx9sdU+UiVtRt61s5crtvHqt8jjTa13ol/xrlN2dkDDByJz5oiN3+Q6z+4BVmPv1gT2VBHd9XJuZahd7YAGE0/AH82M/nqL93BlAv4gZVtS+cKSpBmBale+i6D7WOacSI/vyTuXMmjq8zipXV73SAo5lU+Hx/9Bq2X6qDxBeQhMujrjsrLqD6qKoAlHzoZ1UjtjWiGFfUwBcU+Bu4mZ+qxjUh+VHHaW5f6NYJF4hP+iyEEAZDPfpEsqoXkODFZXQy8Gx8HP2SNjSrky/l9gUt2ZqvnVM3gIeGzmbmq2XtT5txuztLq17AgXpE3casd/s4k5PIjQa1nYWiL5UjGOSa1JLZRy8VYNO01LawbB/1ZimOY94vPAGv/veUm6wZ8wE9uXCpfJVzg=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(346002)(46966006)(36840700001)(40470700004)(316002)(70206006)(36860700001)(8936002)(8676002)(6916009)(4326008)(54906003)(70586007)(966005)(5660300002)(7416002)(31686004)(2906002)(478600001)(336012)(86362001)(41300700001)(426003)(47076005)(26005)(186003)(40480700001)(40460700003)(82740400003)(356005)(82310400005)(81166007)(31696002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 08:41:17.4324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff6c85ba-6c1b-4795-c3b0-08da6a2b9cf1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5774
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Jul 2022 13:53:23 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.207 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.207-rc1.gz
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

Linux version:	5.4.207-rc1-g0b5688944207
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
