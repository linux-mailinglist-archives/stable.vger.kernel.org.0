Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F666A0906
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 13:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbjBWMz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 07:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbjBWMzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 07:55:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDFC4499;
        Thu, 23 Feb 2023 04:55:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B67D2616E3;
        Thu, 23 Feb 2023 12:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67436C433D2;
        Thu, 23 Feb 2023 12:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677156943;
        bh=PGbyQ9hwUpWcSyO10G16sakWoM0uQ6ZVywdLcMZ0wsQ=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=a53Lzf1l4JTfOUWffYMAT0eziJxEbONFYnb53EEtstpBn6uYH2SkHxUQzvuBf7eU9
         v352+Z3ZpKjRxntJVPkW2uld7U4hSprP8hcvwK0dGLpA4gGBV3oc8zNrHU5211BzkU
         CTtLoVRm7OQyTAFLnrjdiRIe3VQTHJGKFgOURLRi7GJfb3rgKD7UloUt/oCg01hIuW
         FiZDgzZqJFNH3EqctvdYCi9SxonXU0yhi1Dz+tqQzLBf5iW4a7psHa+oZTL8/UIGdP
         x7oZOG3BOuvp7jJSAeB3Ek29SqB+rBQQUQRSgsklpTU0RapOQP0yPhLIrEqBnJwkD6
         NUlkPXiVyXJqw==
From:   Mark Brown <broonie@kernel.org>
To:     Liam Girdwood <lgirdwood@gmail.com>,
        Matthias Kaehlcke <mka@chromium.org>
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Stephen Boyd <swboyd@chromium.org>,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        stable@vger.kernel.org
In-Reply-To: <20230223003301.v2.1.I9719661b8eb0a73b8c416f9c26cf5bd8c0563f99@changeid>
References: <20230223003301.v2.1.I9719661b8eb0a73b8c416f9c26cf5bd8c0563f99@changeid>
Subject: Re: [PATCH v2] regulator: core: Use ktime_get_boottime() to
 determine how long a regulator was off
Message-Id: <167715694213.59264.12069624928598461545.b4-ty@kernel.org>
Date:   Thu, 23 Feb 2023 12:55:42 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Feb 2023 00:33:30 +0000, Matthias Kaehlcke wrote:
> For regulators with 'off-on-delay-us' the regulator framework currently
> uses ktime_get() to determine how long the regulator has been off
> before re-enabling it (after a delay if needed). A problem with using
> ktime_get() is that it doesn't account for the time the system is
> suspended. As a result a regulator with a longer 'off-on-delay' (e.g.
> 500ms) that was switched off during suspend might still incurr in a
> delay on resume before it is re-enabled, even though the regulator
> might have been off for hours. ktime_get_boottime() accounts for
> suspend time, use it instead of ktime_get().
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-next

Thanks!

[1/1] regulator: core: Use ktime_get_boottime() to determine how long a regulator was off
      commit: 80d2c29e09e663761c2778167a625b25ffe01b6f

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

