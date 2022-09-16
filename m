Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB0D5BB48A
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 00:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiIPWzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 18:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiIPWzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 18:55:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B04CABF2F;
        Fri, 16 Sep 2022 15:55:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35D2362DD1;
        Fri, 16 Sep 2022 22:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A05C43470;
        Fri, 16 Sep 2022 22:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663368950;
        bh=CxePb5gSHUo+VC915HSKvQFTvB1YDl7G7mETr2pEKdM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bQLRcpJO4wQpxuKyGPt8hrvOCf0+UCyiCoUTiiNwv/aIhNN2dBjfLe9+QF/vrP3qz
         yETSihoSo2NYig77KvTY3XH/HlCWIokQfpFPLYX8Qv2gyRTME+saS6Ot3RD4E39+2u
         ZbzrYBduaPFhF8M4EDAqy/Ag9+IysO1rAr4ocN5mjDDjZk2rQaERZC+Ey8RuAkZcv8
         jATd6s/+YmiMLcTLj/AGvyq1gL5PLUo0akM3FuoXQ9eliemMvzjswZ1xUJIzWfcw+o
         xxagVoK8vIdeTEZPhRw3QtjglIMZbew9OpEnnDlG0PTcC4PqVIy8GEhcI3ffi/x3hM
         3UtsVZcy30L4A==
Received: by mail-wm1-f47.google.com with SMTP id v185-20020a1cacc2000000b003b42e4f278cso718695wme.5;
        Fri, 16 Sep 2022 15:55:50 -0700 (PDT)
X-Gm-Message-State: ACrzQf0htlC4P9wklDtoerfl3559sCb/6L0fIA/MpQcZsLmEfbYS5B+b
        AusuQfNMR3YqbmYhm1mjUsbe4NUwrbm5AsgYwMY=
X-Google-Smtp-Source: AMsMyM4DdIs0+/VNJIbbOCv56yQxPrcSrae4oNrMbcWmbPGfpBk1PqD5XW8+CRbBoA9out17hpCehWfW1Yb7zoW8xm0=
X-Received: by 2002:a7b:c2a2:0:b0:3a8:4959:a327 with SMTP id
 c2-20020a7bc2a2000000b003a84959a327mr4772463wmk.50.1663368948773; Fri, 16 Sep
 2022 15:55:48 -0700 (PDT)
MIME-Version: 1.0
References: <404d2f5ec663128342541fa392a47226a46e5634.1663219530.git.objelf@gmail.com>
 <YyRCtrOtPqu2oEPj@kroah.com>
In-Reply-To: <YyRCtrOtPqu2oEPj@kroah.com>
From:   Sean Wang <sean.wang@kernel.org>
Date:   Fri, 16 Sep 2022 15:55:36 -0700
X-Gmail-Original-Message-ID: <CAGp9Lzqyd0c0Aw6XSjsepKw_RsTawvbF512DvzaXisRxdYbMZA@mail.gmail.com>
Message-ID: <CAGp9Lzqyd0c0Aw6XSjsepKw_RsTawvbF512DvzaXisRxdYbMZA@mail.gmail.com>
Subject: Re: [PATCH 5.19] wifi: mt76: mt7921e: fix crash in chip reset fail
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sean.wang@mediatek.com, stable@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, Deren Wu <deren.wu@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Greg

On Fri, Sep 16, 2022 at 2:39 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Sep 15, 2022 at 01:32:35PM +0800, sean.wang@mediatek.com wrote:
> > From: Deren Wu <deren.wu@mediatek.com>
> >
> > commit fa3fbe64037839f448dc569212bafc5a495d8219 upstream.
>
> This is already in the 5.19.9 kernel release, right?  Do we need it
> again?

Ah, If so, we don't need it again. It seemed unavailable when I
submitted the patch. Sorry for bothering you.

    Sean

>
> thanks,
>
> greg k-h
