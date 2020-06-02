Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039A21EBF13
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 17:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgFBPeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 11:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgFBPeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 11:34:23 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BB6C08C5C0;
        Tue,  2 Jun 2020 08:34:22 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y18so1490078plr.4;
        Tue, 02 Jun 2020 08:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MU0MW0wjNs//zXQKIkp9U2Odwc0Dta290PoaIbMQMd4=;
        b=XyxRObsgdYuhcaVLT7lAyUBOe15I/7IvPXSLP+eNysdLV+gksXxMClqCXODKHr6Cqp
         +PMB0OHR3pObnA5STWXoVB3OXfhSl59ZVcUXQ6Xvu70XtiW+x9IGN66+oRoYP7mTdbZI
         n64MB5GAmhslVfgHXlN4OJE435xozybPgd4du5JXrdjdS0cJZYlHDdrEd/mX7o12xo9/
         vt0pxCXIY47be6cgXLoKZaqMN1COK0QZ3hQ7as/imeDypmc1CJ4MiADhl2g6LVIXclS8
         SVo1/y9Qbs8H/obNDcm//PCqLEu1uJBz/GAFigaGnV8q4Y+ovyXPO92jM90wUyXOfdHg
         f6zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MU0MW0wjNs//zXQKIkp9U2Odwc0Dta290PoaIbMQMd4=;
        b=mJpzx1RPBkX9gmBaaDGhoEI4xQCqMEXUeHfWZXh/sFoim+Tjjw9Vy9eeAhILRY+bSK
         nzyR76naaZf+h2fnrHNWeSfPsq+errVfuk77sO+BgoH36a4VJweT/mDYRQmR+sCkFUYQ
         Aovh1Xv/8uivnVNNUBLyfep3psCto3cXTWyr33ZEUbxlWVEwgxJDPLUVBuT6n3XfW5Il
         WQK7pd8gsLYeVWMH5kJFabScFQDt0vXhRyDQAQJ/tQINwuw5jZFpOvRrIontULnm0V3o
         7j4QsRh+428w0zefpDeUz5u24bh+40FWDl4MZUAiA8zfeS9WhADYM218drieFUCItNRI
         zaPg==
X-Gm-Message-State: AOAM532w9bFi7CR4sa+UQAkiiDqlpKeRBnetg6r02tjhcGe105x5ZUhi
        wsYS7mtIwWraoOnKzbWzo+w=
X-Google-Smtp-Source: ABdhPJzJoeSmatK65R/6VBJSUdG0R+dAnJjPWqT3iIbTmD4TKabyqzbccL5mf9lgGaXTEEMt88sVKQ==
X-Received: by 2002:a17:90a:df16:: with SMTP id gp22mr6195976pjb.6.1591112061727;
        Tue, 02 Jun 2020 08:34:21 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id o20sm2654113pjw.19.2020.06.02.08.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 08:34:21 -0700 (PDT)
Subject: Re: [PATCH 2/4] serial: core: fix broken sysrq port unlock
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
References: <20200602140058.3656-1-johan@kernel.org>
 <20200602140058.3656-3-johan@kernel.org>
 <CAHp75VeXYn46wQ5EXkk_MOQ49ybtyTeoQS6BS1X9DkC6hbeF-w@mail.gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Message-ID: <b016ad68-124a-5c98-f49b-f7286d995223@gmail.com>
Date:   Tue, 2 Jun 2020 16:34:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAHp75VeXYn46wQ5EXkk_MOQ49ybtyTeoQS6BS1X9DkC6hbeF-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/2/20 3:48 PM, Andy Shevchenko wrote:
> On Tue, Jun 2, 2020 at 5:03 PM Johan Hovold <johan@kernel.org> wrote:
>>
>> Commit d6e1935819db ("serial: core: Allow processing sysrq at port
>> unlock time") worked around a circular locking dependency by adding
>> helpers used to defer sysrq processing to when the port lock was
>> released.
>>
>> A later commit unfortunately converted these inline helpers to exported
>> functions despite the fact that the unlock helper was restoring irq
>> flags, something which needs to be done in the same function that saved
>> them (e.g. on SPARC).
> 
> I'm not familiar with sparc, can you elaborate a bit what is ABI /
> architecture lock implementation background?

I remember that was a limitation a while ago to save/restore flags from
the same function. Though, I vaguely remember the reason.
I don't see this limitation in Documentation/*

Google suggests that it's related to storage location:
https://stackoverflow.com/a/34279032

Which is definitely non-issue with tty drivers: they call
spin_lock_irqsave() with local flags and pass them to
uart_unlock_and_check_sysrq().

Looking into arch/sparc I also can't catch if it's still a limitation.

Also, looking around, xa_unlock_irqrestore() is called not from the same
function. Maybe this issue is in history?

Johan, is it a theoretical problem or something you observe?
Also, some comments would be nice near functions in the header.

Thanks,
          Dmitry
