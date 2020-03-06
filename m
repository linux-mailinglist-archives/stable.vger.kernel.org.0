Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98FB117C7E2
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 22:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgCFVcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 16:32:14 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37078 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgCFVcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 16:32:14 -0500
Received: by mail-pl1-f195.google.com with SMTP id b8so1390176plx.4
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 13:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:content-transfer-encoding:in-reply-to:references
         :subject:from:cc:to:date:message-id:user-agent;
        bh=ThTZqiq06fipVzy9RW1LluCf54UlVnq4vd8uGcF/tcQ=;
        b=jm6EHAKHOIoqgWI0j1ax51Ae6RTPkwFU+DpXO5+3A9VnGVafwQsPmjw8E8ojzvHo6C
         yAQu4MAV420EisWUU2jslXFHbfnoMmi8mCY5UtpSDuMGlVpEdmpb294mKcgLOyn41ull
         l6TQugpJwTXWhMqlyoQTWrBXvGDDNNVNHv88U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding
         :in-reply-to:references:subject:from:cc:to:date:message-id
         :user-agent;
        bh=ThTZqiq06fipVzy9RW1LluCf54UlVnq4vd8uGcF/tcQ=;
        b=gdbClYOBcesFmU7oPMUiRWnmXQHKkq3O5JG5ppje1i0PnSC/3b6N2i9jggsfMY1fya
         eXX3vdKWgsM6HQ4CxZegQgQhgiJgS6zD+fc7OyteQoPsryNV8md9eqnQRKUiq1YEULwu
         WjjCUKvvk9gDrZ/DWg9Ogwdqo3SZwLUlIwXG0vt0d6uN1zu6bRJHEUyggUiyl/eT1m65
         shCtrlufgcPHwx+pqNxtR0/HIxBiGBB/ijizQTKiyeqFrR04bDBxe+LR+I97eDjrzEc0
         XXYzz27F4zCQ5Owsf7e6YxQdjYDMUPzk/w5iPS4nHNcoAi2jElX/CkZZ9VblpctGSSo0
         KbHQ==
X-Gm-Message-State: ANhLgQ3kX3JkM96+KskhCBtZftrlU/pd8aoWL1r36EctTusQZa+v7Ka4
        jV2h3L0Kc7v8ore/7SPWraLouw==
X-Google-Smtp-Source: ADFU+vuadZKfQR3SfeWc/992URv4Ic0V5yrWlTYxzsEFN03fP1PsL8GxGlLlFmfNElKN8ajw6rOx9w==
X-Received: by 2002:a17:90a:1747:: with SMTP id 7mr5666505pjm.154.1583530333345;
        Fri, 06 Mar 2020 13:32:13 -0800 (PST)
Received: from chromium.org ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id w65sm33266018pfd.77.2020.03.06.13.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 13:32:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200306121221.1231296-1-linus.walleij@linaro.org>
References: <20200306121221.1231296-1-linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: qcom: Guard irq_eoi()
From:   Stephen Boyd <swboyd@chromium.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
To:     Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org
Date:   Fri, 06 Mar 2020 13:32:11 -0800
Message-ID: <158353033159.66766.8391368684056319578@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Linus Walleij (2020-03-06 04:12:21)
> In the commit setting up the qcom/msm pin controller to
> be hierarchical some callbacks were careful to check that
> d->parent_data on irq_data was valid before calling the
> parent function, however irq_chip_eoi_parent() was called
> unconditionally which doesn't work with elder Qualcomm
> platforms such as APQ8060.
>=20
> When the drivers/mfd/qcom-pm8xxx.c driver calls
> chained_irq_exit() that call will in turn call chip->irq_eoi()
> which is set to irq_chip_eoi_parent() by default on a
> hierachical IRQ chip, and the parent is pinctrl-msm.c
> so that will in turn unconditionally call
> irq_chip_eoi_parent() again, but its parent is invalid
> so we get the following crash:
>=20
>  Unnable to handle kernel NULL pointer dereference at
>  virtual address 00000010
>  pgd =3D (ptrval)
>  [00000010] *pgd=3D00000000
>  Internal error: Oops: 5 [#1] PREEMPT SMP ARM
>  (...)
>  PC is at irq_chip_eoi_parent+0x4/0x10
>  LR is at pm8xxx_irq_handler+0x1b4/0x2d8
>=20
> Implement a local stub just avoiding to call down to
> irq_chip_eoi_parent() if d->parent_data is not set.
>=20
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Lina Iyer <ilina@codeaurora.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Stephen Boyd <swboyd@chromium.org>
> Cc: stable@vger.kernel.org
> Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Reviewed-by: Stephen Boyd <swboyd@chromium.org>
