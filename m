Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B1C45104E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242695AbhKOSp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:45:29 -0500
Received: from mail-pj1-f54.google.com ([209.85.216.54]:46658 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242615AbhKOSm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 13:42:58 -0500
Received: by mail-pj1-f54.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so576632pjb.5;
        Mon, 15 Nov 2021 10:40:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Qq1oYPT2bATap84U8yzlebca1go/bddrPCpIhQ/oN8=;
        b=vjfHZ/T0wkBqG3HXbTzEeKftmumMjh+etdKFZDZd7s3+gKIhiazxvhGyF/zJipJ19/
         fiGN74/TgIxar4Sp6r7GCS8aXhVd9QkMWskSjM95dscOGY4YeQEno4qIz7HvzQIKA6Qv
         6eWtHeDvipwFLnh9XYapZmDM+MI1Mq8IxZpAvTxpGhz2rpolv+hJzNGITnmGRut5xhjb
         twPikGuPCERTCHxEFeNR0jLjSQeiqjCPQr80z6hmxbmsFaR2UOWRe137T5JrxOLh1+1m
         9OKySh8HGUPKLT+4iOQmIjIpJcOzUku2/S1lN2PFuU9JjA9fEGY0uWHlNZC0+6zKan4v
         qnJA==
X-Gm-Message-State: AOAM5315APqSiAcgQBwsSggAw3QCf0aFHuy+oowfFt4t+uXECjvBa1aQ
        zf/uoZdtHEYAuKR+AIAuTKZk2cj52SCtAw==
X-Google-Smtp-Source: ABdhPJxqu5DEBxNKfYq6bVKKiDASVhYHF3GWI3OGaYQ2c+51xwf/qrlrl1nR26UTz0Z522sEk1hmYw==
X-Received: by 2002:a17:90a:1a55:: with SMTP id 21mr836115pjl.240.1637001602352;
        Mon, 15 Nov 2021 10:40:02 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c779:caf7:7b7f:3ecd])
        by smtp.gmail.com with ESMTPSA id d3sm5793910pfv.57.2021.11.15.10.40.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 10:40:01 -0800 (PST)
Subject: Re: [PATCH v2] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
To:     Alistair Delva <adelva@google.com>, linux-kernel@vger.kernel.org
Cc:     Khazhismel Kumykov <khazhy@google.com>,
        Serge Hallyn <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, kernel-team@android.com,
        stable@vger.kernel.org
References: <20211115181655.3608659-1-adelva@google.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <da032e9f-0b95-f517-6e3c-647668fd823f@acm.org>
Date:   Mon, 15 Nov 2021 10:40:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211115181655.3608659-1-adelva@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/21 10:16 AM, Alistair Delva wrote:
> Booting to Android userspace on 5.14 or newer triggers the following
> SELinux denial:
> 
> avc: denied { sys_nice } for comm="init" capability=23
>       scontext=u:r:init:s0 tcontext=u:r:init:s0 tclass=capability
>       permissive=0
> 
> Init is PID 0 running as root, so it already has CAP_SYS_ADMIN. For
> better compatibility with older SEPolicy, check ADMIN before NICE.
> 
> Fixes: 9d3a39a5f1e4 ("block: grant IOPRIO_CLASS_RT to CAP_SYS_NICE")
> Signed-off-by: Alistair Delva <adelva@google.com>
> Cc: Khazhismel Kumykov <khazhy@google.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Serge Hallyn <serge@hallyn.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: selinux@vger.kernel.org
> Cc: linux-security-module@vger.kernel.org
> Cc: kernel-team@android.com
> Cc: stable@vger.kernel.org # v5.14+
> ---
> v2: added comment requested by Jens
>   block/ioprio.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/block/ioprio.c b/block/ioprio.c
> index 0e4ff245f2bf..313c14a70bbd 100644
> --- a/block/ioprio.c
> +++ b/block/ioprio.c
> @@ -69,7 +69,14 @@ int ioprio_check_cap(int ioprio)
>   
>   	switch (class) {
>   		case IOPRIO_CLASS_RT:
> -			if (!capable(CAP_SYS_NICE) && !capable(CAP_SYS_ADMIN))
> +			/*
> +			 * Originally this only checked for CAP_SYS_ADMIN,
> +			 * which was implicitly allowed for pid 0 by security
> +			 * modules such as SELinux. Make sure we check
> +			 * CAP_SYS_ADMIN first to avoid a denial/avc for
> +			 * possibly missing CAP_SYS_NICE permission.
> +			 */
> +			if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
>   				return -EPERM;
>   			fallthrough;
>   			/* rt has prio field too */
> 

Are there any other SELinux policies (Fedora?) that need to be verified?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
