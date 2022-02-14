Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14F34B5322
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 15:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiBNOWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 09:22:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbiBNOWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 09:22:07 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F17B851;
        Mon, 14 Feb 2022 06:21:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FyXDjIvTcKp+C7JsD8NVxqK27wvQtMli1uZ83sp8bLGFRkWGw32bbO5cye4t4lat0+MIg3JLY3zKppMzQv6lCbICLMIzWMxhG3KX+cv8W2TmfKl8XwhBPFIpSzZD4YJ+5J74BcNoYi4Igp2lTMMbnwX58lkJ1B/X4S8wv6Ug1ta7YiwTVy0EBQhtkIe5mRrYbkMwt5ZrL4EimKz6xAfheQoD8cGjh/e7+Pp7h40arLS0mCicklc+J2uy0+NUgyh/xx/yw6UFsG5FnBGswWTD4SPHXqhYbYLUK24P6wfJ9vqYq9Asz45iu2PDlGatLvEHODxu5XPveqLiTHbtgDvLcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ZIFFI8Sqanp/GvE3YYJrkNXagfYv9wsfR3yFZS0080=;
 b=E7088sNNmrogm8yPEEd3plPXSwCr8Ag1YzHrPzsH/f/MOtm4zvsNZDROUwegqJQp7Z2qTTJS05eaTZFgfHGoHKoQwvYlDXqlcqvYZ4EbwP5lUrm8qTv25w8ZXfie7NGNCfcUI2QNfIwGk/AI+NmfqLku5FumMX+OdJtbHEncj0P7bNvjy+hKYE8X7VVf6thw83JgOtfuymRr/+rw2vI1hSkRIHy6+La8xlFEnY9okAy3q+F/jaG2a//XJAnrArkMmpYh2h0g7tEQKrh5K73M1cq6h5GXEUEoDtypJgYV0CyoPfymJ4N31s/QloPQ96X+Qzm2Oj2xIMCHEkjaLTyzjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ZIFFI8Sqanp/GvE3YYJrkNXagfYv9wsfR3yFZS0080=;
 b=KTaMprbyYaOP3toY7C2tQi+xS0WTX5CWv3dHKAB4LcWm6vzsmsUcioIcniaabTJDBf06tjVxfwjhps+Kq1e7MitYIC1tqe5NTVMQjwyiCk28q2b4UXDwY82PWGOoTOLD23vl+sQbNfqwWF3gQi1bK5fqJtX56nl0VT8gsIdjGaB2QT1p2gDtFALkHh1T6ixSOThfLs7BLVC3LDBs4KhxKzPcSpWQ4BT+BOvdwhPHUSlu2+fLmdFOoK8Nybpn+pAPgjGBZVDqYizEh7kYMFu3T7eC7mP/beKvgxaESDRdz5VHgNXFICyFWfRvRyu6KAT5nsVmj0kyyu8C3ecbn8rUsQ==
Received: from BN9PR03CA0336.namprd03.prod.outlook.com (2603:10b6:408:f6::11)
 by MWHPR12MB1774.namprd12.prod.outlook.com (2603:10b6:300:112::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.14; Mon, 14 Feb
 2022 14:21:57 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::6b) by BN9PR03CA0336.outlook.office365.com
 (2603:10b6:408:f6::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15 via Frontend
 Transport; Mon, 14 Feb 2022 14:21:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 14:21:56 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 14:21:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 14 Feb 2022
 06:21:54 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Mon, 14 Feb 2022 06:21:54 -0800
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
Subject: Re: [PATCH 4.14 00/44] 4.14.267-rc1 review
In-Reply-To: <20220214092447.897544753@linuxfoundation.org>
References: <20220214092447.897544753@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <46a24317-5c4f-4bd8-a9db-b361a9d93eff@rnnvmail201.nvidia.com>
Date:   Mon, 14 Feb 2022 06:21:54 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86da8a5d-6b53-49c7-7455-08d9efc55aec
X-MS-TrafficTypeDiagnostic: MWHPR12MB1774:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1774B193C257E64ECCC89385D9339@MWHPR12MB1774.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SRjUWM6OmbShA6wBByJwhLH/rp4okrsIA6eK5cOVjz5vE9jNK6upxVlAt+/k1hTsBDax9ntIfn0UPf01XF06msqe+dHViaNQW4I2YAxyiT14jz236xgvOlPyR4Q4aoQmgysohmaRmFLvT0ZsQMjNBdydcr0ehkawbrDLZJcj637+fRe9dLyqaodUk/P+JBqy6YhPAZDtCK8/EdCiuwbS9lJiCSvCZQAWMXQC11VyDOa+rGl412AHv24VRH6dvcc13xDbfZG1jhrZue+6agMOzEqN0aUmPm/b4doDN1QGfvXY8m0vcRzEzh7hfqGZKHJEovIjN6AVWfOF7sFmbWoJalaXPGyIzyWUsz3K8wsE4mzKTxpBUYQhKSkSK21W5sVDsa3n0gGQ8XNCY/07ZUUX6dRIggk1NfQNNTkqn6fTelBnhQ5ZKlciwraiQkwn8jbITUvivgLjRZ3xzshEN5KkBTz0/G0hmD4pS8SBuxL23gubd6VVMuR7xIBOL7zYsicad3UmQL4UkXI+I8Pyf/N/svEHKd11N/QD0VaaLwmGks0rNm1TEwnYfZvsKAwo+wTQhdZckbe2dnJYpkhuFd9UuebnQk0kkjRzyHry9Gt8H5m/+F5czxCb4A4HXiNAe+cfmsK6viKJ+QZG7P0I+V/2Uby5Bdek1Z6Q7FoQK48EnYLqNJ819+402szKwY6PY0OnqqzNeMoNCO+K9VjoTseVXqPsjRammwOrn5aHGk8ziQWg3miqsziUnnxCNcDu7KXlmyvs+q6ZlQ11Fp40QVtRSTv4Jg4FlJ/OL0O6P1bI/pE=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(426003)(26005)(186003)(336012)(2906002)(36860700001)(47076005)(7416002)(8936002)(82310400004)(5660300002)(40460700003)(966005)(54906003)(508600001)(70586007)(70206006)(4326008)(8676002)(316002)(6916009)(86362001)(356005)(31696002)(81166007)(31686004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 14:21:56.0802
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86da8a5d-6b53-49c7-7455-08d9efc55aec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1774
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Feb 2022 10:25:23 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.267 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.267-rc1.gz
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

Linux version:	4.14.267-rc1-gce409501ca5f
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
