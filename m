Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652916E1F9B
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 11:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjDNJpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 05:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDNJpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 05:45:49 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2139.outbound.protection.outlook.com [40.107.8.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D9040FB;
        Fri, 14 Apr 2023 02:45:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdYtEWl2FvBeCCHmwxG/nJ5NaBMVPceylpSHe5J/iYD/5PxSM6xjkjNf59rpLkZKcrAnmKXlRKNc3WL+zdNMy9aZe4Q21c3PYnYhBgcSK9Vwdci8vJtnJSaFWQnacGiYz7ek7d8ZmmTSGqOhUhEbLJuMxwEoaPPDi4cVC0zcw9ozDQ6wctq3Wf7Lxg8R2EEvFd0VKxaGhkPJ0SlW9AFwGc22K3Xe6fMK4hVbUZikvFlJhyebdZI2OiNW4mCVZLWyWNilS5UNYH+uvnNxsZ5B1rfS7bTlWFVd5DElqdl59DmyG9wiFbNJrBhqRQW3BbFv3Rt+C4ne7vMfm2wUJ5GeHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yACxxRvdClYzWixx+CkadzOdGVq0QHKlM0PZh+2JCPI=;
 b=Wtv2SJ0cKOywKf8Or7Sjs8/gMOH3e34xuuvqiLT8lVC0KovjZiwndBxNp30gk9P70ruJwHml2eROUehe/eDHEqGM05sN5jXGLV7FuQdt5CNoD0CeNeJZSgCPNSrqhXXEdpAK/Ob8yLIiL5a9srF7xn4ijBSf7KYW6d4p5wGYW+cw4Z0gp0gbxCsuqSsl7fHWulKVrr9dNV8pPlQB0uBKCXm8r+ZaZqt6J+wImk2OTZ++uv1NO54zvL7lM4hw4OwaMhJ2pBNfudUlARmuDCDqnFXFSUlNN04BoAJkeM0sVxewnU4h72zTuulNqavhzGCdcAsqaTwV7fQTxqpyvj+6PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mbosol.com; dmarc=pass action=none header.from=mbosol.com;
 dkim=pass header.d=mbosol.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mbosol.com;
Received: from DB8P192MB0533.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:16b::17)
 by DB3P192MB2108.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:439::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Fri, 14 Apr
 2023 09:45:44 +0000
