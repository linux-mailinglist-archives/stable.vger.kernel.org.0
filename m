Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC4D5620DF
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 19:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbiF3RJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 13:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236123AbiF3RJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 13:09:56 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE13C2496A;
        Thu, 30 Jun 2022 10:09:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWxzjmF6NGuO/lnrK2ljStrjZaYFRe4KMpx+nbtQ1B8CCGt6Go5MMLoasW+KAI2/7cUfDV9QqZvELPRfKteXBv+omLvIfQAypuhSSvTCNGT0TebJi3PnWCd5aF9JO2szSxCclyyWt1EdzpGNndXDZyxbWf2gb5P44nJbLvlQ90/BDQUhwJmilopQd3bJZYMUeZSuzhdxjB7s71sL8xQnjMmfJEoioe6aTQLgDLIaApmaSzEeX4BZUUj78wMjXToSSn5AVZ8XNt7qF1AVCYYcPgZyB7jHwTA/rLIgqaod4dKoFc4m69Huj7Ys4rqiXtj/SDXULuP33oieTyibyRHOdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=igCVVKhFKrIkZWR5AoAH27wJBVCSXSB35/AVQ4YMrNM=;
 b=biDLP2oTScCB6IBe4en/YPVl+ao6dJ2zeOF255TxUSH1iAEp7HrBBjHSQ3MxnATuh0n/FUnIRprFokcTNB75cEvia3dQQmrwtNkqIfnGv12MD/I4XVofhpd+Xfs2bXgd5eG9kjJJE+2mywwIuoMM38VXP7lSz6YeHNPT6xSfaRalOLF33O9AtBq7NC9VLTnsroXKn2P/WydO2bOEc9phGpA16ByJR4nj9xoPJYrPvioLLaJ2fnjDp/4QnVYjGzcGrHDpkgiymKUtp2btauNPIEuLI3lB2HBcbIRPCe+86HLR+R/OAfMwkEB+FlRWtBGQ3NHPYJDvvxie+/xffqU9vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=igCVVKhFKrIkZWR5AoAH27wJBVCSXSB35/AVQ4YMrNM=;
 b=U/98RLtBVZ9a4nta+Uy0ZGYDnxujhI3RC4AnI+xyK8a/WKRdvCAS7fiZOH56feQegj+O6IjVdKYmfD+XtuGxRCwoM9ew5QXKLH7RX9Hr4ft7cWtoP+i3uCKGv42mIqQSaOA4w60fSJHmGbCIKX6lccN7VEbRpKxrAJYMHIIkdohLqod/FM/aOOqSLJ+ZotULlHH+dI2jbYHIBtHjsUWofcca8lo8Nr8NbN7koK6dvNuFAWRpsgUTnkQGsnEwV+kzGb5iB1Hqoqt5qaBU+cQ5QuJ8Z12t73/QqvCq9GdkzWEC0aquPrYARsf13gXfPlb0/RBQNvUcPF6r9GHCjl7vbw==
Received: from MW4PR04CA0033.namprd04.prod.outlook.com (2603:10b6:303:6a::8)
 by BY5PR12MB3700.namprd12.prod.outlook.com (2603:10b6:a03:1a5::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 17:09:53 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::fe) by MW4PR04CA0033.outlook.office365.com
 (2603:10b6:303:6a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Thu, 30 Jun 2022 17:09:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 17:09:53 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 17:09:52 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 10:09:52 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 10:09:52 -0700
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
Subject: Re: [PATCH 5.4 00/16] 5.4.203-rc1 review
In-Reply-To: <20220630133230.936488203@linuxfoundation.org>
References: <20220630133230.936488203@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c40b70ca-8228-4e35-ba51-a1c0a82a4909@drhqmail203.nvidia.com>
Date:   Thu, 30 Jun 2022 10:09:52 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49001b64-f447-4a64-afdf-08da5abb5994
X-MS-TrafficTypeDiagnostic: BY5PR12MB3700:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /tMDYsz1Q5ggXwpTxYF68wAok3pH5VOPMONzVFOr+qEz7ySZI1zZx/sLy6dQXjn+U79C56FGblVeYGIK0QBNM8Z2C+TlNSTdjN4BFQ2XxK4pU4GOKS3nbhR4qlr2q9SYKmD/fheYvWa0YXKl8+grt0EG8bQ5IBOk9tQdhEEV5nPfcd4MzbeL0ym2YvVDXNLLjK00l4w5SdE9gGE23CeOEmq5Z0aNIYXFJtXt3IkvHeJYEFfIIrX0jZUKWMda6pmWrVZz79x20e+9V8QeoxGA5A+wzXl6R7JQ8C/FIes35LEeaLDdkUBr9HMYbvQayY6/ssiWbYrYm+9r6QbphBY8U5oO/DMNXbn69NkXJHI+7lG4IoO1FnNwMg79N9IN9CA8Dc7SSoe5FlmtE/k/Yl8kOcIGkj3IbhDtFIbQhvbFRWsze6ozG4rw/zcWsWJaMG5pi6AnwvXvqt3fjzJxrI+E2dFfR/D5YZQ8AQaP17P15XiodyO+a2/qvBtZpXW1rTkq7AcvyQLX8A0J47jAHk9wtzOTt2a6BBSFtSXRE9qbSaqLgS7Ys1DPnXEgdDtMA4Wl/3ZYxP6udeKZibnmA8xaozwrNzxXdYe8Xh+LS9sTUrDO5GzrkOCQkCcdaKHBksZKNC5zLKKEztyEQZy0whhFjKEQCzjeQ5AAsoPg3/M/8SgBZLWhqmNCpExIZIQmN/CclcjKVWq+fQ+mk4Rl50Ej4KSoQTidUzq8PqFNucMJGU4Jp01xrkOFzHsziut5Lz0FM1Gv6Fy8pMjcLuShs98PDU2ocHGATD/qNe92asR0H7AVXlLKi6VNIDBY04ueaClZ+4R/UpK0ID1onLfI6w+mYWZCs+KKZT77tnKn0/Uf+XhEeaJRJYv7KRMNeD5knZ2Y2ueV/Ka+FaEUw7zIv2g/dR+Yg3M92segmvSUxI+7304bq98Z4okW6UfCOnz2e+TX
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(46966006)(36840700001)(40470700004)(70206006)(7416002)(8936002)(5660300002)(4326008)(26005)(8676002)(40460700003)(2906002)(40480700001)(70586007)(82310400005)(36860700001)(31696002)(86362001)(426003)(356005)(47076005)(81166007)(82740400003)(478600001)(966005)(186003)(54906003)(316002)(41300700001)(6916009)(336012)(31686004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 17:09:53.3397
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49001b64-f447-4a64-afdf-08da5abb5994
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3700
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Jun 2022 15:46:54 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.203 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.203-rc1.gz
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

Linux version:	5.4.203-rc1-g9e421f18b387
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
