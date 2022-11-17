Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D512662D328
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 07:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbiKQGEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 01:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbiKQGD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 01:03:59 -0500
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E586D12A8F;
        Wed, 16 Nov 2022 22:03:58 -0800 (PST)
Received: by mail-ua1-x936.google.com with SMTP id 97so247358uam.0;
        Wed, 16 Nov 2022 22:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G28Rt+EetBjrxyZcHJjZdVZZs1sU8FxpkLuTAymdxMM=;
        b=c6LKeOUObpXFOqrhlmriDmjn9jRw13wAbM/2VlwIs2mg2wVLYAm69iHn0qGTIjSQ/s
         x+Uk0hMjgeV7R3Lox9LwEKqb+5zBFbD1etKP1gkXCd4aFRW0tV6Vz5bIlChpx3EGxgUf
         B9NCVyfhTEKLKji4DmKIgpbhqiT4gvhdvxX/y/WXiPr7mow+ZSSmHLh+AxcJSYV3IOkt
         aPXoaDzzh+Lg2M6V60ipKwIoR5Am8v9dVlAVJmgIeUoW12W1MRR/EZH6Mrj4NFpNEURk
         Naz7Br8eCjYPPocWZoQ3/AaVpiQBkcqIVZeG+7dCHHwT8+8W/y4WSJtnPzJjWbv6BlnS
         P3fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G28Rt+EetBjrxyZcHJjZdVZZs1sU8FxpkLuTAymdxMM=;
        b=lOJa6slGjS/30u+m7u0zQmeIJmphdEfv8TSvdWUtKqRcpPWF3FHOk+T5/6zxu7/+Yw
         2SCgv2hDAySiRchRVigcKf9hmBemDcyer8H2oEO5P5yXdDyYNIqv4e/5RQ8hWgOmmF4N
         /ilsgxI0BsySKtNyd4C1onQiottM81CBt+SwxKDahitVJ93l8ZIgZq4djsnTbrYytdEu
         NdzFS8fj5JOy9yzFuCCLYuzOVuW4vXy86xxBwmfggsP2WpBgIXYJG55vBjMa2m48os2x
         OR7xk/wVyLtkDeOoyroIgJRmzge9wwRgiJ2BfS3WXt5Q4BOLSTRvVm6CtlA0qwwHM9nS
         BuPQ==
X-Gm-Message-State: ANoB5pla7j5AkrcbluH0aLVAe2JXKHsUkM36B5FeSrjmWG1izsfFdbkl
        vu+35m6AAfrS+vqHa4ec0XTa9gtqNxCiW08Zqc0=
X-Google-Smtp-Source: AA0mqf4t6/ZBQFElflxxAGxstkcBQNcPJk8jYrUatZtIykDQ/09oObo2j1m2OEyThdJTmWpQCkwwHlQJ+BcEBxmMt4o=
X-Received: by 2002:ab0:b06:0:b0:3b8:4a1a:5a63 with SMTP id
 b6-20020ab00b06000000b003b84a1a5a63mr336281uak.110.1668665038029; Wed, 16 Nov
 2022 22:03:58 -0800 (PST)
MIME-Version: 1.0
References: <20221115092218.421267-1-pawell@cadence.com> <CAL411-qwcboX-vTn+3oOPna+tixFNEajYi_E_rgweqrC3CcXCA@mail.gmail.com>
In-Reply-To: <CAL411-qwcboX-vTn+3oOPna+tixFNEajYi_E_rgweqrC3CcXCA@mail.gmail.com>
From:   Peter Chen <hzpeterchen@gmail.com>
Date:   Thu, 17 Nov 2022 14:02:48 +0800
Message-ID: <CAL411-pZm_8M4gSXJQ4zC1F-1w4zfTS2JRzxRM2e-ZQFjsx_Uw@mail.gmail.com>
Subject: Re: [PATCH v3] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     peter.chen@kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Pawel, with your change, the TD_SIZE is 1 or 0, but not like the
> kernel doc defined like below:
>

Please omit my comments, I did not check the code carefully.

> /*
>  * TD size is the number of max packet sized packets remaining in the TD
>  * (*not* including this TRB).
>  *

With your current change, it may work. But your change conflicts with
the xHCI spec that described above.
With ZLP, the last useful trb's TD size should be 0, but if it is 0,
the controller will be confused.

With your change, it makes the code more different with xhci's. Do you
consider handling ZLP packet at
another TD instead of current at the same TD=EF=BC=9F

Peter

>  * Total TD packet count =3D total_packet_count =3D
>  *     DIV_ROUND_UP(TD size in bytes / wMaxPacketSize)
>  *
>  * Packets transferred up to and including this TRB =3D packets_transferr=
ed =3D
>  *     rounddown(total bytes transferred including this TRB / wMaxPacketS=
ize)
>  *
>  * TD size =3D total_packet_count - packets_transferred
>  *
>  * It must fit in bits 21:17, so it can't be bigger than 31.
>  * This is taken care of in the TRB_TD_SIZE() macro
>  *
>  * The last TRB in a TD must have the TD size set to zero.
>  */
>
> Peter
>
> >         /* One TRB with a zero-length data packet. */
> >         if (!more_trbs_coming || (transferred =3D=3D 0 && trb_buff_len =
=3D=3D 0) ||
> >             trb_buff_len =3D=3D td_total_len)
> > @@ -1960,7 +1965,8 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev=
, struct cdnsp_request *preq)
> >                 /* Set the TRB length, TD size, and interrupter fields.=
 */
> >                 remainder =3D cdnsp_td_remainder(pdev, enqd_len, trb_bu=
ff_len,
> >                                                full_len, preq,
> > -                                              more_trbs_coming);
> > +                                              more_trbs_coming,
> > +                                              zero_len_trb);
> >
> >                 length_field =3D TRB_LEN(trb_buff_len) | TRB_TD_SIZE(re=
mainder) |
> >                         TRB_INTR_TARGET(0);
> > @@ -2025,7 +2031,7 @@ int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev=
, struct cdnsp_request *preq)
> >
> >         if (preq->request.length > 0) {
> >                 remainder =3D cdnsp_td_remainder(pdev, 0, preq->request=
.length,
> > -                                              preq->request.length, pr=
eq, 1);
> > +                                              preq->request.length, pr=
eq, 1, 0);
> >
> >                 length_field =3D TRB_LEN(preq->request.length) |
> >                                 TRB_TD_SIZE(remainder) | TRB_INTR_TARGE=
T(0);
> > @@ -2225,7 +2231,7 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_devic=
e *pdev,
> >                 /* Set the TRB length, TD size, & interrupter fields. *=
/
> >                 remainder =3D cdnsp_td_remainder(pdev, running_total,
> >                                                trb_buff_len, td_len, pr=
eq,
> > -                                              more_trbs_coming);
> > +                                              more_trbs_coming, 0);
> >
> >                 length_field =3D TRB_LEN(trb_buff_len) | TRB_INTR_TARGE=
T(0);
> >
> > --
> > 2.25.1
> >
