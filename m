Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A4F4D11F4
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 09:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344925AbiCHITy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 03:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237521AbiCHITy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 03:19:54 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2073.outbound.protection.outlook.com [40.107.96.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AFE3EF3F;
        Tue,  8 Mar 2022 00:18:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kG68uhXdGbYli/2+8ioouDIJwj59MNJb2ip1AMkkYpI6XRv2q8TjSaj3Tvo+CNiQ4oKlKOUgaNuCIOeK/817AlFZwq+f27y7xNlEtE/Ef9S01zFnxweS6+xtHnf0xR/kQ5iTMFBew2qvMfkXPgrgHSJwQiL6uflNggEhkTJ+UT605BDJmvDExoYwK0jSnFj50vLUidSj/sTWn0jT4+aeROYOYykCX0v4mdwKOYs+cvtg+Zky0xu/4r7f/8a3trzcFpI1po1DObhO5FADXIR6aY0l7GkrHqhb5mW1IbjcIaVrnQ06vLQj3sf9SU6vnSMS9gPIyPoLEIzwh54AWd7KYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IX0CebQkCRrV8lGCUJVaKzv3Vaa8rTxtjIk3vrUQCDM=;
 b=Wy/QkkHLeiYHHCmcwJmz/Fo/wC293QgRUqL+cS/oNUB7Vf8E4X84lAKU0F7rMl1oIIpmlp/HWKWC6I/yzuIV5qvTXBmrdnWgN24KccC73zEdYBwjfd0ddBEC0T9HSw5BNK3cS5knWWbuLEAt7gyKMAHWOBX6dEV1xiE1y7QcbdKvw4dgkWWi5JeLgBZ/zLTrVV5DNLFU9ZbP/lYuHAZOxKiFwuCOJ3VLDJP/iHQG3orH3sykf3GVtPEouZMPW4/xlbirA7CqFSOJu9XvqhB2uvluDD+ac5NTbj6OJ5bxU1/KyoXyfrM94MVokJTO44yR3bJej8vj+Swo2FtaMdhNcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IX0CebQkCRrV8lGCUJVaKzv3Vaa8rTxtjIk3vrUQCDM=;
 b=iHxUTsfsH0C2NxuQwqUJ+Iy1NJUnTC0UEWwHgICv4PilFsdz0IcoLBrdtI6GrwK9Z55Gdsb+u1g3xNMIBkdRL/AsmlLYdL0Vf9EDT1qn4Oydm0IfbMtSmO0WxaR9RykM/6v1sa7UMSb+vyYI4djmX/xRKrflH1Szl1zj9dVgndaiw2b5rnRLzEuSaKp2aNL88gJK8xMOJv5i+wSD3DuiDJiWlPJOuajobNl5IfM4JtFCp4aT/rnO5LdAcWUECnFdBiU9T+n93MySosqeSlHvpF300v760QUvFN38H4DdBlbgVwE9D8bqqOFcc+oWMIXNfh39JsmRjpB5NXXwiSnPKQ==
Received: from BN9PR03CA0370.namprd03.prod.outlook.com (2603:10b6:408:f7::15)
 by CY4PR12MB1335.namprd12.prod.outlook.com (2603:10b6:903:37::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Tue, 8 Mar
 2022 08:18:56 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::5e) by BN9PR03CA0370.outlook.office365.com
 (2603:10b6:408:f7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 08:18:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 08:18:55 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Mar
 2022 08:18:54 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Mar 2022
 00:18:53 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 8 Mar 2022 00:18:53 -0800
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
Subject: Re: [PATCH 4.14 00/42] 4.14.270-rc1 review
In-Reply-To: <20220307091636.146155347@linuxfoundation.org>
References: <20220307091636.146155347@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <136666b5-6fbb-4289-881d-25ffdfe59374@rnnvmail202.nvidia.com>
Date:   Tue, 8 Mar 2022 00:18:53 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 253890a7-caee-4bbf-9618-08da00dc49f8
X-MS-TrafficTypeDiagnostic: CY4PR12MB1335:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB13358773B5A7FA3266739893D9099@CY4PR12MB1335.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MruoBLzCJJJtPvUmM/gxV9mNKazGNl6csHRbiDBDwBN/KLClrNuNmj/TELWeu6PRFPH9//llAHXORX0c7YWm0279QQ5ktPQ2rgg6jv1x5KqMuBNSQuxLJjHW2k9PzQtDOdzCeIFWh2myVIt/olmD4krzlr8GLsyvofiX8SY2dEXU9vnAcPhk1TPsUhLIq66jjr/MQ/TDD+A82j0L8YamC8TSJ6P1kIB+9fXNlnahqJDuxuggSJG54XgOrylAvgIOHYvbDO1ByAYZJk9lOk92wp/Hcy9hooZA5/i9JQmRF/WVVbsfTgfUJAED6L6lQgr+R398WAKyR0jOyGw7hdCTgu+ReEVm8X/XIQoRAx65sAhUGG6H77SOyuZXPpo2tOj0fUnVitbl4Sd9pWmsV9BpDYbxM8juu6YyfB+9XDSUDB/LMe/q+P14xkQ8ZGziZbBzOz5CM9tkg8sJhkt065sKXdQ+zfh9TljEHz8MEDy8txYxMtHLlmF+ir+Yqf90JkIg4nfJjit8gJU7J/8DKbWYlr++tesKEgUtqZ0SrEuF2x3os93XbeKiP9JiIb12cWqCnUM58dDAowrZaY7+OwRs3c5WUI0X6nDsTxupJkKbnlcjQ2kaVYlqBwsmaS04Hk0SXtAPBpW9ECIENfMLWKdP9jyFJviEnRNXXpjCPtwKPf9edEMBu6aR3qvnfX7IYZrCLM/MJnW9FV4v0iJctR4+9Uqd/Ce86chq7pBWkycGtODIx1s6LviRDiQOWmbv4IXhzsTpFkh1s8yU5wYHOh0fUbeKuE3x9+BVRtejKZZmb4I=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(508600001)(31696002)(186003)(86362001)(966005)(40460700003)(336012)(26005)(426003)(47076005)(70586007)(2906002)(4326008)(81166007)(5660300002)(70206006)(8676002)(36860700001)(7416002)(54906003)(31686004)(316002)(356005)(8936002)(82310400004)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 08:18:55.5492
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 253890a7-caee-4bbf-9618-08da00dc49f8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1335
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 07 Mar 2022 10:18:34 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.270 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.270-rc1.gz
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

Linux version:	4.14.270-rc1-g5ffa96cabf3e
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
