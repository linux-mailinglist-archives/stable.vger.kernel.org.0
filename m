Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE566CD0D0
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 05:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjC2Dpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 23:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjC2Dp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 23:45:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E052728
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 20:45:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYpJPLuQPx92VGW1DY/E2VfJCq8SXPRQ1gpPNXxmRVeh5Ce72LCt4qpo0tpduLB8HU0lhN8qwOgn+xUzR/Y2AdNsADi2uIfAqgkFYVpiAbuBXUrmNl3kE7PChLTQkTx66eDCLiTN5jbx/XtP65GclNw+gs65vSyLF8TqxhCe+6+NmUb835dVM/AwlcQ/FiwRG8hSBWYo1nM5POLkFaCdoiIq5RU+Yp9E6YyUlJyXiKAPZmJGqTPApHqrl8cDJAUI3HX+hAYspF8SEk/ahAKSqhmmmdEki1xD34tqMT8JkV+9iiKcch+SFqdv2fBCEXmQ1l0hWQ4AM16rLzAE0va1sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VtZ/dg/FCavFlJdlQFKRFOc1d5MaDfynq2yufp2TEds=;
 b=lsLpvh7IBt6YI9QP68P55GRAcSm3FeTlJeywkoYJM5IQ/6iL7PcZh7laU2G4dfp4gdDCN8oVlLgPaWZa5itvXxTOxhCzRMEuIhqND1OtZQ9ysibCpLFnPPjY7p5+uGOKVWWgCTc5wBD+CieUTw2G0JvO2k7gYRhQAZiNnRyCyHI1MGWxFTzzT84AnxWMz6ku8UU0aHIvmSSnXwA/boyLjE75aSWIQRbh1M2SVY82lUoqxIre+nhUwOrd9ftuu0corARSWW5eW6NZqbj6jY/V89EqaJ5LlQfrt2NARUbIBcB4Fd4t6WTqrhFKUe0GL+85vJEJL27Q12XvwD2mrDpEcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtZ/dg/FCavFlJdlQFKRFOc1d5MaDfynq2yufp2TEds=;
 b=ZFj85QiZYW+LF4HC9FhS5ZMgZAj+ij2LP9WU8Nzz0jyBDB8TSVH+SyeB2aexuOWtvA5MeyXYibuFhFW6HrLLBfAZWnkckohTULgal7UF9Vlt1lotv+hOaJD9IzNy94uB9oA+v5p62IBYwjnZfmtC3sbjRM8BhO5Te/N01rFJHu9Igiqb0QUb5kN7xmg73M7THX6GgJfNiK5thuKM/7UA7XQYUJikfSJBKaU3atJ5dzH59cLnsUMjPhHToHkMmsvyzR86nnLsZAgikkb7NiWqwl8N5T2eFZ+bZLC3QkClkyxCeEl5lGfKC4JtIcjFRTOj/13KKw2Vrgw30y4hbsIzHw==
Received: from MW4PR03CA0342.namprd03.prod.outlook.com (2603:10b6:303:dc::17)
 by CH3PR12MB7594.namprd12.prod.outlook.com (2603:10b6:610:140::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.29; Wed, 29 Mar
 2023 03:45:26 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::bb) by MW4PR03CA0342.outlook.office365.com
 (2603:10b6:303:dc::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Wed, 29 Mar 2023 03:45:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.22 via Frontend Transport; Wed, 29 Mar 2023 03:45:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 28 Mar 2023
 20:45:16 -0700
Received: from [10.110.48.28] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 28 Mar
 2023 20:45:15 -0700
Message-ID: <bbc8bc42-5f2a-9238-94e9-b2191e2f8c7e@nvidia.com>
Date:   Tue, 28 Mar 2023 20:45:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] mm: Take a page reference when removing device exclusive
 entries
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>,
        Alistair Popple <apopple@nvidia.com>
CC:     <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Ralph Campbell" <rcampbell@nvidia.com>,
        <nouveau@lists.freedesktop.org>, <stable@vger.kernel.org>
References: <20230328021434.292971-1-apopple@nvidia.com>
 <ZCOtiZFoxC6w/eoZ@casper.infradead.org>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <ZCOtiZFoxC6w/eoZ@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT009:EE_|CH3PR12MB7594:EE_
X-MS-Office365-Filtering-Correlation-Id: d8fe3ff9-8830-489a-f7d9-08db30080857
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2oprKiCBul16PaM4e5lsb5jBdftFEAdseFu0SxWhHAG/kUKDmzXe+Sni7qYWM3wtBfJ9f+53zvlwQPT6ZvlLVJ0DjVUTxvjKLNi1oBU6zWI3JwmYKRKDPT0REWMCowrZGS0vlId2GG+5TVaz0MsANGoPAmRLHBSFdduEw4OjdIcRsmKy7m1A8u0euTRX5g2Ckbu6clt8Ljvm1nlLWZ5s3Er47BcnVVENZD0ixQ4Sa3+Endmib8iv5S4teoxnICHfe8iOd7O/IuOzm/iNC/1ZV/wWTjQG0JkkugaQX63NXjpARQY4c3HOzgnshFHUSLk+rv7KMiqk1d4zUKVXSZ/YsuileVXQvo2yNyxkIYGCdC0+KhaKrtq68VsGxLfLqWtyE4txfSglzLeEX3thrb5hhENg85aJRSa6ZRB9FHa3/gYXLYEYRX8uCnUietHxbTt9eXS1H/ba6jlGlqAoPJ9GzIIMOwFyfKo85mLwkq/MLGyuw3c2x3U6UUdUYZIBhfHnrHs14+dqD0o7CrIiJlPEQsKTxCm2wkd/CSC+bNVh1MUcoYBQAOLx0VyhG1U1myYvU5kwVzkTbJhkSmZbzX5/ig1Es3vAYv2EVf3QAHPKbpL8CqvYgPSCMGMhg8qnCrZAMA17uAYFj+Bj6CWM92ZiKTu4hgbF8OA5jDtMbMxSOnyCX4O7haDPDCbKcIKndZHJUc4SDrG9P8IcLgFZX6EBLoJM0oM6wRS1tM/f2rbnLKnnIZUfTJfwgNWcfM3lJ3ypX6SVQOl2Ft2gCl7NRILSlxwClcrUu/QbvdX9mvB4OhRRuwdG7s+HCqmLqghA8Xlu
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199021)(40470700004)(46966006)(36840700001)(8936002)(31686004)(2906002)(47076005)(336012)(83380400001)(426003)(2616005)(34020700004)(36860700001)(41300700001)(31696002)(86362001)(36756003)(40460700003)(7636003)(5660300002)(82740400003)(356005)(6636002)(478600001)(40480700001)(54906003)(8676002)(70586007)(70206006)(4326008)(4744005)(16526019)(82310400005)(186003)(53546011)(110136005)(316002)(26005)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 03:45:25.9974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8fe3ff9-8830-489a-f7d9-08db30080857
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7594
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/28/23 20:16, Matthew Wilcox wrote:
...
>> +	if (!get_page_unless_zero(vmf->page))
>> +		return 0;
> 
>  From a folio point of view: what the hell are you doing here?  Tail
> pages don't have individual refcounts; all the refcounts are actually

ohh, and I really should have caught that too. I plead spending too much
time recently in a somewhat more driver-centric mindset, and failing to
mentally shift gears properly for this case.

Sorry for missing that!

thanks,
-- 
John Hubbard
NVIDIA

