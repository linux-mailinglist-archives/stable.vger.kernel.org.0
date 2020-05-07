Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169361C9A2B
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 20:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgEGS6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 14:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727889AbgEGS6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 14:58:53 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A48C05BD0A
        for <stable@vger.kernel.org>; Thu,  7 May 2020 11:58:53 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y26so2470617ioj.2
        for <stable@vger.kernel.org>; Thu, 07 May 2020 11:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X06gQhxNuqNC0FB5uh4LFKI+uUsgLH7IELkz/3JNWnI=;
        b=yVZIlWrdh9uyveIkGpKsIFZio5/7W9X57tsGyag7WPhT84Xn10Dm7l1E2gxJsCPI8/
         CPepTbjA5RftqJkhZmxP47Pe4UZASvjtz8oJqGiALj5nsjPSe+iRqAwLPST3+LHZ4lzD
         S0xTTOVBK37ZkTHPRgiPXXVLsXfUvi7TF0ez4pgWTWqKyjBBLzn2N+Ss9nORekhp2L0x
         tiZzM0mqXZboUxiluSs1yElFyJhTnt7snX9yeftY7wBd1GNcRU7Rt6e/yI5FJg1SHGqA
         qngqM+I6y+2G/sC86VRnOi9Imz0e7iZOTtlo0TvQIc1z1rs+0Z/nstLroceqd+gO+vdO
         Go9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X06gQhxNuqNC0FB5uh4LFKI+uUsgLH7IELkz/3JNWnI=;
        b=jan1HOBMkPNp0bCUK9qbc6SubVGB2vlWvweB+SUiRwA73l2PaJDdsE3g4yBSamGg9e
         a2wTR2ebt8FFeWWtczJKKok/tonC/xtBbVB6WKMG9y+0UBy4f4ezJQLbdOYX+yg1Rxe9
         TaoqNOLRyJXYDMN4d9PkB7xRnM3OyeAAl1Uup/wJbxHcnqU12IiYADUBr3aSiTtPXqFU
         TigUwVKWLhTDL6JUlk0sHsw+f3EKoj481+9ZMkY28qn2Sm50yVXNGSCoxINK/SobEYH0
         /5K5ZlUCbqWfIEfVxrj2WRxwDlyLp1isb++LaI6Kw4qsZzGKJjqnKlQEFQqgmB1aZZAI
         2P9w==
X-Gm-Message-State: AGi0PuZC/PjguswB6IKcSMITN5ggt5QW3gJUxn+cngr4/VE0r1HZ76gA
        45Y+uP/HrjV95uLgJhBPIWCM638i8QY=
X-Google-Smtp-Source: APiQypLKj9rERGXnwSxHGoeKcyPtXyMeD5lEx3YG7RLuJaR44rMQRzpnWHbj/jf6H0x74lZ8l+ciHg==
X-Received: by 2002:a05:6602:2e0b:: with SMTP id o11mr14921537iow.94.1588877932759;
        Thu, 07 May 2020 11:58:52 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z2sm3085748ilz.88.2020.05.07.11.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 11:58:51 -0700 (PDT)
Subject: Re: [PATCH] fs/io_uring: fix O_PATH fds in openat, openat2, statx
To:     Max Kellermann <mk@cm4all.com>, linux-fsdevel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200507185725.15840-1-mk@cm4all.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a048108e-67e0-b261-ab56-312a98045255@kernel.dk>
Date:   Thu, 7 May 2020 12:58:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507185725.15840-1-mk@cm4all.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/7/20 12:57 PM, Max Kellermann wrote:
> If an operation's flag `needs_file` is set, the function
> io_req_set_file() calls io_file_get() to obtain a `struct file*`.
> 
> This fails for `O_PATH` file descriptors, because those have no
> `struct file*`, causing io_req_set_file() to throw `-EBADF`.  This
> breaks the operations `openat`, `openat2` and `statx`, where `O_PATH`
> file descriptors are commonly used.
> 
> The solution is to simply remove `needs_file` (and the accompanying
> flag `fd_non_reg`).  This flag was never needed because those
> operations use numeric file descriptor and don't use the `struct
> file*` obtained by io_req_set_file().

Do you happen to have a liburing test addition for this as well?

-- 
Jens Axboe

