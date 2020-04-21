Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3771B3127
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 22:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgDUUZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 16:25:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38924 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726160AbgDUUZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 16:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587500754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BNhmHt4RMHenaofqoWMv475WdAp14sVTXvWnABShIgI=;
        b=Hcw/jxPdfhAEO0yiIME6llK+D69Kl+zjUcUoX7fsDkIg7Ex/dtmO2X+9UuOHMXAZUxOaVj
        dq+VLROBivqbBAXtJhk+okMwYl2b6YJ/3EX27zGJ3OgPoQJwVePIRxKUQ3xY3eAz0MJaG7
        zWagdjC/ucWmX75fmNDfKheNLiwnUCw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-tagRjZXNOoSqqMud0bBb4g-1; Tue, 21 Apr 2020 16:25:45 -0400
X-MC-Unique: tagRjZXNOoSqqMud0bBb4g-1
Received: by mail-wm1-f71.google.com with SMTP id f128so1968539wmf.8
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 13:25:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BNhmHt4RMHenaofqoWMv475WdAp14sVTXvWnABShIgI=;
        b=Qf+V+h/a95r3Lrvl+P7mQOEyyzshMdFbz5hUG5veDVmtXotM5jTVEQn2Yph2yM8Q0h
         9K8JAD4Eg2Ac2ylpkkNoUUV3QtsHJGYJ1dHX4Grt3dHNLpddfoeXcVOyjtZCiyxdO9Ud
         gXKPoOkJsiTfkZlpO+4+8nYeHcdElhL07lyjZT86MMVyLfgjNwYMRFanGzJ3PbqinNcC
         qOtMmKhArNh7ZL405zlkvEB64kQoLkptS1DEzk6Zj06IihtmwNeVK9nFCKwAotpKhBDg
         R/YM3taW9lZXgeagVgFAVuA5k4YgTxexHM6neB8Q6AqXkiTxuZW/klNKhsJCnqvDsPwA
         /yAA==
X-Gm-Message-State: AGi0Pubr6uey4uoDhNK7Jldn/776Z+34NkLc3zT/bn31EON9c8NLuYRD
        zoKoXuWs7WMpi1tIZTxeju32o/LGbOk1DpfodGm+5tBn9abiJvbJP+bDjtMCcxMUY7aMN6zODzs
        XKaCsrl25W70eXXRx
X-Received: by 2002:a1c:7d90:: with SMTP id y138mr7105637wmc.121.1587500744439;
        Tue, 21 Apr 2020 13:25:44 -0700 (PDT)
X-Google-Smtp-Source: APiQypKEl1/LaKqe5TKbNDkzBHlY5TT0KgVkGRX8P7aeJwKLOlLKLxxk/V4PeDMiOLVOh9I8f0byQQ==
X-Received: by 2002:a1c:7d90:: with SMTP id y138mr7105610wmc.121.1587500744175;
        Tue, 21 Apr 2020 13:25:44 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id 17sm4730210wmo.2.2020.04.21.13.25.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 13:25:43 -0700 (PDT)
Subject: Re: [PATCH v2] tpm/tpm_tis: Free IRQ if probing fails
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200416160751.180791-1-jarkko.sakkinen@linux.intel.com>
 <fa25cd78-2535-d26d-dd66-d64111af857a@redhat.com>
 <20200421195403.GA46589@linux.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <2692261d-5395-b03c-2a6f-1694212cd2d4@redhat.com>
Date:   Tue, 21 Apr 2020 22:25:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200421195403.GA46589@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4/21/20 9:54 PM, Jarkko Sakkinen wrote:
> On Tue, Apr 21, 2020 at 03:23:19PM +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 4/16/20 6:07 PM, Jarkko Sakkinen wrote:
>>> Call disable_interrupts() if we have to revert to polling in order not to
>>> unnecessarily reserve the IRQ for the life-cycle of the driver.
>>>
>>> Cc: stable@vger.kernel.org # 4.5.x
>>> Reported-by: Hans de Goede <hdegoede@redhat.com>
>>> Fixes: e3837e74a06d ("tpm_tis: Refactor the interrupt setup")
>>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>
>> I can confirm that this fixes the "irq 31 nobody cared" oops for me:
>>
>> Tested-by: Hans de Goede <hdegoede@redhat.com>
> 
> Hi, thanks a lot! Unfortunately I already put this out given the
> criticality of the issue:
> 
> https://lkml.org/lkml/2020/4/20/1544
> 
> Sincere apologies that I couldn't include your tested-by

No problem.

> but the most
> important thing is to know that it works now.

Agreed.

Regards,

Hans

