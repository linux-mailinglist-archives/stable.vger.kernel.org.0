Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3D64D8587
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237850AbiCNM6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241770AbiCNM6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:58:16 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2873811A3E;
        Mon, 14 Mar 2022 05:57:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CBBA6218FE;
        Mon, 14 Mar 2022 12:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647262624; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TaLNlzXGwgt3rIVBhMb8m6A+9RFUlVGbRu4EdMRGlyg=;
        b=eFmcNQFmrNsywdOeFr5SEDup6JsmNK0K+YScoACNqR2qy1LHFFYhq1WsNq+LI5EPmA8/2Q
        bQCv7UfngnJKKpainDF0pEVNMNsKVuHf3pi0c/ifsViuOWtm9nfJR/G4o6naP5tiL4+IiB
        27UYnqde9XPDx7asXLRv5oXrc/eu6lc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A930B13B34;
        Mon, 14 Mar 2022 12:57:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wMNRKKA7L2KcTgAAMHmgww
        (envelope-from <mkoutny@suse.com>); Mon, 14 Mar 2022 12:57:04 +0000
Date:   Mon, 14 Mar 2022 13:57:03 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Ivan Babrou <ivan@cloudflare.com>,
        Frank Hofmann <fhofmann@cloudflare.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] memcg: sync flush only if periodic flush is delayed
Message-ID: <20220314125703.GA11645@blackbody.suse.cz>
References: <20220304184040.1304781-1-shakeelb@google.com>
 <20220311160051.GA24796@blackbody.suse.cz>
 <20220312190715.cx4aznnzf6zdp7wv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220312190715.cx4aznnzf6zdp7wv@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi.

On Sat, Mar 12, 2022 at 07:07:15PM +0000, Shakeel Butt <shakeelb@google.com> wrote:
> So, I will focus on the error rate in this email.

(OK, I'll stick to error estimate (for long-term) in this message and
will send another about the current patch.)

> [...]
> 
> > The benefit this was traded for was the greater accuracy, the possible
> > error is:
> > - before
> >    - O(nr_cpus * nr_cgroups(subtree) * MEMCG_CHARGE_BATCH)	(1)
> 
> Please note that (1) is the possible error for each stat item and
> without any time bound.

I agree (forgot to highlight this can stuck forever).

> 
> > - after
> >      O(nr_cpus * MEMCG_CHARGE_BATCH) // sync. flush
> 
> The above is across all the stat items.

Can it be used to argue about the error?
E.g.
    nr_cpus * MEMCG_CHARGE_BATCH / nr_counters
looks appealing but that's IMO too optimistic.

The individual item updates are correlated so in practice a single item
would see a lower error than my first relation but without delving too
much into correlations the upper bound is nr_counters independent.


> I don't get the reason of breaking 'cr' into individual stat item or
> counter. What is the benefit? We want to keep the error rate decoupled
> from the number of counters (or stat items).

It's just a model, it should capture that every stat item (change)
contributes to the common error estimate. (So it moves more towards the 
  nr_cpus * MEMCG_CHARGE_BATCH / nr_counters
per-item error (but here we're asking about processing time.))

[...]

> My main reason behind trying NR_MEMCG_EVENTS was to reduce flush_work by
> reducing nr_counters and I don't think nr_counters should have an impact
> on Δt.

The higher number of items is changing, the sooner they accumulate the
target error, no?

(Δt is not the periodic flush period, it's variable time between two
sync flushes.)

Michal
