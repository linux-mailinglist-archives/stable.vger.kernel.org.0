Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194214C8B08
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 12:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbiCALoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 06:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234616AbiCALoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 06:44:23 -0500
X-Greylist: delayed 574 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Mar 2022 03:43:42 PST
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A9B55BD1;
        Tue,  1 Mar 2022 03:43:42 -0800 (PST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
        by gnuweeb.org (Postfix) with ESMTPSA id 342487EDA6;
        Tue,  1 Mar 2022 11:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646134448;
        bh=wMwH0Esa7+9XDQnRseGQt8XVBoPkgTDDTk0Y4Mory9w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ozNH5t1JqCXZkK+2cROun6P2rSOAmspGKECltAFEdVniA8sbDxBzMgW9oPNrpGbh1
         NzNz/TGh51LiBjUbwxMk2BAGleNmweGzvJtzI5rjcyW9hJNzJtnuI9g4+MDq2FZ5Vo
         rgTlebg9O99wGVDzAEBeeeAo+j5Rz07B5wdCfpk+Oa6zAAgpGx8mNgxkV/YhPicZaM
         cn/02HjPudmVAufa15GpcnRKYf4oERNNDAA9eUpyKIO+ePrWCAPMNgSXq7MefOFk9m
         jk+NmDVNv+zkyYKXul9xoMT5pad3v5vz3wDl5qSaQb16gkihZtgm00mJboSlrR0kcJ
         iu+wAfbinm4qw==
Received: by mail-lf1-f42.google.com with SMTP id j7so26338916lfu.6;
        Tue, 01 Mar 2022 03:34:08 -0800 (PST)
X-Gm-Message-State: AOAM533FqFQyYydoYGquVgR9KCPMq3HBLnKQDjWeIBGvsXLDIWrbb1sR
        8MonECnOBtNR92BRkVfdQg7q1YouKo8fXPcFd/4=
X-Google-Smtp-Source: ABdhPJx/og7d59BUuP9SzoT81fyxcdFHHXnA6Zmocol8wG52eI7x4l9kVQJ+3a3dLhPtZKivoBAxuF+VBA9iz/o4cMQ=
X-Received: by 2002:a05:6512:1190:b0:443:ff19:e685 with SMTP id
 g16-20020a056512119000b00443ff19e685mr14888853lfr.70.1646134446046; Tue, 01
 Mar 2022 03:34:06 -0800 (PST)
MIME-Version: 1.0
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org> <20220301094608.118879-2-ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220301094608.118879-2-ammarfaizi2@gnuweeb.org>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Tue, 1 Mar 2022 18:33:54 +0700
X-Gmail-Original-Message-ID: <CAOG64qPgTv5tQNknuG9d-=oL2EPQQ1ys7xu2FoBpNLyzv1qYzA@mail.gmail.com>
Message-ID: <CAOG64qPgTv5tQNknuG9d-=oL2EPQQ1ys7xu2FoBpNLyzv1qYzA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] x86/delay: Fix the wrong asm constraint in `delay_loop()`
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>, x86@kernel.org,
        stable@vger.kernel.org, Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 1, 2022 at 4:46 PM Ammar Faizi wrote:
> Fortunately, the constraint violation that's fixed by patch 1 doesn't
> yield any bug due to the nature of System V ABI. Should we backport
> this?

hi sir, it might also be interesting to know that even if it never be
inlined, it's still potential to break.

for example this code (https://godbolt.org/z/xWMTxhTET)

  __attribute__((__noinline__)) static void x(int a)
  {
      asm("xorl\t%%r8d, %%r8d"::"a"(a));
  }

  extern int p(void);

  int f(void)
  {
      int ret = p();
      x(ret);
      return ret;
  }

translates to this asm

  x:
          movl    %edi, %eax
          xorl    %r8d, %r8d
          ret
  f:
          subq    $8, %rsp
          call    p
          movl    %eax, %r8d
          movl    %eax, %edi
          call    x
          movl    %r8d, %eax
          addq    $8, %rsp
          ret

See the %r8d? It should be clobbered by a function call too. But since
no one tells the compiler that we clobber %r8d, it assumes %r8d never
changes after that call. The compiler thinks x() is static and will
not clobber %r8d, even the ABI says %r8d will be clobbered by a
function call. So i think it should be backported to the stable
kernel, it's still a fix

-- Viro
