Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02F0357769
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 00:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhDGWLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 18:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhDGWLm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 18:11:42 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3C0C061760;
        Wed,  7 Apr 2021 15:11:31 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id g24so14970466qts.6;
        Wed, 07 Apr 2021 15:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=amAuSjaH75GbFNszV8kNPKmiZ9+ARLzooMkxZXBGL4c=;
        b=Q8bUVhUxi4if9bKkZaClN0vDG8Zqwvx/YTkTZjDFMQGm+J80O+6zT5JzPrwgh13HwR
         sZvKNz1EIgUUVwwBu74zih3eU37J3Y2BpKH++a/1JufPT3FDw2k0pL/VfkATVkQfwKwu
         +szXKkmHxDY+HSA063eeY3uJeTc6AwgBI85CH0BK9WAJMNVmujmEBJPNyZGlCBtgu9Gk
         aICCgKb8a7sKH7V6bnIJnVdNQps/CNVOz6UZVcFiSpluTrRUJ2Pp9BFEuAHHDIxGWzsY
         pMMlKT4K2Fcg4l1iGQpPuvBYtPOKQMLJLXwKECylxNTHuhw/SyAF4oaW3iZJNBP7qUa3
         X4RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=amAuSjaH75GbFNszV8kNPKmiZ9+ARLzooMkxZXBGL4c=;
        b=EonMrydY2xuuwV6a8SEvSbJI6eVzzU1epbqKYcSYD9R2jZGV7bv0lykfzM9aRPSlUp
         ropmqZ/HdJ/Jqz7EPDkaawpynzu/O9YQRF0+gHmLVLuS2Ia4BQTUcoceD4a2EqbDFeGX
         ExZpJwSkyxv1EDu5U4fl0xsiONhEqy27jeZTFKbYOAhYvNgpeJVPGWaMjnuGVM2ejx6W
         xvIpWwGN0XGjFH5BfX+vx3n2QmTlXSV/M1jCx1DzoeDmqjmmW5hNgdNGOJva81hVWzWA
         nidcNWe2qSwyiCos4GjP0nnD8xEVEYdlTlvz1zO1qUWv0xAYaNlMVPmnPwnUN33iFpq9
         p/Ew==
X-Gm-Message-State: AOAM531kddTJxcYli8fLVSOP1gDChw9mEuHgp1weGkt8egufX4pvgqHL
        E5OiFn7mC5meAXBWyrAKK8KPT2EXJGfYyJdRxgc=
X-Google-Smtp-Source: ABdhPJy9uzxI0rQ+Z4C4+JpW5tL/YK+9PabpkQyOtmeoKQV8IH3MlM7Azd/8wZxPx9/B6fqdWSebJuvstroAIDQCBdg=
X-Received: by 2002:ac8:6d2b:: with SMTP id r11mr4635895qtu.245.1617833490836;
 Wed, 07 Apr 2021 15:11:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210331062723.2090-1-wangfangpeng1@huawei.com>
In-Reply-To: <20210331062723.2090-1-wangfangpeng1@huawei.com>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Thu, 8 Apr 2021 00:11:19 +0200
Message-ID: <CAFLxGvwer-w7ngekB_4rtBLWrr0KrwqLjavJd3ZTR8Xh5f_Y3A@mail.gmail.com>
Subject: Re: [PATCH] ubifs: fix read fail but return ok
To:     wangfangpeng <wangfangpeng1@huawei.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Adrian Hunter <ext-adrian.hunter@nokia.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        Xiaoming Ni <nixiaoming@huawei.com>, zengweilin@huawei.com,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 31, 2021 at 8:29 AM wangfangpeng <wangfangpeng1@huawei.com> wrote:
> do_readpage() may return err, but ubifs_readpage() always return ok.
> The vfs will ignore the err happen in ubifs.

Are you sure about that?
In case of an error UBIFS sets the error flag of the page and does not
mark it as uptodate,
so vfs will emit -EIO. At least this is the theory. :-)

-- 
Thanks,
//richard
