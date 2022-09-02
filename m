Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746145AA878
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 09:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiIBHDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 03:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiIBHDF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 03:03:05 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFDFBCC29
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 00:03:00 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8155FFF809;
        Fri,  2 Sep 2022 07:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662102176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kUEi3qE9VsWHjdX8pelP/Njt/+TRnCAycHuxXrGFqsM=;
        b=Hph2yMdjFg6+8neCCiNoZc5rRX6pnFD61fs7s86ZWlXK3hV5+yezKmaloLEFyBucCQqNBF
        Ivh4VNLKUOOHPrEjGcDeo9NV8RyKvzi7NwP/3/o0WQtnwc2JDVeBO0ME8+j4HQ63l6Xk8/
        hhtJM8DcJHlcwEHMewja9rvFCy+73FaZnlXmzHbWFiZ7p9cQKCs6fP369XxHtOc5MBXmGl
        FmwvxirY4CgUrSVo22SjiO7dNP2pg/U/yNXj9sPkyyi9Gw8yJsh5Ym4jnlJlvJNjODGYlv
        7QX/Xo0ZCptEwemyE+a8kZTjSwFgPLJPoAFLGEbDcW0DaG7NzZoLaeOWphQA7Q==
Date:   Fri, 2 Sep 2022 09:02:52 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Tomasz =?UTF-8?B?TW/FhA==?= <tomasz.mon@camlingroup.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        torvalds <torvalds@linux-foundation.org>,
        Han Xu <han.xu@nxp.com>, kernel <kernel@pengutronix.de>,
        stable <stable@vger.kernel.org>,
        k drobinski <k.drobinski@camlintechnologies.com>
Subject: Re: [PATCH] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
 program/erase times
Message-ID: <20220902090252.75285234@xps-13>
In-Reply-To: <770744970.283550.1657871950910.JavaMail.zimbra@nod.at>
References: <20220701110341.3094023-1-s.hauer@pengutronix.de>
        <c2d545d1f5478e66c0dac47f4bc4c04256ff44aa.camel@camlingroup.com>
        <fd830c7e94de6b4a0b532dfcf46cf1edd22b42fb.camel@camlingroup.com>
        <YtD/9KJZwlVj+6hS@kroah.com>
        <20220715074631.GA7333@pengutronix.de>
        <YtEdIujszEKSprbF@kroah.com>
        <770744970.283550.1657871950910.JavaMail.zimbra@nod.at>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey folks,

richard@nod.at wrote on Fri, 15 Jul 2022 09:59:10 +0200 (CEST):

> ----- Urspr=C3=BCngliche Mail -----
> >> My IRC history doesn't go back far enough, but if I recall correctly
> >> Miquel is on vacation, he would have picked up this patch for linux-ne=
xt
> >> otherwise. =20
>=20
> Exactly.

Indeed, I was off for an extended period of time, I'm (very) slowly
catching up now.

> =20
> > Ok, let me do a round of stable releases so that people don't get hit by
> > this now... =20
>=20
> Thanks a lot for doing so.
> =20
> > Hopefully this gets fixed up by 5.19-final. =20
>=20
> Sure, I'll pickup this patch.

Thanks Greg & Richard for the handling of this issue.

Cheers,
Miqu=C3=A8l
