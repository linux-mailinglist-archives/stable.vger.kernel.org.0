Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A906BE149
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 07:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjCQGdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 02:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCQGdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 02:33:00 -0400
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA6728D1D;
        Thu, 16 Mar 2023 23:32:58 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id az3-20020a05600c600300b003ed2920d585so4472411wmb.2;
        Thu, 16 Mar 2023 23:32:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679034777;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o8QYF+ZxY6zKiENpvWSu3rcbxJoaEBwd9eRUaok3CRo=;
        b=qkOaLMEu6nJKCHWmpLnXGtszAhoDwc0XMbCcJkoMvaN+VAnbGWivzCo3YcyRuoqFnx
         otYckFtB/OGz//q1MeRPNdLNbZyCczA/Ce6EmwAFbFjImxjZyyV2+FMY98vapS66jOPE
         g0YETuXEqxGEalZwL6rOqSkPCpi747LnAfeeiyjXR/n9g5EJHWKWNow5PsEqIoPqi1yT
         0Jpc8C13sgyaVPu+v3RL2IUbq7JGxah5nTxfB1MiachS1Cg5bRuL8xVLbCk3gVIlJuqd
         KY+qJ+tRyLFtnQjNqMWzFGXXYOX+g/4gC9ORZZovu/5dWS3ZWOhEjgXBN3LyGCtHvTjW
         QnIQ==
X-Gm-Message-State: AO0yUKWL2FZiE61o02daso79NLLENsGXXZc/CdLHj1Ie+k6m4hpq1zBi
        7Flw/wsEbTQUcZmuR43qTchddMlkoOA=
X-Google-Smtp-Source: AK7set/rrD/4P5dr3MBAQuUKOwvhkZ+QY7VK7VqAsoBq8ujWpApvZSg1ZQx8loekeE/PtRGJDGHcvA==
X-Received: by 2002:a05:600c:19c9:b0:3ed:31fa:f563 with SMTP id u9-20020a05600c19c900b003ed31faf563mr7851826wmq.20.1679034777125;
        Thu, 16 Mar 2023 23:32:57 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id f26-20020a7bc8da000000b003ed2d7f9135sm1002599wml.45.2023.03.16.23.32.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 23:32:56 -0700 (PDT)
Message-ID: <35358148-3d46-40e5-aa1e-84e7fb6dbb6f@kernel.org>
Date:   Fri, 17 Mar 2023 07:32:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     juanfengpy@gmail.com, gregkh@linuxfoundation.org
Cc:     ilpo.jarvinen@linux.intel.com, benbjiang@tencent.com,
        robinlai@tencent.com, linux-serial@vger.kernel.org,
        Hui Li <caelli@tencent.com>, stable@vger.kernel.org
References: <YrmdEJrM3z6Dbvgn@kroah.com>
 <1679020915-8349-1-git-send-email-caelli@tencent.com>
From:   Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH v7] tty: fix hang on tty device with no_room set
In-Reply-To: <1679020915-8349-1-git-send-email-caelli@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17. 03. 23, 3:41, juanfengpy@gmail.com wrote:
> From: Hui Li <caelli@tencent.com>
> 
> We have met a hang on pty device, the reader was blocking
> at epoll on master side, the writer was sleeping at wait_woken
> inside n_tty_write on slave side, and the write buffer on
> tty_port was full, we found that the reader and writer would
> never be woken again and blocked forever.
> 
> The problem was caused by a race between reader and kworker:
> n_tty_read(reader):  n_tty_receive_buf_common(kworker):
> copy_from_read_buf()|
>                      |room = N_TTY_BUF_SIZE - (ldata->read_head - tail)
>                      |room <= 0
> n_tty_kick_worker() |
>                      |ldata->no_room = true
> 
> After writing to slave device, writer wakes up kworker to flush
> data on tty_port to reader, and the kworker finds that reader
> has no room to store data so room <= 0 is met. At this moment,
> reader consumes all the data on reader buffer and calls
> n_tty_kick_worker to check ldata->no_room which is false and
> reader quits reading. Then kworker sets ldata->no_room=true
> and quits too.
...
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
...
> @@ -1729,6 +1729,27 @@ n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
>   	} else
>   		n_tty_check_throttle(tty);
>   
> +	if (unlikely(ldata->no_room)) {
> +		/*
> +		 * Barrier here is to ensure to read the latest read_tail in
> +		 * chars_in_buffer() and to make sure that read_tail is not loaded
> +		 * before ldata->no_room is set,


I am not sure I would keep the following part of the comment in the code:

 > otherwise, following race may occur:
> +		 * n_tty_receive_buf_common()
> +		 *				n_tty_read()
> +		 *   if (!chars_in_buffer(tty))->false
> +		 *				  copy_from_read_buf()
> +		 *				    read_tail=commit_head
> +		 *				  n_tty_kick_worker()
> +		 *				    if (ldata->no_room)->false
> +		 *   ldata->no_room = 1
> +		 * Then both kworker and reader will fail to kick n_tty_kick_worker(),
> +		 * smp_mb is paired with smp_mb() in n_tty_read().

I would only let it ^^^ documented in the commit log as you did.

> +		 */
> +		smp_mb();
> +		if (!chars_in_buffer(tty))
> +			n_tty_kick_worker(tty);
> +	}
> +
>   	up_read(&tty->termios_rwsem);
>   
>   	return rcvd;
> @@ -2282,8 +2303,25 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
>   		if (time)
>   			timeout = time;
>   	}
> -	if (old_tail != ldata->read_tail)
> +	if (old_tail != ldata->read_tail) {
> +		/*
> +		 * Make sure no_room is not read in n_tty_kick_worker()
> +		 * before setting ldata->read_tail in copy_from_read_buf(),

The same here (it's only repeated). I think the above two lines are 
enough for the comment. We have git blame after all.

> +		 * otherwise, following race may occur:
> +		 * n_tty_read()
> +		 *			n_tty_receive_buf_common()
> +		 *   n_tty_kick_worker()
> +		 *     if(ldata->no_room)->false
> +		 *			  ldata->no_room = 1
> +		 *			  if (!chars_in_buffer(tty))->false
> +		 *   copy_from_read_buf()
> +		 *     read_tail=commit_head
> +		 * Both reader and kworker will fail to kick tty_buffer_restart_work(),
> +		 * smp_mb is paired with smp_mb() in n_tty_receive_buf_common().
> +		 */
> +		smp_mb();
>   		n_tty_kick_worker(tty);
> +	}
>   	up_read(&tty->termios_rwsem);
>   
>   	remove_wait_queue(&tty->read_wait, &wait);

-- 
js

