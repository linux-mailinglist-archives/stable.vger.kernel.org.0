Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF06E501D
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 17:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440755AbfJYP15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 11:27:57 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37605 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440754AbfJYP15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 11:27:57 -0400
Received: by mail-lf1-f68.google.com with SMTP id b20so2103090lfp.4
        for <stable@vger.kernel.org>; Fri, 25 Oct 2019 08:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=p1Hpmsd781iQPQDBjQH17bW2u73+OuLAp5jOLLAjrpU=;
        b=UjpzsMmefP9GXBLnHTmzYQaImtlmjwNNXQBPcTENIshdDReqiRpsXTajTZ5+KU5WOr
         sMORwXoI9mw57B1wzSdN9dDcXPRDeKZ2E/Cwj26oupxnaWLqtZ8gjpoW3CvuTVuQQu7U
         UipzSYuGz4Htd+a0tUdJRH9nHwoBEfud7JY0wppGc/BIWMzXb1hwTtXy7G8R117Yr4aF
         a789TgwI+45jxxaL8wR5yp/78EU06i3pcebfatjq4+2dwfY/Wgijw8bLrDn9vASP4YBa
         Cz+a6j1fBxpDKKljotXQqF5dP4xcCJI2v4IvM7v3awR5zJflIA/ZGIPKa32z+Q7QVf+s
         PeWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=p1Hpmsd781iQPQDBjQH17bW2u73+OuLAp5jOLLAjrpU=;
        b=Z7NF1vNo64gdiwVPI9do8W6pSyCVgRC5OFnMK4mC4ZefJpE/K5CYJWVjEmZaOSv4mS
         g8OBjLO6356Y4wO10/10jH0syXlu8lk/xSVLRtlmr4dDPW7nW6eSDre9HoWtFj2jB25u
         BBXy7qK2Kyd9Q3GxNP4tlb7EghqWl7Fl3cRh75jPqF1mtCaU25ciG7OJtoNF8P8WW7Hs
         ylusWFw6+KoXr0qQzXP31HnQLcdKucxcRHX09VAduwkyqGQeoVzWh7CuxN3utrJyes4V
         BBB2tHeBYQD8PEswlB5LRBaLGD6A2IUlZOHdvNMPW1doBnLudCSEWTpFX4JnvAudjZgo
         DjKg==
X-Gm-Message-State: APjAAAVKBAAdnU9pKXNEGTFGTONP7H6DhKOUJ739APAfsUXEFQpW0sGz
        JZNBDmt2S8ZQ1eag/vZyOyBulQ==
X-Google-Smtp-Source: APXvYqx8ut170aduTcnwpN2s58bh8CtaxjaBrLwb48WkUcqiuDYotYDlIZtCagLNprtwWMYn8tqYbQ==
X-Received: by 2002:a19:c6d6:: with SMTP id w205mr2917433lff.17.1572017275214;
        Fri, 25 Oct 2019 08:27:55 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id c21sm1020556lfh.33.2019.10.25.08.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 08:27:54 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id D8B1010267F; Fri, 25 Oct 2019 18:27:53 +0300 (+03)
Date:   Fri, 25 Oct 2019 18:27:53 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     hughd@google.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com, willy@infradead.org,
        gavin.dg@linux.alibaba.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [v4 PATCH] mm: thp: handle page cache THP correctly in
 PageTransCompoundMap
Message-ID: <20191025152753.qdob7tpdnnzlje6k@box>
References: <1571865575-42913-1-git-send-email-yang.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571865575-42913-1-git-send-email-yang.shi@linux.alibaba.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 05:19:35AM +0800, Yang Shi wrote:
> We have usecase to use tmpfs as QEMU memory backend and we would like to
> take the advantage of THP as well.  But, our test shows the EPT is not
> PMD mapped even though the underlying THP are PMD mapped on host.
> The number showed by /sys/kernel/debug/kvm/largepage is much less than
> the number of PMD mapped shmem pages as the below:
> 
> 7f2778200000-7f2878200000 rw-s 00000000 00:14 262232 /dev/shm/qemu_back_mem.mem.Hz2hSf (deleted)
> Size:            4194304 kB
> [snip]
> AnonHugePages:         0 kB
> ShmemPmdMapped:   579584 kB
> [snip]
> Locked:                0 kB
> 
> cat /sys/kernel/debug/kvm/largepages
> 12
> 
> And some benchmarks do worse than with anonymous THPs.
> 
> By digging into the code we figured out that commit 127393fbe597 ("mm:
> thp: kvm: fix memory corruption in KVM with THP enabled") checks if
> there is a single PTE mapping on the page for anonymous THP when
> setting up EPT map.  But, the _mapcount < 0 check doesn't fit to page
> cache THP since every subpage of page cache THP would get _mapcount
> inc'ed once it is PMD mapped, so PageTransCompoundMap() always returns
> false for page cache THP.  This would prevent KVM from setting up PMD
> mapped EPT entry.
> 
> So we need handle page cache THP correctly.  However, when page cache
> THP's PMD gets split, kernel just remove the map instead of setting up
> PTE map like what anonymous THP does.  Before KVM calls get_user_pages()
> the subpages may get PTE mapped even though it is still a THP since the
> page cache THP may be mapped by other processes at the mean time.
> 
> Checking its _mapcount and whether the THP has PTE mapped or not.
> Although this may report some false negative cases (PTE mapped by other
> processes), it looks not trivial to make this accurate.
> 
> With this fix /sys/kernel/debug/kvm/largepage would show reasonable
> pages are PMD mapped by EPT as the below:
> 
> 7fbeaee00000-7fbfaee00000 rw-s 00000000 00:14 275464 /dev/shm/qemu_back_mem.mem.SKUvat (deleted)
> Size:            4194304 kB
> [snip]
> AnonHugePages:         0 kB
> ShmemPmdMapped:   557056 kB
> [snip]
> Locked:                0 kB
> 
> cat /sys/kernel/debug/kvm/largepages
> 271
> 
> And the benchmarks are as same as anonymous THPs.
> 
> Fixes: dd78fedde4b9 ("rmap: support file thp")
> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
> Reported-by: Gang Deng <gavin.dg@linux.alibaba.com>
> Tested-by: Gang Deng <gavin.dg@linux.alibaba.com>
> Suggested-by: Hugh Dickins <hughd@google.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: <stable@vger.kernel.org> 4.8+

Looks good to me.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
