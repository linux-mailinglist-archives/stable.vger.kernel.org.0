Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840FB551F0C
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241112AbiFTOjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349114AbiFTOin (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 10:38:43 -0400
X-Greylist: delayed 536 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Jun 2022 06:56:26 PDT
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D1C2181;
        Mon, 20 Jun 2022 06:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1655733368;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=4lhgN+ZI3dPGIFegFe0CmokyjhjAq7kqoHQxu3MoKrA=;
    b=NPwciXZQX4bXqgJqGAmAInvCD+GsyvfkxZX4VL0F4q6b2F8Ui+FmByCIz65b97g8f9
    XYDdbqwGbpBH/xkRr4jCICMmwxKqtlzUKrdJr9hVwY0FRGn058uk2t76ijI3+e2pTP6E
    06SEdfUoG8pdi8htQxAVzZ7CPi7QSle1veEv/QE6l+hDCOme1k/PeNsZZH+XRF1O5l5h
    TRVY4XqKNZmNuiQ1IoBYyoVqYRhP5JAj4t4nLhi4VFHRwcK9+Uu8SYAV5mek6r44A4mf
    DhyCLiq8g7+FkY42FK/fCMxW0kk0T0AVcEnPLXmrG0Jwg1qnzbpqfHniD0eBGHuAXrHY
    KwdQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOuh2kneQdYGqA2E4P8JkCzsEGifkMD"
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b00:6774:46a:3797:c828]
    by smtp.strato.de (RZmta 47.46.0 AUTH)
    with ESMTPSA id D7afdcy5KDu8F5A
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 20 Jun 2022 15:56:08 +0200 (CEST)
Message-ID: <4a53cf90-6ed9-c1b6-2974-3a0d1836c3b3@hartkopp.net>
Date:   Mon, 20 Jun 2022 15:56:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.18 081/141] net: remove noblock parameter from
 skb_recv_datagram()
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
References: <20220620124729.509745706@linuxfoundation.org>
 <20220620124731.932460774@linuxfoundation.org>
 <04920243-e585-edf6-a849-cfa5a2ff6ba1@hartkopp.net>
 <YrB8Jpk9FUqIxT/1@kroah.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <YrB8Jpk9FUqIxT/1@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/20/22 15:54, Greg Kroah-Hartman wrote:
> On Mon, Jun 20, 2022 at 03:44:08PM +0200, Oliver Hartkopp wrote:
>> Hello Greg,
>>
>> as already answered to Sascha:
>>
>> ---
>>
>> Hello Sasha,
>>
>> this patch is some kind of improvement/simplification to reduce and clean up
>> the number of variables passed through skb_recv_datagram() call.
>>
>> There is no functional change and therefore no need to backport this patch
>> IMO.
> 
> It is needed by a follow-on patch that fixes a real issue.

Ah, ok! Wasn't aware of that follow-on patch.

Sorry for the noise ;-)

Many thanks,
Oliver
