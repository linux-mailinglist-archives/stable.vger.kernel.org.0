Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F15A586CC9
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 16:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbiHAO05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 10:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbiHAO0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 10:26:55 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2042.outbound.protection.outlook.com [40.107.96.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0043C2AE1B;
        Mon,  1 Aug 2022 07:26:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3MWwTUu/DWpnnFCpX97EaUMGaThb+fFEERb3vNA1V8cNjK3WzwyEf0NAUsO8ISrpOxwIxa3+tkM9APd8WmtlQ1h34yL6mdzN36pTUJDlrkwhaoOc1FKiVlPGGgpseEqB7UKr6YA/E3iYaaks7Su9gLez1un3KrWnYUcBAlCTnu/F34EOfo8EugTieUIzkZWfxpRAjI5adLPwuqkuxwKjJI3J2axHQw5ULI7+aPjBd+ewRH1SPDj8Fl3mer4HLcI2n1KxX4O4UF+HBKdsQCo8cLwqbPPfwy759vD0D6sIIfJhLqwidvonZ8xPBkIns5KW42nWxRIguG1aEG7qwGrjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wztB11z5ew1KlYbYupQJGhsPBlqpPOJhdZsVfSKZgU=;
 b=VBRBvJcU7N/BvenB4GkYPPGSiN5WaMIYFP7bve2u0W9MX7OMSCgbKlUcy5WwJ4b8SKM+nENIqY2CD7V2Ornl5RLPKpjaEkJCjoo3qgD4smBndB+6jztTJMvKzbbCunPPkCBdIdFDLngzLXMlN7lbXlex76LApvIhxwt8NDcPlHlL8tjR8m8XGHcge65WEyaFj90GjnWXZ4bibBeEFZPw+91L97EoNWG7QIugynhlFbEEOuRqIci5dse32LRVEN/qDreY/Q4SD6q7/AuAqStUW3qNLxmnMA/XLkI/obPv30WJ7VzDaN3Zvfjc+stZZa/wj4pWICkOLobrcODu01K0Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wztB11z5ew1KlYbYupQJGhsPBlqpPOJhdZsVfSKZgU=;
 b=eg1qvuOt8+FuS3wsGDwil71qkz7pRxveEzsGeL5L9kOj8tWDLqS1Oe5tBukXUo/jkIOVrexWFa3JfEl4rXMFAEWmmHfCZsYbuaA9GAG1y3pC0GmYFGJ4zGA7VKuidHEXUm1JCkoZwzldzkXTx4YyTPdrytVrGlKBoWczr7Q56bLOmumzuusIJ63UAOyCpvGrEZnIzQGF5li60xR3quebo/a0hMXAjQA/EGMp/QYucQ6nOdEOdsl7hamw1oOx+E3B6k8JDmhTFpJ2gvCERlTkjsTels0NJWE8R9kbManUcqfXensYeiLtdRTH56l/BQvOd6bsmshd2CtNQbIZ9oA/5A==
Received: from DS7PR03CA0028.namprd03.prod.outlook.com (2603:10b6:5:3b8::33)
 by CO6PR12MB5428.namprd12.prod.outlook.com (2603:10b6:5:35c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Mon, 1 Aug
 2022 14:26:52 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::48) by DS7PR03CA0028.outlook.office365.com
 (2603:10b6:5:3b8::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24 via Frontend
 Transport; Mon, 1 Aug 2022 14:26:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Mon, 1 Aug 2022 14:26:52 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 1 Aug 2022 14:26:52 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 1 Aug 2022 07:26:51 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Mon, 1 Aug 2022 07:26:51 -0700
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
Subject: Re: [PATCH 5.4 00/34] 5.4.209-rc1 review
In-Reply-To: <20220801114128.025615151@linuxfoundation.org>
References: <20220801114128.025615151@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <df1edc65-25b0-4412-8ff3-a88fc440c113@drhqmail202.nvidia.com>
Date:   Mon, 1 Aug 2022 07:26:51 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a2efe1f-e17d-4bf3-153f-08da73c9e10f
X-MS-TrafficTypeDiagnostic: CO6PR12MB5428:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xuA5b4MnliOyy4XpX1wj/3tUIIfO0KW881e545OqudZbOXLQJ8Jz5X9UrlWyWay5b5zXGFvJ06Jg02iIGL2E5By3saSt/jn6/QsNUfzYIIeFCc7CyIWNGW1/c4YIj3Em+RaZ8WquObnTBBurKoRDAqYmw+Df34sHGD8OMvexuyNvWBDoI4ejCLjpQuAQdFzTzIGkEth91AbEbZCPqVbzjFhQGF+qPvUbMHjAUVtWhIP1T6fHtrdd5udvH5mLGAUfbUZ88oLS8ajs45tzJcegszjgRD72BLokrCepacnwGC79tFQAMMX82M85zgSgEB81lF9seWJaxOoDADQ4KLlR0beldBDFsj1qzYCErofvN4BZ5+yuNcBRzQaByc+Lj6AtWpNGE6np4AlvXbQJPxAQE0sMixRcNRZaX24Sm/IbEnRTg0/OyDsWtULY1l2axLJhPr7sbmZaTzKN8wbRGcJYL/mK6gzi7i+NPsm8FLWu4LPG1laOrlthBGLkP3qiv8i4fZGMUWmvh5/UfWT5NCcJSlbB1+0C5O7J2RQHfHad0II9M6plgMe4IFakya1alep+NpwVKD4pesIOnCNkoyDLcL3kML7Z9+kBO3kUslulFtP/g218YFbYVse4JS41WMPq1QqnJTYR25Z9r5pQLEGGFRDBbTz3QE0BSOEdFCqPqqizW8KuzHUI8wmLI0iuW/nIosMJ6HmfXQxrFLdJBUxUaKa5WG2Ou8CjOYWa1a7Pkger7CEjw6vjbF6wbGI7WFKGIvr4UyW56pGqf4t+CnGrcjVfX5+Zdd/4yE/ZgskJUDUWgyZF8uSDXy/gyN+WlEcF9ZPdTraWrkBDl61sekNAntDmgfJBQOcrzZEdcZFkOtt8F221Ni85PXfhZBoqwxc6nLben7e+uiD3R+gkDiTE+N1dPhjSseCUJaXkU7kZDGE=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(39860400002)(396003)(36840700001)(40470700004)(46966006)(47076005)(26005)(186003)(336012)(426003)(356005)(82740400003)(8676002)(36860700001)(81166007)(8936002)(5660300002)(7416002)(4326008)(40480700001)(82310400005)(2906002)(966005)(41300700001)(478600001)(70586007)(54906003)(70206006)(40460700003)(316002)(6916009)(31696002)(86362001)(31686004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 14:26:52.6579
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a2efe1f-e17d-4bf3-153f-08da73c9e10f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5428
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Aug 2022 13:46:40 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.209 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.209-rc1.gz
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

Linux version:	5.4.209-rc1-gb48a8f43dce6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
