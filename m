Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7A66DCFD9
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 04:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjDKCsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 22:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjDKCsa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 22:48:30 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309D51A4;
        Mon, 10 Apr 2023 19:48:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AW0wf7JKPr1DXvKfvLacR1YhOYOnDUNfxO9WfOHkS8sFrErp+Kjv4ZimtY67SQRJ5HQVKJoj8wWQzYMl4ifZud1ZwoBMXCQ60ammQKu5tb+UHh378jGRuAhCJXDRmP1WEbZBFmB0NagGw7ihTckAbd5EwqlM6f4V2CmSm9H85lPcsEjV1QnoeKaiOUwtciq3aQ7ECdiM9oxKBqTxUU9HWKmXskkicIeHjZDX3LRQ7K2eoawZZ1tuWJpbmFbVp4wE/WitryhBGAOkQFh3s/IirFe1StpMiXGaDq96D4uvUvyMdFa3fc1VY8B3idA44n7wr9Q5sCmcpEYIz+yaN5VzxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0pbRMVYvrReUroTrHh6N1+xeIuJO8v1kAsqLakfzPI=;
 b=cVB0NB98nRli4dHYFQ+PCKIZP/JF+92TsJP9pflDDINLcoT5PiVHNSwgY16u9ylb72HcpU21tIiSefdU7VOSv8NV1qw9EaX8+0h9DDy+QR3kYlilK3iHmXRfcI5Jv9ngaeuOMwLq3PcJg4Y1+Qc6uRVOh74ixq1WJIUNd6WAuLkhQk8jL3N8lRgwXxJPzTs1LV94zyWcr5u8kB/258hdyZjf5G1ujIik+n+SngWZnIgKtnE/qxgu3tqARxmIJM/47+8sNTcBbbfIulUipKUCGt3CZaJC7eFE+8HNSslI+QB60hXHcefD9+JFo9pt+94cRjHKEu/SfCCEFbTTSQhvPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0pbRMVYvrReUroTrHh6N1+xeIuJO8v1kAsqLakfzPI=;
 b=qnTyfVZyctLVKlkJfJwJRMBwEkf6eSB9mSSBXnpcZJCXART1g59VJB0eQJAv9uCVmgDjrjxGVDl5pravHPOhBZeuFHjr9Lj1rtvwMvVNfY66YvHcVRSnzqyz2lMjJqbCnLie4ixcAlgcyiciCG0ozeSL82Q5AGhW/jLCdA2j9I/K5d8yORk9Rb+0JpGWh2MwRmOhPONDp4dLHCK7hDsHBP2LkQ5vo/i+J/Vtq4GKuJ+QihP6HSQ4OsOfclsZyrwWrLDdDYTbTOCiwT/iCqjIU+HKbbYWFmJljb/Qe7pxzXt0jhHz31/s5tCORc1naPeomd3CHILJkfsJpTaep5FoYQ==
Received: from DS7PR03CA0151.namprd03.prod.outlook.com (2603:10b6:5:3b2::6) by
 DM4PR12MB6399.namprd12.prod.outlook.com (2603:10b6:8:b7::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.35; Tue, 11 Apr 2023 02:48:27 +0000
Received: from DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::1c) by DS7PR03CA0151.outlook.office365.com
 (2603:10b6:5:3b2::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34 via Frontend
 Transport; Tue, 11 Apr 2023 02:48:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT078.mail.protection.outlook.com (10.13.173.183) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.28 via Frontend Transport; Tue, 11 Apr 2023 02:48:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 10 Apr 2023
 19:48:17 -0700
Received: from [10.110.48.28] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 10 Apr
 2023 19:48:16 -0700
Message-ID: <90505ef2-9250-d791-e05d-dbcb7672e4c4@nvidia.com>
Date:   Mon, 10 Apr 2023 19:48:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] arm64/mm: don't WARN when alloc/free-ing device private
 pages
Content-Language: en-US
From:   John Hubbard <jhubbard@nvidia.com>
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Feiyang Chen <chenfeiyang@loongson.cn>,
        Alistair Popple <apopple@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <stable@vger.kernel.org>
