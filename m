Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66A23ACDFD
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 16:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbhFROzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 10:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbhFROzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 10:55:07 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DCFC061767
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 07:52:57 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id m137so10825622oig.6
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 07:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lfcsRgFy2xq8rFyaA8Nz5ZAiMzCPmlUUdOOARhZaZCQ=;
        b=gsoQ9aEfUO7Xvs0FyVDIHEU7u9CS+WcWA/IyOVjbcfTH6pgLtYG8n2K/qgdFFkFmRf
         CXTr/rOKIp7UANm9ovr65iZDf2vHLmZXO0NOcG2mXmkgoSworF25MLAOtYU6BaU6Ichi
         GOlS7y1zLqEGJ9rFASZT+JtZpp7+ECxoZiEAIP1DCUfxe7nPbSyGxqSvowpB/q6Yvykp
         9TLWjo5CE+48kh9XOMzUniF9/K92pN4OF45voWnFAQ28XOrkbcz1cWim2QhVcOj65y0G
         pnGfcfxt92pZ42v4BaXBzEZCgklA785C01Zo5obJPxYqQCFfnBYPpNC0uBD8JWsZEFc+
         ybWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lfcsRgFy2xq8rFyaA8Nz5ZAiMzCPmlUUdOOARhZaZCQ=;
        b=l3phie7a4USsf5csxEzToN+0UOoJElWeagS/HhdpBq3bRse8LpMDJLxT5bejB4naIG
         As/Yw4Z6Y3cjhvHs0TI5adKIFdbfYYucuhEzTnqk6NI0r/heIjpNZT4TeycFvoW1CJC5
         meN2qIz+iZg/w8wakOAGvyt+NoXQD85KcT9akZOtnzWGZcRX1crZ1Z0UfPpJL6w4oHLo
         oapgR33j7xvm4ZRa/z8wgAHwioOuPMs7faY0aOseoX9sjUW8im2bjLgYBhadOjuTfNxi
         CaiRIsJGIliiQSvSAhK61Atj31ZXifTzKTnl6gaLtj9oKFLIAMfYgpZAbYA/iU8kysby
         SU/w==
X-Gm-Message-State: AOAM532n0qYQG0ZBAyAPIs5DdxTmnSrQ3yr0+cYeGI00BMef/zDxnhip
        z8UtwgayxtVpSV/GVlqyu3k4kQ==
X-Google-Smtp-Source: ABdhPJye1eow3zDlcW8WFc5WqtQz3JnuGxiQji+GYWeMI7kL1izOVo3QAosH6I6TqQTmqa+mXYdt2A==
X-Received: by 2002:aca:4fcc:: with SMTP id d195mr14553893oib.88.1624027976941;
        Fri, 18 Jun 2021 07:52:56 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id 3sm1856148oob.1.2021.06.18.07.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 07:52:56 -0700 (PDT)
Subject: Re: [PATCH v2] loop: Fix missing discard support when using
 LOOP_CONFIGURE
To:     Kristian Klausen <kristian@klausen.dk>, linux-block@vger.kernel.org
Cc:     stable@vger.kernel.org, Martijn Coenen <maco@android.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20210618115157.31452-1-kristian@klausen.dk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <64494b7d-01b3-8da3-e10c-d346746758ea@kernel.dk>
Date:   Fri, 18 Jun 2021 08:52:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210618115157.31452-1-kristian@klausen.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/18/21 5:51 AM, Kristian Klausen wrote:
> Without calling loop_config_discard() the discard flag and parameters
> aren't set/updated for the loop device and worst-case they could
> indicate discard support when it isn't the case (ex: if the
> LOOP_SET_STATUS ioctl was used with a different file prior to
> LOOP_CONFIGURE).

Applied, thanks.

-- 
Jens Axboe

