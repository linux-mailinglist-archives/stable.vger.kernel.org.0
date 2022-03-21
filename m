Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DDA4E26A8
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 13:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbiCUMhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 08:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347454AbiCUMhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 08:37:02 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5A8205CA
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 05:35:36 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 15B8D20003;
        Mon, 21 Mar 2022 12:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647866131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HBTSUt8GUXUCOdIHXgmXN1kcOd2zjeOJ9XAUitbr+xI=;
        b=G0hC54UEmqGGQxEcvBpemYxcmxAY5tWsAD2cfncEGI13KhRueHberRW5KAqzl8ypwmBvz2
        tdlH3i6ESXycwgooSKqPDX+KhrUhvyUr8C+T+NxD0jwC2B7E6k3Di9Hw9VdkG68Cu0T6e6
        Y2MSVMm5qdQLLGfdVpCS4pktqKGIEl/zfMm46xAmUV5J8LngS+CJSHX9OwireKRJwYCmCw
        Inu2JRNAu771ULQY/0KTGA+ZC79tt/RqJvItIgBsIawd41I00M5TzCcDsAqm8Vqoh24e8w
        YOOpHPibqbSm1rjYeisrvmKap7IjYU/tzR8yx+kDxNV6svKZIn/qm57y3m1IAw==
Date:   Mon, 21 Mar 2022 13:35:29 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        linux-mtd@lists.infradead.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH v4 2/3] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Message-ID: <20220321133529.2d3addaf@xps13>
In-Reply-To: <db755852-effe-c4ca-726c-200d28b0b8a5@leemhuis.info>
References: <20220316155455.162362-1-ikegami.t@gmail.com>
        <20220316155455.162362-3-ikegami.t@gmail.com>
        <db755852-effe-c4ca-726c-200d28b0b8a5@leemhuis.info>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thorsten,

regressions@leemhuis.info wrote on Mon, 21 Mar 2022 12:48:11 +0100:

> On 16.03.22 16:54, Tokunori Ikegami wrote:
> > As pointed out by this bug report [1], buffered writes are now broken on
> > S29GL064N. This issue comes from a rework which switched from using chi=
p_good()
> > to chip_ready(), because DQ true data 0xFF is read on S29GL064N and an =
error
> > returned by chip_good(). One way to solve the issue is to revert the ch=
ange
> > partially to use chip_ready for S29GL064N.
> >=20
> > [1] https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@peng=
utronix.de/ =20
>=20
> Why did you switch from the documented format for links you added on my
> request (see
> https://lore.kernel.org/stable/f1b44e87-e457-7783-d46e-0d577cea3b72@leemh=
uis.info/
>=20
> ) to v2 to something else that is not recognized by tools and scripts
> that rely on proper link tags? You are making my and maybe other peoples
> life unnecessary hard. :-((
>=20
> FWIW, the proper style should support footnote style like this:
>=20
> Link:
> https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutroni=
x.de/
>  [1]
>=20
> Ciao, Thorsten
>=20
> #regzbot ^backmonitor:
> https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutroni=
x.de/
>=20

Because today's requirement from maintainers is to provide a Link
tag that points to the mail discussion of the patch being applied. I
then asked to use the above form instead to point to the bug report
because I don't see the point of having a "Link" tag for it?

Thanks,
Miqu=C3=A8l
