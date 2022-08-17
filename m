Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD49859670E
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 03:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238144AbiHQByn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 21:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237734AbiHQBym (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 21:54:42 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE63996757;
        Tue, 16 Aug 2022 18:54:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBcehth33uE01Ka0UznRj+3zoRaLIClPESQjV8rA8Ku81eB1Pqc95a+wGz9WDUy4x3ND64l7UaMkHo1t/2/E6OnuULNugc7nKWO5ratMUhWea5IyIiIgICn+w0PGoCWJZqpdkiKF7fnP7wUKuy1NBTRfhFhrZaOY2g7VmP9KAarHc31PhPtF9O1vyVLBcIREFzl6tlP+zS9E+pPThrmvbvX8DwMWik2tPoE5IE4CjEx0UOb4GKAcucriJWr2VaH9gbUIlVS04lXugRju3vxSWggRYixmhI0rTd1e+bflBPJOgkKea9zDS6xQ/e6hobpAYSAqR+fDFKpQuunBggp8Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JwzRzTZo/bTe7fhmMmGaM33C/G34Zu6E6yMW8E2QnQ=;
 b=g9vkpo1bgMh3lgIWZ1tTUVt63aX2xv7dxp4OeTVyZqJjTxEGE9IQqEW0qhMK/E7vnTPMrhOVWNtZ7GO3UgM5Xp7DjGe0FI5NX1tKVzbyYN7dW8lpCY9tlef9QJrKrkTrT+GbNlWNDUd4soFAq8l7Ox0bzD65Ze6ENC+vkiG1jNjtBc+pVd0tVrvY/ix+tuf58EDSQdIm0Pc8SKsYHED80wBraDXMtGPKbTf0/KBWxgVDc/OP3EeFTCJQHHs84Xl/LFJzC1AghXp3+RU4g7PI4HQnOFo+zxZGMYL//Ay6U/ahzjVRSIHkYS4Gf3z8cFYvKcvRguDfpk8sXoxMB57vNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JwzRzTZo/bTe7fhmMmGaM33C/G34Zu6E6yMW8E2QnQ=;
 b=WkbJtlHEeE7iqXI9m9B5RNO7YOsaaYeFkP/GNmnh6mJC2XA+H9JwsYye5EtN8DiNJ2uoAG5QoeECqnvNvXVaqIcUJwR5MAlnuhCxPc9+yEW7BM/cB6GAF8ufeJgwe6cZvEGUUYK0cPEYQZtLaoMNJRiZ8R/LOTOHriL+COoqgO35MPGBdSchS7vLDu5lry0TBrOW/2uREH+httCh00iHR/b78gfodzvVOgo8mhyb5Ozd+8WXGKsdtG3kg3LOoWkxvT+svZrYhwxSPUFu5uB2U5QI0L5L/6ID9KDRHWEjGt5ln9Ie4QS8EgNmmWTAXGoQwHHxqfgYH6AJTZUNlGrduw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by BY5PR12MB4276.namprd12.prod.outlook.com (2603:10b6:a03:20f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 01:54:39 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::eca6:a4a7:e2b2:27e7]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::eca6:a4a7:e2b2:27e7%5]) with mapi id 15.20.5504.027; Wed, 17 Aug 2022
 01:54:39 +0000
References: <6e77914685ede036c419fa65b6adc27f25a6c3e9.1660635033.git-series.apopple@nvidia.com>
 <CAC=cRTPGiXWjk=CYnCrhJnLx3mdkGDXZpvApo6yTbeW7+ZGajA@mail.gmail.com>
 <Yvv/eGfi3LW8WxPZ@xz-m1.local>
User-agent: mu4e 1.6.9; emacs 27.1
From:   Alistair Popple <apopple@nvidia.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     huang ying <huang.ying.caritas@gmail.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, Huang Ying <ying.huang@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
Date:   Wed, 17 Aug 2022 11:49:03 +1000
In-reply-to: <Yvv/eGfi3LW8WxPZ@xz-m1.local>
Message-ID: <871qtfvdlw.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0067.namprd11.prod.outlook.com
 (2603:10b6:a03:80::44) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 079f6b67-3404-4939-748c-08da7ff3720e
