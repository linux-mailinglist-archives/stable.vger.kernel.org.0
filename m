Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B04E4F360E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243184AbiDEK6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346705AbiDEJpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:45:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7938E4B42E;
        Tue,  5 Apr 2022 02:31:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BE15B81B14;
        Tue,  5 Apr 2022 09:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984E1C385A4;
        Tue,  5 Apr 2022 09:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649151084;
        bh=Fzz3ascwScSN8mlgX8AOFuaHlsRdXJCzGKE041uMtYo=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=sO1+eaDGwua4hTwxsxWvwQ4f9PWir/mw48Nu5p/k7OyC6gmrvDP7lBnwF26eLUenH
         jfTfrQ5J/fLHjSaBEVrKDonwR9/M/NQDyihJIxaYf90frnR2KGF3kh0133LJxoKxnl
         rkwuSapewEPukF55NcBd7yNegPZdodUzzybuLVpAD0V5IuQymM1e+BJ96bj77VvxKv
         MAfbAedBidV7QuIggcgG8TEo/2CdqSZ97cn8CmHYJw8hjsSUZ7wCHemNSspUcV6YVa
         y3/dtTe3HYOc7GvBbNT/Cj1OItEF9L5+q8xwf+DBvWaCqb37ZPyPxkTt6RLOqdQ+I/
         0/aG2LQwVKxJQ==
From:   Mark Brown <broonie@kernel.org>
To:     tiwai@suse.com, xiam0nd.tong@gmail.com, perex@perex.cz,
        lgirdwood@gmail.com
Cc:     stable@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220329012134.9375-1-xiam0nd.tong@gmail.com>
References: <20220329012134.9375-1-xiam0nd.tong@gmail.com>
Subject: Re: [PATCH v2] soc: soc-dapm: fix two incorrect uses of list iterator
Message-Id: <164915108235.276574.3850661736822524747.b4-ty@kernel.org>
Date:   Tue, 05 Apr 2022 10:31:22 +0100
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

On Tue, 29 Mar 2022 09:21:34 +0800, Xiaomeng Tong wrote:
> These two bug are here:
> 	list_for_each_entry_safe_continue(w, n, list,
> 					power_list);
> 	list_for_each_entry_safe_continue(w, n, list,
> 					power_list);
> 
> After the list_for_each_entry_safe_continue() exits, the list iterator
> will always be a bogus pointer which point to an invalid struct objdect
> containing HEAD member. The funciton poniter 'w->event' will be a
> invalid value which can lead to a control-flow hijack if the 'w' can be
> controlled.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] soc: soc-dapm: fix two incorrect uses of list iterator
      commit: f730a46b931d894816af34a0ff8e4ad51565b39f

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
