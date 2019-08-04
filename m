Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88D15808FF
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 05:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbfHDDu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 23:50:59 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:22281 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfHDDu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Aug 2019 23:50:59 -0400
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id x743olnN005896;
        Sun, 4 Aug 2019 12:50:47 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com x743olnN005896
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1564890648;
        bh=3vS3/5rDcS18Sb1Eug7YS5T01mgblSSYbNpIdtgur6c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iF72YwKqnOePS9nerjL2Gy4Q75/TdlZCEsCX9PhzH+f4DSy6R5khaPcRlv1M6vgPq
         YucD7z2OkRDMMBPELtCRtALjV90LaGCsnmlwI8lh8aOdpWOfq9EfBUMYlNN1OCsYgK
         DrGvMZcdgmJ9uhG4uR1ChOxhPuEtmyCfD+O265TPgOjhFVnEA9Nl+VTXhPGBWPFwFZ
         AGfjQrBcBk/Ny2CVVWGCWZGawY3u7cBYqHM3JuRaSDpyD1bNPyLY+4cewRGui0Mpab
         v7fTkJYZjN4YsAJjyNJfVd64nikNvK6MTapp3BYU8MJ70F4svsOUWBKE0VRj4MGmQc
         fCJBgbJ+7M5qQ==
X-Nifty-SrcIP: [209.85.222.41]
Received: by mail-ua1-f41.google.com with SMTP id a97so31065898uaa.9;
        Sat, 03 Aug 2019 20:50:47 -0700 (PDT)
X-Gm-Message-State: APjAAAVwnKXgbYDAMEOWCOquX6yZ6CxtpaCK44H0nT6MOMJcaD0qXwxS
        uA3BICQCeiRO3osib/uJCBOEp0VrX7PAyFueYQU=
X-Google-Smtp-Source: APXvYqx8onDg0qzMkVy3xckekMqtp+JwWYueQcaBxSbON6vDfFQxIN1skfZGQVCrNF4p5bz2ZX0sdr0MQKEG4jHmhWE=
X-Received: by 2002:a9f:25e9:: with SMTP id 96mr74623588uaf.95.1564890646592;
 Sat, 03 Aug 2019 20:50:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAK7LNASPib2GUgjUEwmNYcO9_NgvjyjKSpqwJVZSNhFOJ7Lkfw@mail.gmail.com>
 <20190803100212.8227-1-m.v.b@runbox.com>
In-Reply-To: <20190803100212.8227-1-m.v.b@runbox.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sun, 4 Aug 2019 12:50:10 +0900
X-Gmail-Original-Message-ID: <CAK7LNAS3heQA-0FzANyqXGSOR+kZ6zLgoSWYEW_ngrEdH46QsQ@mail.gmail.com>
Message-ID: <CAK7LNAS3heQA-0FzANyqXGSOR+kZ6zLgoSWYEW_ngrEdH46QsQ@mail.gmail.com>
Subject: Re: [PATCH v2] kconfig: Clear "written" flag to avoid data loss
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>
Cc:     =?UTF-8?B?Sm9vbmFzIEt5bG3DpGzDpA==?= <joonas.kylmala@iki.fi>,
        Ulf Magnusson <ulfalizer@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 3, 2019 at 7:02 PM M. Vefa Bicakci <m.v.b@runbox.com> wrote:
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


Applied to linux-kbuild/fixes.
Thanks.



-- 
Best Regards
Masahiro Yamada
