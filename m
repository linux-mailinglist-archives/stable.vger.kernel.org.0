Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7045729CBF4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 23:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832356AbgJ0W23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 18:28:29 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37784 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832352AbgJ0W22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 18:28:28 -0400
Received: by mail-io1-f67.google.com with SMTP id q25so3313167ioh.4
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 15:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yd2294ZBZMy4XljpTTzjUGRIXipCuL8kyBKHe5NQtNI=;
        b=UvStF98FJhE092zgD2uanf57kDNaIOnaSuCHnKirsofWd0aCjRO4Qy5GS3JnhbXeJd
         R0JIdamE6oJenSkkX6e4uPkCcRw420HhLdJjWD91oSYP5oBUv2PrnHcU21GtGHURFmaL
         AqzzPN//XnWoxpYoy6vkYKeKEXLuzf7F4/9rI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yd2294ZBZMy4XljpTTzjUGRIXipCuL8kyBKHe5NQtNI=;
        b=KX6OCoxkaqwEBdgJuhY1W0ZJz9yz9GozR9tLXBbJY6Y2tRQV52A4B4PQHxV3S4BJlX
         dVvQxJCpCpq08BYRRTsQWSihSDScqw5sh3MkxDEmafZ3ypyFtjwfGw5iQpX2x869fagi
         g2wtA/zr3FniQYyFYwVVDfNEKb4GMSkg92fS0Dngu+iZy7oIe11qLy36pzFg0CiwK+IX
         hMDWLUxl0D3pqHcJk98GO6sR2M2w7Uoz78yvDCbpHe9VtaU5wH3+318DQMJn7WwacqQK
         hVKgQam/5rT5qqkser1TMN4pa1OF+QLcj9lz0ep6nnqGancBM53+x7zKudY9o34k75gK
         SJjw==
X-Gm-Message-State: AOAM531Ei4gipDxN4mWi9unLUQmOpYQcZOQWLWwadOcQy3wfbNo/q5bm
        YrvWLHWcfYLIo64hRseVbGMJZg==
X-Google-Smtp-Source: ABdhPJySrsRO6td3S9ry6TCmbA6yj3jZ4Si223/83KN70hGwaMF2taBI3cWZWOi8+OG8ZYgPWvMvBQ==
X-Received: by 2002:a5e:8349:: with SMTP id y9mr3812931iom.188.1603837707726;
        Tue, 27 Oct 2020 15:28:27 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i201sm1549583ild.12.2020.10.27.15.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 15:28:27 -0700 (PDT)
Subject: Re: [PATCH] openat2: reject RESOLVE_BENEATH|RESOLVE_IN_ROOT
To:     Aleksa Sarai <cyphar@cyphar.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>
Cc:     stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        containers@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20201007103608.17349-1-cyphar@cyphar.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4ce6ba2c-8b23-78aa-47c0-8c9673273e8f@linuxfoundation.org>
Date:   Tue, 27 Oct 2020 16:28:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201007103608.17349-1-cyphar@cyphar.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/7/20 4:36 AM, Aleksa Sarai wrote:
> This was an oversight in the original implementation, as it makes no
> sense to specify both scoping flags to the same openat2(2) invocation
> (before this patch, the result of such an invocation was equivalent to
> RESOLVE_IN_ROOT being ignored).
> 
> This is a userspace-visible ABI change, but the only user of openat2(2)
> at the moment is LXC which doesn't specify both flags and so no
> userspace programs will break as a result.
> 
> Cc: <stable@vger.kernel.org> # v5.6+
> Fixes: fddb5d430ad9 ("open: introduce openat2(2) syscall")
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> ---
>   fs/open.c                                      | 4 +++
>   tools/testing/selftests/openat2/openat2_test.c | 8 +++++++-

You are combining fs change with selftest change.

Is there a reason why these two changes are combined?
2 separate patches is better.

thanks,
-- Shuah
