Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94014C924C
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 18:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbiCAR55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 12:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236724AbiCAR5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 12:57:48 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CFC41F8A;
        Tue,  1 Mar 2022 09:57:06 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6E71A1F39D;
        Tue,  1 Mar 2022 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646157425; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=buWeJHt6GiyDyp6c2t6RjOy396An8wRLpBnyIHHufHY=;
        b=Qa/tlCjNWZWBuQe2pEOePHVesePkJsxgpGAcf+RKInChvZEOpBSOv16KjCk6wN3eB9rRmD
        GZyyOTwaEbMN0GGXw2Xmw8uaT/U5BevMNkAopM6bozcI14rCPFaheJSxDUirS59knYxmsK
        6sub2e238Ivp/5yAAgjARKA1omAM1WM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3EA0313B89;
        Tue,  1 Mar 2022 17:57:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Ks7BDXFeHmJXRwAAMHmgww
        (envelope-from <mkoutny@suse.com>); Tue, 01 Mar 2022 17:57:05 +0000
Date:   Tue, 1 Mar 2022 18:57:03 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Ivan Babrou <ivan@cloudflare.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Dao <dqminh@cloudflare.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] memcg: async flush memcg stats from perf sensitive
 codepaths
Message-ID: <20220301175703.GA10867@blackbody.suse.cz>
References: <20220226002412.113819-1-shakeelb@google.com>
 <Yh3h33W45+YaMo92@dhcp22.suse.cz>
 <CALvZod7aF9xRc+XvY7GPN7OnDyPitt1H6Q4yrwzAXTFzv1LzWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod7aF9xRc+XvY7GPN7OnDyPitt1H6Q4yrwzAXTFzv1LzWQ@mail.gmail.com>
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

Making decisions based on up to 2 s old information.

On Tue, Mar 01, 2022 at 09:21:12AM -0800, Shakeel Butt <shakeelb@google.com> wrote:
> Without flushing the worst that can happen in the refault path is
> false (or missed) activations of the refaulted page.

Yeah, this may under- or overestimate workingset size (when it's
changing), the result is likely only less efficient reclaim.

> For reclaim code, some heuristics (like deactivating active LRU or
> cache-trim) may act on old information.

Here, I'd be more careful whether such a delay cannot introduce some
unstable behavior (permanent oscillation in the worst case).

> Now, coming to your question, yes, we can remove the flushing from
> these performance critical codepaths as the stats at most will be 2
> second old due to periodic flush. 

Another aspect is that people will notice and report such a narrowly
located performance regression more easily than reduced/less predictable
reclaim behavior. (IMO the former is better, OTOH, it can also be
interpreted that noone notices (is able to notice).)

Michal
