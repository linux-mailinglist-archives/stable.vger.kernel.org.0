Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC4B32B05B
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344770AbhCCAyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1838133AbhCBXFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 18:05:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB845614A7;
        Tue,  2 Mar 2021 23:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614726272;
        bh=VmZ6Ik2ZSnnZpTOZSIxyVdcyKcQ9ArweNZ4G9uZr2Ks=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=iyJnaNrzKJ4WcqrcLThQe9GUC3Goimq5X/WFpNyrCT8VCBI4pyUuzPPLPSk+vMW7a
         EdxCwT2tpH+3P71T+C6egnwQ+ybtt1j02kGby3sfn/NVjzHkNzznYymEC/NXD+60wX
         IMuRxl/c2DVquTx/wCfXvChrrR7rd7MERbYkm3rUYuh2nZL1u8JNyozflC+5eeCZc6
         xjIjb8nO5Yx8QhCVnW/ohyoBDhW5QEQE2M35qyMQ/E+QQ9sCcO4Xu2/QhRhk+Qci+D
         ddAF6xzt7PVK5XfDumBFs46nTdZyFEI5np5AKk/LEob7MMDdoTJ9Njc/H4fjGBe3Cp
         c05KQCIxEPB2A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210302115646.62291-22-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org> <20210302115646.62291-22-sashal@kernel.org>
Subject: Re: [PATCH AUTOSEL 5.10 22/47] clk: qcom: gdsc: Implement NO_RET_PERIPH flag
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Tue, 02 Mar 2021 15:04:31 -0800
Message-ID: <161472627150.1254594.15331941259835237534@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Sasha Levin (2021-03-02 03:56:21)
> From: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.or=
g>
>=20
> [ Upstream commit 785c02eb35009a4be6dbc68f4f7d916e90b7177d ]
>=20
> In some rare occasions, we want to only set the RETAIN_MEM bit, but
> not the RETAIN_PERIPH one: this is seen on at least SDM630/636/660's
> GPU-GX GDSC, where unsetting and setting back the RETAIN_PERIPH bit
> will generate chaos and panics during GPU suspend time (mainly, the
> chaos is unaligned access).
>=20
> For this reason, introduce a new NO_RET_PERIPH flag to the GDSC
> driver to address this corner case.
>=20

Same comment as on 5.11

> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@soma=
inline.org>
> Link: https://lore.kernel.org/r/20210113183817.447866-8-angelogioacchino.=
delregno@somainline.org
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/clk/qcom/gdsc.c | 10 ++++++++--
>  drivers/clk/qcom/gdsc.h |  3 ++-
>  2 files changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
> index af26e0695b86..51ed640e527b 100644
> --- a/drivers/clk/qcom/gdsc.c
> +++ b/drivers/clk/qcom/gdsc.c
> @@ -183,7 +183,10 @@ static inline int gdsc_assert_reset(struct gdsc *sc)
>  static inline void gdsc_force_mem_on(struct gdsc *sc)
>  {
>         int i;
> -       u32 mask =3D RETAIN_MEM | RETAIN_PERIPH;
> +       u32 mask =3D RETAIN_MEM;
> +
> +       if (!(sc->flags & NO_RET_PERIPH))
> +               mask |=3D RETAIN_PERIPH;
> =20
>         for (i =3D 0; i < sc->cxc_count; i++)
>                 regmap_update_bits(sc->regmap, sc->cxcs[i], mask, mask);
> @@ -192,7 +195,10 @@ static inline void gdsc_force_mem_on(struct gdsc *sc)
>  static inline void gdsc_clear_mem_on(struct gdsc *sc)
>  {
>         int i;
> -       u32 mask =3D RETAIN_MEM | RETAIN_PERIPH;
> +       u32 mask =3D RETAIN_MEM;
> +
> +       if (!(sc->flags & NO_RET_PERIPH))
> +               mask |=3D RETAIN_PERIPH;
> =20
>         for (i =3D 0; i < sc->cxc_count; i++)
>                 regmap_update_bits(sc->regmap, sc->cxcs[i], mask, 0);
> diff --git a/drivers/clk/qcom/gdsc.h b/drivers/clk/qcom/gdsc.h
> index bd537438c793..5bb396b344d1 100644
> --- a/drivers/clk/qcom/gdsc.h
> +++ b/drivers/clk/qcom/gdsc.h
> @@ -42,7 +42,7 @@ struct gdsc {
>  #define PWRSTS_ON              BIT(2)
>  #define PWRSTS_OFF_ON          (PWRSTS_OFF | PWRSTS_ON)
>  #define PWRSTS_RET_ON          (PWRSTS_RET | PWRSTS_ON)
> -       const u8                        flags;
> +       const u16                       flags;
>  #define VOTABLE                BIT(0)
>  #define CLAMP_IO       BIT(1)
>  #define HW_CTRL                BIT(2)
> @@ -51,6 +51,7 @@ struct gdsc {
>  #define POLL_CFG_GDSCR BIT(5)
>  #define ALWAYS_ON      BIT(6)
>  #define RETAIN_FF_ENABLE       BIT(7)
> +#define NO_RET_PERIPH  BIT(8)
>         struct reset_controller_dev     *rcdev;
>         unsigned int                    *resets;
>         unsigned int                    reset_count;
> --=20
> 2.30.1
>
