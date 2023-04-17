Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332CF6E4E31
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 18:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjDQQWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 12:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjDQQWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 12:22:32 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B3A5BB3
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 09:22:26 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-552ae3e2cbeso51676267b3.13
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 09:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681748545; x=1684340545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9qqF9B0Sz3hWGl8lp8w0SC9VFttXX9F/0UBZXJc8LdE=;
        b=O+IupxaO3kOEk4LZ8PMz7M1+WC06Ctx7jwcKQOXom5VE2vP548mPHKM62zpIsbZ/z5
         J/bUAgd38QG9yjfv6lFEa92MzyY5mDDeU7qY2XEAmv4WHIL3o6ZQStKvK53ZyqXTG1Ux
         raay+P0IBseG5ELTRQWxxGHsUEAm8/y33N2BM/dO9nsU/IqsdEz5SqKAG9AVQWakzb/i
         i6A1Nc9BlTL4Gmce2wcpjpusihjc7uyl+Gq2O5LVk22cDjm9olATWEg+V1qRiTDvYZK8
         u1sazrm+KAwfJf8RESywW7ocFI80bOLzXHGcfH2NghpmkfBzt9mlx5uiX2jGnjxLMUke
         EZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681748545; x=1684340545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9qqF9B0Sz3hWGl8lp8w0SC9VFttXX9F/0UBZXJc8LdE=;
        b=LW0s1ZXpV/5X9wBOPlS+KRilnyqB4VeYlpqVFThpqpLMurSf0iQVkYMYjjq8gUrvTF
         WrbkvqtFa4j1438PH0oNSMbDF2FtLMZwefNFJ59IoturjMuVkTG2PL5Wx8Nwy6LjXbR1
         B/dZSfsTGICsyTiYMO1BCMYSZ0An2E0HM8FLsJlbpx+7W0MOAdo3ftaeeofdwvpN0rJK
         lXxWa+ZfNlCzs2jIDuXxqgcdE72TfbR4RYqCl0jSJ9jCtMLfkWeBPbEdpTYuqsPfUaSc
         2+vUCMnNDzDgas0V5+q2mQ2IUgPYEhcYHYYDtVNY8BTMu/x2yYLeFdmOiXLeYhhbWM5X
         CFLg==
X-Gm-Message-State: AAQBX9dusrj/LRSycDP+eRZBVSxYlwXm0Uzr6YKAg47UEueX4fRPivMU
        xnAYhzPYCTwwjBss3jftC8U3SwHNqWPxrPZuBnBv
X-Google-Smtp-Source: AKy350Y0DLw5tz9PIc3EICASrVKN0fK1tXB+NpmFnsqUhEJX+BLy04ShEbasbAaSm0yXOilWHxcbl2myHRlWIK/xP64=
X-Received: by 2002:a81:b50a:0:b0:54b:fd28:c5ff with SMTP id
 t10-20020a81b50a000000b0054bfd28c5ffmr9878142ywh.3.1681748545541; Mon, 17 Apr
 2023 09:22:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230412023839.2869114-1-jstultz@google.com> <20230412035905.3184199-1-jstultz@google.com>
 <20230417111949.GJ83892@hirez.programming.kicks-ass.net>
In-Reply-To: <20230417111949.GJ83892@hirez.programming.kicks-ass.net>
From:   John Stultz <jstultz@google.com>
Date:   Mon, 17 Apr 2023 18:22:14 +0200
Message-ID: <CANDhNCp2WEAMjK1DUVKCen05-EdwVBYZxxLSP3ZSZvRh1ayAhQ@mail.gmail.com>
Subject: Re: [PATCH v2] locking/rwsem: Add __always_inline annotation to __down_read_common()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Tim Murray <timmurray@google.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>, kernel-team@android.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 17, 2023 at 1:19=E2=80=AFPM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Wed, Apr 12, 2023 at 03:59:05AM +0000, John Stultz wrote:
> > Apparently despite it being marked inline, the compiler
> > may not inline __down_read_common() which makes it difficult
> > to identify the cause of lock contention, as the blocked
> > function will always be listed as __down_read_common().
> >
> > So this patch adds __always_inline annotation to the
> > function to force it to be inlines so the calling function
> > will be listed.
>
> I'm a wee bit confused; what are you looking at? Wchan?

Apologies! Yes, traceevent data via wchan, sorry I didn't make that clear.

> What is stopping
> the compiler from now handing you
> __down_read{,_interruptible,_killable}() instead? Is that fine?

No, we want to make the blocked calling function, rather than the
locking functions, visible in the tracepoints captured. That said, the
other __down_read* functions seem to be properly inlined in practice
(Waiman's theory as to why sounds convincing to me).

If you'd like I can add those as well to be always_inline, as well so
it's more consistent?

thanks
-john