X-MS-TrafficTypeDiagnostic: BY5PR12MB4276:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FJoXUaCSEGsayOjZr060UkboC968klLIUWGf1ltT9GuTSaHyinfO6mfY/3CE4o/vPtbyVuXyiHcO3bKZpq0GL5c/nO3+lzNNL77LpwVp0uILY0u4vm6QkUF1o3bUXNaF2IrMO1Yfi9nsbEgsRKDcX9IstmzyiJ/tw/NfLZm0N4+CU0v98m2IWDrcaUefYl1qy9y6ir1EE+WuL1WJd3/BR1KLs1rwozgzKsMMXYS1xtnsjT/uH1ETISNraRTdi77NZ06X/zY3c7Ef0QAGVqBwa7d7TXCshTAlgo5WwvA2E/zDQJ2AGeNKjNyGBRFp1MidFVoWaQUfM04ghhJ4B6n0jVgynu1GqvButZs9rCpbyYYZgEypzknyKfkB2CykeqxVZcHgC0YFO7ZysSFc8lm4FgK7BkDtBN/v3C5M4I+7B/7j7XevChsjn9OOut6EkHn/jQBfdcns4Xj1Dxq343rL+4d4xeuKJHT3tvABLQDtLJKnS4By938BuQ8Tog4oyqykphBswjeUMZOD+ZJyVVDHoQdZkCqMp0o0tUl67oPflD2EgS/rGfN4EVenpp8AgtpCh3O7POtG99o9kKlp05cwpQ6+w4qsLcCe0DnlfOECt2FprBb8oqyCqXLqPZHmcLjne8VFARGnPiGzDN1fxUimOMEQaWy8mJVEp1t1HOgIvEC3NtJFhiBwvlkAoUIs/K3L5VoB3Cz4vpah4iRsZszENSuVPIdH0xvCT4d9GQwI2juVgMD7VZmD3RKLH0jzmT9M7N+rQ4mReEOZQdVibKQObVTOlqIU6sSdX1K/MryHQFE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(86362001)(186003)(83380400001)(9686003)(6512007)(6506007)(6666004)(316002)(54906003)(478600001)(41300700001)(66476007)(66556008)(8936002)(7416002)(66946007)(8676002)(5660300002)(2906002)(26005)(6916009)(38100700002)(6486002)(4326008)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wsAn2SVxSqGIKJ9LCMnCHs1bTNFoawLOStQIgOQHbdXPVZsQhVXJymH60gga?=
 =?us-ascii?Q?+dgvKgwAHnzc7mNPiixj8oTtJ7Jc+Ivd/Jut7hkNeAgSioWUxAzdIVHea9i9?=
 =?us-ascii?Q?kDDjrUzbprdazSzq9zl0vNzJKaAo6W3iJTqvImmd9SSQ/pCa8iEMkykN0aZ4?=
 =?us-ascii?Q?jpemoX5XQ5MM+AgIxvUe/VJY9gKXWch14nYd3FC7P/A8r8Ja5ZavQW/+M1we?=
 =?us-ascii?Q?ZjI5NoPHvGNwIMSk0oqE+LoMqrfsHDJfaiVfhPeMw+xnUwOaFU6sWON8ACaW?=
 =?us-ascii?Q?X2Z8aKBjcIZnO/aEBBVBWH7EPQDLy0u32FwAFZ5Hsvu9w+6DsPe2AIS5k3c9?=
 =?us-ascii?Q?4kJ5+RdNssaa5lSvEtz7TmUj0G+H5YroWlSjvLLo7SQ1F+EFX+Qr9/i2WuNc?=
 =?us-ascii?Q?nx5Up/gvaIc3UAkbdlGMTsaCdel3ERMaTp5A9YNzBSCMmhC01A+QM0jIUH0Z?=
 =?us-ascii?Q?41/f5fKTZqq5VA5Z1fLH1OuVwkVEy95O7Thw/7Sqxd0jRa6hVGuc7adq3G0f?=
 =?us-ascii?Q?k3HiRxRisEJ/Tw+WF/FKXWZmiHBL0sdxf+wgPvoa17rdsPk7Aay/wRfIlv0Z?=
 =?us-ascii?Q?mu59zucgR+HuamDKPpOofoP6pw7qpQ2wgRDkXC6CjX81jm6qr3TXxdjmITwA?=
 =?us-ascii?Q?0Lx9cXAzt1+FTdmBw7tO9dSZtF7ugfQMVkWFUuT1/hW9lc/OdXoyesRy4i88?=
 =?us-ascii?Q?UQETfahgDTbYX6KIVEA3YbsEyqZ39WT49nH9AEARtXMT0YF8eZePLAKhBl2G?=
 =?us-ascii?Q?4Fm80+o7frSqjLJHZGNwmApu/bF2h1eyrAcLeAVdlcLUSegLmPumb4KokWtS?=
 =?us-ascii?Q?K2HWgHKkihw1vp/OgOQfuNDKRz+MUcBTGM+yWWDjmU6AjOcQ/gcONTGQ/LhA?=
 =?us-ascii?Q?02qzDE3oKwnNXsu/xMinbnN6UUXZ81ch+tBL6OjIkbbj+1Bm196zrLF68wt2?=
 =?us-ascii?Q?YWzq96CAfsX62GFsGGgtKNAknaDz0CVkP5oe/5yHEH48nI32D01G62DIeDy+?=
 =?us-ascii?Q?e9OxH03a+M8IHXS9zG5xRtZAOFMgGY7r3L+V8OMFcbbPtcp/hVxwTzm4W63z?=
 =?us-ascii?Q?yycJUfaPZO4ODsgCqVvDIPpj0JLprz5Pr/96k7BF3qndynYxLOpd1+QbBnq4?=
 =?us-ascii?Q?A6U+SHYz2zrWzwH8WnGQLB01o7cqnuF01nCkQENK091uoanf5Ej7Bz5On5Ao?=
 =?us-ascii?Q?kx0OMT+eX+seWPX3iA6Kf0t55QK84uogOSl5OAhVg61ht4Dn6eS0SpaoFfJ1?=
 =?us-ascii?Q?/KEBLvVYQG+hYyInhzijSDnET0JDLJSm/nidLMoQcs35RYcRNnphZkKdcONL?=
 =?us-ascii?Q?OWRmPoz9nJeCBaxntRbt14zwICia6z4VqHARWdQ9ZyGoIVnoUg7okGfEgIhc?=
 =?us-ascii?Q?+SGBiPdXVud8XwY93egqxRTiotz8oraht2aLQoY+O2nBKuOVLDGjEH/4Mxp/?=
 =?us-ascii?Q?j0rPEFByU4vTgNnfJCGdqI8yp8PDX399YxIKtklCXYIdDEtWeKHVqdD2Tl4i?=
 =?us-ascii?Q?f6R8G0BUQIjCHUYtVYCtTdFbM1lGhO2nVZvZPTgq812IRqShT7Gj1SnEmjxn?=
 =?us-ascii?Q?/wuGOsxVF3zl5yYeCUF02GD99PrwXouKLmiHYPUE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 079f6b67-3404-4939-748c-08da7ff3720e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 01:54:39.5239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ERdGm4UwuXUO4du3bOsaXbD/0m2/jxM9wZ6IGnHvDS0g1iO1qVb8gUKn4/jCnwLQNWw1BIQpSvPw4eMnW1+vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4276
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Peter Xu <peterx@redhat.com> writes:

