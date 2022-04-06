Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC9A4F6BBB
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbiDFUyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbiDFUxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:53:55 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022D05D192;
        Wed,  6 Apr 2022 12:11:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpmUmamQEdxBlSm9p5Ib1wvdYlpclaicPn7gzwF+dwB2jAVA7WtxWm9IFQabEzjz0bcgDutBekg9u8Zjz7u4v9xDihePd8e8M4exqJZSsyVdzm4GorNPhMtmHXB2MTc/0TYlvm2yv4EsxG8jxDjTOvEGEuNqjFAOepeim2Hto1nG2lopW2fcaFFlPiPfS4o465gbQPXXpJzJsCKsDUZ4S121NlpA5XTL75feTQ5AsaMqW+TRyN9wlLT+gsHEuSnR1rRDEqJ7NcoU6hb8xDjWn8xLrBMHMd2urdVdxVJQcUvz52JhpLiJzGrKo+pJ4Vzju8eUAlUVs03BHZYW5o8i3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ehKsz1zl026j1vfhH8VEZfsd0TYwDI0UoeyNCo+iGs8=;
 b=SIjYpY5mb/bWeoXg1np2YyPFES3DpsnKCsWrUama7ESAbOJJdK4fSEjVYoCIa2QUM5PimWzSoyZgonWgzARto5sV0ARgnc5koQRoeeZk7emhB5gVcDKM5sVxB4D1/ZHJSpPiig6OfVltMpmSmT/p3Kn0BBkQMSmwSQ5rptusnRO3nH7ZDhN4SGwLk98yfY8DRlkSk0BGqbVnMfK1hP+cFV5sIw0eTgUu/C2zhwf2SGt8MzZ0BNDU08LkVfI8GLqekXerx9dYU1drwNYgJ3tZGtLw79wlokX9oIxM63gmrJczSXI3lO3G5zCt1YQ0u90s64NM6hVio01lZnbyki75kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehKsz1zl026j1vfhH8VEZfsd0TYwDI0UoeyNCo+iGs8=;
 b=ZubIYDu/CmaWc7TFBb9//nbpbTr1eb2nKJBaYr2Kxq4+pJIQMLDzbCTwL5j9mznMI4fqh4P0V7d3ODmojrPKI+i1LxD3sonZfNJg2v5M+xEYEd7gQyOTcE65GxZBr4jnpB7VKHmUBSIVGxo39U2VBo8PYrgt+V9FcLdj7um81eQpkSh9FkFzFBgPAxUlRD2SYbvZkNeDq4i9Zr6w3aeFOZIRRUhsmHPbhET+qfYx0yqNtEjTLg+3+5oOvqWZY8y8raPrKYsKGY4/35hf2mQlyVGMBzoTiJ1ileH/4/mDUQxmtVHP4ZTAee9+NN4+YA8aQNTHeHny5qRpJEC6pjG/Bg==
Received: from MW4PR04CA0250.namprd04.prod.outlook.com (2603:10b6:303:88::15)
 by DM5PR12MB1898.namprd12.prod.outlook.com (2603:10b6:3:10d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 19:11:49 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::5b) by MW4PR04CA0250.outlook.office365.com
 (2603:10b6:303:88::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21 via Frontend
 Transport; Wed, 6 Apr 2022 19:11:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Wed, 6 Apr 2022 19:11:48 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Apr
 2022 19:11:48 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 12:11:47 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 6 Apr 2022 12:11:47 -0700
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
Subject: Re: [PATCH 5.15 000/911] 5.15.33-rc2 review
In-Reply-To: <20220406133055.820319940@linuxfoundation.org>
References: <20220406133055.820319940@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a3c351b4-17cc-4127-8ff3-21e459e1c28e@rnnvmail202.nvidia.com>
Date:   Wed, 6 Apr 2022 12:11:47 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d78ca815-7888-40e6-3f7c-08da18014cbc
X-MS-TrafficTypeDiagnostic: DM5PR12MB1898:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1898691F8D6413CCBBC3511ED9E79@DM5PR12MB1898.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cMw4Jh9YKW4HSRRIv0C9FJKytwiGPcfhSJDX3GpdpViZg7uPrwqDHywxxtU97/HA9koDIKX/ZK4M7sY8fPzJUrofiBmPFDruVDaWQJiubSBeuOGH7hlYLcTbBCqE8ObScQILBy8Enk1TrFk2x3MsowzGUvPlBqMzS67ggSmsUagoLrH7O0KNQJC+nighDIWpCagh57cUizJt9uU/TZOpxQuZ1gkfOn1R9K4raepxsEkORLFtwUj3NQms6NA6a1Zsz69nLVvqr6nxg0vL02q/uX8kIL0/EjAQoNpt1KjLSTpxPHsINFHyVns1PkZbs1PK+scqLCry3mkRPqhAxK1XzUIUivo8t+RhxdnTZzfD/RsGoE+RPeblobjh9oS3ldhRcMQGBCaxdT5+wqAK9s3xEHIGYpAs3yBq6f2/idOn01r9Tjxb6L4RtsiuaqnXgEs6n8Yew4sOVMn0MiYDwCJFp3jdAP4KLI3m4JAh6NJIg4cqJgY0Qt0diVP1YrXchZipfNcYpXVXKzUMn440CSjN6hI5ozL7sTMrJ/YVRRyujqXapNb9U+JUSKGg+9qQKom/zlV4c1BtkpIIFLdhKnDLZHFeEsrFf5wbbnf31muhDziYVulf0vtb+t0FpZZSHl/2/ewLzefCvtSi+qKPFvBqGUneOHlIpTWx1DmO9hxd74licJzTZaT9/JDGfr4tFhMpMalvSpi65RtvxjxcJgBgVUB9noFpw2drSk8F6JKCLbMIv+1U6j9SnOmgwQqkmgh1kQItgT8MrVCaYi+gyHoYdruJIZsDmZXshex8ELFBWpY=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(47076005)(31696002)(36860700001)(86362001)(26005)(426003)(966005)(31686004)(336012)(7416002)(186003)(5660300002)(508600001)(8676002)(8936002)(356005)(4326008)(6916009)(82310400005)(316002)(70586007)(40460700003)(2906002)(81166007)(70206006)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 19:11:48.6692
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d78ca815-7888-40e6-3f7c-08da18014cbc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1898
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 06 Apr 2022 15:44:09 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.33 release.
> There are 911 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.33-rc2.gz
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

Linux version:	5.15.33-rc2-ga476e005a81c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
