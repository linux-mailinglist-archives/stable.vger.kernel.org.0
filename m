Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1384135F1B0
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 12:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbhDNKu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 06:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbhDNKus (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 06:50:48 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7627C061574;
        Wed, 14 Apr 2021 03:50:22 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j5so18440451wrn.4;
        Wed, 14 Apr 2021 03:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wtL4NEaz1e7dZ5rH59pH/u2eUopJxXPtepf8OA0VPwo=;
        b=uEnENVCGrAkSwljvFQE8R7TjyuNNrtj3oBbFJksFZ/DWUtDLvXkHPf7Flp6L+I2+ZY
         XRd22nOx9aq/gGdw2eTN0ibQXrVqqYogIb/y8oRWL9ApNCqxV0I5pqlt9aZgwLXubhoH
         fE9f/wOP7XvvVr1hh0p4FvdCkaf438ibhI0FnO75Vd0EoYf0KlEO7aCBf8m33Gy2eenW
         QkjRJaeQE9gdrpgl1dlBjfZHiW+qf/ePFsZaqUKyvvV/0OHnSRlZAE6P+PRXd26sYwFz
         FrawXOg6+ulsYWAwTQ2w24FJGhuRHIgYQf3XkD3YeJeIpVLQeV4QwhfiW2FDDeRA/3/N
         FWYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wtL4NEaz1e7dZ5rH59pH/u2eUopJxXPtepf8OA0VPwo=;
        b=VUswseiJOHaVng8+AOsBWIs0I+kp1hzpmF5o/eH4lz0ZLXtVA6ku5xvbW1N+aJm4jJ
         3ARuSpFOl5GAE5JxAdlLhayIQiF3ArLL4+Z0fxFE49mgNvJ86sYALaRl6McdE2sdg87U
         0GJsVvczq0Sd3L1L9p4DFQADm80cghR1m8AEWTHT+cAb2kp4+XefTJdNHQXDtXGmAQUu
         m/GwsR6XRlY8sP5alUHRlV2CUV8yEcN1eFE9Wtdw0whQFUJ5lmQqc25xgyIre2saUt7w
         Z+C3oixSvJZYVNFMlK9o0y1xGdp15ej9q6/j3KQ5L9RUD7xqShEQAxCH5OcrY9F1+6nO
         3cLQ==
X-Gm-Message-State: AOAM532obfPLRu3sI+TFwTRCO1Zt7gHF06+SijoeE4/1l3RZwrnRed7C
        AwxD/QHU7X/43b/A2IjD31M=
X-Google-Smtp-Source: ABdhPJx49Q41j8rkIdSXW71tA52j9UGdlFNEgF/xeODVi39kbf8ltkthI2NabfinVZySZsMJ0UdOsQ==
X-Received: by 2002:a5d:4584:: with SMTP id p4mr13181762wrq.383.1618397421724;
        Wed, 14 Apr 2021 03:50:21 -0700 (PDT)
Received: from [192.168.8.185] ([148.252.128.163])
        by smtp.gmail.com with ESMTPSA id f7sm4456804wmq.11.2021.04.14.03.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 03:50:21 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix early sqd_list removal sqpoll hangs
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org, Joakim Hassila <joj@mac.com>
References: <1592cc2b0418a0512c83898dbef0b1c9722e8645.1618310545.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <5df3c1f9-fbf5-ed78-00df-87850de67c71@gmail.com>
Date:   Wed, 14 Apr 2021 11:46:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1592cc2b0418a0512c83898dbef0b1c9722e8645.1618310545.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/04/2021 11:43, Pavel Begunkov wrote:
> [  245.463317] INFO: task iou-sqp-1374:1377 blocked for more than 122 seconds.
> [  245.463334] task:iou-sqp-1374    state:D flags:0x00004000
> [  245.463345] Call Trace:
> [  245.463352]  __schedule+0x36b/0x950
> [  245.463376]  schedule+0x68/0xe0
> [  245.463385]  __io_uring_cancel+0xfb/0x1a0
> [  245.463407]  do_exit+0xc0/0xb40
> [  245.463423]  io_sq_thread+0x49b/0x710
> [  245.463445]  ret_from_fork+0x22/0x30
> 
> It happens when sqpoll forgot to run park_task_work and goes to exit,
> then exiting user may remove ctx from sqd_list, and so corresponding
> io_sq_thread() -> io_uring_cancel_sqpoll() won't be executed. Hopefully
> it just stucks in do_exit() in this case.

fwiw, it's actually a 5.12 problem and I have a reliable enough
way to reproduce it.


> Cc: stable@vger.kernel.org
> Reported-by: Joakim Hassila <joj@mac.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index cadd7a65a7f4..f390914666b1 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6817,6 +6817,9 @@ static int io_sq_thread(void *data)
>  	current->flags |= PF_NO_SETAFFINITY;
>  
>  	mutex_lock(&sqd->lock);
> +	/* a user may had exited before the thread wstarted */
> +	io_run_task_work_head(&sqd->park_task_work);
> +
>  	while (!test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state)) {
>  		int ret;
>  		bool cap_entries, sqt_spin, needs_sched;
> @@ -6833,10 +6836,10 @@ static int io_sq_thread(void *data)
>  			}
>  			cond_resched();
>  			mutex_lock(&sqd->lock);
> -			if (did_sig)
> -				break;
>  			io_run_task_work();
>  			io_run_task_work_head(&sqd->park_task_work);
> +			if (did_sig)
> +				break;
>  			timeout = jiffies + sqd->sq_thread_idle;
>  			continue;
>  		}
> 

-- 
Pavel Begunkov
