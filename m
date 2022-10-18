Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B2D602B6C
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 14:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiJRMNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 08:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiJRMNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 08:13:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0989648A15;
        Tue, 18 Oct 2022 05:13:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 996F261311;
        Tue, 18 Oct 2022 12:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4ABC433C1;
        Tue, 18 Oct 2022 12:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666095220;
        bh=ERE5fGH+iI9+kRAgCKLOw9anYezkn5lRnmwLpEkdq0I=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=iKdwIl/dNubjlRXdkBy5sm5XTV/nRUNOr4+7c2Jf4UKbFzdavPuE7pIDovmKNrsMf
         Z1qzOJ3ChUyGND+QEIOrvWd8Y1rdQqcN/jnZMLFe6p4F5V/jPvrYpE0yFM5cvO0abY
         QKXhmBMUHMzz7yp4XnwT7MoInaySuhEudRKUA9afZ3zBGtHpjJI10HIvo50tm4Xst0
         4buUCa1PFkcC+mpIWWT9AlQe3+DJh/iwiN+FduL3wdjqPOBxk0l6TrfRcav2tLZSD4
         Mui+G0fxKV8ExF5zgSD9gvjQmvI5VyQJB6duxUi8+h8o+bFkRz4+psR8QbOWYQS/CR
         iMOV+wUEvDh3w==
From:   Mark Brown <broonie@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        alsa-devel@alsa-project.org, stable@vger.kernel.org,
        Cheng-Yi Chiang <cychiang@chromium.org>,
        Jaroslav Kysela <perex@perex.cz>,
        kernel test robot <lkp@intel.com>,
        Takashi Iwai <tiwai@suse.com>
In-Reply-To: <20221015001228.18990-1-rdunlap@infradead.org>
References: <20221015001228.18990-1-rdunlap@infradead.org>
Subject: Re: [PATCH] ASoC: qcom: SND_SOC_SC7180 optionally depends on SOUNDWIRE
Message-Id: <166609521768.371929.7568128242261436965.b4-ty@kernel.org>
Date:   Tue, 18 Oct 2022 13:13:37 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-fc921
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 Oct 2022 17:12:28 -0700, Randy Dunlap wrote:
> If SOUNDWIRE is enabled, then SND_SOC_SC7180 should depend on
> SOUNDWIRE to prevent SOUNDWIRE=m and SND_SOC_SC7180=y, which causes
> build errors:
> 
> s390-linux-ld: sound/soc/qcom/common.o: in function `qcom_snd_sdw_prepare':
> common.c:(.text+0x140): undefined reference to `sdw_disable_stream'
> s390-linux-ld: common.c:(.text+0x14a): undefined reference to `sdw_deprepare_stream'
> s390-linux-ld: common.c:(.text+0x158): undefined reference to `sdw_prepare_stream'
> s390-linux-ld: common.c:(.text+0x16a): undefined reference to `sdw_enable_stream'
> s390-linux-ld: common.c:(.text+0x17c): undefined reference to `sdw_deprepare_stream'
> s390-linux-ld: sound/soc/qcom/common.o: in function `qcom_snd_sdw_hw_free':
> common.c:(.text+0x344): undefined reference to `sdw_disable_stream'
> s390-linux-ld: common.c:(.text+0x34e): undefined reference to `sdw_deprepare_stream'
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: qcom: SND_SOC_SC7180 optionally depends on SOUNDWIRE
      commit: 9a7f2c9e7a19b16b4409f372cf2e16e4334cdca2

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
