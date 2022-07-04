Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E555651C5
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 12:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiGDKLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 06:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiGDKLs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 06:11:48 -0400
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE53CE26;
        Mon,  4 Jul 2022 03:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1656929503; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fdDfaJmsBBFfaFN5qYM4oBebDe0q1isIg/MbLGof6RY=;
        b=tMaJAQYv7wevuKVSWdEwxe7ivU5gM+bbwl++b/klkCY80im+OELuHuxGt9D+1vlPKu4tWU
        YUvtkWqP7/qdk419/HEs4f3qhOcprXxxBM+flL6wQYeqBG579/OcsbHOckiWsSlRGo/FBc
        q0AYKUhe90gj0mdJ5eVssHmxmQms8go=
Date:   Mon, 04 Jul 2022 11:11:34 +0100
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] drm/ingenic: Use the highest possible DMA burst size
To:     Sam Ravnborg <sam@ravnborg.org>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        linux-mips@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, list@opendingux.net,
        Christophe Branchereau <cbranchereau@gmail.com>,
        stable@vger.kernel.org
Message-Id: <AZQHER.2A0CO1CY2033@crapouillou.net>
In-Reply-To: <YsE6mZanHLy9LpBd@ravnborg.org>
References: <20220702230727.66704-1-paul@crapouillou.net>
        <YsE6mZanHLy9LpBd@ravnborg.org>
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

Hi Sam,

Le dim., juil. 3 2022 at 08:43:37 +0200, Sam Ravnborg=20
<sam@ravnborg.org> a =E9crit :
> Hi Paul,
>=20
> On Sun, Jul 03, 2022 at 12:07:27AM +0100, Paul Cercueil wrote:
>>  Until now, when running at the maximum resolution of 1280x720 at=20
>> 32bpp
>>  on the JZ4770 SoC the output was garbled, the X/Y position of the
>>  top-left corner of the framebuffer warping to a random position with
>>  the whole image being offset accordingly, every time a new frame was
>>  being submitted.
>>=20
>>  This problem can be eliminated by using a bigger burst size for the=20
>> DMA.
>=20
> Are there any alignment constraints of the framebuffer that depends on
> the burst size? I am hit by this with some atmel IP - which is why I
> ask.

I verified this, and everything behaves correctly when the source=20
address is not aligned to the burst size. So I believe in our case the=20
DMA is smart enough to auto-select the best burst size, up to the=20
configured value.

Cheers,
-Paul

>=20
> Patch looks good and is a-b.
>=20
>>=20
>>  Set in each soc_info structure the maximum burst size supported by=20
>> the
>>  corresponding SoC, and use it in the driver.
>>=20
>>  Set the new value using regmap_update_bits() instead of
>>  regmap_set_bits(), since we do want to override the old value of the
>>  burst size. (Note that regmap_set_bits() wasn't really valid before=20
>> for
>>  the same reason, but it never seemed to be a problem).
>>=20
>>  Cc: <stable@vger.kernel.org>
>>  Fixes: 90b86fcc47b4 ("DRM: Add KMS driver for the Ingenic JZ47xx=20
>> SoCs")
>>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>


