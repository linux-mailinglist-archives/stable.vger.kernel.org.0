Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101935EADC0
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiIZRM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiIZRMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:12:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5DE11C1C;
        Mon, 26 Sep 2022 09:22:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4830A60B75;
        Mon, 26 Sep 2022 16:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01354C433D6;
        Mon, 26 Sep 2022 16:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664209363;
        bh=MCzP9eVXLKhxRL2tdxliiONv5on5c/ZHccysA1C1M94=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oXljwazRhRbwilif7FNPSeMAC8RTeh5deZY7pRY26AQuG4oF3FclRSyg9/9Hh0kNh
         kDEM0tljg0B1xYlbkUCT6TpN48EsJIiSdereBKcJF4H/goZHs/e5SCHZv1AWr4X/Fn
         0LLDkPoQA9wtEnkfOabFiHJzIk41MtKPy2q8YhWc=
Date:   Mon, 26 Sep 2022 09:22:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        stable@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: split initialization into early arch step and
 later non-arch step
Message-Id: <20220926092241.64f73e7420cea6b964f1f116@linux-foundation.org>
In-Reply-To: <20220926160332.1473462-1-Jason@zx2c4.com>
References: <20220926160332.1473462-1-Jason@zx2c4.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sep 2022 18:03:32 +0200 "Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> The full RNG initialization relies on some timestamps, made possible
> with general functions like time_init() and timekeeping_init(). However,
> these are only available rather late in initialization. Meanwhile, other
> things, such as memory allocator functions, make use of the RNG much
> earlier.
> 
> So split RNG initialization into two phases. We can give arch randomness
> very early on, and then later, after timekeeping and such are available,
> initialize the rest.
> 
> This ensures that, for example, slabs are properly randomized if RDRAND
> is available. Another positive consequence is that on systems with
> RDRAND, running with CONFIG_WARN_ALL_UNSEEDED_RANDOM=y results in no
> warnings at all.

Please give a full description of the user-visible runtime effects of
this shortcoming.

> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: stable@vger.kernel.org

Which is important when proposing a -stable backport.


