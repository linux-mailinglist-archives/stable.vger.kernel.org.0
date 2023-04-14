Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629FF6E20D7
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 12:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjDNKcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 06:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjDNKce (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 06:32:34 -0400
X-Greylist: delayed 46174 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 14 Apr 2023 03:32:09 PDT
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4175D9009;
        Fri, 14 Apr 2023 03:32:09 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1681468326; bh=NDBLIJpoqluWbT+SNHb4Zjr5K7zRBHfrlvu7guSlJl4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Rx2lfzmgTL2ZSoUPKZZDqtZnpTu9guFuufDFABCcplLB15j2MAn511WD7gV//U+0O
         SInnKE4xcErF1PVl6CEXEjsAG/jZadA4UsLnTW75iqI0YkEv9G3KxNu0Z8yB6vwVWG
         zXaKbShNMixQlZ1wn9O0qmBOHm8+eOshCtjadnHgIKFQjxj3bUw76j/SHSMKUl1A6p
         QbHSvQFY5PEEA85d3rw0D4C5fKW1RpMvDDVjp9KqchG5RO3OV+YJjW5F1vRPEvOrGg
         c3dwXWyL/EbSg6DqGgx3WdqPe0cX5l7nZmg5hSF0aU+v26XpfuuwJqH8QHzKfkj13Z
         7GgPzx2F3RGUg==
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Kalle Valo <quic_kvalo@quicinc.com>,
        Colin Ian King <colin.i.king@gmail.com>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] wifi: ath9k: Don't mark channelmap stack variable
 read-only in ath9k_mci_update_wlan_channels()
In-Reply-To: <87v8hysrzx.fsf@kernel.org>
References: <20230413214118.153781-1-toke@toke.dk> <87v8hysrzx.fsf@kernel.org>
Date:   Fri, 14 Apr 2023 12:32:05 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87bkjqzrdm.fsf@toke.dk>
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

Kalle Valo <kvalo@kernel.org> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>
>> This partially reverts commit e161d4b60ae3a5356e07202e0bfedb5fad82c6aa.
>>
>> Turns out the channelmap variable is not actually read-only, it's modifi=
ed
>> through the MCI_GPM_CLR_CHANNEL_BIT() macro further down in the function,
>> so making it read-only causes page faults when that code is hit.
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D217183
>> Fixes: e161d4b60ae3 ("wifi: ath9k: Make arrays prof_prio and channelmap =
static const")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>
> I guess the casting in MCI_GPM_CLR_CHANNEL_BIT() hide this and made it
> impossible for the compiler to detect it? A perfect example why I hate
> casting :)

Yup, exactly. I was also assuming the compiler would catch it, but yay, C! =
:/

Anyway, cf the bugzilla this was a pretty bad regression for 6.2, so
would be good to move this along reasonably quickly (although I guess we
just missed the -net PR for rc7)...

-Toke
