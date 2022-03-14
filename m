Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40664D858A
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241216AbiCNM6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238582AbiCNM6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:58:22 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CD21261E;
        Mon, 14 Mar 2022 05:57:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3DEED1F391;
        Mon, 14 Mar 2022 12:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647262631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rDnjmno3RNaHoqZQk8WStttjohZNlh5HTFSnG4DmMuc=;
        b=mY8tCJ8kdj2//VBcpDAmvBBhExrUmqIb9QskcfqVQbsBuGJos52kN/oZy8yP8s3R3YkMAT
        55/zyV4NfDXeabMudRc7XBOL6SWU7OgUWrhN5/gRR9UioEoI1goBUSum1ejzdOss6B/OHt
        9gluR5EzP1m6EZGprUljPNBmw0yLXtU=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1825D13ADA;
        Mon, 14 Mar 2022 12:57:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Ua8+Bac7L2KtTgAAMHmgww
        (envelope-from <mkoutny@suse.com>); Mon, 14 Mar 2022 12:57:11 +0000
Date:   Mon, 14 Mar 2022 13:57:09 +0100
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
Message-ID: <20220314125709.GA12347@blackbody.suse.cz>
References: <20220304184040.1304781-1-shakeelb@google.com>
 <20220311160051.GA24796@blackbody.suse.cz>
 <20220312190715.cx4aznnzf6zdp7wv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Hi 2.

On Sat, Mar 12, 2022 at 07:07:15PM +0000, Shakeel Butt <shakeelb@google.com> wrote:
> It is (b) that I am aiming for in this patch. At least (a) was not
> happening in the cloudflare experiments. Are you suggesting having a
> dedicated high priority wq would solve both (a) and (b)?
> [...]
> > We can't argue what's the effect of periodic only flushing so this
> > newly introduced factor would inherit that too. I find it superfluous.
> 
> 
> Sorry I didn't get your point. What is superfluous?

Let me retell my understanding.
The current implementation flushes based on cumulated error and time.
Your patch proposes conditioning the former with another time-based
flushing, whose duration can be up to 2 times longer than the existing
periodic flush.

Assuming the periodic flush is working, the reader won't see data older
than 2 seconds, so the additional sync-flush after (possible) 4 seconds
seems superfluous.

(In the case of periodic flush being stuck, I thought the factor 2=4s/2s
was superfluous, another magic parameter.)

I'm comparing here your proposal vs no synchronous flushing in
workingset_refault().

> Do you have any strong concerns with the currect patch?

Does that clarify?

(I agree with your initial thesis this can be iterated before it evolves
to everyone's satisfaction.)


Michal

