Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD4C378E65
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240797AbhEJN2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:28:52 -0400
Received: from mail-mw2nam08on2082.outbound.protection.outlook.com ([40.107.101.82]:29408
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241046AbhEJMnj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 08:43:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U3qnzYeIqXRFdF2z1yMZXuT8u7qQAMi3Nk5MoDWX9mmo0sE+AQtcj5CyxdtcZ2ujEU7pt6T3KIIn9pxVkmTR6+LKwaM4NzmIgxh/mPmF0Ceu6DINsMVAkmQX4J+N8WUoeWWjwiWtCEy/3ooBhru6KpVXGE5Fh4tG9893vqKpj7IivUnDyiuHCR8Hid1T/eM67yS0zXLrYn4K/Xlkc/2kj3Hlqmcq6/Gsc9aTvSFIubT48EVswwb+FTuPtOxu5q9NP5KxcYjVzVCCiPHDnxSdsMSPlC9+hb0HkQ5MY9Apv7nc3++0A6ckpGnupj0bb7pt1YfXQePq3hy+XetapWhEiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcU1myhWYyLfGjTSLb7BC/nU5+AB4lmU+HKRotzWjHs=;
 b=Q8IpBDTdSEBLN6psyDZPud9MZXhvi76myM4pO3nvNLuhFkkCsrbx/qPEWOLOLrT8Dpp+v2eiZYQZ7Ca1GLc2x759YbDcWxkTq7orQASc/K2D8z/vpZMEw+hh7a99rWJI7ySOV7OyrEBA0bOSgG8LFkVoYQ3MHmBxd0l5yYqCEodBF0UYBfHe3diPIR54Q2j/4ZGrnpWh0JUZ6DFOayFY67HyaFlk70JaXCX5Fk9BDeQanrIRa9XTEdYLqxRV5ssWkL2byEfumXlRbtkEnHXrI2bmpEOsRp5vdlbQw40ag6v0C2c4RWSqwrPff1L9ofOWWxEAN84L0c534lKUv+ATYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcU1myhWYyLfGjTSLb7BC/nU5+AB4lmU+HKRotzWjHs=;
 b=qvY8tMHmtdPMU20w7CvAqSJVNoWgcC8pAIUQCxzFyOBPb6869BZmTGxTadOu4BnQQi03srmTYsy5J10n97x+qbIuKIaAM30EAqRnVMeWTLg02xYDfZBmLqDeSUukcmbKxQHckqhdWIVXuOLc3PSPMRPTPoLZ3VB2oe/xM94QRP/5n6/MXxGCk+gXxNf/q9iKE2/0ZTw1zWQ4QIwnarJzg67rjhk2rwBL+w+byZNxMqOV+2V/oMKNSR3/OzCqhP+zDLzBH8R20xXLbtmhkSIvnBqdnKOCOJgGIRgP8hRqy7+OFRnK8Md9op8o/WOkmN8WmILOpTaWPtggcAHWoN1FyQ==
Received: from BN8PR04CA0054.namprd04.prod.outlook.com (2603:10b6:408:d4::28)
 by BN6PR12MB1393.namprd12.prod.outlook.com (2603:10b6:404:18::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Mon, 10 May
 2021 12:42:25 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::cc) by BN8PR04CA0054.outlook.office365.com
 (2603:10b6:408:d4::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Mon, 10 May 2021 12:42:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 12:42:25 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 10 May
 2021 12:42:25 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 10 May
 2021 12:42:24 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 10 May 2021 12:42:24 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 000/384] 5.12.3-rc1 review
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f38bef4a9d9241b4ad5411c57af35dc3@HQMAIL105.nvidia.com>
Date:   Mon, 10 May 2021 12:42:24 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 286b5c86-6b59-4823-316b-08d913b1109b
X-MS-TrafficTypeDiagnostic: BN6PR12MB1393:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1393F853F281E1251DB60196D9549@BN6PR12MB1393.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IlEEoFPqlZNWbTFo+IOqPuEq17oQyu0IDR8+txT0GM35P6+4ormnvXNaA1KoXulOxj7rWsBMPqOU1TzICkOwu9q75TbpSq5Qn63SKsYgc7JgNTAxagbvJNsqs/5PKos1jg5tWPAdo03d6jgVqVKkON/XCSV6anbtq/ZmYVwJO66Q2UoIRBkPDz64VMvxwzFVYFb+CV9lOWBYxJ/q2SZOQLDzkyJgXaVJbEQ0KvEpflM6VFpFpXUTa56OWC1dKHvhEXQBzDlr60DoTIELrbPOSQFDor9HUx65Fc/oPr2fafdqz92Oir3MaNFTBqjeNwA0zOyUI/roMxnSzkmwrVD6+DO9s3aXInmSFqPsQ/DvJo/sRh6k7P+gvyNJQdcR7lhq+1SAZQmhf+qNo2+yqGPgV+Nvm3FPzjmwV4ZBbJkt5dcFW+S+/cLvcHqAUgcAwCRfKdYNZS5AtDyI5S/emMFkb8HCQNohJGHFSK3fC8zlfqkwGfUvrzJWg7DFcLIJV0JiQshmN9aCKXDQkUI3J853mhUegtSxhluBh5RIRyL9I9BHp759aRyjp2U0DyzBa0/y8nE8DORNp3wit1Ee9Frr3NDZE/Eu71P0GpTuqT7/fOULHL0PVVRab9Fd6XcYJqNkNrm6l1hzvf+QuWHLB2Nd8u6OMIrVwn4gDGlQgZrBsnO4jr3JcoGTZ5GQhOOFp9Ymk+/9G2nd8Vh0EFQqjzaFvl2eQXdxPz1ZhGNzFQ/i05c=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(36840700001)(46966006)(426003)(36860700001)(82740400003)(26005)(82310400003)(7636003)(356005)(4326008)(7416002)(316002)(8676002)(36906005)(478600001)(54906003)(70206006)(8936002)(6916009)(47076005)(966005)(2906002)(86362001)(5660300002)(336012)(108616005)(24736004)(70586007)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 12:42:25.6542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 286b5c86-6b59-4823-316b-08d913b1109b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1393
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 May 2021 12:16:29 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.3 release.
> There are 384 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.12:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	104 pass, 0 fail

Linux version:	5.12.3-rc1-g47db4685df62
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
