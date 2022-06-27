Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA4755C377
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbiF0Ook (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 10:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236155AbiF0Ooj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 10:44:39 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8251DF22;
        Mon, 27 Jun 2022 07:44:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUK+IgOu8E5zMW2zKDHMU2EqBr9zwPs25Gx1eeNKy6j6uA8xFi10ZjWvvuSKNFNFb5XfeSVSS+ACGZV0PhayR6b2HOnKyZm/Y3DdAUdeAkeD+AaKt7Z0cdsdK3EUuNvpRPr/sz+NGZUOZk5A59h/USTEO8GwNSANVXJ9lS6vOO7vnUCzZ9lsbKUxSj1mX5nLh3/4T/80gkKMRUMqSHEa970o9paQjMU0F9+Xm75trj1f/YG8j192S/w70hYch58A1z8gt9AgJF0kkRBxvxorhmumCV/gnZSbht0z+tudkhNrWFKwm/Js7kV1RysydVAyvChf0oXwjXA2hgkK6xwXfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bqrlPS+nM2AA5VrYI288ihHn8oIHhbnW8oWQGQZUV3c=;
 b=hbxrOKlXDM31cEOrkMshrYcFk7m9E9oqphjDDO5ehN3RbU8Wf4OfMyW6PjRUMBvrXEIdMYs8uFB2eKowXHbXhaaKyW8cHJUj30I4NtI+cUYVa7iXbOmC6U/ynXgj5meQUoyrzbEKFYLiaR7h2hpdHS1dQWsrhD7ZSsvGj0Y0T/1hfsrgRPs6qD9g9GeVJoRSXaLKEy55kQE/+VTn9fw8JFcv4bO6hAxUeNsFxRhZ0e4OzC3+35qzDB+XYRUybKym0JjEqneDkm6lbI8qw7gjYc1Pa+xEG26GvziCsWGq7/js81tpHSLqNd+HOqrk1Fs1xxMgxocXgmUHWdqYpF1kow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqrlPS+nM2AA5VrYI288ihHn8oIHhbnW8oWQGQZUV3c=;
 b=V8SFVTyr1lvv55jodXKqlWhJWOVIWjinQd11YggQnFqResC/Rcb8jhi8bFSH91GBo3CRc0AwlLxLWlW8jOXdy7IsuDWqQhgvqO3gwk6YUI1nCO4F07LYqz1S3dW9x1KlPANWO/6LH3uZyIyWiswNrsJe8Jm5x84bCzH8HUHRCNWHQ6hFOIuDSvyICB7TspNSqVKZ9l1yftiI2NM5WN0nhgX0uRyaYsglzcQXp60ovJQa1kw6MxVSK8SVdEb8A3kzf+qibBwV2D4h//63qWMcNOTzrekkrynQGTzmqU34WJ2SXjyguyn+iSlvbCEnS9hB0Zt0PwdMIoQtMhE41Z3JYw==
Received: from DS7PR03CA0265.namprd03.prod.outlook.com (2603:10b6:5:3b3::30)
 by BN6PR12MB1841.namprd12.prod.outlook.com (2603:10b6:404:103::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Mon, 27 Jun
 2022 14:44:37 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::f4) by DS7PR03CA0265.outlook.office365.com
 (2603:10b6:5:3b3::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Mon, 27 Jun 2022 14:44:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Mon, 27 Jun 2022 14:44:36 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 27 Jun
 2022 14:44:36 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 27 Jun
 2022 07:44:35 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Mon, 27 Jun 2022 07:44:35 -0700
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
Subject: Re: [PATCH 5.15 000/135] 5.15.51-rc1 review
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <df6647d5-9432-492e-b4bf-85f131bce801@rnnvmail202.nvidia.com>
Date:   Mon, 27 Jun 2022 07:44:35 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7d1a79b-e568-4979-95a6-08da584b8ee7
X-MS-TrafficTypeDiagnostic: BN6PR12MB1841:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jTED0E38mOWjG2JgT1v3+wzL7rNuGoDO/24uY3ip4Yof2ATTVUNoO3RBjwgVPIsMsHx51vrLhJH9WzQjMwmr4wz8Gv/rZP9Vl6n0sT46yiDG64OJ12gDbqp0q/ojZvbYR/XzlmOdMhZnZdc6jJr9FkWNdzThJrPZMselrEmTkBgS/828tr5x1MleLyNNGiH0t3y7zkKyTDvQVHRCV7ha49GSJefNPxvS9R9P9yqGub4j3dDTIMROh08OiSri977AZMr9aUhCifmVBC/PfPtg/igsPkGfaXZJK5gKuAPUrxdE1ePYDTa46O7jgUytGa/N6JzJ0XICGBRVMmsJTgsSrIWkqwAFka3eV4TGCMq01olIFfIzGaKmuwEE+notyXXmJUJM7URjTUHHlIvkbrgjK3SjqzUYB1wiePUpHEY1GgfXW2f0Pepljw1T9hs/MHmmWR9RfnWqy6m2dCzVt1NPbkFNMOSqPiqI1yE31pMcqYBoJ8gVdkoT7AkbtoSwD+8X9mtD/txmbJ4wJjBZ4FY9lN7mCIDGTt4Y94cnDGSNQfArbCFEk4nbPqBDebQLbY6wMhybAiwlqWtMFOd9fcdh5/EzC3UkEL0m5ApkELDsA400ofr2VjBElugQB51tCWgCn6McLAy/E3iOJnhpByX2xrFV4WuJqdtv9paE/gwjrpq9SZzEaYuAXLlw/Fnvii7B3auGhwsB/wsLvIqpyiZ8YqAHo/PRalCEjR7New7qjfLxKUeJ7OrO4KSvU7EpYegMpe2gv/C1DrrIKkuq3QPiTIEZN88U5f0V19on0uXJ6WXIVThhXjKZHY58dJO24ek9CUsfooOcvMva0n+cfO0zg1D+8wxFla/9O9LIENc0QRDOndAmU8FK8SySRdwc0vmNsaY7+F5y5tAdVBMWKytgjgnrYSsdY/4mpan0tpJtUl0=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(39860400002)(136003)(40470700004)(36840700001)(46966006)(966005)(478600001)(31686004)(426003)(47076005)(336012)(82310400005)(31696002)(186003)(86362001)(41300700001)(40460700003)(8936002)(2906002)(82740400003)(40480700001)(36860700001)(8676002)(316002)(54906003)(4326008)(6916009)(81166007)(26005)(70206006)(7416002)(356005)(70586007)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 14:44:36.8429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7d1a79b-e568-4979-95a6-08da584b8ee7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1841
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Jun 2022 13:20:07 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.51 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.51-rc1.gz
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

Linux version:	5.15.51-rc1-g2c21dc5c2cb6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
