Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88DB62D093
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 02:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbiKQBXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 20:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiKQBXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 20:23:19 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A5E68C43;
        Wed, 16 Nov 2022 17:23:18 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id p4so110933vsa.11;
        Wed, 16 Nov 2022 17:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/7xKUMGGimUYtJgHLPWFAyDYCp5vd1aYTbMEmjYh3+I=;
        b=mN1jHmpN8E1dh7RItO9CyHzhnzTdIIBGFSlacYTp6ak7RRJ3IhziTdNZVgA6QWWcoN
         ADd3ZOduofY/peCyNz+FIyNdIzFjILG8ZzWYSadC0PkMpjDmEIrufdO60uQj2vHs1bKv
         PmkqEZ2w8gsm7b8ZKETyGP+ZclllROWHSL0wyv8Jq1lH1EZQSFY1DOYiiYgwh68jF/9H
         NGjsBu9SZbE1Ise0mYsHfT+hlmjjaOW1CKYAslFU3Nq1+nbQdBlM0/pF1B+EJnk6zDCS
         I3r7COZvkSmX04L3MgbXJrMRIqk8f0JuEOcq0/P+zQpX9xk9E4QxSvDbvIuh6fo8rdbx
         Xyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/7xKUMGGimUYtJgHLPWFAyDYCp5vd1aYTbMEmjYh3+I=;
        b=0JCIQQyzfM8Zxznz8mM9wyA34RhVFuHJe8KQt1CGxuMxP6n1Gh/csxh0WU9gKWqd1T
         9D8Vo8HwEFYeioELoYbGeJmiWXlCQ9ZkiPjdae2i1gnSFLH4ddBvuVb3nz4Yz+pfVKF0
         vrr2a4dOS4o7/CWFA++qep8WOv4hBdAK02MpK/aAuQhc7jyBRhE5eevKNYm6JF+PqdwR
         8xoGladItFlxbqIqX9BF5WMVZzs5kzfkldFGGQK7qmsa0PxS1BX+uISmHrdUjVAa4k/J
         Q8+ozEXm3WndEwTRhQFO6/ji7SboSUPCOKxRyJR/b++KCyBkS7IWj4UZdC0oIyXrkNKL
         0pSA==
X-Gm-Message-State: ANoB5plNfQhGkRgZjDCetbd7kZr7SEVJBFdK3QQpxcls2TfbPKTGeEUq
        90Q35+eT8s1M519ghy8H3FASGeqCkEWsWtYKIT2rNHSWOuA=
X-Google-Smtp-Source: AA0mqf4PYta2i51gBc6838T30dAQNpkuvm8cz95Bw9VchHeTHSq8F4L007Q556tdh2nFgHmzCm+iBRcydjZY6H1+Axo=
X-Received: by 2002:a05:6102:30b1:b0:3aa:8da6:44c0 with SMTP id
 y17-20020a05610230b100b003aa8da644c0mr607589vsd.20.1668648197975; Wed, 16 Nov
 2022 17:23:17 -0800 (PST)
MIME-Version: 1.0
References: <20221115092218.421267-1-pawell@cadence.com>
In-Reply-To: <20221115092218.421267-1-pawell@cadence.com>
From:   Peter Chen <hzpeterchen@gmail.com>
Date:   Thu, 17 Nov 2022 09:22:09 +0800
Message-ID: <CAL411-qwcboX-vTn+3oOPna+tixFNEajYi_E_rgweqrC3CcXCA@mail.gmail.com>
Subject: Re: [PATCH v3] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     peter.chen@kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 15, 2022 at 5:22 PM Pawel Laszczak <pawell@cadence.com> wrote:
>
> Patch modifies the TD_SIZE in TRB before ZLP TRB.
> The TD_SIZE in TRB before ZLP TRB must be set to 1 to force
> processing ZLP TRB by controller.
>
> cc: <stable@vger.kernel.org>
> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
> v2:
> - returned value for last TRB must be 0
> v3:
> - fix issue for request->length > 64KB
>
>  drivers/usb/cdns3/cdnsp-ring.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
> index 794e413800ae..86e1141e150f 100644
> --- a/drivers/usb/cdns3/cdnsp-ring.c
> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> @@ -1763,10 +1763,15 @@ static u32 cdnsp_td_remainder(struct cdnsp_device *pdev,
>                               int trb_buff_len,
>                               unsigned int td_total_len,
>                               struct cdnsp_request *preq,
> -                             bool more_trbs_coming)
> +                             bool more_trbs_coming,
> +                             bool zlp)
>  {
>         u32 maxp, total_packet_count;
>
> +       /* Before ZLP driver needs set TD_SIZE = 1. */
> +       if (zlp)
> +               return 1;
> +

Pawel, with your change, the TD_SIZE is 1 or 0, but not like the
kernel doc defined like below:

/*
 * TD size is the number of max packet sized packets remaining in the TD
 * (*not* including this TRB).
 *
 * Total TD packet count = total_packet_count =
 *     DIV_ROUND_UP(TD size in bytes / wMaxPacketSize)
 *
 * Packets transferred up to and including this TRB = packets_transferred =
 *     rounddown(total bytes transferred including this TRB / wMaxPacketSize)
 *
 * TD size = total_packet_count - packets_transferred
 *
 * It must fit in bits 21:17, so it can't be bigger than 31.
 * This is taken care of in the TRB_TD_SIZE() macro
 *
 * The last TRB in a TD must have the TD size set to zero.
 */

Peter

>         /* One TRB with a zero-length data packet. */
>         if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
>             trb_buff_len == td_total_len)
> @@ -1960,7 +1965,8 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
>                 /* Set the TRB length, TD size, and interrupter fields. */
>                 remainder = cdnsp_td_remainder(pdev, enqd_len, trb_buff_len,
>                                                full_len, preq,
> -                                              more_trbs_coming);
> +                                              more_trbs_coming,
> +                                              zero_len_trb);
>
>                 length_field = TRB_LEN(trb_buff_len) | TRB_TD_SIZE(remainder) |
>                         TRB_INTR_TARGET(0);
> @@ -2025,7 +2031,7 @@ int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
>
>         if (preq->request.length > 0) {
>                 remainder = cdnsp_td_remainder(pdev, 0, preq->request.length,
> -                                              preq->request.length, preq, 1);
> +                                              preq->request.length, preq, 1, 0);
>
>                 length_field = TRB_LEN(preq->request.length) |
>                                 TRB_TD_SIZE(remainder) | TRB_INTR_TARGET(0);
> @@ -2225,7 +2231,7 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
>                 /* Set the TRB length, TD size, & interrupter fields. */
>                 remainder = cdnsp_td_remainder(pdev, running_total,
>                                                trb_buff_len, td_len, preq,
> -                                              more_trbs_coming);
> +                                              more_trbs_coming, 0);
>
>                 length_field = TRB_LEN(trb_buff_len) | TRB_INTR_TARGET(0);
>
> --
> 2.25.1
>
