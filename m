Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79434C523E
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 00:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbiBYXp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 18:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiBYXpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 18:45:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172BA1B7561;
        Fri, 25 Feb 2022 15:45:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAE84B833C1;
        Fri, 25 Feb 2022 23:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AD5C340E7;
        Fri, 25 Feb 2022 23:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645832720;
        bh=NDHUSkypJld5d5CGQR6W7J8F3jQ+Dhc1F620s3ekMVg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M3B7HMJmt3xObSeYIG/wl8EEhpwltcLfl74Qun9Npta6HKmi1lGd0bjzQTbrl7T7b
         961g+Ynw1WYvQ6fMSsP7ryJsEr6+GR1FHEo1VVtT8Vzf+xriyAxgU+8xWecdee4F2e
         WFr7BqMNe7tbXnbOaopVlZvMs9rr1WyUSSBjyo54=
Date:   Fri, 25 Feb 2022 15:45:18 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     llvm@lists.linux.dev, Marco Elver <elver@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Micay <danielmicay@gmail.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] mm: Handle ksize() vs __alloc_size by forgetting size
Message-Id: <20220225154518.0d1159fdc6f37ee38e39e90c@linux-foundation.org>
In-Reply-To: <20220225221625.3531852-1-keescook@chromium.org>
References: <20220225221625.3531852-1-keescook@chromium.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Feb 2022 14:16:25 -0800 Kees Cook <keescook@chromium.org> wrote:

> If ksize() is used on an allocation, the compiler cannot make any
> assumptions about its size any more (as hinted by __alloc_size). Force
> it to forget.
> 
> One caller was using a container_of() construction that needed to be
> worked around.

Please, when fixing something do fully explain what that thing is.  I,
for one, simply cannot understand why this change is being proposed.

Especially when proposing a -stable backport!  Tell readers what was
the end-user impact of the bug.

> Link: https://github.com/ClangBuiltLinux/linux/issues/1599

Even that didn't tell me.  Is it just a clang warning?  Does the kernel
post your private keys on reddit then scribble all over your disk
drive?  I dunno.


