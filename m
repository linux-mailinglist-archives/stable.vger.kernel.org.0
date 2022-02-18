Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC694BBFF9
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 19:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbiBRSyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 13:54:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiBRSye (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 13:54:34 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC2E212E2D;
        Fri, 18 Feb 2022 10:54:16 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BA49D1F380;
        Fri, 18 Feb 2022 18:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645210454; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7xBLRQZhq3/skvOmeDBJB14+LYXLehKVzIynhx/JjM0=;
        b=0jXyJ65ecJsaSLvPCVibOVAuY3OGK4usVKD2EERKyiLsHHz0e7QV4ZYTI3Rbt+GijfiPAG
        xIwopJxYs0ot03/jzftod8OrUCu8aNBPsxw0mQJkerkALjDt7nHVaIaaaszd+tdaM61Yh8
        d+1wWi8yXTM/1QG71yycfwTLocwKzPk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645210454;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7xBLRQZhq3/skvOmeDBJB14+LYXLehKVzIynhx/JjM0=;
        b=80A1QJM3/GCBQg8FBevUB/VqXoEnD5gOwj9dFfPlDytKxWCjOlLQ3vd3yEu21dWjq5f7Ox
        JiaCkAMG6wXNfDDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 87D2513C9F;
        Fri, 18 Feb 2022 18:54:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Zl1lIFbrD2KneQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 18 Feb 2022 18:54:14 +0000
Message-ID: <c237f6d1-4219-0e6d-6aca-9c29d060bb4f@suse.cz>
Date:   Fri, 18 Feb 2022 19:54:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] slab: remove __alloc_size attribute from
 __kmalloc_track_caller
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nathan Chancellor <nathan@kernel.org>, linux-mm@kvack.org,
        llvm@lists.linux.dev
References: <20220218131358.3032912-1-gregkh@linuxfoundation.org>
 <a5ab4496-8190-6221-72c7-d1ff2e6cf1d4@suse.cz> <Yg/eG4X7Esa0h1al@kroah.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <Yg/eG4X7Esa0h1al@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/18/22 18:57, Greg Kroah-Hartman wrote:
> On Fri, Feb 18, 2022 at 06:14:55PM +0100, Vlastimil Babka wrote:
>> On 2/18/22 14:13, Greg Kroah-Hartman wrote:
>> > Commit c37495d6254c ("slab: add __alloc_size attributes for better
>> > bounds checking") added __alloc_size attributes to a bunch of kmalloc
>> > function prototypes.  Unfortunately the change to __kmalloc_track_caller
>> > seems to cause clang to generate broken code and the first time this is
>> > called when booting, the box will crash.
>> > 
>> > While the compiler problems are being reworked and attempted to be
>> > solved, let's just drop the attribute to solve the issue now.  Once it
>> > is resolved it can be added back.
>> 
>> Could we instead wrap it in some #ifdef that' only true for clang build?
>> That would make the workaround more precise and self-documented. Even
>> better if it can trigger using clang version range and once a fixed
>> clang version is here, it can be updated to stay true for older clangs.
> 
> It's not doing all that much good like this, let's just remove it for
> now until it does actually provide a benifit and not just crash the box :)
> 
> This is only 1 function, that is used in only a very small number of
> callers.  I do not think it will be missed.

Fair enough, added to the slab tree:

https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=for-5.17/fixup5

> thanks,
> 
> greg k-h
> 

