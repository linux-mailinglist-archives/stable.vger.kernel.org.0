Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8CD3CCC5D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 04:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbhGSCrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 22:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhGSCrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 22:47:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B9CC061762;
        Sun, 18 Jul 2021 19:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CkU8nVUDnffLrkz4DUK+GmPmahjzgRndjrnRCR8YauY=; b=UFffVny8+0I97DD+4Ofigd11P7
        zDhen93BvIB5vb2XX78j/xX10LqnrvRjWNwN2sfNILyJDpI7D8/RVjukpSN2KsiDHJPclj9cXikm7
        U1Yvzoj0zF0KHxzcGslUsLsG2GHoRlko377Dxo+VHw6u1oY2B37wjHCkVX6n74Q8lzI0LXQbEJWT0
        hJjXabSUC+qR63Xl4GfF7uYDYBpzPOTYsaO0CjJexxcs5ZyN5s5Ig5NlXznFVLJj9weQOqYEFOLsg
        xMFkXLv6KSWJmXLez5SOSxYaXZaxA4RFFumDrA3tm0eEhvKMzo+iHaSBSa1U8gPhnsTKa0h0trUxk
        0wfU23eQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m5JFE-006TD0-Qc; Mon, 19 Jul 2021 02:43:17 +0000
Date:   Mon, 19 Jul 2021 03:43:00 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc:     paulmck@kernel.org, Oleksandr Natalenko <oleksandr@natalenko.name>,
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
        Linux-MM <linux-mm@kvack.org>
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
Message-ID: <YPTmtNMJpykEpzx6@casper.infradead.org>
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <2245518.LNIG0phfVR@natalenko.name>
 <6698965.kvI7vG0SvZ@natalenko.name>
 <20210718215914.GQ4397@paulmck-ThinkPad-P17-Gen-1>
 <YPSweHyCrD2q2Pue@casper.infradead.org>
 <20210719015313.GS4397@paulmck-ThinkPad-P17-Gen-1>
 <CAABZP2yE+3vzd+LgJDJcJ2f8qttJQSUQ6efD9MaFd2iD4xPTZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAABZP2yE+3vzd+LgJDJcJ2f8qttJQSUQ6efD9MaFd2iD4xPTZA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 10:24:18AM +0800, Zhouyi Zhou wrote:
> Meanwhile, I examined the 5.12.17 by naked eye, and found a suspicious place
> that could possibly trigger that problem:
> 
> struct swap_info_struct *get_swap_device(swp_entry_t entry)
> {
>      struct swap_info_struct *si;
>      unsigned long offset;
> 
>      if (!entry.val)
>              goto out;
>     si = swp_swap_info(entry);
>     if (!si)
>        goto bad_nofile;
> 
>    rcu_read_lock();
>   if (data_race(!(si->flags & SWP_VALID)))
>      goto unlock_out;
>   offset = swp_offset(entry);
>   if (offset >= si->max)
>    goto unlock_out;
> 
>   return si;
> bad_nofile:
>   pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
> out:
>   return NULL;
> unlock_out:
>   rcu_read_unlock();
>   return NULL;
> }
> I guess the function "return si" without a rcu_read_unlock.

Yes, but the caller is supposed to call put_swap_device() which
calls rcu_read_unlock().  See commit eb085574a752.
