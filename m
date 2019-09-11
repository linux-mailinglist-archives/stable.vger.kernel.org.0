Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E63CAFE4A
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 16:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfIKOGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 10:06:06 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36697 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfIKOGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 10:06:06 -0400
Received: by mail-oi1-f193.google.com with SMTP id k20so14197135oih.3;
        Wed, 11 Sep 2019 07:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dG0h5xr7PLWX3L1atFp9BWDn9f7GpG/Z8DYTb3U4rQ4=;
        b=ZP2OF21C3vwcf7/IRHQORsFEZmCsgicTi1Op+DG2/KplgJVDynX5wuLDrzyOkVlX0f
         hUxoAlJXYriNpae7K3bbZYoOSoXR4gP1JXwCMVCzd612qB1PvozP0/3K1BZMB3yjV0a+
         c6SxtaouKPgXbvv8LyiwDU00REQsv4TdN6phb5TvoUyQSNVkOWusjkdqO8pLPNAcs0MP
         ahg0exc4I5NlVcrSt1w2lwVXxEAb6iQc0VEpGIb2Wgoui/tEvmFxN0pcH4Mu59IBFdT5
         CNTSLVkfygneI9wOBFNzad4DvfAzafUeP08r/nYxdOm2Ld/uOiDmAS1CNJ17yQi8cChr
         chxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dG0h5xr7PLWX3L1atFp9BWDn9f7GpG/Z8DYTb3U4rQ4=;
        b=S6O3vTBluwMl6jEl3XtZFrCWNnz9q+ZJlFwrmQ2/9ElDdPIpBkzS/FrBoX8WOHX+/A
         ckP8Bf1k4YgzSE3iWWo29IwCSbBvDnhJyOs4ERUjb88ThE1Jb2be2qgGf82jBBhlJAp0
         vWRSB8Z0TBXDs8GwiybZmPlMry02/igpOHesyGbpdrW1CP4zcUdeMVLRIgR8wS0ZZ/xR
         8tVpbR9gxM971wZ/OrmI4wb6AHo5/JzGw0BuGWfwEqMge8jUCVqAxcCxBAdV97Bx7PP1
         4IM69IkVjhBAkIoPtsKQ9zfrhRl4gwuHQYaJForON0snsZoa0YO5CzzvyDLMAzX/lZI9
         +8Kw==
X-Gm-Message-State: APjAAAV0b7yj5Tk2feB+FgwALGotTKSLddeVWs8WJuUYikI3eTrDBne7
        5XpLuULqg2uR9Lw+dPtZpIUCqlvQ
X-Google-Smtp-Source: APXvYqyX2jvH3BqvZXW/hU+naeoh/m6eknkg01iFOvHHszGb1/7T64Zi4J5PJex2m/6UnXOf4OnC2w==
X-Received: by 2002:aca:c645:: with SMTP id w66mr4413165oif.9.1568210765336;
        Wed, 11 Sep 2019 07:06:05 -0700 (PDT)
Received: from [192.168.1.249] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id i47sm8174197ota.1.2019.09.11.07.06.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 07:06:04 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: Purge frame registrations on iftype change
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20190828211110.15005-1-denkenz@gmail.com>
 <5dc694c33759a32eb3796668a8b396c0133e1ebe.camel@sipsolutions.net>
 <bb8d43d2-8383-1f7c-94f8-feecc29240f3@gmail.com>
 <ea9a895d18a34b876c440e6272b1d55d27c8a419.camel@sipsolutions.net>
From:   Denis Kenzior <denkenz@gmail.com>
Message-ID: <8fdb9d1f-d535-22ed-1a1a-357f826ecf54@gmail.com>
Date:   Wed, 11 Sep 2019 07:12:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ea9a895d18a34b876c440e6272b1d55d27c8a419.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johannes,

>> 'typical' failure paths.  I didn't add such checking in the other patch
>> set since I felt you might find it overly intrusive on userspace.  But
>> maybe we really should do this?
> 
> As I just said on the other patch, I think we probably should do that
> there, if just to be able to advertise a correct set of interface types
> that you can switch between there. I don't see how it'd be more
> intrusive to userspace than failing later? :-)

What I was worried about was that all the fullmac drivers would have had 
to be updated to set the feature bit, and it would have caused 
wpa_s/hostapd to no longer be able to do the whole set_iftype -> ebusy 
-> ifdown & set_iftype retry logic until all were updated.

>> I would concur as that is what happens today.  But should it?
> 
> Well, dunno, what should happen? If you ask drivers they might want to
> remove & re-register after, for those registrations that are still
> possible.
> 

I would think you'd want to define a clear order of operations that 
cfg80211 / mac80211 would enforce :)

> 
> Let's not then.
> 
> I've applied this patch now.
> 

Great, thanks.

Regards,
-Denis
