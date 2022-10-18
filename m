Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E8B60283A
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 11:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiJRJYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 05:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiJRJYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 05:24:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA9EACF4B;
        Tue, 18 Oct 2022 02:23:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2796E2002A;
        Tue, 18 Oct 2022 09:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666085030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DU9aUKfe8YiSdBMpeyV3GLQ4rLKutE7C4dx+hv01OMA=;
        b=D5kpcQm7hez0sNUS250ZsyzcaSWlOuOBwJG9lit3I05Nd/OiZUCYSlfz8zuR5p+jxXURLs
        wxle+PgXojzSsvryNl2RZQREddF9ApdaQyGwwfJuT2OdPsVmh9ces+hoqsZCc1kSN+w33w
        TiEBC8Bx7ifq2rCzB9KznbQz1XcaJto=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666085030;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DU9aUKfe8YiSdBMpeyV3GLQ4rLKutE7C4dx+hv01OMA=;
        b=GKP62Khoi8ff8rvlt5e3xjTGfC3MxZUlCsNI+gWmPw3lnmvdgAa52QxddcTrhgfbtYQsLq
        KEQx3IEuu25sIgBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6B91413480;
        Tue, 18 Oct 2022 09:23:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ghoWGaVwTmPWBwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Tue, 18 Oct 2022 09:23:49 +0000
Message-ID: <c8ebeaf0-2dbb-37d8-52c8-7880c516ce6a@suse.cz>
Date:   Tue, 18 Oct 2022 11:23:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH AUTOSEL 5.4 10/13] kmsan: disable physical page merging in
 biovec
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org
References: <20221018001102.2731930-1-sashal@kernel.org>
 <20221018001102.2731930-10-sashal@kernel.org>
 <Y03xyaUhL6gSLWYQ@sol.localdomain>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <Y03xyaUhL6gSLWYQ@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/18/22 02:22, Eric Biggers wrote:
> On Mon, Oct 17, 2022 at 08:10:59PM -0400, Sasha Levin wrote:
>> From: Alexander Potapenko <glider@google.com>
>>
>> [ Upstream commit f630a5d0ca59a6e73b61e3f82c371dc230da99ff ]
>>
>> KMSAN metadata for adjacent physical pages may not be adjacent, therefore
>> accessing such pages together may lead to metadata corruption.  We disable
>> merging pages in biovec to prevent such corruptions.
>>
>> Link: https://lkml.kernel.org/r/20220915150417.722975-28-glider@google.com
>> Signed-off-by: Alexander Potapenko <glider@google.com>
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: Alexei Starovoitov <ast@kernel.org>
>> Cc: Andrey Konovalov <andreyknvl@gmail.com>
>> Cc: Andrey Konovalov <andreyknvl@google.com>
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Dmitry Vyukov <dvyukov@google.com>
>> Cc: Eric Biggers <ebiggers@google.com>
>> Cc: Eric Biggers <ebiggers@kernel.org>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: Ilya Leoshkevich <iii@linux.ibm.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Marco Elver <elver@google.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Cc: Pekka Enberg <penberg@kernel.org>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Petr Mladek <pmladek@suse.com>
>> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Vasily Gorbik <gor@linux.ibm.com>
>> Cc: Vegard Nossum <vegard.nossum@oracle.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   block/blk.h | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/block/blk.h b/block/blk.h
>> index ee3d5664d962..3358ef4244fe 100644
>> --- a/block/blk.h
>> +++ b/block/blk.h
>> @@ -79,6 +79,13 @@ static inline bool biovec_phys_mergeable(struct request_queue *q,
>>   	phys_addr_t addr1 = page_to_phys(vec1->bv_page) + vec1->bv_offset;
>>   	phys_addr_t addr2 = page_to_phys(vec2->bv_page) + vec2->bv_offset;
>>   
>> +	/*
>> +	 * Merging adjacent physical pages may not work correctly under KMSAN
>> +	 * if their metadata pages aren't adjacent. Just disable merging.
>> +	 */
>> +	if (IS_ENABLED(CONFIG_KMSAN))
>> +		return false;
>> +
>>   	if (addr1 + vec1->bv_len != addr2)
>>   		return false;
>>   	if (xen_domain() && !xen_biovec_phys_mergeable(vec1, vec2->bv_page))
> 
> So KMSAN is being backported to 5.4?

No, AUTOSEL is drunk and should drop the random kmsan patches for random 
stable versions.

> - Eric

