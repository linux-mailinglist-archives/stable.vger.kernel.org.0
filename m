Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671303A1FC8
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 00:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhFIWJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 18:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhFIWJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 18:09:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F91F613E6;
        Wed,  9 Jun 2021 22:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623276463;
        bh=8lohqtM5vYcUit3TkCLDiatbG5BOUIFupvfsoJAgZVs=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=Dpq4tsWzzfgouXFbPB6MnBua7diTMUdEPq1vRp4HUQoJuDTkTs8asWG7LjkNz+sgr
         iwOTikU/+dMsuCik0vqqoCKP9Q7bL6KWotIUEUzJQ0VdeNr13z5Z3dw5402gaLIR7/
         YRWue5r5yGbzEMPONI3/hm6peAwzDdrXjUuTbs5KZRfJYSYCsEEIT3H45m1OQkiFlr
         CXnZpkoi+GYVOP0ELdlWwJv9br/IVDZsit4tYSDM7SZvMEWSCt8DriLQBQbOuLgcOB
         VTeGzGDLCN3gzUTi0o9MWZArclFDw7oBN+x3N+aInQitzBgUKmxEyTo4UwRn9m9QQG
         soVe5TDQwu87A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210609191736.39668-4-dinguyen@kernel.org>
References: <20210609191736.39668-1-dinguyen@kernel.org> <20210609191736.39668-4-dinguyen@kernel.org>
Subject: Re: [PATCHv2 4/4] clk: agilex/stratix10/n5x: fix how the bypass_reg is handled
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     dinguyen@kernel.org, mturquette@baylibre.com,
        stable@vger.kernel.org
To:     Dinh Nguyen <dinguyen@kernel.org>, linux-clk@vger.kernel.org
Date:   Wed, 09 Jun 2021 15:07:42 -0700
Message-ID: <162327646225.9598.494770537412694156@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Dinh Nguyen (2021-06-09 12:17:36)
> If the bypass_reg is set, then we can return the bypass parent, however,
> if there is not a bypass_reg, we need to figure what the correct parent
> mux is.
>=20
> The previous code never handled the parent mux if there was a
> bypass_reg.
>=20
> Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agil=
ex platform")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---
>  drivers/clk/socfpga/clk-periph-s10.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/clk/socfpga/clk-periph-s10.c b/drivers/clk/socfpga/c=
lk-periph-s10.c
> index e5a5fef76df7..e2aad5d37611 100644
> --- a/drivers/clk/socfpga/clk-periph-s10.c
> +++ b/drivers/clk/socfpga/clk-periph-s10.c
> @@ -66,14 +66,19 @@ static u8 clk_periclk_get_parent(struct clk_hw *hwclk)
>         u32 clk_src, mask;
>         u8 parent;
> =20
> +       /* handle the bypass first */
>         if (socfpgaclk->bypass_reg) {
>                 mask =3D (0x1 << socfpgaclk->bypass_shift);
>                 parent =3D ((readl(socfpgaclk->bypass_reg) & mask) >>
>                            socfpgaclk->bypass_shift);
> -       } else {
> +               if (parent)
> +                       return parent;
> +       }
> +

This seems to cause a smatch warning

drivers/clk/socfpga/clk-periph-s10.c:83 clk_periclk_get_parent() error: uni=
nitialized symbol 'parent'.

> +       if (socfpgaclk->hw.reg) {
>                 clk_src =3D readl(socfpgaclk->hw.reg);
>                 parent =3D (clk_src >> CLK_MGR_FREE_SHIFT) &
> -                       CLK_MGR_FREE_MASK;
> +                         CLK_MGR_FREE_MASK;
>         }
>         return parent;
>  }
