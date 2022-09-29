Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6055EF5C6
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 14:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiI2My6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 08:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbiI2My5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 08:54:57 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79CD50185;
        Thu, 29 Sep 2022 05:54:54 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id u10so1941821wrq.2;
        Thu, 29 Sep 2022 05:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=qzPvBQ6RJ5HhPEoJU168pvBJD/VGTaEj9IR0bVPoXkw=;
        b=o+uENSjPt9B10AN7xS71tCSWQZjyvWh1T2piBIUSqFPGkT54uMJFLaGF7npcZ2UjGd
         ux2dsv+LUFLmLlqd9fUia3RpkWkpodu3ENN6gsH8g2DwZSb1sEe4XTAQhqOF6P6RPLC/
         PAP9LRSqDIWx/smDOFDlp/M13mmdG5wtw85eFhpaYvV0tkYtfSNnnWgjHp/PTbFs5Wl8
         gqUgLwarMHSfqlo8ycVPuwQLeN73etXKZmPyGgFbbd4g1IgW6FZaiZZRhSYlhYCtNYYu
         E/aq6obW7Hs+3UwpcVTPcBbeJJnMqJfAm2ukCwOJOd40rwFLKzYH4SRmSOM2B3ts3VzR
         nRMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=qzPvBQ6RJ5HhPEoJU168pvBJD/VGTaEj9IR0bVPoXkw=;
        b=EE75S9G+VJbRwvxD9vai+W2guUda98MSOhX+BH2bLyr/8KKjTfm9U7J6BONFHArqJ1
         gSHAC5L4FU0gCN3RdNwrVRmBbxYTNv5Rvy2u25huONKmq357a4KGMlQ0Vw8NndrlsZ/S
         51AWNmzSivOirzQNvr4bzF4EI7r78c8VV1Devwc3QcETq9Gk1vQhLa1QXpkOxM+x5VGm
         vhmMI6qshRTh/hv+VVr8mjBqG99vie7QHMCp5oWmMM5WAUMwkLj+cE7NBKMq2suG00pi
         peJkgtQ6A6irEypyqRXRFMFhzVa2EQWej+vvCAPFUIuvYsQ77RB2fzqWI00PQnHydQs+
         IVgg==
X-Gm-Message-State: ACrzQf3MSAtOGW0uN3S9OAbKU044JeY0mvoCuXC+sYrPQOVrnYLmLrFG
        xvuBdn76mRKilLjBbbNDyJ5Df3tJlk8=
X-Google-Smtp-Source: AMsMyM6aJrBn5YUdIfNrVXxC/hSIUUTDrU2+FuEaVIlNYItGq1guA5oflRElF/gloZXGfFe9U3siuw==
X-Received: by 2002:a05:6000:78b:b0:22a:da96:8ae6 with SMTP id bu11-20020a056000078b00b0022ada968ae6mr2152178wrb.232.1664456092754;
        Thu, 29 Sep 2022 05:54:52 -0700 (PDT)
Received: from [192.168.8.100] (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id i6-20020adfefc6000000b0022ccbc7efb5sm2894628wrp.73.2022.09.29.05.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 05:54:52 -0700 (PDT)
Message-ID: <4a64cd7d-ddaf-d5ab-3ae1-fab677299643@gmail.com>
Date:   Thu, 29 Sep 2022 13:53:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/1] io_uring/net: fix fast_iov assignment in
 io_setup_async_msg()
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        axboe@kernel.dk
Cc:     stable@vger.kernel.org
References: <cover.1664436949.git.metze@samba.org>
 <b2e7be246e2fb173520862b0c7098e55767567a2.1664436949.git.metze@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b2e7be246e2fb173520862b0c7098e55767567a2.1664436949.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/29/22 08:39, Stefan Metzmacher wrote:
> I hit a very bad problem during my tests of SENDMSG_ZC.
> BUG(); in first_iovec_segment() triggered very easily.
> The problem was io_setup_async_msg() in the partial retry case,
> which seems to happen more often with _ZC.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

And tested with liburing patches I sent yesterday


> iov_iter_iovec_advance() may change i->iov in order to have i->iov_offset
> being only relative to the first element.
> 
> Which means kmsg->msg.msg_iter.iov is no longer the
> same as kmsg->fast_iov.
> 
> But this would rewind the copy to be the start of
> async_msg->fast_iov, which means the internal
> state of sync_msg->msg.msg_iter is inconsitent.
> 
> I tested with 5 vectors with length like this 4, 0, 64, 20, 8388608
> and got a short writes with:
> - ret=2675244 min_ret=8388692 => remaining 5713448 sr->done_io=2675244
> - ret=-EAGAIN => io_uring_poll_arm
> - ret=4911225 min_ret=5713448 => remaining 802223  sr->done_io=7586469
> - ret=-EAGAIN => io_uring_poll_arm
> - ret=802223  min_ret=802223  => res=8388692
> 
> While this was easily triggered with SENDMSG_ZC (queued for 6.1),
> it was a potential problem starting with 7ba89d2af17aa879dda30f5d5d3f152e587fc551
> in 5.18 for IORING_OP_RECVMSG.
> And also with 4c3c09439c08b03d9503df0ca4c7619c5842892e in 5.19
> for IORING_OP_SENDMSG.
> 
> However 257e84a5377fbbc336ff563833a8712619acce56 introduced the critical
> code into io_setup_async_msg() in 5.11.
> 
> Fixes: 7ba89d2af17aa ("io_uring: ensure recv and recvmsg handle MSG_WAITALL correctly")
> Fixes: 257e84a5377fb ("io_uring: refactor sendmsg/recvmsg iov managing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>   io_uring/net.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 60e392f7f2dc..a81fccd38ae4 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -165,8 +165,10 @@ static int io_setup_async_msg(struct io_kiocb *req,
>   	memcpy(async_msg, kmsg, sizeof(*kmsg));
>   	async_msg->msg.msg_name = &async_msg->addr;
>   	/* if were using fast_iov, set it to the new one */
> -	if (!async_msg->free_iov)
> -		async_msg->msg.msg_iter.iov = async_msg->fast_iov;
> +	if (!kmsg->free_iov) {
> +		size_t fast_idx = kmsg->msg.msg_iter.iov - kmsg->fast_iov;
> +		async_msg->msg.msg_iter.iov = &async_msg->fast_iov[fast_idx];
> +	}
>   
>   	return -EAGAIN;
>   }

-- 
Pavel Begunkov
