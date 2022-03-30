Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE6A4EBD03
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 10:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244480AbiC3I6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 04:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241961AbiC3I6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 04:58:00 -0400
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E963129267
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 01:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1648630570; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GMxNp3hilOQ3XkTLYclCmMd/xeq+eq1T0g+2tg6rrxY=;
        b=iaZZ5bs13kPIiwHFiLb5RLlXHkUwq3A45zFN4xR/eAp+YSeumgzw6ijV77IQ0RuEq2Khji
        rj7VDuubqXMzqMGtGP0Sd6BkjVwSdgfdipOajzmdLJJMZkO/otWAnTRKWzd1jcTKUhUXtm
        RwzsTo52m7ehH1eJBIhMld0C6DLbV7I=
Date:   Wed, 30 Mar 2022 09:56:01 +0100
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: kernel 5.16.12 and above broke yoga c930 sound and mic
To:     Joshua Freedman <freedman.joshua@gmail.com>
Cc:     lis8215@gmail.com, stable@vger.kernel.org, sboyd@kernel.org,
        gregkh@linuxfoundation.org
Message-Id: <DHVJ9R.RF13VMG7CUAL2@crapouillou.net>
In-Reply-To: <CAJQ3t4RxYXkREhwBb_JgYj4=ty+VtnV9m65U79ZLbmmj4mN7WA@mail.gmail.com>
References: <CAJQ3t4RxYXkREhwBb_JgYj4=ty+VtnV9m65U79ZLbmmj4mN7WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Joshua,

Le mer., mars 30 2022 at 03:34:34 -0400, Joshua Freedman=20
<freedman.joshua@gmail.com> a =E9crit :
> Hi, I noticed my audio and mic stopped working on my yoga c930 on=20
> 5.16.12 and newer. 5.16.11 was ok.   On 5.16.12 and above I get a=20
> dummy output and no mic.
>=20
> Anything we can do about that?  Thanks.
>=20
> I'm not a git guy so I just looked at the changlogs and this was the=20
> only audio one in 5.16.12.  I could be wrong in the ID though.

This commit changes the clocks on the JZ4725B SoC, there is just no way=20
for it to be the cause of your problem.

Cheers,
-Paul

> commit 6b0d719ffed1c21c1a2e473301fd95f78cd35c9e
> Author: Siarhei Volkau <lis8215@gmail.com>
> Date:   Sat Feb 5 20:18:49 2022 +0300
>=20
>     clk: jz4725b: fix mmc0 clock gating
>=20
>     commit 2f0754f27a230fee6e6d753f07585cee03bedfe3 upstream.
>=20
>     The mmc0 clock gate bit was mistakenly assigned to "i2s" clock.
>     You can find that the same bit is assigned to "mmc0" too.
>     It leads to mmc0 hang for a long time after any sound activity
>     also it  prevented PM_SLEEP to work properly.
>     I guess it was introduced by copy-paste from jz4740 driver
>     where it is really controls I2S clock gate.
>=20
>     Fixes: 226dfa4726eb ("clk: Add Ingenic jz4725b CGU driver")
>     Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
>     Tested-by: Siarhei Volkau <lis8215@gmail.com>
>     Reviewed-by: Paul Cercueil <paul@crapouillou.net>
>     Cc: stable@vger.kernel.org
>     Link:=20
> https://lore.kernel.org/r/20220205171849.687805-2-lis8215@gmail.com
>     Signed-off-by: Stephen Boyd <sboyd@kernel.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
>=20
> --
>=20
>=20
> Joshua Freedman
>=20
> President
>=20
> P: +19168060052
>=20
> 49 Sample BR RD
>=20
> Mechanicsburg, PA 17050-2386
>=20
> Fix & Flip Rehab Financing <31 Unit
>=20
>=20
>=20
>=20
> PGPKEY
>=20


