Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90EB7533AA5
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 12:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240348AbiEYKcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 06:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239770AbiEYKcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 06:32:08 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CD495A19
        for <stable@vger.kernel.org>; Wed, 25 May 2022 03:32:06 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ck4so36492233ejb.8
        for <stable@vger.kernel.org>; Wed, 25 May 2022 03:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pdJRdc/ChWME/KxDvyR3ZmETgfGtqY1xnlD8l9hYebU=;
        b=PXpN/dttRaV6ZjRj3+8fM5fKOugMRbKVV77YrS82pZiguRVn/eRCelxJ0wNCcUm51g
         SBxGCUBNIXvf3f2bbAK2WY6hWO04JBntvKRC+yS31yDGZfajdTFIofOqKGJtKhra+iLP
         7/nyDujb5uxiX6Z07t+uIGhpU7xOtm2mgWl29ciH0qJkVTIwa6Sen+pKWb/c96RQq2mb
         s60fT+z+Xcq+FG38TOT14eteHndjAaYiTWDZyXQBDAY0hVnTLM2AWOOyfUCdxqOsXZhc
         KPQraD+QxDcJBYDtkfqaGfiBCPmJrHSQ7xbfo0koI5sahBx3V/SUJW1vdaVIe8OhkDd9
         J59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pdJRdc/ChWME/KxDvyR3ZmETgfGtqY1xnlD8l9hYebU=;
        b=iLrUDWW6oUl1KNvMQFtOpSFP4Qj2B5C2Nc+7H3IFyli0g5/Hp17vXrFgGrUpcKMdpA
         K1itDjs2DlGAoAUOCFySTBz6LzVDaCN7TAvvLSI6h+kyWYwoLpWkPOrMtdvTW3p2yNiu
         /6hD9HMwvx77MlJ5IhiE0LYlxgAS4jmKTWyUPtESP1pHruC2pfKx+J43CAXromSCqLCc
         nHDDbU17mpykuoHNixsF1xlBfBdWO753UFEWkz4rbD2IQaSvOrUg5tewvjA++jPyr7fn
         LnG7XNbf+W2uF/LpZ632EWH176d7ITnWWE6DXRBE0K8Qf1SrXv1C5Tr9l42Osm5MR68i
         /ZQQ==
X-Gm-Message-State: AOAM5332ZaNAoGojMql4o668tdWV+iCqV95lzSdQk2nfnO1198ngvfuD
        bHzQVV/BQ6snypFW/U9O70Qz8g==
X-Google-Smtp-Source: ABdhPJwECrSLZmjwGo9irIirPePkFqH5rQ8m6RjYax9+026IapisC7bInKFA7hWtTAvX8i1QY7l8TA==
X-Received: by 2002:a17:906:52c7:b0:6ce:a880:50a3 with SMTP id w7-20020a17090652c700b006cea88050a3mr27925698ejn.437.1653474725390;
        Wed, 25 May 2022 03:32:05 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:2c21:b442:2fc3:f06f? ([2a02:578:8593:1200:2c21:b442:2fc3:f06f])
        by smtp.gmail.com with ESMTPSA id y7-20020a1709060a8700b006fec3b2e4f3sm4073996ejf.205.2022.05.25.03.32.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 03:32:05 -0700 (PDT)
Message-ID: <0648dc99-7465-871c-90a1-8a69f60d893c@tessares.net>
Date:   Wed, 25 May 2022 12:32:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] mptcp: Do TCP fallback on early DSS checksum failure
Content-Language: en-GB
To:     Greg KH <gregkh@linuxfoundation.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        MPTCP Upstream <mptcp@lists.linux.dev>
References: <20220524181041.19543-1-mathew.j.martineau@linux.intel.com>
 <Yo3gG9H8Sw/w7baR@kroah.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <Yo3gG9H8Sw/w7baR@kroah.com>
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

Hi Greg, Mat,

On 25/05/2022 09:51, Greg KH wrote:
> On Tue, May 24, 2022 at 11:10:41AM -0700, Mat Martineau wrote:
>> [ Upstream commit ae66fb2ba6c3dcaf8b9612b65aa949a1a4bed150 ]
>>
>> RFC 8684 section 3.7 describes several opportunities for a MPTCP
>> connection to "fall back" to regular TCP early in the connection
>> process, before it has been confirmed that MPTCP options can be
>> successfully propagated on all SYN, SYN/ACK, and data packets. If a peer
>> acknowledges the first received data packet with a regular TCP header
>> (no MPTCP options), fallback is allowed.
>>
>> If the recipient of that first data packet finds a MPTCP DSS checksum
>> error, this provides an opportunity to fail gracefully with a TCP
>> fallback rather than resetting the connection (as might happen if a
>> checksum failure were detected later).
>>
>> This commit modifies the checksum failure code to attempt fallback on
>> the initial subflow of a MPTCP connection, only if it's a failure in the
>> first data mapping. In cases where the peer initiates the connection,
>> requests checksums, is the first to send data, and the peer is sending
>> incorrect checksums (see
>> https://github.com/multipath-tcp/mptcp_net-next/issues/275), this allows
>> the connection to proceed as TCP rather than reset.
>>
>> Cc: <stable@vger.kernel.org> # 5.17.x
>> Cc: <stable@vger.kernel.org> # 5.15.x
>> Fixes: dd8bcd1768ff ("mptcp: validate the data checksum")
>> Acked-by: Paolo Abeni <pabeni@redhat.com>
>> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> [mathew.j.martineau: backport: Resolved bitfield conflict in protocol.h]
>> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
>> ---
>>
>> This patch is already in 5.17.10-rc1 and 5.15.42-rc1, but involves a
>> context dependency on upstream commit 4cf86ae84c71 which I have
>> requested to be dropped from the stable queues.
>>
>> I'm posting this backport without the protocol.h conflict to
>> (hopefully?) make it easier for the stable maintainers to drop
>> 4cf86ae84c71.
>>
>> For context see https://lore.kernel.org/stable/fa953ec-288f-7715-c6fb-47a222e85270@linux.intel.com/
> 
> THanks, will take this after this round of releases.

It might already be too late but is it possible to have this patch
("mptcp: Do TCP fallback on early DSS checksum failure") and "mptcp: fix
checksum byte order" in the same stable release?

Note that "mptcp: fix checksum byte order" patch has been recently
queued by Sasha at the same time as "mptcp: Do TCP fallback on early DSS
checksum failure".

A bit of context: "mptcp: fix checksum byte order" fixes an important
encoding issue but it also breaks the interoperability with previous
Linux versions not having this patch.

The patch from Mat ("mptcp: Do TCP fallback on early DSS checksum
failure") improves the situation when there is this interoperability
issue with a previous Linux versions not implementing the RFC properly.
The improvement is there to make the MPTCP connections falling back to
TCP instead of resetting them: at least there is a connection.

In other words, that would be really nice to have these two commits
backported together. If it is easier, it looks best to me to delay the
main fix ("mptcp: fix checksum byte order") than having the two patches
in different stable versions. But I understand it was not clear and
maybe too late to do these modifications.

Anyway, thank you for your work maintaining these stable versions! :)

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
