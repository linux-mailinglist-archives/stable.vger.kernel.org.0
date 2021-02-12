Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9F1319F58
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 14:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhBLM7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 07:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbhBLM6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 07:58:52 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BC7C061574;
        Fri, 12 Feb 2021 04:58:11 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id a11so4007045vsm.7;
        Fri, 12 Feb 2021 04:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z12PhhCoyKbGlotTE60lQTToSx/Gs5QgkUPZavQ8JyM=;
        b=WakuNUrLlqX3/pBx8Z5QWInFd2yPiItuIQv0HfK2RuT6FZ9GV1Q9EesYKehz/9zq1u
         0i0yYGb1RCCwH546iOAiodn/t4q/0NkGapIQt7gnyZh02Ne55TgDkxsWlqq8CTP7s3wH
         Y1jKc3TFbigc+4YZ9EuPwZDO+NA9XsJ7bGDB+lz/vBkm0pXIPcY5J7i4FOEyC/4aSRmX
         tYDbM+tQZ42kmiykaxMwTzg/KXgn7XJJ/gCtC/pIJNDopm9nxhKRUNxIdar8a595ou4B
         MCpj3dHuI7QKp0t2WwOnEJOhQQKGIatIobHB8tUp4ZBC2f4x43D+9V/LSZOVcB1b51Qn
         Y6Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z12PhhCoyKbGlotTE60lQTToSx/Gs5QgkUPZavQ8JyM=;
        b=EA55BL0ahihrfWwwxdoUSQfvjoIFjf3K5haMD6F3OKQjawyguqV7TuGmK/89WfM4JX
         bgFPI4dKavm0JSY9z30TrcfII7151ZpQpadfWF3O9NkfWlTW5vOuHwS+Awzw7jh0yBxy
         Ob4B9WHIgdbcMVWjHG8z5ZXPWRL6ctShflPPQ5I7MaGpC9SN4PA2DFXA/cnle5Rx7ybj
         13Pn/NVv3RAxJRgTxPOvbNfGZZhATenylpf6ywe2phGJxDGqGLCBmxlEijqZhSRyN9RE
         k6zGFcczyEV3UJTA0ujIB9G2TGi959Aeg+2rseCCAKA0DXWdM5h9Li0vmMIbKcxoEN+g
         X4lw==
X-Gm-Message-State: AOAM533NBZUzLjvBfdYWzZUKchtA9TDhdK1dam2VDxXVNfTndZdooyX3
        VHW0uY8sBbllhv73d2ikN6cI/BUuHg9o8hruhaM=
X-Google-Smtp-Source: ABdhPJz3FJd2niEkts/x/fUwfjf6jSSgG5LfMcil8AoCJ8Ae9QFcx8LfcFbVGYiker6htZZ0mPPuDZXC92wGm/H7das=
X-Received: by 2002:a67:882:: with SMTP id 124mr998667vsi.33.1613134690545;
 Fri, 12 Feb 2021 04:58:10 -0800 (PST)
MIME-Version: 1.0
References: <20210205163752.11932-1-chris@chris-wilson.co.uk> <20210205220012.1983-1-chris@chris-wilson.co.uk>
In-Reply-To: <20210205220012.1983-1-chris@chris-wilson.co.uk>
From:   Emil Velikov <emil.l.velikov@gmail.com>
Date:   Fri, 12 Feb 2021 12:57:59 +0000
Message-ID: <CACvgo52u1ASWXOuWuDwoXvbZhoq+RHn_GTxD5y9k+kO_dzmT7w@mail.gmail.com>
Subject: Re: [PATCH v3] kcmp: Support selection of SYS_kcmp without CHECKPOINT_RESTORE
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "# 3.13+" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 5 Feb 2021 at 22:01, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> Userspace has discovered the functionality offered by SYS_kcmp and has
> started to depend upon it. In particular, Mesa uses SYS_kcmp for
> os_same_file_description() in order to identify when two fd (e.g. device
> or dmabuf)

As you rightfully point out, SYS_kcmp is a bit of a two edged sword.
While you mention the CONFIG issue, there is also a portability aspect
(mesa runs on more than just linux) and as well as sandbox filtering
of the extra syscall.

Last time I looked, the latter was still an issue and mesa was using
SYS_kcmp to compare device node fds.
A far shorter and more portable solution is possible, so let me
prepare a Mesa patch.

-Emil
