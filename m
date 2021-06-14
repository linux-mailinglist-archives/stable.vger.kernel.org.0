Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C377B3A6782
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 15:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbhFNNNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 09:13:44 -0400
Received: from mail-lf1-f52.google.com ([209.85.167.52]:43675 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbhFNNNm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 09:13:42 -0400
Received: by mail-lf1-f52.google.com with SMTP id x24so15434475lfr.10
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 06:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/AteiqldFMFOlpZ79iKSrJdb9WM23atrdo76u3CtXI0=;
        b=FnIic0hbgy06y+4HvKKGSOvyWaPQrYD35pFM/GZos/rN/Lcvxwixs/PuimxKwX06/S
         l6O4pihxZsTOmjP310zNezN9EfU7dnv95KvZX6kDvNz9Myr4OixJwc/s2+fU6BSYqxSo
         OD0MqV6BUR3mKwKSaXy9O3Z9YDamvekqCLaxgXDvu3GaSHyxIThLOAsJam8pmw3mQkOZ
         Etj9FKo8CWi8fnzaaUKYfFCpnj0uFzz/WxGKHp/qA/2ZUzuaoouVr4ws63PADIWze9FF
         KgiSHIP3uiTSPIKZMgAY9ZmLCLGxOmKAX/S/tRsjMThQJomfcXKcvSQwjChbGSN6diTw
         1UoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/AteiqldFMFOlpZ79iKSrJdb9WM23atrdo76u3CtXI0=;
        b=m0VuYmwW+VNPLTFYVnRXBNYQgi7bJ/mEyVbnWAFHgJBZ6eZ7eslDsEQkRCY2nGoclz
         VUEF47mgnbSQ+Kj1+7LvcVl1/BXn9tH6a02uyKTjCrgDATXzs44DHS/2Tj9X22kW1huz
         Z/xVAUqkwRYvgL+qAncb5WN/Y6GJA+ur/xG2OhddEkNUkbo4LwII0l65XecDF4yANjzg
         ugRGL0gzQ+zXjRfaNmXc3OCuiA/ZW6CXqOWb4LGFPMbpKvtpjhglWdrslDoqjDqhtJaP
         f3XbkxZbtaNfckbTN6kQTgu2J0b4cxgsTRHogWVtp2twsX/PIq7HP438S2vQ6B/4w4jQ
         jXug==
X-Gm-Message-State: AOAM531iMVRt9YqjFX8Iu8VsQKQHO1juSqFQW3vCuspg0ybY1FYLr6Sy
        qaHacLGe1dSmBN3nTBoxKAui2Q==
X-Google-Smtp-Source: ABdhPJw/sDHQHR4Uy1E7hq8O/pknucYcEdwsugy0iyc2N7DnWfH9PwZY0WvwzTbxFxv9m3RQiSz30g==
X-Received: by 2002:a05:6512:1290:: with SMTP id u16mr4641610lfs.144.1623676239063;
        Mon, 14 Jun 2021 06:10:39 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id d15sm1086495lfl.199.2021.06.14.06.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 06:10:38 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id C702E101ABE; Mon, 14 Jun 2021 16:10:56 +0300 (+03)
Date:   Mon, 14 Jun 2021 16:10:56 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Jann Horn <jannh@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: Re: [PATCH resend] mm/gup: fix try_grab_compound_head() race with
 split_huge_page()
Message-ID: <20210614131056.lo4ojw7lvfecwits@box.shutemov.name>
References: <20210611161545.998858-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611161545.998858-1-jannh@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 11, 2021 at 06:15:45PM +0200, Jann Horn wrote:
> try_grab_compound_head() is used to grab a reference to a page from
> get_user_pages_fast(), which is only protected against concurrent
> freeing of page tables (via local_irq_save()), but not against
> concurrent TLB flushes, freeing of data pages, or splitting of compound
> pages.
> 
> Because no reference is held to the page when try_grab_compound_head()
> is called, the page may have been freed and reallocated by the time its
> refcount has been elevated; therefore, once we're holding a stable
> reference to the page, the caller re-checks whether the PTE still points
> to the same page (with the same access rights).
> 
> The problem is that try_grab_compound_head() has to grab a reference on
> the head page; but between the time we look up what the head page is and
> the time we actually grab a reference on the head page, the compound
> page may have been split up (either explicitly through split_huge_page()
> or by freeing the compound page to the buddy allocator and then
> allocating its individual order-0 pages).
> If that happens, get_user_pages_fast() may end up returning the right
> page but lifting the refcount on a now-unrelated page, leading to
> use-after-free of pages.
> 
> To fix it:
> Re-check whether the pages still belong together after lifting the
> refcount on the head page.
> Move anything else that checks compound_head(page) below the refcount
> increment.
> 
> This can't actually happen on bare-metal x86 (because there, disabling
> IRQs locks out remote TLB flushes), but it can happen on virtualized x86
> (e.g. under KVM) and probably also on arm64. The race window is pretty
> narrow, and constantly allocating and shattering hugepages isn't exactly
> fast; for now I've only managed to reproduce this in an x86 KVM guest with
> an artificially widened timing window (by adding a loop that repeatedly
> calls `inl(0x3f8 + 5)` in `try_get_compound_head()` to force VM exits,
> so that PV TLB flushes are used instead of IPIs).
> 
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org
> Fixes: 7aef4172c795 ("mm: handle PTE-mapped tail pages in gerneric fast gup implementaiton")
> Signed-off-by: Jann Horn <jannh@google.com>

Looks good to me:

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>


-- 
 Kirill A. Shutemov
