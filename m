Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FB63CD43D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 13:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbhGSLSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 07:18:44 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:55666 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhGSLSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 07:18:44 -0400
Received: from spock.localnet (unknown [151.237.229.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 29CEDB3F506;
        Mon, 19 Jul 2021 13:59:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1626695962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lEKGRenaAPW2gmTFyg57lWPQrt1Vqj2PhxfMAnpoKJU=;
        b=d7hajsSlNaqrqEWRUG0Ghtkzz+3EOXNYXRxp/oeBEBA+eE99YxWxRpSFDd4jBWG4X6y06I
        ADrN3O1atnVXbEsIvtzpvg53MakH1UoQjdWBG4LqW5mE+IqKMSz61I1C9XUMMHYeYKgMb3
        XFYR7z+zaMV7h2ycTcjo3GdgR1bin+0=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Matthew Wilcox <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>
Cc:     Boqun Feng <boqun.feng@gmail.com>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>, paulmck@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Chris Clayton <chris2553@googlemail.com>,
        Chris Rankin <rankincj@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        rcu <rcu@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        "Huang, Ying" <ying.huang@intel.com>, gregkh@linuxfoundation.org
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
Date:   Mon, 19 Jul 2021 13:59:20 +0200
Message-ID: <2145858.R0O0FObHBN@natalenko.name>
In-Reply-To: <8058e175-cec5-c243-6499-c1cd4e3c8605@huawei.com>
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com> <YPVgaY6uw59Fqg5x@casper.infradead.org> <8058e175-cec5-c243-6499-c1cd4e3c8605@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On pond=C4=9Bl=C3=AD 19. =C4=8Dervence 2021 13:50:07 CEST Miaohe Lin wrote:
> On 2021/7/19 19:22, Matthew Wilcox wrote:
> > On Mon, Jul 19, 2021 at 07:12:58PM +0800, Miaohe Lin wrote:
> >> When in the commit 2799e77529c2a, we're using the percpu_ref to serial=
ize
> >> against concurrent swapoff, i.e. there's percpu_ref inside
> >> get_swap_device() instead of rcu_read_lock(). Please see commit
> >> 63d8620ecf93 ("mm/swapfile: use percpu_ref to serialize against
> >> concurrent swapoff") for detail.
> >=20
> > Oh, so this is a backport problem.  2799e77529c2 was backported without
> > its prerequisite 63d8620ecf93.  Greg, probably best to just drop
>=20
> Yes, they're posted as a patch set:
>=20
> https://lkml.kernel.org/r/20210426123316.806267-1-linmiaohe@huawei.com
>=20
> > 2799e77529c2 from all stable trees; the race described is not very
> > important (swapoff vs reading a page back from that swap device).
> > .
>=20
> The swapoff races with reading a page back from that swap device should be
> really uncommon as most users only do swapoff when the system is going to
> shutdown.
>=20
> Sorry for the trouble!

git log --oneline v5.13..v5.13.3 --author=3D"Miaohe Lin"
11ebc09e50dc mm/zswap.c: fix two bugs in zswap_writeback_entry()
95d192da198d mm/z3fold: use release_z3fold_page_locked() to release locked=
=20
z3fold page
ccb7848e2344 mm/z3fold: fix potential memory leak in z3fold_destroy_pool()
9f7229c901c1 mm/huge_memory.c: don't discard hugepage if other processes ar=
e=20
mapping it
f13259175e4f mm/huge_memory.c: add missing read-only THP checking in=20
transparent_hugepage_enabled()
afafd371e7de mm/huge_memory.c: remove dedicated macro HPAGE_CACHE_INDEX_MASK
a533a21b692f mm/shmem: fix shmem_swapin() race with swapoff
c3b39134bbd0 swap: fix do_swap_page() race with swapoff

Do you suggest reverting "mm/shmem: fix shmem_swapin() race with swapoff" a=
s=20
well?

=2D-=20
Oleksandr Natalenko (post-factum)


