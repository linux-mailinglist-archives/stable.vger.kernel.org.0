Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428503E20E4
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 03:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241874AbhHFBVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 21:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241839AbhHFBVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 21:21:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0318A61184;
        Fri,  6 Aug 2021 01:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628212897;
        bh=N4h4dBuDJ4KHxr54fi8jhhcQmz/UXhAg6jZwfPXQ9ec=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=VO+dEf6Bju4jYaQDGVfD2VqWT3T814WQ4FVXr/tAAc9AOPmM5AF9nv1+bWhMrpsAG
         ir0QNuvYR49EzzG0yBXKsDT3oAQ8mtjkbXhYa13lsEGTJ3sqEGhKPa+cmFOQm7Uxy0
         PTYIarVunY+JfF0qWT+GVAvhaQIaSZvC2d6YaLXtM4Ficjh47T4gJ8Jh5r7QDnDlq4
         xImwWvnUt/NejBpa9r2LPzKVZT7nKGkxhubxVshaG+SQrfR+4raXiz0NMSUSbEebsA
         aUV+x/H0eCzA12y6zKkqN3tpm3Hhpix/DDmmoMQbhAnnBkee06D/Utr+z9XibgnjZV
         ChfBct1MFfQfQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210721224056.3035016-1-bjorn.andersson@linaro.org>
References: <20210721224056.3035016-1-bjorn.andersson@linaro.org>
Subject: Re: [PATCH v2] clk: qcom: gdsc: Ensure regulator init state matches GDSC state
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Mike Tipton <mdtipton@codeaurora.org>,
        Taniya Das <tdas@codeaurora.org>, Vinod Koul <vkoul@kernel.org>
Date:   Thu, 05 Aug 2021 18:21:35 -0700
Message-ID: <162821289569.19113.17542153894487967394@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Bjorn Andersson (2021-07-21 15:40:56)
> As GDSCs are registered and found to be already enabled gdsc_init()
> ensures that 1) the kernel state matches the hardware state, and 2)
> votable GDSCs are properly enabled from this master as well.
>=20
> But as the (optional) supply regulator is enabled deep into
> gdsc_toggle_logic(), which is only executed for votable GDSCs the
> kernel's state of the regulator might not match the hardware. The
> regulator might be automatically turned off if no other users are
> present or the next call to gdsc_disable() would cause an unbalanced
> regulator_disable().
>=20
> But as the votable case deals with an already enabled GDSC, most of
> gdsc_enable() and gdsc_toggle_logic() can be skipped. Reducing it to
> just clearing the SW_COLLAPSE_MASK and enabling hardware control allow
> us to simply call regulator_enable() in both cases.
>=20
> The enablement of hardware control seems to be an independent property
> from the GDSC being enabled, so this is moved outside that conditional
> segment.
>=20
> Lastly, as the propagation of ALWAY_ON to GENPD_FLAG_ALWAYS_ON needs to
> happen regardless of the initial state this is grouped together with the
> other sc->pd updates at the end of the function.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 37416e554961 ("clk: qcom: gdsc: Handle GDSC regulator supplies")
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---

Applied to clk-fixes
