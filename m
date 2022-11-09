Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C57622E33
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 15:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiKIOoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 09:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiKIOoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 09:44:11 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20E2186EB;
        Wed,  9 Nov 2022 06:44:09 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id l190so16732400vsc.10;
        Wed, 09 Nov 2022 06:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Pd3oCLn1GKk4PquKayZllpj3KkafLGWk7nWdgAL1e1Q=;
        b=SNhfXW7DsOWLFsYLC55azBYl0sk5kMq1wYeALdVSIOTR7CrbGXE7cLcER54edpbFAV
         Ufq/ULlrBM0UDVysT4m8CR/bpjJBFlk7mp7Auy1UTJjj4VqXMJS0Nk6U01U9vwbsphTN
         2fAPwt2XlJGDvDBHBAiy5UI5Ck3mkhhu0QuA6v34pyiDaIi8o2uULuSvjxJhiVfX+hnp
         AYZXnRPWtl7mai2DLNS/FkTK6AhfYub9PjmHQ2J7bamLOOdpCOpR+80dYdakFlf153ZW
         qKxR9brYh5DjBfs7L3qSHK0iHmex012ILrNfKN6NxlHzYsRIzdQ/A9kFs9q9Uq54j8zt
         N89w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pd3oCLn1GKk4PquKayZllpj3KkafLGWk7nWdgAL1e1Q=;
        b=DakOjKjHGO6hsJb/lBn/lBdN7h3ZHl9R8m0TFP/uHlgth1Myks8C9f1NcY2e9I6nvr
         TJl5N1WDdNHdoXR3Rm8qISBScM0lp9neOu+Fxt/3ROVvgbxIYKBdPZpDHlRyq0T+JhR+
         uLM54bhKd4OGN67f8SfI75wmAoQSDMlvnGFTfYBSVVq+pZlVsvuCLfnrova9CLf6oNRG
         WjnaAlV7sTv/+UC2WqGVNhl4RTKOgQzkEUKnRSOO885/r8e0IZ+bRO88PA/WDDG1CVZ4
         F1YcDlaSw+5p2Z4JFg4ySNApaujcyUUsucKlNzhWuZTuyv8HNwmBLvhSX950rW6GJm7a
         3Ffg==
X-Gm-Message-State: ACrzQf2cxEUwzysJbycnQTFv1NzuUjP3PbIPPEphLYn0mlVxKbwxDJ2z
        OGiU+UKW2a7STtdgzKRvKpyf8i0bWIST+ZelwYQ/BQt6
X-Google-Smtp-Source: AMsMyM4RFlhx8Oigq3QssJQ8TvCY/9/mUUXM9K82HK3ax46rGx/SbmF1FLe/QBfFZPFztNFikj8AhihgjxZ+AN5UPKA=
X-Received: by 2002:a67:dc18:0:b0:3aa:4149:510c with SMTP id
 x24-20020a67dc18000000b003aa4149510cmr31149048vsj.20.1668005048879; Wed, 09
 Nov 2022 06:44:08 -0800 (PST)
MIME-Version: 1.0
References: <20221026093710.449809-1-pawell@cadence.com>
In-Reply-To: <20221026093710.449809-1-pawell@cadence.com>
From:   Peter Chen <hzpeterchen@gmail.com>
Date:   Wed, 9 Nov 2022 22:43:06 +0800
Message-ID: <CAL411-qwmC8xuZUtrrVjtiiyaD-aLamO6GJAeMbLd1X73UDSmQ@mail.gmail.com>
Subject: Re: [PATCH] usb: cdnsp: Fix issue with Clear Feature Halt Endpoint
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

On Wed, Oct 26, 2022 at 5:37 PM Pawel Laszczak <pawell@cadence.com> wrote:
>
> During handling Clear Halt Endpoint Feature request driver invokes

Add "," between request and driver. Otherwise, it is okay for me.

Reviewed-by: Peter Chen <peter.chen@kernel.org>

Peter

> Reset Endpoint command. Because this command has some issue with
> transition endpoint from Running to Idle state the driver must
> stop the endpoint by using Stop Endpoint command.
>
> cc: <stable@vger.kernel.org>
> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/cdnsp-gadget.c | 12 ++++--------
>  drivers/usb/cdns3/cdnsp-ring.c   |  3 ++-
>  2 files changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
> index e2e7d16f43f4..0576f9b0e4aa 100644
> --- a/drivers/usb/cdns3/cdnsp-gadget.c
> +++ b/drivers/usb/cdns3/cdnsp-gadget.c
> @@ -600,11 +600,11 @@ int cdnsp_halt_endpoint(struct cdnsp_device *pdev,
>
>         trace_cdnsp_ep_halt(value ? "Set" : "Clear");
>
> -       if (value) {
> -               ret = cdnsp_cmd_stop_ep(pdev, pep);
> -               if (ret)
> -                       return ret;
> +       ret = cdnsp_cmd_stop_ep(pdev, pep);
> +       if (ret)
> +               return ret;
>
> +       if (value) {
>                 if (GET_EP_CTX_STATE(pep->out_ctx) == EP_STATE_STOPPED) {
>                         cdnsp_queue_halt_endpoint(pdev, pep->idx);
>                         cdnsp_ring_cmd_db(pdev);
> @@ -613,10 +613,6 @@ int cdnsp_halt_endpoint(struct cdnsp_device *pdev,
>
>                 pep->ep_state |= EP_HALTED;
>         } else {
> -               /*
> -                * In device mode driver can call reset endpoint command
> -                * from any endpoint state.
> -                */
>                 cdnsp_queue_reset_ep(pdev, pep->idx);
>                 cdnsp_ring_cmd_db(pdev);
>                 ret = cdnsp_wait_for_cmd_compl(pdev);
> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
> index 25e5e51cf5a2..aa79bce89d8a 100644
> --- a/drivers/usb/cdns3/cdnsp-ring.c
> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> @@ -2081,7 +2081,8 @@ int cdnsp_cmd_stop_ep(struct cdnsp_device *pdev, struct cdnsp_ep *pep)
>         u32 ep_state = GET_EP_CTX_STATE(pep->out_ctx);
>         int ret = 0;
>
> -       if (ep_state == EP_STATE_STOPPED || ep_state == EP_STATE_DISABLED) {
> +       if (ep_state == EP_STATE_STOPPED || ep_state == EP_STATE_DISABLED ||
> +           ep_state == EP_STATE_HALTED) {
>                 trace_cdnsp_ep_stopped_or_disabled(pep->out_ctx);
>                 goto ep_stopped;
>         }
> --
> 2.25.1
>
