Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49EC7F1D26
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 19:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbfKFSJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 13:09:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:57220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbfKFSJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 13:09:45 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A30CA2067B;
        Wed,  6 Nov 2019 18:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573063784;
        bh=FY+VXyS042hqe2bvJcmQdupgBykiS4rX0d53SHRw51I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2WRdGHt47CFD+6e0g9a/DCq16NRX0NOphUrmdhwSSR30P8qFIiTR1h+1XckzbdGi6
         JTzx+4Mdh2t9ZdVLdftRnRg4buh96CRSdHHPjMzM+SLN510XKwn5lrgEt2JEDG5eRM
         hZR253QLW/u0MMWwdShFA1PUX9uY0Uy4IRTAmVJ0=
Date:   Wed, 6 Nov 2019 10:09:42 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com,
        jlbec@evilplan.org, junxiao.bi@oracle.com,
        Linux-MM <linux-mm@kvack.org>, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable <stable@vger.kernel.org>, sunny.s.zhang@oracle.com
Subject: Re: [patch 05/17] ocfs2: protect extent tree in
 ocfs2_prepare_inode_for_write()
Message-Id: <20191106100942.ccdd57115916ea71754ed027@linux-foundation.org>
In-Reply-To: <CAHk-=wgZvzmijNca0rX+jcZZPPAdD8RSR0=5=vDB+1zUhHYD+w@mail.gmail.com>
References: <20191106051634.IwGqLbBvh%akpm@linux-foundation.org>
        <CAHk-=wgZvzmijNca0rX+jcZZPPAdD8RSR0=5=vDB+1zUhHYD+w@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 6 Nov 2019 08:41:44 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Nov 5, 2019 at 9:16 PM <akpm@linux-foundation.org> wrote:
> >
> > From: Shuning Zhang <sunny.s.zhang@oracle.com>
> > Subject: ocfs2: protect extent tree in ocfs2_prepare_inode_for_write()
> >
> > When the extent tree is modified, it should be protected by inode cluster
> > lock and ip_alloc_sem.
> >
> > The extent tree is accessed and modified in the
> > ocfs2_prepare_inode_for_write, but isn't protected by ip_alloc_sem.
> 
> This patch results in a new warning for me:
> 
>   fs/ocfs2/file.c:2101:12: warning: ‘ocfs2_prepare_inode_for_refcount’
> defined but not used [-Wunused-function]
>    2101 | static int ocfs2_prepare_inode_for_refcount(struct inode *inode,
>         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> and I'm wondering why nobody seems  to have noticed that or fixed
> things? Because it does look like this removed the only use of that
> function, and everybody who compiled this should have seen this
> warning?
> 

Oop, sorry, that's in a separate patch which I failed to squish.  Shall
send now.

