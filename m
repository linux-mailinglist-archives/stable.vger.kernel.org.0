Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1AD64F1B7A
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355286AbiDDVTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380641AbiDDUrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 16:47:45 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E11B13E9A;
        Mon,  4 Apr 2022 13:45:48 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1649105146; bh=PPkiu+urIKPtgvOJca3nK/rJD3o5hAzywiUYLWo5p4w=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Q8w2Q5ZZ7Oa4YQR1jpAjtNPxmIDsN8CJHipsYyQ34L+BC+deTHN6RAu9jPZtq1QQ2
         4OhsIy0/FhHNnz44hvYD3SFSZKBEiGw4ZUBxD7OAMWTR5Zs/9FeF2LA1saRk+5vgzu
         0/ox5vIrlQXFWb/Oa8F7hurGPVtv7LDm3POBDVQS6fi+hI+xgCET0vK+vKDhVBz9Y/
         2og+XcRmYaBMSoBforsDnB1NHymVME2GkzwyDVtxmUlzP42Z6mfvEuSJ9+BarS77IT
         HqyC2MvjJGCqG/N5yqBxrOHwN2Sqhk5LC9ZW6lOY0paylqsrHhILmw1BtPdXBQhmBg
         dAqVSg+GtdMwQ==
To:     Peter Seiderer <ps.report@gmx.net>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH for-5.18 v2] ath9k: Fix usage of driver-private space in
 tx_info
In-Reply-To: <20220404222655.7276fb9d@gmx.net>
References: <20220404181151.2669173-1-toke@toke.dk>
 <20220404222655.7276fb9d@gmx.net>
Date:   Mon, 04 Apr 2022 22:45:46 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <877d84efwl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Peter Seiderer <ps.report@gmx.net> writes:

> Hello Toke,
>
> On Mon,  4 Apr 2022 20:11:51 +0200, Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@toke.dk> wrote:
>
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>=20
>> The ieee80211_tx_info_clear_status() helper also clears the rate counts =
and
>> the driver-private part of struct ieee80211_tx_info, so using it breaks
>> quite a few other things. So back out of using it, and instead define a
>> ath-internal helper that only clears the area between the
>> status_driver_data and the rates info. Combined with moving the
>> ath_frame_info struct to status_driver_data, this avoids clearing anythi=
ng
>> we shouldn't be, and so we can keep the existing code for handling the r=
ate
>> information.
>>=20
>> While fixing this I also noticed that the setting of
>> tx_info->status.rates[tx_rateindex].count on hardware underrun errors was
>> always immediately overridden by the normal setting of the same fields, =
so
>> rearrange the code so that the underrun detection actually takes effect.
>>=20
>> The new helper could be generalised to a 'memset_between()' helper, but
>> leave it as a driver-internal helper for now since this needs to go to
>> stable.
>>=20
>> Cc: stable@vger.kernel.org
>> Reported-by: Peter Seiderer <ps.report@gmx.net>
>> Fixes: 037250f0a45c ("ath9k: Properly clear TX status area before report=
ing to mac80211")
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/xmit.c | 30 ++++++++++++++++++---------
>>  1 file changed, 20 insertions(+), 10 deletions(-)
>>=20
>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireles=
s/ath/ath9k/xmit.c
>> index cbcf96ac303e..db83cc4ba810 100644
>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>> @@ -141,8 +141,8 @@ static struct ath_frame_info *get_frame_info(struct =
sk_buff *skb)
>>  {
>>  	struct ieee80211_tx_info *tx_info =3D IEEE80211_SKB_CB(skb);
>>  	BUILD_BUG_ON(sizeof(struct ath_frame_info) >
>> -		     sizeof(tx_info->rate_driver_data));
>> -	return (struct ath_frame_info *) &tx_info->rate_driver_data[0];
>> +		     sizeof(tx_info->status.status_driver_data));
>> +	return (struct ath_frame_info *) &tx_info->status.status_driver_data[0=
];
>>  }
>
> Would be too easy if all locations would use get_frame_info()..., at leas=
t one location
> in drivers/net/wireless/ath/ath9k/main.c uses direct access:
>
>  841                 txinfo =3D IEEE80211_SKB_CB(bf->bf_mpdu);
>  842                 fi =3D (struct ath_frame_info *)&txinfo->rate_driver=
_data[0];
>  843                 if (fi->keyix =3D=3D keyix)
>  844                         return true;

Ah, bugger; nice find! I'll fix that up as well, but I do believe it's
the only one.

-Toke
