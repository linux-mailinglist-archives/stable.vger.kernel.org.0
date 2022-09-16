Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07975BB1A3
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 19:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiIPRec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 13:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIPRec (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 13:34:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AAE2739;
        Fri, 16 Sep 2022 10:34:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8FBBC1FEC5;
        Fri, 16 Sep 2022 17:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1663349669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lsisgMPvCT3VnHLqKa8pUpcXqHPIsT7c6cznGtgolXM=;
        b=YbqxfnG7uzxLk9Kk2ojLDXzSXCNuWwxsn+n3/hwlrFjBa6I99ubNz1FAxJyUASjX0gSBV5
        fNsl3MRXmx0lLgLiTWymxXpBkLLXdt9dpwj6Bxu3Ln18t4FRLngCF0GbjrgWr8rG1gKEh/
        NTnXiqOsp7K0eZpd6+vIIwKyQvMm1hw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1663349669;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lsisgMPvCT3VnHLqKa8pUpcXqHPIsT7c6cznGtgolXM=;
        b=ARwhLTZLiEC5WXth8EDAdV2IFxIrD8+mQv1MT6j67AS2hVWktVIIBbQIaZHLMxQFWcFKXy
        FFLaJueFKzAwPGCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4AABC1346B;
        Fri, 16 Sep 2022 17:34:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Cg5tEaWzJGMiGwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 16 Sep 2022 17:34:29 +0000
Message-ID: <f06965ea-c7e5-3a8d-f819-64baedf75d96@suse.cz>
Date:   Fri, 16 Sep 2022 19:32:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] kasan: call kasan_malloc() from __kmalloc_*track_caller()
Content-Language: en-US
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Peter Collingbourne <pcc@google.com>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220914020001.2846018-1-pcc@google.com>
 <YyF6N8uHGVrqpoDM@hyeyoo>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <YyF6N8uHGVrqpoDM@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/14/22 08:52, Hyeonggon Yoo wrote:

Thanks for the Cc.

> On Tue, Sep 13, 2022 at 07:00:01PM -0700, Peter Collingbourne wrote:
>> We were failing to call kasan_malloc() from __kmalloc_*track_caller()
>> which was causing us to sometimes fail to produce KASAN error reports
>> for allocations made using e.g. devm_kcalloc(), as the KASAN poison was
>> not being initialized. Fix it.
>>
>> Signed-off-by: Peter Collingbourne <pcc@google.com>
>> Cc: <stable@vger.kernel.org> # 5.15
>> ---
>> The same problem is being fixed upstream in:

The "upstream" here is now only in -next, not mainline yet, so we still
have more options at this point.

>> https://lore.kernel.org/all/20220817101826.236819-6-42.hyeyoo@gmail.com/
>> as part of a larger patch series, but this more targeted fix seems
>> more suitable for the stable kernel. Hyeonggon, maybe you can add
>> this patch to the start of your series and it can be picked up
>> by the stable maintainers.
...
> 
> Ah, I should have sent it to stable team ;)
> 
> I think "Option 3" in Documentation/process/stable-kernel-rules.rst will be appropriate,
> So will resend this after the series goes to Linus's tree.

I'll pick this for sending to Linus after rc6, which means the series in
slab.git / -next will afterwards cause a trivial conflict to resolve
when merging. AFAIK Linus prefers that over late rebasing.
It will also make it simple for stable.

> Thank you Peter!
> 

