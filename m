Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20CAF4FADCF
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 14:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbiDJMZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Apr 2022 08:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiDJMZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Apr 2022 08:25:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0A91AD8C;
        Sun, 10 Apr 2022 05:22:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8A7BB80CBE;
        Sun, 10 Apr 2022 12:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30801C385A4;
        Sun, 10 Apr 2022 12:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649593367;
        bh=xAbgk3LtfASQPq7bXtN9u6+1PL1eZhprClZ6QOfd+lE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AKjlJHQrkizBLFE6pjCdEq0fkxQaO7cp9aCkR11gU4wpMZsoGgfrB/8lsNEr0rU6Y
         E6UysO6KPaS5Acx4NpFHtojRfc7n4pn7sc7wKfSGRY7v32s3MlYJ3OdY7dlSefQuq0
         sPXqBGFu7J3EvwUxPrXkQETn9B9xJGlK7koX9S34A3MVytm8TSax9J8uX02dA/U4lK
         paEb0K0bDCu78bz8bOdXlNZogxEOIt09AtaaPj1X9bvjOEIb6gemsYngs1rNvrojw6
         wB0E+LX5l7PPqOrNfYrY6sSNud9g+GfbIZXHW3bDziy5syN4u+z2VDLapcXqboCFsp
         8AzJpRaD54qrQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH for-5.18 v3] ath9k: Fix usage of driver-private space in
 tx_info
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220404204800.2681133-1-toke@toke.dk>
References: <20220404204800.2681133-1-toke@toke.dk>
To:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgens?= =?utf-8?q?en?= 
        <toke@redhat.com>, stable@vger.kernel.org,
        Peter Seiderer <ps.report@gmx.net>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164959336397.19712.4818817416672005852.kvalo@kernel.org>
Date:   Sun, 10 Apr 2022 12:22:45 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Toke Høiland-Jørgensen <toke@toke.dk> wrote:

> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> The ieee80211_tx_info_clear_status() helper also clears the rate counts and
> the driver-private part of struct ieee80211_tx_info, so using it breaks
> quite a few other things. So back out of using it, and instead define a
> ath-internal helper that only clears the area between the
> status_driver_data and the rates info. Combined with moving the
> ath_frame_info struct to status_driver_data, this avoids clearing anything
> we shouldn't be, and so we can keep the existing code for handling the rate
> information.
> 
> While fixing this I also noticed that the setting of
> tx_info->status.rates[tx_rateindex].count on hardware underrun errors was
> always immediately overridden by the normal setting of the same fields, so
> rearrange the code so that the underrun detection actually takes effect.
> 
> The new helper could be generalised to a 'memset_between()' helper, but
> leave it as a driver-internal helper for now since this needs to go to
> stable.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Peter Seiderer <ps.report@gmx.net>
> Fixes: 037250f0a45c ("ath9k: Properly clear TX status area before reporting to mac80211")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Reviewed-by: Peter Seiderer <ps.report@gmx.net>
> Tested-by: Peter Seiderer <ps.report@gmx.net>

Patch applied to wireless.git, thanks.

5a6b06f5927c ath9k: Fix usage of driver-private space in tx_info

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220404204800.2681133-1-toke@toke.dk/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

