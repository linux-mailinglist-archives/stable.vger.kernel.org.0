Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4B01913B3
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 15:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgCXOxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 10:53:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32980 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgCXOxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 10:53:54 -0400
Received: by mail-pg1-f194.google.com with SMTP id d17so8564635pgo.0
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 07:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=QVduhjXWCW00OJd/ZTpW4kWOwCgt6BaHgBSZwaL9YvA=;
        b=ac0mxzqnJvdjFusvzY2BcTccxLg8YyQ7c51h0qnsozG+IkL7o2DXPkmarhaV7Yup8b
         HKL2RWBDzs9HmfCFgoxwZOz7D3MUcIEv1NZi5G0JvQxw/3Gz5IS0l4fdaH4UEmWHPGHb
         og1Xaejyn/+UVhB4irSmT0vqPb8awJjwUUyCK+btX8LNEqmIcSG1bN7qvSlkZT0apWEF
         5DwTJQNYW3y2vh1iuscQVR2PoO8U/+eM360Bft4YNgKBJgt+gxtrDgFjra/2+PqMQDpg
         qcrRYNAwLVYYfFZLJtVca2CS20FiXvrjic9yLq7i04iiBwlDDVSXSsy1hrbCnJ7mFHPN
         1IAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=QVduhjXWCW00OJd/ZTpW4kWOwCgt6BaHgBSZwaL9YvA=;
        b=hScVND8+jWvwoxC4vs0Tf+wc5yXkEWsJTO2IvVC4eQDsb1dL5YwaHuHphidLJSddEM
         QuBObP53PRty5X+dwS6Ecgp6WasDRY1cKwePQnPXnSGjFNQOf3xRwyY0EVztTqY1pVaT
         GGK9JAl8vhDDOBxsuxqfgXjSBZqhgrds0i751r8mlZ4geDdCSEMG9lve6v4YrBYIVKzn
         QfstB5nfdH8EDAhJz49cnozlP+phMb76K0bnOmqqDJHfmHv8r4JVulorUwK1weUpPWmW
         GwVKU5047MWa23F2Ner4lSIcsTu2Jj7pvkWdOTo/jnj3LasDW8maXUdDKODopZQLsfhn
         DIJA==
X-Gm-Message-State: ANhLgQ2ujjzJEFTsJDn0v698F1R3YO0QggM1OyWAzzYd1QYEaU+YxFCT
        IqJuW3jOMlGyA0ggUUvSpq9jKDxeaA4nMA==
X-Google-Smtp-Source: ADFU+vtpua5I87p/4y8NFbZWT4Wgn5mB76vtJd0xqd+xckxhQ93AleIpG7Npipof2OjCFaYwvpCsIA==
X-Received: by 2002:a05:6a00:2cb:: with SMTP id b11mr415184pft.42.1585061633502;
        Tue, 24 Mar 2020 07:53:53 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:200:5404:91ba:59dc:9400])
        by smtp.googlemail.com with ESMTPSA id b25sm16218138pfd.185.2020.03.24.07.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 07:53:52 -0700 (PDT)
Subject: Re: locks use-after-free stable request
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <52be02d3-3a6a-c8b8-4177-5cc1d67aedd4@android.com>
 <20200324144338.GA2507446@kroah.com>
From:   Mark Salyzyn <salyzyn@android.com>
Message-ID: <29c96b7a-5964-5d89-304a-92673b68e8ef@android.com>
Date:   Tue, 24 Mar 2020 07:53:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324144338.GA2507446@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/24/20 7:43 AM, Greg KH wrote:
> On Tue, Mar 24, 2020 at 07:24:49AM -0700, Mark Salyzyn wrote:
>> Referencing upstream fixes commit dcf23ac3e846ca0cf626c155a0e3fcbbcf4fae8a
>> ("locks: reinstate locks_delete_block optimization") and commit
>> 6d390e4b5d48ec03bb87e63cf0a2bff5f4e116da ("locks: fix a potential
>> use-after-free problem when wakeup a waiter") and possibly address
>> CVE-2019-19769.
>>
>> Please apply to all relevant stable trees including 5.4, 4.19 and below.
>> Confirmed they apply cleanly to 5.4 and 4.19.
>>
>>
>> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
>>
>> Cc: stable@vger.kernel.org
>>
>> Cc: linux-kernel@vger.kernel.org
>>
>> Cc: kernel-team@android.com
>>
> These are all queued up for the next round of 5.4 and 5.5 stable
> releases,but they do not seem to apply to 4.19.
>
> And why do you think they apply to 4.19, that's not what 6d390e4b5d48
> ("locks: fix a potential use-after-free problem when wakeup a waiter")
> says.

When I used my tool to apply the pair by sha, I failed to notice that 
they were _both_ skipped because they are _both_ already present and 
read that as clean without looking at _what_ got applied or not.

(I will be fixing my tool)

> confused,

<sorry>

>
> greg k-h


