Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3CC16D932
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 04:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbfGSCxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 22:53:55 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42210 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfGSCxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 22:53:55 -0400
Received: by mail-oi1-f195.google.com with SMTP id s184so23180315oie.9
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 19:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CJrorFZPwH37FCb9+E44SyJ7wOVMUUfXLYvFlvXaXe0=;
        b=hx7Bkmfmhute9V7A5GdZv3mR0B7Qdq8/cBFx7PPc2khFtfbftkq0XrGQstJDy/sJFe
         s0qWF3WLaOukww8Byf/RVNOjNdso0toZjMrByDkwHq6zIwh1M9xPKx9zmnlhZZWck/fQ
         qvh/Oo8Adr0ZVZ+7JjP1PXhTKgADmHYE/eqCbcAOAdu+b1Z9JJmeG4tN0LRowGiXZlmr
         9cef5oh65H24J79rwgwDO469Iq56UUCY41e/L1dvT1blrQlxYNStCHooPGJegyBHnxZG
         n0MhvR3m0OjkOjBYEwCr0YwmTkZVWD8JuHcXKgmAWW62FF5N0ROLCTxtW2/FIL+Q0Asq
         YxHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CJrorFZPwH37FCb9+E44SyJ7wOVMUUfXLYvFlvXaXe0=;
        b=YdULQG+lIvqhN/U1uc45ciGGnSR/qtUTpx7jf04+JoPvGH2M4w9N8GlviUi+n0pgmE
         z5WA++yozAuyEUSyL0B31pW9TBgb17j9E8okFMNbiQdG7bf90iFpGa6mhpEzEUzz7ikX
         JXGg9hS3GJ+Up4fPBRgeLgibGXOBL7fcsU7camAitDRNrI/UxETVo66pD1K0nXkZ/eGe
         CYFx3csOw+RZSmpJgOxTjzkgj+2jKnw/it2PdqsyTXXgzy789q4Z4XAUAiyNvuNdq/U5
         yJbfTPVkV5Vmwc4XErPfS4svLViEIL51D2pf9ZDOC65rb5rADaG7KTVmmnIoV2uK49vP
         zBmg==
X-Gm-Message-State: APjAAAUceS5dlZ6mEYM6+3HqGYEQpCON80RoCti42+I1aWHmzE9Gm/4M
        orw2lfa3CP8dUCCrDFs/wMy5gt0FQneI8PEQlTKkSw==
X-Google-Smtp-Source: APXvYqwfTG3XIJMOd6zYoiaFB7RBS7dBO5NkBZzvNoiLPcwO6oj+MdoMhskIOXV2jg011+rwltFZBuP69xupYjsUk54=
X-Received: by 2002:aca:fc50:: with SMTP id a77mr24717405oii.0.1563504834412;
 Thu, 18 Jul 2019 19:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <1563495160-25647-1-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1563495160-25647-1-git-send-email-bo.liu@linux.alibaba.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 18 Jul 2019 19:53:42 -0700
Message-ID: <CAPcyv4jR3vscppooTFBEU=Kp4CNVfthNNz1pV6jxwyg2bmdBjg@mail.gmail.com>
Subject: Re: [PATCH] mm: fix livelock caused by iterating multi order entry
To:     Liu Bo <bo.liu@linux.alibaba.com>
Cc:     stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
        Peng Tao <tao.peng@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ add Sasha for -stable advice ]

On Thu, Jul 18, 2019 at 5:13 PM Liu Bo <bo.liu@linux.alibaba.com> wrote:
>
> The livelock can be triggerred in the following pattern,
>
>         while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
>                                 min(end - index, (pgoff_t)PAGEVEC_SIZE),
>                                 indices)) {
>                 ...
>                 for (i = 0; i < pagevec_count(&pvec); i++) {
>                         index = indices[i];
>                         ...
>                 }
>                 index++; /* BUG */
>         }
>
> multi order exceptional entry is not specially considered in
> invalidate_inode_pages2_range() and it ended up with a livelock because
> both index 0 and index 1 finds the same pmd, but this pmd is binded to
> index 0, so index is set to 0 again.
>
> This introduces a helper to take the pmd entry's length into account when
> deciding the next index.
>
> Note that there're other users of the above pattern which doesn't need to
> fix,
>
> - dax_layout_busy_page
> It's been fixed in commit d7782145e1ad
> ("filesystem-dax: Fix dax_layout_busy_page() livelock")
>
> - truncate_inode_pages_range
> This won't loop forever since the exceptional entries are immediately
> removed from radix tree after the search.
>
> Fixes: 642261a ("dax: add struct iomap based DAX PMD support")
> Cc: <stable@vger.kernel.org> since 4.9 to 4.19
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>
> The problem is gone after commit f280bf092d48 ("page cache: Convert
> find_get_entries to XArray"), but since xarray seems too new to backport
> to 4.19, I made this fix based on radix tree implementation.

I think in this situation, since mainline does not need this change
and the bug has been buried under a major refactoring, is to send a
backport directly against the v4.19 kernel. Include notes about how it
replaces the fix that was inadvertently contained in f280bf092d48
("page cache: Convert find_get_entries to XArray"). Do you have a test
case that you can include in the changelog?
