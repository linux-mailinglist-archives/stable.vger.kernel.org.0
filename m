Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B8E3D9D45
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 07:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbhG2FyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 01:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbhG2FyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 01:54:08 -0400
Received: from mxout2.routing.net (mxout2.routing.net [IPv6:2a03:2900:1:a::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6C2C061757;
        Wed, 28 Jul 2021 22:54:06 -0700 (PDT)
Received: from mxbox4.masterlogin.de (unknown [192.168.10.79])
        by mxout2.routing.net (Postfix) with ESMTP id D25AD5FA4D;
        Thu, 29 Jul 2021 05:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1627538044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cVlxDO10y/7Na3xuH5jj4ZdMVQFeOoVyuZjIQ6RviyU=;
        b=Uq1sKiNjQJ0Zm+dOb18ivYGNCHTeMkuK7PpObxwKV/2oWFOlKyIKfQcCaDmo53VZyAFv/I
        UNXYwyw1iWllc7hzvApDMnXNPS6gO8p/37Sij0PbV4uvnsJkPYVIrq9p8bNW0mzdHhaLca
        mVnHVi/0XGal+BIVCfAUJwxGXLjM5ac=
Received: from [IPv6:2a01:598:a001:9235:1:2:c0e0:123a] (unknown [IPv6:2a01:598:a001:9235:1:2:c0e0:123a])
        by mxbox4.masterlogin.de (Postfix) with ESMTPSA id 0D6968001F;
        Thu, 29 Jul 2021 05:54:03 +0000 (UTC)
Date:   Thu, 29 Jul 2021 07:53:58 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <CAJMQK-gQeMidjBZ1E=ReMmffC5G8oiFawB4Ey1PNb2ZWXw_1Bg@mail.gmail.com>
References: <20210727174025.10552-1-linux@fw-web.de> <CAJMQK-g8g5QJbBkU-A6th1VSWafxVv2fGtym+enQa_hDVaVoBw@mail.gmail.com> <97C4FA94-B28A-4F0E-9CD3-4E33B01BA353@fw-web.de> <CAJMQK-gQeMidjBZ1E=ReMmffC5G8oiFawB4Ey1PNb2ZWXw_1Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] soc: mmsys: mediatek: add mask to mmsys routes
To:     Hsin-Yi Wang <hsinyi@chromium.org>
CC:     "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, CK Hu <ck.hu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>
From:   Frank Wunderlich <linux@fw-web.de>
Message-ID: <6BFE13A3-6A42-455E-BDF7-CD285CC6C66D@fw-web.de>
X-Mail-ID: 35ad2a0b-3622-4f69-b59c-67b9f9caa6aa
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 29=2E Juli 2021 07:47:03 MESZ schrieb Hsin-Yi Wang <hsinyi@chromium=2Eor=
g>:
>On Thu, Jul 29, 2021 at 1:40 PM Frank Wunderlich <linux@fw-web=2Ede>
>wrote:
>>
>
>>
> struct mtk_mmsys_routes {
>         u32 from_comp;
>         u32 to_comp;
>         u32 addr;
> +       u32 mask;
>         u32 val;
>  };
>mask is not the last element, and mmsys_mt8183_routing_table =3D {
>  {
>    DDP_COMPONENT_OVL0, DDP_COMPONENT_OVL_2L0,
>    MT8183_DISP_OVL0_MOUT_EN, MT8183_OVL0_MOUT_EN_OVL0_2L
>  }
>=2E=2E=2E
>so the mask and val will be wrong=2E CK, do you know what mask we should
>set for mt8183? Or can we just set a dummy 0 mask=2E

Ahhh=2E=2E=2Emt8183 has own mmsys-table and
i had only changed the default one,so
value is now missing because value is now the mask=2E I have used same ord=
er as
CK to avoid confusion and make it easier
to review=2E
Afaik you could use same value as value to reset same bits=2E=2E=2Edid thi=
s in default routing table too=2E

regards Frank
