Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3444F47DA
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346121AbiDEVWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573227AbiDES1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 14:27:35 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B84625C2;
        Tue,  5 Apr 2022 11:25:34 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1649183131; bh=z/z39V2h2Ell0dkMKVRzEpV5Eg6+3vxUnVLnfYEBrgk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=sZpeQsF6h7Sz8UOnGoOfUZJ+CXEwWeXR88bGHvZwbEIHRRQ4ntkCJ9ttrl6Pt71Kk
         1UqGn27RMYPz1n6pTTB2UYm+B4ZsTQfDNXZvGznZrxQAoZQRNPgnHRqiSuvJL2Ygmi
         cxf1nOhRjc/Gs5ARWFnLqCL1CBx0KLFLr3gnKT/9H0DasdjHYLOhul3sy9Aq75D5JN
         XUvUFlrqqYU2eWVT30ztxsMcUraQCVYWMBCEdqfBs2d4nONzhClD9KNSVWq2VRhYTU
         wDdI2mDG44DikGHo1Msm1BZoHRpDAzHYtjbu6zXHywS21Q65DtwtqsPjGd6Oor/bAK
         g58gh9NYNhzuA==
To:     Peter Seiderer <ps.report@gmx.net>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH for-5.18 v3] ath9k: Fix usage of driver-private space in
 tx_info
In-Reply-To: <20220405184908.7fb44111@gmx.net>
References: <20220404204800.2681133-1-toke@toke.dk>
 <20220405184908.7fb44111@gmx.net>
Date:   Tue, 05 Apr 2022 20:25:30 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <874k37e6at.fsf@toke.dk>
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
> On Mon,  4 Apr 2022 22:48:00 +0200, Toke H=C3=B8iland-J=C3=B8rgensen <tok=
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
>
> And finally found time to test your latest version of the patch, you can =
add my
>
> Reviewed-by: Peter Seiderer <ps.report@gmx.net>
> Tested-by: Peter Seiderer <ps.report@gmx.net>

Awesome! Thanks for testing! :)

-Toke
