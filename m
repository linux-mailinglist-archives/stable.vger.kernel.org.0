Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0B622FA19
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 22:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgG0Uag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 16:30:36 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52604 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726196AbgG0Uad (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 16:30:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595881832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hw5a11evQWNoZLcSM3PhrQFxwvQ8zctZnXM4jg3v0qk=;
        b=MJGDbb2FRAmIuqES8FHkphpqaUW/rdwNOAreMHv5tWqS2XJBtXtbpkKgL8ZgI0R5ozoRRl
        f1USM9zh4eFs1oSohcWX/ARYpktEAxjiKVxWzE3pKvDbQvIFhH8GKQosxye2eSvwjIicVQ
        qH7scPvX/oiklxTXyXlHVGeOtSrn74A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-LgqPGVQYPI6kbodr6iBHuw-1; Mon, 27 Jul 2020 16:30:28 -0400
X-MC-Unique: LgqPGVQYPI6kbodr6iBHuw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F1C11932480;
        Mon, 27 Jul 2020 20:30:27 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F31F410013D7;
        Mon, 27 Jul 2020 20:30:26 +0000 (UTC)
Date:   Mon, 27 Jul 2020 16:30:26 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     John Donnelly <john.p.donnelly@oracle.com>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: (resend) [PATCH [linux-4.14.y]] dm cache: submit writethrough
 writes in parallel to origin and cache
Message-ID: <20200727203025.GA28830@redhat.com>
References: <37c5a615-655d-c106-afd0-54e03f3c0eef@oracle.com>
 <20200727150014.GA27472@redhat.com>
 <20200727191809.GI406581@sasha-vm>
 <D8DDA535-33D5-4E80-85B3-62A463441B5F@oracle.com>
 <20200727201700.GJ406581@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727201700.GJ406581@sasha-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27 2020 at  4:17pm -0400,
Sasha Levin <sashal@kernel.org> wrote:

> On Mon, Jul 27, 2020 at 02:38:52PM -0500, John Donnelly wrote:
> >
> >
> >>On Jul 27, 2020, at 2:18 PM, Sasha Levin <sashal@kernel.org> wrote:
> >>
> >>On Mon, Jul 27, 2020 at 11:00:14AM -0400, Mike Snitzer wrote:
> >>>This mail needs to be saent to stable@vger.kernel.org (now cc'd).
> >>>
> >>>Greg et al: please backport 2df3bae9a6543e90042291707b8db0cbfbae9ee9
> >>
> >>Hm, what's the issue that this patch addresses? It's not clear from the
> >>commit message.
> >>
> >>--
> >>Thanks,
> >>Sasha
> >
> >HI Sasha ,
> >
> >In an off-line conversation I had with Mike , he indicated that :
> >
> >
> >commit 1b17159e52bb31f982f82a6278acd7fab1d3f67b
> >Author: Mike Snitzer <snitzer@redhat.com>
> >Date:   Fri Feb 28 18:00:53 2020 -0500
> >
> >  dm bio record: save/restore bi_end_io and bi_integrity
> >
> >
> >commit 248aa2645aa7fc9175d1107c2593cc90d4af5a4e
> >Author: Mike Snitzer <snitzer@redhat.com>
> >Date:   Fri Feb 28 18:11:53 2020 -0500
> >
> >  dm integrity: use dm_bio_record and dm_bio_restore
> >
> >
> >Were picked up  in  "stable" kernels picked up even though
> >neither was marked for stable@vger.kernel.org
> >
> >Adding this missing  commit :
> >
> >2df3bae9a6543e90042291707b8db0cbfbae9ee9
> >
> >
> >Completes the series
> 
> Should we just revert those two commits instead if they're not needed?

I'd be fine with that, exceept I haven't looked to see whether any
other stable commits conflict with reverting them.

But you have my blessing to give it a shot ;)

Mike

