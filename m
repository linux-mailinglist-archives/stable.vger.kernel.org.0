Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F337B4F1B1A
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379411AbiDDVTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378973AbiDDQNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 12:13:24 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A68B2F009;
        Mon,  4 Apr 2022 09:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649088679;
        bh=8zy/6p/pV0tkzHz053vouiUoj4m9fdn0vkgNGVSD/4M=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=GinRMsdp7HtQEmCuLTfwnVkTB72HeqN06PVFe2imZd4VMCSbRF97bl5XP0aS0WUie
         ytbqmyHVucelzvKPfViR5mAqbqUA4GNJPhxqj8yAUlmfGoAU8cCG7TnqsdqheGB9XT
         VIuUHSwfJD1js6ulQxyV4fdIL/mTgpQ+/h4F0coE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([62.216.209.4]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MRCOK-1nPMd12DHI-00NC4k; Mon, 04
 Apr 2022 18:11:19 +0200
Date:   Mon, 4 Apr 2022 18:11:18 +0200
From:   Peter Seiderer <ps.report@gmx.net>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v5.18] ath9k: Save rate counts before clearing tx status
 area
Message-ID: <20220404181118.515b60ad@gmx.net>
In-Reply-To: <20220402122752.2347797-1-toke@toke.dk>
References: <20220402122752.2347797-1-toke@toke.dk>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MJaNJJ/tTgbL3TaXRwW4cRPQ58/zas+KLuWq4SdYCK/8v78boRa
 N0kBx403ExV/S38iljycj8wxwcr2g5jQ5rFsBbfk1m3KGbROPMn0dB+1aoKV49LBMDJQx8H
 tXbmGGHlkNxqpCY9SlNdXQH6oo/Eshlz2byWN9MQlHdpuZyaTPN+QKnsy/lrLdjS0pubtLC
 GImTeR94n9JdTgfUQ+MhA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:coivBirEVS4=:giaGVAW3Q6IL+MoT1v9bu+
 l9/emL6L+BffmseoUdhcLcES1qVsaPYxif+SFow67JMjh851B4N8K6AujXgvukjJfWra3nPrE
 VIZl4x1lQEU58tEe1IFsF0+jOCasYK3leMvSXli2RgimrEXZG6hJqrY0Ie/kgmz7yF7bUpYNN
 jd5GSplNT8A9ciuweJv6L20S5UNNJxJO8bLziOuiOGW9EQKJ+ziNawbalReXHdxOhBHHPi1P0
 Gl1c2KzPEEXM3LIkE1F5Z4Tl3D/QpxAZOPo/xSceo8n9J9WF3oCe+NdQCH5p2Q3oXYkDH5fB8
 Vqro2hi31aS9OSxcI9Lbg/fOvRPSn3CiPLjZr73o96eV1qObyETZ6TMdVMonOdnyG2XUQAs8+
 GfYLT3Mc+pqZRZrg6Svbs0wM1NKWsgh+XrXZcbzorseGwdrwhKe8qN7yXC/tjTTApTgmdH51j
 XRs0hZeAqv3OCDgpAlCS81Qlc65HhfXD7bvw/Dk8fNOULNbdrGEh9by0BMKzaVg8nqs+YmB70
 yo3/pHWbrSstDiU9B5WzCF66kxx1KnDbgnaAYhzmtz2FeDEwWkcE/sT0JLagD5luIDw9/dI6E
 0wAOwTFxmE+YuM6GT46YTxm+bPe5B0WTReEGRj+2/6fjxM+0ckmU/fDeIAZuheYfe2DjOUMDj
 MLE/ikKgsU6rVmTQkcDStf7FcpISiLmnK9SQYJtrEAMZV2YW4l3Qk9CgnFC7CMmWRMx3RG3Wa
 VPh3c6UNNbw9laqJPHdt1otezkmbrr+/6KStIrIeq3zMw8CHqQBss2KeWCWZIvEXAxq2480Mt
 idO7AitU5H/PdZj72HllXLBpWYIvjLVPRasqtSwnVck+q2WtfAiOocC0Bae0zja8aLElvmpCu
 eXEo6cnNoRbePKpRiMlYng49w8IikVnmlak1NbHGxWBX339DyIu3QQGtgLaAhOfLwobULI4at
 3H4mM0fKqi0CKkZnWqcKeeX78ar6mtTFlcRsyYSZ4YON+ZQQ2+Ivs+Je3pIaVevPFeTkPFxhJ
 F51GIhZFLlJW9d+hU4zKtfuPNORga9x9nOjPhATx5ic88MEQjeKl+KVTrjSMeK5crpxKJgVEG
 4k4eZOKKndKOXY=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Toke,

