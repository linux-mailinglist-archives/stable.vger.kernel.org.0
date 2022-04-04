Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996454F1B13
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379442AbiDDVTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379547AbiDDR3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 13:29:37 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697BB24BF9;
        Mon,  4 Apr 2022 10:27:40 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1649093259; bh=IJU11DU/QrW9iqVMiJGOGZmJCQr5ziv8W0ZcyFcdZtI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=xiHQqBAiJOBp+9qWJrK7CTfzc661kLgsXSKbhEY1sRFhL9184sblR/y8X6yxw4XjC
         0wdCKmjaqcTgQMFZnZ9keGbvI58fVttpjipCPPRYKkae+oHnoLzSuEa4ZN0saAyjNy
         nYwTmPWKDiqzgtGvslYoe88SI8NBBO3JqDLS6M6CfQd8+QDzVtybRwbpbvuf68ysWc
         VwdfelinAO4n7S2KtUlFgz5QfvJf3mMxzPoRwjeJvAKUvEYKeTtYR8nV1Epn6f0F/z
         g3pcGXPaMJ4XXJzAut0/PZcgyhvFLzfB94VyZVqW0ty4upa5taRaMbXGTZFgeG/zMi
         Kzw5h2jewLz6w==
To:     Peter Seiderer <ps.report@gmx.net>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v5.18] ath9k: Save rate counts before clearing tx status
 area
In-Reply-To: <20220404181118.515b60ad@gmx.net>
References: <20220402122752.2347797-1-toke@toke.dk>
 <20220404181118.515b60ad@gmx.net>
Date:   Mon, 04 Apr 2022 19:27:38 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87lewkep2t.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Peter Seiderer <ps.report@gmx.net> writes:

> Hello Toke,
>
> On Sat,  2 Apr 2022 14:27:51 +0200, Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@toke.dk> wrote:
>
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>=20
>> The ieee80211_tx_info_clear_status() helper also clears the rate counts,=
 so
>> we should restore them after clearing. However, we can get rid of the
>> existing clearing of the counts of invalid rates. Rearrange the code a b=
it
>> so the order fits the indexes, and so the setting of the count to
>> hw->max_rate_tries on underrun is not immediately overridden.
>>=20
>> Cc: stable@vger.kernel.org
>> Reported-by: Peter Seiderer <ps.report@gmx.net>
>> Fixes: 037250f0a45c ("ath9k: Properly clear TX status area before report=
ing to mac80211")
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/xmit.c | 25 +++++++++++++++----------
>>  1 file changed, 15 insertions(+), 10 deletions(-)
>>=20
>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireles=
s/ath/ath9k/xmit.c
>> index cbcf96ac303e..ac7efecff29c 100644
>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>> @@ -2551,16 +2551,19 @@ static void ath_tx_rc_status(struct ath_softc *s=
c, struct ath_buf *bf,
>>  	struct ieee80211_tx_info *tx_info =3D IEEE80211_SKB_CB(skb);
>>  	struct ieee80211_hw *hw =3D sc->hw;
>>  	struct ath_hw *ah =3D sc->sc_ah;
>> -	u8 i, tx_rateindex;
>> +	u8 i, tx_rateindex, tries[IEEE80211_TX_MAX_RATES];
>> +
>> +	tx_rateindex =3D ts->ts_rateindex;
>> +	WARN_ON(tx_rateindex >=3D hw->max_rates);
>> +
>> +	for (i =3D 0; i < tx_rateindex; i++)
>> +		tries[i] =3D tx_info->status.rates[i].count;
>>=20=20
>>  	ieee80211_tx_info_clear_status(tx_info);
>>=20=20
>>  	if (txok)
>>  		tx_info->status.ack_signal =3D ts->ts_rssi;
>>=20=20
>> -	tx_rateindex =3D ts->ts_rateindex;
>> -	WARN_ON(tx_rateindex >=3D hw->max_rates);
>> -
>>  	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
>>  		tx_info->flags |=3D IEEE80211_TX_STAT_AMPDU;
>>=20=20
>> @@ -2569,6 +2572,14 @@ static void ath_tx_rc_status(struct ath_softc *sc=
, struct ath_buf *bf,
>>  	tx_info->status.ampdu_len =3D nframes;
>>  	tx_info->status.ampdu_ack_len =3D nframes - nbad;
>>=20=20
>> +	for (i =3D 0; i < tx_rateindex; i++)
>> +		tx_info->status.rates[i].count =3D tries[i];
>> +
>> +	tx_info->status.rates[tx_rateindex].count =3D ts->ts_longretry + 1;
>> +
>> +	for (i =3D tx_rateindex + 1; i < hw->max_rates; i++)
>> +		tx_info->status.rates[i].idx =3D -1;
>> +
>>  	if ((ts->ts_status & ATH9K_TXERR_FILT) =3D=3D 0 &&
>>  	    (tx_info->flags & IEEE80211_TX_CTL_NO_ACK) =3D=3D 0) {
>>  		/*
>> @@ -2591,12 +2602,6 @@ static void ath_tx_rc_status(struct ath_softc *sc=
, struct ath_buf *bf,
>>  				hw->max_rate_tries;
>>  	}
>
> The full lines above read:
>
> 2597                 if (unlikely(ts->ts_flags & (ATH9K_TX_DATA_UNDERRUN |
> 2598                                              ATH9K_TX_DELIM_UNDERRUN=
)) &&
> 2599                     ieee80211_is_data(hdr->frame_control) &&=20
> 2600                     ah->tx_trig_level >=3D sc->sc_ah->config.max_txt=
rig_level     )
> 2601                         tx_info->status.rates[tx_rateindex].count =3D
> 2602                                 hw->max_rate_tries;
> 2603         }
>
> So this patch fixes by drive-by a overwrite of
> tx_info->status.rates[tx_rateindex].count...

Yeah, that was intentional; the setting of
tx_info->status.rates[tx_rateindex].count you quoted never had any
effect, which I'm assuming is not deliberate :)

>>=20=20
>> -	for (i =3D tx_rateindex + 1; i < hw->max_rates; i++) {
>> -		tx_info->status.rates[i].count =3D 0;
>> -		tx_info->status.rates[i].idx =3D -1;
>> -	}
>> -
>> -	tx_info->status.rates[tx_rateindex].count =3D ts->ts_longretry + 1;
>>  }
>>=20=20
>>  static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
>
> Otherwise looks good ;-), would like to give a Reviewed-by/Tested-by but =
still
> affected by the underlying ieee80211_tx_info status vs. rate_driver_data =
overwrite
> as mentioned in the other thread (see [1])...

No worries, I'll respin with a fix for that as well (as soon as I figure
out the right way to fix it), so just wait until v2 and give that a spin
instead :)

-Toke
