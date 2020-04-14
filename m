Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72EB1A7DA7
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 15:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731838AbgDNNYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 09:24:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51759 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2502872AbgDNNQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 09:16:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586870159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fkgBK9xnpU8Tu3dZHUSNLZnfPluOMQrIKm9bQ1t2jqg=;
        b=UiPMvykgRdLbhE2Wb8guqneNNa0Ufmb6GuFWIJC0BRjW6cZdJzpJbWMa/OKJbSvyVBd3q/
        hh1Tss2q/NmPcswIGkOqVYyrLRWwKdLMNTm5TzhV9zktZv2OwtLuMrCwqPEbspoUwIOza4
        vzvhQjL0PcalIVDqaiNJ/UfAcXcF2ZE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-TOymzebSP1mEf3OUagdCMw-1; Tue, 14 Apr 2020 09:15:57 -0400
X-MC-Unique: TOymzebSP1mEf3OUagdCMw-1
Received: by mail-wr1-f71.google.com with SMTP id p16so5869474wro.16
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 06:15:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fkgBK9xnpU8Tu3dZHUSNLZnfPluOMQrIKm9bQ1t2jqg=;
        b=d/ms9jST0S6XU11mH53o7/3PdN14Gb7GSxNlBqD8sLWPEYvN3CrKZHGg6Sym6HKCAe
         Hljf1+VpW8+nPmbe35KzjM72dp/3mm6KwCdlWZiUcfyI8BC629dZGgihxsJbXtStWEZ+
         AZHfEPe1HZfyVAsJVXp8ECnMu1lVz6C+zURim3kafzd7DrYR9CQlIEM/LGS71HOcF6rW
         THvmBCMo2Kt6rHmFrSnZrJ8t+BCp66LlRSTGTgsFVqt8+3fpDHBmqvXZQTJ8W4YDrSWp
         fx77ZEI/ZWbC3kT15uasGUIjhq/BUn/0lIJz0sWwVQJeVD9fwidtRiANbXkoC9Lj1RDx
         mNxQ==
X-Gm-Message-State: AGi0Pubo6r7Zigs3GrGlgXm9SdWe4KlQVYU0GAK0Y7gIC6eaKO76BBCT
        ZXtwloHiXp5xtBqhxPA2bICxW0sUWZ0mLGwjzxFChHrWgXq4qKlk3eOyK+G+TgKINDJOhhsw8+U
        n6iqEKl8MANqNQQIK
X-Received: by 2002:a5d:6145:: with SMTP id y5mr3671370wrt.126.1586870155640;
        Tue, 14 Apr 2020 06:15:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypIYnGXCmimjktgJ31Rsn05nuM82C4sRRSEJSiXVM+BE/3APQErQB0fwpedAZZG7kleviTPIyA==
X-Received: by 2002:a5d:6145:: with SMTP id y5mr3671335wrt.126.1586870155233;
        Tue, 14 Apr 2020 06:15:55 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id y15sm19420635wro.68.2020.04.14.06.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 06:15:54 -0700 (PDT)
Subject: Re: [PATCH] platform/x86: intel_int0002_vgpio: Only bind to the
 INT0002 dev when using s2idle
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        "5 . 3+" <stable@vger.kernel.org>
References: <20200407213058.62870-1-hdegoede@redhat.com>
 <cfd3171a-94fb-7382-28e1-a236cb6759cc@redhat.com>
 <CAHp75VdqQnHbMSSeoDESMgywH-1VxBTT=Uo_GLV1aycmg=MXtA@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <32d57d33-5278-aead-1545-fac1ab936fbd@redhat.com>
Date:   Tue, 14 Apr 2020 15:15:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAHp75VdqQnHbMSSeoDESMgywH-1VxBTT=Uo_GLV1aycmg=MXtA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4/8/20 12:26 AM, Andy Shevchenko wrote:
> On Wed, Apr 8, 2020 at 1:24 AM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Hi all,
>>
>> I just realized that I should have added a cover letter to this
>> patch to discuss how to merge it.
>>
>> Rafael has already queued up the
>> "[PATCH v3 2/2] platform/x86: intel_int0002_vgpio: Use acpi_register_wakeup_handler()"
>> in his tree. Looking at both patches the parts of the file the
>> touch are different enough that that should not be a problem though.
>>
>> So I guess this can go through platform/x86 as usual, or
>> (assuming everyone is ok with the change itself) alternatively
>> Rafael can take it to make sure there will be no conflicts?
> 
> You will need different patches for v5.7 and the rest.
> In v5.7 new CPU macros are in use.

I see, I will send out a v2 rebased on top of 5.7-rc1.

Regards,

Hans

