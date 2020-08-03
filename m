Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6B123AB78
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 19:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgHCRRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 13:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgHCRRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 13:17:08 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58D3C06174A
        for <stable@vger.kernel.org>; Mon,  3 Aug 2020 10:17:08 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id o1so21108033plk.1
        for <stable@vger.kernel.org>; Mon, 03 Aug 2020 10:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5pjqZimihVvvMV/kdQU8FuG/+DQEondXrGpEqByvj50=;
        b=ugUrWVIF7k9NFxcVqvDedjtg7E3uLaFDHTEDjLKMwoQHuAiUhsnK83PDehE0Mo1CuF
         9HqrXJUrdnvjW9hhwVYr/+egYcG+rBBa9kwQLfTiLpObGSpQFbuo12v/eZrhusmTCBBU
         T7SsYxRqBQd/06dWO1FjJnAyf+XLakHHamyYt6GV0JRSzf45bk4nW33ga9mKv93GkvEF
         Bchm/eixG6xdHbEwCC2eA08Tf8X2B7OSTijtgKbk55vj+2rOmDJHkyyRkStHZ2pYe+CF
         t7gsJA7L5EqPMeLSEHtMFV3EkyIDEKJ49bYwGUFn3g1WHGhQiSLIFe16gzBPIOWXCM1J
         auKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5pjqZimihVvvMV/kdQU8FuG/+DQEondXrGpEqByvj50=;
        b=M/bMKhuybQNjXnCyrlCVwp9PLaW2ei2nub2RpWs1uCHcPMGfopAQo8bbLrqITQAc1B
         fIZuqwhCqqN+AVKQoZBrBwvrQAZ1eYPALG2/j2SrVopehcf5LauxjdnI0FdjxK1IgZIc
         Sz3heF+x7OgJlzPK0LT+h2eb5lvLzutbU/p0uyyczbkTr/hCUhwFULQ2KxEvv2zTf41l
         zhaqRk5L5+MggQHs8/LKoEJao+xqZ02cHytRi+JPzmLd3E25hTjhZbjkfpRjiixH8u4o
         vEMaukqT01lYQb2DmFJQjsh4dUPsAc+8b6Xlev+m8h1Ul7+MSzHPf+wvsvqEF0iQUbIb
         RH8A==
X-Gm-Message-State: AOAM5325MUfVyN7TR0jDzYxyL+f/qUOPyhtXCfQVIwfLtM00s5X8Rit1
        qoB2qIN45pw2opf33Zk7TMicguH7Khfqhy+h2L6nF/x7
X-Google-Smtp-Source: ABdhPJyoKIHkORpo3ucpnHB59kiqbgMo/P+fMJ1K/VjN8ql0BK8BFvARNSoRXWl3Ni/rGOs7f4WS7t6o+AcpGeg9V7Y=
X-Received: by 2002:a17:902:cb91:: with SMTP id d17mr15313070ply.223.1596475028108;
 Mon, 03 Aug 2020 10:17:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200731210255.3821452-1-ndesaulniers@google.com> <20200801120213.GA382353@kroah.com>
In-Reply-To: <20200801120213.GA382353@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 3 Aug 2020 10:16:56 -0700
Message-ID: <CAKwvOdmzGh9QyS81Xxz5vSPniYBrzEnTxBdG9B48+z27DEMn2A@mail.gmail.com>
Subject: Re: [PATCH 4.19] wireless: Use offsetof instead of custom macro.
To:     Greg KH <greg@kroah.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Pi-Hsun Shih <pihsun@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 1, 2020 at 5:02 AM Greg KH <greg@kroah.com> wrote:
>
> On Fri, Jul 31, 2020 at 02:02:55PM -0700, Nick Desaulniers wrote:
> > Fix landed in v5.7-rc1. Thanks to James Hsu of MediaTek for the report.
>
> What about 5.4.y?  Why ignore that tree?  You can not have people moving
> from an older stable to a newer stable tree and have regressions :(
>
> I'll queue it up there, but be more careful next time please.

Yes, sorry, my mistake.  I don't know what happened; perhaps I forgot
how to count.
-- 
Thanks,
~Nick Desaulniers
