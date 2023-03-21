Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4375A6C3979
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 19:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjCUSrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 14:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbjCUSqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 14:46:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2849B567B3;
        Tue, 21 Mar 2023 11:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB89361DB1;
        Tue, 21 Mar 2023 18:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039BBC433EF;
        Tue, 21 Mar 2023 18:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679424373;
        bh=AkV5mMvCPQu+Wixqy+QjFKEzp2Wq/u6jxA9GfPmKyXg=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=GmjTNpjtRXAtOrZYSOAV0Hi2cKDoLNKMTZttBIxX0XBv3FIuGQabPF4uCU3D016Sm
         XyWQPe1B2FaQkU652sl5RW1bYeGqpLRy2eifegZBYDGCBlljp+Lvs8NPLkg/kJz4kn
         Wu8czOwiSzRPZUiNjf8W7vLp9bXmy1Y7Bwt9kNFsjwCzU7cNci79nS/x8h0mncA7ze
         44AvIUUUq/DzQ8y4ktRI0pX6QzvfEJVL+pXjBz9dBOytqUvKJis+50yyUAU5K2+rdP
         wfJhTUxhezYKDeUdg3NSGmC3yzmreXtHgmzupuPCYxC6VriyN59JnE1dXpvQqWgkuQ
         58uPR+t7odGvQ==
Message-ID: <c5273d67493cbb008f13d7538837828a.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230321175758.26738-1-srinivas.kandagatla@linaro.org>
References: <20230321175758.26738-1-srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH] clk: qcom: gfm-mux: use runtime pm while accessing registers
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     konrad.dybcio@linaro.org, mturquette@baylibre.com,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        stable@vger.kernel.org, Amit Pundir <amit.pundir@linaro.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        agross@kernel.org, andersson@kernel.org
Date:   Tue, 21 Mar 2023 11:46:10 -0700
User-Agent: alot/0.10
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Srinivas Kandagatla (2023-03-21 10:57:58)
> gfm mux driver does support runtime pm but we never use it while
> accessing registers. Looks like this driver was getting lucky and
> totally depending on other drivers to leave the clk on.
>=20
> Fix this by doing runtime pm while accessing registers.
>=20
> Fixes: a2d8f507803e ("clk: qcom: Add support to LPASS AUDIO_CC Glitch Fre=
e Mux clocks")
> Cc: stable@vger.kernel.org
> Reported-by: Amit Pundir <amit.pundir@linaro.org>

Is there a link to the report?

> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
>  drivers/clk/qcom/lpass-gfm-sm8250.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/clk/qcom/lpass-gfm-sm8250.c b/drivers/clk/qcom/lpass=
-gfm-sm8250.c
> index 96f476f24eb2..bcf0ea534f7f 100644
> --- a/drivers/clk/qcom/lpass-gfm-sm8250.c
> +++ b/drivers/clk/qcom/lpass-gfm-sm8250.c
> @@ -38,14 +38,37 @@ struct clk_gfm {
>  static u8 clk_gfm_get_parent(struct clk_hw *hw)
>  {
>         struct clk_gfm *clk =3D to_clk_gfm(hw);
> +       int ret;
> +       u8 parent;
> +
> +       ret =3D pm_runtime_resume_and_get(clk->priv->dev);
> +       if (ret < 0 && ret !=3D -EACCES) {
> +               dev_err_ratelimited(clk->priv->dev,
> +                                   "pm_runtime_resume_and_get failed in =
%s, ret %d\n",
> +                                   __func__, ret);
> +               return ret;
> +       }
> +
> +       parent =3D readl(clk->gfm_mux) & clk->mux_mask;
> +
> +       pm_runtime_mark_last_busy(clk->priv->dev);
> =20
> -       return readl(clk->gfm_mux) & clk->mux_mask;
> +       return parent;
>  }
> =20
>  static int clk_gfm_set_parent(struct clk_hw *hw, u8 index)
>  {
>         struct clk_gfm *clk =3D to_clk_gfm(hw);
>         unsigned int val;
> +       int ret;
> +
> +       ret =3D pm_runtime_resume_and_get(clk->priv->dev);

Doesn't the clk framework already do this? Why do we need to do it
again?

> +       if (ret < 0 && ret !=3D -EACCES) {
> +               dev_err_ratelimited(clk->priv->dev,
> +                                   "pm_runtime_resume_and_get failed in =
%s, ret %d\n",
> +                                   __func__, ret);
> +               return ret;
> +       }
> =20
>         val =3D readl(clk->gfm_mux);
>
