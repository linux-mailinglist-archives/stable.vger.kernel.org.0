Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4DC4F0201
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 15:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355262AbiDBNRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 09:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355259AbiDBNRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 09:17:12 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD4550E1C;
        Sat,  2 Apr 2022 06:15:20 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1648905319; bh=DDaAG2e7mgiqXy4ZWzsvJ4jI3ZsoDxGnOvMuS0wZU8M=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=RngxIFg0bCkEVZS6HQ9JRYA4/W4/M7BK8W4QgGVQy1r2jaJhAqfhB9h5qw9Eu8/Iz
         c7OGcYOEf3pYywwgd9x0u0CiedtQK3I8kpgHmXYPo2Wa5vmgNq2XDkboF7RAL60gsU
         RE2cwxzn10hwiZFiOXdIW0z4Cl/b7W2q8uaxBOxhp3xlcJJrDmOFE89dtx0yH+bs4h
         grVtk8vtH5t1IG01GoxXar2/Uoj51Om5c0ZHRW7YoESmIAoQO9JjNPNRwGrvdOz9uC
         Q8mGsGT4c6JTk+405xDCDXtiEOnuOiJAu/ZAOqcySGir47hvp5YXsJLkhk1aGeVVb7
         szFSKsi4d/L/g==
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Peter Seiderer <ps.report@gmx.net>
Subject: Re: [PATCH v5.18] ath9k: Save rate counts before clearing tx status
 area
In-Reply-To: <d04373063ca88490d95101e52cd1b65d123d207e.camel@sipsolutions.net>
References: <20220402122752.2347797-1-toke@toke.dk>
 <d04373063ca88490d95101e52cd1b65d123d207e.camel@sipsolutions.net>
Date:   Sat, 02 Apr 2022 15:15:19 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87lewnfwyg.fsf@toke.dk>
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

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2022-04-02 at 14:27 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>> @@ -2591,12 +2602,6 @@ static void ath_tx_rc_status(struct ath_softc *sc=
, struct ath_buf *bf,
>>  				hw->max_rate_tries;
>>  	}
>>=20=20
>> -	for (i =3D tx_rateindex + 1; i < hw->max_rates; i++) {
>
> might want to drop that blank line too :)
>
>> -		tx_info->status.rates[i].count =3D 0;
>> -		tx_info->status.rates[i].idx =3D -1;
>> -	}
>> -
>> -	tx_info->status.rates[tx_rateindex].count =3D ts->ts_longretry + 1;
>>  }
>
> since there's nothing else.

Hmm, fair point; Kalle, I don't suppose I could trouble you for a fixup
when committing? :)

-Toke
