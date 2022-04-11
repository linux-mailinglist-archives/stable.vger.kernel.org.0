Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8304FBD0A
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 15:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241027AbiDKNaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 09:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbiDKNaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 09:30:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BA5A18F
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 06:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB894B815B3
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 13:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9DDC385A4;
        Mon, 11 Apr 2022 13:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649683662;
        bh=K6u8kuHNlnW0AmZZfXiQ+6iUmXkMHlpTPYJjgxSWInc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ioBMbdDlNr1sxi5EM29+JY5muo8U12I6/k6qrTrB3+EB6Xv/FLCs1HiXz6Arm7RIn
         Hj1UrBSpYgBJNlBVojmsxL8mYaZfFVvE1ot645GVGtOCWSU8yDM607lu4pi0t+xsa4
         nQe7Tmx9VQTo9/q1cjXOJ17scZYAdWdMMduZzB2E=
Date:   Mon, 11 Apr 2022 15:27:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5.10] ubsan: remove CONFIG_UBSAN_OBJECT_SIZE
Message-ID: <YlQsywGKHwxYWtu2@kroah.com>
References: <20220331160219.10687-1-tadeusz.struk@linaro.org>
 <a12b6cf4-2002-09d6-80a4-56bfea0b4e56@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a12b6cf4-2002-09d6-80a4-56bfea0b4e56@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 09:07:02AM -0700, Tadeusz Struk wrote:
> On 3/31/22 09:02, Tadeusz Struk wrote:
> > Upstream commit: 69d0db01e210 ("ubsan: remove CONFIG_UBSAN_OBJECT_SIZE")
> > 
> > The object-size sanitizer is redundant to -Warray-bounds, and
> > inappropriately performs its checks at run-time when all information
> > needed for the evaluation is available at compile-time, making it quite
> > difficult to use:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=214861
> > 
> > This run-time object-size checks also trigger false-positive errors,
> > like the below, that make it quite difficult to test stable kernels in
> > test automations like syzkaller:
> > 
> > https://syzkaller.appspot.com/text?tag=Error&x=12b3aac3700000
> > 
> > With -Warray-bounds almost enabled globally, it doesn't make sense to
> > keep this around.
> 
> Hi,
> This back-port is for 5.10 only. Please also cherry-pick the original
> commit 69d0db01e210 ("ubsan: remove CONFIG_UBSAN_OBJECT_SIZE")
> to 5.15.y and 5.16.y. There is no back-port required for these kernels.

Now queued up, thanks.

greg k-h
