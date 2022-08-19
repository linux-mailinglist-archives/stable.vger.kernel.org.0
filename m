Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8CF599BB7
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 14:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348409AbiHSMQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 08:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348495AbiHSMQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 08:16:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38239100969;
        Fri, 19 Aug 2022 05:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uJIjedYarczgR1fsBatrH00iIT2IriOKYXL6KyniivQ=; b=lVjBzwDnL3TrLWNLHk7fn3Zu5H
        uOneN7WQJLk3Ocvk6+5NHFKCHi7tRAShM40RhrUHtyho7QHrHAg9Gq8avL2auKCXw82/3DsATrxIt
        F3hHmQ/GZVrguU14SMnEi1xfiKp2iuBlEwpwe1KKSgKDtmA9SGJ+BqXAedD0JnDxVqpAQyIg4qqaS
        RhNgIJGA1P8YMmmiNOaRDxVc4CASWoh2Z6WsV5GwLITc0PsAkbTyKH4f66HcJh0TMFV+FqFwYi6Yk
        alrKd5oIBDJrz7hFmhwl4PIi0kemfNQnTOhstNfXVZ7F/ClCIyzzZAW3TEuqjTaBkBkLLt0oTPBjQ
        8fRWd75Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oP0ui-00B6SB-EK; Fri, 19 Aug 2022 12:15:48 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 84B18980163; Fri, 19 Aug 2022 14:15:46 +0200 (CEST)
Date:   Fri, 19 Aug 2022 14:15:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        1017425@bugs.debian.org,
        =?iso-8859-1?Q?Martin-=C9ric?= Racine <martin-eric.racine@iki.fi>,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: Re: [PATCH] x86/speculation: Avoid LFENCE in FILL_RETURN_BUFFER on
 CPUs that lack it
Message-ID: <Yv9+8vR4QH6j6J/5@worktop.programming.kicks-ass.net>
References: <Yv7aRJ/SvVhSdnSB@decadent.org.uk>
 <Yv9OGVc+WpoDAB0X@worktop.programming.kicks-ass.net>
 <Yv9tj9vbQ9nNlXoY@worktop.programming.kicks-ass.net>
 <9395338630e3313c1bf0393ae507925d1f9af870.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9395338630e3313c1bf0393ae507925d1f9af870.camel@decadent.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 01:38:27PM +0200, Ben Hutchings wrote:

> So that puts the whole __FILL_RETURN_BUFFER inside an alternative, and
> we can't have nested alternatives.  That's unfortunate.

Well, both alternatives end with the LFENCE instruction, so I could pull
it out and do two consequtive ALTs, but unrolling the loop for i386 is
a better solution in that the sequence, while larger, removes the need
for the LFENCE.
