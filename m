Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892D94C8781
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbiCAJOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 04:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbiCAJOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:14:36 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D367F5621C;
        Tue,  1 Mar 2022 01:13:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZc78aixBcLfMqaBMD6A4xybTxjYsbyg4QuArhDxLwjwJYMqNQhKtFuVvCcFkkBQwaKOJLNE4uBC0lR9QpprPgUJzzaoFGa7Y7llSQNWFs3UQnvb8N9EQJ/+1uVBtoZ70FJGlZKVnIEL4dTPaMXggjUdys3xo9thNZiA+fZXFH/x1ow+dOjL5oSBBFgu9X03KUTF/59ZqpRqMUz9mFHXR+/70hWQOn84hMrRB6/R/0fO1L6dosnLHgJtH0kfeQy+6ZaEFei9VQUjg7zpe445VgRxhr4OYyC3oUFVo+orrEzDjsoFnH064b7PQsy3SAS+FTUrzYD2XCqA5AVvP8hkiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fddRDkrnL4Wn5MVgrxB0uXX9HeSEgttf7bcqvc4yJss=;
 b=hm0C6ebipYr1iylNQzsZyfQgokPHTzxleOlIhtn5vq7WwP7U86oTJDvWb/Dl+oHlKS0Q8twuE+Js7zgbYmzMx6mP3kEltSh0KTSHjhGAbJjbxkXMgQLoMIPeRNavgRmxGBH6iAvcXRD9YqZWZ/PLzTWNUHleNdT0ED3ReLXju8Ldppd8sKyrmb7ceLknmSGg+v05q3VpWjLoOIO56tyqD8Bgdo9slS0r6Y40SnbQ00l4WnYHppYgubZGysAxSVk8YnVWnIw/gM2BkMMoCnakOlfv07myD9HzicP6+R9qB/v6e9bU9aWoLnWHf4ZXfBDZJd/mWkUPdYft0Sb5vnU7Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fddRDkrnL4Wn5MVgrxB0uXX9HeSEgttf7bcqvc4yJss=;
 b=p3hYJcgmTN9BZo9FAdIqjq5PUR+WNfa8kdQguI7C2nPI+Z9YHOIFkQ+ZaAPXK5RzrI+kVXW6F3CweMuxmkI2NX5yl1hzPRFF67UwiweRCSBKfHVsX58M4g+NIS2bVNS+0J/BagQ8lTN2CRKXXJLtxqbzSGghYWQDfS3+pfe9XB4oRuprAJhHQsakjVAuLkAprnaxEe3BIy30+j8IBO6G930DmwtlbxIarKvxlhHfvniHddCovj0wncvEM0zdHuUlHfOPvjQXrWXIHQ5kaxcmm0FEVy9cn0PvKWmUmneQmd2YuYNfw1x/tNSvamZ3Ig4Nbt/hUeCqTaMFLQmsGX7f3w==
Received: from DM6PR17CA0036.namprd17.prod.outlook.com (2603:10b6:5:1b3::49)
 by DM6PR12MB3593.namprd12.prod.outlook.com (2603:10b6:5:11c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Tue, 1 Mar
 2022 09:13:51 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::44) by DM6PR17CA0036.outlook.office365.com
 (2603:10b6:5:1b3::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25 via Frontend
 Transport; Tue, 1 Mar 2022 09:13:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 09:13:51 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 09:13:50 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 1 Mar 2022
 01:13:48 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 1 Mar 2022 01:13:48 -0800
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
Subject: Re: [PATCH 5.10 00/80] 5.10.103-rc1 review
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e97e98b0-bdc4-498b-b6bc-8a1bbbf44c82@rnnvmail202.nvidia.com>
Date:   Tue, 1 Mar 2022 01:13:48 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d33daa22-844f-4f1a-ee28-08d9fb63cd2d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3593:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB35930719860A35270BD100B9D9029@DM6PR12MB3593.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /PqwcO/VByMw+dzktdyydEUHkjMkEdYxrkil4xO6qthoJHeTGF14WxrUu8R0W1dMEY7J89nPb0Y5ek4GpQUfrJu94z9lA+1f2xle80rzclEassnXierMTso7/MAqGBFDxrr2Of19/0vCm1Pnb7cgahRMX+HwFVLjCxr08u7k4mMDSE9IO4wdPzalRApqHUXXYusHAzsYxzXx1t2ezkOY7Vh15n2aU0hJSxZbU6SsiWIcGqGboFf/FwKZqSfOul9fmBh8VOZditpfTKSqMvWZ86ZsAtkgiQAwiviKSvHXkV5YNyXzUdwiB0jSdXcB48iEQNyOJWOwKUV3J96DRbcj86re/4e6zn5SKb2LDdhCX5fyso8MzT2x5eBhp/lmGuzX+3zuDArbfQWoSJzIQcUDN//Upu1nkwNWDWs7TZyaceU7Q/yoymkcoL3gAAUdxMaMQXYvyWUuxHYCKulcKURY36tht9nUwAMDNmUAc8KWUjTnHSdqZXj9WLQxogvDQUc4rnBCRQFRaT/YeTv3Yli/FZdSwEb+VhUa3OzXF7CcmQ2JzTFAhJA9k5uDKBKaNfRgVNIX/T5n9ckSwXZGNi3uX7DDOsr9fKvbFHYKEHEiPLIyOO5K0dKxxLZuY/VS7Ibzom0L4dCO1Ffhqbp+MtzaC0bQ4Swxfqp0JAGYTZp/6vvhHJP2bCG1zNMdSZyCAluxLSlLZpWU63LpsOuIWguuIqKOjqmMogVKHNh+/MS7jXhfsNdKTcPrtLR4eCBMYoMVmePYfT8cDYjHkbTJgamzaENFeJe/jQrdZNlE6gMM/zw=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36860700001)(508600001)(966005)(31686004)(8936002)(47076005)(70586007)(40460700003)(8676002)(70206006)(4326008)(5660300002)(7416002)(186003)(426003)(336012)(31696002)(26005)(86362001)(81166007)(356005)(82310400004)(54906003)(2906002)(6916009)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 09:13:51.1059
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d33daa22-844f-4f1a-ee28-08d9fb63cd2d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3593
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Feb 2022 18:23:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.103 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.103-rc1.gz
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

Linux version:	5.10.103-rc1-g3a000049e6a1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
