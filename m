Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C994F01FF
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 15:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352792AbiDBNQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 09:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346501AbiDBNQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 09:16:47 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750556553;
        Sat,  2 Apr 2022 06:14:55 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1648905294; bh=vKZaNhqeUWallcqyw2qD7Jq/dDYxww72yxBWf+oyMPg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=PrLTLH2G2H8yRMUcc0dRtL+PF+WsxF+LPJlZ0/5aBMOXOjuX2FnWMAT0NcKrIBps9
         A80MrAAQGfoMWXl4hS3nwtM3LmBdpZYYavc80/uoto/Di6GAUGQUugBHdiLUWCfKyI
         WcbX5GIrxgSUHgAlInX99NjEitg6bEufXcZ8fdRAP9bXsthoqmu3cjNSmOC9SXrejC
         cv3N9lzM6/ZXeH3jYTchHx+VrKR9U7Ivcyv5rPSZBveljVQd2iNC+bouzcqTviTZg7
         JILpZgjtozzf4UFHGmroOb/87404ROY3m86kJYHAHsO0js2CZbP7nlqG4I6BlOZH54
         r/wxcukFQSSiA==
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        stable@vger.kernel.org, Peter Seiderer <ps.report@gmx.net>
Subject: Re: [PATCH v5.18] ath9k: Save rate counts before clearing tx status
 area
In-Reply-To: <YkhEO9teh58RdrXR@kroah.com>
References: <20220402122752.2347797-1-toke@toke.dk>
 <YkhEO9teh58RdrXR@kroah.com>
Date:   Sat, 02 Apr 2022 15:14:53 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87o81jfwz6.fsf@toke.dk>
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

Greg KH <gregkh@linuxfoundation.org> writes:

> On Sat, Apr 02, 2022 at 02:27:51PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
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
>
> What is the git commit id of this change in Linus's tree?

You mean the commit referred to in the Fixes: tag, right? That's not in
Linus' tree yet, it's a follow-up to a commit that was merged into the
wireless tree yesterday and marked for stable, so the two commits should
be added to stable together once they do hit Linus' tree.

I forgot to add the stable Cc when sending out the previous patch, so
Kalle added it when committing; so I guess you haven't seen that one? :)

-Toke
