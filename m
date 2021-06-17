Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359CF3AB919
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 18:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhFQQM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 12:12:29 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34808 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbhFQQLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 12:11:25 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0EE5B21AFA;
        Thu, 17 Jun 2021 16:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623946157; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mYFUJ1KwmJZvOYZxN949HWoq7I5ZyPXAkOTS38THsaM=;
        b=O8wStvwXRtGhEu9rSOmINCc3gKa0fX430+NkQuQbOkuOgzvTCBI6CWHLMeYxU/sKc1Rufn
        p6tTCRejpso6dv1Hfc6qnAeGQkhkX9ZitSFrBPGrq+6hczMTuCinMh5MsKfgAkstLgDWRO
        mUT/c2rknm8jSoq5ZXEzyH0t3cHh1qE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623946157;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mYFUJ1KwmJZvOYZxN949HWoq7I5ZyPXAkOTS38THsaM=;
        b=F18qGxTSGuiUOE7eUJOB6D0LpdALEtYrW6yjb5glRm3YeteuexOkZKf3OJtDpy0R+AG+rK
        IPwqsc/iagiCCxAQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id E5347118DD;
        Thu, 17 Jun 2021 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623946157; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mYFUJ1KwmJZvOYZxN949HWoq7I5ZyPXAkOTS38THsaM=;
        b=O8wStvwXRtGhEu9rSOmINCc3gKa0fX430+NkQuQbOkuOgzvTCBI6CWHLMeYxU/sKc1Rufn
        p6tTCRejpso6dv1Hfc6qnAeGQkhkX9ZitSFrBPGrq+6hczMTuCinMh5MsKfgAkstLgDWRO
        mUT/c2rknm8jSoq5ZXEzyH0t3cHh1qE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623946157;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mYFUJ1KwmJZvOYZxN949HWoq7I5ZyPXAkOTS38THsaM=;
        b=F18qGxTSGuiUOE7eUJOB6D0LpdALEtYrW6yjb5glRm3YeteuexOkZKf3OJtDpy0R+AG+rK
        IPwqsc/iagiCCxAQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id Y7R2N6xzy2B9HQAALh3uQQ
        (envelope-from <vbabka@suse.cz>); Thu, 17 Jun 2021 16:09:16 +0000
Subject: Re: [PATCH v2] mm/gup: fix try_grab_compound_head() race with
 split_huge_page()
To:     Yang Shi <shy828301@gmail.com>
Cc:     Jann Horn <jannh@google.com>, John Hubbard <jhubbard@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
References: <20210615012014.1100672-1-jannh@google.com>
 <50d828d1-2ce6-21b4-0e27-fb15daa77561@nvidia.com>
 <CAG48ez3Vbcvh4AisU7=ukeJeSjHGTKQVd0NOU6XOpRru7oP_ig@mail.gmail.com>
 <CAHbLzkomex+fgC8RyogXu-s5o2UrORMO6D2yTsSXW5Wo5z9WRA@mail.gmail.com>
 <6d21f8cb-4b72-bdec-386c-684ddbcdada1@suse.cz>
 <CAHbLzkpa5MQBtYcRPWu4vNDn=Q8SKStQ-9wKYWogqRrMR3Aonw@mail.gmail.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <2847e923-2366-6a3b-3d76-4513a01981a0@suse.cz>
Date:   Thu, 17 Jun 2021 18:09:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAHbLzkpa5MQBtYcRPWu4vNDn=Q8SKStQ-9wKYWogqRrMR3Aonw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/16/21 8:40 PM, Yang Shi wrote:
> On Wed, Jun 16, 2021 at 10:27 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> On 6/16/21 1:10 AM, Yang Shi wrote:
>> > On Tue, Jun 15, 2021 at 5:10 AM Jann Horn <jannh@google.com> wrote:
>> >>
>> >
>> > It might be possible after Mel's "mm/page_alloc: Allow high-order
>> > pages to be stored on the per-cpu lists" patch
>> > (https://patchwork.kernel.org/project/linux-mm/patch/20210611135753.GC30378@techsingularity.net/).
>>
>> Those would be percpu indeed, but not "lockless, non-atomic", no? They are
>> protected by a local_lock.
> 
> The local_lock is *not* a lock on non-PREEMPT_RT kernel IIUC. It
> disables preempt and IRQ. But preempt disable is no-op on non-preempt
> kernel. IRQ disable can guarantee it is atomic context, but I'm not
> sure if it is equivalent to "atomic freelists" in Jann's context.

Hm right, I thought all locks had the acquire/release semantics, but this one is
just a barrier().
