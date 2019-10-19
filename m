Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 657DEDD5BB
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 02:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbfJSASb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 20:18:31 -0400
Received: from condef-04.nifty.com ([202.248.20.69]:30861 "EHLO
        condef-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfJSASb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 20:18:31 -0400
Received: from conssluserg-01.nifty.com ([10.126.8.80])by condef-04.nifty.com with ESMTP id x9J0Dmfd017755
        for <stable@vger.kernel.org>; Sat, 19 Oct 2019 09:13:48 +0900
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id x9J0DhVI017441;
        Sat, 19 Oct 2019 09:13:44 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com x9J0DhVI017441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1571444024;
        bh=Wv7SDO7TGz/Tz/kPoq97RTLIMVXEt2S+6Yr6mw+gDCQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qiFlhYVBWH7HcAHa04a0nidYNnCnZHQY+DeY0xGKGwNJa1W70j6ualaYq5jjbei7Q
         P0um+gifV5M5Isba1elISoevdeTYTvYVo+IEQZvfPEPAi3ROzpZ97MNGbVtXp/hr6S
         C7NJr+SBe2+MffR3Mmv4rXjGb4m703A0rEuKsGUFbbvRVUMxdlarZPmASzStUihaTW
         F7PTu2wrtwAtPEmVRw52VavGHZ7/s9dcNkNl6ZviYD+KYHI/Y0HoxDDFKJn/x6KaOm
         U/aN4/z6b3N8Es3NGkKRp/W04yH52En28mxmOllC7turK959Lb1IJcMKhaLE4Ojp6B
         3Mg4brqp1262Q==
X-Nifty-SrcIP: [209.85.222.46]
Received: by mail-ua1-f46.google.com with SMTP id l13so2338807uap.8;
        Fri, 18 Oct 2019 17:13:44 -0700 (PDT)
X-Gm-Message-State: APjAAAX/TkFC5XQJsNcLY2bIJo7JNP6DZM2EPPfir952rYF9Fs9bfqkL
        n1AUebqcGfqaLUcOu+3uDlbXLT4LsEk3cJl/CcY=
X-Google-Smtp-Source: APXvYqwLdG24TcKRI2xGdPVyXycA/P86iGVpj388RYLudVH3Yy2vabgr2OOiiA0cJgKnUH8lbg94E4aPGHgyjlzHrec=
X-Received: by 2002:ab0:59ed:: with SMTP id k42mr7047231uad.25.1571444023192;
 Fri, 18 Oct 2019 17:13:43 -0700 (PDT)
MIME-Version: 1.0
References: <20191018220525.9042-1-sashal@kernel.org> <20191018220525.9042-77-sashal@kernel.org>
In-Reply-To: <20191018220525.9042-77-sashal@kernel.org>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sat, 19 Oct 2019 09:13:07 +0900
X-Gmail-Original-Message-ID: <CAK7LNATx=yY2Tmfd-BkmPjsqOFc+wUAtKzR7UpmU83LueVDQQw@mail.gmail.com>
Message-ID: <CAK7LNATx=yY2Tmfd-BkmPjsqOFc+wUAtKzR7UpmU83LueVDQQw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 077/100] kbuild: fix build error of 'make
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

Hi Sasha,

On Sat, Oct 19, 2019 at 7:18 AM Sasha Levin <sashal@kernel.org> wrote:
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

Thanks.


>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index 4d29c7370b464..80f169534c4a7 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -566,7 +566,7 @@ endif
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
