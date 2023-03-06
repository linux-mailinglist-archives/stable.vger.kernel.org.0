Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF4D6ABFCA
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 13:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCFMpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 07:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjCFMpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 07:45:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EB02BEFD;
        Mon,  6 Mar 2023 04:45:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 154D0B80DF2;
        Mon,  6 Mar 2023 12:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035FBC433EF;
        Mon,  6 Mar 2023 12:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678106739;
        bh=EGjzYm/2z9uZZ81Lj/ba0nqcUILcwbFpoY2UUdEuutQ=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=Yr2jKpZh1Mm3riFN5T+mPtgoGwPNflrFnIE12B3moTH2rx+lCRohi3TVA6LJjfGBn
         ZQ81PLMF/+uwb/DoT/NohHAmTAE28Um+/ETw1ddPB33UiOTRtpKNm1U1GIdj0ygo8T
         g8FkYO5dO2NULQJQSU8e1h09Lstt12X68nUY1iXAY84xzx3WMYGm96SGqQrnSozbFy
         FFyGvESMRh2AKmfeuWqM7i7vGlrSQL0qCcXkS/gTUuQsJhF8cNIaGvpkuRJ6s2yqWi
         nODCin57ymqOsUDAdI7feD2+mqIr/x+Jq2FDIrMRvGqpUeWBCxgbf8vb5Mu9PPT7FO
         5Zo686MX5bTKw==
From:   Mark Brown <broonie@kernel.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     stable@vger.kernel.org
In-Reply-To: <20230302122908.221398-1-krzysztof.kozlowski@linaro.org>
References: <20230302122908.221398-1-krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH] ASoC: qcom: q6prm: fix incorrect clk_root passed to
 ADSP
Message-Id: <167810673773.45838.18351424183553686686.b4-ty@kernel.org>
Date:   Mon, 06 Mar 2023 12:45:37 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-bd1bf
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 02 Mar 2023 13:29:08 +0100, Krzysztof Kozlowski wrote:
> The second to last argument is clk_root (root of the clock), however the
> code called q6prm_request_lpass_clock() with clk_attr instead
> (copy-paste error).  This effectively was passing value of 1 as root
> clock which worked on some of the SoCs (e.g. SM8450) but fails on
> others, depending on the ADSP.  For example on SM8550 this "1" as root
> clock is not accepted and results in errors coming from ADSP.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: qcom: q6prm: fix incorrect clk_root passed to ADSP
      commit: 65882134bc622a1e57bd5928ac588855ea2e3ddd

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

