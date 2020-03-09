Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43C817EB94
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 22:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCIV61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 17:58:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbgCIV61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 17:58:27 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1D1F2253D;
        Mon,  9 Mar 2020 21:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583791107;
        bh=29KSn/6fVHHENEBQvirhiLc58yhaT3CC78KGsKZTYLQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RdU9NXA/8HZ5WZUHGIrJhSobpt2yTYDt3dmgB0z43XHHnRYmclrV9/oT7+U2osFHQ
         HOGnXC7eAtZ6M/glwBBC5tQr60VoXe5yxpxuOi0x2JGrnJaXmShK07ahjwkUBciNsr
         qR10bIIyoABlUyNgcK7jYKvQczfb1099mNwUd48c=
Date:   Mon, 9 Mar 2020 17:58:25 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     ying.huang@intel.com, aarcange@redhat.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mhocko@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, ziy@nvidia.com
Subject: Re: FAILED: patch "[PATCH] mm: fix possible PMD dirty bit lost in"
 failed to apply to 4.14-stable tree
Message-ID: <20200309215825.GA24841@sasha-vm>
References: <158378131510638@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158378131510638@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 09, 2020 at 08:15:15PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 8a8683ad9ba48b4b52a57f013513d1635c1ca5c4 Mon Sep 17 00:00:00 2001
>From: Huang Ying <ying.huang@intel.com>
>Date: Thu, 5 Mar 2020 22:28:29 -0800
>Subject: [PATCH] mm: fix possible PMD dirty bit lost in
> set_pmd_migration_entry()
>
>In set_pmd_migration_entry(), pmdp_invalidate() is used to change PMD
>atomically.  But the PMD is read before that with an ordinary memory
>reading.  If the THP (transparent huge page) is written between the PMD
>reading and pmdp_invalidate(), the PMD dirty bit may be lost, and cause
>data corruption.  The race window is quite small, but still possible in
>theory, so need to be fixed.
>
>The race is fixed via using the return value of pmdp_invalidate() to get
>the original content of PMD, which is a read/modify/write atomic
>operation.  So no THP writing can occur in between.
>
>The race has been introduced when the THP migration support is added in
>the commit 616b8371539a ("mm: thp: enable thp migration in generic path").
>But this fix depends on the commit d52605d7cb30 ("mm: do not lose dirty
>and accessed bits in pmdp_invalidate()").  So it's easy to be backported
>after v4.16.  But the race window is really small, so it may be fine not
>to backport the fix at all.

As d52605d7cb30 ("mm: do not lose dirty and accessed bits in
pmdp_invalidate()") has an explicit note asking not to backport it, we
won't backport it or this patch to 4.14.

-- 
Thanks,
Sasha
