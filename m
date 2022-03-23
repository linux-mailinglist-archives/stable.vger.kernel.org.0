Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E63E4E4ABA
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 03:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239850AbiCWCJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 22:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiCWCJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 22:09:57 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F1F22519
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 19:08:27 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id g24so66257lja.7
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 19:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J8R5fIKIW6T8IIqFMnxqRAyAbWLACxuZ0qCUQR/pgGY=;
        b=Eq6BQka4f8LYxS/Tno67bSzUoi2mPqlP+glM7TxOjfAPhoCdKuboSnQmWForCK/G5Q
         uvSWbW9LGbfwRAbIk2bphRZ9Qq8tpiA45DZWZTzPG6mPJUagHr2/7r5uPM6LolhND+kx
         ws/mB3u/w9v98tgrtujz3csM3dx0hX8Bmi0fQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J8R5fIKIW6T8IIqFMnxqRAyAbWLACxuZ0qCUQR/pgGY=;
        b=UQGsvEQ4AONjSSAadwl38YoeA+fpWF308j+ZxZzjbHIiUvup0kY4+Udgc7fWyKstPZ
         tlz2mIOrR8U7QdpmwGTTR5cLze1Db4im0jlV56ekY17K4HSBJ6eKs8Fo0yu/z53fT/GG
         mZj1aTIZFD3sckpy5QwxGl8mkVez3EFXhsPwUHocOeE3TNq0g3vZc8WQjq02+QQGP/pd
         9/0ybLOGdO5LyUbEYfpBvOqBGVT0NQeVzwQAtMdiwigHSY/28jniyBWA1EkjF80c6IYP
         IfNGRxLOeSmVW3xvHSOGGBXb0eINWmJ05LViQUR4K3YSfeapYjwlq8DfhUxwyyUC2X6v
         S39g==
X-Gm-Message-State: AOAM532xUENnDQAWzZ1JIiCH3/hROag0FLFeGVSxSyEUkteur2XJ3oKh
        NyZAlmU84eOGikGzDXaWE2+sOvaQGL/xoMwkOpw=
X-Google-Smtp-Source: ABdhPJwW+D3ycda8vHTCJTzoue641hVBfJx7PCqmBL+QpEc3EuhlvzvFxhqqeBmJzSjK171OZbO0Pw==
X-Received: by 2002:a2e:145e:0:b0:249:7feb:58bd with SMTP id 30-20020a2e145e000000b002497feb58bdmr11619959lju.449.1648001305935;
        Tue, 22 Mar 2022 19:08:25 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id a10-20020a19e30a000000b00448ed99d745sm2241526lfh.90.2022.03.22.19.08.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 19:08:25 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id h11so86128ljb.2
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 19:08:24 -0700 (PDT)
X-Received: by 2002:a2e:9794:0:b0:249:8488:7dbd with SMTP id
 y20-20020a2e9794000000b0024984887dbdmr9591965lji.176.1648001304369; Tue, 22
 Mar 2022 19:08:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
 <20220322214648.AB7A1C340EC@smtp.kernel.org> <Yjpo2jnp5pkJr+XI@google.com>
In-Reply-To: <Yjpo2jnp5pkJr+XI@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 22 Mar 2022 19:08:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiLMM1QJfmosoY3+Ah79_Oga8=EzUZnR8AoTRBUZGSfoA@mail.gmail.com>
Message-ID: <CAHk-=wiLMM1QJfmosoY3+Ah79_Oga8=EzUZnR8AoTRBUZGSfoA@mail.gmail.com>
Subject: Re: [patch 163/227] mm: madvise: skip unmapped vma holes passed to process_madvise
To:     Minchan Kim <minchan@kernel.org>,
        Charan Teja Kalla <quic_charante@quicinc.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>,
        stable <stable@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Rientjes <rientjes@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Michal Hocko <mhocko@suse.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 22, 2022 at 5:25 PM Minchan Kim <minchan@kernel.org> wrote:
>
> I thought it was still under discussion and Charan will post next
> version along with previous patch
> "mm: madvise: return correct bytes advised with process_madvise"
>
> https://lore.kernel.org/linux-mm/7207b2f5-6b3e-aea4-aa1b-9c6d849abe34@quicinc.com/

Hmm. It's merged now, as commit 08095d6310a7.

So any fixes please do it on top of that existing state ;(

            Linus
