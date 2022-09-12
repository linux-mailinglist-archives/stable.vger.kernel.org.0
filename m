Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E7F5B58D7
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 12:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiILK5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 06:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiILK5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 06:57:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2A233A3B;
        Mon, 12 Sep 2022 03:56:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9741B6116E;
        Mon, 12 Sep 2022 10:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C8BC433C1;
        Mon, 12 Sep 2022 10:56:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="CySJ+5cH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1662980215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fwiUXXyaDl64W0gR77hDL+1inITH1E0hryyhOBfnNHA=;
        b=CySJ+5cHEwERUaAySyASiB4MUgIfRGKz9AZDD1Q/WoUtbZgu111yq5kBQrYro0mRbt2F91
        2q/MTtbcgYAvTSD+sTvtsHJ5E+ubyFcxqRzxHxMFle7aaWT1JjOAsN2sBRD5G6KyN0j7QA
        5bjU4FNY2JyBM9OIbThsnn2az1Gty0Y=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 37b6f6d7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 12 Sep 2022 10:56:55 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id d189so12075627ybh.12;
        Mon, 12 Sep 2022 03:56:54 -0700 (PDT)
X-Gm-Message-State: ACgBeo1NKdrxzuXYTOhE+GsYF30EonmmmGJdDRyWN2+cSwo0pDkghJKE
        cajT9DX0AOsJhfjYsZLf9CgOkPDI1CUdTxaW5sg=
X-Google-Smtp-Source: AA6agR6cMHL5Yanxmy5O+FVq36ySuLwhW06E+MW8/V6CmXcyAVlRgoo0MfVBB3QUBajEC59cn2wWECIz7QcigRnz3OA=
X-Received: by 2002:a25:7452:0:b0:6ae:c28d:f173 with SMTP id
 p79-20020a257452000000b006aec28df173mr7327298ybc.556.1662980214189; Mon, 12
 Sep 2022 03:56:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAJZ5v0js78b3qZXoxgXEwG7g0a7n_ALnEYjjzBGaQW7q4_ceCA@mail.gmail.com>
 <20220905172428.105564-1-Jason@zx2c4.com> <20220911123346.a7xbzdlbb7r5p6ih@mercury.elektranox.org>
 <Yx8N0hGNcbVPnJxW@zx2c4.com> <CAHmME9popsZskH5xR0sX2Prhd_R78Dc9mEO3BKy6qcvaok1MXQ@mail.gmail.com>
In-Reply-To: <CAHmME9popsZskH5xR0sX2Prhd_R78Dc9mEO3BKy6qcvaok1MXQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 12 Sep 2022 11:56:43 +0100
X-Gmail-Original-Message-ID: <CAHmME9qUirnDQCxLvcQPTVYjSXEgGZcTnYTfRRVkVUwziFTywQ@mail.gmail.com>
Message-ID: <CAHmME9qUirnDQCxLvcQPTVYjSXEgGZcTnYTfRRVkVUwziFTywQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] power: supply: avoid nullptr deref in __power_supply_is_system_supplied
To:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        Mark Pearson <mpearson@lenovo.com>
Cc:     linux-pm@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CC+ Mark Pearson from Lenovo
Full thread is here:
https://lore.kernel.org/all/YwDsy3ZUgTtlKH9r@zx2c4.com/

On Mon, Sep 12, 2022 at 11:48 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Ah another thing:
>
> On Mon, Sep 12, 2022 at 11:45 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > My machine went through three changes I know about between the threshold
> > of "not crashing" and "crashing":
> > - Upgraded to 5.19 and then 6.0-rc1.
> > - I used my laptop on batteries for a prolonged period of time for the
> >   first time in a while.
> > - I updated KDE, whose power management UI elements may or may not make
> >   frequent calls to this subsystem to update some visual representation.
>
> - Updated my BIOS.

GASP! The plot thickens.

It appears that the BIOS update I applied has been removed from
https://pcsupport.lenovo.com/fr/en/downloads/ds551052-bios-update-utility-bootable-cd-for-windows-10-64-bit-and-linux-thinkpad-p1-gen-4-x1-extreme-gen-4
and now it only shows the 1.16 version. I updated from 1.16 to 1.18.

The missing release notes are still online if you futz with the URL:
https://download.lenovo.com/pccbbs/mobiles/n40ur14w.txt
https://download.lenovo.com/pccbbs/mobiles/n40ur15w.txt

One of the items for 1.17 says:
> - (Fix) Fixed an issue where it took a long time to update the battery FW.

So maybe something was happening here...

I'm CC'ing Mark from Lenovo to see if he has any insight as to why
this BIOS update was pulled.

Maybe the battery was appearing and disappearing rapidly. If that's
correct, then it'd indicate that this bandaid patch is *wrong* and
what actually is needed is some kind of reference counting or RCU
around that sysfs interface (and maybe others).

Jason
