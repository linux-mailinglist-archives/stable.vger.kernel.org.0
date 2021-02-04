Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF2930F173
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 12:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhBDLBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 06:01:18 -0500
Received: from mail-ej1-f46.google.com ([209.85.218.46]:37745 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235378AbhBDLBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 06:01:14 -0500
Received: by mail-ej1-f46.google.com with SMTP id jj19so4609866ejc.4;
        Thu, 04 Feb 2021 03:00:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lYj7+T0uhcqQ91m5FLh+plxjvp8VVf54myAhRXHsJLg=;
        b=L1hhBRUkSVIkRnRcEHunMcIbB2gtTxEgpEaKlgMvSKKd7yzPIhuwqCQ8+2++Z6W3kI
         4nQ6HG/pUcR9npUoYnBKt04DURAD4vRoDmYjj2vJeJ+e+qFysg+1Bl/clL79LB9Z9Z1y
         TtUTX6suaD2mlwyKH/kt74UNvYhA44aHTcwbqW48HzlOZC64HLBicKY2WNaTxi4OBpGG
         w1KLWyDWfEXJOeZzwdWClLaC0AsdkfkGADzWEp8svDviuxHr1lyvLOxkUWLqrtzn24rP
         Xi8ALtuh/vJuzbjwZ86x/738rDgBXAB52+SkG1Q/W++RJgmuD5+FKqlI6Sxe/4196o/c
         KZxw==
X-Gm-Message-State: AOAM533Btxvh/coUnXJsQkdiD6YIXgAPLtuRwwbPgW8dGOlnRThQ87e1
        TdhEjwtAlGXSuiOi1GdjwhQ=
X-Google-Smtp-Source: ABdhPJwpkr/jHrKe8Ewv6L4nc2KPVwUXnxty6cATQegN+8BqxOyk20T+97wsJlpOdvLQppnrho4/kQ==
X-Received: by 2002:a17:906:3e14:: with SMTP id k20mr7313111eji.42.1612436433117;
        Thu, 04 Feb 2021 03:00:33 -0800 (PST)
Received: from ?IPv6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id k9sm2273323edo.30.2021.02.04.03.00.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 03:00:32 -0800 (PST)
Subject: Re: Kernel version numbers after 4.9.255 and 4.4.255
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jari Ruusu <jariruusu@protonmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        masahiroy@kernel.org
References: <7pR0YCctzN9phpuEChlL7_SS6auHOM80bZBcGBTZPuMkc6XjKw7HUXf9vZUPi-IaV2gTtsRVXgywQbja8xpzjGRDGWJsVYSGQN5sNuX1yaQ=@protonmail.com>
 <YBuSJqIG+AeqDuMl@kroah.com>
 <78ada91b-21ee-563f-9f75-3cbaeffafad4@kernel.org>
 <YBu1d0+nfbWGfMtj@kroah.com>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <a85b7749-38b2-8ce9-c15a-8acb9a54c5b5@kernel.org>
Date:   Thu, 4 Feb 2021 12:00:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBu1d0+nfbWGfMtj@kroah.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04. 02. 21, 9:51, Greg Kroah-Hartman wrote:
>> It might work somewhere, but there are a lot of (X * 65536 + Y * 256 + Z)
>> assumptions all around the world. So this doesn't look like a good idea.
> 
> Ok, so what happens if we "wrap"?  What will break with that?  At first
> glance, I can't see anything as we keep the padding the same, and our
> build scripts seem to pick the number up from the Makefile and treat it
> like a string.
> 
> It's only the crazy out-of-tree kernel stuff that wants to do minor
> version checks that might go boom.  And frankly, I'm not all that
> concerned if they have problems :)

Agreed. But currently, sublevel won't "wrap", it will "overflow" to 
patchlevel. And that might be a problem. So we might need to update the 
header generation using e.g. "sublevel & 0xff" (wrap around) or 
"sublevel > 255 : 255 : sublevel" (be monotonic and get stuck at 255).

In both LINUX_VERSION_CODE generation and KERNEL_VERSION proper.

thanks,
-- 
js
