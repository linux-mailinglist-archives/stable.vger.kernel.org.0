Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A2764D916
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 10:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiLOJyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 04:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbiLOJyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 04:54:17 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF5255A97;
        Thu, 15 Dec 2022 01:53:57 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id u12so2430196wrr.11;
        Thu, 15 Dec 2022 01:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TS4H46NJpKIj1mAjET3pDVRzVrVVAnQzfGePBLuHEEg=;
        b=ZqJFprCq+Pg1srwp6w/JzB1GLa3p2KdoQWKODfSXiJP6YO7pWBVLYhpN8kw6S5kHlo
         71TGFPTVu+Z8Z4vQSAL/o/huHn1XkBxQwc0QY603hx8ZEnN6BE8pAno8ih2qo9SfyMeX
         F46caq2Or5gwlGTEUUKmyLDxPlxKtKAN9yksViMYDpeaaWvJpZSiLytCLqAlZiOgEQce
         R4yq6e8O6m0gBylvcqTwwA8Alb2t5O/+3k3YqIyP65kkrNpvOv75NoukMJ1fWpv/negS
         4alqGGYmG2EqsusDicr8dlERLVXT5ufMrhnGhid2+SbUOvjtlTV7fiwoOm7sGn1J3xoi
         t2jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TS4H46NJpKIj1mAjET3pDVRzVrVVAnQzfGePBLuHEEg=;
        b=FJ7mPpYWW/IkLG3FdjrM8JgxBgKk+kJTOAuNuQlD93HS6loMswaCqIAEoN32bvVXqd
         MIefc18AegAWLw4HqrU3yj9Z1xcp8cRoO2sKmF4WCaZqInU5+H6X1fnAIqGSVZORWxsY
         NWDKnHV2LV9T+IwwH7KWSABDgxPJGq6qqIyqozMmiCPFWQ+zVyOM079T9xdnMMTZjVds
         Wh9oOgd4bkUx/UNL7IFCPZgEZFOrbstpcDoxhRuCbi9tlLwe96Se/Bnm6pHjb9pzvQE/
         fXZR7n6oUvzTiVUxPSjoo/Yo+NTn0QNGWtIJ8ct6uwkRLtAEJ0krpKQb4ZwUgXiCHnQ1
         Sucw==
X-Gm-Message-State: ANoB5pk6E/RiPlZQW9Kj1sFbo4WHBJp5nNkEwmgslA0y8x4my5ItFuqA
        b4hII9uOFrOEJ3fICVO89/j/C8SaPIcmMK5s7G4=
X-Google-Smtp-Source: AA0mqf57PEcCvncPREwZ/GRgdbbmcI0IPPgF7N2rlcyfdkFtxDFVyJLs55NGC9hcWER4/t2A5vW83V2+rhPR/banfXw=
X-Received: by 2002:a5d:6d84:0:b0:242:4ba2:312c with SMTP id
 l4-20020a5d6d84000000b002424ba2312cmr15308125wrs.406.1671098035745; Thu, 15
 Dec 2022 01:53:55 -0800 (PST)
MIME-Version: 1.0
References: <1671096096-20307-1-git-send-email-u0084500@gmail.com> <Y5rsdo/SGHJM4UKG@kroah.com>
In-Reply-To: <Y5rsdo/SGHJM4UKG@kroah.com>
From:   ChiYuan Huang <u0084500@gmail.com>
Date:   Thu, 15 Dec 2022 17:53:44 +0800
Message-ID: <CADiBU3-iVLQf6Q5SzOB_pMCs2PGcFuWryjpDn5Qvz41WQ6C2RA@mail.gmail.com>
Subject: Re: [PATCH] usb: typec: tcpm: Fix altmode re-registration causes
 sysfs create fail
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux@roeck-us.net, heikki.krogerus@linux.intel.com,
        matthias.bgg@gmail.com, tommyyl.chen@mediatek.com,
        macpaul.lin@mediatek.com, gene_chen@richtek.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        ChiYuan Huang <cy_huang@richtek.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> =E6=96=BC 2022=E5=B9=B412=E6=9C=8815=
=E6=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=885:44=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
> On Thu, Dec 15, 2022 at 05:21:36PM +0800, cy_huang wrote:
> > From: ChiYuan Huang <cy_huang@richtek.com>
>
> Why not send directly from this address so we can validate that this is
> the correct email address of yours?
>
It's  the company mailbox policy. To send the external mail, there's
the security text block at the bottom.
Except this, some mail address are also blocked. To avoid this, I use
my personal mail to send the patch
and leave the SoB for the Richtek mailbox.
It's lazy to fight for this.

Sorry for the inconvinence.

> thanks,
>
> greg k-h
