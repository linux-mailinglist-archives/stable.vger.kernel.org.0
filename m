Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A3B6AB802
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 09:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCFILx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 03:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCFILx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 03:11:53 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A0CAD18;
        Mon,  6 Mar 2023 00:11:51 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id bn17so4972018pgb.10;
        Mon, 06 Mar 2023 00:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678090310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qp1gun1BLOT9XnkM22r0ylB6HbLuHvziOHShU4JCZiI=;
        b=fOfqDdJ9QLzyJMMXV0jxGLG8CPsKKTmz4HUgvY+E8fI0wotkwxnS3/3mX1kROASB5L
         1xNFdLFVSA4PlVui6IJjrU0JlY4HL+prbiFw8DpgJI/zEKFAFKT4KS4/72KMNaBkl2DB
         TrwQ3hkOqrUg1fzDNb970ZgwEvKLAHNT9w+AAjMCH1NyoWdLPW2AEq0SaFIZDKzQnU9R
         skFRIMxFxSaecDgulm0frpPe21wXQ1v6Fjghmzwp70/enlOarYGRPQEkd9OfIbccAkk7
         RAgW66ARDVAbBw1MZTU89Yl7bKRcNymlRqbumb/Kf4H901pGaF1pUiCukXJhPymgPk48
         X5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678090310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qp1gun1BLOT9XnkM22r0ylB6HbLuHvziOHShU4JCZiI=;
        b=2sj7Ueo56+LujQcILyYQd3FlMQTEYlGF8rknqta5cqYSZe7CFUGYp9w9f7qOmOdbvK
         lWBBHLj/Ox5XNGgcxgCj8nVS9yxk/CX0/n1ayTSWiJ3R0nQhoCmrzbVwNLhscoX3BIqq
         sbj5tUhc588n1W5AfFy2BtpQGHN3kkVTXcqYSdnU2HZ6iYEkbFqqSa4tX6MvhyUFQU6x
         3hWZavYEXW79hsAjRHOG1SUiccGATsmGUceYsu0U379T+obArNH1H++IKmIhz/UCA9Qs
         nDPqkRZAicOJ0zoyLse3fmGYtdj9msjojlnVuq+wcGrwcliyGyQkm0Y6tFVNjL8IQ+bE
         alEQ==
X-Gm-Message-State: AO0yUKWQgeip5ormXYONb5JjOivRFvjD6OzqdLZQHB5+UX+v1bpkXQQR
        D9WinFz1QpIyRilRDPDRMnNNJb84ILE=
X-Google-Smtp-Source: AK7set/LFfMaDVI9c/CcJesoRQEmXetMxIz7x1oo+Oe1MxbjGixZgj6gUzdRsFXwFdkE1H2Z1VUX4A==
X-Received: by 2002:aa7:9426:0:b0:60e:950c:7a55 with SMTP id y6-20020aa79426000000b0060e950c7a55mr8032387pfo.9.1678090310580;
        Mon, 06 Mar 2023 00:11:50 -0800 (PST)
Received: from localhost ([156.236.96.165])
        by smtp.gmail.com with ESMTPSA id 9-20020aa79109000000b0060c55143fdesm5706038pfh.68.2023.03.06.00.11.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 Mar 2023 00:11:50 -0800 (PST)
Date:   Mon, 6 Mar 2023 16:18:08 +0800
From:   Yue Hu <zbestahu@gmail.com>
To:     Gao Xiang <hsiangkao@linux.alibaba.com>
Cc:     linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, huyue2@coolpad.com
Subject: Re: [PATCH] erofs: fix wrong kunmap when using LZMA on HIGHMEM
 platforms
Message-ID: <20230306161808.000046c0.zbestahu@gmail.com>
In-Reply-To: <20230305134455.88236-1-hsiangkao@linux.alibaba.com>
References: <20230305134455.88236-1-hsiangkao@linux.alibaba.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun,  5 Mar 2023 21:44:55 +0800
Gao Xiang <hsiangkao@linux.alibaba.com> wrote:

> As the call trace shown, the root cause is kunmap incorrect pages:
> 
>  BUG: kernel NULL pointer dereference, address: 00000000
>  CPU: 1 PID: 40 Comm: kworker/u5:0 Not tainted 6.2.0-rc5 #4
>  Workqueue: erofs_worker z_erofs_decompressqueue_work
>  EIP: z_erofs_lzma_decompress+0x34b/0x8ac
>   z_erofs_decompress+0x12/0x14
>   z_erofs_decompress_queue+0x7e7/0xb1c
>   z_erofs_decompressqueue_work+0x32/0x60
>   process_one_work+0x24b/0x4d8
>   ? process_one_work+0x1a4/0x4d8
>   worker_thread+0x14c/0x3fc
>   kthread+0xe6/0x10c
>   ? rescuer_thread+0x358/0x358
>   ? kthread_complete_and_exit+0x18/0x18
>   ret_from_fork+0x1c/0x28
>  ---[ end trace 0000000000000000 ]---
> 
> The bug is trivial and should be fixed now.  It has no impact on
> !HIGHMEM platforms.
> 
> Fixes: 622ceaddb764 ("erofs: lzma compression support")
> Cc: <stable@vger.kernel.org> # 5.16+
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Yue Hu <huyue2@coolpad.com>

> ---
>  fs/erofs/decompressor_lzma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
> index 091fd5adf818..5cd612a8f858 100644
> --- a/fs/erofs/decompressor_lzma.c
> +++ b/fs/erofs/decompressor_lzma.c
> @@ -278,7 +278,7 @@ int z_erofs_lzma_decompress(struct z_erofs_decompress_req *rq,
>  		}
>  	}
>  	if (no < nrpages_out && strm->buf.out)
> -		kunmap(rq->in[no]);
> +		kunmap(rq->out[no]);
>  	if (ni < nrpages_in)
>  		kunmap(rq->in[ni]);
>  	/* 4. push back LZMA stream context to the global list */

