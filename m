Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3220F3469D0
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 21:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhCWU3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 16:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbhCWU2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 16:28:51 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9A1C061574
        for <stable@vger.kernel.org>; Tue, 23 Mar 2021 13:28:51 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id g8so21465098lfv.12
        for <stable@vger.kernel.org>; Tue, 23 Mar 2021 13:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1mJxXlJLpF04ktu0Td/MXe7AhNpm2832ClSG5vRPtkQ=;
        b=g14x6sHmde8J0uY1U3oJCCjEgEIi4Wfjc4hlvckQ9Y7hMPL3hUA0WflQVlbbc/fD87
         2mdAvJNmOCibE4HxV1z+VFo0r1yBv7jpMSRJl24WKPQwaPNsqkmvkqWPhnB13+WP0L8q
         0w0J1hOyd7n0Y7RvT0o4KG+hC+FOec0swWO+Mv/jSfPmbGCx2d8ohMXGbjockdbWwyZD
         HWgBLTPnvvN/4OKur/ilYV8k9nGyNbiPA/OO1Wjj/HVJEzjgPFl0EWYgJ1Jghy7m6zqa
         ZJLy//zRufxgTJftW9eGq+nM+Tpj+3Nb9CLSJ7ZqEX6MKgwcAUkIRFiwXay7RzPFxcJY
         yr6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1mJxXlJLpF04ktu0Td/MXe7AhNpm2832ClSG5vRPtkQ=;
        b=OGjuc8zaPuAORSCVus+7Qt3tsuH4lADtkiWYsBt3x18ib3yzEF6WZBq4nXVHiZBixG
         x0SAv4Y9n4giJMU3eh7P6Ia4f+HmKekXC8BwEV/iLFfd4C31DvptDrLzqImvoLsbaHWm
         2MSOp4V3itQe/QWilCFWpqVGrr5aOFWS4mou/UxYgTJTgRIaz5Dmk57yqEYYg04KDioT
         Ht3ZcTx5Wj8I0iygDPJYlw0Vtt2NzU+I2WFfDUVX/cSsZJd1sIMAsnPiaie0tFKyls42
         mhY7E/SFAkrDCgH1RIM8R/3hW7ifU6z0GWEzIUMdl2T4tMATwT9bBhJtK8IpcTkJa5Mv
         m9Cw==
X-Gm-Message-State: AOAM531gMRFTmXF3lz+cEXfbtxy+vw6Zwwpv4zsVEqlrdCgYQRUzrZt0
        wa5o2P+giwMqk3mmK04VRUJcnxAobF4UNcH1d6OX8w==
X-Google-Smtp-Source: ABdhPJxAIjxZyedPPhNLxAmmnwaQEK1JeosnTw6S70cLKAOWYHjeSxqBaG86+vQnbMjH/mn4kS4ZkIe07b7p2mInPmQ=
X-Received: by 2002:ac2:538e:: with SMTP id g14mr3441936lfh.543.1616531329644;
 Tue, 23 Mar 2021 13:28:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210316213136.1866983-1-ndesaulniers@google.com>
 <YFnyHaVyvgYl/qWg@kroah.com> <CAKwvOd=9HwLcTD8GaMsbEWiTPfZ+fj=vgFOefqBxDYkFiv_6YQ@mail.gmail.com>
 <YFo78StZ6Tq82hHJ@kroah.com>
In-Reply-To: <YFo78StZ6Tq82hHJ@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 23 Mar 2021 13:28:38 -0700
Message-ID: <CAKwvOdmL4cF7ConV8841BX+Pey571KDWM8CBt8NnYY47vJ_Gfg@mail.gmail.com>
Subject: Re: [PATCH] scripts: stable: add script to validate backports
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 23, 2021 at 12:05 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> The only time git gets involved is when we do a -rc release or when we
> do a "real" release, and then we use 'git quiltimport' on the whole
> stack.
>
> Here's a script that I use (much too slow, I know), for checking this
> type of thing and I try to remember to run it before every cycle of -rc
> releases:
>         https://github.com/gregkh/commit_tree/blob/master/find_fixes_in_queue
>
> It's a hack, and picks up more things than is really needed, but I would
> rather it error on that side than the other.

Yes, my script is similar.  Looks like yours also runs on a git tree.

I noticed that id_fixed_in runs `git grep -l --threads=3 <sha>` to
find fixes; that's neat, I didn't know about `--threads=`.  I tried it
with ae46578b963f manually:

$ git grep -l --threads=3 ae46578b963f
$

Should it have found a7889c6320b9 and 773e0c402534?  Perhaps `git log
--grep=<sha>` should be used instead?  I thought `git grep` only greps
files in the archive, not commit history?
-- 
Thanks,
~Nick Desaulniers
