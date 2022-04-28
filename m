Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11665139A9
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 18:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349926AbiD1QZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 12:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349948AbiD1QZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 12:25:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A71146A01F
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 09:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651162950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bdsvxHkxQ1ayVoY65cwtDE3V6Ao2iHmOMM19Zm5PkZw=;
        b=LS31H3OHVBeoBqSs06IfO8P1oGnqSaO5iT7JG2OGhpvxZfI9bD/MtUkokKj9d/2qlAXyho
        jE1WRaLo9Bt7/ja3S1abiwH2gRe9aTN11Mr7ijwopzSuIkZZvtwUowpCSKVcCF2VSK1lD+
        9dsZyHnzSDn5EMrzsxnl3uIjgXOc+Ck=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-90OxVjwMPwW4JEsr5FCuJw-1; Thu, 28 Apr 2022 12:22:27 -0400
X-MC-Unique: 90OxVjwMPwW4JEsr5FCuJw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09702101AA4D;
        Thu, 28 Apr 2022 16:22:27 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0107F40D1B99;
        Thu, 28 Apr 2022 16:22:26 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 23SGMQr2010319;
        Thu, 28 Apr 2022 12:22:26 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 23SGMQYV010316;
        Thu, 28 Apr 2022 12:22:26 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Thu, 28 Apr 2022 12:22:26 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5.10] dm: fix mempool NULL pointer race when
 completing IO
In-Reply-To: <YmeUXC3DZGLPJlWw@kroah.com>
Message-ID: <alpine.LRH.2.02.2204281155460.5963@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2204211407220.761@file01.intranet.prod.int.rdu2.redhat.com> <YmeUXC3DZGLPJlWw@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Tue, 26 Apr 2022, Greg Kroah-Hartman wrote:

> On Thu, Apr 21, 2022 at 02:08:30PM -0400, Mikulas Patocka wrote:
> > Hi
> 
> Not really needed in a changelog text :)
> 
> > This is backport of patches d208b89401e0 ("dm: fix mempool NULL pointer
> > race when completing IO") and 9f6dc6337610 ("dm: interlock pending dm_io
> > and dm_wait_for_bios_completion") for the kernel 5.10.
> 
> Can you just make these 2 different patches?
> 
> > 
> > The bugs fixed by these patches can cause random crashing when reloading
> > dm table, so it is eligible for stable backport.
> > 
> > This patch is different from the upstream patches because the code
> > diverged significantly.
> > 
> 
> This change is _VERY_ different.  I would need acks from the maintainers
> of this code before I could accept this, along with a much more detailed
> description of why the original commits will not work here as well.
> 
> Same for the other backports.

Regarding backporting of 9f6dc633:

My reasoning was that introducing "md->pending_io" in the backported 
stable kernels is useless - it will just degrade performance by consuming 
one more cache line per I/O without providing any gain.

In the upstream kernels, Mike needs that "md->pending_io" variable for 
other reasons (the I/O accounting was reworked there in order to avoid 
some spikes with dm-crypt), but there is no need for it in the stable 
kernels.

In order to fix that race condition, all we need to do is to make sure 
that dm_stats_account_io is called before bio_end_io_acct - and the patch 
does that - it swaps them.

Do you still insist that this useless percpu variable must be added to the 
stable kernels? If you do, I can make it, but I think it's better to just 
swap those two functions.

Mikulas

