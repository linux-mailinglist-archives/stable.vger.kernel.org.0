Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47559B6540
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 15:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbfIRN7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 09:59:06 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34270 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfIRN7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 09:59:06 -0400
Received: by mail-pg1-f193.google.com with SMTP id n9so4183405pgc.1
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 06:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=S/KRTjZ02zi6c1DDfK/DqHGqV/93TPR7DjwT2TJEwJI=;
        b=fA20MKYYunP199zqtkonqkulcTdaHjqjGaf8aGDaHCI0MLa9D2dlXQz/CtrLHFq8qA
         pBsmdkEhkwUJv1KexBDOi1mHm43EEPT246gDC5+Dh94bJGOaqdoON47DGFp0okz90I6q
         ysIVe6vpOFuHJ256FribFKo+31MarFxqHPPd7oK4/8AU3/xRDHcHGFT8PCxcAcBWL3g2
         Tc+IfRLkuXyEk5xsFIQ3wCX0es/L8tKaGX1fR9MkuMj9lrMHOhMx9/O4icIVrU9Dtk1L
         zwmQOl1VmzglIx0ruHf0oWZ5buNILCRfIrLM1YtKK1FH76apwjaUjV373tQ91AaX4RDc
         DfeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=S/KRTjZ02zi6c1DDfK/DqHGqV/93TPR7DjwT2TJEwJI=;
        b=JCEEtHNYIYkneMeU5vROAOtHceOSWcicpfr3CK/JavGLVE3vMvt+dyimcTW8pA9ClN
         3semhbJvP2wkDdzD3+X9AvENDjiO/5ZFRH61JOPJz12J/8vocBko3stNBizwddLAK05v
         aGVPbQ9Fg/B+wqCCxvtORaH04FOcGz3TJNBeGahDZWa0imhaEvt2YuwrcslvNmyfN19/
         ik1FtiHT9E8l8+QFIe9ziedPDl22Y6G8YbC2/Qy2GPlenO2QnXl99bDba5jvSjOsB2Jj
         kpJejMj+fjRWpUUPc+HvOm1OvZN72dt1JykAGXfa6LTYiBIHpmhUAinuari9cUUXca18
         iofg==
X-Gm-Message-State: APjAAAV4ZviVHP8uLVRolTPwdHus4YvM1XpL+rzYtd9MXFfzsdw60yJm
        SaKGF/IoJSDoD/JG7MDJHnQ=
X-Google-Smtp-Source: APXvYqzIGgUvmqwt8HDdZsFSz9fyHCtMba88K+2dAaA5DyLiqRtCiRc1sSlmXLmyXnhVkZpBOai39Q==
X-Received: by 2002:a63:34cb:: with SMTP id b194mr4049917pga.446.1568815144998;
        Wed, 18 Sep 2019 06:59:04 -0700 (PDT)
Received: from ?IPv6:240b:10:2720:5510:a182:288:3ffa:432a? ([240b:10:2720:5510:a182:288:3ffa:432a])
        by smtp.gmail.com with ESMTPSA id n1sm4679043pfa.12.2019.09.18.06.59.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 06:59:04 -0700 (PDT)
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
 <7c0113e0-d455-e3e6-86fc-45429be196fb@gmail.com>
 <20190918055246.GC1830105@kroah.com>
From:   Tokunori Ikegami <ikegami.t@gmail.com>
Message-ID: <f3d20580-ac4f-6c63-83b2-4d7d0e7d69b2@gmail.com>
Date:   Wed, 18 Sep 2019 22:59:01 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190918055246.GC1830105@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2019/09/18 14:52, Greg KH wrote:
> On Wed, Sep 18, 2019 at 07:32:39AM +0900, Tokunori Ikegami wrote:
>> On 2019/09/18 3:11, Greg KH wrote:
>>> On Wed, Sep 18, 2019 at 02:50:48AM +0900, Tokunori Ikegami wrote:
>>>> As reported by the OpenWRT team, write requests sometimes fail on some
>>>> platforms.
>>>> Currently to check the state chip_ready() is used correctly as described by
>>>> the flash memory S29GL256P11TFI01 datasheet.
>>>> Also chip_good() is used to check if the write is succeeded and it was
>>>> implemented by the commit fb4a90bfcd6d8 ("[MTD] CFI-0002 - Improve error
>>>> checking").
>>>> But actually the write failure is caused on some platforms and also it can
>>>> be fixed by using chip_good() to check the state and retry instead.
>>>> Also it seems that it is caused after repeated about 1,000 times to retry
>>>> the write one word with the reset command.
>>>> By using chip_good() to check the state to be done it can be reduced the
>>>> retry with reset.
>>>> It is depended on the actual flash chip behavior so the root cause is
>>>> unknown.
>>>>
>>>> Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
>>>> Cc: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
>>>> Cc: linux-mtd@lists.infradead.org
>>>> Cc: stable@vger.kernel.org
>>>> Reported-by: Fabio Bettoni <fbettoni@gmail.com>
>>>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>>> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
>>>> [vigneshr@ti.com: Fix a checkpatch warning]
>>>> Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
>>>> ---
>>>>    drivers/mtd/chips/cfi_cmdset_0002.c | 18 ++++++++++++------
>>>>    1 file changed, 12 insertions(+), 6 deletions(-)
>>>>    mode change 100644 => 100755 drivers/mtd/chips/cfi_cmdset_0002.c
>>> You changed the file to be executable???  That's not ok :(
>> Very sorry for this.
>> I missed it to fix to not be executable since it was changed to be
>> executable on my local environment.
>> Anyway I will do fix it.
> Please do, we can not take these patches as-is at all.

I see.

>
>>> Also, what is the git commit id of this patch in Linus's tree?  I can't
>>> seem to find it there.
>> Actually it has not been pulled in Linus's tree.
>> But it has been merged into
>> git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/next for
>> v5.4-rc1 as the git commit id 37c673ade35c.
>> So I thought as that it is okay to send the patches for the stable trees.
>> But should I wait to be pulled the patch in Linus's tree at first?
> Yes, you have to wait, please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.

Thank you for your advice.
I have just read the rule as described this so I will wait it to be 
existed in Linus's tree.

Regards,
Ikegami

>
> thanks,
>
> greg k-h
