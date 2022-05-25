Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E6A533CC0
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 14:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiEYMgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 08:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiEYMgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 08:36:16 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EB73B033
        for <stable@vger.kernel.org>; Wed, 25 May 2022 05:36:13 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id i40so26865895eda.7
        for <stable@vger.kernel.org>; Wed, 25 May 2022 05:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JnTsdyqsMIp6Mkc/pGpmWvIeAMJseFFk2exHElPDHTk=;
        b=PqoWfGVSxu/X+y7BwtFs5DTYrAi5Ni7AQNKaxJgiuoGO0XSWS7WWlfvKrmwGC39xhZ
         GChUuMI1sKoBWkPo9mQq9hrWJJC4bHXMMWabNhMYjlUaIDnv/o5StX8oyvXRABOtzUNx
         SlRduDbDs9EiPCOGABv1o/4eBrurXChaF+DDtQzPiRWtPMbzNsjZb9lIt07xUUKnsxoo
         jlPskgOgz22SFHiePg/pw9+tQRXCWFj6mPEKNCScELkqYB12zcsrVY6XeThcv2oXaH/c
         gLImVlwkgMcLqmiGnobftk5AFb9mliRmml7R7ZM0a8rTi1rg3kkyW2y6sJ+u9AMg6rrL
         h6OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JnTsdyqsMIp6Mkc/pGpmWvIeAMJseFFk2exHElPDHTk=;
        b=tFeB8LXSRc4gQWziNRDKDDS/GhD8zHyT/Tc+5efEI+q2F3zE9dcjSJabFiwRsWnJeY
         341iTmjsWgNMbKOSBMf4y70jczdDhStGrdu20AuqTY/1eIk9HneuyMEo5uB83EG7T4kp
         Q/alxugRZl+Ogwup6oHnysIgUgXC8dGkmrip0hYXLRm8Cxh7RgIBDDjwiojhj51d2VP5
         7bWlS6xd42VRi8g6DOAh9aSDaMA+/4pr6ush9EiDGs5/cdTHeVdvX1iTMYHJXotOfOaa
         rtIRxi1vJLMIzBB5vTuF+tXAtT8rV6vKJy/iGPBkWDA8OiHaFnFa+KGc7BuMG9i/naey
         9i9A==
X-Gm-Message-State: AOAM531IRpr1LJG9O79/dr7e2ZCvEfRKCZ/9iaelHu4bHcjb1Qo+l+HX
        fIOO18H+bNl7m9GqZX5neqcKZA==
X-Google-Smtp-Source: ABdhPJwiB+cyq+tTxJqIkHFs0l1du5B80GGII32SJRolGm7DzCrcabpx+/jftxtkZPyZc5cZYNIvzg==
X-Received: by 2002:a05:6402:f28:b0:42b:d200:dc9a with SMTP id i40-20020a0564020f2800b0042bd200dc9amr44187eda.6.1653482172320;
        Wed, 25 May 2022 05:36:12 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:2c21:b442:2fc3:f06f? ([2a02:578:8593:1200:2c21:b442:2fc3:f06f])
        by smtp.gmail.com with ESMTPSA id p23-20020a1709060e9700b006fef56adcafsm2515707ejf.206.2022.05.25.05.36.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 05:36:11 -0700 (PDT)
Message-ID: <be79c0fc-25b2-98ad-2e66-4ecfc6a64deb@tessares.net>
Date:   Wed, 25 May 2022 14:36:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] mptcp: Do TCP fallback on early DSS checksum failure
Content-Language: en-GB
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        stable@vger.kernel.org, sashal@kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        MPTCP Upstream <mptcp@lists.linux.dev>
References: <20220524181041.19543-1-mathew.j.martineau@linux.intel.com>
 <Yo3gG9H8Sw/w7baR@kroah.com>
 <0648dc99-7465-871c-90a1-8a69f60d893c@tessares.net>
 <Yo4gPPQ1GVzblG8B@kroah.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <Yo4gPPQ1GVzblG8B@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/05/2022 14:25, Greg KH wrote:
