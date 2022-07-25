Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D55357FACB
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 10:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbiGYIDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 04:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbiGYIDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 04:03:36 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF93C4D;
        Mon, 25 Jul 2022 01:03:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9qoelxLilfpbevL3Ey4zRhDjixkY/Ma95swTB+YfBbueI+cG2CZ7zj9GMO7BjQH91Kl8DH7QTzTu/1BVl+4ceWsxYALsnJKIvC4ywM159ZAHQuFxWnAnM/m5UzZ1KH7YalQWSGSRJLU9FvlXMAPMyrCYSHxXbAj9dipcP1x5FJbehGhegiZ3wyb9alU6NTnE1D+b5djSJbi4NaUCkMwZsEXceeDu0qSqiKX87ia9pORHPs/ELndLL4qLHUaX02C9i7bo5YKufPRtb4JXd5WHrrVMPtPvHg2rwrWHec3Ne2FYEll2/uW2P+Wm5gT8IikNrhBNflGtHdZK4ji/8cp4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2kTh132pxvPKrAi4oZnWOzpsH6JaHkLSFdeikYZQn0=;
 b=QBERaxQ2DO9bBB7C2V8smQO1eTd3PLnys1keOcV342spbiK7p2WkBWDYrKYnuy+hsbRG3SnLwFkRZzJpkzZjIzDeczEI0bBToskZzRWgo1llNOp0SmlXfvZBaSwwr3XDZHcBSG23jqD+DDLjZZVtZLuvO8R8WfMJc3BI88d95AnQI2hPzgKJNk8V/rLwCNyVqK8TBxKZqOXALjz8aijPt4/fbQh3JhsH98taoazigYZCi/fjBcDg+J7ooLv8E3zLGPdNAwVrCgY00QvTIL4WrCa5XdFNHzhRYX9h5w8oFy6+bsufC+UNBiNgh2xhczs+SswQ44KDYscutJNFeQD10w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2kTh132pxvPKrAi4oZnWOzpsH6JaHkLSFdeikYZQn0=;
 b=NeBW2XuRsNSw0CMHsul188rWlGhtz4gSov1+Y3mXnDbIHO6xj01Lh9QUJXUGZmC1nU6mwKTTW31Nw72hfVxGCHyxdbNmTEztpG/nlczoGpAhj6yIP65phuFPHKjHYF/II5qmVu9IlB9/Nkvh/+TGCsyg5u1f649+39LwFOq6rkjH/06PUlvHNajAe3778KnnZr5LcbMZyTU15YIRn72cOgzIvoQb1SjUhApbOw8aINb+Z4+blP5A+sjLrWmuIGffPBc6jH02rYPqpRrNaQApd2lr5n9xe/NreuXFCoRJSCbioriufvNajoFMmbYAF21KA5mnvZF3OIMkjnDRPALSvw==
Received: from BN9PR03CA0505.namprd03.prod.outlook.com (2603:10b6:408:130::30)
 by CH2PR12MB4005.namprd12.prod.outlook.com (2603:10b6:610:22::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 08:03:33 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::c2) by BN9PR03CA0505.outlook.office365.com
 (2603:10b6:408:130::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Mon, 25 Jul 2022 08:03:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Mon, 25 Jul 2022 08:03:32 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 25 Jul
 2022 08:03:32 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 25 Jul
 2022 01:03:31 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Mon, 25 Jul 2022 01:03:31 -0700
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
Subject: Re: [PATCH 5.10 000/148] 5.10.133-rc1 review
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9d3f7508-81e4-4776-90bc-8b191bf3070d@rnnvmail204.nvidia.com>
Date:   Mon, 25 Jul 2022 01:03:31 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e2fcfbc-15a0-43c3-604b-08da6e142b4c
X-MS-TrafficTypeDiagnostic: CH2PR12MB4005:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ybEHaqv0dtgujwTlAFiK+W5NaGZ6XQkzVe7Am6GOB5s4z1nO2FqypH99e++LHVtl+hE+qIc0z64o82+8x0fVTNaAuofxdXVC2O9N5dEw2BIIgEgv7G3dtdk6RO7Zg11yvqsHCz0nPc6bA6fQIX2Ri+XZUfruhSImAzJqn6dIfqkXkNROpCPGV79vqqUBV4LMY80N1YNo/goNjMRwK0Co42sL8HSRF8Vec6JGEl2Y7G+n263V5XN405Yd64nodhB42KVEEeNFYqM1roVYnAESN5IEXuJ4o6dFnQWmu1ayyrZt9XrIY6QbNX3tg5YaliIPyhGXvTROnPz+d7qXIU0hQWkjhi0Lh8kBaE2gyUS+4KFQ3WmFeD9F+P63akZYDPjnk2jt1UKEvNHFS/9GTcYbWLglDKBIfqWDg7ZOwQvEUx4bnZ3Waqhg9AEIg9lNspaDNZfEMXbIul+0BVFKHwHczLXaqD41HhnRIaQ+WTEQF8PcIKXhFg/AvXphLG8Ll42CxpQQwMRjyfYaKNlgH8Pp/91V1KfOTy19OqQl3VMSOoIYGBsg3WkUsCB9fh8wbkXKnq92LEFKTUUOrWEqO0/mVTSs51/DywOh8TAwgIlL5YtNfsuzRamzn2Y0nR+c9036XWS5eQ1SjTc/A7KB7e6Meej2rz5bzgFYsdkywfZaKZa2zEtXxPj5K+94rSIixsKagjsNwdwVSo6HITCQAL9wzdMfAuXlh66wjNqm/RDhBVBpO2SOLii02Q2eMv1SQW0LHFdX6O5Qn5UTmnhCTc1VyfRsj07Aq5gqZspliqwCNXliTa7SA+CeLI/a7k4uG6wItvKTl4wjxjbXbD2mr6rtBYO1G0Qpd5182AFdA2KqqAsGyFPyAXXGCUHBBbl6GADWvRbugkNP6SCiJi7frGDJxxRf02mDZz1qaHFh8xwYL/Y=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(376002)(136003)(396003)(36840700001)(40470700004)(46966006)(41300700001)(2906002)(26005)(40460700003)(31696002)(478600001)(966005)(5660300002)(86362001)(7416002)(8676002)(6916009)(8936002)(47076005)(82310400005)(186003)(40480700001)(316002)(81166007)(36860700001)(54906003)(82740400003)(356005)(4326008)(31686004)(426003)(70586007)(336012)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 08:03:32.9454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e2fcfbc-15a0-43c3-604b-08da6e142b4c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4005
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 23 Jul 2022 11:53:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.133 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 25 Jul 2022 09:50:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.133-rc1.gz
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

Linux version:	5.10.133-rc1-g00d1152b1162
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
