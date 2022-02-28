Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FD84C6F84
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 15:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbiB1ObK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 09:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237184AbiB1ObI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 09:31:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9467EB33;
        Mon, 28 Feb 2022 06:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XfmIhW9nefMDb0zDTmGJWtqR+tWEq/czupXA0KsLpuU=; b=qbmDJRUut1QJorb6OhzfhKehG0
        JIALb8xpWSL+u2jovi++1IazK9pdTw8LlGUTLVjmcJ01rc2Hhyx9WJLwvCoYJWi39huunsIdMnMvU
        4h2MWso+ADY41rCVoK4w4GBj2iaP9ADHe77DbBAU7pI6J+tndzHONKwgdkvktgX2za+dd5wtIMdcl
        NBFzPCEnS6If7LMQ6NoyEJz7EJG9dN4X5jUyeTc0NE0XmE+l83nSQuTdndlRHEP8hz68MI/nUyUbW
        gSd3zugZEtHmmU+6zwHAD7B/xHKPQTNG9ylSqU9C6U99rcerieNDO1XynItF+BQ/f93DXeatpwcg0
        tZGakbbA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOh2R-008bVC-QB; Mon, 28 Feb 2022 14:30:11 +0000
Date:   Mon, 28 Feb 2022 14:30:11 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Marco Elver <elver@google.com>
Cc:     Kees Cook <keescook@chromium.org>, llvm@lists.linux.dev,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <Yhzcc1YfpgEXzKdh@casper.infradead.org>
References: <20220225221625.3531852-1-keescook@chromium.org>
 <CANpmjNOup5JCjRpRkhsF3Z+dPX6_MQE5u6WhnMit84c1TyRK+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNOup5JCjRpRkhsF3Z+dPX6_MQE5u6WhnMit84c1TyRK+A@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 12:24:51PM +0100, Marco Elver wrote:
> 2. Somehow statically computing the size-class's size (kmalloc_index()
> might help here), removing __alloc_size from allocation functions and
> instead use some wrapper.

I don't think that's computable.  I have been thinking about a slab flag
that would say "speed is more important than size; if the smallest slab
for this size of allocation has no free objects, search larger slabs
to get memory instead of allocating a new slab".  If we did have such
a feature, it would be impossible to know how large ksize() would report.

