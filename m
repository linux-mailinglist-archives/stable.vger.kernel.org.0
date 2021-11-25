Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251AD45D61C
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 09:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352543AbhKYI2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 03:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240966AbhKYI0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 03:26:30 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF51DC06174A
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 00:23:18 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id i5so9837960wrb.2
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 00:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n6+8gB3EOqEKwhhKrLGqW+T8RKrwMDwlPKdzvWKFsyw=;
        b=h09L8eYHrDHX/TDjymXBSdPtkLOISN3ZO5YwaAI5a4l+WQ+8KmYWGXteSdQWuAWN7Q
         OrrvqXftM/Zh5cyxeci3ycTtiz+ofjmb91bCy5wmzh8g9LkzwmgSPOgU/S2FGf81zbno
         ODF4F5+L6JFvMlTQFSDwTcAO1qBWocvCAbX+eCTeAQVuhSNMMToF8TTiG2ngB6ZgB0Q6
         F441Fp3duVs+q8tjO3/Ow3uhY2t2TtrcF471+l30xR/Xptqd6TCDzwSBKvAOn1hWSbvq
         jbIG6x4HeI3PxRt/3sM5LVAdr/DQJcl9LRBvbTUmS7hzJGhwEAO5p4YXsACsxuE2aQqi
         Entg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=n6+8gB3EOqEKwhhKrLGqW+T8RKrwMDwlPKdzvWKFsyw=;
        b=iHoWB/MFlIWl3NoU0RId7pYsRQ2uf5AfUJHV2yT9puFENrLG31NjzqAydDhbQEEd8l
         2h4ng685030G5gFwH5ydeaUKy/j8C1JH+fKr59TOreuMi/y8EXkTU0kxha2Z5kw0+auo
         /SpUcXflQz1T1A3+NIwIfdFZDejmoQd+MfBp+Y3qcWvD7+BRaLVlMt2/bHkpSVfu7wrf
         pqUefPi9PAGBewBH4n2l+S/fFq+N+Q1OtmRmacojShGU7mWh/Yr/NIy8WjXRY4rinEnA
         np8yC5VflKhsURKW+LLK8/xhS2Oxv38c3MHJHrC8ScZeh616L8rMjh15CvAg67CH4k8/
         U82Q==
X-Gm-Message-State: AOAM531Di60eUbogNz2BZE6CjmRdk/bydlWtiffd1bsyaem/9NEDpJi3
        Go7jMVoPLh6uQHHTJp2d3WJMzU/12M7Bvg==
X-Google-Smtp-Source: ABdhPJwUbGdoVVm4AlCw/c17brEy3dpQsAH5DqoxMJwBLXHz7dT1VJYn8woelneSPw5HcnsFs9FIzw==
X-Received: by 2002:adf:fb0c:: with SMTP id c12mr4805484wrr.614.1637828596711;
        Thu, 25 Nov 2021 00:23:16 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:ad98:650:185f:cd0c? ([2a01:e0a:b41:c160:ad98:650:185f:cd0c])
        by smtp.gmail.com with ESMTPSA id f15sm2780344wmg.30.2021.11.25.00.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 00:23:16 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec] xfrm: fix dflt policy check when there is no policy
 configured
To:     antony.antony@secunet.com
Cc:     steffen.klassert@secunet.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, kuba@kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
References: <20211122103313.1331-1-nicolas.dichtel@6wind.com>
 <YZ8z8KPXZyiPLahh@moon.secunet.de>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <5a22e114-f12e-38df-daf2-8ea39dc1f60d@6wind.com>
Date:   Thu, 25 Nov 2021 09:23:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YZ8z8KPXZyiPLahh@moon.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 25/11/2021 à 07:57, Antony Antony a écrit :
> Hi Nicolas,
Hi Antony,

> 
> On Mon, Nov 22, 2021 at 11:33:13 +0100, Nicolas Dichtel wrote:
>> When there is no policy configured on the system, the default policy is
>> checked in xfrm_route_forward. However, it was done with the wrong
>> direction (XFRM_POLICY_FWD instead of XFRM_POLICY_OUT).
> 
> How can I reproduce this? 
> I tried adding fwd block and no policy and that blocked the forwarded traffic.
> I ran into another issue with fwd block and and tunnel. I will double check. Next week.
> 
With the out default policy set to 'block' and no out policy configured, the
packets are forwarded. After my patch, packets are blocked:

$ ip xfrm policy getdefault
Default policies:
 in:  accept
 fwd: accept
 out: block
$ ip xfrm policy
$


Regards,
Nicolas
