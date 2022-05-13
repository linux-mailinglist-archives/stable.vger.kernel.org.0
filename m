Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E0F525D62
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 10:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351091AbiEMIZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 04:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358165AbiEMIZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 04:25:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA57E2716C6
        for <stable@vger.kernel.org>; Fri, 13 May 2022 01:25:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 10CEFCE2DA4
        for <stable@vger.kernel.org>; Fri, 13 May 2022 08:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1AAC34100;
        Fri, 13 May 2022 08:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652430307;
        bh=CzLC9hqmUfKi6OEUUAQwHI74/QXX0ymS+WpEP5Y/Vkc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sghwJYukEmX/SZpbv9V2OgBQlM0j6M9sjBn+Gk4FK/ZHol15awgFAQPizBpZ+i+T2
         60qcmkDFjZGG3xiMWmt8x012HHs1hUZXC/opGFhqARtnXZH6Tv8pj1oGtx+VDm5w7X
         z8qd0K3IO943RPj13Nk6oHaiCU2Rkirb96BAFMP8=
Date:   Fri, 13 May 2022 10:25:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Meena Shanmugam <meenashanmugam@google.com>
Cc:     stable@vger.kernel.org, trond.myklebust@hammerspace.com
Subject: Re: Request to cherry-pick f00432063db1 to 5.10
Message-ID: <Yn4V4HdJFyHARf1b@kroah.com>
References: <CAMdnWFC4+-mEubOVkzaoqC5jnJCwY5hpcQtDnkmgqJ-mY5_GYg@mail.gmail.com>
 <Yn00jd+uX8PVZv/9@kroah.com>
 <CAMdnWFBCyiU-p1ww5NQnvMxVUnVyCkzoS6D+6Hg=7aJR4Bwn5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMdnWFBCyiU-p1ww5NQnvMxVUnVyCkzoS6D+6Hg=7aJR4Bwn5Q@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 12, 2022 at 10:38:04AM -0700, Meena Shanmugam wrote:
> On Thu, May 12, 2022 at 9:23 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, May 10, 2022 at 07:33:23PM -0700, Meena Shanmugam wrote:
> > > Hi all,
> > >
> > > The commit f00432063db1a0db484e85193eccc6845435b80e upstream (SUNRPC:
> > > Ensure we flush any closed sockets before xs_xprt_free()) fixes
> > > CVE-2022-28893, hence good candidate for stable trees.
> > > The above commit depends on 3be232f(SUNRPC: Prevent immediate
> > > close+reconnect)  and  89f4249(SUNRPC: Don't call connect() more than
> > > once on a TCP socket). Commit 3be232f depends on commit
> > > e26d9972720e(SUNRPC: Clean up scheduling of autoclose).
> > >
> > > Commits e26d9972720e, 3be232f, f00432063db1 apply cleanly on 5.10
> > > kernel. commit 89f4249 didn't apply cleanly. I have patch for 89f4249
> > > below.
> >
> > We also need this for 5.15.y first, before we can apply it to 5.10.y.
> > Can you provide a working backport for that tree as well?
> >
> > And as others pointed out, your patch is totally corrupted and can not
> > be used, please fix your email client.
> >
> > thanks,
> >
> > greg k-h
> 
> For 5.15.y commit f00432063db1a0db484e85193eccc6845435b80e((SUNRPC:
> Ensure we flush any closed sockets before xs_xprt_free())) applies
> cleanly. The depend patch
> 3be232f(SUNRPC: Prevent immediate close+reconnect) also applies
> cleanly. Patch  89f4249
> (SUNRPC: Don't call connect() more than once on a TCP socket) is
> already present in 5.15.34 onwards.
> 
> Sorry about the patch corruption, I will fix it.

Sorry, but this did not work out at all, I get build errors when
attempting it for 5.10.y:

  CC [M]  net/sunrpc/xprtsock.o
net/sunrpc/xprtsock.c: In function ‘xs_tcp_setup_socket’:
net/sunrpc/xprtsock.c:2276:13: error: too few arguments to function ‘test_and_clear_bit’
 2276 |         if (test_and_clear_bit(XPRT_SOCK_CONNECT_SENT),
      |             ^~~~~~~~~~~~~~~~~~
In file included from ./arch/x86/include/asm/bitops.h:391,
                 from ./include/linux/bitops.h:29,
                 from ./include/linux/kernel.h:12,
                 from ./include/asm-generic/bug.h:20,
                 from ./arch/x86/include/asm/bug.h:93,
                 from ./include/linux/bug.h:5,
                 from ./include/linux/mmdebug.h:5,
                 from ./include/linux/gfp.h:5,
                 from ./include/linux/slab.h:15,
                 from net/sunrpc/xprtsock.c:24:
./include/asm-generic/bitops/instrumented-atomic.h:81:20: note: declared here
   81 | static inline bool test_and_clear_bit(long nr, volatile unsigned long *addr)
      |                    ^~~~~~~~~~~~~~~~~~
net/sunrpc/xprtsock.c:2276:55: warning: left-hand operand of comma expression has no effect [-Wunused-value]
 2276 |         if (test_and_clear_bit(XPRT_SOCK_CONNECT_SENT),
      |                                                       ^
net/sunrpc/xprtsock.c:2312:17: warning: this statement may fall through [-Wimplicit-fallthrough=]
 2312 |                 set_bit(XPRT_SOCK_CONNECT_SENT, &transport->sock_state);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
net/sunrpc/xprtsock.c:2313:9: note: here
 2313 |         case -EALREADY:
      |         ^~~~
make[2]: *** [scripts/Makefile.build:280: net/sunrpc/xprtsock.o] Error 1
make[1]: *** [scripts/Makefile.build:497: net/sunrpc] Error 2


And I am not quite sure what order you want me to apply things for 5.15.y.

So please, send me a properly backported series of patches for this for 5.15.y
and 5.10.y and I will be glad to pick them up.  Right now I'm just confused as
this was obviously not tested at all :(

thanks,

greg k-h
