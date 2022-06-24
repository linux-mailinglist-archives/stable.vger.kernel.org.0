Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E8A559692
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 11:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbiFXJaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 05:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiFXJaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 05:30:01 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C704C29817;
        Fri, 24 Jun 2022 02:30:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTPoO++4sXHiVM+5kLExCRmdFVJ+7ixjIUrPJNcbRVdRX735z/AIP6WdGzQw5MpITTbfdUTNFKfzHxV/VSUlb4Fw2viTf7fCzjf1kjHNvrGZX8skxTJRKhB221K4EwgPh+xV8qdx7COJJ9hHz+kqMGoqr7E+bLI9OJMgLP3OoH6VDKIFBop/MrMALysB38QeKPHoHgEN6wJsSs17/SQFqvMLTmVJ+30Z6RvIMfQERzwuYnJDKzWCx2XaH7q7Sqxi9WikFqFZ88nhOs6J8MPkGqsbv+dXHdrQNpcy7Ijx180Rx+ntqhuUDGf9zTMbqTfqFsS8pUUNb82GKx1/nAvO6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHQqSvGuKethL2uiwtXFxXirqLAC2KiwWh7BuAOIIfU=;
 b=HJh1I+urbaV57NxnvMPN0DtpjI/H10c5f370oTwWuoPDSqj4BK4qXzQon4USODh6clYjy+jXoYe8Pn36l3Watk/drK4Gtace1wn/zkl0ptsAwL18p8jlGtjx3sMIwfV5h6VUSxKdEi6TmvrEE7fu/baoLpG8y/IKZg48GovwR6VOAOMUdoDeoCxT0oFQd1IzAmCiq8+K/yAoi2psrDt7MdPIufvJg45FZa+UY8eqWZT7tFKYzPpfjFEMj1VzeOrW7OXPtWmO9pQKUkKNyqg6SRfm9lkGZ/EE2LZ1Cyg53e0PAVWmBL1HE3ePGuIi8wlw0zbx77C4HOUlLDHcpMSZKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHQqSvGuKethL2uiwtXFxXirqLAC2KiwWh7BuAOIIfU=;
 b=SqfrCeZI1V3dVSBfPAkcBIGNW0QZOZJku5AFfD2oE80b5NHEeIhemQoqS84eWyxxaauDIyDxXCknm+MEIK20NIiMdYZcaHXV47T6qzXrsC2GM3e7etm5TQZB4XLImVARLSbJGyBCvWjf2WNDJVYecG+2DbHxllSDq2GarzyGH/I6S6gbDlPMFxk3gSRvEDvgpCIFjUkTQNFscEr25f4KL3ly+rQZjhMwW7Tp2ohFhvyoiFWOLBOhCdZKd+c4vDHBbiWVjrXhE1qf5RKgHbISnm3MkerzIJTVl+9Mar2NCAwcY6oAfOtm40Wjc+4XKuN9QWSeoPaxfd39x+l4Ri7MXg==
Received: from MW3PR05CA0006.namprd05.prod.outlook.com (2603:10b6:303:2b::11)
 by MN2PR12MB3278.namprd12.prod.outlook.com (2603:10b6:208:ac::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 24 Jun
 2022 09:29:58 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::d9) by MW3PR05CA0006.outlook.office365.com
 (2603:10b6:303:2b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.6 via Frontend
 Transport; Fri, 24 Jun 2022 09:29:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Fri, 24 Jun 2022 09:29:52 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 24 Jun
 2022 09:29:50 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 24 Jun
 2022 02:29:50 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Fri, 24 Jun 2022 02:29:50 -0700
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
Subject: Re: [PATCH 4.19 000/234] 4.19.249-rc1 review
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e1e8d0ec-87f9-4213-b8bf-226ce44d002b@rnnvmail202.nvidia.com>
Date:   Fri, 24 Jun 2022 02:29:50 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1855a9b1-0117-4a83-319b-08da55c417c0
X-MS-TrafficTypeDiagnostic: MN2PR12MB3278:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ybGlofYfugGLxmG97/kNhL+UEIFxkOaWeiRnKHVa1QzWvtDs/GN7tKljm2aC7VoUtSIowtQtWMr34EThOTD9IXhZHI0mc4Zfozu7J5gtMDY6HTg6Kva/gdxWRWAhpQCf8G6cxNlbHJ/PaeWFFqNIbNGLuxXsIDC2w5d7HIEVatwaNOA+23MwHjBzd4TV1LWm4eqlItT8dGXfDUrm2W4eANF24m8VtPNd9KiAo23OEgin9YQlJBHqhjGNM+oAoGa5k9KJrarFjH9DHbBCGhRADrQTvfIpr1VycSsSGAm3PnaMn8XCm0dofkGYEZawCFr+F6OKXq50+v8k97yGH3aFBsHP9PmLAZU/kZp8f8jgKF+v87VN2cEgCDDuf00KVBDI6bUHMS84IlOG9AdUxf2yovxYXzyFoWBvkRy5Gqh8eduk/zeIsxFkk+jzsSWLCnNazXfWXzE8O8OmV+EyQNFOF04ObmPhLuhcHQ78bAA4F/gFdhkehpjTKER2WJOp2mXv8CEOt03g6ECjsIVGBtKClqs7wmbmJpE/+BReSvSKFhr1Cv+iCo8BDTN3BIm3cOlWI9kt3mS4upihJQMco6wPG+BE0NLi/RvjKgFOjKuFDUi6IrocLwiiRwARG3ZFHp6G6XR6y/KMlKitPUiWJCDsxchN/oXtPfUfR/WYeT69H1y6u2IOuA/igQw7Q12a0WLcSxERUL302KwjAQL8apjQ4OFfD/6tuhnEUmMbmZpsp/x8nbeWhG+pKqmx2nFUhm/yqRrjvQ4hfjBN6fOlG0Y6mvjb3Rgw5WGFff1IK2mTWgNpAcFftEgBfDAJeH7t6kS+dyzaWZzHw2YcaSH3NFT6hEGImYjvKfc5EK+IMiELpNqLKOrObBDbksn9krDoDLKy6sTPStph97YKpZnAg4wt1Md8yaqlOBnAtfXZ+mymx9g=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(39860400002)(346002)(136003)(40470700004)(46966006)(36840700001)(7416002)(40460700003)(966005)(40480700001)(86362001)(82310400005)(2906002)(36860700001)(5660300002)(31696002)(426003)(82740400003)(70586007)(4326008)(81166007)(336012)(356005)(70206006)(26005)(478600001)(31686004)(8676002)(41300700001)(47076005)(186003)(54906003)(6916009)(8936002)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 09:29:52.5675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1855a9b1-0117-4a83-319b-08da55c417c0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3278
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Jun 2022 18:41:07 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.249 release.
> There are 234 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.249-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.249-rc1-g55129f567572
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
