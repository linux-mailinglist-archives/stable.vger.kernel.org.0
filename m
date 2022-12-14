Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB4364CF8C
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 19:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbiLNSku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 13:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238888AbiLNSkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 13:40:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30D3D45;
        Wed, 14 Dec 2022 10:40:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 220D4B818A6;
        Wed, 14 Dec 2022 18:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C064C433D2;
        Wed, 14 Dec 2022 18:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671043237;
        bh=BfPmRbxFCqUCV8U+jqF/ZUYDmw0wAT7lnJ27V9BdeZI=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=KZ3P2Jv9oF0WMB2ZBUF8BZEtYZa176QxZ/CgppeP2V/ZRZb1Q+XA4uKrx14uaydIa
         JLi5AO3VrEeT67vretVugZV2ptRwxX7gMv0bBKz+0U81WAz+cXR9C3iKiVQRHi+sTM
         QfV05JduPaGsWxj/SkXIX7doH/ycy9MUp/RrRYsZKolGh+3OPu7WTNvbls6YQkAxiP
         1ICtOk0GbuVzjPWHNDwORhPIFdcCieVZeVbOcPqQDt8ZHmB9jnIKGeDy8rLqbqyGqs
         ie4+AZQ1jcKhNHX0npRoypQTT9b49vGVqgwRwQeMGW82mr3cNwrPQ9KGZhESwjuRz3
         yh1TF3SdKsU5w==
From:   Mark Brown <broonie@kernel.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-spi@vger.kernel.org, Herve Codina <herve.codina@bootlin.com>,
        stable@vger.kernel.org
In-Reply-To: =?utf-8?q?=3C8aab84c51aa330cf91f4b43782a1c483e150a4e3=2E1671025?=
 =?utf-8?q?244=2Egit=2Echristophe=2Eleroy=40csgroup=2Eeu=3E?=
References: =?utf-8?q?=3C8aab84c51aa330cf91f4b43782a1c483e150a4e3=2E16710252?=
 =?utf-8?q?44=2Egit=2Echristophe=2Eleroy=40csgroup=2Eeu=3E?=
Subject: Re: [PATCH] spi: fsl_spi: Don't change speed while chipselect is active
Message-Id: <167104323615.416042.13205866259522482706.b4-ty@kernel.org>
Date:   Wed, 14 Dec 2022 18:40:36 +0000
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

On Wed, 14 Dec 2022 14:41:33 +0100, Christophe Leroy wrote:
> Commit c9bfcb315104 ("spi_mpc83xx: much improved driver") made
> modifications to the driver to not perform speed changes while
> chipselect is active. But those changes where lost with the
> convertion to tranfer_one.
> 
> Previous implementation was allowing speed changes during
> message transfer when cs_change flag was set.
> At the time being, core SPI does not provide any feature to change
> speed while chipselect is off, so do not allow any speed change during
> message transfer, and perform the transfer setup in prepare_message
> in order to set correct speed while chipselect is still off.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[1/1] spi: fsl_spi: Don't change speed while chipselect is active
      commit: 3b553e0041a65e499fa4e25ee146f01f4ec4e617

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
