Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C104F6BC9
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbiDFU4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbiDFUzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:55:35 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C7E1017C7;
        Wed,  6 Apr 2022 12:14:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axOg3HK8B1rll/+akv3v1HAeIyOq3MmHd6I6kgRf+IeSp4QCc4nBrbF9TAxmJ85mVKrU37nlGLrxssQA6kmDPRvRL34srBDVYd5Sh75cO02KNqYZn+k5gDgXsaqPse2JsagqkmY+c0wmonyVoSpQpIl+t8WKAvGA8amb5nXmJe7rJBiaeRp8RCADWVTQgJTyoGPunGAB6sVi2EX/cgLiIFSe0fYylNqiUHN9bMwDRmOx9XhUoZNcqpwA1f78K80bOVWCfmz2xGz90g0q+6WzPUzEgdf7mkP8HZR7GGxggd2mg/slGZ0oCuOi2mFPRozFH22UmgElNfrV7/oDsnw/7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wxY3hSHnGl//RjglLGwbbgbRtquV+OKIdVfuehQCL4=;
 b=YY9+NEYIWa/tLnb12CMEyo+no63W03LRQjOnx+niM3tlGM+RwcbRehu1wIdKCWj00CfhvCkymrlNzLrLtUQexXV3gdrb4vCiJ725f4VdoPiTnTYSWOeyF9R9nIANqLcidZhHL6Sz77bWekra8DBZkUBluPYcXwcsXVViuM2i9nxrO3rNrSRkozTIwBTxnGM34vHR4WvdPe1/+ZzudxgNG1ylUfq0McJ2kkDdRYG0lECRXEiJsqfg5Ut0d/4ATTKkCmi1hk9o8iu3DYtCBL/huEvaA3Opav0iUGpvZY6u4UAmgJ9nPR9GdLERCeryzkiA58sDjiy3TPif0fbQHR9UdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wxY3hSHnGl//RjglLGwbbgbRtquV+OKIdVfuehQCL4=;
 b=fFJVmz1iqesCq7AQmZosPwmIoprOsAqy5hY40T7UZLtxlBR7D4eEEIaTeqWlKvRoyYf8jp6dvtWmBGGp/D69uoKE3P/pKDOsTbaFyL6ogzBGlw04iXuviM4TqYg6ZNy/Fevr8FY9r88ogHL6NncW7EjcJdAVHEPaqnZP48RnDcn0V+0Q9LqzZm8wEhadCYfpDLZBHrsn//0hipZN2ygy61v4AWbaK+fMnFLOvi3OtDKqk/CwePr89qRamIRWc4cNF7ASkGXe/t/MCnuEtbud7O6/2MLvu42rzgrmcXeI02qOpAN5ZbggVJ6xANGdi21n3ahzDg6zGXownZ+lfbAbsA==
Received: from MW4PR04CA0131.namprd04.prod.outlook.com (2603:10b6:303:84::16)
 by MN2PR12MB3840.namprd12.prod.outlook.com (2603:10b6:208:16f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 19:14:24 +0000
Received: from CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::c0) by MW4PR04CA0131.outlook.office365.com
 (2603:10b6:303:84::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Wed, 6 Apr 2022 19:14:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT011.mail.protection.outlook.com (10.13.175.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Wed, 6 Apr 2022 19:14:23 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Apr
 2022 19:14:22 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 12:14:22 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 6 Apr 2022 12:14:21 -0700
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
Subject: Re: [PATCH 5.17 0000/1123] 5.17.2-rc2 review
In-Reply-To: <20220406133122.897434068@linuxfoundation.org>
References: <20220406133122.897434068@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7e0995fd-6122-4b00-b87e-1182b678ab87@rnnvmail203.nvidia.com>
Date:   Wed, 6 Apr 2022 12:14:21 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46a0d8d1-de62-4206-0b9c-08da1801a8e9
X-MS-TrafficTypeDiagnostic: MN2PR12MB3840:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB38409C526454A3B59340DAA0D9E79@MN2PR12MB3840.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6jMTu2jgrKhI1nG8+WP2lnV8lryxji7q6U/Bib71M5KJKduVWewrWRsoAcXvWtjY+5vFFUDSX6t9BE3k7R9b1XxzQF7jOI2uKQ4Z7rj7dmjccsjWvt2wUh5U+6rOVJqqIzLf82zmxeMnDZVyEp2A4JbSG97Bqgi+z1es5GiGMzvni9NNv+TW0yvdGVLvO6G9evCaC46UeA7szffykZgDvqICJ8v8TrZWMP9Dtj4im2r91cezyPus0GehnwGAYJMZmiCayl4fPtxr+ieXYJUqe2WWLnppD2oTZiyUHfEr7QhP35XIVsZQAAm7gmdPInHtxxbJZR6Z2c/XZukHH+CkZWEl89Re1L2yq0z5GBBmCP3qce6QkDjW+p/XhHpsA7UdmNQ5qrx9nbKHEl5E3PDQCZEteEuKOCP4XW91aYIgGt7fqaJCoCVbkT05wq616lbCvX1EiOJt0LXbKZ37EvDqeoKi4YIb23n91T+bvzNd9bmqlr4MaZiEtLlELhPRTkKvGePMYCgyX69NpSndUuOLJyh2/DOaMWkxG8ospX4JsnHbPnXgpZvYwlH+30RVNknlemDF6Yl4FJNlYrtq0QyNh3tDkX4L6q4aWBqOf3SkFb9UE6YWC/yOzrz+8stPvchBQq1ykSfJRbXJKoPk1SpwlYnaxk4hz6+L/w2/fbtg5to7USkUgls+5VeRqzAauzN4F5fIH05BSgaYx/OMQKj6w6ee5XuBBkUhXTOTuYTmYfGjQcjw/nr6/3HBkHxJBRnYs3OKLE6AzCpudZStCIvjO/P1eLBHpAMXvXdJQNP6MUw=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(966005)(5660300002)(8936002)(508600001)(426003)(86362001)(31696002)(26005)(336012)(7416002)(47076005)(186003)(81166007)(40460700003)(2906002)(70586007)(70206006)(31686004)(316002)(82310400005)(8676002)(4326008)(356005)(6916009)(54906003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 19:14:23.3444
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46a0d8d1-de62-4206-0b9c-08da1801a8e9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3840
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 06 Apr 2022 15:44:54 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	5.17.2-rc2-g8137844a8b59
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
