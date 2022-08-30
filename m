Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DCE5A62A3
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 14:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiH3MAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 08:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiH3MAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 08:00:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF403AE6F;
        Tue, 30 Aug 2022 05:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=PdmZTpzthURRizUZ4JSn2ogictuJkmVakktejwJD/dQ=; b=H5ll5BMZRJfCXUcTYrh+kk5imH
        irP4h4IRToGvqnj3tgPuUzjoGOrUWYO4ranhLM75kFZII7bOXd+wQifv6AGa3BxVGVQp/POexa0VH
        F50M0M8yF3UVFAEzV0UlWIJThz1fdukyAkqmoRNgpwxqR3MKuBwDGPZsB755z9wqbIJNflV3TEz42
        IpannB3sI0keaI9cLYY9Q+ye6kI2fYO71YwRpuPBOWLZtIKUij7DvODCrlhzSjXN+pS44iWcXFAkY
        7JipoQOweYAJyJ/wZ8wN+P2ZGlQpZW5nlG1x6s6hIu0oFEMemiu9QN23P3ZIg4JrbjLeKFhz52wCB
        2VtuvuyQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oSzuX-0040Ca-Lk; Tue, 30 Aug 2022 12:00:05 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E11A330031D;
        Tue, 30 Aug 2022 14:00:02 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BF6C720A3C659; Tue, 30 Aug 2022 14:00:02 +0200 (CEST)
Date:   Tue, 30 Aug 2022 14:00:02 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     =?iso-8859-1?Q?Martin-=C9ric?= Racine <martin-eric.racine@iki.fi>
Cc:     Ben Hutchings <ben@decadent.org.uk>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        1017425@bugs.debian.org, stable@vger.kernel.org,
        regressions@lists.linux.dev,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: Re: [PATCH] x86/speculation: Avoid LFENCE in FILL_RETURN_BUFFER on
 CPUs that lack it
Message-ID: <Yw37wnE19bAIhhP2@hirez.programming.kicks-ass.net>
References: <Yv7aRJ/SvVhSdnSB@decadent.org.uk>
 <Yv9OGVc+WpoDAB0X@worktop.programming.kicks-ass.net>
 <Yv9tj9vbQ9nNlXoY@worktop.programming.kicks-ass.net>
 <9395338630e3313c1bf0393ae507925d1f9af870.camel@decadent.org.uk>
 <Yv9+8vR4QH6j6J/5@worktop.programming.kicks-ass.net>
 <CAPZXPQeYh_BrZzinsvCjHvd=szAsOXUmkVYS1tJC5vwamx+Wow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPZXPQeYh_BrZzinsvCjHvd=szAsOXUmkVYS1tJC5vwamx+Wow@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 02:42:04PM +0300, Martin-Éric Racine wrote:
> Greetings,
> 
> On Fri, Aug 19, 2022 at 3:15 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Fri, Aug 19, 2022 at 01:38:27PM +0200, Ben Hutchings wrote:
> >
> > > So that puts the whole __FILL_RETURN_BUFFER inside an alternative, and
> > > we can't have nested alternatives.  That's unfortunate.
> >
> > Well, both alternatives end with the LFENCE instruction, so I could pull
> > it out and do two consequtive ALTs, but unrolling the loop for i386 is
> > a better solution in that the sequence, while larger, removes the need
> > for the LFENCE.
> 
> Have we reached a definitive conclusion on to how to fix this?

https://git.kernel.org/tip/332924973725e8cdcc783c175f68cf7e162cb9e5
