Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0D57BD17
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbfGaJ1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:27:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44301 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbfGaJ1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 05:27:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so68834040wrf.11;
        Wed, 31 Jul 2019 02:27:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EGM5RKDve8/AJbKDylbWZIikdzuX+zEV16LFhW7u4Ok=;
        b=JENqiz9OBD+afpN0kpc5rEgo8xfGE/dhb+/OW82KY3olCKzgzUWt1SyBXdTVqc+vtY
         nA61KOD29bO52ZTQK0ZEI3EZvqdNcdwZWZb/b5nyLOIgJyAHpriptBPJWne79zqw6yCx
         FSO8CjpLkja/nlgItQ0CjtfJX5QePx3GaUbTGUbwuDkWp/TCfOhNsEy1EMZEdKk6rPMu
         pnC6SgdO7S+T7U1M2iROS0qAbNdvsN4bF4LaNA9HNt88p65qjLHCIHp/v6lRP1/xtQJN
         Wn7Dq4V9kKxd7UZeAvaQvNiIllmjqKAaJJib266b5cqaBpNH1L52eNFs9TifbLeVIgVz
         MWHA==
X-Gm-Message-State: APjAAAW/WIcPPesnr1ArK7FBMbqd8ZcarpXBd7ib/cWoGYwxdOq0l0M3
        NxMeZJWhwFH7FzYsDss1kqMfAvZElechUWSX8TpMoA==
X-Google-Smtp-Source: APXvYqw9c9Q5GKDpsqV7MciNU/urisuCE7B3KXVQAFDBcKvBOEM0oVW1SwoqNTvYlQZ5w9O4vw30XmIutx+pqJr8X3M=
X-Received: by 2002:a5d:630c:: with SMTP id i12mr45644695wru.312.1564565234591;
 Wed, 31 Jul 2019 02:27:14 -0700 (PDT)
MIME-Version: 1.0
References: <1564563689-25863-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <1564563689-25863-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 31 Jul 2019 11:27:02 +0200
Message-ID: <CAMuHMdWhA2xxKKEmmobZDDKGnWNfO4xDb6m6gM16CCFX-1UyTQ@mail.gmail.com>
Subject: Re: [PATCH] phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Pavel Machek <pavel@denx.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shimoda-san,

On Wed, Jul 31, 2019 at 11:04 AM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> Since the role_store() uses strncmp(), it's possible to refer
> out-of-memory if the sysfs data size is smaller than strlen("host").
> This patch fixes it by using sysfs_streq() instead of strncmp().
>
> Reported-by: Pavel Machek <pavel@denx.de>
> Fixes: 9bb86777fb71 ("phy: rcar-gen3-usb2: add sysfs for usb role swap")
> Cc: <stable@vger.kernel.org> # v4.10+
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

> ---
>  Just a record. The role_store() doesn't need to check the count because
>  the sysfs_streq() checks the first argument is NULL or not.

Is that wat you mean? sysfs_streq() doesn't seem to check for NULL pointers.

Isn't the real reason that sysfs (kernfs) guarantees that the passed buffer
is NUL-terminated?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
