Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D85051105D
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 07:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357779AbiD0FGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 01:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240085AbiD0FGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 01:06:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8546F7522B;
        Tue, 26 Apr 2022 22:02:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3325DB824AE;
        Wed, 27 Apr 2022 05:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4436C385A9;
        Wed, 27 Apr 2022 05:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651035774;
        bh=Ryk8RyZobT8Xsk55rLKfasMQd9aoSfXpUoz9jmg9C1w=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=uZ0hEjsQhtn5NIRodXZVZEOb+b8NreursonsXHaa98ogCO1eR2y1Qdw/Bz4a6H/bT
         MAFQBSN/uY0BHKogTRpuh2TvhzbXim3yAY02An9d85IgHHXGVUB7qx9XmrFaq3i1Vp
         1fE3I9VyOHtTwp4Qo5V1+NbL0OZ8K2LqDziwDk/Ej1tYw5+1Mwhv2Vvv48PkxZpjLA
         i8mIKRh1PkgJK3EC26UWP/QD2uZS/ESaUwdx28rccNERJJPxraJUobFwWbm8WOE+aR
         ATSfBKs8z+LxZaIJleuvIo265UtfeE553JU95tiQ7+0KsIuGWR7ghB4IZGVGHuM8GC
         iJptZkILu589Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: rtl818x: Prevent using not initialized queues
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220422145228.7567-1-alexander@wetzel-home.de>
References: <20220422145228.7567-1-alexander@wetzel-home.de>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>,
        stable@vger.kernel.org, pa@panix.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165103577076.18987.11755306741060093427.kvalo@kernel.org>
Date:   Wed, 27 Apr 2022 05:02:52 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Alexander Wetzel <alexander@wetzel-home.de> wrote:

> Using not existing queues can panic the kernel with rtl8180/rtl8185 cards.
> Ignore the skb priority for those cards, they only have one tx queue. Pierre
> Asselin (pa@panix.com) reported the kernel crash in the Gentoo forum:
> 
> https://forums.gentoo.org/viewtopic-t-1147832-postdays-0-postorder-asc-start-25.html
> 
> He also confirmed that this patch fixes the issue. In summary this happened:
> 
> After updating wpa_supplicant from 2.9 to 2.10 the kernel crashed with a
> "divide error: 0000" when connecting to an AP. Control port tx now tries to
> use IEEE80211_AC_VO for the priority, which wpa_supplicants starts to use in
> 2.10.
> 
> Since only the rtl8187se part of the driver supports QoS, the priority
> of the skb is set to IEEE80211_AC_BE (2) by mac80211 for rtl8180/rtl8185
> cards.
> 
> rtl8180 is then unconditionally reading out the priority and finally crashes on
> drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c line 544 without this
> patch:
> 	idx = (ring->idx + skb_queue_len(&ring->queue)) % ring->entries
> 
> "ring->entries" is zero for rtl8180/rtl8185 cards, tx_ring[2] never got
> initialized.
> 
> Cc: stable@vger.kernel.org
> Reported-by: pa@panix.com
> Tested-by: pa@panix.com
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>

Patch applied to wireless-next.git, thanks.

746285cf81dc rtl818x: Prevent using not initialized queues

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220422145228.7567-1-alexander@wetzel-home.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

