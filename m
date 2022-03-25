Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56254E7B5C
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbiCYUHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 16:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiCYUHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 16:07:31 -0400
Received: from meesny.iki.fi (meesny.iki.fi [IPv6:2001:67c:2b0:1c1::201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641BE4578A;
        Fri, 25 Mar 2022 13:03:05 -0700 (PDT)
Received: from [172.16.24.240] (73-55.dynamonet.fi [85.134.55.73])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: tmb)
        by meesny.iki.fi (Postfix) with ESMTPSA id 8632D20034;
        Fri, 25 Mar 2022 19:36:47 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
        t=1648229807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1+FRaduQeESmuKYRTCT5Rbst5a/a4/BE0qFe/49USy8=;
        b=F1rCdqG1z0iNOaQZucwBXfLcgd2p4lS2q5UhMmEZhIAWbGEE+0+e9De543m+3YpkfIHbfv
        7XiGmosOOjGb2/CUVqxMORazvhR9rEwmWtHIOpKPWDhblEl6857m67THRT5LPOURlCslp6
        ykGSTrr3Yru1iZ3S9spoCIPNO7TEpwo=
Message-ID: <60a29ef1-b433-3832-d052-50ce834ba916@iki.fi>
Date:   Fri, 25 Mar 2022 19:36:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10 11/38] swiotlb: rework "fix info leak with
 DMA_FROM_DEVICE"
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>
References: <20220325150419.757836392@linuxfoundation.org>
 <20220325150420.085364078@linuxfoundation.org>
 <CAHk-=wiaeZKiEk87Sms1sy53m8tT3UCLOoeUBnX1c_1dZ78WjQ@mail.gmail.com>
From:   Thomas Backlund <tmb@iki.fi>
In-Reply-To: <CAHk-=wiaeZKiEk87Sms1sy53m8tT3UCLOoeUBnX1c_1dZ78WjQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=tmb smtp.mailfrom=tmb@iki.fi
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1648229807; a=rsa-sha256; cv=none;
        b=Y7dv7WoPZWY41Y2TwKwqFxB33dMnbguDMN2cc+pNMXRP0Hfs19D4qPauJlRLU16s9DEtkf
        abvFdhVBjz3ef7yaLbGNqnLvyLbcOYoMrxVBS3YaY/muJQpPg9lGkkNiYUzpDk0rqwnwak
        70WQsxDB8ho94MEYOK6QtmDczjReWJ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=meesny; t=1648229807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1+FRaduQeESmuKYRTCT5Rbst5a/a4/BE0qFe/49USy8=;
        b=SNL5W8dwAHaHxa/Ryo4spcZ9xEABDZPVZl65SghvKMpcQM0ox2cDKiTCP/I3xWRl3M8Kkb
        DmZUxDhhTFBTpdow/nMZIVi/0nh553DNVpenLpiYK96aIS3rdreUpfsI8fmwaeBPV6ZU1j
        CzhV7CNWHc1aQT45nTrW02AWztyJE20=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 2022-03-25 kl. 19:08, skrev Linus Torvalds:
> On Fri, Mar 25, 2022 at 8:09 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> From: Halil Pasic <pasic@linux.ibm.com>
>>
>> commit aa6f8dcbab473f3a3c7454b74caa46d36cdc5d13 upstream.
> 
> This one causes a regression on at least some wireless drivers
> (ath9k). There's some active discussion about it, maybe it gets
> reverted, maybe there are other options.
> 
> There's an ath9k patch that fixes the problem, so if this patch goes
> into the stable tree the ath9k fix will follow.
> 
> But it might be a good idea to simply hold off on this patch a bit,
> because that ath9k patch hasn't actually landed yet, there's some
> discussion about it all, and it's not clear that other drivers might
> not have the same issue.
> 
> So I'm not NAK'ing this patch from stable, but I also don't think it's
> timing-critical, and it might be a good idea to delay it for a week or
> two to both wait for the ath9k patch and to see if something else
> comes up.
> 
>                Linus
> 


As it has already landed in 5.15.29 and 5.16.15 it should IMHO 
preferably be reverted in those trees too to get them back to working 
state...


--
Thomas
