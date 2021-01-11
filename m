Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C0B2F1D29
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 18:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbhAKRzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 12:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbhAKRzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 12:55:46 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8843C0617A4
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 09:55:00 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id q25so466216otn.10
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 09:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=v3TDFrqVxc55qv6u1Dum5raMCBbdcZl0roEhiqKm12E=;
        b=lZjWCfbG8Auf1FSXEvxpu9z2F5nHThHpYy+3QmdRfHgZVbQ8iOt14U29oCzCIsnSSs
         VLnoFMCQuU8xnqBAcfa27K7hZwCGat+qOGKyVOKc1qcvS7Lptqlgs3L85HeKvTd7Fq5P
         qNtF3fONSHYdETB6J67jpgTgQwvHjLNj8ANi2QHjTGFvKED65JATHmMfwF73+u6t2XC4
         AdO18lob+PcRGaVt9Z3wT0TMgPWAROZq+9iUc3Mz57gtt07GZF4r/fktMmNGMqr+pNrq
         QSHQPMXbbPinZWTBNZqVISGjn92RtSuT496ufjI7WpQHaqyhMZVHZPPnwyDGmi8DWwog
         Jr7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=v3TDFrqVxc55qv6u1Dum5raMCBbdcZl0roEhiqKm12E=;
        b=VOEY5HbRcBSKbeywgNqF3kLNJ5LOusrFA3fgoOI2xvfh8lAxD9rweQ5VG6k8Fcs9wv
         8iZWHnOUL12B+L+mWdxoatyljNut3JZtf8onm6/w+eIDgKm3yuBWW0zHTjA39+i6krdz
         HhbSGuepdQYWyjk2lO7+tf0PfE2AcSMFJB2Bl4JymfT6tSyNmMWLlxyFq23g6XpVxSr0
         aZ7i0rwCmVBu0+dv5GPoPU0bTL3fJAOJ2SBryZz+OYRril4KLm0yB71tkpbG9gLfCoK3
         4Vp3XV9DusrlQrTs0we89OFabNmG2J0mLbX7YFmOxvgX0LlI7ibOeZLsFtQ91A6kF8JH
         kM2g==
X-Gm-Message-State: AOAM531xO40VK9/srCDnn8ywUsZetUOBOVd3DdW6MeTWK//1gPMhQ2Rv
        KGUczy7yIWefidbt3TWI3IJGxA==
X-Google-Smtp-Source: ABdhPJys9h9FMDY8QzdOCVIr242CR9PxOf1m9Ov17uYelIEIUq9xy+LTMHC0Hx5xuhWW8BdmeAdCCA==
X-Received: by 2002:a9d:479a:: with SMTP id b26mr203427otf.297.1610387699841;
        Mon, 11 Jan 2021 09:54:59 -0800 (PST)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id l5sm90794otj.57.2021.01.11.09.54.58
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Mon, 11 Jan 2021 09:54:59 -0800 (PST)
Date:   Mon, 11 Jan 2021 09:54:37 -0800 (PST)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+2fc0712f8f8b8b8fa0ef@syzkaller.appspotmail.com,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5.10 109/145] mm: make wait_on_page_writeback() wait for
 multiple pending writebacks
In-Reply-To: <20210111130053.764396270@linuxfoundation.org>
Message-ID: <alpine.LSU.2.11.2101110947280.1731@eggly.anvils>
References: <20210111130048.499958175@linuxfoundation.org> <20210111130053.764396270@linuxfoundation.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jan 2021, Greg Kroah-Hartman wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> commit c2407cf7d22d0c0d94cf20342b3b8f06f1d904e7 upstream.
> 
> Ever since commit 2a9127fcf229 ("mm: rewrite wait_on_page_bit_common()
> logic") we've had some very occasional reports of BUG_ON(PageWriteback)
> in write_cache_pages(), which we thought we already fixed in commit
> 073861ed77b6 ("mm: fix VM_BUG_ON(PageTail) and BUG_ON(PageWriteback)").
> 
> But syzbot just reported another one, even with that commit in place.
> 
> And it turns out that there's a simpler way to trigger the BUG_ON() than
> the one Hugh found with page re-use.  It all boils down to the fact that
> the page writeback is ostensibly serialized by the page lock, but that
> isn't actually really true.
> 
> Yes, the people _setting_ writeback all do so under the page lock, but
> the actual clearing of the bit - and waking up any waiters - happens
> without any page lock.
> 
> This gives us this fairly simple race condition:
> 
>   CPU1 = end previous writeback
>   CPU2 = start new writeback under page lock
>   CPU3 = write_cache_pages()
> 
>   CPU1          CPU2            CPU3
>   ----          ----            ----
> 
>   end_page_writeback()
>     test_clear_page_writeback(page)
>     ... delayed...
> 
>                 lock_page();
>                 set_page_writeback()
>                 unlock_page()
> 
>                                 lock_page()
>                                 wait_on_page_writeback();
> 
>     wake_up_page(page, PG_writeback);
>     .. wakes up CPU3 ..
> 
>                                 BUG_ON(PageWriteback(page));
> 
> where the BUG_ON() happens because we woke up the PG_writeback bit
> becasue of the _previous_ writeback, but a new one had already been
> started because the clearing of the bit wasn't actually atomic wrt the
> actual wakeup or serialized by the page lock.
> 
> The reason this didn't use to happen was that the old logic in waiting
> on a page bit would just loop if it ever saw the bit set again.
> 
> The nice proper fix would probably be to get rid of the whole "wait for
> writeback to clear, and then set it" logic in the writeback path, and
> replace it with an atomic "wait-to-set" (ie the same as we have for page
> locking: we set the page lock bit with a single "lock_page()", not with
> "wait for lock bit to clear and then set it").
> 
> However, out current model for writeback is that the waiting for the
> writeback bit is done by the generic VFS code (ie write_cache_pages()),
> but the actual setting of the writeback bit is done much later by the
> filesystem ".writepages()" function.
> 
> IOW, to make the writeback bit have that same kind of "wait-to-set"
> behavior as we have for page locking, we'd have to change our roughly
> ~50 different writeback functions.  Painful.
> 
> Instead, just make "wait_on_page_writeback()" loop on the very unlikely
> situation that the PG_writeback bit is still set, basically re-instating
> the old behavior.  This is very non-optimal in case of contention, but
> since we only ever set the bit under the page lock, that situation is
> controlled.
> 
> Reported-by: syzbot+2fc0712f8f8b8b8fa0ef@syzkaller.appspotmail.com
> Fixes: 2a9127fcf229 ("mm: rewrite wait_on_page_bit_common() logic")
> Acked-by: Hugh Dickins <hughd@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: stable@kernel.org
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I think it's too early to push this one through to stable:
Linus mentioned on Friday that Michael Larabel of Phoronix
has observed a performance regression from this commit.

Correctness outweighs performance of course, but I think
stable users might see the performance issue much sooner
than they would ever see the BUG fixed.  Wait a bit,
while we think some more about what to try next?

Hugh

> 
> ---
>  mm/page-writeback.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2826,7 +2826,7 @@ EXPORT_SYMBOL(__test_set_page_writeback)
>   */
>  void wait_on_page_writeback(struct page *page)
>  {
> -	if (PageWriteback(page)) {
> +	while (PageWriteback(page)) {
>  		trace_wait_on_page_writeback(page, page_mapping(page));
>  		wait_on_page_bit(page, PG_writeback);
>  	}