References: <20230406040515.383238-1-jhubbard@nvidia.com>
 <CAMj1kXHxyntweiq76CdW=ov2_CkEQUbdPekGNDtFp7rBCJJE2w@mail.gmail.com>
 <a421b96a-ed4b-ae7d-2fe9-ed5f5f8deacf@nvidia.com>
 <CAMj1kXGtFyugzi9MZW=4_oVTy==eAF6283fwvX9fdZhO98ZA3g@mail.gmail.com>
 <8dd0e252-8d8b-a62d-8836-f9f26bc12bc7@nvidia.com>
In-Reply-To: <8dd0e252-8d8b-a62d-8836-f9f26bc12bc7@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT078:EE_|DM4PR12MB6399:EE_
X-MS-Office365-Filtering-Correlation-Id: d3b929f4-4eb0-431c-08ee-08db3a3739c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rJhYZzG2/JddxwAhmbf3R2iD4zWYBJj7NEnjjMpI5HpniMVRFEGrakOoMjsbmrm8bnxBRNFT2SpHumTk+jwhzJj/3fr0XRITH44rNCY60Lr33n3ubltInvcumecG1ipz7gqhUx2bhpGw8qFSukK7K1pPoe5neITR408kLRuphffUsKFbUFIPesTY4afZek5uSG8hCGG4duzg1jEhLcb2mWUPZTy0LdeGIAjNV7Qim2UGC2Ka5OvcCzD9i0Bq5h691roryrkBepuVSYFX+YjoHqWLqPrCaUfS2C/f5cFgCrQcTfoFixVNSLlkMV8AyCKH2uyAuVjVGyekG8pzyb6i0TlYZeqFsOAxQVsNm78bxk70C79iuHaI6t2oO5WQ3m5MFmM2rRlinYU34kmXSX6g+5UzSNHZpHOFBTwVTMKcond4YKqqGW9GWNZLHbtJWeBEP5HGuXhSl9u0g5PK7bhMT5c0OuxslAd8ZBWdBtTKJXgypTaDJupQPMQHLfqF65nCtiR3aWqy46hHlPmBxoDD0RDb02otTiRM6Qtq5Vp9K6j32RcnoY5Ln9GlQ3MLMSnwV3xwa8BivZvwrHABp10gRqMmh603og5Sz1GenMuoyweMCQDG7e3ljgoBUEHoIYWIHnHAieoKTo2K08fBjtLsBz8osWH6juO/B1nIAlzYifz9WRVrs3HdlBo38cwG06A0XFHs33TgBnus3rt6Aw1AfiKZaReSu2WdbpISIsLa+mG8m5NIbfs0biOr9VURNzAMkYhY9MEJiKZ5ZnUxhj0WSh4LIWDRis8Hbsfh7TEk7Co=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199021)(36840700001)(40470700004)(46966006)(8936002)(40460700003)(40480700001)(7416002)(5660300002)(6916009)(86362001)(31696002)(4326008)(8676002)(70586007)(70206006)(478600001)(16576012)(316002)(31686004)(82310400005)(36860700001)(82740400003)(7636003)(356005)(54906003)(53546011)(2906002)(186003)(2616005)(336012)(426003)(47076005)(41300700001)(36756003)(16526019)(26005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 02:48:26.8346
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3b929f4-4eb0-431c-08ee-08db3a3739c3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6399
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/10/23 00:39, John Hubbard wrote:
>> pfn_to_page(x) for values 0xc00_0000 < x < 0x1000_0000 will produce a
>> kernel VA that points outside the region set aside for the vmemmap.
>> This region is currently unused, but that will likely change soon.
>>
> 
> I tentatively think I'm in this case right now. Because there is no wrap
> around happening in my particular config, which is CONFIG_ARM64_VA_BITS
> == 48, and PAGE_SIZE == 4KB and sizeof(struct page) == 64 (details
> below).
> 

Correction, actually it *is* wrapping around, and ending up as a bogus
user space address, as you said it would when being above the range:

page_to_pfn(0xffffffffaee00000):  0x0000000ffec38000


> It occurs to me that ZONE_DEVICE and (within that category) device
> private page support need only support rather large setups. On x86, it
> requires 64-bit. And on arm64, from what I'm learning after a day or so
> of looking around and comparing, I think we must require at least 48 bit
> VA support. Otherwise there's just no room for things.

I'm still not sure of how to make room, but working on it.


thanks,
-- 
John Hubbard
NVIDIA

