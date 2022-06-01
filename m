Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F7053A0E9
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 11:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351156AbiFAJmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 05:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351364AbiFAJl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 05:41:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E1251E69;
        Wed,  1 Jun 2022 02:41:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C0C26152E;
        Wed,  1 Jun 2022 09:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD218C385A5;
        Wed,  1 Jun 2022 09:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654076510;
        bh=+vvGVfvl3eJVw1BSvVr6Sq0ojnt2IcElWQ2G5CzVv+I=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ftiEFLa8pw28sSEVK6H6v6QR0a+6/2fR1aIv07oXwgwa7s7ZHhVHwmKJs1ODXEfu1
         AAsXSawArDpwYVqm6enxADiuAT97ooE+C5LZfbjVUdFFBJwPOpRWwEfPXGan5XqqPi
         BeztnxWJJ8JZYgvp0pvdcaSjdNHwRU3vReQkHlmeHjfve04AjO2b7o9pvc5EAcdwUG
         wPnat0NMxUCVjWhKIYmoW1TNlk7kyfh2j0UVSHVlaPp0CUhPKGC2EEysK5kRGhZJg9
         1HN4z1rXdjstK4VRpwcK7/Q/c3O5nQaUNMjbNTg1xSgY31T2NS+aIy7mIMMlDCqbA1
         qS1C/YylaJsDQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: mac80211: fix use-after-free in chanctx code
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220601091926.df419d91b165.I17a9b3894ff0b8323ce2afdb153b101124c821e5@changeid>
References: <20220601091926.df419d91b165.I17a9b3894ff0b8323ce2afdb153b101124c821e5@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165407650749.7808.10842549104327768836.kvalo@kernel.org>
Date:   Wed,  1 Jun 2022 09:41:49 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> In ieee80211_vif_use_reserved_context(), when we have an
> old context and the new context's replace_state is set to
> IEEE80211_CHANCTX_REPLACE_NONE, we free the old context
> in ieee80211_vif_use_reserved_reassign(). Therefore, we
> cannot check the old_ctx anymore, so we should set it to
> NULL after this point.
> 
> However, since the new_ctx replace state is clearly not
> IEEE80211_CHANCTX_REPLACES_OTHER, we're not going to do
> anything else in this function and can just return to
> avoid accessing the freed old_ctx.
> 
> Cc: stable@vger.kernel.org
> Fixes: 5bcae31d9cb1 ("mac80211: implement multi-vif in-place reservations")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Patch applied to wireless.git, thanks.

2965c4cdf7ad wifi: mac80211: fix use-after-free in chanctx code

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220601091926.df419d91b165.I17a9b3894ff0b8323ce2afdb153b101124c821e5@changeid/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

