Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C1E5A7042
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 00:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbiH3WB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 18:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiH3WBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 18:01:21 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F39027FF6
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 14:57:07 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id by6so12762690ljb.11
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 14:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=1fa8H+/zqrg4rLek0JWMSXHGxEPhsU7TtoF+0YlZ8IY=;
        b=c06NVwVMTCHcZQzC0mXtuVOLzYez/z0qCP+KjabYfFBW4cLFDPX8svVAFfy/H73v6C
         9SfRL3nSJwQ/kb+BAFQK+M8w7sBcvpxd/njeFI6eX6V1aIEnFh9ZKirX/lVBG0okGhZP
         uvrFqHWmpkewfeJwC/5EB7ICVB2g/EzZ9KD1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=1fa8H+/zqrg4rLek0JWMSXHGxEPhsU7TtoF+0YlZ8IY=;
        b=6HI9mimWzXVVr3touFP4zsMzOKpbtO0OWtBhHAq0dCqpP2DstMxTgHfl4YYgWD4iLF
         soDXZKTMm6xkvW7yPEuA9XF4dcjpS1IVftYxa+9zp3L8wUyImQpdEj7nDSpPPGEKGAfJ
         h3jxfvLz9NGLcMI60vNR9RunUA1NUFx1E2XGZ6nZhFWsoztOQ0fW51tk+wbR+VKfZI80
         IFaHzL2Uk+y7qva7VIQhQwNIfV8x8TXkIbf91omIMjsjCb2X7mwBnLhA69AkKK34Z1PN
         ed00WWUgOqO3f8I7BSofHJZ63WaRp4EbxZlq4EHIloe1a165xu0+C5ayB2UnZsZXEVYE
         cNkQ==
X-Gm-Message-State: ACgBeo1mO3PiTkZFw6fuBVI4b5qjRuGH3mdV52Ux67lN5ozbxABuPj68
        8/bkEz+fQOqsH7uusLhod7pEXJnc6+FeAigs
X-Google-Smtp-Source: AA6agR4H3gswGPv/xOyde2gz4BwXnbK0otWeed+0c3uzNOBCjjDRbJhzcqPtZdY3sHuFSekW7ST1Pg==
X-Received: by 2002:a2e:bf11:0:b0:261:9343:fb2 with SMTP id c17-20020a2ebf11000000b0026193430fb2mr7711999ljr.47.1661896625235;
        Tue, 30 Aug 2022 14:57:05 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id q2-20020a056512210200b0048b0696d0b1sm216323lfr.90.2022.08.30.14.57.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 14:57:04 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id z25so17385858lfr.2
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 14:57:03 -0700 (PDT)
X-Received: by 2002:a05:6512:1308:b0:492:a402:ce64 with SMTP id
 x8-20020a056512130800b00492a402ce64mr7699025lfu.607.1661896623331; Tue, 30
 Aug 2022 14:57:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200527165718.129307-1-briannorris@chromium.org>
 <YmPadTu8CfEARfWs@xps> <CA+ASDXPeJ6fD9hvc0Nq_RY05YRdSP77U_96vUZcTYgkQKY9Bvg@mail.gmail.com>
 <CAG2Q2vXce2V3Y6MnPhV6obcNWyQzyusMTL=5oCQLRNh2_ffNYA@mail.gmail.com> <CAG2Q2vXFcSVwF4CbU5o3VP1MWwrdqrZjTHgfBj_Q0t3nNipJRw@mail.gmail.com>
In-Reply-To: <CAG2Q2vXFcSVwF4CbU5o3VP1MWwrdqrZjTHgfBj_Q0t3nNipJRw@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 30 Aug 2022 14:56:51 -0700
X-Gmail-Original-Message-ID: <CA+ASDXNx30A3=BA9b-tiAQzYHP=nV_eLw1QFpJij=F=JgWZ5sg@mail.gmail.com>
Message-ID: <CA+ASDXNx30A3=BA9b-tiAQzYHP=nV_eLw1QFpJij=F=JgWZ5sg@mail.gmail.com>
Subject: Re: [PATCH] Revert "ath: add support for special 0x0 regulatory domain"
To:     Cale Collins <ccollins@gateworks.com>
Cc:     kvalo@kernel.org, Patrick Steinhardt <ps@pks.im>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        Stephen McCarthy <stephen.mccarthy@pctel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Cale,

