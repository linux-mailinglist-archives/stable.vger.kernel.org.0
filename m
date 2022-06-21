Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7746552F3D
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 11:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348776AbiFUJ53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 05:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348638AbiFUJ52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 05:57:28 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B3727CEE;
        Tue, 21 Jun 2022 02:57:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhV21jACPVKpi9SmVchbZCGVD3HysSYu84+6n2m17gesnibWtoHjjyRrzjEIksKf+khwPMr5zuz4SwKKqGa3JdsAQVUARwTrWpZYYdVkLHJrej99r8LssG+bvraYqQk4TTqZnxMjCFcq/bdjLNGT3LRwgnUHe2nuza+Ui3oBqOCljFMuSN0PMcN+Hj7y6Z3ohRbErjecur04mGXA2jT6pIRJi4ScELe1OD64BlhkMe9l19IgbGFEUDjkWHSxgYMYTc0NganOBfa/81MJH5uiORGs5IFuD0BGpjKFllnp5LrKzEoUucT1a332yF8RZTOSFDDQovj/Hnms4OfygWnNNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QuYViUW7BB3yVlv4ai2lDXHyJrJHMtoSwQaj4nOu88w=;
 b=jInzzGJKeiPangkAa6aeLTCAYzlw0w7cpf8nZ4ORc715Ao36iyY0EccCr9j4kpDo6dTYVdFOxYc8nQxbqMhmBXQfwFkwqpxxWL/967sM9is+h930OuGrL5l/B/EPno/T4AuZqJrJ4edI2aIcdsDhlVz4adC7TDz/ranaBUBUW5CUolUYdAE6G32JpCR4c6aVzKpajpqtxbRkqznPsmZ5+Ha4dSRTyqPm4LT5jK6gufij7Kb+UDaAF+aDz1T1aeYTbdL2Z168jTsPKO0TnO9ExcwzqlS7RS8jkJbuaNEjDuIUKur6YRI/yH/XAuBcEXFUmxHj6bEnQR3FOyTWwOFqVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QuYViUW7BB3yVlv4ai2lDXHyJrJHMtoSwQaj4nOu88w=;
 b=TyR+iusKNFe5s9EA1MMmAPJdvW8EoicmHNEV/KLEIpvR4UzXUYOHHlGo+cn/kads7kz52aVu9p7jfKPLHVl0+/AkJE4+qG41Ua8i0KGvFEcn+rnG++9zxnIEPP20ZNvvyzSIpdhmXMdZxxDdKHm7cQ93BjP5nw3Bn61iSYMR6FIdizu8Ck5Hq7HsZZQE16KIP80iXhU5iGNTTVHfl3ul6mbtMRXM+NIpXLk0Dllo/cituOYfyfR8zpRPAUrQL3JtDMscT/JelrImIKkQiCjvbWh7xYs4K/Wq4IPXtLwI7J3iJt89uYMfbDzU/SjrGuA3n9hz+e0eAjsRdC1GbO3K9w==
Received: from MWHPR21CA0053.namprd21.prod.outlook.com (2603:10b6:300:db::15)
 by BYAPR12MB3013.namprd12.prod.outlook.com (2603:10b6:a03:a9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Tue, 21 Jun
 2022 09:57:24 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:db:cafe::83) by MWHPR21CA0053.outlook.office365.com
 (2603:10b6:300:db::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.5 via Frontend
 Transport; Tue, 21 Jun 2022 09:57:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Tue, 21 Jun 2022 09:57:24 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 21 Jun
 2022 09:57:24 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 21 Jun
 2022 02:57:23 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 21 Jun 2022 02:57:23 -0700
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
Subject: Re: [PATCH 5.4 000/240] 5.4.200-rc1 review
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <587d3e41-e7fa-445d-999f-a34b677e3a9b@rnnvmail205.nvidia.com>
Date:   Tue, 21 Jun 2022 02:57:23 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83b0a555-123d-4303-e821-08da536c710d
X-MS-TrafficTypeDiagnostic: BYAPR12MB3013:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3013A91FE6082CB7A1606C44D9B39@BYAPR12MB3013.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TOi0ZRnfAo2VtjYmZEgy06EwVGQsPL0mMQLeo/onpB3njkqLjoc1db4UBnzabawYBUMSib1rt3g5E10J9h/EYOYDYgSGk7roM+h5DqqjwRljBkXIBtwghPDc0WXEWCc+waAyagyqd9CLOLx8rF+uhIhuq6F9BPbWqSSOfafKdEAsbZ1WdoAP3ge0lQDXMW6OmNAYp0WcZ4hK+JK+PU9+r0m1Z/EffENmjbro3hSsukFtw+X5OAXFvL19NeiUsw/J6qCVvKTtNVfJtdt8EDRG32rpOVx7uR96LSIRCHtU6nuREU67yD/6QUVspg4iYU4s4VdUcFVbw/HhO2guQS5PMd1p9BZ4OkGr0OQ6fpB3goDrCO9mCNFDuLw71Te2yMPh3D8MMfmImlEbVfZF/ql8vyYMCNJwDGbP+smXJKY6KmSDCzKQJBnyAYDDRbeMXQ8yETkxWbXJavUMWYXvKoZtZVsbNSfmDhD/cLjeVGQ1QopvnVR7j+ck9dP3lqa8kBxAxXiz3uvSih8JMvMfDmmX5wLVMJIdQN35E+9DDnBXMfjW3B8E0x+vZVh/oCOurBC089uqQNLA8MtSrQ3fh5ROSWuea0H1FE6a5leToVjTH9hDHF5eIFn56jtnorv71NzbWFnrBxwus0lkQvvEt9Ny67AWQYDs0swEUuOTh8C3HlbxwexF3xF2VFu5vUvmVO5pfqLob0k2fCuEPIDr2vSv2rTWblpMjX+dDfqhf8nyeNKKeXSzRD6rwUxRwr0hZYHcMYvFElICw8A3fhUpfR0z7gGMIdl4jk8zyRTA58msbpfVH0M3iTvdqc6F1qMrNVS5RSoArl7BI7pdoBofeF8K5A==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(39860400002)(346002)(376002)(36840700001)(46966006)(40470700004)(6916009)(70206006)(70586007)(31686004)(54906003)(5660300002)(478600001)(26005)(8936002)(966005)(7416002)(2906002)(8676002)(316002)(41300700001)(4326008)(40480700001)(356005)(47076005)(82310400005)(36860700001)(81166007)(336012)(86362001)(40460700003)(31696002)(426003)(186003)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 09:57:24.3563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b0a555-123d-4303-e821-08da536c710d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3013
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Jun 2022 14:48:21 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.200 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.200-rc1.gz
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

Linux version:	5.4.200-rc1-gbc956dd0d885
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
