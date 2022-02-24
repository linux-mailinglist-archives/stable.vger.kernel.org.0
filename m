Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723614C3960
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 00:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbiBXW73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 17:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiBXW71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 17:59:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826691795D6;
        Thu, 24 Feb 2022 14:58:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A138B829D2;
        Thu, 24 Feb 2022 22:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12217C340EF;
        Thu, 24 Feb 2022 22:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645743533;
        bh=CO5/sGueBwwMRa9A9zjBVB4qVAii3ODAKpYKxMTzJNs=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=CjpXndFoGzZhD9Sl2oj4fVvfks3oGDRE6wAdLl7AwbQFYd2513T60wygKB378y4LI
         sDRqzhBOm6syyd+NiOg/VzgJOUHZq3WIEX+MZ1G8X6cAtfxfGN50+gwyQXHq3S2b3u
         puk2yzPBWTj7kpxWnCVFRzBLXOyvcW8uEOKtPeZShQajcNTC8Sey79SM7Mc+DgzDYL
         rmvCRtqZb8V0mGeKKl9YouLyXXlVrduAqrzpfosxhR0HjUeFBK5E7Ex7DPIFeGani+
         gDuPZruaPrAtFa88yGRWJhyMdIRxp8qf4c8cQYkSucROhAH2IKhWhPhUw5PNFq/v8v
         gKqDAKRpYz4Dw==
From:   Mark Brown <broonie@kernel.org>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Keyon Jie <yang.jie@linux.intel.com>, stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        alsa-devel@alsa-project.org, Rander Wang <rander.wang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
In-Reply-To: <20220224182818.40301-1-ammarfaizi2@gnuweeb.org>
References: <20220224145124.15985-1-ammarfaizi2@gnuweeb.org> <cfe9e583-e20a-f1d6-2a81-2538ca3ca054@linux.intel.com> <Yhe/3rELNfFOdU4L@sirena.org.uk> <04e79b9c-ccb1-119a-c2e2-34c8ca336215@linux.intel.com> <20220224180850.34592-1-ammarfaizi2@gnuweeb.org> <YhfLCWm0Ms3E+j4z@sirena.org.uk> <20220224182818.40301-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH v3] ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM
Message-Id: <164574353079.3982297.3715467450133041074.b4-ty@kernel.org>
Date:   Thu, 24 Feb 2022 22:58:50 +0000
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

On Fri, 25 Feb 2022 01:28:18 +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Do not call snd_dma_free_pages() when snd_dma_alloc_pages() returns
> -ENOMEM because it leads to a NULL pointer dereference bug.
> 
> The dmesg says:
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-linus

Thanks!

[1/1] ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM
      commit: b7fb0ae09009d076964afe4c1a2bde1ee2bd88a9

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
