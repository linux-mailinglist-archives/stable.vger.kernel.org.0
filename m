Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175484F3611
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243423AbiDEK6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346700AbiDEJpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:45:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA964992D;
        Tue,  5 Apr 2022 02:31:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE012616D4;
        Tue,  5 Apr 2022 09:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8C2C385A2;
        Tue,  5 Apr 2022 09:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649151082;
        bh=A4/cLM5NPo8irk/vpe7YE2iwcgOutJwMOohvACQXNIQ=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=le/sBVDlea0jPsjUT6cnlIpQm41Q0Zc3AatcaUBcVU/Za1NcXE0f21mYzoladnjrh
         6zY022gpr3oSehDSCgDzKWgbLEhQN/FlWh3rx8TGn9nUdG+PP6v77D2GPp4p8E+0GK
         UFHd+KMCghI3PZ3qZ2vwg7PvRWtzL/WFn0doz+lRqSbRQIccajDNPnUNKhxVev6C8a
         wabnJm+Ecq9n0ZdyizW9frXLeKDd1KFEcRFY+iM3Uze8PEbIDcOkPq4Nf6Plma2On9
         52KcSTQ21iZ8IcEbI8hkqpQvvDokBG6FL+YaRtx17HcypsQfhEYiWcYMkXrr0jARlV
         1VnxuJm7sPoUg==
From:   Mark Brown <broonie@kernel.org>
To:     xiam0nd.tong@gmail.com, oder_chiou@realtek.com,
        lgirdwood@gmail.com, tiwai@suse.com, perex@perex.cz
Cc:     derek.fang@realtek.com, stable@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220327081300.12962-1-xiam0nd.tong@gmail.com>
References: <20220327081300.12962-1-xiam0nd.tong@gmail.com>
Subject: Re: [PATCH] codecs: rt5682s: fix an incorrect NULL check on list iterator
Message-Id: <164915108018.276574.3161764909349816004.b4-ty@kernel.org>
Date:   Tue, 05 Apr 2022 10:31:20 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 27 Mar 2022 16:13:00 +0800, Xiaomeng Tong wrote:
> The bug is here:
>             if (!dai) {
> 
> The list iterator value 'dai' will *always* be set and non-NULL
> by for_each_component_dais(), so it is incorrect to assume that
> the iterator value will be NULL if the list is empty or no element
> is found (In fact, it will be a bogus pointer to an invalid struct
> object containing the HEAD). Otherwise it will bypass the check
> 'if (!dai) {' (never call dev_err() and never return -ENODEV;)
> and lead to invalid memory access lately when calling
> 'rt5682s_set_bclk1_ratio(dai, factor);'.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] codecs: rt5682s: fix an incorrect NULL check on list iterator
      commit: acc72863e0f11cd0bedc888b663700229f9ba5ff

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
