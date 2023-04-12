Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C356DE9C1
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 05:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjDLDDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 23:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjDLDDb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 23:03:31 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7514269F
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 20:03:28 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-54c0c86a436so314959867b3.6
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 20:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681268608; x=1683860608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=17CalVnlnSF1u3wj9kLiBfp288Sjx7j6mGn09upq5ig=;
        b=II9wI4cDuaPTzXJlKSDhJzCqs/51mr2T6pfc2TNXQ2F/7U/xhHgXrFjDAlndm9j12n
         d5py3YRGQe7Ln5rz7JlFCUkemPyR2seauPLce64VZaHp7gx+SAwkSF0M7qFr9R6X3b05
         LVhtx26Bi4z0JZ0CkMtJJLHezCF3+erFmnH12GxByzF/ppw3qKCdB/K+gQ0btklJN6HA
         H5JQ7ZulOnQl7FNaAYcrkzvXCKWjRC0+Z6ko4hb9jBmpkuH5kVWf/2zm1Xv06p3yGDaC
         GV38u3qoDDZ64naGLy/tR/7CFKdS4FPJhu9uO/oQNp679jDmumpN+4S0K8oqzB1wWZCt
         ot4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681268608; x=1683860608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=17CalVnlnSF1u3wj9kLiBfp288Sjx7j6mGn09upq5ig=;
        b=PtK9TJqlgLkp2RvkjlL2p8dvSB/+gBgubvH9mCZvefSluwhejaSCUUZnaYYjXf17/O
         OYWHX1iv3TUfMQ//k0U82fJjAH2eVyc0bLPbh0i1DADsYLnCz4FqpKlCILQ57i2/X7tB
         w+uEC/uxRlb2NPBSI/l4RJFOWMdCeYK/batJSXtwnQuVaRHqn2XJ4uBVH7RhwGo7+hGZ
         xEnmbDyvc+ZxcSmwc3Nlg+ERARzRDY0r9ZOpFDot3ofUvRCFg6fFo1Y+1JBUAfRNZbrJ
         k2J5zgorchJcNzZ9b8HMYQBQTpEN33JV/sMQYeIPeJ5c9wrt0GHFbWa27vKOWCADj6M/
         ypUQ==
X-Gm-Message-State: AAQBX9cTvGkxEr0ErUAbFIS8VMne9JUovJNpBxrOvGzFklF94p0BHQfv
        tKFQjLMES2xkb+8hHNWIxu2M/1+PzBglayoya6uY
X-Google-Smtp-Source: AKy350bAxWRcztok/L6FYt+6p+5XhVextFdJQtIbjL4nccr4o1JaYPN5wkZIwYLr8kXeSturZMs1N9TP1psmkQqBcYE=
X-Received: by 2002:a81:ac27:0:b0:54c:21c9:cb6 with SMTP id
 k39-20020a81ac27000000b0054c21c90cb6mr454504ywh.5.1681268607902; Tue, 11 Apr
 2023 20:03:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230412023839.2869114-1-jstultz@google.com> <5e7d733c-7272-d202-c80a-f8e8f23478d0@redhat.com>
In-Reply-To: <5e7d733c-7272-d202-c80a-f8e8f23478d0@redhat.com>
From:   John Stultz <jstultz@google.com>
Date:   Tue, 11 Apr 2023 20:03:15 -0700
Message-ID: <CANDhNCo2=2qT6qzJf97cdsjPhCue8U98yaHhxcL1RbNtGK+98Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] locking/rwsem: Add __sched annotation to __down_read_common()
To:     Waiman Long <longman@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Tim Murray <timmurray@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, kernel-team@android.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 11, 2023 at 7:58=E2=80=AFPM Waiman Long <longman@redhat.com> wr=
ote:
>
> On 4/11/23 22:38, John Stultz wrote:
> > Apparently despite it being marked inline, the compiler
> > may not inline __down_read_common() which makes it difficult
> > to identify the cause of lock contention, as the blocked
> > function will always be listed as __down_read_common().
> >
> > So this patch adds __sched annotation to the function so
> > the calling function will instead be listed.
> >
...
> > -static inline int __down_read_common(struct rw_semaphore *sem, int sta=
te)
> > +static inline __sched int __down_read_common(struct rw_semaphore *sem,=
 int state)
> >   {
> >       int ret =3D 0;
> >       long count;
>
> Change inline to __always_inline instead of adding __sched.
> __down_read_common() is not supposed to be a standalone function.

Sounds good. I'll give that a go and will re-submit!
Thanks for the review!
-john
