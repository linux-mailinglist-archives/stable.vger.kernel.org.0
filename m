Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C99D061A
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 05:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfJIDpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 23:45:23 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42250 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbfJIDpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 23:45:23 -0400
Received: by mail-pl1-f193.google.com with SMTP id e5so357155pls.9
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 20:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=liff+2I181mBeYcP7vnPa93eBbGSoVxP2sz1/iUSuJA=;
        b=lzHc6dfnxI3dTD9LV+12XsYQ1hfX4oAzzxy28wzYWGuzZM3OrIjcsVdMJsl2NCRffU
         nWHgdMrHBTKPRwoxwzLvUhyy8+d2CPtNvSNRmbX+PAPE0Ock4jWRBw/8L7PZq6VSYJx6
         Wv8bE4jrOsVmNqFT23UsmDV0HmsolL/P4rXtlBlF+xM0rKtomvz/At5XZpHwH2tV/p/X
         2tPKwyTBRpPAicoHU6BbukbZuruFT9/c0DLwvVTqcGPa4gaWWoIx5Xo9vxUbogtWfuM5
         VWd9rWEFHfhBen67fEILP6GH7uk3wS10t9Etur1Gac3M1FmL3+9NljBpx/B9grMGbZOB
         X4bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=liff+2I181mBeYcP7vnPa93eBbGSoVxP2sz1/iUSuJA=;
        b=eeNg3m63AQ4QH/Nt6npI9SGDRHtJbS+3cJfFrWCsinGWa2w17bdFXQo9bpsqBZ+Fho
         2bl9OrPWTQr8mp9emJ0cDVTqLsXD66iR+jlc9h39FfgJGjS4R7kxXuzQ5jBDV2EgzW0Y
         gbGXlJkF/n0D55MkLH5rzMP+3T4ZGwO9PUWKNK7wwriYYqNzft7GDzxpkTmF2eEpMO+G
         CPHzKPZWh0TN5VHCfdkrQ2QgSXwdYq/aKH0jXWKaC1EvIRNroI8/J6XbtO/MSgOEYjwT
         3rRIKXqVbwiEMMJEygsp5TXXwaq962ER/hGahQouJWaaFJNmXP95SH0wSiZjVSTCU7pt
         l0PQ==
X-Gm-Message-State: APjAAAXAx0BYrIrfPmBHU6rX/SXqY15Dvz3g08c4BK40lRDFwbs6H2tc
        +3Dl5KZ6tayHtLD5QSzGuT50QQ==
X-Google-Smtp-Source: APXvYqzfO/3qMUWyXK1s8QSMSKpYAi65qrIiMZYufP6UyQiC5vB5Y5+5O56CER+1kzI4YCQYOTisoQ==
X-Received: by 2002:a17:902:8d8e:: with SMTP id v14mr1030449plo.287.1570592721944;
        Tue, 08 Oct 2019 20:45:21 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id w11sm563669pfd.116.2019.10.08.20.45.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 20:45:20 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.3 15/71] rbd: fix response length parameter for
 encoded strings
To:     Sasha Levin <sashal@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
 <20191001163922.14735-15-sashal@kernel.org>
 <CAOi1vP-2iSHxJVOabN05+NCiSZ0DxBC9fGN=5cx98mk5RvaDZA@mail.gmail.com>
 <20191008212944.GD1396@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ecddc946-4fbf-4bb2-aac2-689135473f36@kernel.dk>
Date:   Tue, 8 Oct 2019 21:45:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191008212944.GD1396@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/19 3:29 PM, Sasha Levin wrote:
> On Tue, Oct 01, 2019 at 07:15:49PM +0200, Ilya Dryomov wrote:
>> On Tue, Oct 1, 2019 at 6:39 PM Sasha Levin <sashal@kernel.org> wrote:
>>>
>>> From: Dongsheng Yang <dongsheng.yang@easystack.cn>
>>>
>>> [ Upstream commit 5435d2069503e2aa89c34a94154f4f2fa4a0c9c4 ]
>>>
>>> rbd_dev_image_id() allocates space for length but passes a smaller
>>> value to rbd_obj_method_sync().  rbd_dev_v2_object_prefix() doesn't
>>> allocate space for length.  Fix both to be consistent.
>>>
>>> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
>>> Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
>>> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>   drivers/block/rbd.c | 10 ++++++----
>>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>>> index c8fb886aebd4e..69db7385c8df5 100644
>>> --- a/drivers/block/rbd.c
>>> +++ b/drivers/block/rbd.c
>>> @@ -5669,17 +5669,20 @@ static int rbd_dev_v2_image_size(struct rbd_device *rbd_dev)
>>>
>>>   static int rbd_dev_v2_object_prefix(struct rbd_device *rbd_dev)
>>>   {
>>> +       size_t size;
>>>          void *reply_buf;
>>>          int ret;
>>>          void *p;
>>>
>>> -       reply_buf = kzalloc(RBD_OBJ_PREFIX_LEN_MAX, GFP_KERNEL);
>>> +       /* Response will be an encoded string, which includes a length */
>>> +       size = sizeof(__le32) + RBD_OBJ_PREFIX_LEN_MAX;
>>> +       reply_buf = kzalloc(size, GFP_KERNEL);
>>>          if (!reply_buf)
>>>                  return -ENOMEM;
>>>
>>>          ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
>>>                                    &rbd_dev->header_oloc, "get_object_prefix",
>>> -                                 NULL, 0, reply_buf, RBD_OBJ_PREFIX_LEN_MAX);
>>> +                                 NULL, 0, reply_buf, size);
>>>          dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
>>>          if (ret < 0)
>>>                  goto out;
>>> @@ -6696,7 +6699,6 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
>>>          dout("rbd id object name is %s\n", oid.name);
>>>
>>>          /* Response will be an encoded string, which includes a length */
>>> -
>>>          size = sizeof (__le32) + RBD_IMAGE_ID_LEN_MAX;
>>>          response = kzalloc(size, GFP_NOIO);
>>>          if (!response) {
>>> @@ -6708,7 +6710,7 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
>>>
>>>          ret = rbd_obj_method_sync(rbd_dev, &oid, &rbd_dev->header_oloc,
>>>                                    "get_id", NULL, 0,
>>> -                                 response, RBD_IMAGE_ID_LEN_MAX);
>>> +                                 response, size);
>>>          dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
>>>          if (ret == -ENOENT) {
>>>                  image_id = kstrdup("", GFP_KERNEL);
>>
>> Hi Sasha,
>>
>> This patch just made things consistent, there was no bug here.  I don't
>> think it should be backported.
> 
> I'll drop it, thanks!

How did it even get picked up, it's not marked for stable?

-- 
Jens Axboe

