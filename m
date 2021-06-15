Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13563A730F
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 02:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhFOAk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 20:40:27 -0400
Received: from mail-bn8nam08on2047.outbound.protection.outlook.com ([40.107.100.47]:65024
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229829AbhFOAk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 20:40:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsSzOwmhpl2CaSUyWwTmMOUK6V0kHBQUxVFWft/WiR9uSUjEnSWvQS/AkErJQJkec/WCkoao9xBVUrJR+srL468Rmnmq/pLbSWEcfNh9H7Z1AzhvZBDG71X6WTQv0Ybm2r0yCAQJwkJ/h4jDMyvpteTkjFcyfaHSBXR6KSB3cQsu6Gvjgyv7+pRTiC6+TUtUsZOpLd16nIt44RQKzDdRSQyys0mLuA8wc26t9LISDBXd4UeCGiWY/kTAgxqaGH5WZlEBLw9KG1Wi5dhgI1rurHfl26WkifhkbcOvEH9/liv1OEzlHgfADJ9928gdH7KntRRCXboWjzYnsOi5g/Vqeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+BwxUOyBcnXI7nl+HW6rbwXBHY/QJu5Tq4EvQ2Mg9A=;
 b=H3a39vrcHoDACFy30v1jf+/e5YJDtIWKkL/pmEbXzPq9C7uY1lz/oOOeZ7xPpeAmS43sV9vmsKIyxosCgMJkDmENIwDYbR3gcSxcsWnmfVViYDA71Eej5xJiAxgAQyr9gm9r8vBpnZ9B9GlALAE7KtpQ7ly0vdoYiDFzQQTzWwusJ81wluBl3mcqXgfFUO+jUsf19AlXCdzmvcPD9R/xnHpjb7Gt6T1GnnA2/23nvgDNhHMOgb7swzmNTqnu2LEskWli/b0vTQ/QTllT3sF58J5aoLG28V1cLs25c0UuUtnjCcqAVml/vF+dqR5YtgOi4pYYGHZ61Fn9DN3HAknE4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+BwxUOyBcnXI7nl+HW6rbwXBHY/QJu5Tq4EvQ2Mg9A=;
 b=rXi5Km08QznhBXx0GTPGe716+m0hbsdjCE+XfnVC9R4YRFB0gLYdHwmx8UE6xfRwhtwnpwJYyDX1dT6hQ1CDFMfgZndEm2vbW0QmbcRNqCY/CcgIsAib7juSSaAR0qHbifwym+P8QKe/NmmndOumqFQuK+TFT3D91d+HG5LsoyCZfKDCw+V+M9yj5MonpUokfqsVZzZbd1VeuNMEIFuWZotpW/E0vm63cZQK91yWsXdf6oK7ODGBVKaq+1hXpY3YL88r4EVV0Zkb39+4PY5QB3pTwvuQBsQNlG2RjGDZhKndoUUpY1C+1oeR2No7qhoVPIA/rFjy5cMPDubXy2YYlg==
Received: from MWHPR1601CA0011.namprd16.prod.outlook.com
 (2603:10b6:300:da::21) by CY4PR12MB1320.namprd12.prod.outlook.com
 (2603:10b6:903:40::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Tue, 15 Jun
 2021 00:38:20 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:da:cafe::e6) by MWHPR1601CA0011.outlook.office365.com
 (2603:10b6:300:da::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Tue, 15 Jun 2021 00:38:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Tue, 15 Jun 2021 00:38:19 +0000
Received: from [10.2.81.70] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Jun
 2021 00:38:19 +0000
Subject: Re: [PATCH resend] mm/gup: fix try_grab_compound_head() race with
 split_huge_page()
To:     Jann Horn <jannh@google.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
References: <20210611161545.998858-1-jannh@google.com>
 <20210611153624.65badf761078f86f76365ab9@linux-foundation.org>
 <CAG48ez3mjsf41Z2vCjmkuBaHe9XgoXbWDGvM4OJdUjqiCQbN4A@mail.gmail.com>
 <9041f85d-515d-576d-21a9-6f10b6e1279e@nvidia.com>
 <CAG48ez3Vb1BxaZ0EHhR9ctkjCCygMWOQqFMGqt-=Ea2yXrvKiw@mail.gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <ad8601a0-f520-9986-1a6c-2852e2e1d3c2@nvidia.com>
Date:   Mon, 14 Jun 2021 17:38:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez3Vb1BxaZ0EHhR9ctkjCCygMWOQqFMGqt-=Ea2yXrvKiw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22ef54fe-f7b2-4202-188b-08d92f95dfa9
X-MS-TrafficTypeDiagnostic: CY4PR12MB1320:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1320E86C4E218996D944766CA8309@CY4PR12MB1320.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V4BwzmYi+/6PnRifqxUDIZm+WAy/Pan4lky267QbyspmJEfvllqsay4423ecHM5rDXvCptHmnAc4Jka+mCjm9wx7zKP708cyLDZI3vdkxW1O93YR7DYQrJ/6CdWrgAKtfe4jKh0m9FOktjxiCpeSO+CH0UQLhr6y8Xnq8lO/UI0pGDZl1FhLKbhSQvwg4ZI07pKSN8OwNKy1sO2p6Hw2o3I7M08HCfl3iYCZ5/Gi+bTjJZt0FxsU2fixydtQ5E8eUT9R/eF8ThY9naNr8EcYsp23WbPXaPtsqgP2iZ+TSCUHX00Or6NN4zPSWCR09g9buxXnTw8LSBqCmERWMedYLkxMDN9GYIkNnVYn/zcQbwsCiBHU05czIsarcmiWCk7Xy5Jh8nAFrUc9Vq1PYFCCDd+ks7aoiJ7drIE7dok7mfOvf3akj2ucWp2738JqKdlosLqlEVfazZiBkOLSnGVWzXsmw/RTymYsCw/qzUEv+1Tu7zD78Vcxchrjkqv2QB0y7T20BTIf8GVyhniZOZ2A3qvalDbAzkmsYhWeOFmXQMC6OScln6JB9Ghrxg9vQBB8ln/8HdaFdWjqM4vNH1xnutE2+Q/sQe0Zm1HzNgru+rhbw5wHubqrcAQLzHM+mNmvBZ3acfsuXtCfuyTWqELCMG0yIhTt5ovzYXne5EpC8L6sopbnyKqXpyEq+mbhkDhTqDycf9I7OLJzlMzBxBIaCg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(46966006)(36840700001)(53546011)(31696002)(6916009)(36860700001)(16576012)(426003)(86362001)(26005)(2616005)(47076005)(478600001)(83380400001)(82310400003)(4326008)(5660300002)(82740400003)(8676002)(70586007)(31686004)(70206006)(186003)(356005)(7636003)(8936002)(2906002)(36906005)(316002)(16526019)(36756003)(54906003)(336012)(14583001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 00:38:19.7560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22ef54fe-f7b2-4202-188b-08d92f95dfa9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1320
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/21 9:47 PM, Jann Horn wrote:
...
>> The VM_WARN_ON_ONCE_PAGE() is not implemented exactly right
>> in the !CONFIG_DEBUG_VM case. IMHO it should follow the WARN*()
>> behavior, and return the original condition and keep going
>> in that case.
> 
> But the point of the existing definition is that the compiler can
> avoid generating code for the condition in !DEBUG_VM builds, even if
> it can't prove that the condition is free of side effects, right? If
> VM_WARN_ON_ONCE_PAGE() was changed as you propose, then I think that
> in mem_cgroup_page_lruvec(), the compiler would have to generate code
> for mem_cgroup_disabled(), which calls static_branch_likely(), which
> ends up in "asm volatile" statements; so the compiler probably won't
> be able to eliminate the condition.
> 
>> Then you could use it directly here.
> 
> Depending on whether the intended behavior here is to skip the check
> in !DEBUG_VM builds (which was the case before) or also perform the
> check in DEBUG_VM builds. And if DEBUG_VM is a config option because
> it might have some performance impact, isn't the cost of the check
> probably quite large compared to the cost of printing the warning on a
> codpath that should never execute?
> 

That's true for these VM_WARN*() macros, but not true for the more widely
used WARN*() macros. And I was hoping to bring VM macros closer to the
WARN macros. But as you point out, pre-existing callers expect to have
zero impact in !DEBUG_VM builds, and so some caution is required.

I feel like a separate set of macros would be reasonable. Something that
has WARN*() type of behavior, and accepts a struct page (which typically
means that WARN_ON_ONCE is required, because for pages you have to limit
it to that pretty much always).

thanks,
-- 
John Hubbard
NVIDIA
