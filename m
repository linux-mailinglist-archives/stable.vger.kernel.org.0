Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7763D4DA901
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 04:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245499AbiCPDtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 23:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353447AbiCPDtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 23:49:07 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F70262D;
        Tue, 15 Mar 2022 20:47:53 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id h10so1373351oia.4;
        Tue, 15 Mar 2022 20:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PEfk5ZCw1gvfQthm7kb0RoxLz3zm47ykuGeSs5jnx6I=;
        b=HSG7GO50mp8W5FgZV9MsYIWpa+Z2WfR1etjogsmIf9wpK6wV3CL8Zew6wa2q6DrHdK
         ju8tVEdB9pALkQysQlXU5JTAhFJ623UBIzmacZ5EcA9yCWHch0RyLKilZcCdKiXphn8D
         lvSfmKeLIJhffkMCc+G2cGJ1972MUYAY0Mx3fWwtK0ultcytt6NYE8MEdvtE9kEK5CoA
         jVfndsNoSXrEnIJx6IRPzLBXciPhgcEJBLZKsxgejm80CmZcRoIILj0UY3lX9LOk9x6t
         +t5UQoke0OnhySOY/GMeGokZd+FGPp/NpbyAPVn+EiY46pYPpqAjFpyiHDtwPMBvRWTX
         kEDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PEfk5ZCw1gvfQthm7kb0RoxLz3zm47ykuGeSs5jnx6I=;
        b=TusEXnHw4d7evCfep0ME3LIfRRt9l3/2Lez15n6GPA8gyMxJlHP2ubOvG21lLP27tJ
         XlP9s+DeS63KunTXZmnAyz8Xxara0vKtpkBAxhi9LTZdnF7okLmH2VIbcprJP61Pm971
         X4FJl7ev67YP2/ZmtdEd0XqjP8W+RP/iwMo9KihzL7hXJ6PhYrs23Lj4bL+lSNuygB+w
         ypWZ8E+CkON7b3uOBp2VeACHT9GFMeg9YPqMgIKiNGZB3rnK09WGob1fkTSgFOTps4kv
         Sk5L/RZYHkqGdo/VO+UJQXZVlzRaSV4fTTAV9qPDBNsISwWjpC+fmwioeVYaKChmvKIo
         oiYQ==
X-Gm-Message-State: AOAM530lzRRfty26nIOv1nn5hqJotG/nkGeJefDE94QjDHuhxDhihZh2
        1+GxSUZX7XxaHSznMc0e6iKKlW2Ua2PKXh4jGfo=
X-Google-Smtp-Source: ABdhPJzg99M9AK63teBKEJsFUyLwWfNV90oI6GfdhY6zqxkW0xn2DFGNkG68nRcBD+T3EcpCWZ2ZTqYw79g5GaSHJts=
X-Received: by 2002:a05:6808:118e:b0:2d4:6fe7:6bd7 with SMTP id
 j14-20020a056808118e00b002d46fe76bd7mr3250272oil.146.1647402472671; Tue, 15
 Mar 2022 20:47:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220315144521.3810298-1-aisheng.dong@nxp.com>
 <20220315144521.3810298-2-aisheng.dong@nxp.com> <20220315155837.2dcef6eb226ad74e37ca31ca@linux-foundation.org>
In-Reply-To: <20220315155837.2dcef6eb226ad74e37ca31ca@linux-foundation.org>
From:   Dong Aisheng <dongas86@gmail.com>
Date:   Wed, 16 Mar 2022 11:41:37 +0800
Message-ID: <CAA+hA=Ss=YBt-3f=r1BL1NuO7FK56kTf31zWzNjMBkAKQE41Rg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm: cma: fix allocation may fail sometimes
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Dong Aisheng <aisheng.dong@nxp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        shawnguo@kernel.org, linux-imx@nxp.com, m.szyprowski@samsung.com,
        lecopzer.chen@mediatek.com, david@redhat.com, vbabka@suse.cz,
        stable@vger.kernel.org, shijie.qin@nxp.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 16, 2022 at 6:58 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 15 Mar 2022 22:45:20 +0800 Dong Aisheng <aisheng.dong@nxp.com> wrote:
>
> > --- a/mm/cma.c
> > +++ b/mm/cma.c
> >
> > ...
> >
> > @@ -457,6 +458,16 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
> >                               offset);
> >               if (bitmap_no >= bitmap_maxno) {
> >                       spin_unlock_irq(&cma->lock);
> > +                     pr_debug("%s(): alloc fail, retry loop %d\n", __func__, loop++);
> > +                     /*
> > +                      * rescan as others may finish the memory migration
> > +                      * and quit if no available CMA memory found finally
> > +                      */
> > +                     if (start) {
> > +                             schedule();
> > +                             start = 0;
> > +                             continue;
> > +                     }
> >                       break;
>
> The schedule() is problematic. For a start, we'd normally use
> cond_resched() here, so we avoid calling the more expensive schedule()
> if we know it won't perform any action.
>
> But cond_resched() is problematic if this thread has realtime
> scheduling policy and the process we're waiting on does not.  One way
> to address that is to use an unconditional msleep(1), but that's still
> just a hack.
>

I think we can simply drop schedule() here during the second round of retry
as the estimated delay may not be really needed.

Do you think that's ok?

> A much cleaner solution is to use appropriate locking so that various
> threads run this code in order, without messing each other up.
>
> And it looks like the way to do that is to simply revert the commit
> which caused this regression, a4efc174b382 ("mm/cma.c: remove redundant
> cma_mutex lock")?

Yes, agree it could be a backup solution if not better ideas.

Regards
Aisheng
