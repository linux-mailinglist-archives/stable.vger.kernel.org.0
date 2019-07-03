Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63DEF5DA05
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 02:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfGCA7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 20:59:16 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:33799 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbfGCA7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 20:59:16 -0400
Received: by mail-yw1-f66.google.com with SMTP id q128so359247ywc.1
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 17:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wIf3s/qpqMqc2ju4HSpCa9loV1PYd9khtmiRlahKfMw=;
        b=pPp129mGMAgZmQQqFW2wfGEyipUebLHwGsceAtgrBF3rmcputVE6yLkvSQzI5+Umpe
         ozwXEefLssoK6is8zIDlkwY/8KxjUGg4mFuSKbFB26uy43eFMyRjUtyFLV2PXbRIXp4S
         nXHtGaazQ+NoOvr/kGLrfL86ynZ5+JPT39vV8UPPVwpByVSniduvE865bw+oh4sDDk8e
         jZ+tHN3OsCR6DZ27o/h80jb8FFe8FqUFoAO21NfwxBXtyuAwby9BaxyIDkmG6v6CBDrB
         xMZdvZ8g4jOQzQlCof9FvROv5TZ+hPQySu6YgAIUvgtORBagVLpLL4A6t2rIK8irYDYe
         USHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wIf3s/qpqMqc2ju4HSpCa9loV1PYd9khtmiRlahKfMw=;
        b=GqxVXdZdKeSz4HOxa63hZQhC7ZqucMM3CvWTvT2XHZfk9lwHzEfGidqc2ExE3re0p2
         ZTtBjJmoz35hwbIuYTjgn2sFAiJ+/OPrRE6rb4OC5xswAQrb7UF8L5duVl8U52jxxpPi
         Z6cckQOKvKSIyEmEty0rc/gteJhZXvxwvYlQO7dKH+xLWv5pYz+3cHJRfVb3VPcfyg4a
         xw6ZP5etQulrkfp0f838EK7X0PQqOXBP74y3KkWqHKnsQKDY88QzqtqTJHd06L+mrPrY
         lUFSGDCudlQcvT10XCkdS1xd6M4S0sgc0VV6vnmDro+piQTzq7mewoL4oICWzorT6w7C
         hvqQ==
X-Gm-Message-State: APjAAAXjpdUyxmmPDqXjzLPVs7C9O4Y4QAN6r9i97u3yiqEWuABtLa1b
        ZsqdUJxtFiGbY77eRgIDJ+4z0sZMkOGsrcvcpiJAqw==
X-Google-Smtp-Source: APXvYqxK5DEkk2kHSda+WF/FAeUHPkw6wKzo7ZmZsBWNCRYS9CdUUUng7zhdFAAYidX2Li7ETs1OA9wyePtHHTyX7VI=
X-Received: by 2002:a81:ae5d:: with SMTP id g29mr19968749ywk.398.1562115554994;
 Tue, 02 Jul 2019 17:59:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190702233538.52793-1-henryburns@google.com>
In-Reply-To: <20190702233538.52793-1-henryburns@google.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Tue, 2 Jul 2019 17:59:03 -0700
Message-ID: <CALvZod7udORRrz7wzQPRa2Eya5TfrVh9kG037GKsAsSkRJPx7Q@mail.gmail.com>
Subject: Re: [PATCH v3] mm/z3fold.c: Lock z3fold page before __SetPageMovable()
To:     Henry Burns <henryburns@google.com>
Cc:     Vitaly Wool <vitalywool@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vitaly Vul <vitaly.vul@sony.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Xidong Wang <wangxidong_97@163.com>,
        Jonathan Adams <jwadams@google.com>,
        Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 2, 2019 at 4:35 PM Henry Burns <henryburns@google.com> wrote:
>
> Following zsmalloc.c's example we call trylock_page() and unlock_page().
> Also make z3fold_page_migrate() assert that newpage is passed in locked,
> as per the documentation.
>
> Link: http://lkml.kernel.org/r/20190702005122.41036-1-henryburns@google.com
> Signed-off-by: Henry Burns <henryburns@google.com>
> Suggested-by: Vitaly Wool <vitalywool@gmail.com>
> Acked-by: Vitaly Wool <vitalywool@gmail.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Vitaly Vul <vitaly.vul@sony.com>
> Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
> Cc: Xidong Wang <wangxidong_97@163.com>
> Cc: Jonathan Adams <jwadams@google.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

We need a "Fixes" tag.

Reviewed-by: Shakeel Butt <shakeelb@google.com>