Received: from DB8P192MB0533.EURP192.PROD.OUTLOOK.COM
 ([fe80::d7f2:bd32:264f:64de]) by DB8P192MB0533.EURP192.PROD.OUTLOOK.COM
 ([fe80::d7f2:bd32:264f:64de%5]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 09:45:43 +0000
Message-ID: <9cb84b60-6b51-3117-27cb-a29b3bd9e741@mbosol.com>
Date:   Fri, 14 Apr 2023 12:45:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/6] mm/hugetlb: Fix uffd-wp during fork()
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc:     Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-stable <stable@vger.kernel.org>
References: <20230413231120.544685-1-peterx@redhat.com>
 <20230413231120.544685-2-peterx@redhat.com>
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@mbosol.com>
In-Reply-To: <20230413231120.544685-2-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HE1PR1001CA0007.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:3:f7::17) To DB8P192MB0533.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:16b::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8P192MB0533:EE_|DB3P192MB2108:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ee5a96f-cf62-4258-c182-08db3ccd040b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P/8EAbql0dcKCITBi0SX4HQXeHTRAhR5V70JfGYByBBQBWUqpIICOlvxAIRRQPJli9+Sg5D94qHXmzV7IUCamJUbfxNkbHXQyEfRIMY1a77Y7MiMXkiDdYTkUXoQFbaibLqZKfWbIv2y/eTigB1/tkoHgLN5vhYoq6SO5t4hZXSyXtxxRKUIodcZh2w9RLv7yVQG6SpbFqCBUoWxnp+yKOSngI/8GyvwskGEPOCc2io1s8ujBNSds4TyajEOmGYA1vpHBAm96OOUNL08AkqwlGgHI975+XjmR42GHAebbra3bELRKx6ShaW+YjjnLsCdNfZy45r7MeaqXYTAiuQs4M9/e4bl1M/CnwgqWpkC7+fUns3qGft4HV1fnU4BxR4lUMXUlxRCESca+fir6h9pdFwtPJBH018AWj7Wo4buPVdwt7Agl+DBm3oXFwE34oZWc2nheD4V6jaIkOdOmL68e7yIKmx0KSo9aQHeywxwdLJbn3RjRTw7qAwc4mp8++MabwNwskpXTnuZcGSwzWOfBoTILOnLO9frqK/xu7XC8J5mZPS97DWaWKD5xy+ZkzrNcNJmkoceORUZs9PkThqy3HpCZXA9kX2p76ErVeXElI73vaX529wGc0EIODWn+QLauCi28UOAC2zIIrKaTpiINjw6h/PEaANn3Zc9ur3S8zFfp4AtLlcpJDsvzRwfZaRp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8P192MB0533.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(366004)(396003)(39830400003)(451199021)(31686004)(66556008)(52116002)(54906003)(6666004)(6486002)(478600001)(4326008)(66476007)(41300700001)(316002)(66946007)(31696002)(86362001)(36756003)(83380400001)(2616005)(6512007)(26005)(6506007)(2906002)(7416002)(5660300002)(8936002)(38350700002)(38100700002)(8676002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3JHVXhEWFNSN1lqS0pmZjNSY0loSDVaZ3VNUVBxT3ZYSFFWbXhway92TnJu?=
 =?utf-8?B?eEMrV2Jid2RNdUFwMzNqdkFMREJiTDR4VGtjSGdBVHZQeEE1OTBvcldMdW9h?=
 =?utf-8?B?WWtndm1hUXk0ck14eXNqNkZVZ2NTL3R3QklyRlVQMFZDbWZrdndOZk0vQmlz?=
 =?utf-8?B?MTIvWTh3TFdVeUQ3cGZYUUVKL29zQmp5bUgwa2ZjVHVtYnlXMnJFWVcxRnV6?=
 =?utf-8?B?L25SRzdBZFlOT3JKSTM3c2tnTGpNS0VpWDlpTHlnNEZZR0luR2xheXJ5SnlF?=
 =?utf-8?B?TFBXdlpWTEQrYzlIR3ZUb3JCcWFtcGEvclBQTEpycjlJZkJQVVJQK3NHejFM?=
 =?utf-8?B?ZHRSSGNJUmpXSnR3QWdPN1VCWjFVdkdXeDVHRHJHalhUWWh1ZHlydmR4Um5N?=
 =?utf-8?B?WDN1ZlRMNStreHl1TklLNDlOSjdVTFR5NUFZZlZubWRHeFUzM1N5SEVNVGlk?=
 =?utf-8?B?WEVkb2Z0cnFJQnp3TXNCMDRXY3NkRW12M2NtM2gzNjNWNDdNYVhCTzJ5ZDlU?=
 =?utf-8?B?RUNRVVg2ck9ncjlEa1dkK1lOb3FvdFVUaEllQU5zelVwTFVmQ1hZaUc4MHU1?=
 =?utf-8?B?MHRKWVBpclR0Y1hTYWRzc1QvNG9SanZjdGhTWmtwQTk5WEJoVFo0SXI5ekti?=
 =?utf-8?B?YTQzUUo5V3BmUGlDWXlRSit3ZnBYN0FyVCtoMTE4eGYzdG1pNzRBQkFCTkVs?=
 =?utf-8?B?aVc0M0t3K3BmdUsvT24wM3FVMnhjM29LczB0ZUZJemZpa2NRUjVwOTNqdzNT?=
 =?utf-8?B?cHhSZzlKMW1TcDRTVWhERUlPcjVraHFHc2hMb3huV2pWaWkvZEx5L0RYbWF1?=
 =?utf-8?B?Z3hSODVScUtYMUJWWlhJeW5Pb2FqQ1RCeVkrNnhtQlE4U05HdWR1UDVxcHNl?=
 =?utf-8?B?eGlEeTJQMkdHcVpzZExkZ0I5ZWJWSUVTV2tZL2xSV1pzYjd3WUJTY2g0R0Rl?=
 =?utf-8?B?WVlOZWpESTExbXVySEc4a0JKN2ZjNkV1bVBsUzhvakJCRHQ2YkI0cTBic2lM?=
 =?utf-8?B?SnVTMjdMODMvTFZmNEMvbGxoMklOTDZtR0I5RnU1dElWM2o4TTBsMktSUG9H?=
 =?utf-8?B?MVlkS045Zm1xSUwxMUx4NHY2U2RsY0tXQXlLYlJ4RHVnTFB3cXVrTCtKYk9G?=
 =?utf-8?B?dEUvMy9oZG0yTU83bnR2d1o0QUc1aXI5Q1hLMENvVjRUUStKN1dJcTVsaEZR?=
 =?utf-8?B?b1JFSGNGT1BGcVcyMjM3cHNsVnlSVXUweUVaZUNwcjllbFpzNG9pYXI2Qko0?=
 =?utf-8?B?QXhzcllnUFk5dmJHTysyWUZqVC95OWJBOHRDbTdrSzZSVWt0VmVUQjZkdWNv?=
 =?utf-8?B?NkpHNHZkbVpQeWp2UXBLTTBFUDZXay9KR0FCZi9Ha0wxa0Y3VFZmd0JEQ0Vz?=
 =?utf-8?B?bEZxYTJ0NU1VSnMzb0RwR1o2N085Ty9YeUlsb0hOd3RDTDg4SmtMeWR3bWtq?=
 =?utf-8?B?WEtkejhmODlkSi9OS01qTy9takJIbFp6dVFRa2ZzTTJ2QTI5eGtnM0d2T0pU?=
 =?utf-8?B?S05YZmFIWmREb0Y1V0JHbW5MNE5HaExNcGR6ejAxZldjMzk0Tm1MQkZrd2lC?=
 =?utf-8?B?aG1zMGRLKzFEQThRTzlJSEVCYXQ1RTRYVnJEWFArL2lhSy9wS1NFN1NqNkdu?=
 =?utf-8?B?TDZXUDY0U3VadUJLRU1UY0g4NXJLWjlNTGJEbUp3Q2FSZ0tQSkJiWlpQeXBm?=
 =?utf-8?B?U0huSURRUDNpOW5NQndXM3h1d0dwUW55RDEwR3ZXaG1SYVUvdDdKQlR0aGNw?=
 =?utf-8?B?bm1UaTlnUExvalFFQzdWclVSVmtOVkk5NW9YeTFtOGV0WXZZRm1nS2lLV21w?=
 =?utf-8?B?UWtURUFlNDR1YmFJWW9mN0k5L0svLytCU2VwUVExTzNHWEpSWFRjaGI3c05r?=
 =?utf-8?B?NElnRzBibDlSaWszdkVTZHd1enMvdTczWUJUR0U5S3QrcTFja0xrR1E2OVRZ?=
 =?utf-8?B?VjQ1T3I5SEwvQlZkb3kzMSt6U3BzQ1dZVEJwSnNYRjlnUXZrWGsyeGE1TkUr?=
 =?utf-8?B?QUhPbzVqREpZWWdtTEhKbU5rN21NN1hjcUQzcFB6dHRLMXJiWnhrZ281TkNk?=
 =?utf-8?B?b3hEV3V4bmswd2pHMzE2TCtDUGM4U3pDcjVVSk5UTmIrelhzMmNicG12QnFh?=
 =?utf-8?B?MWh5QkgyS2VsYVhBY0tWaDczdGdiTmt5TWpPZUZaNDk3L2pqRm5xWHFhYlNa?=
 =?utf-8?B?dmc9PQ==?=
X-OriginatorOrg: mbosol.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ee5a96f-cf62-4258-c182-08db3ccd040b
X-MS-Exchange-CrossTenant-AuthSource: DB8P192MB0533.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 09:45:43.9295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 571b6760-44e0-4aae-b783-84984ac780c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ll8IhfkxMqjbz1Z3NfCYF98F36+7MaD/qjkrCDFLuikaWEDPRSLdoqM7+UJPEUVRP9V3iFCmQCVE03qPzdj9nrWlgmtU5GaHj33y7+HDYZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3P192MB2108
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 14.4.2023 2.11, Peter Xu wrote:
> There're a bunch of things that were wrong:
> 
>    - Reading uffd-wp bit from a swap entry should use pte_swp_uffd_wp()
>      rather than huge_pte_uffd_wp().
> 
>    - When copying over a pte, we should drop uffd-wp bit when
>      !EVENT_FORK (aka, when !userfaultfd_wp(dst_vma)).
> 
>    - When doing early CoW for private hugetlb (e.g. when the parent page was
>      pinned), uffd-wp bit should be properly carried over if necessary.
> 
> No bug reported probably because most people do not even care about these
> corner cases, but they are still bugs and can be exposed by the recent unit
> tests introduced, so fix all of them in one shot.
> 
> Cc: linux-stable <stable@vger.kernel.org>
> Fixes: bc70fbf269fd ("mm/hugetlb: handle uffd-wp during fork()")
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   mm/hugetlb.c | 26 ++++++++++++++++----------
>   1 file changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f16b25b1a6b9..7320e64aacc6 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4953,11 +4953,15 @@ static bool is_hugetlb_entry_hwpoisoned(pte_t pte)
>   
>   static void
>   hugetlb_install_folio(struct vm_area_struct *vma, pte_t *ptep, unsigned long addr,
> -		     struct folio *new_folio)
> +		      struct folio *new_folio, pte_t old)
>   {
> +	pte_t newpte = make_huge_pte(vma, &new_folio->page, 1);
> +
>   	__folio_mark_uptodate(new_folio);
>   	hugepage_add_new_anon_rmap(new_folio, vma, addr);
> -	set_huge_pte_at(vma->vm_mm, addr, ptep, make_huge_pte(vma, &new_folio->page, 1));
> +	if (userfaultfd_wp(vma) && huge_pte_uffd_wp(old))
> +		newpte = huge_pte_mkuffd_wp(newpte);
> +	set_huge_pte_at(vma->vm_mm, addr, ptep, newpte);
>   	hugetlb_count_add(pages_per_huge_page(hstate_vma(vma)), vma->vm_mm);
>   	folio_set_hugetlb_migratable(new_folio);
>   }
> @@ -5032,14 +5036,11 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>   			 */
>   			;
>   		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry))) {
> -			bool uffd_wp = huge_pte_uffd_wp(entry);
> -
> -			if (!userfaultfd_wp(dst_vma) && uffd_wp)
> +			if (!userfaultfd_wp(dst_vma))
>   				entry = huge_pte_clear_uffd_wp(entry);
>   			set_huge_pte_at(dst, addr, dst_pte, entry);
>   		} else if (unlikely(is_hugetlb_entry_migration(entry))) {
>   			swp_entry_t swp_entry = pte_to_swp_entry(entry);
> -			bool uffd_wp = huge_pte_uffd_wp(entry);
>   
>   			if (!is_readable_migration_entry(swp_entry) && cow) {
>   				/*
> @@ -5049,11 +5050,12 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>   				swp_entry = make_readable_migration_entry(
>   							swp_offset(swp_entry));
>   				entry = swp_entry_to_pte(swp_entry);
> -				if (userfaultfd_wp(src_vma) && uffd_wp)
> -					entry = huge_pte_mkuffd_wp(entry);
> +				if (userfaultfd_wp(src_vma) &&
> +				    pte_swp_uffd_wp(entry))
> +					entry = pte_swp_mkuffd_wp(entry);


This looks interesting with pte_swp_uffd_wp and pte_swp_mkuffd_wp ?


>   				set_huge_pte_at(src, addr, src_pte, entry);
>   			}
> -			if (!userfaultfd_wp(dst_vma) && uffd_wp)
> +			if (!userfaultfd_wp(dst_vma))
>   				entry = huge_pte_clear_uffd_wp(entry);
>   			set_huge_pte_at(dst, addr, dst_pte, entry);
>   		} else if (unlikely(is_pte_marker(entry))) {
> @@ -5114,7 +5116,8 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>   					/* huge_ptep of dst_pte won't change as in child */
>   					goto again;
>   				}
> -				hugetlb_install_folio(dst_vma, dst_pte, addr, new_folio);
> +				hugetlb_install_folio(dst_vma, dst_pte, addr,
> +						      new_folio, src_pte_old);
>   				spin_unlock(src_ptl);
>   				spin_unlock(dst_ptl);
>   				continue;
> @@ -5132,6 +5135,9 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>   				entry = huge_pte_wrprotect(entry);
>   			}
>   
> +			if (!userfaultfd_wp(dst_vma))
> +				entry = huge_pte_clear_uffd_wp(entry);
> +
>   			set_huge_pte_at(dst, addr, dst_pte, entry);
>   			hugetlb_count_add(npages, dst);
>   		}


--Mika


