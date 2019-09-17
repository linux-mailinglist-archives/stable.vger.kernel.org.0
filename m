Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9448B5804
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 00:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbfIQWco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 18:32:44 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37396 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfIQWcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 18:32:43 -0400
Received: by mail-pl1-f194.google.com with SMTP id b10so2159127plr.4
        for <stable@vger.kernel.org>; Tue, 17 Sep 2019 15:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=dmHKlC95wEkb+HENLwm0wnzogMC58TL2IKPX+eVUAOk=;
        b=rdYlYU4iWu37JaHMYZYnsFvPb4IVU+ujYbjqRjhooffq05DM3nAh3j6bzbFqnl+Z+m
         u9ZAKZlglBUOYenB/3BrqhJ3tLmlHyZCLaO3E/Uya10zG0S2a7lm8L0FYkuj/hWdLa93
         4iShr/m6wuZq3U7YBdeXaA74t2uDX31eoste1s5rVd8Hm6zeO6vifII9CTxcFrqfmY/y
         frUpAk8OmB38+keSHKuVEZKnZRV3DHkXPFHewW+TK4X5qpWno7yju2r+e22NP8NAlFQc
         t0q/kHRZ2rZWLYq0mEi1eGiRbcw4+Iltb8k661e/Zg0AJwXBqcaJCA/7S9I5vvDxsGHl
         QT1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dmHKlC95wEkb+HENLwm0wnzogMC58TL2IKPX+eVUAOk=;
        b=OxvTljUQlvc5Q+khU8E38uLfazUf7cs+jeZVaeChX+kvcXK4ASsrLwMotcCqatXTKw
         Gjymd5vVshsMnUM6a7dWnCAIOWF6hWuXXHxU/Fg8/XwvJWugG7l8vUTmpczlW3ezPOSe
         K1cPQDbG8JlTUSgHzRK/Qn7+CFeRHVYA/p5ti/nFmyRUn3N/reW/+OMQ0hIDAJPISEXH
         FQQh3HvLnD8CoD1gUii4gBdtPuSC4ccSZiQ2C7jNFfEfktf6eZ6k/R/zpe00Djt6i9Mz
         Rq++30FqEOXSW1ZWuga+FVWN5P0ewCZw5Z4TGMK0in9iWdzpUqlsVQ08fpAZwbvhVpPj
         jYOg==
X-Gm-Message-State: APjAAAUNm2ZpKvsKvO3MuiaR2/rOKtv6eQROArUjruQDhw1OBmLW8Bgr
        iGfV2puZj9kQJ2epFrrJvAALPnV6Eh4=
X-Google-Smtp-Source: APXvYqz2kwMiV3IzxK9Tf5xKPsp4eqjTJDvh2n17maZJlAv70QrBj7iUZdXyac4Xthx4D2Em5ItjLA==
X-Received: by 2002:a17:902:9b86:: with SMTP id y6mr1010494plp.217.1568759563045;
        Tue, 17 Sep 2019 15:32:43 -0700 (PDT)
Received: from ?IPv6:240b:10:2720:5510:a182:288:3ffa:432a? ([240b:10:2720:5510:a182:288:3ffa:432a])
        by smtp.gmail.com with ESMTPSA id v5sm5003146pfv.76.2019.09.17.15.32.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 15:32:42 -0700 (PDT)
Subject: Re: [PATCH for 5.2.y] mtd: cfi_cmdset_0002: Use chip_good() to retry
 in do_write_oneword()
To:     Greg KH <greg@kroah.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vignesh Raghavendra <vigneshr@ti.com>
References: <20190917175048.12895-1-ikegami.t@gmail.com>
 <20190917181127.GD1570310@kroah.com>
From:   Tokunori Ikegami <ikegami.t@gmail.com>
Message-ID: <7c0113e0-d455-e3e6-86fc-45429be196fb@gmail.com>
Date:   Wed, 18 Sep 2019 07:32:39 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190917181127.GD1570310@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2019/09/18 3:11, Greg KH wrote:
> On Wed, Sep 18, 2019 at 02:50:48AM +0900, Tokunori Ikegami wrote:
>> As reported by the OpenWRT team, write requests sometimes fail on some
>> platforms.
>> Currently to check the state chip_ready() is used correctly as described by
>> the flash memory S29GL256P11TFI01 datasheet.
>> Also chip_good() is used to check if the write is succeeded and it was
>> implemented by the commit fb4a90bfcd6d8 ("[MTD] CFI-0002 - Improve error
>> checking").
>> But actually the write failure is caused on some platforms and also it can
>> be fixed by using chip_good() to check the state and retry instead.
>> Also it seems that it is caused after repeated about 1,000 times to retry
>> the write one word with the reset command.
>> By using chip_good() to check the state to be done it can be reduced the
>> retry with reset.
>> It is depended on the actual flash chip behavior so the root cause is
>> unknown.
>>
>> Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
>> Cc: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
>> Cc: linux-mtd@lists.infradead.org
>> Cc: stable@vger.kernel.org
>> Reported-by: Fabio Bettoni <fbettoni@gmail.com>
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
>> [vigneshr@ti.com: Fix a checkpatch warning]
>> Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
>> ---
>>   drivers/mtd/chips/cfi_cmdset_0002.c | 18 ++++++++++++------
>>   1 file changed, 12 insertions(+), 6 deletions(-)
>>   mode change 100644 => 100755 drivers/mtd/chips/cfi_cmdset_0002.c
> You changed the file to be executable???  That's not ok :(

Very sorry for this.
I missed it to fix to not be executable since it was changed to be 
executable on my local environment.
Anyway I will do fix it.

>
> Also, what is the git commit id of this patch in Linus's tree?  I can't
> seem to find it there.

Actually it has not been pulled in Linus's tree.
But it has been merged into 
git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/next for 
v5.4-rc1 as the git commit id 37c673ade35c.
So I thought as that it is okay to send the patches for the stable trees.
But should I wait to be pulled the patch in Linus's tree at first?

>
> thanks,
>
> greg k-h
