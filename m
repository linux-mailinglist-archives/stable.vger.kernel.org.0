Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0DC586CCE
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 16:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbiHAO1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 10:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbiHAO07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 10:26:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0509B2AE1B;
        Mon,  1 Aug 2022 07:26:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrPvgEIaLEtB3q9Olx5wyVjtgGdoFSCzvVkVqwVGCquONhxoIKmA1HSt4JiECYqRcndetuNTtLaMajOxXmJ3HeKmtCA1LRc+AVmL0qGAZVbEHLTbNH+8Q7Qa/9amSJLiQdIQ9pEnNwmfE6m599Z0nTeuimDHJElsAPslryvxGpM8xbioIqujh2u6GIrJIa0h3yY4oivj8d6J4TKkbG0XdpCABjqDJ2QgD8yZUY96Sv6qG9He0fhzSXZmC4qRzDwmXkLlevHrjrbuZ4npCNvxd4BcccbFogZvfJEuVQLPOCgXd7TvK8NCryNtzbC9TenaSrVuAs4s/nD7Tw9PWjtGlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OaGAJKYwvJZrQ3l2G3MrpwELeAW4ZXCtR69HW0qDyAA=;
 b=HauknWBtq/TuXMUpzAFKDKRtWBq3RAo1zV3oEsgNA0jjlCm+DAfDzagwUOEOBYw72zU4YEJxGNcIpFt0+tQpuRte92wPHSjfpByirxJqGSzOlSqAwni6p3mNwzyOGodi0TLZdr7XTiKstEunF6RqTb4gVVdxSaq2MpPAkls0QwRku+qDTifv5zX0Y5omSyQXHHE9xNUIdzcG7DJUiEy8ayXGk2COZ3ryJCJ7HXJIEcprT9agC3OAWJ0dMhk1XQIYYTo1G2jO5cKrJVa2k3f2+mMfXv75e2SXlEZla2GUD4azk2Bv/uy29eT2AFxB101ikpLZEIQzUorJ+tppdn6EmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaGAJKYwvJZrQ3l2G3MrpwELeAW4ZXCtR69HW0qDyAA=;
 b=qbln5afZ1QAvipfYW/6qegrCTSKpC2R0LBJgdOker+PuSxqFj/mMsUy9Dj3LpU3WyCcv0AgoSic20oz0uevGOFEH02zCx2ioH5GhEAd4Y6569zMRhvk8fJPUrffFizE2VRX8lnAsJDviFUc3u2ASbektUIaG4ryIOw3KJ7qBLUdUDziHv9FWbGhlw+YeHMB0s8YL4GsqA5Xg078WRmV8SQw7e43TiFth8FSqfnOGgyFLRAxJN6ZyR20EOxuC+5QJKim5MhdpWoCX9uz9GmxNR+2BN3YnRvzv5MGwYNIUFVC8lxdBNA+yVWVIcvcyQiSnIu4bDwdY2l9hayDwuFa3fA==
Received: from DM6PR07CA0079.namprd07.prod.outlook.com (2603:10b6:5:337::12)
 by SJ0PR12MB6965.namprd12.prod.outlook.com (2603:10b6:a03:448::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 1 Aug
 2022 14:26:55 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::cb) by DM6PR07CA0079.outlook.office365.com
 (2603:10b6:5:337::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24 via Frontend
 Transport; Mon, 1 Aug 2022 14:26:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Mon, 1 Aug 2022 14:26:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 1 Aug
 2022 14:26:54 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 1 Aug 2022
 07:26:53 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Mon, 1 Aug 2022 07:26:52 -0700
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
Subject: Re: [PATCH 5.10 00/65] 5.10.135-rc1 review
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <10f8ab86-1492-41e3-b8ae-3b68ec082770@rnnvmail203.nvidia.com>
Date:   Mon, 1 Aug 2022 07:26:52 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d59efaca-3e6e-4a3a-e6c3-08da73c9e24d
X-MS-TrafficTypeDiagnostic: SJ0PR12MB6965:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rFYDbhIkbbfMMXbuFeQpArz1P9oE1KUxTqhDpKn7MfOJGDsgUQSbgmtCcDw08mT6K41qubNPzqAywqgIB0dkmSUUR+9uFPb+4DseYDnzMQdWJ38gQ5pFWQXZR4pCQMYj6wGbsMP+l1Dp8ndiVcOpzU56GsjgognTzMO97hW3J08GbA3RwN5/mVQOsHVmu1xcaiZbPlpLtEgra/ddHoVkszu79ja7AUxhCLd+rsHOBaxWR9xbaMWPtUqnl4I9tVG7h1Bzl3kVdiPkKDUrEK7W+ynXAbaMw9eADRnbqyER7bzlvCFBwWuc0KI4QHWlu6Fyupu84ViZLvWMRQCZUHRVrjfcWOxBQ9trnyb7bmQlE2pwz7UuLTwum8HXM/Hiyv8DtCL/qT3kxIWpqVhcQknILuECE4mwwWIEwaBS7G5JppJkUohsDg5eZbZ+2tLJFLE58ah09CP/oES9YJFsBYwzd8VFiequ/U8sU0ahflz09eG0G3DrGv79ng8sBP/83R1oAQ1JbcXeOaMy6A5rozK0Hc9T6LMjx0rNjJaQ6dBll0CzaqrFbuZRVeXy4PtB61Ms3T/euuVei4V/BKS/bvHX5XUcwIPQYzhygSel6DKRhgVlOBzJur2fxn+mQCvYJyn/SUv5PT4Ollw5u0bV/yeUyVX84iwQZF0+Gje8d22MzTcNOt0i6CeVIFM8PVu1vIEQ4m8kvHDMkfEDIiIharVA/3jbwAkQikAe+gtWTnMBUq2cMQzMeGeJHdIH7v8YwR6tobaLn1HOUgGVz7Lajcf2rGjAsy+/hH1apWlDJ23h5Gqq7DVg7zopSllKxVss1+AuIeuFQ0P5XAAmFwuo43Cd8DbPpJ8ZJTNxKscnnQTwcU2ipqDZxnB36cG8EJw4VxIJ0VzAVPF5FD2IzuL0ocdvt629tvrlOEhNs8CQNQTEIZo=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(136003)(346002)(36840700001)(40470700004)(46966006)(81166007)(356005)(316002)(336012)(186003)(6916009)(47076005)(8676002)(26005)(7416002)(54906003)(36860700001)(70586007)(70206006)(40460700003)(31686004)(86362001)(426003)(966005)(40480700001)(82310400005)(478600001)(31696002)(2906002)(8936002)(41300700001)(5660300002)(82740400003)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 14:26:54.7317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d59efaca-3e6e-4a3a-e6c3-08da73c9e24d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6965
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Aug 2022 13:46:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.135 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.135-rc1.gz
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

Linux version:	5.10.135-rc1-g4f874431e68c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
