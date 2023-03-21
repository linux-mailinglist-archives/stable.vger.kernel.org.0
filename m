Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88846C3DD8
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 23:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCUWs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 18:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjCUWsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 18:48:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BE8EB44;
        Tue, 21 Mar 2023 15:48:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5F41B80D5C;
        Tue, 21 Mar 2023 22:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C88C433D2;
        Tue, 21 Mar 2023 22:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679438930;
        bh=eRkCIDKtMuOnkY12HfzUf0za5OR3niuDosLQfAgVtEA=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=lY8hziGCpjvnfSPvhRPK1muiFE0geLAf8x7mxf377TCmLwVpqG/fVp9KMlZijkz7i
         L8JMzlc5H33OOxevLOEGtr7KXLfshUbd6OjjlKTD6PzIopM49GQfRqRuZGxGd3bJwr
         abuPRxzu2NtCx5YagH4C/EZjXQs/KUgG0xsnWNhYATX7sNCkDQSCOoQeSiSZDzTXgn
         Zz214VkrHVFtHkY+Q2OHbn+kqxoSOyW436gG9IYHJfvIwVJM4JkRAXCH/p4UVkS7ZB
         PuY57Rwe5LPDUXEuwdn7wvrzyp/k33COAlLhEtFg0n1y7t+GHCpfI99WY7oDLYioUT
         E/MoJgetUvBwQ==
Message-ID: <ab6757652325303964d3de29f920befe.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <4df4d530-f12a-cc34-692a-1f5ff784bbe5@linaro.org>
References: <20230321175758.26738-1-srinivas.kandagatla@linaro.org> <c5273d67493cbb008f13d7538837828a.sboyd@kernel.org> <4df4d530-f12a-cc34-692a-1f5ff784bbe5@linaro.org>
Subject: Re: [PATCH] clk: qcom: gfm-mux: use runtime pm while accessing registers
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     konrad.dybcio@linaro.org, mturquette@baylibre.com,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Amit Pundir <amit.pundir@linaro.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        agross@kernel.org, andersson@kernel.org
Date:   Tue, 21 Mar 2023 15:48:48 -0700
User-Agent: alot/0.10
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Srinivas Kandagatla (2023-03-21 13:33:49)
>=20
>=20
> On 21/03/2023 18:46, Stephen Boyd wrote:
> > Quoting Srinivas Kandagatla (2023-03-21 10:57:58)
> >> gfm mux driver does support runtime pm but we never use it while
> >> accessing registers. Looks like this driver was getting lucky and
> >> totally depending on other drivers to leave the clk on.
> >>
> >> Fix this by doing runtime pm while accessing registers.
> >>
> >> Fixes: a2d8f507803e ("clk: qcom: Add support to LPASS AUDIO_CC Glitch =
Free Mux clocks")
> >> Cc: stable@vger.kernel.org
> >> Reported-by: Amit Pundir <amit.pundir@linaro.org>
> >=20
> > Is there a link to the report?
>=20
> https://www.spinics.net/lists/stable/msg638380.html

Please add a Link: after the reported-by and use a lore link instead of
spinics please.

> >>   {
> >>          struct clk_gfm *clk =3D to_clk_gfm(hw);
> >>          unsigned int val;
> >> +       int ret;
> >> +
> >> +       ret =3D pm_runtime_resume_and_get(clk->priv->dev);
> >=20
> > Doesn't the clk framework already do this? Why do we need to do it
> > again?
>=20
> You are right, clk core already does do pm_runtime_resume_and_get for=20
> set_parent.
>=20
> this looks redundant here.
>=20
>=20
> so we need only need to add this for get_parent
>=20

The get_parent() clk op is called from a couple places in the clk
framework. I guess that you're getting called from
clk_core_reparent_orphans() where the runtime PM count isn't
incremented? Can you confirm? Either way, this should be fixed in the
framework and not in the driver.
