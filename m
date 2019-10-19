Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 696B6DD5B6
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 02:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404131AbfJSAPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 20:15:04 -0400
Received: from conssluserg-03.nifty.com ([210.131.2.82]:46420 "EHLO
        conssluserg-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728453AbfJSAPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 20:15:03 -0400
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id x9J0Enup018065;
        Sat, 19 Oct 2019 09:14:50 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com x9J0Enup018065
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1571444090;
        bh=ObtrhjJLtVvUcEuk7d6WPsh0EgcUSH6MV5cSvNA/oRA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Wnyu941P8MMYoJPpC5X21INNKZ2qDQnzcYH484B3ak7th0zMIhM0fmAc1+9udSEVJ
         pAo5D7L2TzGc2i5z+lNgOpCOHRGaSh2DVz22zYFvszixoVkqh2CcrZtG2MlDt0k92k
         gTVXC5A0YhG1LCg+oVRGQnL5N5PdRcuVfbjg6xPHZPK+IKyunQ5Fg74QZ7i3Ihmkrv
         hVJlLUXEi59Y2p3XH82iERbZMpFHYFnkJ/Oo674IXJalp8AH6IGs/Z3UjVP1iSk00l
         rl4QxSjOLGH0co7wwdQRGt+SyEmCvjUe+varC5tW/Vu6PwIJjm2ONoTdCibudL5BV/
         rl314TSpYB6lQ==
X-Nifty-SrcIP: [209.85.217.45]
Received: by mail-vs1-f45.google.com with SMTP id s7so5216819vsl.2;
        Fri, 18 Oct 2019 17:14:50 -0700 (PDT)
X-Gm-Message-State: APjAAAXBrw52bXgz90rGgHXRl6J77NYXsxiRs8SeKVhimyVTjOOqbtyc
        Ddh1VM+zAikeNNx8AK5nnXhRkRLUxIw+dVtESHk=
X-Google-Smtp-Source: APXvYqzrDt+dWmfKbnc4Mz74p3lyUBSTxtM5qVGBCj4hiblh+r+/CaWvNSFAUEmrim2fAW/s3bS1mPXWZ+j/+/aWMfA=
X-Received: by 2002:a05:6102:97:: with SMTP id t23mr7279808vsp.179.1571444089167;
 Fri, 18 Oct 2019 17:14:49 -0700 (PDT)
MIME-Version: 1.0
References: <20191018220324.8165-1-sashal@kernel.org> <20191018220324.8165-50-sashal@kernel.org>
In-Reply-To: <20191018220324.8165-50-sashal@kernel.org>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sat, 19 Oct 2019 09:14:13 +0900
X-Gmail-Original-Message-ID: <CAK7LNARovn6jNGUBQbn-0KbwsCfC6GHE-ybqHDvRUXiCCDuMZA@mail.gmail.com>
Message-ID: <CAK7LNARovn6jNGUBQbn-0KbwsCfC6GHE-ybqHDvRUXiCCDuMZA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.3 50/89] kbuild: fix build error of 'make
 nsdeps' in clean tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Matthias Maennich <maennich@google.com>,
        Jessica Yu <jeyu@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 19, 2019 at 7:04 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Masahiro Yamada <yamada.masahiro@socionext.com>
>
> [ Upstream commit d85103ac78a6d8573b21348b36f4cca2e1839a31 ]
>
> Running 'make nsdeps' in a clean source tree fails as follows:
>
> $ make -s clean; make -s defconfig; make nsdeps
>    [ snip ]
> awk: fatal: cannot open file `init/modules.order' for reading (No such file or directory)
> make: *** [Makefile;1307: modules.order] Error 2
> make: *** Deleting file 'modules.order'
> make: *** Waiting for unfinished jobs....
>
> The cause of the error is 'make nsdeps' does not build modules at all.
> Set KBUILD_MODULES to fix it.
>
> Reviewed-by: Matthias Maennich <maennich@google.com>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> Signed-off-by: Jessica Yu <jeyu@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

nsdeps was introduced in v5.4

Please do not backport this commit.



>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index d7469f0926a67..62b9640d007a0 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -594,7 +594,7 @@ endif
>  # in addition to whatever we do anyway.
>  # Just "make" or "make all" shall build modules as well
>
> -ifneq ($(filter all _all modules,$(MAKECMDGOALS)),)
> +ifneq ($(filter all _all modules nsdeps,$(MAKECMDGOALS)),)
>    KBUILD_MODULES := 1
>  endif
>
> --
> 2.20.1
>


-- 
Best Regards
Masahiro Yamada
