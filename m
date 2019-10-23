Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 517D1E2390
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 22:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404168AbfJWUAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 16:00:45 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39612 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733176AbfJWUAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 16:00:44 -0400
Received: by mail-pl1-f194.google.com with SMTP id s17so10604439plp.6
        for <stable@vger.kernel.org>; Wed, 23 Oct 2019 13:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=jL7YH7Fjq1P1RNBDDDVMpkcwNNt3gwJI8ibnwp8UcA0=;
        b=H5TGVYtbmxJDnjBAlV5R0/O1Wg+CEVoOjLx+GxePd3BfJWnKrgRN64LBI9ZRSI8SZU
         3tPLdb6b2OUUx/1PvEs5uqw72BSsrWY3TmEEtm97ELqOKPKcgod6Ib+pXFddTOSvCT/M
         I5Nd8BhuZ1dswizZVvXpxSbkwexp2nJiDrHAJ1R5WyhUL1nB0O8mBC7PWvTuzrZjeXcJ
         mHFZOfFD+Ewd0kCNXeoRyIFA4VO1sJ/O5YrCo6M4Y0OyIsJZ1B0K3Uf3ckfdVlAg0xzh
         XQ7qmYxuGzIz37MdMu/A7H0+DO+WXGPCHBP+vfhEtbT4Q259iIziW+MEigfM9GbQ6B1w
         DiJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=jL7YH7Fjq1P1RNBDDDVMpkcwNNt3gwJI8ibnwp8UcA0=;
        b=Ngmpj6U940M1L5srLLHkhwmLxhRsjZcCGFYMotpy1ZsVLJ0vzCbiZGI/A35RRLGZ3G
         heB/aVgmXrI1HAH4aL04muEzEkeld69U4OsRjmETgFObPhSdhTmwsuaCL6meKfX0c73c
         o6VSUh2yGcYeE+jEw7ENvmQSHxI8IEc4Uv5fHrzf/hNqDJ+VB4fNEqyjV5T/zdi/OXUe
         u58TfCt183PCo4jRIwsVPFAMvMdnjv7k88czfsL70g7EVB56BDZB1NnWP44BBpJ10pSU
         SaPhltd4HZ16vEYxNpwwDU+aEYH1SVSAnVMwkqASA8l6wcsYn4HNQ/dda0rpbPmGXtXs
         XCkg==
X-Gm-Message-State: APjAAAXOlOoI6OjmWqCzVcpByU2O9KGq6spIw2sztXTcj+8A7IHMQjln
        sInARqmPnTD3lWGH+0J2are34w==
X-Google-Smtp-Source: APXvYqwNsfwfkeoTe2BZwqQxl/10o/f9XEmvONkoaKUlhyRRYWn4js2YYJh3uOjA6AetNdKceyh2Og==
X-Received: by 2002:a17:902:9005:: with SMTP id a5mr11418732plp.204.1571860841311;
        Wed, 23 Oct 2019 13:00:41 -0700 (PDT)
Received: from [100.112.92.218] ([104.133.9.106])
        by smtp.gmail.com with ESMTPSA id c34sm23458622pgb.35.2019.10.23.13.00.40
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 13:00:40 -0700 (PDT)
Date:   Wed, 23 Oct 2019 13:00:24 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Yang Shi <yang.shi@linux.alibaba.com>
cc:     Hugh Dickins <hughd@google.com>, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com, gavin.dg@linux.alibaba.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v2 PATCH] mm: thp: handle page cache THP correctly in
 PageTransCompoundMap
In-Reply-To: <4d3c14ef-ee86-2719-70d6-68f1a8b42c28@linux.alibaba.com>
Message-ID: <alpine.LSU.2.11.1910231250260.1794@eggly.anvils>
References: <1571850304-82802-1-git-send-email-yang.shi@linux.alibaba.com> <alpine.LSU.2.11.1910231157570.1088@eggly.anvils> <4d3c14ef-ee86-2719-70d6-68f1a8b42c28@linux.alibaba.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 23 Oct 2019, Yang Shi wrote:
> On 10/23/19 12:28 PM, Hugh Dickins wrote:
> > 
> > > +	return map_count >= 0 &&
> > You have added a map_count >= 0 test there. Okay, not wrong, but not
> > necessary, and not consistent with what's returned in the PageAnon
> > case (if this were called for an unmapped page).
> 
> I was thinking about this too. I'm wondering there might be a case that the
> PMD is split and it was the last PMD map, in this case subpage's _mapcount is
> also equal to compound_mapcount (both is -1). So, it would return true, then
> KVM may setup PMD map in EPT, but it might be PTE mapped later on the host.
> But, I'm not quite sure if this is really possible or if this is really a
> integrity problem. So, I thought it might be safer to add this check.

The mmu_notifier_invalidate_range_start.._end() in __split_huge_pmd(),
with KVM's locking and sequence counting, is required to protect
against such races.

Hugh
