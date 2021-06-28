Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E012C3B57C8
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 05:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhF1DYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 23:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhF1DYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 23:24:15 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6730CC061574;
        Sun, 27 Jun 2021 20:21:49 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id m9so16096655ybp.8;
        Sun, 27 Jun 2021 20:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+oBDwfkoqQBZF8b/GVv8gJiTknHVSmHA0o8eDbQJ7qw=;
        b=beed0lhxIcJCRaaH5GRHcpVOJJi5P+mDN8/+bYP6RjuDgQHW8kmvd/GOuAv8K/62kj
         akoNVx+UnWBiuetQAhVxfJzSaTKp/e4Rr3iCWwGMPN8G5qvBdYdilCGVsVzsduJjZwjY
         rBuZdu+HqPBmqepHyfbtmcInWYgQyhrDEmGxAeUmDe06eFcExTSGm4goewxhpGz8S1eb
         Zeuz4oFoFRJQOHLiJQn8Gmbi2L+VfuFIV1+qG7kJ7SS+id1EVbysa1rNtog5jGySbDYW
         Gf2ojeNMuYqLn05rYzt69QJp+FerbJ/7bU7/jT+qqB5LujHEswLniAyKzheXKAM7bRXf
         94SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+oBDwfkoqQBZF8b/GVv8gJiTknHVSmHA0o8eDbQJ7qw=;
        b=kz2ojIFqqYYooLTS6eojeL6JsU7y+xeHm50nNS3vop8CDYuoe7kcE20+8SRXEtVh2O
         8l97kaO6l30W/Pvvq5I6hVfoYqFMJrN/EVj32IFlGSlB+INQoFToG+RspvSpsh8Ls52C
         IUOxy5fuU3OQGtFZPrRx6C9lTbIFRc8KZLAJVg34UmInQZP2rK+MRvjUIOqi8+4K/VvK
         H/OkBOX2WqCd1+7WkFXLFYygbwnwLHWAvTPx8MO58K1ffgz3jFBkYByazaJaw1QmvtHa
         mv2mXe0d28ZkttYS9R0nFBp+zK49ssEC7PIyRR4FKhzleH0gu4h2rBhi4BrbCm1rmCvQ
         lCDA==
X-Gm-Message-State: AOAM532y+Rklg3D4JaqwN+fjF2v95L+4gTsdQOwo7m60ARmTd+ZyWqP4
        3wsT9TwjKUJeue7LlFL/c0RGIyP9vBGKjmudff2pcnI/
X-Google-Smtp-Source: ABdhPJzwr3WGDedoWAjPw98+br/6i6KSq1AYI6Tz6NPl4p41ofTvwK1WH1T6PuFjIYkkH5nXUh5uTyDLQ7aKnHC7G5A=
X-Received: by 2002:a25:2c01:: with SMTP id s1mr6424780ybs.387.1624850508742;
 Sun, 27 Jun 2021 20:21:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210627135117.28641-1-bmeng.cn@gmail.com> <11706f7e-a53a-5640-d713-bc4562db71fa@huawei.com>
 <CAEUhbmV=h3nZ8Aa94_uyjrZ_NGe+9-xAorUMubSPJXu3y60PeQ@mail.gmail.com> <aa1f027c-bbc7-92f8-80a6-fe290cd1cdf8@huawei.com>
In-Reply-To: <aa1f027c-bbc7-92f8-80a6-fe290cd1cdf8@huawei.com>
From:   Bin Meng <bmeng.cn@gmail.com>
Date:   Mon, 28 Jun 2021 11:21:37 +0800
Message-ID: <CAEUhbmXeqAsLxm+oCHRPHMZq2mQXPD6fJOFerwp_BRv1kCc7ow@mail.gmail.com>
Subject: Re: [PATCH] riscv: Fix 32-bit RISC-V boot failure
To:     Kefeng Wang <wangkefeng.wang@huawei.com>
Cc:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Atish Patra <atish.patra@wdc.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 10:28 AM Kefeng Wang <wangkefeng.wang@huawei.com> w=
rote:
>
>
> On 2021/6/28 9:15, Bin Meng wrote:
> > On Mon, Jun 28, 2021 at 8:53 AM Kefeng Wang <wangkefeng.wang@huawei.com=
> wrote:
> >> Hi=EF=BC=8C sorry for the mistake=EF=BC=8Cthe bug is fixed by
> >>
> >> https://lore.kernel.org/linux-riscv/20210602085517.127481-2-wangkefeng=
.wang@huawei.com/
> > What are we on the patch you mentioned?
> >
> > I don't see it applied in the linux/master.
> >
> > Also there should be a "Fixes" tag and stable@vger.kernel.org cc'ed
> > because 32-bit is broken since v5.12.
>
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/riscv/linux/+/c9=
811e379b211c67ba29fb09d6f644dd44cfcff2
>
> it's on Palmer' riscv-next.

Not sure riscv-next is for which release? This is a regression and
should be on 5.13.

>
> Hi Palmer, should I resend or could you help me to add the fixes tag?

Regards,
Bin
