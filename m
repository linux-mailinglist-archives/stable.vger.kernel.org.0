Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515754A3152
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 19:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241700AbiA2SXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 13:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbiA2SXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 13:23:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558ECC061714;
        Sat, 29 Jan 2022 10:23:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1A1DB8280F;
        Sat, 29 Jan 2022 18:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1225AC340E5;
        Sat, 29 Jan 2022 18:23:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="dTanMXJP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1643480583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X/Lx7neWJZLtKH8EwEWLZr1/h9vJrv7+5peMou7nwgY=;
        b=dTanMXJP9MvbBdmzHtRx6IH6fjViyLLSc07ZQHC2ETRzsNjpidnJTN/ISBSGpdWS+MPx+a
        7kul3oq9M08zU5jd5JaiRJWhWPXb+Cepm3TuFY7mtnCvbIV/3hL7l/HecRN9q6nyWClW48
        cN5Nd95UgsWbvyIIM3Sa9kCJQ/nsTsc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 17a72866 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 29 Jan 2022 18:23:02 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id k17so28067845ybk.6;
        Sat, 29 Jan 2022 10:23:02 -0800 (PST)
X-Gm-Message-State: AOAM533O+Y42D5s+ReHGCK+hKY6jq9qYoCKcEYwkRfAldI5fA1ymxbj4
        g5Xq3ICrFzVswDzNDCOu8BK5upjktUjZ7bTsM7U=
X-Google-Smtp-Source: ABdhPJzTutGWoKx8b6WfvB/LV4fBK5SPfWA4/hwRJ5c8SZzOAXT/C8ipn/YW681KFz5Gc3tqpZo8BGBgFLbi5aOqm3M=
X-Received: by 2002:a25:ace0:: with SMTP id x32mr21245069ybd.255.1643480580389;
 Sat, 29 Jan 2022 10:23:00 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9pb9A4SN6TTjNvvxKqw1L3gXVOX7KKihfEH4AgKGNGZ2A@mail.gmail.com>
 <20220128153344.34211-1-Jason@zx2c4.com> <YfQwUvyZL05MtEA4@latitude>
In-Reply-To: <YfQwUvyZL05MtEA4@latitude>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 29 Jan 2022 19:22:49 +0100
X-Gmail-Original-Message-ID: <CAHmME9pVbbj-=bU8yU=-X8_bG0D97jAqR2Pi+77P0yrOp-AK4w@mail.gmail.com>
Message-ID: <CAHmME9pVbbj-=bU8yU=-X8_bG0D97jAqR2Pi+77P0yrOp-AK4w@mail.gmail.com>
Subject: Re: [PATCH] random: remove batched entropy locking
To:     =?UTF-8?Q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Jonathan,

On Fri, Jan 28, 2022 at 7:05 PM Jonathan Neusch=C3=A4fer
<j.neuschaefer@gmx.net> wrote:
> FWIW, this does fix the splat on my machine.
>
> Tested-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>

Thanks for testing. If it's not too much trouble, would you verify v2
as well? It's substantially different from v1 that it doesn't seem
right to carry through your Tested-by, and from talking a bit with
Andy, I think we're more likely to go with a v2-like approach than a
v1-like one.

Jason
