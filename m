Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7DC2CCA7D
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 00:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgLBXZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 18:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbgLBXZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 18:25:00 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EC4C0617A7
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 15:24:14 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id e23so206928pgk.12
        for <stable@vger.kernel.org>; Wed, 02 Dec 2020 15:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dnoTL/j78/GLlJgkxUiUGABx5fodVU0RbVMA54xb55A=;
        b=cbdvv4HEcqxdANldfkOLzVi0e72dF7T3cfOFN+8+kGmQ4/OgsjpC72C7olbbm/eqZx
         J/zpD66GKtwfzhCny8aVzfLJFrji/YiZ5YTkj1Lv7e5F++ZOgX8rk7X5s8YRgeiZLjB0
         Dq47WNQFXZATDNCru8dlbSZoLgqsu0l/lz+xgQ4UXG2cqWGdRQi3GLaqxL8hPM4oD10A
         mMC5LEINqzql8lAKM+0qLS1wxKriJ2EMdqsaJV3FrpdiL0yqQzmHQrFTv5s2qe/v4r7S
         wvaE7gOj19J073EQtgwRWCX8XkqIz/QxxlQn793hqeVvKva3iw1tPeEumAS2EsxG3N7o
         g4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dnoTL/j78/GLlJgkxUiUGABx5fodVU0RbVMA54xb55A=;
        b=a4Hp/0G+NfyxYG6EBmp5ByAT+kHLZRPUJFvGenM8XrjyOLh+gjlbtvjSh5JA93jdyO
         dsbV86ynarA9H/KXjnhrqnh+kuZsDmpEk6Bi7Z49a7VxWYVMghtfpOQNd/A8Ku1tXysH
         Pyyp1Y0UwwO1FUbTTbQF+5NfF/9WCkyefCwnnGPHOz9fiKbj11y1Cc2Gw6O6Kl9XXzU7
         KEKRKSuP5G5ShU333H7m2paw+Ve5U08s83nLHzOqhmF25AJ0/tNk8V5Tw7VryvoibfXG
         FKQTFUoSyQ0B8FieIzJR4XBmamcZw7PfBTeTPXBhQC01kqEcJouDv/VvrON/gbl9EhZz
         4F7w==
X-Gm-Message-State: AOAM533ZSl35IdRDCeBMdNbKlnlKO4RHK97DE+sc+I0yZkdET34FkqK7
        kqhBlLOr8ipSIl4kbARY2f3qUBqbN/OqqA==
X-Google-Smtp-Source: ABdhPJw8qNWfh77J+ibW7chTT6vTsbGxkWB07n3S2BEDgzvVERRpVIRDf6sw8mC6RWEXIY8fc0HHdQ==
X-Received: by 2002:a62:2a81:0:b029:18c:310f:74fe with SMTP id q123-20020a622a810000b029018c310f74femr563331pfq.50.1606951453831;
        Wed, 02 Dec 2020 15:24:13 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o11sm19638pjs.36.2020.12.02.15.24.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 15:24:13 -0800 (PST)
Subject: Re: [PATCH 5.10] io_uring: fix recvmsg setup with compat buf-select
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <70a236ff44cc9361ed03ebcd9c361864efdf8dc3.1606674793.git.asml.silence@gmail.com>
 <ee19d846-6f58-5ff0-7928-48c00fcbce3a@kernel.dk>
 <14be454c-46cc-310a-1a43-6065f3b3020b@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d67dd667-d161-a070-06ed-0cd0ae0e617a@kernel.dk>
Date:   Wed, 2 Dec 2020 16:24:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <14be454c-46cc-310a-1a43-6065f3b3020b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/2/20 3:04 PM, Pavel Begunkov wrote:
> On 30/11/2020 18:12, Jens Axboe wrote:
>> On 11/29/20 11:33 AM, Pavel Begunkov wrote:
>>> __io_compat_recvmsg_copy_hdr() with REQ_F_BUFFER_SELECT reads out iov
>>> len but never assigns it to iov/fast_iov, leaving sr->len with garbage.
>>> Hopefully, following io_buffer_select() truncates it to the selected
>>> buffer size, but the value is still may be under what was specified.
>>
>> Applied, thanks.
> 
> Jens, apologies but where did it go? Can't find at git.kernel.dk

Looks like I forgot to push it out, but it did get applied to
io_uring-5.10. My git box is having an issue right now, so can't even
push it out... Will do so tomorrow morning.

-- 
Jens Axboe

