Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B07275FAD2
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 17:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfGDP1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 11:27:20 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35459 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbfGDP1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 11:27:20 -0400
Received: by mail-wm1-f67.google.com with SMTP id c6so6577564wml.0;
        Thu, 04 Jul 2019 08:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sJaoAJm+vr+hfSZiUJmGgzcbIrgfovbrJWCxV23LtM4=;
        b=NgnTWA1WXAcTz9gdGhK99h4bL/9yxcQVlZNQd68BtineVAPG2iI/J06YkfFVdTDC0Y
         8mDkh2BPuGEVsTlww7JN5vQC6e/bCQw3BAAXqQjEgvKnVuzexneQf7V9Y7U/Rf7OPa1H
         proiI3qw7kiYervEZWdz/+/rgNg+ZQjvthe8dUKeAjIkGF/bDSVYd3TEbbNBb2wgNROQ
         58Z9bgoF37eXTwfNaZ4jJdvLEDTIAdVZ/qZE5z5Ld5l035DxJvL5N9NcOZO9LyPRJ+AD
         fi0M5xhY8sdgHzviaHau8lB1IdmRN9UYv5bJ4j6w30w5SL/HvBx2FgkjodEfEpMJfgI4
         5rAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sJaoAJm+vr+hfSZiUJmGgzcbIrgfovbrJWCxV23LtM4=;
        b=VB8MfWg7XF6yvaO/qsX++4ie1ICQcajTnpyZjyzXd03YRQoklKZG1ZL3qFt9RBADf+
         kjqQpb5z3FidHI3X6ngDP94piM2dfpL1Jfk6ZrVpqkIgvscyd7LrNOFobFjGupsCCwHF
         qQe7uTblXg4183Acp6By2Jlo6yT7obe9V8xZ3O96mnzFEcnbyxM3pX9QUWFytR4Y49hM
         OmEIKrz6jKU3GOuOxyBJowr4g9+0BDhk/ese2N9hU2/rhAnnqhklMWXXnaBdyDh7Ubed
         Rgt+Z044qVXaCItTLzeVlUblFCLZoelrUPCnEKqTkT52qdic7lcAGELtuUI8tDBrhpMI
         DhVg==
X-Gm-Message-State: APjAAAVbq9P2pP4OhsQ1JgdqJtimvUat3Bwqa7H7avlNFc27UNQ48qgx
        oarS2ZTgrRhTJkpsWjSC9BNwKw94
X-Google-Smtp-Source: APXvYqysqF+b3wxfuoECdI3oA1dHTqn4SnBT+bb+Z9O3tDFZvG5N7ZnZT+OCBn1OJGdU69siqSCbtQ==
X-Received: by 2002:a05:600c:2056:: with SMTP id p22mr69988wmg.155.1562254037051;
        Thu, 04 Jul 2019 08:27:17 -0700 (PDT)
Received: from [192.168.1.4] (ip-86-49-110-70.net.upcbroadband.cz. [86.49.110.70])
        by smtp.gmail.com with ESMTPSA id q10sm6108288wrf.32.2019.07.04.08.27.15
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 08:27:16 -0700 (PDT)
Subject: Re: [PATCH] iio: adc: gyroadc: fix uninitialized return code
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Wolfram Sang <wsa@the-dreams.de>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jonathan Cameron <jic23@kernel.org>,
        stable <stable@vger.kernel.org>,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Rob Herring <robh@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20190704113800.3299636-1-arnd@arndb.de>
 <20190704120756.GA1582@kunai>
 <CAMuHMdXDN60WWFerok1h05COdNNPZTMDCgKXejmQZMj9B6y5Cw@mail.gmail.com>
From:   Marek Vasut <marek.vasut@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <fc3b8b4e-fe0e-9573-124d-4b41efa409e4@gmail.com>
Date:   Thu, 4 Jul 2019 17:27:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXDN60WWFerok1h05COdNNPZTMDCgKXejmQZMj9B6y5Cw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/4/19 2:10 PM, Geert Uytterhoeven wrote:
> Hi Wolfram,
> 
> On Thu, Jul 4, 2019 at 2:08 PM Wolfram Sang <wsa@the-dreams.de> wrote:
>> On Thu, Jul 04, 2019 at 01:37:47PM +0200, Arnd Bergmann wrote:
>>> gcc-9 complains about a blatant uninitialized variable use that
>>> all earlier compiler versions missed:
>>>
>>> drivers/iio/adc/rcar-gyroadc.c:510:5: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]
>>>
>>> Return -EINVAL instead here.
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 059c53b32329 ("iio: adc: Add Renesas GyroADC driver")
>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
>> This is correct but missing that the above 'return ret' is broken, too.
>> ret is initialized but 0 in that case.
> 
> Nice catch! Oh well, given enough eyeballs, ...

I don't think ret is initialized, reg is, not ret .

>> And maybe we can use something else than -EINVAL for this case? I am on
>> the go right now, I will look for a suggestion later.
> 
> -EINVAL is correct here (and in the above case, too), IMHO.

Yep, -EINVAL is fine.

-- 
Best regards,
Marek Vasut
