Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDC44FC2E1
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 19:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238284AbiDKRGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 13:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244412AbiDKRGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 13:06:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EE438E;
        Mon, 11 Apr 2022 10:04:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E31A1B81717;
        Mon, 11 Apr 2022 17:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEC9C385A3;
        Mon, 11 Apr 2022 17:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649696642;
        bh=frZ/qMfauBfztraKieX1XcHWLdV0Dc/40AGkHPNQZVE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HBq0buwJVJYQCcSglb5aK/veFAkmgoM6jxovsN5bQhtdYSYDanDbS6C1dHNeBxUDh
         HG+3pIvGm7mpqy6hhA/DIT6F8XzMyh5lBKzRhVjik0bYAgFVD/00Nk3aaFYIxPGqkn
         GYZe3biU8w8n0UoKSyPpoPmxla6I1WBfyHupEPjc=
Date:   Mon, 11 Apr 2022 19:04:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH] [Rebased for 5.15,5.16,5.17] static_call: Don't make
 __static_call_return0 static
Message-ID: <YlRfgBe7AeAyoLlr@kroah.com>
References: <155efe38aa611a362ed23a52cecc26371399ae7f.1649696042.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155efe38aa611a362ed23a52cecc26371399ae7f.1649696042.git.christophe.leroy@csgroup.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 11, 2022 at 06:54:43PM +0200, Christophe Leroy wrote:
> This is backport to 5.15,5.16,5.17
> 
> (cherry picked from commit 8fd4ddda2f49a66bf5dd3d0c01966c4b1971308b)
> 
> System.map shows that vmlinux contains several instances of
> __static_call_return0():
> 
> 	c0004fc0 t __static_call_return0
> 	c0011518 t __static_call_return0
> 	c00d8160 t __static_call_return0
> 
> arch_static_call_transform() uses the middle one to check whether we are
> setting a call to __static_call_return0 or not:
> 
> 	c0011520 <arch_static_call_transform>:
> 	c0011520:       3d 20 c0 01     lis     r9,-16383	<== r9 =  0xc001 << 16
> 	c0011524:       39 29 15 18     addi    r9,r9,5400	<== r9 += 0x1518
> 	c0011528:       7c 05 48 00     cmpw    r5,r9		<== r9 has value 0xc0011518 here
> 
> So if static_call_update() is called with one of the other instances of
> __static_call_return0(), arch_static_call_transform() won't recognise it.
> 
> In order to work properly, global single instance of __static_call_return0() is required.
> 
> Fixes: 3f2a8fc4b15d ("static_call/x86: Add __static_call_return0()")
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Link: https://lkml.kernel.org/r/30821468a0e7d28251954b578e5051dc09300d04.1647258493.git.christophe.leroy@csgroup.eu
> ---
>  include/linux/static_call.h                   |   5 +-
>  kernel/Makefile                               |   3 +-
>  kernel/static_call.c                          | 542 +-----------------
>  .../{static_call.c => static_call_inline.c}   |   5 -
>  4 files changed, 4 insertions(+), 551 deletions(-)
>  copy kernel/{static_call.c => static_call_inline.c} (99%)

Thanks for this, now queued up!

greg k-h
