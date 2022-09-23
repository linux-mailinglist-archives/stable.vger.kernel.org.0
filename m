Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933195E8058
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 19:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiIWRHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 13:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbiIWRHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 13:07:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E9514B865;
        Fri, 23 Sep 2022 10:07:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B62F4B8331C;
        Fri, 23 Sep 2022 17:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF0DC4314B;
        Fri, 23 Sep 2022 17:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663952827;
        bh=OHPc09XdtkB69hHy9A41/zPZ29zpuKb1HP+2+9skeBA=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=sPYgRfnHuP+icV2S/4rnjYWWFaj8e6xIPXcYr3UlywAG6ubQqFuZ4kEsz5L6sWeFT
         cLcHRONKOEfSqNv+DSKMzrb7ORks/ew5Q8Cl645OdytW8p/oFiFeqF0SOrW/DEF+h9
         qpWNmSG28hJJ7IbXp5KYjVZngeXfWYFhBHZ5oA4hYallbJRkFck4oY0McTfYnRnzDZ
         GGn0rjC9ZVSjPw9cqucDA0ynJ/zJdsqCQxR4+3vbEkkBEyb78mKQtbslRNp0/h8wcy
         BMudEc9Jt4SOJiPXHxky4bPdkDrNzyC95CB3Jdn9YDyD2G0RE3SmtewOI94F+yq/Mn
         TVhI4rx9Mcdtg==
From:   Mark Brown <broonie@kernel.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Banajit Goswami <bgoswami@quicinc.com>,
        Vinod Koul <vkoul@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc:     stable@vger.kernel.org
In-Reply-To: <20220921145354.1683791-1-krzysztof.kozlowski@linaro.org>
References: <20220921145354.1683791-1-krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH 1/2] ASoC: wcd9335: fix order of Slimbus unprepare/disable
Message-Id: <166395282508.610218.13514868920079222413.b4-ty@kernel.org>
Date:   Fri, 23 Sep 2022 18:07:05 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-fc921
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 21 Sep 2022 16:53:53 +0200, Krzysztof Kozlowski wrote:
> Slimbus streams are first prepared and then enabled, so the cleanup path
> should reverse it.  The unprepare sets stream->num_ports to 0 and frees
> the stream->ports.  Calling disable after unprepare was not really
> effective (channels was not deactivated) and could lead to further
> issues due to making transfers on unprepared stream.
> 
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/2] ASoC: wcd9335: fix order of Slimbus unprepare/disable
      commit: ea8ef003aa53ad23e7705c5cab1c4e664faa6c79
[2/2] ASoC: wcd934x: fix order of Slimbus unprepare/disable
      commit: e96bca7eaa5747633ec638b065630ff83728982a

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
