Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F2F6BBE2B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 21:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjCOUxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 16:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjCOUxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 16:53:51 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B331A655;
        Wed, 15 Mar 2023 13:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net; s=s31663417;
        t=1678913618; i=rauchwolke@gmx.net;
        bh=XhWUJQui0NrzKlaAq8XLqzlkawl2PqZIDMaWHIvXXFA=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=KcZx5FxndbgqsD865GWQFXS4LZOIIJQWlVoCqwr3z2UBPvEMzOYBO2B0TcvX9K1pu
         Vy44YdvCgl32UXC4E0dQGcAHvfMdRvZCvreLeIhgEsTQIdz2uVrzv/148hZAv4lLvL
         BHgAP3q7POzzPJVpFnm3DouYl2tbNLP4YQUAJqmWbrh9MxFZ1Ozc92o8tgNED23X+u
         DrxfMphIXYm22cwzhPpCYmmCH0VdMcg4BQ8NqLJY8FUAcIhS1t2WwLTUJyPA17wntz
         E4AubpTWt3cTF2QAlZAwtMTDfUk/TyeFd/NTvcMVCaPAnTzw1fMUkv885K/ZgQ4uKj
         DimyA4Iq/NV4Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from polar.lan ([62.178.199.114]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mf07E-1q983P3taU-00gYDQ; Wed, 15
 Mar 2023 21:53:38 +0100
Date:   Wed, 15 Mar 2023 21:53:39 +0100
From:   Thomas Mann <rauchwolke@gmx.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     johannes@sipsolutions.net, nbd@nbd.name,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] wifi: mac80211: Serialize
 ieee80211_handle_wake_tx_queue()
Message-ID: <20230315215339.04659cf8@polar.lan>
In-Reply-To: <20230315190731.145997-1-alexander@wetzel-home.de>
References: <20230315190731.145997-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:7Dr3sJm6dkFJMJnZORtbeH1SCczvfCsgDOChqcB5yhkqJr+nyjZ
 cOzEgpLxJKCg1x0gjr0aRwrt/p55CSoeEliVx6B/udJx7O0vQeJD1255IKhhO5xp4AMC25Y
 mFXgQKB9dmiQuFm5/XsTcikoW1UvqsNn17wv+EqhXAir8x/jINBVYIRUFvXCqDQ0M3ebSwn
 2iOV9OGyC09imLd7Llomg==
UI-OutboundReport: notjunk:1;M01:P0:NUEoiCj4v+U=;esyD/3bQOOkzdenmqZOGQRT/6l+
 0RWlh6LUMvldeUmj4v0sUUPP5E9qkMba/huD+W8NFLCD/MCX2FJTpo2HFPqhYgVAD6xmBgFRU
 dKBhKQx/oi+0/0o9GVcc7YjUVNFb8/v3rtFtQJB9ZVFcP4GcxXRGhBK8EERvYxcnK8jldzzVo
 e55Zoa0uwGe5MdvXTtbu90G7nHm+BldQ+r6jCiJf14TfcwXe44Lry4c9FPDLxm1FCDkUE8X/t
 xJ76lqglJpkl9MBeyUwF8aLE6gBwzFVEEJQlsYn7imFIfwHyXkmXBornYLhTFcRXCIyyqbPa4
 lsTPJRlTYx7G5kdF2gO/h1aRX2gUIBvcypoqqP0kBYvg/I07NWrFKYKxTNdjCDA2y8ikySN3i
 fyfvZrRnIvml4XXWwfsdThHwajF3+6IRNq7yVQJ6o4PiL6iknTIQx5wcMRIafUQlEAqCMlY8X
 /Ge/Fry/coLBnuAJyYrrRYalaBM6e5x4oZU5EUQImzceMkYqmDckpmGyUWIQYojuqQALYTInj
 vtazsPiZdGRAPj4SUP2WRvQ3cgtL+Gy3IfZcpSkdT0VVYPTWXArzILWx7SeJsWHxcazx9tAkq
 ufJLHeAima6dCtR6LEr6az0qtXyHYBkQYhLIsnXs/toVKsBPJpYJOwWMTgW4uDSdRAQ4yOMaU
 VgC2W2y0kI62af5Bb+cJQggqI6bYkdOQjPTJpMObkAh+W6wkglNx56yosoUZi5GP/nfVEJs/d
 Kd66nTOJ8hCqsgp1RhwVJIkJ7Ct77ordt3LVdyYNRB6Zp4u8rfxA8NJ/KwnlKhFcaIbS2eAi9
 jGC5Op00mIf+cybcM3qA1mvhlT2VpKq+fGHyfsvgX8zDYOgqIGElsQHUNVjrvwmClXACBi6BB
 zMTDKYIg4k1Mu1Wr43kLICAeJ/PbnztM/YTQys5xDM4QihCWydVqEU/Fk353/xFb2Bllywx1T
 tcT1Jkw9W4AlSWsILWg5XxvBoI4=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

