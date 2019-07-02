Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E650D5C778
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 04:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfGBCvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 22:51:15 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41186 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfGBCvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 22:51:14 -0400
Received: by mail-io1-f67.google.com with SMTP id w25so33569039ioc.8;
        Mon, 01 Jul 2019 19:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=057Pa4boLoPPDteo8R0KTEwSZg3CyppxjLulMTMnDsw=;
        b=p/j9hre/GI3XCiRSCpdiyabMg8GFc6R9jAHFE9ssWcyiBjZHFVssnSPik9p4qndE7F
         5DA1nQNjVke5uTJBAKJ7a7i5Ky7Qz1vXZBrlLWr7Vhc2a71i554xVR/eLuRnNwSYvGmt
         qIgoIMjhGTVgz13FqbzT1G4jzb1h4StY14Ux2P6h5z8n2pzTNeFfIcUSKQiYwsi3CWSm
         fpHW5PklxCH7Tk8pJMcZF29e1t/7IC0Oy6tudMNKkUGiLy5HdU0Us54RSZHvZkLuBrNC
         jZPiG6HOwiBf2jEerOYfN4oQ5HAzqdjnsYu1mWSzxC9Ah553ECTCl4rEaLZKEiTSRLoj
         fk6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=057Pa4boLoPPDteo8R0KTEwSZg3CyppxjLulMTMnDsw=;
        b=b6Z3PYGuAjblTP0pQuIPI2++rrLHcwHviAYyTwO4qVFDNE8SMSmxCm9UCj9KCNkplr
         SmPRmoigbT8GQ1Aql5pKXLNGNRxvERF5Wjpk31bqoZz3YuLF2nfvk9IMtbPdnKGpt3Jg
         WATppSalMjZbHHqTkW0CtFQICzn05SAL00l5LGfojI0f9jVtkVxKs0ADYmpCzlz1+kro
         E9pJD3TYZTjLdLAM4baK0UlHigqnZWWQQIBlNZBTrir4ggybdDLftmYet8e6yUc75aas
         6behQqmK9KZwSTJNlr4q0f7bvHub9EM+SCsFEJVXXNa8yxHREYQSbQFTB4+QgVFc5F/4
         UkYQ==
X-Gm-Message-State: APjAAAVVMbbIiLMsaubxQPkaS9kBuJAN0IJWLUhsh4bZFDwMEEfJTKOD
        1/rrrwOH7fPSgxI4VSzeRMU=
X-Google-Smtp-Source: APXvYqwasQ2Qsk8eJeFsrpZ19yqKDk9kJpsNQX6oTygilT30vuDGJHldZ/AF/aqWKX/aL8zq3XGldA==
X-Received: by 2002:a02:3904:: with SMTP id l4mr1311099jaa.81.1562035873543;
        Mon, 01 Jul 2019 19:51:13 -0700 (PDT)
Received: from [10.230.24.186] ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id c81sm24959528iof.28.2019.07.01.19.51.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 19:51:12 -0700 (PDT)
Subject: Re: [PATCH 3.16 08/10] tcp: tcp_fragment() should apply sane memory
 limits
To:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jonathan Looney <jtl@netflix.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Neal Cardwell <ncardwell@google.com>,
        Bruce Curtis <brucec@netflix.com>
References: <lsq.1560868082.489417250@decadent.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <37926faa-0f7f-621c-8ee6-ba46d34c8cfc@gmail.com>
Date:   Mon, 1 Jul 2019 19:51:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <lsq.1560868082.489417250@decadent.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ben,

On 6/18/2019 7:28 AM, Ben Hutchings wrote:
> 3.16.69-rc1 review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Eric Dumazet <edumazet@google.com>
> 
> commit f070ef2ac66716357066b683fb0baf55f8191a2e upstream.
> 
> Jonathan Looney reported that a malicious peer can force a sender
> to fragment its retransmit queue into tiny skbs, inflating memory
> usage and/or overflow 32bit counters.
> 
> TCP allows an application to queue up to sk_sndbuf bytes,
> so we need to give some allowance for non malicious splitting
> of retransmit queue.
> 
> A new SNMP counter is added to monitor how many times TCP
> did not allow to split an skb if the allowance was exceeded.
> 
> Note that this counter might increase in the case applications
> use SO_SNDBUF socket option to lower sk_sndbuf.
> 
> CVE-2019-11478 : tcp_fragment, prevent fragmenting a packet when the
> 	socket is already using more than half the allowed space
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Jonathan Looney <jtl@netflix.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
> Cc: Bruce Curtis <brucec@netflix.com>
> Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [Salvatore Bonaccorso: Adjust context for backport to 4.9.168]
> [bwh: Backported to 3.16: adjust context]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Don't we also need this patch to be backported:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=b6653b3629e5b88202be3c9abc44713973f5c4b4

Thanks!
-- 
Florian
