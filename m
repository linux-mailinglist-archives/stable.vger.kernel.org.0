Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEF32A09EB
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 16:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgJ3Pec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 11:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgJ3Pec (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 11:34:32 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2BDC0613CF
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 08:34:31 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id a9so8420968lfc.7
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 08:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qM4J1yE0KLU5F8QyG5kC5LlHB8ZdM2OXBQyKY4bPPG8=;
        b=otXOfEzK9W1IRzhLagM/rOl8Uox3QAsxNGcfJAriK5e9tbtG8dc5a97zPIBkUI5Xig
         d97j65dDcgUwo3rKIqTYxsDkZWFzZUHNxA2oKqfWGwj8823L9kFyCk0O122Ap8/wav3A
         nEhC/bGx+3GVxOYUgUQZwm4gAeYcoBfijlLy8nJeAcs0ORg9gd4SHFzlXh0FIh5hJf8B
         Ao6+xSGXgD02/KDktagUMb8Iy8fJQ88VIfgAgmDupjd+ibLo8Ul6yBqIHyfqP1QTiTer
         Cy/BCYaQNnspe24MnE9YtkTcLQoNPTb/3ZdTY5zrBNJLm4Xm9Gx1cwmfQF5SN9oeNLQc
         gV3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qM4J1yE0KLU5F8QyG5kC5LlHB8ZdM2OXBQyKY4bPPG8=;
        b=fbUiBp14QtOMoHc4t7z+yrX5q9Jw6Uhtyr8BHODgpl3hilbaJByWLp0tGIMY9Bet20
         FofI9Zv2q2raB2HOdWMH1T/Uhfr7VLN50rKxcK1o/tMxiTbL9jOaPdWqo7tfV9FHYLw7
         M7aaeGfUaRfUMpnrgGomVzrPC1kaupj2ibeu+SxRZTqfLeqp6NduH5URmyC89M7vXYU7
         WXZ4bRFwMqvlMefvbOYs0/AdcyJRUHp06gOGO6o/W5WPOP7oU7j5QQIsptCLW1eSpSn5
         UVyU1qLRVjyk6qkwcLwypnUg5HtNvymiDec3VZRIReNNiAzILCzckgqWCjx8vaxQWgpB
         mPUA==
X-Gm-Message-State: AOAM533BojG9jOAgpIj8EhVWx6GjKk9AcYdL+PNZiuff3prAtsA9sheR
        7rIE6l/Ky5Zs+zybr3aLKE0zpDhd4XT047DbvDXMhg==
X-Google-Smtp-Source: ABdhPJyaMAJuSEdSdPOxRQ0zpZINDQPMrZyIuDAHHetn/wlXXtmKXFXcF4mKtRhuohWCHb+fSMLV8uyxyp10TGkPbCE=
X-Received: by 2002:a05:6512:51a:: with SMTP id o26mr1119962lfb.381.1604072070166;
 Fri, 30 Oct 2020 08:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20201030123849.770769-1-mic@digikod.net> <20201030123849.770769-3-mic@digikod.net>
In-Reply-To: <20201030123849.770769-3-mic@digikod.net>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 30 Oct 2020 16:34:03 +0100
Message-ID: <CAG48ez3nBq7_LN6KeY1hdM5T1F+mAm8b_Yg2oY9npxG77ZcvJw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] seccomp: Set PF_SUPERPRIV when checking capability
To:     =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Will Drewry <wad@chromium.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 30, 2020 at 1:39 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> Replace the use of security_capable(current_cred(), ...) with
> ns_capable_noaudit() which set PF_SUPERPRIV.
>
> Since commit 98f368e9e263 ("kernel: Add noaudit variant of
> ns_capable()"), a new ns_capable_noaudit() helper is available.  Let's
> use it!
>
> Cc: Jann Horn <jannh@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
> Cc: Will Drewry <wad@chromium.org>
> Cc: stable@vger.kernel.org
> Fixes: e2cfabdfd075 ("seccomp: add system call filtering using BPF")
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>

Reviewed-by: Jann Horn <jannh@google.com>
