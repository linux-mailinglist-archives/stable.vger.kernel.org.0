Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D826C6478
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 11:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjCWKLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 06:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjCWKLm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 06:11:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B7012CEA;
        Thu, 23 Mar 2023 03:11:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7F2F61FDB6;
        Thu, 23 Mar 2023 10:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1679566300; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eIVf6X9+8w7hFkVIs+NEITGJgY3dPy4ZtkDYRI94iS4=;
        b=pv0xanWEkShhW8d9mi9xUUKWZCzV5wq1QxwI5LK3zM7ugLCnEb7SJgXrfzjJqROaYC5sJ5
        Hh3IyZK3OVFNWwkuYDnF/mxRh88kIlYIs8pWCxQIMwvSrsmN0MJjmdQ9C33HY+UxxYEn9T
        Orjb3Mv3szzbF0HcmYf1LhgpbYPDtiw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1679566300;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eIVf6X9+8w7hFkVIs+NEITGJgY3dPy4ZtkDYRI94iS4=;
        b=sRexLaKzDUTT7eODp4EQ1BU8/ZK30x6HSerOZZzUI2XzbAWEE0gnj8gw7SMh+Gc+Auys0i
        Th5K7lmGXZuxdpBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5C993132C2;
        Thu, 23 Mar 2023 10:11:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EawSFtwlHGTTYAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 23 Mar 2023 10:11:40 +0000
Message-ID: <64ec7939-0733-7925-0ec0-d333e62c5f21@suse.cz>
Date:   Thu, 23 Mar 2023 11:11:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [v4 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration
 entry
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Yang Shi <shy828301@gmail.com>,
        kirill.shutemov@linux.intel.com, jannh@google.com,
        willy@infradead.org, akpm@linux-foundation.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220203182641.824731-1-shy828301@gmail.com>
 <132ba4a4-3b1d-329d-1db4-f102eea2fd08@suse.cz>
 <9ba70a5e-4e12-0e9f-a6a4-d955bf25d0fe@redhat.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <9ba70a5e-4e12-0e9f-a6a4-d955bf25d0fe@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/23/23 11:08, David Hildenbrand wrote:
> On 23.03.23 10:52, Vlastimil Babka wrote:
>> On 2/3/22 19:26, Yang Shi wrote:
>>> --- a/fs/proc/task_mmu.c
>>> +++ b/fs/proc/task_mmu.c
>>> @@ -440,7 +440,8 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
>>>   }
>>>   
>>>   static void smaps_account(struct mem_size_stats *mss, struct page *page,
>>> -		bool compound, bool young, bool dirty, bool locked)
>>> +		bool compound, bool young, bool dirty, bool locked,
>>> +		bool migration)
>>>   {
>>>   	int i, nr = compound ? compound_nr(page) : 1;
>>>   	unsigned long size = nr * PAGE_SIZE;
>>> @@ -467,8 +468,15 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
>>>   	 * page_count(page) == 1 guarantees the page is mapped exactly once.
>>>   	 * If any subpage of the compound page mapped with PTE it would elevate
>>>   	 * page_count().
>>> +	 *
>>> +	 * The page_mapcount() is called to get a snapshot of the mapcount.
>>> +	 * Without holding the page lock this snapshot can be slightly wrong as
>>> +	 * we cannot always read the mapcount atomically.  It is not safe to
>>> +	 * call page_mapcount() even with PTL held if the page is not mapped,
>>> +	 * especially for migration entries.  Treat regular migration entries
>>> +	 * as mapcount == 1.
>>>   	 */
>>> -	if (page_count(page) == 1) {
>>> +	if ((page_count(page) == 1) || migration) {
>> 
>> Since this is now apparently a CVE-2023-1582 for whatever RHeasons...
>> 
>> wonder if the patch actually works as intended when
>> (page_count() || migration) is in this particular order and not the other one?
> 
> Only the page_mapcount() call to a page that should be problematic, not 
> the page_count() call. There might be the rare chance of the page 

Oh right, page_mapcount() vs page_count(), I need more coffee.

> getting remove due to memory offlining... but we're still holding the 
> page table lock with the migration entry, so we should be protected 
> against that.
> 
> Regarding the CVE, IIUC the main reason for the CVE should be 
> RHEL-specific -- which behaves differently than other code bases; for 
> other code bases, it's just a way to trigger a BUG_ON as described here.

That's good to know so at least my bogus mail was useful for that, thanks!
