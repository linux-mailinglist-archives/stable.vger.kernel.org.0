Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82113F3136
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 18:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhHTQKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 12:10:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238564AbhHTQJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 12:09:35 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8898D61213;
        Fri, 20 Aug 2021 16:08:55 +0000 (UTC)
Date:   Fri, 20 Aug 2021 12:08:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, willy@infradead.org,
        linux-nfs@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-doc@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-afs@lists.infradead.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org,
        akpm@linux-foundation.org, luto@kernel.org, bfields@fieldses.org,
        w@1wt.eu, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] fs: warn about impending deprecation of
 mandatory locks
Message-ID: <20210820120848.5692d25a@oasis.local.home>
In-Reply-To: <0f4f3e65-1d2d-e512-2a6f-d7d63effc479@redhat.com>
References: <20210820135707.171001-1-jlayton@kernel.org>
        <20210820135707.171001-2-jlayton@kernel.org>
        <0f4f3e65-1d2d-e512-2a6f-d7d63effc479@redhat.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Aug 2021 17:52:19 +0200
David Hildenbrand <david@redhat.com> wrote:

> > +static bool warned_mand;
> >   static inline bool may_mandlock(void)
> >   {
> > +	if (!warned_mand) {
> > +		warned_mand = true;
> > +		pr_warn("======================================================\n");
> > +		pr_warn("WARNING: the mand mount option is being deprecated and\n");
> > +		pr_warn("         will be removed in v5.15!\n");
> > +		pr_warn("======================================================\n");
> > +	}  
> 
> Is there a reason not to use pr_warn_once() ?

You would need a single call though, otherwise each pr_warn_once()
would have its own state that it warned once.

	const char warning[] =
		"======================================================\n"
		"WARNING: the mand mount option is being deprecated and\n"
		"         will be removed in v5.15!\n"
		"======================================================\n";

	pr_warn_once(warning);

-- Steve
