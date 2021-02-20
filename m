Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6BC6320396
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 04:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhBTDvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 22:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhBTDvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Feb 2021 22:51:38 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBDEC061574;
        Fri, 19 Feb 2021 19:50:58 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id l12so11666766wry.2;
        Fri, 19 Feb 2021 19:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sYMGQY4FQ9Vle0M1pWK4gDcW3LphMLiWlqDqe7HzToI=;
        b=ZVpSTskeOSy79TcVJ/Fz7ZMtLh3SCNx5SFjwQ1HPw/YjNfB/fABGtMNsohPRYVyc/r
         wix7Iq/7Ley8OvjD87k/Y1hj40O+wvNXnzkjn5P/szxC6aAsM52XW5NHmA/zr+bBgphj
         hopigS1qAzxy0dyE6NqUfNGzKJ3o8f1YMhKboVdTRBdPU/plo9bK/a+o4pmj6+iRhAJl
         NDy6rulPT9wlwqSi4DHo3MlyRGhRDWU8yueTka0hA816A0YDLXRCH/ylEozavkaAoivu
         5q9yvQcjVJ8QM2BmbbxWLZ3pZbA/x6fvIkUZQYvkOmZdFcXpBFciJXHLLWWbQZek4QOj
         RAaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sYMGQY4FQ9Vle0M1pWK4gDcW3LphMLiWlqDqe7HzToI=;
        b=CB9+cDJiwJZpQbAPpkAvGas2tL86TJfRrSqUqyfiy94f2JGR21gAdUuhuo1KKYSrTh
         cBgek9ywSMXcA+sk0rt9ApultMXyNE3VHG1enfiZDZwOhhhRH0jPn1+9Wsu/eQyAEZiL
         A9Q8UJoHREAYfZKrp+9e9WAx2BSQYLFciQlmP041ojQxyX3MHoNLMyAyaVjYpBbtNJcj
         Ym5vg4uX0BdEqXZr5+253Rqa2Cf853B5jnCDOoRlzQD5Mox2jiEYKIIzM4qxFAk4n6k6
         zqk5bCmGoL4dJ2c8QZJ+UuNMfBivEeYIhr3C2OMY7Y/kfi6OAqtp+EUrJ0o9E/wJ4RX0
         6NCg==
X-Gm-Message-State: AOAM531EYkA2cDl+NBJ5l3krumPIDLhJ2naXOA4LVZ8Qufpyk799EQqN
        adJr2045/HUPOvqqy6kFybmKt6zsFhbQOw==
X-Google-Smtp-Source: ABdhPJx2HxKjwZs42w85yO/RgAUu684TSqk/YeYQFkQLaxK9dswpN/ooJvQ5JHDAj6LLC3Y3PNZcwA==
X-Received: by 2002:a5d:53c5:: with SMTP id a5mr11818706wrw.263.1613793055194;
        Fri, 19 Feb 2021 19:50:55 -0800 (PST)
Received: from [192.168.8.140] ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id g18sm16124352wrw.40.2021.02.19.19.50.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 19:50:54 -0800 (PST)
Subject: Re: [PATCH 1/2] io_uring: wait potential ->release() on resurrect
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <cover.1613785076.git.asml.silence@gmail.com>
 <75e1c94aff46a5bc409f50e50207f4d9a01ff9a0.1613785076.git.asml.silence@gmail.com>
 <914848f1-f30e-4d3a-ab40-9db78e1321b7@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <217745e7-0e2b-0faa-8fa9-8e4757515128@gmail.com>
Date:   Sat, 20 Feb 2021 03:47:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <914848f1-f30e-4d3a-ab40-9db78e1321b7@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/02/2021 03:40, Jens Axboe wrote:
> On 2/19/21 6:39 PM, Pavel Begunkov wrote:
>> There is a short window where percpu_refs are already turned zero, but
>> we try to do resurrect(). Play nicer and wait for all users to leave RCU
>> section.
> 
> We need to do something better than synchronize_rcu() here, that can
> take a long time on a loaded box. I'll try and think about this one.

It only happens when it can't be drained and there are task_works or
signals. I have another patch, doing it via tryget, but it's uglier and
I'd rather prefer synchronize_rcu for stable.

Want me to send it tomorrow (on top or not)?

-- 
Pavel Begunkov
