Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1764C1976
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 18:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiBWRHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 12:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbiBWRHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 12:07:35 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28385EDDA;
        Wed, 23 Feb 2022 09:07:05 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 621FA1F43E;
        Wed, 23 Feb 2022 17:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645636024; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CaDuGVMSnVYMBtbixokplU//+MPnASve3hmmEe3B/h8=;
        b=TqKpsWRJetKNQIjMX62ryxEm53gPFT4Ddlge7AjxiZy+3ipmpZ8sKf9k553nqoSIx38g8J
        bD4fpwJdFVt+kt3HK0s0ljvU4i6bmpdbmRI1AZjjLZ9z46UYnHgezq0Eo69vWMq48UCn4U
        Wx4ISi8z/fBoyStzt9b6kBK4fb58q3U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645636024;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CaDuGVMSnVYMBtbixokplU//+MPnASve3hmmEe3B/h8=;
        b=YMy5kpWxlF/sLctza+/jeSBv105CdyfrVALqxr6yuDfU4nDWqnWaEj8ptKr9SsVhWjpB1W
        vxJA4wQa5lkyiHBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3A5C613C94;
        Wed, 23 Feb 2022 17:07:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 12KWDbhpFmK3GQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 23 Feb 2022 17:07:04 +0000
Message-ID: <87b056da-80e8-17f5-41ae-9fb493a7f0da@suse.cz>
Date:   Wed, 23 Feb 2022 18:07:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: read() data corruption with CONFIG_READ_ONLY_THP_FOR_FS=y
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Takashi Iwai <tiwai@suse.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, patches@lists.linux.dev,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <df3b5d1c-a36b-2c73-3e27-99e74983de3a@suse.cz>
 <YhZFr+kXIJFgiMaf@casper.infradead.org>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <YhZFr+kXIJFgiMaf@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/23/22 15:33, Matthew Wilcox wrote:
> On Wed, Feb 23, 2022 at 02:54:43PM +0100, Vlastimil Babka wrote:
>> we have found a bug involving CONFIG_READ_ONLY_THP_FOR_FS=y, introduced in
>> 5.12 by cbd59c48ae2b ("mm/filemap: use head pages in
>> generic_file_buffered_read")
>> and apparently fixed in 5.17-rc1 by 6b24ca4a1a8d ("mm: Use multi-index
>> entries in the page cache")
>> The latter commit is part of folio rework so likely not stable material, so
>> it would be nice to have a small fix for e.g. 5.15 LTS. Preferably from
>> someone who understands xarray :)
> 
> [...]
> 
>> I've hacked some printk on top 5.16 (attached debug.patch)
>> which gives this output:
>> 
>> i=0 page=ffffea0004340000 page_offset=0 uoff=0 bytes=2097152
>> i=1 page=ffffea0004340000 page_offset=0 uoff=0 bytes=2097152
>> i=2 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
>> i=3 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
>> i=4 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
>> i=5 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
>> i=6 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
>> i=7 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
>> i=8 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
>> i=9 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
>> i=10 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
>> i=11 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
>> i=12 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
>> i=13 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
>> i=14 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
>> 
>> It seems filemap_get_read_batch() should be returning pages ffffea0004340000
>> and ffffea0004470000 consecutively in the pvec, but returns the first one 8
>> times, so it's read twice and then the rest is just skipped over as it's
>> beyond the requested read size.
>> 
>> I suspect these lines:
>>   xas.xa_index = head->index + thp_nr_pages(head) - 1;
>>   xas.xa_offset = (xas.xa_index >> xas.xa_shift) & XA_CHUNK_MASK;
>> 
>> commit 6b24ca4a1a8d changes those to xas_advance() (introduced one patch
>> earlier), so some self-contained fix should be possible for prior kernels?
>> But I don't understand xarray well enough.
> 
> I figured it out!
> 
> In v5.15 (indeed, everything before commit 6b24ca4a1a8d), an order-9
> page is stored in 512 consecutive slots.  The XArray stores 64 entries
> per level.  So what happens is we start looking at index 0 and we walk
> down to the bottom of the tree and find the THP at index 0.
> 
>                 xas.xa_index = head->index + thp_nr_pages(head) - 1;
>                 xas.xa_offset = (xas.xa_index >> xas.xa_shift) & XA_CHUNK_MASK;
> 
> So we've advanced xas.xa_index to 511, but advanced xas.xa_offset to 63.
> Then we call xas_next() which calls __xas_next(), which moves us along to
> array index 64 while we think we're looking at index 512.
> 
> We could make __xas_next() more resistant to this kind of abuse (by
> extracting the correct offset in the parent node from xa_index), but
> as you say, we're looking for a small fix for LTS.  I suggest this
> will probably do the right thing:

Great!

Just so others are aware: the final fix is here:
https://lore.kernel.org/all/20220223155918.927140-1-willy@infradead.org/

> +++ b/mm/filemap.c
> @@ -2354,8 +2354,7 @@ static void filemap_get_read_batch(struct address_space *mapping,
>                         break;
>                 if (PageReadahead(head))
>                         break;
> -               xas.xa_index = head->index + thp_nr_pages(head) - 1;
> -               xas.xa_offset = (xas.xa_index >> xas.xa_shift) & XA_CHUNK_MASK;
> +               xas_set(&xas, head->index + thp_nr_pages(head) - 1);
>                 continue;
>  put_page:
>                 put_page(head);
> 
> but I'll start trying the reproducer now.
> 
> 

