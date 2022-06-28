Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A170755E416
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346036AbiF1NMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 09:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345865AbiF1NME (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 09:12:04 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091092C676
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 06:12:03 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id i64so11961626pfc.8
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 06:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=XoYbPu8ODNB+aCWUy44nZWPrpPoZ1GysfeORk/lUgLM=;
        b=XHLhZaEaqR9QT3n72jGC4B9CTYQLGgvSgK5FeBhATU//AaDLwb/uPmare7UUzHCmyF
         8ZxmzjQIv1VJYF3kxIJep8D0Wy/rX0Hfu83UHtsKjrWxH+xmjazgwoZPmqITisW1cvy9
         10gJwkCBPRYXhEK6qhlHZ9IbtS69KMgFFx8HOg9mjACyNRf/BheHQuwwsckrz3gdq9qY
         WL6HAvO2pym4fY1/bGmqCNe9LLscw6dtJsZUcVJz9dmRGm42zTVZBz429hn66jOMcMzY
         0cEFS13T5IEjTOkOwH/jOXyhEGOwVm0+m7UAOSsjV4QUZONQ1N6gWLTU7S12gm5E5lHC
         UbqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=XoYbPu8ODNB+aCWUy44nZWPrpPoZ1GysfeORk/lUgLM=;
        b=W25JTI++2O2E5luk6xymfZQQtf8Lj3mbWEK4PpMdmKmthkGXLXGTnCX5WuVWpMqL5x
         oTAObyDSXuJAKj7hIVTY/p2sOsloivCMMN3+iS/YirIs983kSYJNSlaqXuKH8z6rWqsZ
         gomipbWKQqS0niJffdBpaKZ0IH3FLMnf7havRU9S7QnaPW68uJbnjASDZmk4OHP8HXVf
         BsulJ6DAbt8Pnr6AiRpcdV2WtLpLcsTePVuKgGFrAd8MaXevg05ihyKSKKUbE3sUJxdZ
         lW8bsyHwD1SrqpnlDjBTT3MloUBYLO2mVH/G874dJPPVUOgmaeXLlX/Q7siIq13tlGlh
         V/hQ==
X-Gm-Message-State: AJIora+XbGSygaXuLJBHWYhUbafxc4IxSmRug+Vst4/LRyIa7dMXVY7T
        /ENkVMcBs1RmdG11LHHmSoaoTA==
X-Google-Smtp-Source: AGRyM1v+C2N+0M6g5SN7PpJOGUDCyzzebuVob89bSW99C05vbsm8/cBqbUwRKRC138wRQjE3ZfHSvQ==
X-Received: by 2002:a63:4d5:0:b0:40d:77fd:cff8 with SMTP id 204-20020a6304d5000000b0040d77fdcff8mr17449254pge.361.1656421922420;
        Tue, 28 Jun 2022 06:12:02 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902654900b0016357fd0fd1sm9354401pln.69.2022.06.28.06.12.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 06:12:02 -0700 (PDT)
Message-ID: <7dc3a545-8fa5-e540-7c64-00b61c4bef13@kernel.dk>
Date:   Tue, 28 Jun 2022 07:12:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH AUTOSEL 5.18 37/53] io_uring: fix merge error in checking
 send/recv addr2 flags
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        io-uring <io-uring@vger.kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
 <20220628021839.594423-37-sashal@kernel.org>
Content-Language: en-US
In-Reply-To: <20220628021839.594423-37-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 8:20 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Jens Axboe <axboe@kernel.dk>
>
> [ Upstream commit b60cac14bb3c88cff2a7088d9095b01a80938c41 ]
>
> With the dropping of the IOPOLL checking in the per-opcode handlers,
> we inadvertently left two checks in the recv/recvmsg and send/sendmsg
> prep handlers for the same thing, and one of them includes addr2 which
> holds the flags for these opcodes.
>
> Fix it up and kill the redundant checks.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/io_uring.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 725c59c734f1..9eb20f8865ac 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5252,8 +5252,6 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>
>         if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>                 return -EINVAL;
> -       if (unlikely(sqe->addr2 || sqe->file_index))
> -               return -EINVAL;
>
>         sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
>         sr->len = READ_ONCE(sqe->len);
> @@ -5465,8 +5463,6 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>
>         if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>                 return -EINVAL;
> -       if (unlikely(sqe->addr2 || sqe->file_index))
> -               return -EINVAL;
>
>         sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
>         sr->len = READ_ONCE(sqe->len);

This doesn't look right, and cannot be as the problem was added with a
5.19 merge issue. Please drop this patch from 5.18-stable, thanks.

-- 
Jens Axboe

