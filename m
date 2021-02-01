Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C17930A446
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 10:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhBAJVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 04:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbhBAJVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 04:21:22 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CE6C061573
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 01:20:42 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id g15so11665433pgu.9
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 01:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SbMuFSgh3hr3dFklO+f875czdlYyM5GeImwLmAoRm6w=;
        b=ifgKEbl2qJf4cTm77gAQDroic8ArAi72Bw5NaKOmairtEYamHEnBR6T/1YJzNntWrW
         J9VRUdimGea0Dumgw08zuSTRcIBK/J78suy+/732mrFeMUwzits0NxVpsoS2hV7bDmwR
         ocFx60xoUbw4gCcm8Vhw1MYVB6yKItNQSk63s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SbMuFSgh3hr3dFklO+f875czdlYyM5GeImwLmAoRm6w=;
        b=GO9tgXfJhuQirs7UBq52FHu6I1dK5wSCakKACxlMGX6SdLJzFW+h+d2ZVtEyBfI5VD
         5DFhOY5jhMz3qjQnMl0vxPH/1FuXSafBko1sfKY0e1H1KZW1HyMIhk5TAINae+Y3IWDA
         6kE/9D1Yh/eyYhwWKNLctoBGpJ57h/VaP5ICayoRYLi/2//Cz7wRld7QgKpGst7uE93U
         MksI4nwnj/5UKZh5F5zsA7Lwygc41zS7kF+NoqdTTaRV+7vCOvRuvtjyTJxde/JvdeLW
         ClLOcWE6R5PYplDJONWj89gAC0Esbh7oL+X/MU3+WCJR1O1h6fKXIN5jsID2OOYEQnob
         /kqA==
X-Gm-Message-State: AOAM531Ze9KPgz1xB4BEozi5/sy1tftg+FbkqBKAbUty9qPcewTqpJLM
        es4vVbAFAypIieFYahnSfQ25zYsu82Ax3X3ogPQ1+w==
X-Google-Smtp-Source: ABdhPJzSYnS1s6DdHuyZOGevPBj5cK11OSvI0fuN6o/tNl92e+pA2OwmRQgGtb5EyAYza9zj9EE6xURZmN8TYzSx4zc=
X-Received: by 2002:a05:6a00:a8f:b029:1bd:bb89:5911 with SMTP id
 b15-20020a056a000a8fb02901bdbb895911mr15412045pfl.42.1612171241505; Mon, 01
 Feb 2021 01:20:41 -0800 (PST)
MIME-Version: 1.0
References: <1612159064-28413-1-git-send-email-chunfeng.yun@mediatek.com>
In-Reply-To: <1612159064-28413-1-git-send-email-chunfeng.yun@mediatek.com>
From:   Ikjoon Jang <ikjn@chromium.org>
Date:   Mon, 1 Feb 2021 17:20:30 +0800
Message-ID: <CAATdQgCkLxU2ts_dUq5+MnaxQ6RD69zddVKxqPRRZAGG2iq2hA@mail.gmail.com>
Subject: Re: [next PATCH] usb: xhci-mtk: skip dropping bandwidth of unchecked endpoints
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zhanyong Wang <zhanyong.wang@mediatek.com>,
        linux-usb@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Tianping Fang <tianping.fang@mediatek.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

HI Chunfeng,

On Mon, Feb 1, 2021 at 1:58 PM Chunfeng Yun <chunfeng.yun@mediatek.com> wrote:
>
> For those unchecked endpoints, we don't allocate bandwidth for
> them, so no need free the bandwidth, otherwise will decrease
> the allocated bandwidth.
> Meanwhile use xhci_dbg() instead of dev_dbg() to print logs and
> rename bw_ep_list_new as bw_ep_chk_list.
>
> Fixes: 1d69f9d901ef ("usb: xhci-mtk: fix unreleased bandwidth data")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>

Reviewed-and-tested-by: Ikjoon Jang <ikjn@chromium.org>

