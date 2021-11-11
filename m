Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4E944DA44
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 17:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbhKKQYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 11:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbhKKQYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 11:24:11 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137A3C061766;
        Thu, 11 Nov 2021 08:21:22 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id m9so7678096iop.0;
        Thu, 11 Nov 2021 08:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hBm6JO/iSJ+GL1C6xVW5PCmaMsD9ZfQqODjs2YkP1sU=;
        b=YV71s0Ev2mXVcz6tWXyGZUsZLzfLGIkp3ELcfIJgPv2VpPq/w5tgNgNrqw+LhKSK60
         ypAN/jXd2U6uHeSo6EKYM/zbuOJjvXF2o1EfAmhIYDnO4J2yvU2nNH4jhsF/rPgVr3bb
         PA4/javfSdpJOvTjk44LNTGCIrwi2A5vk0Uny5Zc8EjPCM3Wp8yaJaeS7h9ev/9shMri
         Y2aFBgo5K4oI03r0IdC4eQANOTblYgjhhh3f8yAxn3sUQHc7z6YHPMh8IvmNLzhD7nQc
         iP4dlZyUtwFS6qHzAjhd+KnNGwdCOGRRlmSuuTRYwgG6vQzI7je8tn/bPRGwHXLJDZUH
         GabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hBm6JO/iSJ+GL1C6xVW5PCmaMsD9ZfQqODjs2YkP1sU=;
        b=SarYalpw53/tK9IJkrSCNpMBj11LmTgwa6wmqR5HwTI0VBRr6D0jJCzZstX/+YJYNC
         KBi6yHloW1K0Idgaj+hXuMnR2ecVaVCwxknBompUSGJDO1jXf4vnIYVzyNZiXaOItn6/
         Etl7EEJdcS1YweBtfyJ4XumJTmrd3mLhdrnlXEOUHaYeTuzZAsNe/RYybpFN9pBIX1HT
         D3e2CNbl0hNfwBDDXHWqzS8qtSXPtCuO3Bq7yn5LbONwkDcT587baYVWYM9yZC+o8FMv
         C+rZ6gYOQP1vK6iif7eWCyYGVmBlUG4w7aiTb4HhwiY6J41mb1n8yNQ6Krof6cnHrNUM
         j9Mw==
X-Gm-Message-State: AOAM533j7Ya6DY7pA9xPOGxOxX3pU1e1q+ANgUbg4BTPT620QE4PB0Yz
        GbUK2h5jEzIsRlNUwsh4ivJumBrlL1MIQj+8aaE=
X-Google-Smtp-Source: ABdhPJxkBdvyWNsHljIwNTdiGRWG08lJpu3tGVUukky9muJYg0YaC5jYHTIk/gC7oo7gaQB5/SOPVDm2YXZLXvzSMe8=
X-Received: by 2002:a05:6602:45d:: with SMTP id e29mr5752619iov.202.1636647681387;
 Thu, 11 Nov 2021 08:21:21 -0800 (PST)
MIME-Version: 1.0
References: <20211110113842.517426-1-agruenba@redhat.com> <20211110125527.GA25465@lst.de>
 <CAHc6FU49TnYvrL-FU5oz9th6STuQ=eYokjsD+0QpbkdHedRd9w@mail.gmail.com> <20211111072506.GB30478@lst.de>
In-Reply-To: <20211111072506.GB30478@lst.de>
From:   =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date:   Thu, 11 Nov 2021 17:21:10 +0100
Message-ID: <CAHpGcM+GVufLn_VZD_Kmrj=Y-XQwkqcjFxN4aFajh1Loi324ow@mail.gmail.com>
Subject: Re: [5.15 REGRESSION] iomap: Fix inline extent handling in iomap_readpage
To:     Christoph Hellwig <hch@lst.de>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Do., 11. Nov. 2021 um 08:26 Uhr schrieb Christoph Hellwig <hch@lst.de>:
> The iomap mapping sizes are read-only to iomap for a good reason.  You
> can't just break that design.

Right. We can stop iomap_iter by returning 0 now though; see v2.

Thanks,
Andreas
