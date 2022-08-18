Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5D3598142
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 12:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241012AbiHRKEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 06:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbiHRKEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 06:04:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7CB474FC;
        Thu, 18 Aug 2022 03:04:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 31652353CA;
        Thu, 18 Aug 2022 10:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660817088; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yGB57PLr3/XCzM4eFzUWiwdrtPGGJcwk3YhcDibPx8M=;
        b=gvEy9i+g+y8d7rIZ0U0o86DQsVZwmbcNxlRYSpGPZr0T18g6ijVFRl1wyUxyWXaJJFfxPx
        9qoD12WHed4RQwOShceW3e3jpd7+bBtOWgXhiU9NWNAk7soVGUTTfqS40al6REZE5TWySi
        1MximM3wxgOE7vjWSPav2gtm55geZkg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DA66E139B7;
        Thu, 18 Aug 2022 10:04:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Kkw+NL8O/mJLCgAAMHmgww
        (envelope-from <mkoutny@suse.com>); Thu, 18 Aug 2022 10:04:47 +0000
Date:   Thu, 18 Aug 2022 12:04:46 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        David Hildenbrand <david@redhat.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "memcg: cleanup racy sum avoidance code"
Message-ID: <20220818100446.GA789@blackbody.suse.cz>
References: <20220817172139.3141101-1-shakeelb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817172139.3141101-1-shakeelb@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 05:21:39PM +0000, Shakeel Butt <shakeelb@google.com> wrote:
> $ grep "sock " /mnt/memory/job/memory.stat
> sock 253952
> total_sock 18446744073708724224
> 
> Re-run after couple of seconds
> 
> $ grep "sock " /mnt/memory/job/memory.stat
> sock 253952
> total_sock 53248
> 
> For now we are only seeing this issue on large machines (256 CPUs) and
> only with 'sock' stat. I think the networking stack increase the stat on
> one cpu and decrease it on another cpu much more often. So, this
> negative sock is due to rstat flusher flushing the stats on the CPU that
> has seen the decrement of sock but missed the CPU that has increments. A
> typical race condition.

This theory adds up :-) (Provided the numbers.)

> For easy stable backport, revert is the most simple solution.

Sounds reasonable.

> For long term solution, I am thinking of two directions. First is just
> reduce the race window by optimizing the rstat flusher. Second is if
> the reader sees a negative stat value, force flush and restart the
> stat collection.  Basically retry but limited.

Or just stick with the revert since it already reduces the observed
error by rounding to zero in simple way.

(Or if the imprecision was worth extra storage, use two-stage flushing
to accumulate (cpus x cgroups) and assign in two steps.)

Thanks,
Michal
