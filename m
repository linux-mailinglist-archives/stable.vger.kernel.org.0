Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124464DB71F
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 18:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357597AbiCPR2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 13:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357554AbiCPR2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 13:28:23 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983104F9D8
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 10:27:08 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9CD80200010;
        Wed, 16 Mar 2022 17:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647451627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=scq8Zb1lfOk6h+QLgGzlnO+0bMXFS+z430N4mkT6XOs=;
        b=Q6e5qnx21aoq6asNXsmEuw6WTpfSFBnbcPLQ66ACIOXZzqRraC/xSQjzSAypvcsn+ImRk4
        jewrm9HYbNcwvVxa4D6+xYbq3Xfj1FsCCO6NjHo8kCXXkOpKxM9rXt7m+AqKycpZSHXJn9
        ICIzZZ8K77OeAr9dNnCbLuXjxVPJYbFgogdc71T7+eaxE91ymetoqcsQKjCq5TzjqZotyI
        LH73vk6xr0hS7ZFZW+moHlbYlsmCB8QMoM6W2oIcTXFPavcHAImX1mJN9z2vT319Kv4Al7
        3xy28vM2GmVJpYmxb2kDsWmol80f+6mmeHg9Y3UP5RxRaDK46if+yc6jTl+OvA==
Date:   Wed, 16 Mar 2022 18:27:05 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Tokunori Ikegami <ikegami.t@gmail.com>
Cc:     linux-mtd@lists.infradead.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH v4 0/3] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Message-ID: <20220316182705.7b38828b@xps13>
In-Reply-To: <20220316155455.162362-1-ikegami.t@gmail.com>
References: <20220316155455.162362-1-ikegami.t@gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tokunori,

ikegami.t@gmail.com wrote on Thu, 17 Mar 2022 00:54:52 +0900:

> As pointed out by this bug report [1], buffered writes are now broken on
> S29GL064N. This issue comes from a rework which switched from using chip_=
good()
> to chip_ready(), because DQ true data 0xFF is read on S29GL064N and an er=
ror
> returned by chip_good(). One way to solve the issue is to revert the chan=
ge
> partially to use chip_ready for S29GL064N.

Thanks for your quick iterations but overall I seriously don't feel
this series is ready. At least right now I am still not satisfied by
its shape.

>=20
> [1] https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengut=
ronix.de/
>=20
> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check c=
orrect value")

... and this Fixes tag points to a v4.18 kernel, so if this is true, we
should have a backport-able patch. This also means that this is not as
critical than I thought if people already lived 4 years with the bug.

Vignesh, I let you continue iterating with Tokunori and ack the series
when you feel it's ready.

> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Cc: stable@vger.kernel.org
>=20
> Tokunori Ikegami (3):
>   mtd: cfi_cmdset_0002: Move and rename
>     chip_check/chip_ready/chip_good_for_write
>   mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
>   mtd: cfi_cmdset_0002: Add S29GL064N ID definition
>=20
>  drivers/mtd/chips/cfi_cmdset_0002.c | 93 +++++++++++++++--------------
>  1 file changed, 49 insertions(+), 44 deletions(-)
>=20

Thanks,
Miqu=C3=A8l
