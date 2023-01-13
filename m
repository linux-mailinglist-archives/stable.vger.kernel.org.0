Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9A666A3D1
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 21:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjAMUDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 15:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjAMUDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 15:03:03 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEFD532BE
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:03:02 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id x40so509342lfu.12
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nTni+wbaNdoFxJZHjHSxguNsIMfXs1Dq60dhaD0O3/g=;
        b=XBIvg1iJ+x1OJifoSIqrot543YWkH97QSJZlttNqDQu9a+DFOOG6kHaDVk0UNii0oF
         Exc6whJ7JIn25/sJFFevIaQh50ZR82g2qY8jwPvNw5LuRFYdCg8564iZkrdSkib/AWhr
         7JUc7Lz0+ujudO10B4cjRQfmL4ISt2RMHd5+k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nTni+wbaNdoFxJZHjHSxguNsIMfXs1Dq60dhaD0O3/g=;
        b=4LfMPk/T+7Hfglk0XPDPxf9+rAT3Xqb03g35ajD5TvUpgJab/EkOldVyuXOXA1r3fg
         +TIcf0aVFNURXb7lPMYD1TKWAyi9NK8ORVhTaMB8K7bbc9jneGOVWCobB+ggGr7Bg0TY
         EA0P/7FT7c+Sm9divvX8BqdXPGlOdhFNa0/+xe2VgDEiKhxe971DXRgJnDZko+xfvAja
         N8jAteoSBbJZF2hr9VjoQ34SOqc2kPa0FK05oQEWyGngSj9semU5qYH2E7Cncvu9lTup
         bDeUmDZdLOvUT3Yy0aP/zx7US5/VkYH+6faAWrqKZfGnilzmBzXYb48PqrZufbUNqg4g
         Lexg==
X-Gm-Message-State: AFqh2krgCQaCncj0rRbJFIO15LoZHozZCVuS11w7gDvukud3vjMd14KN
        jlyKfePgZCjz+zLrtkNpT8MJxZI+nodDj5hx2XlPOw==
X-Google-Smtp-Source: AMrXdXvATDP0kTsEAO6f1JN5PqTtH1CxBfFdOMRNxIRSCJSkxOxVtpLbR2C/yH/c8Rt7lZOS9Zrl+HGg/hYrd1EmcH4=
X-Received: by 2002:ac2:4e50:0:b0:4ca:e48d:2b4b with SMTP id
 f16-20020ac24e50000000b004cae48d2b4bmr8290856lfr.511.1673640180795; Fri, 13
 Jan 2023 12:03:00 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 13 Jan 2023 14:03:00 -0600
MIME-Version: 1.0
In-Reply-To: <Y8ERRMXng+kL+Vtc@hovoldconsulting.com>
References: <20230113005405.3992011-1-swboyd@chromium.org> <20230113005405.3992011-4-swboyd@chromium.org>
 <Y8ERRMXng+kL+Vtc@hovoldconsulting.com>
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date:   Fri, 13 Jan 2023 14:03:00 -0600
Message-ID: <CAE-0n52+_wuX_8nuDDex-xnmg22ZLBUedqSxG1VFu+yVPbv9PQ@mail.gmail.com>
Subject: Re: [PATCH 5.15.y 3/4] phy: qcom-qmp-combo: fix broken power on
To:     Johan Hovold <johan@kernel.org>
Cc:     stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Johan Hovold (2023-01-13 00:07:32)
> On Thu, Jan 12, 2023 at 04:54:04PM -0800, Stephen Boyd wrote:
> > diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
> > index c6f860ce3d99..9fda6d283f20 100644
> > --- a/drivers/phy/qualcomm/phy-qcom-qmp.c
> > +++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
> > @@ -4620,13 +4621,13 @@ static int qcom_qmp_phy_com_init(struct qmp_phy *qphy)
> >               qphy_setbits(serdes, cfg->regs[QPHY_COM_POWER_DOWN_CONTROL],
> >                            SW_PWRDN);
> >       } else {
> > -             if (cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL])
> > -                     qphy_setbits(pcs,
> > -                                     cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL],
> > -                                     cfg->pwrdn_ctrl);
> > +             if (usb_phy->cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL])
> > +                     qphy_setbits(usb_phy->pcs,
> > +                                     usb_phy->cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL],
> > +                                     usb_phy->cfg->pwrdn_ctrl);
> >               else
> > -                     qphy_setbits(pcs, QPHY_POWER_DOWN_CONTROL,
> > -                                     cfg->pwrdn_ctrl);
> > +                     qphy_setbits(usb_phy->pcs, QPHY_POWER_DOWN_CONTROL,
> > +                                     usb_phy->cfg->pwrdn_ctrl);
>
> This bit looks like it requires some more work in order not to break
> PCIe and UFS PHYs, which lack the USB registers.

Good point. I don't have PCIe or UFS PHYs so I missed this.

>
> >       }
> >
> >       mutex_unlock(&qmp->phy_mutex);
> > @@ -5769,6 +5770,9 @@ static int qcom_qmp_phy_probe(struct platform_device *pdev)
> >                       goto err_node_put;
> >               }
> >
> > +             if (cfg->type == PHY_TYPE_USB3)

I changed this to by 'cfg->type != PHY_TYPE_DP'

> > +                     qmp->usb_phy = qmp->phys[id];
> > +
> >               /*
> >                * Register the pipe clock provided by phy.
> >                * See function description to see details of this pipe clock.
> > @@ -5791,6 +5795,9 @@ static int qcom_qmp_phy_probe(struct platform_device *pdev)
> >               id++;
> >       }
> >
> > +     if (!qmp->usb_phy)
> > +             return -EINVAL;
> > +
>
> This will break probe of PCIe and UFS PHYs unless you only check this
> for combo PHYs.
>
> Perhaps you can rename the usb_phy pointer to something more generic and
> set it also for PCIe and UFS so that it always points to the register
> block that should be used for QPHY_PCS_POWER_DOWN_CONTROL.

I worry that future backports will be complicated if they use 'usb_phy'.
Maybe I'll just leave this as is.
