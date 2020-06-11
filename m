Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19BC1F68D5
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 15:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgFKNKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 09:10:19 -0400
Received: from mail-ej1-f65.google.com ([209.85.218.65]:37633 "EHLO
        mail-ej1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgFKNKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 09:10:17 -0400
Received: by mail-ej1-f65.google.com with SMTP id mb16so6411506ejb.4;
        Thu, 11 Jun 2020 06:10:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2uHr75ZbW2v6iann1fkN4a19dY4vLMDgf8vBnvP/Hjs=;
        b=MeAj0FMeRghV0mk8uoe01F8hoC2AJ4zno3MNyAx3MPZPeg/G+ahFm/Pcy/uXFhm7Gh
         rZM2SviX3bThp0cvAulUBbkBP/DLUWbqIJIDbtd9a3bhlGcHVII9XDdCIslNDZqLjMNs
         Zdl/XgIOnM9aJIV2+NtfJplk5ZAHdcmnzsb7eMWcmzKL+iIHF0FeveghLFqaAd+LpwoH
         9DULSOg0OySBfXa1F1ttel8KZh9rAmMo+JkmOvzhMpZjK7V/D0PWbjpITKdXPU6MnZe5
         Nhsgym4wXPRUbcb5ok8csi+/dvSrPAGEWZ+b7QNDwPAVew+J6Kvnq2hovd2PwkmniXwu
         SezA==
X-Gm-Message-State: AOAM5317qqqqlzehEqOz6+XK0KQ6LNBEUIFSlJUjPzKu+HGhr0bEW7II
        PxtYza04C3LNf8QQkInvj/xry9eP
X-Google-Smtp-Source: ABdhPJzTA+GZ2UfzZ1VoCR76XSuhDqoC70X4qdvo4Xp7fa1L/UqWYYUMH4+68K19sH+pvoGerqe+mQ==
X-Received: by 2002:a17:906:ce30:: with SMTP id sd16mr8621248ejb.374.1591881014308;
        Thu, 11 Jun 2020 06:10:14 -0700 (PDT)
Received: from kozik-lap ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id b24sm1512117edw.70.2020.06.11.06.10.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Jun 2020 06:10:13 -0700 (PDT)
Date:   Thu, 11 Jun 2020 15:10:11 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Robin Gong <yibin.gong@nxp.com>
Cc:     Vinod Koul <vkoul@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Peng Ma <peng.ma@nxp.com>, Fabio Estevam <festevam@gmail.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] dmaengine: fsl-edma: Fix NULL pointer exception in
 fsl_edma_tx_handler
Message-ID: <20200611131011.GA26264@kozik-lap>
References: <1591877861-28156-1-git-send-email-krzk@kernel.org>
 <1591877861-28156-2-git-send-email-krzk@kernel.org>
 <VE1PR04MB66382172816FB95036776F6489800@VE1PR04MB6638.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <VE1PR04MB66382172816FB95036776F6489800@VE1PR04MB6638.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 01:04:43PM +0000, Robin Gong wrote:
> On 2020/06/11 20:18 Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > 
> > NULL pointer exception happens occasionally on serial output initiated by login
> > timeout.  This was reproduced only if kernel was built with significant
> > debugging options and EDMA driver is used with serial console.
> > 
> >     col-vf50 login: root
> >     Password:
> >     Login timed out after 60 seconds.
> >     Unable to handle kernel NULL pointer dereference at virtual address
> > 00000044
> >     Internal error: Oops: 5 [#1] ARM
> >     CPU: 0 PID: 157 Comm: login Not tainted 5.7.0-next-20200610-dirty #4
> >     Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
> >       (fsl_edma_tx_handler) from [<8016eb10>]
> > (__handle_irq_event_percpu+0x64/0x304)
> >       (__handle_irq_event_percpu) from [<8016eddc>]
> > (handle_irq_event_percpu+0x2c/0x7c)
> >       (handle_irq_event_percpu) from [<8016ee64>]
> > (handle_irq_event+0x38/0x5c)
> >       (handle_irq_event) from [<801729e4>]
> > (handle_fasteoi_irq+0xa4/0x160)
> >       (handle_fasteoi_irq) from [<8016ddcc>]
> > (generic_handle_irq+0x34/0x44)
> >       (generic_handle_irq) from [<8016e40c>]
> > (__handle_domain_irq+0x54/0xa8)
> >       (__handle_domain_irq) from [<80508bc8>] (gic_handle_irq+0x4c/0x80)
> >       (gic_handle_irq) from [<80100af0>] (__irq_svc+0x70/0x98)
> >     Exception stack(0x8459fe80 to 0x8459fec8)
> >     fe80: 72286b00 e3359f64 00000001 0000412d a0070013 85c98840
> > 85c98840 a0070013
> >     fea0: 8054e0d4 00000000 00000002 00000000 00000002 8459fed0
> > 8081fbe8 8081fbec
> >     fec0: 60070013 ffffffff
> >       (__irq_svc) from [<8081fbec>]
> > (_raw_spin_unlock_irqrestore+0x30/0x58)
> >       (_raw_spin_unlock_irqrestore) from [<8056cb48>]
> > (uart_flush_buffer+0x88/0xf8)
> >       (uart_flush_buffer) from [<80554e60>] (tty_ldisc_hangup+0x38/0x1ac)
> >       (tty_ldisc_hangup) from [<8054c7f4>] (__tty_hangup+0x158/0x2bc)
> >       (__tty_hangup) from [<80557b90>]
> > (disassociate_ctty.part.1+0x30/0x23c)
> >       (disassociate_ctty.part.1) from [<8011fc18>] (do_exit+0x580/0xba0)
> >       (do_exit) from [<801214f8>] (do_group_exit+0x3c/0xb4)
> >       (do_group_exit) from [<80121580>] (__wake_up_parent+0x0/0x14)
> > 
> > Issue looks like race condition between interrupt handler fsl_edma_tx_handler()
> > (called as result of fsl_edma_xfer_desc()) and terminating the transfer with
> > fsl_edma_terminate_all().
> > 
> > The fsl_edma_tx_handler() handles interrupt for a transfer with already freed
> > edesc and idle==true.
> > 
> > Fixes: d6be34fbd39b ("dma: Add Freescale eDMA engine driver support")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > ---
> >  drivers/dma/fsl-edma.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c index
> > eff7ebd8cf35..90bb72af306c 100644
> > --- a/drivers/dma/fsl-edma.c
> > +++ b/drivers/dma/fsl-edma.c
> > @@ -45,6 +45,13 @@ static irqreturn_t fsl_edma_tx_handler(int irq, void
> > *dev_id)
> >  			fsl_chan = &fsl_edma->chans[ch];
> > 
> >  			spin_lock(&fsl_chan->vchan.lock);
> > +
> > +			if (!fsl_chan->edesc) {
> Would you like fix the same potential issue in mcf_edma_tx_handler()
> of mcf-edma.c? 

Sure. I'll make another commit as it should be backported to different
kernel.

Best regards,
Krzysztof