On Sat,  2 Apr 2022 14:27:51 +0200, Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
toke.dk> wrote:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>=20
> The ieee80211_tx_info_clear_status() helper also clears the rate counts, =
so
> we should restore them after clearing. However, we can get rid of the
> existing clearing of the counts of invalid rates. Rearrange the code a bit
> so the order fits the indexes, and so the setting of the count to
> hw->max_rate_tries on underrun is not immediately overridden.
>=20
> Cc: stable@vger.kernel.org
> Reported-by: Peter Seiderer <ps.report@gmx.net>
> Fixes: 037250f0a45c ("ath9k: Properly clear TX status area before reporti=
ng to mac80211")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless=
/ath/ath9k/xmit.c
> index cbcf96ac303e..ac7efecff29c 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -2551,16 +2551,19 @@ static void ath_tx_rc_status(struct ath_softc *sc=
, struct ath_buf *bf,
>  	struct ieee80211_tx_info *tx_info =3D IEEE80211_SKB_CB(skb);
>  	struct ieee80211_hw *hw =3D sc->hw;
>  	struct ath_hw *ah =3D sc->sc_ah;
> -	u8 i, tx_rateindex;
> +	u8 i, tx_rateindex, tries[IEEE80211_TX_MAX_RATES];
> +
> +	tx_rateindex =3D ts->ts_rateindex;
> +	WARN_ON(tx_rateindex >=3D hw->max_rates);
> +
> +	for (i =3D 0; i < tx_rateindex; i++)
> +		tries[i] =3D tx_info->status.rates[i].count;
> =20
>  	ieee80211_tx_info_clear_status(tx_info);
> =20
>  	if (txok)
>  		tx_info->status.ack_signal =3D ts->ts_rssi;
> =20
> -	tx_rateindex =3D ts->ts_rateindex;
> -	WARN_ON(tx_rateindex >=3D hw->max_rates);
> -
>  	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
>  		tx_info->flags |=3D IEEE80211_TX_STAT_AMPDU;
> =20
> @@ -2569,6 +2572,14 @@ static void ath_tx_rc_status(struct ath_softc *sc,=
 struct ath_buf *bf,
>  	tx_info->status.ampdu_len =3D nframes;
>  	tx_info->status.ampdu_ack_len =3D nframes - nbad;
> =20
> +	for (i =3D 0; i < tx_rateindex; i++)
> +		tx_info->status.rates[i].count =3D tries[i];
> +
> +	tx_info->status.rates[tx_rateindex].count =3D ts->ts_longretry + 1;
> +
> +	for (i =3D tx_rateindex + 1; i < hw->max_rates; i++)
> +		tx_info->status.rates[i].idx =3D -1;
> +
>  	if ((ts->ts_status & ATH9K_TXERR_FILT) =3D=3D 0 &&
>  	    (tx_info->flags & IEEE80211_TX_CTL_NO_ACK) =3D=3D 0) {
>  		/*
> @@ -2591,12 +2602,6 @@ static void ath_tx_rc_status(struct ath_softc *sc,=
 struct ath_buf *bf,
>  				hw->max_rate_tries;
>  	}

The full lines above read:

2597                 if (unlikely(ts->ts_flags & (ATH9K_TX_DATA_UNDERRUN |
2598                                              ATH9K_TX_DELIM_UNDERRUN))=
 &&
2599                     ieee80211_is_data(hdr->frame_control) &&=20
2600                     ah->tx_trig_level >=3D sc->sc_ah->config.max_txtri=
g_level     )
2601                         tx_info->status.rates[tx_rateindex].count =3D
2602                                 hw->max_rate_tries;
2603         }

So this patch fixes by drive-by a overwrite of tx_info->status.rates[tx_rat=
eindex].count...

> =20
> -	for (i =3D tx_rateindex + 1; i < hw->max_rates; i++) {
> -		tx_info->status.rates[i].count =3D 0;
> -		tx_info->status.rates[i].idx =3D -1;
> -	}
> -
> -	tx_info->status.rates[tx_rateindex].count =3D ts->ts_longretry + 1;
>  }
> =20
>  static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)

Otherwise looks good ;-), would like to give a Reviewed-by/Tested-by but st=
ill
affected by the underlying ieee80211_tx_info status vs. rate_driver_data ov=
erwrite
as mentioned in the other thread (see [1])...

Regards,
Peter


[1] https://lore.kernel.org/linux-wireless/20220404130453.5ec6e045@gmx.net/
