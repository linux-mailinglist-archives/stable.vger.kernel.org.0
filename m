Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7E3317E42F
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 17:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgCIQBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 12:01:11 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39087 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgCIQBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 12:01:11 -0400
Received: by mail-pl1-f195.google.com with SMTP id j20so4145021pll.6
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 09:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:content-transfer-encoding:in-reply-to:references
         :subject:from:cc:to:date:message-id:user-agent;
        bh=KTZj+3STjVcCT5OSqKRIMYkDmtaQOdfMWMC8L9BMTr8=;
        b=bHsmE79Nzwu6P6aYukHgkrewK0wrD2YTkan9k9YUmOAQjk+QsR19+pm2EXr8LB+42d
         29lLDIpmq9gN5lou9H7VaEjh1OJK4NNXSLWkbQRLBYxkoh9j3kKnfz+v7BLYPCZFnOeX
         4ZjhZw5SEaBBq2e73KtcXTWRkqLdRSfO4fsDU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding
         :in-reply-to:references:subject:from:cc:to:date:message-id
         :user-agent;
        bh=KTZj+3STjVcCT5OSqKRIMYkDmtaQOdfMWMC8L9BMTr8=;
        b=f0Luwtt3WPLpDpyMjYFTkt3+NsNFGn+5k2+EZMEQGJwyiEPtznslidlcsJGhNO/nvV
         LgqtScoy71FUW6fjhDfJzNl0F+6HZ+8Oh9WY2l5qntqrR3Z82CCaTgj9PKMCUtcLzM+h
         rBaHtEhtIy35CMAwGhwTQ2ir/uFFsSjMYjhGmogbrhG8TfQGeJch0nnltjs5OEMSYpAF
         ENZNL5Jft4u7eOeQL746ie4YzKQjSc1GPY8d5aK1DNDazwn7ccZUT525ofie3xyXLrvE
         LhrbqhYRtWxAXs5NI0UHg4TRMg6eEASVbqKa8B+xPHWLoOIugrXfSshAN/+nZfmrmH6k
         F8JA==
X-Gm-Message-State: ANhLgQ1I5sksvHc2fneLptBY68BUtUVLL/k6VVHPUHvQYOnHuAzhfvUA
        5cFh9Wo3eI3sgn0F1tIUMnDucQ==
X-Google-Smtp-Source: ADFU+vvSMYysEWRr1RfuoGw7m/AMvOmgItQrC3FgLhMknEsbo8o0KhshDFjyBhxBKbbaVGwT/hH23Q==
X-Received: by 2002:a17:90a:3270:: with SMTP id k103mr36241pjb.30.1583769670742;
        Mon, 09 Mar 2020 09:01:10 -0700 (PDT)
Received: from chromium.org ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id 127sm25920016pfb.130.2020.03.09.09.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 09:01:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200309152604.585112-1-linus.walleij@linaro.org>
References: <20200309152604.585112-1-linus.walleij@linaro.org>
Subject: Re: [PATCH v4] pinctrl: qcom: Assign irq_eoi conditionally
From:   Stephen Boyd <swboyd@chromium.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
To:     Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org
Date:   Mon, 09 Mar 2020 09:01:09 -0700
Message-ID: <158376966926.66766.8061505915424061056@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Linus Walleij (2020-03-09 08:26:04)
> The hierarchical parts of MSM pinctrl/GPIO is only
> used when the device tree has a "wakeup-parent" as
> a phandle, but the .irq_eoi is anyway assigned leading
> to semantic problems on elder Qualcomm chipsets.
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
> If we solve this crash by avoiding to call up to
> irq_chip_eoi_parent(), the machine will hang and get
> reset by the watchdog, because of semantic issues,
> probably inside irq_chip.
>=20
> As a solution, just assign the .irq_eoi conditionally if
> we are actually using a wakeup parent.
>=20
> Cc: David Heidelberg <david@ixit.cz>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Lina Iyer <ilina@codeaurora.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Stephen Boyd <swboyd@chromium.org>
> Cc: stable@vger.kernel.org
> Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
> Link: https://lore.kernel.org/r/20200306121221.1231296-1-linus.walleij@li=
naro.org
> Link: https://lore.kernel.org/r/20200309125207.571840-1-linus.walleij@lin=
aro.org
> Tested-by: David Heidelberg <david@ixit.cz>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Reviewed-by: Stephen Boyd <swboyd@chromium.org>
