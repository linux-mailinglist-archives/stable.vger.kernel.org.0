Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992E36C7D28
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 12:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjCXLZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 07:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjCXLZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 07:25:16 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A7512F3C;
        Fri, 24 Mar 2023 04:25:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1EA2A33777;
        Fri, 24 Mar 2023 11:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1679657113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zAzEnykbRkzE76S86YawLQ+OtSDzAafgXZmO8avderw=;
        b=SAdGEr+m44bROiBZ33wfKMwoxsDilWTDw+XNhAL6jA9UxVl0DV37G51teERp+qpmk2EamA
        fYjUvGLjdDeOXxbNg/dun6AfAhzjvBtySM/9TCFsfNYaglEFXWvFpdIgQyl25liLOqRx5j
        bH8WrCvb6SdrEY5kGNLPsp6jujbA82A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1679657113;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zAzEnykbRkzE76S86YawLQ+OtSDzAafgXZmO8avderw=;
        b=xLqTVEyA6fJwhOcztzd1gwUNeFqYX7VfurosZjpV+fH62ui8qdoJm6pyZ4cXnE0HP4kpLA
        PXspR/jJzUHLh7DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E9904133E5;
        Fri, 24 Mar 2023 11:25:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UodSOJiIHWSZYgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 24 Mar 2023 11:25:12 +0000
Message-ID: <efab25ef-c29c-3671-5f26-060bba76d481@suse.cz>
Date:   Fri, 24 Mar 2023 12:25:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [v4 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration
 entry
Content-Language: en-US
To:     Yang Shi <shy828301@gmail.com>
Cc:     David Hildenbrand <david@redhat.com>,
        kirill.shutemov@linux.intel.com, jannh@google.com,
        willy@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220203182641.824731-1-shy828301@gmail.com>
 <132ba4a4-3b1d-329d-1db4-f102eea2fd08@suse.cz>
 <9ba70a5e-4e12-0e9f-a6a4-d955bf25d0fe@redhat.com>
 <64ec7939-0733-7925-0ec0-d333e62c5f21@suse.cz>
 <CAHbLzkoZctsJf92Lw3wKMuSqT7-aje0SiAjc6JVW5Z3bNS1JNg@mail.gmail.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <CAHbLzkoZctsJf92Lw3wKMuSqT7-aje0SiAjc6JVW5Z3bNS1JNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/23/23 21:45, Yang Shi wrote:
> On Thu, Mar 23, 2023 at 3:11 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> 
> Out of curiosity, is there any public link for this CVE? Google search
> can't find it.

Only this one is live so far, AFAIK

https://bugzilla.redhat.com/show_bug.cgi?id=2180936

>>
>> That's good to know so at least my bogus mail was useful for that, thanks!

