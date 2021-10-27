Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285B943D0A2
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 20:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243532AbhJ0SZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 14:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243510AbhJ0SZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 14:25:23 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDDBC061220
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 11:22:54 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id bl14so3349967qkb.4
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 11:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V9N5C8SGb7U5wdMZ58rdvN1GPz0ZxsaF/5pC41Q62sE=;
        b=FQVRt63dmGzxcOIe6TYyIX4Vu9tje2LGd9fxy8cyXIUBWKQwtlTDLHo7hmIBdrrDgI
         ETEQ2EZ34R5jo6WeXHhUcp0qigiPu3E8JkuaemsjFQyLD/RQS4u7bHF4Gwj+g3v2PuhP
         cFjBpa+zovyyDe1er6eRmuezXlUrm3uFS55+Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V9N5C8SGb7U5wdMZ58rdvN1GPz0ZxsaF/5pC41Q62sE=;
        b=frhRs92lmwwjAeOxvLL2eRtHw+AAMO3jpUgf3lSB5zD8i3p2jdfvjHh2lb7ocM8x2t
         2/43CWoetKLOFSl8xJ9UZHnCmnuGJggbCti3XZqZpopH1rW3ShJnh09APp0rmHtfBsft
         C+DMsCu7EK0ikVp2ti0c82T4gJd8f++AVWHhXhsfnMx/bq5F8kfLoFDAuUfqbzxf7Y2v
         YKguI3MGfYJyvpuJv1H5hDoQQGsuH5c/3X2GWUO+gM6o27V19HnC43V3xthj4qxQpb9h
         yyYiFimMGfcSJoEBrudkOPm2OmzFXlT2NVkXd+u0nZvNw4qMVqcwezNaw49qD7q7zNWA
         8OLw==
X-Gm-Message-State: AOAM532Ao39pImJG8Uht4/is4wbdUgMxFCKiLGTVEWvXmQr5TwuIqswf
        f80D7XmobgP5tj/TLItMj3aig93lOyg2cA==
X-Google-Smtp-Source: ABdhPJw8pEwSKTwzY292aBUEulTsYAPwQ3QAZhmUTPhvjJHHv6n/RDUy9LBvgLFAsO7Zp2Jj7ipsQw==
X-Received: by 2002:a05:620a:d85:: with SMTP id q5mr17513183qkl.64.1635358973425;
        Wed, 27 Oct 2021 11:22:53 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id v3sm649822qtc.25.2021.10.27.11.22.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 11:22:51 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id v138so3072586ybb.8
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 11:22:50 -0700 (PDT)
X-Received: by 2002:a25:c344:: with SMTP id t65mr35272097ybf.409.1635358970358;
 Wed, 27 Oct 2021 11:22:50 -0700 (PDT)
MIME-Version: 1.0
References: <20211027080819.6675-1-johan@kernel.org> <20211027080819.6675-4-johan@kernel.org>
In-Reply-To: <20211027080819.6675-4-johan@kernel.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 27 Oct 2021 11:22:39 -0700
X-Gmail-Original-Message-ID: <CA+ASDXMYbP3jQPeOpDDktHgp4X81AH41cgiLFgz-YHVPyZO1sw@mail.gmail.com>
Message-ID: <CA+ASDXMYbP3jQPeOpDDktHgp4X81AH41cgiLFgz-YHVPyZO1sw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mwifiex: fix division by zero in fw download path
To:     Johan Hovold <johan@kernel.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 1:12 AM Johan Hovold <johan@kernel.org> wrote:
> --- a/drivers/net/wireless/marvell/mwifiex/usb.c
> +++ b/drivers/net/wireless/marvell/mwifiex/usb.c
> @@ -505,6 +505,22 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
>                 }
>         }
>
> +       switch (card->usb_boot_state) {
> +       case USB8XXX_FW_DNLD:
> +               /* Reject broken descriptors. */
> +               if (!card->rx_cmd_ep || !card->tx_cmd_ep)
> +                       return -ENODEV;

^^ These two conditions are applicable to USB8XXX_FW_READY too, right?

> +               if (card->bulk_out_maxpktsize == 0)
> +                       return -ENODEV;
> +               break;
> +       case USB8XXX_FW_READY:
> +               /* Assume the driver can handle missing endpoints for now. */
> +               break;
> +       default:
> +               WARN_ON(1);
> +               return -ENODEV;
> +       }
> +

Anyway, looks pretty good, thanks:

Reviewed-by: Brian Norris <briannorris@chromium.org>
