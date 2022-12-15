Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B370664DE34
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 17:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiLOQJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 11:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiLOQJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 11:09:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B82D3137F;
        Thu, 15 Dec 2022 08:09:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C79B161E3B;
        Thu, 15 Dec 2022 16:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA6EC433D2;
        Thu, 15 Dec 2022 16:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671120559;
        bh=S8mX3KxksW1wGQv7dwz1+uc986a/UJLDGkP6jAg4bjc=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=Ys7iGKbV11EJJmV/RRSoUtS8zkDA32EmBc3O9sV/xVy5Pmk86ghFihf+G6/XbNU0M
         8/y8pPvcPIw528/RRW88KCv8NLNdjbTBvk9TkQ4zehA4eY6we22KvxZSQaBtPl/0oA
         GwMCs5dd/aoL0K3l2CxFa2rUDU8SzMhgLtiEkk6PP9wyfGdVZ+AqPJTZjfhqiag+j+
         WDxLqP7Swv6V/Pvi3gJrxPYu5eNvdQT56b+oVrLr4/alKmM5ghgnlGUPCaCJF8I1CF
         unj+SOnMLngCGrPt6UY6f0sUCKVB739YJeQgvtAqBLj3qrKEFv713udZkpmWv1V05h
         PAYixhpcDU1aA==
From:   Mark Brown <broonie@kernel.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Liam Girdwood <lgirdwood@gmail.com>,
        Maciej Purski <m.purski@samsung.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20221215104646.19818-1-johan+linaro@kernel.org>
References: <20221215104646.19818-1-johan+linaro@kernel.org>
Subject: Re: [PATCH] regulator: core: fix deadlock on regulator enable
Message-Id: <167112055768.3700789.1034235644051276526.b4-ty@kernel.org>
Date:   Thu, 15 Dec 2022 16:09:17 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.11.0-dev-7e003
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Dec 2022 11:46:46 +0100, Johan Hovold wrote:
> When updating the operating mode as part of regulator enable, the caller
> has already locked the regulator tree and drms_uA_update() must not try
> to do the same in order not to trigger a deadlock.
> 
> The lock inversion is reported by lockdep as:
> 
>   ======================================================
>   WARNING: possible circular locking dependency detected
>   6.1.0-next-20221215 #142 Not tainted
>   ------------------------------------------------------
>   udevd/154 is trying to acquire lock:
>   ffffc11f123d7e50 (regulator_list_mutex){+.+.}-{3:3}, at: regulator_lock_dependent+0x54/0x280
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-next

Thanks!

[1/1] regulator: core: fix deadlock on regulator enable
      commit: cb3543cff90a4448ed560ac86c98033ad5fecda9

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