> On Wed, May 25, 2022 at 12:32:04PM +0200, Matthieu Baerts wrote:
>> Hi Greg, Mat,
>>
>> On 25/05/2022 09:51, Greg KH wrote:
>>> On Tue, May 24, 2022 at 11:10:41AM -0700, Mat Martineau wrote:
>>>> [ Upstream commit ae66fb2ba6c3dcaf8b9612b65aa949a1a4bed150 ]
>>>>
>>>> RFC 8684 section 3.7 describes several opportunities for a MPTCP
>>>> connection to "fall back" to regular TCP early in the connection
>>>> process, before it has been confirmed that MPTCP options can be
>>>> successfully propagated on all SYN, SYN/ACK, and data packets. If a peer
>>>> acknowledges the first received data packet with a regular TCP header
>>>> (no MPTCP options), fallback is allowed.
>>>>
>>>> If the recipient of that first data packet finds a MPTCP DSS checksum
>>>> error, this provides an opportunity to fail gracefully with a TCP
>>>> fallback rather than resetting the connection (as might happen if a
>>>> checksum failure were detected later).
>>>>
>>>> This commit modifies the checksum failure code to attempt fallback on
>>>> the initial subflow of a MPTCP connection, only if it's a failure in the
>>>> first data mapping. In cases where the peer initiates the connection,
>>>> requests checksums, is the first to send data, and the peer is sending
>>>> incorrect checksums (see
>>>> https://github.com/multipath-tcp/mptcp_net-next/issues/275), this allows
>>>> the connection to proceed as TCP rather than reset.
>>>>
>>>> Cc: <stable@vger.kernel.org> # 5.17.x
>>>> Cc: <stable@vger.kernel.org> # 5.15.x
>>>> Fixes: dd8bcd1768ff ("mptcp: validate the data checksum")
>>>> Acked-by: Paolo Abeni <pabeni@redhat.com>
>>>> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
>>>> Signed-off-by: David S. Miller <davem@davemloft.net>
>>>> [mathew.j.martineau: backport: Resolved bitfield conflict in protocol.h]
>>>> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
>>>> ---
>>>>
>>>> This patch is already in 5.17.10-rc1 and 5.15.42-rc1, but involves a
>>>> context dependency on upstream commit 4cf86ae84c71 which I have
>>>> requested to be dropped from the stable queues.
>>>>
>>>> I'm posting this backport without the protocol.h conflict to
>>>> (hopefully?) make it easier for the stable maintainers to drop
>>>> 4cf86ae84c71.
>>>>
>>>> For context see https://lore.kernel.org/stable/fa953ec-288f-7715-c6fb-47a222e85270@linux.intel.com/
>>>
>>> THanks, will take this after this round of releases.
>>
>> It might already be too late but is it possible to have this patch
>> ("mptcp: Do TCP fallback on early DSS checksum failure") and "mptcp: fix
>> checksum byte order" in the same stable release?
>>
>> Note that "mptcp: fix checksum byte order" patch has been recently
>> queued by Sasha at the same time as "mptcp: Do TCP fallback on early DSS
>> checksum failure".
>>
>> A bit of context: "mptcp: fix checksum byte order" fixes an important
>> encoding issue but it also breaks the interoperability with previous
>> Linux versions not having this patch.
>>
>> The patch from Mat ("mptcp: Do TCP fallback on early DSS checksum
>> failure") improves the situation when there is this interoperability
>> issue with a previous Linux versions not implementing the RFC properly.
>> The improvement is there to make the MPTCP connections falling back to
>> TCP instead of resetting them: at least there is a connection.
>>
>> In other words, that would be really nice to have these two commits
>> backported together. If it is easier, it looks best to me to delay the
>> main fix ("mptcp: fix checksum byte order") than having the two patches
>> in different stable versions. But I understand it was not clear and
>> maybe too late to do these modifications.
>>
>> Anyway, thank you for your work maintaining these stable versions! :)
> 
> I have already done a release with the first change in it, sorry, but
> have queued this up now.  Given that this is fixing a problem with that
> commit, I'll go do a release right now for 5.17 and 5.15.

I'm sorry for the troubles this is causing you but thank you for doing that!

Please note that on the bright side, the DSS Checksum feature is
disabled by default so hopefully, this interoperability issue should not
affect too many people. It is hard to quantify but I guess there is no
need to rush if you prefer to wait before doing this release.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
