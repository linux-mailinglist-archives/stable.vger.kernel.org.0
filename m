Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A77B441A7A
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 12:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhKALOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 07:14:40 -0400
Received: from mail-dm6nam11on2058.outbound.protection.outlook.com ([40.107.223.58]:30336
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231485AbhKALOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 07:14:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fpmyyk4NkyiyRatNDj6PxdffwwoexHrRgDR04Tl0k/eGhqNVkPUHlTI1Wq8t0TosWfbSAY1OfpArD3GebzDUhwj7JT17LOQBmELP77PH3s3lBWYALUeB3YmyAYY/s6r/9wXCcwbWjVAASa2+hrVGoqClFpB8SQt/szCniNpNeJFcScVel1pAWkTxK4M4bDnzqtPTuFvJmMX0mDrUVOs2CxKjAQvRlZeuC56qCwkOzd/0bmrMSymcJ4hFRQ2k+9Fe2uSB2hCOyuADuHWfNMAsAd2Mr07huv1nwGu9pnQn/kmUtWe2oVZanR31HE+4rkQlR0WQpBNiGnMHBnEY6aDvmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MwX6yy5dM1YRAM+bD/S9CUzXBnzfK2/fCVmBMGgB/vI=;
 b=cFnF/GCWgMTt3PgBbS2YDUcgss+004lKAbZV+0i/P02cF0zjBcJTX2S3KnBgE2co97EknP1zGuH+LohdbU+Mnmyz2BAPCVf8W6Zp8cCrXVsor522YgiFaEAOMP5rxLS+4WRxSx6VeBgl8eEdJH6m2PJWG4UcvxO9CzDXNAGF+WWSQvDxy0FFei//aJTpC+5wPejr4I+DKK5dWALYNO130F5MX8cdsZzgdt1lXL1vRIphGUruU7fI8UhGR2iTsYO2zM7n2AYDpD7XqKqWkz62GXpCVbs7FXsu/gE5LP9az19ndCKzdXOTqASezcrvLwYUd2vn/9BLBxcjJPW4JagEJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwX6yy5dM1YRAM+bD/S9CUzXBnzfK2/fCVmBMGgB/vI=;
 b=Xefbtuwfndx901AOmTRFTH4A/CP8mG1swacRmzjt6PhZFGM+l0W0m1U/bz4yq/blRvhFIa/40ouiJP9GAysh56KZBwPUrKkgLZhst5/PpFWH4S4Iu0fvdORgOr1taA7OMNn6MpLQscyIX0wLxhRxBYZgvgKUqWUNIxgFIsJ7lckB2Pxh0Aky7t5iNJQT3TeX8gpXxmC+NDx7E7pavCzeOHb0u7gNbw3Fa8plWMsXEAV36ge/HVSIDCseG1SiFBeGC8TfF75PoylBROvJ6FPGcYGctQRdLM0WCEV12a61ZTenB5XSGjK6FlxSlMl+AfxGOekB0HA1bUnypK1hLfd/Vg==
Received: from CO2PR04CA0139.namprd04.prod.outlook.com (2603:10b6:104::17) by
 DM6PR12MB2844.namprd12.prod.outlook.com (2603:10b6:5:45::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Mon, 1 Nov 2021 11:12:03 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:0:cafe::23) by CO2PR04CA0139.outlook.office365.com
 (2603:10b6:104::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Mon, 1 Nov 2021 11:12:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Mon, 1 Nov 2021 11:12:02 +0000
Received: from [10.26.49.14] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 1 Nov
 2021 11:12:00 +0000
Subject: Re: [PATCH 5.4 00/51] 5.4.157-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <shuah@kernel.org>,
        <f.fainelli@gmail.com>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <stable@vger.kernel.org>,
        <pavel@denx.de>, <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, <linux@roeck-us.net>
References: <20211101082500.203657870@linuxfoundation.org>
 <CA+G9fYs6FbiP=o=4ACyQ6Lp9YgUpOr9Xtn+ZhHdZm2Z+rhBJZw@mail.gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <9091c526-1a9c-2648-1b6b-146d2b911b5b@nvidia.com>
Date:   Mon, 1 Nov 2021 11:11:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYs6FbiP=o=4ACyQ6Lp9YgUpOr9Xtn+ZhHdZm2Z+rhBJZw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cea511c7-e9eb-4988-263c-08d99d286eb0
X-MS-TrafficTypeDiagnostic: DM6PR12MB2844:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2844EFC93D4258211BBF3722D98A9@DM6PR12MB2844.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 46Py2aEBIWUAQ/fYIlYBhEy/n6z7furuwkT79iAhfLb7d/RK0ITo9KNB2Ex1OSZfxvM1dfQW8+gSpqifTEiUph67HV+yYFglkZxfsQfxl1olMENKV5S6g47ENGwX4cRk9SaSI/ojsWCPn1gM8s6RtBP0NUfzQOdoxVJQD2xR1JGMDVBwg1tQ1H7/j+nclsOZyM3iNlNu8sNfemtInUmRCbUENQlrP4mYB5TMzLjkP11QBuxYx5YBVeDkG2l9HEMonSaT+8bTbztMhSkn5YncO82OjfzlvF8wjnuO/YYli+8PDM/a1giAML/Y/S/PO4IV2EO7x7X1gsGeQg+ZxJ7fI9o7KafLTio9IIfOpamxIbj14BtB5fltMs6+NEnQB/OntE1Uf5/tHhqNAxoPn1mVeYTId2bsc/zOWlX9Y7Nf/uSzpfqc4HSZfjp/yrRyej5pyo0rBP1c2scThzUDIPTqhFmrqVGSvbz6eNto9r7iH/YhavHQwubtn/9x/gjTNzWP8dXQi9QQXJxpP7xMBeY+AESQBHpRkAkTmu7RFQA+//g+VrwFK/hNZ1gOhtkMTm9NVCO6ASFiM7cLVY+h5CtiweLF21j/X8h+3S8UX1j9ZKqA+8g+I5n5gB6mG6CS4JygnZzcNlx5uN1ERlwTRH3D7fqxyp+QCD4Una/I5CvwtMMUdlP2ayPp41RxmrfQ7XthyZ9o0lqN8uuYGyPCfpnTfvoLgQO0T7QtlEPQEJ/FmtBLNLd9QM+yUtKf16H63vsSdq6TPHOkinpVUD9Di+mT7vLn3Cdt2pRuCH9jzi2sMVuzKs9+3wYZ/zHRMnbjan/W
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8936002)(82310400003)(426003)(508600001)(36756003)(83380400001)(47076005)(336012)(2616005)(31696002)(8676002)(110136005)(31686004)(966005)(7416002)(70586007)(186003)(86362001)(26005)(356005)(36860700001)(5660300002)(7636003)(70206006)(36906005)(54906003)(2906002)(316002)(16526019)(53546011)(4326008)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 11:12:02.9787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cea511c7-e9eb-4988-263c-08d99d286eb0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2844
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 01/11/2021 11:09, Naresh Kamboju wrote:
> On Mon, 1 Nov 2021 at 14:53, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.4.157 release.
>> There are 51 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.157-rc1.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> 
> Regression found on arm and arm64 builds
> Following build warnings / errors reported on stable-rc 5.4.
> 
>> Haibo Chen <haibo.chen@nxp.com>
>>      mmc: sdhci-esdhc-imx: clear the buffer_read_ready to reset standard tuning circuit
> 
> 
> build error :
> --------------
> drivers/mmc/host/sdhci-esdhc-imx.c: In function 'esdhc_reset_tuning':
> drivers/mmc/host/sdhci-esdhc-imx.c:1041:10: error: implicit
> declaration of function 'readl_poll_timeout'; did you mean
> 'key_set_timeout'? [-Werror=implicit-function-declaration]
>       ret = readl_poll_timeout(host->ioaddr + SDHCI_AUTO_CMD_STATUS,
>             ^~~~~~~~~~~~~~~~~~
>             key_set_timeoutcc1: some warnings being treated as errors


I am seeing the same. I am also seeing this on v4.14 and v4.19 branches 
as well.

Jon

-- 
nvpublic