I meant to respond a while back, but didn't get around to it, sorry.
In case it's still helpful:

On Wed, May 11, 2022 at 3:52 PM Cale Collins <ccollins@gateworks.com> wrote:
> On Mon, May 9, 2022 at 11:16 AM Cale Collins <ccollins@gateworks.com> wrote:
> > I'm experiencing an issue very similar to this.  The regulatory domain
> > settings wouldn't allow me to create an AP on 5ghz bands on kernels
> > newer than 5.10 when using a WLE900VX (QCA9984) radio.  I bisected the
> > kernel and ultimately landed on the regression that Brian patched.

If the revert broke you, then you were also broken before v5.6. This
patch only landed in v5.6-rc1:

2dc016599cfa ath: add support for special 0x0 regulatory domain

I'm not really an expert on the wide variety of ath-related hardware
production, but given the many people complaining about the existence
of the non-reverted patch, it seemed like a revert was the best way
forward -- don't break those that weren't already broken pre-5.6.

> > root@focal-ventana:~# iw reg get
> > global
> > country 00: DFS-UNSET
> >     (2402 - 2472 @ 40), (N/A, 20), (N/A)
> >     (2457 - 2482 @ 20), (N/A, 20), (N/A), AUTO-BW, NO-IR
> >     (2474 - 2494 @ 20), (N/A, 20), (N/A), NO-OFDM, NO-IR
> >     (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW, NO-IR
> >     (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW, NO-IR
> >     (5490 - 5730 @ 160), (N/A, 20), (0 ms), DFS, NO-IR
> >     (5735 - 5835 @ 80), (N/A, 20), (N/A), NO-IR
> >     (57240 - 63720 @ 2160), (N/A, 0), (N/A)
> >
> > phy#0
> > country 99: DFS-UNSET
> >     (2402 - 2472 @ 40), (N/A, 20), (N/A)
> >     (5140 - 5360 @ 80), (N/A, 30), (N/A), PASSIVE-SCAN
> >     (5715 - 5860 @ 80), (N/A, 30), (N/A), PASSIVE-SCAN

Unless there's some other bug hidden in here in how we're reading
EEPROM settings, it sounds like you have a badly-provisioned PCI
module, with no EEPROM country code. Thus, the driver has to
conservatively treat you as a very-limited "world roaming" regulatory
class, which mostly disables 5GHz, or at least doesn't let you
initiate much radiation on your own (which basically eliminates AP
mode).

The "fix" there would be to get a different, correctly-provisioned
(for your regulatory domain) module.

Also, I didn't notice until today: technically, you also could be
retrieving your incorrect country code info from ACPI; but if you're
using a typical ARM board like claimed, it's unlikely you're using
ACPI.

Somewhat of a sidetrack: The existence of ACPI override support does
suggest that perhaps there's some room for a Device Tree property, so
one can set their regulatory domain on a per-board basis. I've
definitely known some downstream product makers use that sort of
approach -- and that very "solution" is potentially why some devices
don't get a valid EEPROM (if the manufacturer could hack the drivers,
why bother getting the EEPROM right?), and therefore don't work
correctly with upstream kernels... Unfortunately, that kind of
solution is hard to deploy 100% correctly for upstream Linux, because
the Device Tree would need to change depending on which country the
affected system is shipped to. It's easier to get those things right
in a pre-flashed firmware or an EEPROM; it's harder to get those in a
software DTS file shipped to everyone in the mainline kernel sources.

> > #dmesg |grep ath output

In the slim chance there's something else going on in the driver, you
might try to capture logs with ATH10K_DBG_BOOT and
ATH10K_DBG_REGULATORY logging enabled. That could look something like:

echo 0x820 > /sys/module/ath10k_core/parameters/debug_mask
rmmod ath10k_pci
modprobe ath10k_pci
dmesg | grep ath

Brian
