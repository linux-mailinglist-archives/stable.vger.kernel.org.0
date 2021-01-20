Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612972FE01D
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 04:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbhAUDoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 22:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404451AbhATXy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 18:54:57 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F213DC0613D3;
        Wed, 20 Jan 2021 15:54:14 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id 6so60926wri.3;
        Wed, 20 Jan 2021 15:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eKZIfNtKnKJpdNT8iivx2NSa9qVmvjjOpdScE6fVStY=;
        b=AeTUFRBPkELPRHa9vDedTKhX9CSkMau9PkmNp1/AKCLk8box0kDzHfPGUytRVzfWX9
         gTiNQkJwZvSHiBRNiXZxX0m61mWKaYM92Is4vzmTgtA5A5PkxrM3jl2LLUXzevG0AXNX
         FrgvTH5LLZ7w2YJZVqvJHd3bBCq1T+GGZs8DlYAPhGpHbEQEp2IUXonJ55pfVrUUFr5J
         vUMVMGoCkbua/oNhtg2yUPP3sxNvJKYaOkzh3f7LBNJnjM43/0lnRg4eUzcO/lPkPJ7O
         e/EJ0Z53faCd/mqLHZvrsmlUMSFrWB2ZPQ7kw1bZIHx97g83MVvKbzoludY+QROF6tPt
         yofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eKZIfNtKnKJpdNT8iivx2NSa9qVmvjjOpdScE6fVStY=;
        b=P72Jpt3LLkT7JDYM7TKQrC6yIRzOv7qykJYVxKDoxGUM3qwpD4zcyZzv0zso3n4TOx
         Z2Y5kqT51Er3045AvZZ3jAWk2hEy9L8fGZ/qXhDup9KTvijKoSuO3hJMISrLj/z4E0+S
         G3sC2uWADxUD6KJT7dMQgdwTwgWesapqs77iBcimtEefUSFIXhR/UUF10FGe4ltvF2y+
         QRKnl4OHWePl9N59CyBTyRfLbKOg0Gi/jJ9Proh0hMnbai/5oNNd6BU9surl4rYxuhHH
         rUM1CSeOTjpCCdRojgyVXrgNuN86bHvUDiM/MQPsp1aUqG+Uk2cE+usjvDUKJVblPa/E
         lGLg==
X-Gm-Message-State: AOAM5323lG7T/2dH2E2GiCOz7pd9dXmUcos15lTVI0StbaykSWU2sf3j
        cOl48wSYoPerWYaVcQEsh9+IvgoODqw=
X-Google-Smtp-Source: ABdhPJxK2XsriQzvnfsMWKSE7tetTN+plcI9NT3n4ppTka7pztVb225dbueml5oNnULcn8RlFgX/dw==
X-Received: by 2002:adf:9526:: with SMTP id 35mr4996051wrs.399.1611186853436;
        Wed, 20 Jan 2021 15:54:13 -0800 (PST)
Received: from [192.168.8.143] ([148.252.129.228])
        by smtp.gmail.com with ESMTPSA id d30sm7470507wrc.92.2021.01.20.15.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 15:54:12 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: fix short read retries for non-reg files
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <096d4c7e2615704c08786fe793e91ad8b22cb9f9.1611184076.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <93cb73a4-7dee-eaa1-58bb-0ec6fffa0f9e@gmail.com>
Date:   Wed, 20 Jan 2021 23:50:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <096d4c7e2615704c08786fe793e91ad8b22cb9f9.1611184076.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/01/2021 23:09, Pavel Begunkov wrote:
> Sockets and other non-regular files may actually expect short reads to
> happen, don't retry reads for them.

Works well with a quick test, but I think I may have missed a case,
please don't take it yet

> 
> Cc: stable@vger.kernel.org # 5.9+
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5f6f1e48954e..544d711b2ef0 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3557,6 +3557,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>  
>  	io_size -= ret;
>  copy_iov:
> +	if (!(req->flags & REQ_F_ISREG) && ret > 0)
> +		goto done;
> +
>  	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
>  	if (ret2) {
>  		ret = ret2;
> 

-- 
Pavel Begunkov
