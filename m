Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37EE1803F8
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 04:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389224AbfHCCdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 22:33:19 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:60854 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387722AbfHCCdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 22:33:19 -0400
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id x732XA57031601;
        Sat, 3 Aug 2019 11:33:10 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com x732XA57031601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1564799591;
        bh=BHhBAu7QWb2xgg8DrIs34YNt1WlpJeUMbXoRQmIiFKs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AASPhJdEFAVk3KrdqLWc9wHzhpwTQ2VdKMNe/AK2VEPC8+3ZjAQcaJUnKHQR/bCpy
         WaYpCLPUnhg5NSgXWGyClyDk7F3lA6wcFUrYIasfC7EuIMNRztsY9Xy/Ps6NVPRxQw
         JTR0rdRWtVMaCfsWVXp1HY9UrIWooR9OKdfQ8DnuILA5vIBZEuHOOas6OJfNadQSnw
         C223/5N7z8C31vWDHGRSCc/q+gKrhvIMS+nOBg5+oPWq4mAjI0JEqCcERHa+laxcN4
         1pUQtVTOI1eHNz7/6+ogdjoL78Kx5gDH9LUDeuharRdEcYWQRvNEHwCNmF2WegowTL
         nbgrlsN+4BdBA==
X-Nifty-SrcIP: [209.85.217.42]
Received: by mail-vs1-f42.google.com with SMTP id y16so52507102vsc.3;
        Fri, 02 Aug 2019 19:33:10 -0700 (PDT)
X-Gm-Message-State: APjAAAVMSIW7VCooRqCshAj0tx0SaSIJe3Zwv+m98tQD/jloYHqzyMe0
        AbvXq4rYOCprr2gV+MRhl1hkn0y2cb11lWmQlHc=
X-Google-Smtp-Source: APXvYqwEu3TrUy4h3JwlWMn4zeuAtHGCR1iKyVSCrjhBTcr+yFpkAb583zxrFdNQQlqBmCXGkg4KuRVpcg7KdE8cpUc=
X-Received: by 2002:a67:f495:: with SMTP id o21mr87953213vsn.54.1564799589308;
 Fri, 02 Aug 2019 19:33:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190712060709.20609-1-yamada.masahiro@socionext.com> <20190802195243.09a87651@runbox.com>
In-Reply-To: <20190802195243.09a87651@runbox.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sat, 3 Aug 2019 11:32:33 +0900
X-Gmail-Original-Message-ID: <CAK7LNASPib2GUgjUEwmNYcO9_NgvjyjKSpqwJVZSNhFOJ7Lkfw@mail.gmail.com>
Message-ID: <CAK7LNASPib2GUgjUEwmNYcO9_NgvjyjKSpqwJVZSNhFOJ7Lkfw@mail.gmail.com>
Subject: Re: [PATCH] kconfig: fix missing choice values in auto.conf
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        =?UTF-8?B?Sm9vbmFzIEt5bG3DpGzDpA==?= <joonas.kylmala@iki.fi>,
        Ulf Magnusson <ulfalizer@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 3, 2019 at 9:35 AM M. Vefa Bicakci <m.v.b@runbox.com> wrote:
>
> Hello,
>
> > conf_write() must be changed accordingly. Currently, it clears
> > SYMBOL_WRITE after the symbol is written into the .config file. This
> > is needed to prevent it from writing the same symbol multiple times in
> > case the symbol is declared in two or more locations. I added the new
> > flag SYMBOL_WRITTEN, to track the symbols that have been written.
> [snip]
> > diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> > index cbb6efa4a5a6..e0972b255aac 100644
> > --- a/scripts/kconfig/confdata.c
> > +++ b/scripts/kconfig/confdata.c
> [snip]
> > @@ -903,7 +904,7 @@ int conf_write(const char *name)
> >                               fprintf(out, "\n");
> >                               need_newline = false;
> >                       }
> > -                     sym->flags &= ~SYMBOL_WRITE;
> > +                     sym->flags |= SYMBOL_WRITTEN;
>
> The SYMBOL_WRITTEN flag is never cleared after being set in this
> function, which unfortunately causes data loss to occur when a user
> starts xconfig, gconfig, or nconfig and saves a config file more than
> once. Every save operation after the first one causes the saved .config
> file to contain only comments.
>
> I am appending a patch that resolves this issue. The patch is a bit
> ugly because of the code duplication, but it fixes this bug. (I have
> lightly tested the patch.) Even if the patch is not merged, I would
> appreciate it if this bug could be fixed.
>
> Thank you,




When you clear a flag, the tree traverse order is not a big deal.
So, you can use for_all_symbols() iterator.


Could you send v2 with the following code ?



       for_all_symbols(i, sym)
               sym->flags &= ~SYMBOL_WRITTEN;



This is quite simple, so you do not need to create a
new helper function for this.


Thanks.




>
> Vefa
>
> === 8< === Patch Follows === >8 ===
>
> From: "M. Vefa Bicakci" <m.v.b@runbox.com>
> Date: Fri, 2 Aug 2019 17:44:40 -0400
> Subject: [PATCH] kconfig: Clear "written" flag to avoid data loss
>
> Prior to this commit, starting nconfig, xconfig or gconfig, and saving
> the .config file more than once caused data loss, where a .config file
> that contained only comments would be written to disk starting from the
> second save operation.
>
> This bug manifests itself because the SYMBOL_WRITTEN flag is never
> cleared after the first call to conf_write, and subsequent calls to
> conf_write then skip all of the configuration symbols due to the
> SYMBOL_WRITTEN flag being set.
>
> This commit resolves this issue by clearing the SYMBOL_WRITTEN flag
> from all symbols before conf_write returns.
>
> Fixes: 8e2442a5f86e ("kconfig: fix missing choice values in auto.conf")
> Cc: linux-stable <stable@vger.kernel.org> # 4.19+
> Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
> ---
>  scripts/kconfig/confdata.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index 1134892599da..24fe0c851e8c 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -840,6 +840,35 @@ int conf_write_defconfig(const char *filename)
>         return 0;
>  }
>
> +static void conf_clear_written_flag(void)
> +{
> +       struct menu *menu;
> +       struct symbol *sym;
> +
> +       menu = rootmenu.list;
> +       while (menu) {
> +               sym = menu->sym;
> +               if (sym && (sym->flags & SYMBOL_WRITTEN))
> +                       sym->flags &= ~SYMBOL_WRITTEN;
> +
> +               if (menu->list) {
> +                       menu = menu->list;
> +                       continue;
> +               }
> +
> +               if (menu->next) {
> +                       menu = menu->next;
> +               } else {
> +                       while ((menu = menu->parent)) {
> +                               if (menu->next) {
> +                                       menu = menu->next;
> +                                       break;
> +                               }
> +                       }
> +               }
> +       }
> +}
> +
>  int conf_write(const char *name)
>  {
>         FILE *out;
> @@ -930,6 +959,8 @@ int conf_write(const char *name)
>         }
>         fclose(out);
>
> +       conf_clear_written_flag();
> +
>         if (*tmpname) {
>                 if (is_same(name, tmpname)) {
>                         conf_message("No change to %s", name);
> --
> 2.21.0
>


-- 
Best Regards
Masahiro Yamada
