Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2045465AEC1
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 10:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjABJkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 04:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjABJkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 04:40:11 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B53D7F
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 01:40:09 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4B6C6240009;
        Mon,  2 Jan 2023 09:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1672652406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5E6lCTS2ynO3kNOr2DrozkQ00vp5/Kkw0BvSXENsHXY=;
        b=H4c1yh/VB54M+SKD9HDIZAF63eVXa2yhH6f6CxSWCVqlmzIWxOgkzo+mKG7usBZesd4axd
        q8cwWe5EB8lRIlWHxMOoZLRHic6sLONpwflfrR7ksq6/5TeWBsqqjNz0H/oIzhiUXlC2Xr
        /gQni3u+Mvg0qvh4LVdTOQi9XVxmFN1QgL3tWhGTI+60xdbq2xJqkzKKohLpJfgvZ3ueGl
        6mQ7NEKtYXhlViLCJhIXm96QQ7ZwGbaPRLTOBY6/z8PZXWgEMhBCtC6YBCjLLq3U+pvIZa
        TZWEW9T/0v9VEixvNZaL6G2IHHBOGAtOAez+WSlNcM6EVnmyNUNDiDgCnQbolw==
Date:   Mon, 2 Jan 2023 10:40:04 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     Marek Vasut <marex@denx.de>, Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is
 0
Message-ID: <20230102104004.6abae6da@xps-13>
In-Reply-To: <Y5ydGhn/qYUalamm@francesco-nb.int.toradex.com>
References: <Y5wiAPvPU+YY39oX@francesco-nb.int.toradex.com>
        <6f5f5b32-d7fe-13cc-b52d-83a27bd9f53e@denx.de>
        <20221216120155.4b78e5cf@xps-13>
        <Y5xmi62hR6JeYUt1@francesco-nb.int.toradex.com>
        <20221216143720.3c8923d8@xps-13>
        <fb55a784-eda3-8916-1413-581b9436b3f2@denx.de>
        <20221216163501.1c2ace21@xps-13>
        <Y5ydGhn/qYUalamm@francesco-nb.int.toradex.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Francesco,

francesco@dolcini.it wrote on Fri, 16 Dec 2022 17:30:18 +0100:

> On Fri, Dec 16, 2022 at 04:35:01PM +0100, Miquel Raynal wrote:
> > marex@denx.de wrote on Fri, 16 Dec 2022 15:32:28 +0100: =20
> > > The second part of the message, as far as I understand it, is
> > > "ignore problems this will cause to users of boards we do not know
> > > about, let them run into unbootable systems after some linux kernel
> > > update,  =20
> >=20
> > Now you know what kernel update will break them, so you can prevent it
> > from happening.=20
> >=20
> > For boards without even a dtsi in the kernel, should we care? =20
>=20
> Would caring for those boards not be just exact the same as caring for
> some UEFI/ACPI mess for which no source code is normally available and
> nobody really known at which point the various vendors have forked their
> source code from some Intel or AMD or whatever reference code?

I am sorry I don't know UEFI/ACPI well enough to discuss it.

> IMHO we should care for the multiple reason I have already written in my
> previous emails.
>=20
> And honestly, just as a side comment, I would feel way more happy
> to know that the elevator control system in the elevator I use everyday
> or the chemical industrial plan HMI next to my home is running an up to
> date Linux system that is not affected by known security vulnerabilities
> and they did stop updating it just because there was some random bug
> preventing the updated kernel to boot and nobody had the time/skill to
> investigate and fix it. [1]

The issue comes from a very specific U-Boot function that should have
never existed. I hope people working on chemical plants do not make
use of these and will not disregard the "your DT is broken there [...]"
warning we plan to add right before their updated board will fail. We
are not living people in the dark, I agreed for a warning, but I don't
think applying the proposed fix blindly is wise and future-proof.

Thanks,
Miqu=C3=A8l