this patch fixes the bug for me too.

Thanks for fixing it!

Regards

On Wed, 15 Mar 2023 20:07:31 +0100
Alexander Wetzel <alexander@wetzel-home.de> wrote:

> ieee80211_handle_wake_tx_queue must not run concurrent.
> It calls ieee80211_txq_schedule_start() and the drivers migrated to
> iTXQ do not expect overlapping drv_tx() calls.
>
> This fixes commit c850e31f79f0 ("wifi: mac80211: add internal handler
> for wake_tx_queue"), which introduced
> ieee80211_handle_wake_tx_queue(). Drivers started to use it with
> commit a790cc3a4fad ("wifi: mac80211: add wake_tx_queue callback to
> drivers"). But only after fixing an independent bug with commit
> 4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")
> problematic concurrent calls really happened and exposed the initial
> issue.
>
> Fixes: c850e31f79f0 ("wifi: mac80211: add internal handler for
> wake_tx_queue") Reported-by: Thomas Mann <rauchwolke@gmx.net>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D217119
> Link:
> https://lore.kernel.org/r/b8efebc6-4399-d0b8-b2a0-66843314616b@leemhuis.=
info/
> Link:
> https://lore.kernel.org/r/b7445607128a6b9ed7c17fcdcf3679bfaf4aaea.camel@=
sipsolutions.net>
> CC: <stable@vger.kernel.org> Signed-off-by: Alexander Wetzel
> <alexander@wetzel-home.de> ---
>
> V1..V2
> Added the missing spinlock Felix pointed out and fixed the commit
> references with the feedback from Kalle.
> ---
>  net/mac80211/ieee80211_i.h | 3 +++
>  net/mac80211/main.c        | 1 +
>  net/mac80211/util.c        | 3 +++
>  3 files changed, 7 insertions(+)
>
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index ecc232eb1ee8..e082582e0aa2 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -1284,6 +1284,9 @@ struct ieee80211_local {
>  	struct list_head active_txqs[IEEE80211_NUM_ACS];
>  	u16 schedule_round[IEEE80211_NUM_ACS];
>
> +	/* serializes ieee80211_handle_wake_tx_queue */
> +	spinlock_t handle_wake_tx_queue_lock;
> +
>  	u16 airtime_flags;
>  	u32 aql_txq_limit_low[IEEE80211_NUM_ACS];
>  	u32 aql_txq_limit_high[IEEE80211_NUM_ACS];
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 846528850612..3b622f2b787b 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -788,6 +788,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t
> priv_data_len, spin_lock_init(&local->filter_lock);
>  	spin_lock_init(&local->rx_path_lock);
>  	spin_lock_init(&local->queue_stop_reason_lock);
> +	spin_lock_init(&local->handle_wake_tx_queue_lock);
>
>  	for (i =3D 0; i < IEEE80211_NUM_ACS; i++) {
>  		INIT_LIST_HEAD(&local->active_txqs[i]);
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 1a28fe5cb614..3aceb3b731bf 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -314,6 +314,8 @@ void ieee80211_handle_wake_tx_queue(struct
> ieee80211_hw *hw, struct ieee80211_sub_if_data *sdata =3D
> vif_to_sdata(txq->vif); struct ieee80211_txq *queue;
>
> +	spin_lock(&local->handle_wake_tx_queue_lock);
> +
>  	/* Use ieee80211_next_txq() for airtime fairness accounting
> */ ieee80211_txq_schedule_start(hw, txq->ac);
>  	while ((queue =3D ieee80211_next_txq(hw, txq->ac))) {
> @@ -321,6 +323,7 @@ void ieee80211_handle_wake_tx_queue(struct
> ieee80211_hw *hw, ieee80211_return_txq(hw, queue, false);
>  	}
>  	ieee80211_txq_schedule_end(hw, txq->ac);
> +	spin_unlock(&local->handle_wake_tx_queue_lock);
>  }
>  EXPORT_SYMBOL(ieee80211_handle_wake_tx_queue);
>