> On Tue, Aug 16, 2022 at 04:10:29PM +0800, huang ying wrote:
>> > @@ -193,11 +194,10 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>> >                         bool anon_exclusive;
>> >                         pte_t swp_pte;
>> >
>> > +                       flush_cache_page(vma, addr, pte_pfn(*ptep));
>> > +                       pte = ptep_clear_flush(vma, addr, ptep);
>>
>> Although I think it's possible to batch the TLB flushing just before
>> unlocking PTL.  The current code looks correct.
>
> If we're with unconditionally ptep_clear_flush(), does it mean we should
> probably drop the "unmapped" and the last flush_tlb_range() already since
> they'll be redundant?

This patch does that, unless I missed something?

> If that'll need to be dropped, it looks indeed better to still keep the
> batch to me but just move it earlier (before unlock iiuc then it'll be
> safe), then we can keep using ptep_get_and_clear() afaiu but keep "pte"
> updated.

I think we would also need to check should_defer_flush(). Looking at
try_to_unmap_one() there is this comment:

			if (should_defer_flush(mm, flags) && !anon_exclusive) {
				/*
				 * We clear the PTE but do not flush so potentially
				 * a remote CPU could still be writing to the folio.
				 * If the entry was previously clean then the
				 * architecture must guarantee that a clear->dirty
				 * transition on a cached TLB entry is written through
				 * and traps if the PTE is unmapped.
				 */

And as I understand it we'd need the same guarantee here. Given
try_to_migrate_one() doesn't do batched TLB flushes either I'd rather
keep the code as consistent as possible between
migrate_vma_collect_pmd() and try_to_migrate_one(). I could look at
introducing TLB flushing for both in some future patch series.

 - Alistair

> Thanks,
