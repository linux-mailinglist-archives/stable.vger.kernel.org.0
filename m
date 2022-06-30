Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0DAF5620E9
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 19:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235682AbiF3RKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 13:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236123AbiF3RJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 13:09:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728BB33880;
        Thu, 30 Jun 2022 10:09:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=euiQAOA7H9g7grPeLdPNzWdZv9hEI0GChSoaldbGGkB+NNw5y1GJrNfrcGNrNiO/PX8Kl8p06wrs3/6wn3LUXrdLVmbBbbvurP/78vEX04WB6LFp78ouo8Ylrcy0yMSmASv67swAaLIm35DuyTrqy08/2+oz4jtImvHcKZt3iql7y4Nj4v1lQpgB/59bnIpFeEX6OCSC2wHIjIZxbCVKXTEP1i6f87YhZdooiQIPxBA41vi52lpJsnE9geBhmtqsW1SRrkWyy7qi/PuZY0SMC/ybfdiDAwMiTySQzTilWFsoTf7TU6deS0ykGT+aYCKYUGXqUqznNwknOAmfNi15kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ovbxOBNngsHV0BzvU/EbMoJtPc1B6phTlhzI+0q2OB0=;
 b=hYMuRX6BbsnaP924GvOcVFzKhrHMUyDtUn8mQZNcvkeOauu9LJUfr82ZGBJC3tuUQodcdB2vEcpIh6U3tvNa7c+e63sn4c3++BsghlVfORLDcBlfqF4IERvFvc8XCmSNUr1QtKUKhZ5Sh2GIE21zwi1Nmk7qBHV1uNqvqxhBj+XEO7JjInxP4OuGVmZKuc6TUowwbTnvq1qwWe965IZk0YwhNfHiY+qC+PYMWcdi2p1LfXUITlgI5TeeRKGsDriUsTJtl+ZP2XnYma2htqn4X4U91L7qeGuntaTUt3gMSg6NFLvX476Z4doKeOqQR31d9W8irLHDoOJV1ewtIEGXsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovbxOBNngsHV0BzvU/EbMoJtPc1B6phTlhzI+0q2OB0=;
 b=q7L9XEj0U79Ytk8vL8df7yxGYZdouMYENspneersNbGT7kEez5vW0vwtymGRkVF8VQ7cC34xLKhFTTGRzV99ZlZmXrM7JpY3HEYazHnzjaqGuY0PratXtTFFJMwD7P1HgrKDElh4zbQYG7byE7kjl42NPibIxYjitcIOGMJAqoBra+z0YYzHAXXulkA+FPbahmDlhBYnckVtp/94o4s+oKaH+yEqGL9ngYWCuRj0fvTy6T38mkOnrAv4L5HGBikxFFLg94r7KpqGA3kTui9VVt/+UC0tfLjnA1bF04XocttCrovgbFpL5w8/gat6Powv4/byuuWeGAr2J25BsMD7+w==
Received: from MWHPR04CA0070.namprd04.prod.outlook.com (2603:10b6:300:6c::32)
 by DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 17:09:57 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:6c:cafe::16) by MWHPR04CA0070.outlook.office365.com
 (2603:10b6:300:6c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Thu, 30 Jun 2022 17:09:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 17:09:56 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 30 Jun
 2022 17:09:56 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 30 Jun
 2022 10:09:55 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 10:09:55 -0700
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
Subject: Re: [PATCH 5.15 00/28] 5.15.52-rc1 review
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
References: <20220630133232.926711493@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <188bbfe6-53f0-43f0-985a-cf0f8be43d02@rnnvmail203.nvidia.com>
Date:   Thu, 30 Jun 2022 10:09:55 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b04b63ab-0458-4777-abc4-08da5abb5b92
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M3VUPw75GSes7+P7KU/GpnVSkhEHY9WIb/c5bCcL9KTDlPpXGbpEo3HHVYH7xh8XUTDcN0qFv3h0Z22sHNmzA6f7Y1rsnSIDWLWIS791PJ5EYYM7o/JXsrRAPddzotibiuOhqBBCRfWjP/mLjKFUTZ2W9CNtASvSUoWVgu5PjnuPKpGrf+qvMN2UFg1T5acf5ilZLRpCQVcvqkrZ2iQ0Fiy1XUXeVjptVr356G168kN2PAiH1aCaBgkeAolth9DB9Ms2zz2IgIBRCapMIyQHTIVs7qYeOb/lAncnTn34Vg9fa4yU1ChawU9uUG/ljYOweDkVQIG9QMBlrbRxgar4JqmkVmlKF7Jx50tm7aerDmXOLWzpRB08deyOi0w/rBlm29HkwVYPKz+ph3WwjNHqxndxyuIKNWZdvhIMO+DE7LBQ4BFeJN8SH/P64mu6toDMAcDdDRdao1mwaUQw403cZ2tm04zaIIEVY8PBJZHxVqtGj9AzZ/j4UJBhGBctgPy/C14QpE9OxwJ7HjKRNluTRUmzBU7YRv44E9mg5Q0ImH+phqHQNmU64Z1tIv3o2pPhKhKXwiSu2/IboA0NXAaWlM4Tncd8YKb/2X84VqxNak+vHrhnnvqY6fTp6kI7oxR1SnyEJFRBsjaQM8aVhnbFvO8UHSxRsYva3TZmr2lSUbrGDwf45BtGobhyHi/DUHADOmfdlWnlxvPJPIkycmKLJPLq+Wk6ZqMmLdjehzFlqjf7NQdiojd/wrdn5AWsjL6ka5mav857iSSW/mrBIxd9pr6CI6k8fVck5xp9fQg9yIOAQTticRtCXiBhXC8Y2rqf+jgh+mrKywVBToU1sKnPIEF67Fd7uykQdwquaLwJyid87NuOOd4Of6hle6lY8dCCEwmGwkyGmnLxOatJkTsg6GmawZQCErRxt9GycwWgPVT6BcfAL94ujyCpFjJsLLaU
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(39860400002)(346002)(46966006)(40470700004)(36840700001)(82740400003)(54906003)(356005)(6916009)(82310400005)(4326008)(36860700001)(8676002)(70586007)(70206006)(316002)(26005)(31686004)(40480700001)(81166007)(31696002)(40460700003)(186003)(2906002)(86362001)(966005)(426003)(336012)(47076005)(8936002)(478600001)(5660300002)(41300700001)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 17:09:56.6975
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b04b63ab-0458-4777-abc4-08da5abb5b92
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5040
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Jun 2022 15:46:56 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.52 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.52-rc1.gz
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

Linux version:	5.15.52-rc1-g49249bfc4d1b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
