Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2AF1C9A7C
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 21:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgEGTF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 15:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728068AbgEGTF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 15:05:26 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403AFC05BD0A
        for <stable@vger.kernel.org>; Thu,  7 May 2020 12:05:25 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id u11so7432872iow.4
        for <stable@vger.kernel.org>; Thu, 07 May 2020 12:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ALX0KlPOa5CmEMJbE+NcOQr52VcvkvocxSaJgPs417g=;
        b=Odrj/j3H0R7hU8+KYumKak54Bi+Nji00rmKhdstid0P4Ewljc7iDKHNEpARAT40gcH
         hzH0vj3WvTXm1ES6BIUNbnVw2YbUtEj9vl83wkIK26sOKxDubnJIlLmHbJ1mjPVGiK6b
         V1OEl8KM5n50UmVKne7i3ftrx8lMD6VoGvRH6+fK95wyRGwyZKJN3MlIz3wWy8IVhmQk
         mMBrDJSDXA5gBqgXRyntLHSM4Bx6J518MDCJ0dGdveW3Tgt0BO1sr6zDJc3v52Y35Gly
         r2SOi/5yoxTMcu8YaGwcTiCPZyC9uKNhDP3mmP0BIDXVx9OMi3OleEt5p85oOyO06FQb
         XmLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ALX0KlPOa5CmEMJbE+NcOQr52VcvkvocxSaJgPs417g=;
        b=VL1FXlQ87NZWNQhCT6C2D6Mc9npsM1kSraIn3LRb6YgoYBUz9IhOovXwDg4RAXG1vG
         Nqv+iF+Dw3yXQ6NfWutYiIGLCu8CXrr4+VNtDiGa1r5IITNz7ylPMgMLKbR8IrOiq6w9
         pMVZ0+lydOLsUpHvlx83eCuScr9MnqWWUHE0mzlsi0uiLpdBt7I9ifeSeqsloMvRfCGR
         5tRIn/LW4xzmpEJXydLE4r/V89XjgSMse0JERy1DivrG7QyQRJTb7zpi9UQ7KtF2muCb
         irX2DY9qgwg9BpiGNy1n6OmKgDk5MhcS4JwhudUoowpuSATOuaDQWQ2UVi8o6AFXdhTl
         Uegg==
X-Gm-Message-State: AGi0Pua2s6rLvFM88zgkj7UHLLUY79Vlx5UhQXCj07SCz2uM1Jy91tWj
        A0RbPo9fOp6KxKss8Emb6Vd4sImJT8Q=
X-Google-Smtp-Source: APiQypIJCHCIpoM48c4qIZqQu9tdwVZS1I9D2iSqJLjDdhQcB6uT+NCdo27NSUgNnuII8pu0E8zfpA==
X-Received: by 2002:a6b:90f:: with SMTP id t15mr15169184ioi.188.1588878324422;
        Thu, 07 May 2020 12:05:24 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u16sm3076929ilg.55.2020.05.07.12.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 12:05:23 -0700 (PDT)
Subject: Re: [PATCH] fs/io_uring: fix O_PATH fds in openat, openat2, statx
To:     Al Viro <viro@zeniv.linux.org.uk>, Max Kellermann <mk@cm4all.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20200507185725.15840-1-mk@cm4all.com>
 <20200507190131.GF23230@ZenIV.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4cac0e53-656c-50f0-3766-ae3cc6c0310a@kernel.dk>
Date:   Thu, 7 May 2020 13:05:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507190131.GF23230@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/7/20 1:01 PM, Al Viro wrote:
> On Thu, May 07, 2020 at 08:57:25PM +0200, Max Kellermann wrote:
>> If an operation's flag `needs_file` is set, the function
>> io_req_set_file() calls io_file_get() to obtain a `struct file*`.
>>
>> This fails for `O_PATH` file descriptors, because those have no
>> `struct file*`
> 
> O_PATH descriptors most certainly *do* have that.  What the hell
> are you talking about?

Yeah, hence I was interested in the test case. Since this is
bypassing that part, was assuming we'd have some logic error
that attempted a file grab for a case where we shouldn't.

-- 
Jens Axboe

