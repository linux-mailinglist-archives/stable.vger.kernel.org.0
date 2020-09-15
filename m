Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D44D26ABF6
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 20:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgIOSb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 14:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727972AbgIOSOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 14:14:23 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C7DC06178B
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 11:14:06 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l191so2413080pgd.5
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 11:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AT0mHORaxDdMUqWTyM6bXKGpvP94IwQFIcwyyHppM00=;
        b=oVqB6rH1ygmPOlbcsDJp6t662dBAL0svgY6P3cB7gO5IGclx2mJ+Z6xGpYEV4vEQPr
         LX2mUDMFXjOVeISFJ7TPgUVOht+9qtshJd/mT0A7SdFPO7Z6w1R+FqWQkrhwN2gBPQTw
         /rdvct36NLscqnrIcjwf0sw6JpQUXCtnSTGzNpExiH3WGrHQQqKdoul+9UFlmt7bXIa5
         xkPzSduP739AjHnT2BQ38h0ikswSlVjsKQB4xhBfntXqYk34YcnVMT+gjUvWtXwCuwMj
         0wGytZo5pm5njm9KhvpTLAgP2CsTXj0ZsZCwdBnQMDrVEcmmQu1bz2VyikB87JcU9cIK
         ZqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AT0mHORaxDdMUqWTyM6bXKGpvP94IwQFIcwyyHppM00=;
        b=oMPF2QB79T/o8lMGp33T5cTB3h1Ma7QOslXrz3DYwXbqyQtMYpkX8E7v1WW6O1Drii
         D91N9UetvROZVN5qLVO0r+xFz/cMK4qlS6BROdzQVONALaP+oBuVy/ICHLmw+DWo0P8I
         aXBKwHy9nRxumBoBf3eOHBfUa74UoUdIIZ3xJr4OOeaLX0TPBw2WGZU+cSukO8kBs0lk
         kfsOz2HBpkVUHI7I1J4ZmwS7BKOtwFNrFeGnSsFHseICKhC+zcLldxLdy/YNwEUrgOSe
         /U3otKVU31F5euIntx7wNsCN7J5zAwuMH9w74oz0kRQWvHKGs2CCus41+BsaF5stgoGZ
         AA8g==
X-Gm-Message-State: AOAM531He6oSgpHpAdorIi91s+0mFxVw5GJZ7wNLvHNClr9yfzs02Ppu
        /3YaURatEh1tDrKnwjTJN4gjBWsGqvW1ziXUHqWYSg==
X-Google-Smtp-Source: ABdhPJxoYdf1sOG5PfqHKd6wvML9dc6l14Gv1d+/SBAyITIcWM+XQeuVX/wpBYCd2oG0inFIsnktJSMCGDsZtIFVRZY=
X-Received: by 2002:a63:31d2:: with SMTP id x201mr16100266pgx.263.1600193645755;
 Tue, 15 Sep 2020 11:14:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200914160958.889694-1-ndesaulniers@google.com>
 <20200914161643.938408-1-ndesaulniers@google.com> <20200915042233.GA816510@ubuntu-n2-xlarge-x86>
In-Reply-To: <20200915042233.GA816510@ubuntu-n2-xlarge-x86>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 15 Sep 2020 11:13:54 -0700
Message-ID: <CAKwvOdkg6MNBDfEH_A8=HRstAWFA+OcLkMkHsOLjuvSOWF9dxQ@mail.gmail.com>
Subject: Re: [PATCH v5] lib/string.c: implement stpcpy
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Masahiro Yamada <masahiroy@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andy Lavr <andy.lavr@gmail.com>, Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 14, 2020 at 9:22 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> It would be nice to get this into mainline sooner rather than later so
> that it can start filtering into the stable trees. ToT LLVM builds have
> been broken for a month now.

Hi Andrew, I appreciate your help getting this submitted to mainline.

Noting that other folks are hitting this frequently:
https://lore.kernel.org/lkml/CAKwvOdkh=bZE6uY8zk_QePq5B3fY1ue9VjEguJ_cQi4CtZ4xgw@mail.gmail.com/

CrOS folks are already shipping v3 downstream since this is blocking
the release of their toolchain.

(Also, I appreciate folks' thoughts on the comments in the patch, but
please stop delaying this patch from hitting mainline.  You can
rewrite the commit message to whatever you want, delete it for all I
care, please for god's sake please unbreak the build first).
-- 
Thanks,
~Nick Desaulniers
