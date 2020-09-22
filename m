Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D702741F0
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 14:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgIVMSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 08:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgIVMSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 08:18:39 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C07C061755;
        Tue, 22 Sep 2020 05:18:39 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id r9so19319863ioa.2;
        Tue, 22 Sep 2020 05:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=42PP+L0P7UrDlAUQ+gEm/uFRSDGJTrEup5hV3ngJiGo=;
        b=rhJZXWD1dSNuMCuNR0DuR1E444XFj4jI1z6RYDLS2jN+Hu2LfVa5pzhpbNBcr565HR
         FC2hxBx6FbnFbeYNhDyU7b36ah8xStOyNQnwjiSMI9Yi61oCD/3vLxSewppO4vT7tY5P
         dfnwWqj2FLg9P/mmnf0A5BIbYB0x/J/FrW//0Un8GW1uOOR0oQrUDW49b71y0Ziguu80
         /blDFmIl1QW17ucd7C5sygy+aQUq/hDhM35it/Bcwr8QeHpUg75wpLMTFjpeELmgQbQY
         4QKpMVmDmei4AJCBV1uwGWaHV4HYwYKZGa2Oc9F6Azykl8rSeLDl/UiVRrdvE/jSyNMO
         WU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=42PP+L0P7UrDlAUQ+gEm/uFRSDGJTrEup5hV3ngJiGo=;
        b=pd0XXjntYQAYpxONNA1fCnf44t7dToJp3GPRAUd2zputNZuLzwC8ISrIRqXSV3wv4w
         e0OzgN53sEJxD/b3GKPky+WY1XNkjSo+LQvRp/sA3W3t+r9iFww91RVKddqvbuFLkE+y
         VlN5SSoDJm3sJ18JBZ7uSgfghmCvYYY0DJPHqXUmXsg+KuXxJNbwUlfdzahj3ywi/lDa
         rUnxKLskL0Ps21oof01nv7/Onj/T5tlX1HetPklpUjLi/gAnZsZX/mHdhcLRQZ0PlLUk
         pC2+jTf4H/ByUE4C/leMO5vPaKGTo3KquZWO9/1iLwPrVZ0iYXuMiRJ0WWgFmlgm+Qcy
         m/Pw==
X-Gm-Message-State: AOAM5307Ib4+XdtosjNvufeWq5WGirtEelynDYHfF/HBfX+7yNye3Xxf
        c70WwbHy4TBPL4JKluTl8/NvmOnoH3sNQsDimqs=
X-Google-Smtp-Source: ABdhPJxNd1ARfGmnkBsYPcYrgCQe6SpcQ4UoTeAy2LoVim6jeFJ92m2Thejku2YrwvIeFngjWCa9d5eeXg3yrv2xN4g=
X-Received: by 2002:a02:4b07:: with SMTP id q7mr3953267jaa.84.1600777118139;
 Tue, 22 Sep 2020 05:18:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200922114905.2942859-1-gch981213@gmail.com> <20200922120112.GS4792@sirena.org.uk>
In-Reply-To: <20200922120112.GS4792@sirena.org.uk>
From:   Chuanhong Guo <gch981213@gmail.com>
Date:   Tue, 22 Sep 2020 20:18:27 +0800
Message-ID: <CAJsYDVKJHg=CNeomk7FAQXwyc1soQziJk3PLy=M+uYsb849w4g@mail.gmail.com>
Subject: Re: [PATCH v2] spi: spi-mtk-nor: fix timeout calculation overflow
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-spi@vger.kernel.org,
        =?UTF-8?B?QmF5aSBDaGVuZyAo56iL5YWr5oSPKQ==?= 
        <bayi.cheng@mediatek.com>, stable@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On Tue, Sep 22, 2020 at 8:02 PM Mark Brown <broonie@kernel.org> wrote:
>
> On Tue, Sep 22, 2020 at 07:49:02PM +0800, Chuanhong Guo wrote:
>
> >               if ((op->data.dir == SPI_MEM_DATA_IN) &&
> >                   mtk_nor_match_read(op)) {
> > +                     // limit size to prevent timeout calculation overflow
> > +                     if (op->data.nbytes > 0x400000)
> > +                             op->data.nbytes = 0x400000;
>
> If there's a limit on transfer sizes there should also be a
> max_transfer_size or max_message_size set (which we should pay attention
> to in the core for flash stuff but IIRC we didn't do that yet).

There's already a 6-byte max_message_size limit on this controller.
spi-mem dma read is the only operation which allows such a long transfer.

-- 
Regards,
Chuanhong Guo
