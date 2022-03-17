Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4B34DBEF7
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 07:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiCQGJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 02:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiCQGI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 02:08:58 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1B413BAD6;
        Wed, 16 Mar 2022 22:45:50 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id z8so8317964ybh.7;
        Wed, 16 Mar 2022 22:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bzUnjGDyXu7q9v4BjGZ982U1CVW2XxSBT1y4mEjRJv0=;
        b=lPqokLZqsCxHE1yHiPzSj38FzKqk0WtvURGh1j2mZGRinC9mx6Br+yZUHETj9FU6EU
         f5tfU/cotSH2mNNo1cog37Kg+5PbkDh6hAHoMDvwCFhLDCvNhsJqjiLkxpjgqpsyR1ks
         /heSfFFcjoT9Y5tkJordX492YJE6kZpUJABWooPMA6LxTsOPWjlVkbmj1ZR+v8QM+pu9
         vKqGMc6gq6v/fbNyRVGlTr2bUiZWyz6PvvVeChYmLUVPBnDaAtbM/yknwctgsNRP1cwO
         i0c72KK//O2pAyxiwoCt19dCIUgBxxIeJ8U3pkcxdQiQPhhzBxmJinC1RBLqbT8Ndvak
         BoaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bzUnjGDyXu7q9v4BjGZ982U1CVW2XxSBT1y4mEjRJv0=;
        b=t9j8jhZb+o2WfowRU0FVu15N7yNdQL34MAEZwAONy8oaGILRh0XOkRKOMU/WMr/8GU
         L+GUlzow98/R3bQirpPf9T/aA0hE017DsBYiFeLydyHGc0jhNt7lVI5LngN8FU1QFbXJ
         JK3YJWlyKM6hZzUZar2iU34MVP7Q19e3z4PYUHQhwwejEblNwMDXXm4NzF6NIZB0/B4g
         yWkExPkBwSuPwB7AvfzRYk5HN97al7zxq9WB8kcg2ExR9oz7fLild/taJsLiWnNlfTlr
         5msQI+l50Wr80NcGVmY/iySioG5bRBM6dRfzSO26AtgSTQ1c2ZIiyxLbZe9tCDN05d0c
         8zhg==
X-Gm-Message-State: AOAM533DOdOSuXN3dyNZW6y1pcmCAozqB+VEwjikYVoAGVKLJFn/ufi0
        FKywnJorj75mSuub66wtM5W/MnqE+859lvH+uVpe9537WSojcw==
X-Google-Smtp-Source: ABdhPJyFB4RAag2Fam31j7R7qBMFYRNd6SNZ1PP5uYDwvdKBwhy3oxZu7RngKvwR2SO67orM0Owagt8qYRoNNH4+YAk=
X-Received: by 2002:a05:6830:1394:b0:5af:6776:ea37 with SMTP id
 d20-20020a056830139400b005af6776ea37mr987418otq.80.1647488968237; Wed, 16 Mar
 2022 20:49:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220315144521.3810298-1-aisheng.dong@nxp.com>
 <20220315144521.3810298-2-aisheng.dong@nxp.com> <20220315155837.2dcef6eb226ad74e37ca31ca@linux-foundation.org>
 <CAA+hA=Ss=YBt-3f=r1BL1NuO7FK56kTf31zWzNjMBkAKQE41Rg@mail.gmail.com> <20220316140904.513fe0e8180b4e3fcad24e3b@linux-foundation.org>
In-Reply-To: <20220316140904.513fe0e8180b4e3fcad24e3b@linux-foundation.org>
From:   Dong Aisheng <dongas86@gmail.com>
Date:   Thu, 17 Mar 2022 11:49:16 +0800
Message-ID: <CAA+hA=QEtxeCZX7K+sW0KUZbErjr9NFMN6ZaidaXCL+1m6=F+w@mail.gmail.com>
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

On Thu, Mar 17, 2022 at 5:09 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 16 Mar 2022 11:41:37 +0800 Dong Aisheng <dongas86@gmail.com> wrote:
>
> > On Wed, Mar 16, 2022 at 6:58 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > On Tue, 15 Mar 2022 22:45:20 +0800 Dong Aisheng <aisheng.dong@nxp.com> wrote:
> > >
> > > > --- a/mm/cma.c
> > > > +++ b/mm/cma.c
> > > >
> > > > ...
> > > >
> > > > @@ -457,6 +458,16 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
> > > >                               offset);
> > > >               if (bitmap_no >= bitmap_maxno) {
> > > >                       spin_unlock_irq(&cma->lock);
> > > > +                     pr_debug("%s(): alloc fail, retry loop %d\n", __func__, loop++);
> > > > +                     /*
> > > > +                      * rescan as others may finish the memory migration
> > > > +                      * and quit if no available CMA memory found finally
> > > > +                      */
> > > > +                     if (start) {
> > > > +                             schedule();
> > > > +                             start = 0;
> > > > +                             continue;
> > > > +                     }
> > > >                       break;
> > >
> > > The schedule() is problematic. For a start, we'd normally use
> > > cond_resched() here, so we avoid calling the more expensive schedule()
> > > if we know it won't perform any action.
> > >
> > > But cond_resched() is problematic if this thread has realtime
> > > scheduling policy and the process we're waiting on does not.  One way
> > > to address that is to use an unconditional msleep(1), but that's still
> > > just a hack.
> > >
> >
> > I think we can simply drop schedule() here during the second round of retry
> > as the estimated delay may not be really needed.
>
> That will simply cause a tight loop, so I'm obviously not understanding
> the proposal.
>

IIUC the original code is already a tight loop, isn't it?
You could also see my observation, thousands of retries, in patch 2.
The logic in this patch is just retry the original loop in case in case there's
a false possive error return.

Or you mean infinite loop? The loop will break out when meet an non EBUSY
error in alloc_contig_range().

BTW, the tight loop situation could be improved a lot by my patch 2.

And after Zi Yan's patchset [1] got merged, the situation could be
further improved by retring in pageblock step.
1. [v7,0/5] Use pageblock_order for cma and alloc_contig_range
alignment. - Patchwork (kernel.org)

So generally i wonder it seems still better than simply revert.
Please fix me if i still missed something.

Regards
Aisheng
