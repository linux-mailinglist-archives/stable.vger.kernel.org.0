Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2EDB5B92C1
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 04:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiIOCte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 22:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiIOCtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 22:49:33 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D499FF9;
        Wed, 14 Sep 2022 19:49:28 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A66D1063;
        Wed, 14 Sep 2022 19:49:35 -0700 (PDT)
Received: from [10.162.43.6] (unknown [10.162.43.6])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C76C63F71A;
        Wed, 14 Sep 2022 19:49:25 -0700 (PDT)
Message-ID: <f28a373a-4035-78f7-e048-4b5aefd905af@arm.com>
Date:   Thu, 15 Sep 2022 08:19:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] mm/hugetlb: correct demote page offset logic
Content-Language: en-US
To:     Mike Kravetz <mike.kravetz@oracle.com>,
        Doug Berger <opendmb@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Muchun Song <songmuchun@bytedance.com>,
        Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220914190917.3517663-1-opendmb@gmail.com>
 <YyJFQaZtZr08fMhj@monkey>
From:   Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <YyJFQaZtZr08fMhj@monkey>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/15/22 02:48, Mike Kravetz wrote:
> On 09/14/22 12:09, Doug Berger wrote:
>> With gigantic pages it may not be true that struct page structures
>> are contiguous across the entire gigantic page. The nth_page macro
>> is used here in place of direct pointer arithmetic to correct for
>> this.
>>
>> Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
>> Signed-off-by: Doug Berger <opendmb@gmail.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>>  mm/hugetlb.c | 14 ++++++++------
>>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> Thanks!
> 
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> 
> To answer Andrew's question about user-visible runtime effects.
> We could get addressing exceptions.  However, this is only possible in
> configurations where CONFIG_SPARSEMEM && !CONFIG_SPARSEMEM_VMEMMAP.
> Such a configuration option is rare an unknown to be the default
> anywhere.

In that case, should this be a 'Cc: stable' ? Although it does fix
the above mentioned commit for a possible configuration. But should
this be backported, if there could not have been an affected system ?