> ---
>  drivers/usb/host/xhci-mtk-sch.c | 61 ++++++++++++++++++---------------
>  drivers/usb/host/xhci-mtk.h     |  4 ++-
>  2 files changed, 36 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
> index a313e75ff1c6..dee8a329076d 100644
> --- a/drivers/usb/host/xhci-mtk-sch.c
> +++ b/drivers/usb/host/xhci-mtk-sch.c
> @@ -200,6 +200,7 @@ static struct mu3h_sch_ep_info *create_sch_ep(struct usb_device *udev,
>
>         sch_ep->sch_tt = tt;
>         sch_ep->ep = ep;
> +       INIT_LIST_HEAD(&sch_ep->endpoint);
>         INIT_LIST_HEAD(&sch_ep->tt_endpoint);
>
>         return sch_ep;
> @@ -374,6 +375,7 @@ static void update_bus_bw(struct mu3h_sch_bw_info *sch_bw,
>                                         sch_ep->bw_budget_table[j];
>                 }
>         }
> +       sch_ep->allocated = used;

Yes, this is really needed!

>  }
>
>  static int check_sch_tt(struct usb_device *udev,
> @@ -542,6 +544,22 @@ static int check_sch_bw(struct usb_device *udev,
>         return 0;
>  }
>
> +static void destroy_sch_ep(struct usb_device *udev,
> +       struct mu3h_sch_bw_info *sch_bw, struct mu3h_sch_ep_info *sch_ep)
> +{
> +       /* only release ep bw check passed by check_sch_bw() */
> +       if (sch_ep->allocated)
> +               update_bus_bw(sch_bw, sch_ep, 0);

So only these two lines really matter.

> +
> +       list_del(&sch_ep->endpoint);
> +
> +       if (sch_ep->sch_tt) {
> +               list_del(&sch_ep->tt_endpoint);
> +               drop_tt(udev);
> +       }
> +       kfree(sch_ep);
> +}
> +
>  static bool need_bw_sch(struct usb_host_endpoint *ep,
>         enum usb_device_speed speed, int has_tt)
>  {
> @@ -584,7 +602,7 @@ int xhci_mtk_sch_init(struct xhci_hcd_mtk *mtk)
>
>         mtk->sch_array = sch_array;
>
> -       INIT_LIST_HEAD(&mtk->bw_ep_list_new);
> +       INIT_LIST_HEAD(&mtk->bw_ep_chk_list);
>
>         return 0;
>  }
> @@ -636,29 +654,12 @@ int xhci_mtk_add_ep_quirk(struct usb_hcd *hcd, struct usb_device *udev,
>
>         setup_sch_info(udev, ep_ctx, sch_ep);
>
> -       list_add_tail(&sch_ep->endpoint, &mtk->bw_ep_list_new);
> +       list_add_tail(&sch_ep->endpoint, &mtk->bw_ep_chk_list);
>
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(xhci_mtk_add_ep_quirk);
>
> -static void xhci_mtk_drop_ep(struct xhci_hcd_mtk *mtk, struct usb_device *udev,
> -                            struct mu3h_sch_ep_info *sch_ep)
> -{
> -       struct xhci_hcd *xhci = hcd_to_xhci(mtk->hcd);
> -       int bw_index = get_bw_index(xhci, udev, sch_ep->ep);
> -       struct mu3h_sch_bw_info *sch_bw = &mtk->sch_array[bw_index];
> -
> -       update_bus_bw(sch_bw, sch_ep, 0);
> -       list_del(&sch_ep->endpoint);
> -
> -       if (sch_ep->sch_tt) {
> -               list_del(&sch_ep->tt_endpoint);
> -               drop_tt(udev);
> -       }
> -       kfree(sch_ep);
> -}
> -
>  void xhci_mtk_drop_ep_quirk(struct usb_hcd *hcd, struct usb_device *udev,
>                 struct usb_host_endpoint *ep)
>  {
> @@ -688,9 +689,8 @@ void xhci_mtk_drop_ep_quirk(struct usb_hcd *hcd, struct usb_device *udev,
>         sch_bw = &sch_array[bw_index];
>
>         list_for_each_entry_safe(sch_ep, tmp, &sch_bw->bw_ep_list, endpoint) {
> -               if (sch_ep->ep == ep) {
> -                       xhci_mtk_drop_ep(mtk, udev, sch_ep);
> -               }
> +               if (sch_ep->ep == ep)
> +                       destroy_sch_ep(udev, sch_bw, sch_ep);

not so critical but I've also missed 'break' here.
Can you please add a break statement here?

>         }
>  }
>  EXPORT_SYMBOL_GPL(xhci_mtk_drop_ep_quirk);
> @@ -704,9 +704,9 @@ int xhci_mtk_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
>         struct mu3h_sch_ep_info *sch_ep, *tmp;
>         int bw_index, ret;
>
> -       dev_dbg(&udev->dev, "%s\n", __func__);
> +       xhci_dbg(xhci, "%s() udev %s\n", __func__, dev_name(&udev->dev));
>
> -       list_for_each_entry(sch_ep, &mtk->bw_ep_list_new, endpoint) {
> +       list_for_each_entry(sch_ep, &mtk->bw_ep_chk_list, endpoint) {
>                 bw_index = get_bw_index(xhci, udev, sch_ep->ep);
>                 sch_bw = &mtk->sch_array[bw_index];
>
> @@ -717,7 +717,7 @@ int xhci_mtk_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
>                 }
>         }
>
> -       list_for_each_entry_safe(sch_ep, tmp, &mtk->bw_ep_list_new, endpoint) {
> +       list_for_each_entry_safe(sch_ep, tmp, &mtk->bw_ep_chk_list, endpoint) {
>                 struct xhci_ep_ctx *ep_ctx;
>                 struct usb_host_endpoint *ep = sch_ep->ep;
>                 unsigned int ep_index = xhci_get_endpoint_index(&ep->desc);
> @@ -746,12 +746,17 @@ EXPORT_SYMBOL_GPL(xhci_mtk_check_bandwidth);
>  void xhci_mtk_reset_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
>  {
>         struct xhci_hcd_mtk *mtk = hcd_to_mtk(hcd);
> +       struct xhci_hcd *xhci = hcd_to_xhci(hcd);
> +       struct mu3h_sch_bw_info *sch_bw;
>         struct mu3h_sch_ep_info *sch_ep, *tmp;
> +       int bw_index;
>
> -       dev_dbg(&udev->dev, "%s\n", __func__);
> +       xhci_dbg(xhci, "%s() udev %s\n", __func__, dev_name(&udev->dev));
>
> -       list_for_each_entry_safe(sch_ep, tmp, &mtk->bw_ep_list_new, endpoint) {
> -               xhci_mtk_drop_ep(mtk, udev, sch_ep);
> +       list_for_each_entry_safe(sch_ep, tmp, &mtk->bw_ep_chk_list, endpoint) {
> +               bw_index = get_bw_index(xhci, udev, sch_ep->ep);
> +               sch_bw = &mtk->sch_array[bw_index];
> +               destroy_sch_ep(udev, sch_bw, sch_ep);
>         }
>
>         xhci_reset_bandwidth(hcd, udev);
> diff --git a/drivers/usb/host/xhci-mtk.h b/drivers/usb/host/xhci-mtk.h
> index 577f431c5c93..cbb09dfea62e 100644
> --- a/drivers/usb/host/xhci-mtk.h
> +++ b/drivers/usb/host/xhci-mtk.h
> @@ -59,6 +59,7 @@ struct mu3h_sch_bw_info {
>   * @ep_type: endpoint type
>   * @maxpkt: max packet size of endpoint
>   * @ep: address of usb_host_endpoint struct
> + * @allocated: the bandwidth is aready allocated from bus_bw
>   * @offset: which uframe of the interval that transfer should be
>   *             scheduled first time within the interval
>   * @repeat: the time gap between two uframes that transfers are
> @@ -86,6 +87,7 @@ struct mu3h_sch_ep_info {
>         u32 ep_type;
>         u32 maxpkt;
>         void *ep;
> +       bool allocated;
>         /*
>          * mtk xHCI scheduling information put into reserved DWs
>          * in ep context
> @@ -130,8 +132,8 @@ struct mu3c_ippc_regs {
>  struct xhci_hcd_mtk {
>         struct device *dev;
>         struct usb_hcd *hcd;
> -       struct list_head bw_ep_list_new;
>         struct mu3h_sch_bw_info *sch_array;
> +       struct list_head bw_ep_chk_list;
>         struct mu3c_ippc_regs __iomem *ippc_regs;
>         bool has_ippc;
>         int num_u2_ports;
> --
> 2.18.0
> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek
