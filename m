Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30630392197
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 22:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhEZUqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 16:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbhEZUqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 16:46:37 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A62C061574;
        Wed, 26 May 2021 13:45:02 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id j10so4527292lfb.12;
        Wed, 26 May 2021 13:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k1ZZHXurjV73AN1e/cGKB44Qe+b8KYpJFbH2G12urgk=;
        b=hyNPGhiUY1NXt7v2t95BgImr36Vt8RJ07uWA7EGOXM9b3M0/g7JJA/6afZOu5bXJPC
         o0vZvh98AYv6NynIsHl6T8Q/3ipQ59xKAxvYTxGJaSi7DnixpRiiPLLhoiw5QJZezMIu
         eEvLVQTKPB6S8mCktD7LE835w4eZLR2ITickkp3p7Z3vgJGBM+Tcyi1ROFMCTYJvK4rH
         segR5in7PJYVM3enUIywZFav/sIOIBW7BXRqq1ZIKoJPdMoF3GAyk1oezxXeuSK30e1z
         sNc4cbliish54HVe9U2dh5+POEvXtoid/S9GxxdjgzLQ2YBweLvY2Hte1RTkd01OJIVr
         R5jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k1ZZHXurjV73AN1e/cGKB44Qe+b8KYpJFbH2G12urgk=;
        b=hlkot4Skn32pXg+slek7rGwQLdf7l9iPkC6QFZHV75+VBbkzxj60U9oGb49sRKFTBh
         sTrTeN70s18JJXoGjlOyUk6n74A+NYHnnHKG/aM2N0oGpUuN6nO6ZAQdhANX9VFiMTOP
         LZg7bkd5fIk6kiTn82puICdlM+O8G16neizZ8hUe0pdAEss0qTgpgEuUkzn0k7nbAcWQ
         vfYs8GiMvmAGxEq23/X5l953SR+B5W7P4oCCT3XDMahRc4GKii/WmLURyH1qqbisWlBH
         rFM11Scs7APYPwII3IxNi0lJgqG56NyAe6Tk3Cj8nh4aVhgop+hxXFwhLDvKS27QF2OM
         49Zg==
X-Gm-Message-State: AOAM5300JvMNLbaNDwI01c5USQDK5A+dsR1wY1ELauJ/uWxIVTw6RS6V
        XMo9Bnb9/YVmoGtH3IQua6fBUPBDXMw=
X-Google-Smtp-Source: ABdhPJysEhakTuOViXZSLHVs3z0i7B5h+grtzUUmbPIw4k+264g+dmbMkjWHd+fpcEELU5eq0a51tw==
X-Received: by 2002:a05:6512:b9e:: with SMTP id b30mr3509670lfv.323.1622061900720;
        Wed, 26 May 2021 13:45:00 -0700 (PDT)
Received: from [192.168.2.145] (46-138-12-55.dynamic.spd-mgts.ru. [46.138.12.55])
        by smtp.googlemail.com with ESMTPSA id y24sm9727lfg.232.2021.05.26.13.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 13:45:00 -0700 (PDT)
Subject: Re: [PATCH] Input: elants_i2c - Fix NULL dereference at probing
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210526194301.28780-1-tiwai@suse.de>
 <YK6tZy3E/XZpOAbh@google.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <b7fc167b-23c6-fd64-cfbf-dd16a90fbf63@gmail.com>
Date:   Wed, 26 May 2021 23:44:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YK6tZy3E/XZpOAbh@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello all,

26.05.2021 23:19, Dmitry Torokhov пишет:
> Hi Takashi,
> 
> On Wed, May 26, 2021 at 09:43:01PM +0200, Takashi Iwai wrote:
>> The recent change in elants_i2c driver to support more chips
>> introduced a regression leading to Oops at probing.  The driver reads
>> id->driver_data, but the id may be NULL depending on the device type
>> the driver gets bound.
>>
>> Add a NULL check and falls back to the default EKTH3500.
> 
> Thank you for the patch. I think my preference would be to switch to
> device_get_match_data() and annotate the rest of the match tables with
> proper controller types.

Doesn't a NULL mean that elants_i2c_id[] table fails to match the ACPI
device name? What is the name then?

This could be two patches:
  1 - trivial fix that can be backported easily
  2 - switch to device_get_match_data()
