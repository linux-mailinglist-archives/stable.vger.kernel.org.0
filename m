Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6A47198537
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 22:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgC3UPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 16:15:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53698 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgC3UPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 16:15:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/xEbuMGYqmKuHMDUjBVJBLPSd80GP8iW0lTrFNQajdc=; b=RoNOfN4K2vUegOotGDYgeJWEot
        kv2sgwuqwkdc5K2UiMqswl1k0KhFobQVPqYDpBN1gHj+OKMfQHf2zFSzX+CccW239CJA7UUAoSoat
        k0Y9FlUx1EB7DiLAspF9mGU0QUMSzK2l8qHFfzi31vRtcMEG4+YKPxYCBTqkzKSHAizc0XvnzoLG7
        /m8iClxzCeE2Nos8MRR/rGw3ZxJalgZxDPUmrOQBEs/BOs7jxs/E9C3MCGjpQBUBqbcn+P7/hCsdW
        tQc1TFa4zMly2KLuX41ajABY/EblsHBIm+ByOXb8n6h2xPznquh5XSfFg5iy1gCBdyfb7lIn8Yjjz
        FV7mG8Qw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJ0oF-0006Lj-Kn; Mon, 30 Mar 2020 20:14:59 +0000
Date:   Mon, 30 Mar 2020 13:14:59 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v6 00/16] Infrastructure to allow fixing exec deadlocks
Message-ID: <20200330201459.GF22483@bombadil.infradead.org>
References: <AM6PR03MB5170B2F5BE24A28980D05780E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <871rpg8o7v.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170938306F22C3CF61CC573E4CD0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003282041.A2639091@keescook>
 <AM6PR03MB5170E0E722ED0B05B149C135E4CB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR03MB5170E0E722ED0B05B149C135E4CB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 10:12:02PM +0200, Bernd Edlinger wrote:
> On 3/29/20 5:44 AM, Kees Cook wrote:
> > On Sat, Mar 28, 2020 at 11:32:35PM +0100, Bernd Edlinger wrote:
> >> Oh, do I understand you right, that I can add a From: in the
> >> *body* of the mail, and then the From: in the MIME header part
> >> which I cannot change is ignored, so I can make you the author?
> > 
> > Correct. (If you use "git send-email" it'll do this automatically.)
> > 
> > e.g., trimmed from my workflow:
> > 
> > git format-patch -n --to "$to" --cover-letter -o outgoing/ \
> > 	--subject-prefix "PATCH v$version" "$SHA"
> > edit outgoing/0000-*
> > git send-email --transfer-encoding=8bit --8bit-encoding=UTF-8 \
> > 	--from="$ME" --to="$to" --cc="$ME" --cc="...more..." outgoing/*
> > 
> > 
> 
> Okay, thanks, I see that is very helpful information for me, and in
> this case I had also fixed a small bug in one of Eric's patches, which
> was initially overlooked (aquiring mutexes in wrong order,
> releasing an unlocked mutex in some error paths).
> I am completely unexperienced, and something that complex was not
> expected to happen :-) so this is just to make sure I can handle it
> correctly if something like this happens again.
> 
> In the case of PATCH v6 05/16 I removed the Reviewd-by: Bernd Edlinger
> since it is now somehow two authors and reviewing own code is obviously
> not ok, instead I added a Signed-off-by: Bernd Edlinger (and posted the
> whole series on Eric's behalf (after asking Eric's permissing per off-list
> e-mail, which probably ended in his spam folder)
> 
> Is this having two Signed-off-by: for mutliple authors the
> correct way to handle a shared authorship?

If the patch comes through you, then Reviewed-by: is inappropriate.
Instead, you should use Signed-off-by: in the second sense of
Documentation/process/submitting-patches.rst

This also documents how to handle "minor changes" that you make.
