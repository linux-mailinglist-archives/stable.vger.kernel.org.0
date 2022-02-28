Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB30A4C784A
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbiB1Srh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbiB1Srg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:47:36 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC0D21D;
        Mon, 28 Feb 2022 10:46:56 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 91D2E219A0;
        Mon, 28 Feb 2022 18:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646074015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XFD/luhJC8LruRYLMs0gTooM9kEU0Vb0THBd4sc3pRA=;
        b=KRyo6rUkMNul2GZJKG7Kx0l4Nw4gD3yieyj/lCJCTigs5UFZ978tEqO1/WbNe75Q6r5PU/
        jEvk+0GNiPgx1SINVBkCHyUeG/o7df+NptnWhTTZ+74gBbV0gL7jhYSV9B5RCwwVVOAH9R
        vHSGjFMxoT/+7S52NU/YCFOvI+99ku4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6539F13AE1;
        Mon, 28 Feb 2022 18:46:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rAuLF58YHWJGTgAAMHmgww
        (envelope-from <mkoutny@suse.com>); Mon, 28 Feb 2022 18:46:55 +0000
Date:   Mon, 28 Feb 2022 19:46:53 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Ivan Babrou <ivan@cloudflare.com>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Dao <dqminh@cloudflare.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] memcg: async flush memcg stats from perf sensitive
 codepaths
Message-ID: <20220228184653.GA1812@blackbody.suse.cz>
References: <20220226002412.113819-1-shakeelb@google.com>
 <20220225165842.561d3a475310aeab86a2d653@linux-foundation.org>
 <CALvZod7SA17vounKnq1KX23172rztNN_Oo0K1XaeEuS4JVEhMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod7SA17vounKnq1KX23172rztNN_Oo0K1XaeEuS4JVEhMw@mail.gmail.com>
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

On Fri, Feb 25, 2022 at 05:42:57PM -0800, Shakeel Butt <shakeelb@google.com> wrote:
> Yes, the right fix would be to optimize the flushing code (but that
> would require more work/time). However I still think letting
> performance critical code paths to skip the sync flush would be good
> in general. So, if the current patch is not to your liking we can
> remove mem_cgroup_flush_stats() from workingset_refault().

What about flushing just the subtree of the memcg where the refault
happens?
It doesn't reduce the overall work and there's still full-tree
cgroup_rstat_lock but it should make the chunks of work smaller
durations more regular.


Michal

