Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811B540A88F
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 09:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhINHut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 03:50:49 -0400
Received: from mail-co1nam11on2078.outbound.protection.outlook.com ([40.107.220.78]:7936
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231161AbhINHuf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 03:50:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CecRXVRoHrhVs5tr1TbAFYJu5zm73WJkh5kj1SdYoFUTVOKGHVD9yqLDJ3PD7Qc9YWf++s5i3eztD3PxqKAT27iaFpH+slqxgqKpvQj4+FnsOkJI5Q+QziyMZiRT97MKEvBfAlu3LJzpHHyaT+ZYUUZn6UQtfW79oObel9nLpe0hLHeZ+UrjuBjSRBBygKVRFQJ8z4hedSGWLodNdilEgvRQ4YxPwM4UzdsH6px77iuWJlTNDoPST6c6cicIhm0XGi9nwY5Ce9yzUJYu8z6qOJNW7yqUAS82QXzqNZBvUJZw1JCBR3ca/2fN3KfanUf9vFbDaaQX9rgMgsdek9Ibxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zvL0A3pJVgQ+zth76nNFpSh1YYBMCZRwET3FXfU+H38=;
 b=EbMSGJ5f636fpcEim++1vYFC/2pYxMyQlYQQ6zLK+RaIxFuIzWsAhv90UcAAonI3CIECVmemGlJYkCXcBbVd95ZkfrU6hrTOnFO8PlQ4UvrANr/1nsco24hUxBc1JhKoaO2efYhAHwTML5L4uoNBkSp0/OxbGkdEivc/ai2NjuF42fk5ujtiWp4KsQwnZ3HEvLP4f8WmucfTKnQG/xHXcKNmeN+M7MSHt4MVQr11RYIbvI5BxHyVI8gC+0JjO/ky8B1PeIifew993P68aU3LNiEk3zhRwmN7IFcAKnhUUvMkTczlfcklUL+wKP/QX9FTAQO0N24TRPf6o53MYPcenw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvL0A3pJVgQ+zth76nNFpSh1YYBMCZRwET3FXfU+H38=;
 b=H3G0y10qFDuEWvY8K6o9KZPu0wODes5vgFqxa1+0TaYVUSOLgG3fAfOYMOTwuOKDLKWmQy0XI5h44T12DTPYCtfveyePGvff+0Muut/YXMs6rsCkZTHXCKhY/xku0FXz5M5otAe1zp18/OnpzmqoRgwoAziUyrIx5cWmCRMnp+Ns/PLpT4dKHdvXPwwerKqYnarQ/vuA1TlJ2JrWbH3qY19RbqD3nrkxTDVOnH7fEX/5qYXBqJgJ4aHJ5kaTzX+68RmywIokuIP/9MaT2Lrv/p8LnZ3yzMt+4r0FiyWUnGsQjiCd8Vg98gKKImBUArgFWOychUQg9+JSh3u13vGE2A==
Received: from DS7PR03CA0039.namprd03.prod.outlook.com (2603:10b6:5:3b5::14)
 by SN6PR12MB2784.namprd12.prod.outlook.com (2603:10b6:805:68::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Tue, 14 Sep
 2021 07:49:14 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::39) by DS7PR03CA0039.outlook.office365.com
 (2603:10b6:5:3b5::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend
 Transport; Tue, 14 Sep 2021 07:49:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 07:49:14 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Sep
 2021 07:49:13 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 14 Sep 2021 00:49:13 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 000/334] 5.14.4-rc1 review
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e7f001b50e044190ba9798e753471a4a@HQMAIL109.nvidia.com>
Date:   Tue, 14 Sep 2021 00:49:13 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b896738-adce-4d15-2917-08d9775425ee
X-MS-TrafficTypeDiagnostic: SN6PR12MB2784:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2784CD97DABE0CD0F1CD6F2DD9DA9@SN6PR12MB2784.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GS9gFlx9rrXg89FXqbVCHCKGE7C73x8MnvJW3/9xeAlkII+oCFhpg/Mqfqz8n2SEQv+kyCa+qDNbO5xw8+/9t1VUtJcEU1Bp1XTDEWe11p4mhJq9jc6piuVvbE+PymO8a63RIW67UTmCYwuzRBgE9+Wbht7JdyVYha2JfB8PfP0YHr2DQET+fPdMOAnmGvKWrjtkS8wfibS1QQ8sq6hOubuRlwvgPtxJTLgGSwYat5poVtlC00dsEuLdKa2w9DF2uwfWSIEA7GAmK/wzv6j4T4ut0uwLse3y2ovwjpIZ/VmTX3FDu7UKMxiCGj4hSTBsR8Uk3Y4JDFwzJ6SWg7/NIEoyHiXqLbgnotzwemiOFoGXqNo9m3EZd3btBOPmuYqHxASV68TSgh2gssMlT8/i5FlyrfXzy2KaDxIPtqP3IvESEWiEkARVYesNj4BmEm/aMRfENlRChEI4aTJ613bKOF4LejlpI4Ken4ZEDz104pvVRjUKbb3Z1zNcuJsA1KWkOYSGjT0Px7uOosMse5DCGSEmlREjUhHM/FzptLCeix1iEV3ltPG4g0bU0RthbGwrkxakoNH5QXLlgMwqMecdrPHSe/dru+T1rfhgWuWnfyWmzq84atW725hcBRKV62KYJf08E3QqZaKpUCpGs8lpuTJ9UbDgdBfOTzEKsZlcySrN7w/zGfjTRhyJsdHFBl9tjigQIS4cCkM+hJn3rw+NrqmQbjYZT23EX/xVE+SeBckLFooxHtVh+eiziVV9gyfKoSwx7ghLZgjIj3qKq6U2LufBggjSL1LWGy2Gk2TqU7Y=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(46966006)(36840700001)(4326008)(316002)(5660300002)(36906005)(82310400003)(426003)(47076005)(186003)(8676002)(6916009)(70586007)(7636003)(478600001)(24736004)(108616005)(70206006)(966005)(7416002)(26005)(356005)(82740400003)(36860700001)(2906002)(8936002)(86362001)(54906003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 07:49:14.5699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b896738-adce-4d15-2917-08d9775425ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2784
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Sep 2021 15:10:54 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.4 release.
> There are 334 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.14.4-rc1-g03f7369f8044
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
