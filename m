Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6607C3CD3C5
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 13:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhGSKnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 06:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236491AbhGSKnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 06:43:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7920CC061574;
        Mon, 19 Jul 2021 03:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8h+gj7zMndgQ4v2Max/ZsB0/KwqWBXcqOeZTsebwUqk=; b=gW/ia2amiUtk2+XkJaE5YxL0cz
        clPKSzMoF3fVNbFSKTYkVGVJPMIuN46DVHFZlG8fdHGaMbLJaFnHJwnt2tdgjSg6wHvocqC8NHC3d
        cpSEArsyy272WbCLLPVNlqxa2UY0/xG0OEzbirzpeeyjZRFMHcMe7pt6QG/9buJYx/R7OAZjOAATh
        v2gpydY18wkgPxhwl5AiKwSozqfsHnkl6xEd09VE0V+IUeEqiSuOua/Ez+vPEiY9t43wQALDKOxcx
        Nj3J5p9iAYnOziuHbqS1lYsvCj5G5kABcJj+uSKOLlEZA9IPWvZ6wXqAmx73yweSDhuq9gkwTH4oo
        vi3rB+cw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m5RLl-006nhP-Aq; Mon, 19 Jul 2021 11:22:44 +0000
Date:   Mon, 19 Jul 2021 12:22:17 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     Boqun Feng <boqun.feng@gmail.com>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>, paulmck@kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
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
Message-ID: <YPVgaY6uw59Fqg5x@casper.infradead.org>
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <2245518.LNIG0phfVR@natalenko.name>
 <6698965.kvI7vG0SvZ@natalenko.name>
 <20210718215914.GQ4397@paulmck-ThinkPad-P17-Gen-1>
 <YPSweHyCrD2q2Pue@casper.infradead.org>
 <20210719015313.GS4397@paulmck-ThinkPad-P17-Gen-1>
 <CAABZP2yE+3vzd+LgJDJcJ2f8qttJQSUQ6efD9MaFd2iD4xPTZA@mail.gmail.com>
 <YPTmtNMJpykEpzx6@casper.infradead.org>
 <YPVQfaamqwu1PRrK@boqun-archlinux>
 <08803f78-3e99-6b3f-e809-5828fe47cf06@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08803f78-3e99-6b3f-e809-5828fe47cf06@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 07:12:58PM +0800, Miaohe Lin wrote:
> When in the commit 2799e77529c2a, we're using the percpu_ref to serialize against
> concurrent swapoff, i.e. there's percpu_ref inside get_swap_device() instead of
> rcu_read_lock(). Please see commit 63d8620ecf93 ("mm/swapfile: use percpu_ref to
> serialize against concurrent swapoff") for detail.

Oh, so this is a backport problem.  2799e77529c2 was backported without
its prerequisite 63d8620ecf93.  Greg, probably best to just drop
2799e77529c2 from all stable trees; the race described is not very
important (swapoff vs reading a page back from that swap device).
