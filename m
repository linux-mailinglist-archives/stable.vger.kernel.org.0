Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B282E9A85
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbhADQKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728650AbhADQKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 11:10:50 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFD6C061574;
        Mon,  4 Jan 2021 08:10:10 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id v14so18940085wml.1;
        Mon, 04 Jan 2021 08:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XOhzcSd5DMVVTm4CdxSNXR0PEHTt4MMP6CDXjCJGwgo=;
        b=V0Qe5XNsDUL2b55pr7WGb++qC5Rj2qgPOmPpc77u2fRGs56JoWN4EU2xg7gzgG2+LW
         Ny7jMa0jt7uwyivwnfVIBeivTWF4o9J1b/k1Y1paJA2NCy7204BrWePrL/mI6/h/3zbl
         lL7FIXicR2T5AU+nc2a2CmCpVITq3YwCgIzvccm71HdRqOOHZiIGfVr+jK2dPsYeYhDm
         gBAbXR80S9IlgL3gM2LPX3l8Z1VGQsQio155N7R1n5GwNA1ey4ObUiF/a1MSIkluRPzi
         4KYFrrE9z6/ferwLvbNKwPZEKWqV2C7gd3aKl0E3vlCmdcsFNibJK4Bpn8pCmrMDLPF1
         DDkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XOhzcSd5DMVVTm4CdxSNXR0PEHTt4MMP6CDXjCJGwgo=;
        b=r1EtwP60xc0hLecX86pL7PnTFvbJC6ATjIokLAOoYD02KJ69vZMZrCu3l4EI2X4TcU
         mwXVumXI9utoedENHnRWuFTjFpNU9WcqDFVCz+S4sdebe4QdHxQSbNLobHTyrA2yDjIK
         qhpCzPsbEqRuyU7ihlLOhDR27gd5rw6UoVnGD7abEj6JWT1A3CxwAottd1UQgXcZz8kQ
         R9/m1x89LA0moTMfMoEmqXbTx8Jso0ASKb7AocgLwbGTmkDX2ThLFrJxZW5xQD0qvtHf
         2SOHGakId9J1b5jBnpvoMIA78CiVYaaEC+Ab12/dakQqYXz9yA9BK+eYmKCJEuBDddlp
         TVlg==
X-Gm-Message-State: AOAM531KQYrLgKIPBUww1y1qKwJkXuBu3qoVXqYDnJtkb/rsRYE5rAHF
        6hfR08naE363auZpdWrKGLg=
X-Google-Smtp-Source: ABdhPJwdDAREhvXRMBhZP25AhN4f445+u5q3aXFp+LSZEQYYYCl0M7UAYiKKRa/ltoHf5KmI94Xz9g==
X-Received: by 2002:a1c:6484:: with SMTP id y126mr27322035wmb.76.1609776609041;
        Mon, 04 Jan 2021 08:10:09 -0800 (PST)
Received: from [192.168.8.189] ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id o13sm72131739wrh.88.2021.01.04.08.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 08:10:08 -0800 (PST)
Subject: Re: [PATCH 5.10 21/63] kernel/io_uring: cancel io_uring before task
 works
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <20210104155708.800470590@linuxfoundation.org>
 <20210104155709.846535201@linuxfoundation.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <2e03dac2-a91c-ede1-0109-a4d4297e3efd@gmail.com>
Date:   Mon, 4 Jan 2021 16:06:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210104155709.846535201@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/01/2021 15:57, Greg Kroah-Hartman wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> commit b1b6b5a30dce872f500dc43f067cba8e7f86fc7d upstream.
> 
> For cancelling io_uring requests it needs either to be able to run
> currently enqueued task_works or having it shut down by that moment.
> Otherwise io_uring_cancel_files() may be waiting for requests that won't
> ever complete.

Greg, can you drop it from stable for now? I'll backport it later when
related problems are sorted.

> 
> Go with the first way and do cancellations before setting PF_EXITING and
> so before putting the task_work infrastructure into a transition state
> where task_work_run() would better not be called.
> 
> Cc: stable@vger.kernel.org # 5.5+
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  fs/file.c     |    2 --
>  kernel/exit.c |    2 ++
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -21,7 +21,6 @@
>  #include <linux/rcupdate.h>
>  #include <linux/close_range.h>
>  #include <net/sock.h>
> -#include <linux/io_uring.h>
>  
>  unsigned int sysctl_nr_open __read_mostly = 1024*1024;
>  unsigned int sysctl_nr_open_min = BITS_PER_LONG;
> @@ -453,7 +452,6 @@ void exit_files(struct task_struct *tsk)
>  	struct files_struct * files = tsk->files;
>  
>  	if (files) {
> -		io_uring_files_cancel(files);
>  		task_lock(tsk);
>  		tsk->files = NULL;
>  		task_unlock(tsk);
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -63,6 +63,7 @@
>  #include <linux/random.h>
>  #include <linux/rcuwait.h>
>  #include <linux/compat.h>
> +#include <linux/io_uring.h>
>  
>  #include <linux/uaccess.h>
>  #include <asm/unistd.h>
> @@ -762,6 +763,7 @@ void __noreturn do_exit(long code)
>  		schedule();
>  	}
>  
> +	io_uring_files_cancel(tsk->files);
>  	exit_signals(tsk);  /* sets PF_EXITING */
>  
>  	/* sync mm's RSS info before statistics gathering */
> 
> 

-- 
Pavel Begunkov
