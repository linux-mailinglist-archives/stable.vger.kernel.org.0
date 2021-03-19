Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666AD3419EB
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 11:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhCSK1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 06:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCSK1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 06:27:16 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E22AC06175F;
        Fri, 19 Mar 2021 03:27:15 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id o16so8566537wrn.0;
        Fri, 19 Mar 2021 03:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RKvCCP7b7ER0NUXe1RRHnxer5y+U2u99YKoYqcyxuSM=;
        b=duoEC5rnnk8x8amM9xHi25kUCLE/cP4Yl+Tt4KGPf399VJx3MCX53JS4PhfpgXQu5W
         WKBPFwGheSPoutn4tVDfE1sMOowe27WUS+LnaprCNmle+R+1nArLtpQIfPqTMjwLNJ7i
         PBCt0H1CUwAZ4rSJKf/B0ghfk8/kghnnmaRpYr72Ylg7tsGcHGS+ybyLYJS9OdLtXXQc
         izZiauyzYmBg9MbSi5hBZ4eTfGmndiMzlvkWZknoovay+TzRygFKvMjx3Dg33srnopIt
         vDif7ojbn4vtOQlOV3riEfoIEgI2aPGrt0OJ7BNU67czmiw/WKd6a6DFU+f1bTK9hiG9
         jOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RKvCCP7b7ER0NUXe1RRHnxer5y+U2u99YKoYqcyxuSM=;
        b=sfV6ORSTRO3o7rtjC0pD4ARz/kMRexSYdM5ihEd6LrWOg55De6dFg5GqhZBVPqhEBa
         9kqRGeMix5sorqztmgaQIgJmqWZ/zSx7BzUM97As8hUs0p5iUrtJtjbhW7blbnZPNiaS
         IHFhXXnta4vBDQuXWw+DspTBoUHxyNdW67bRbQDnKaTxwgou0iMBH9OiGni7lOahtLX0
         kWEvtujpXF6rMO7tujX5VtDvTN0q2Ea8e4roHxiQTsxEzHFWStHY21MndsOS5Xx5mFI5
         YaTxS4Kt1nZ4LOZpbgwtv18onF0iKwO6RFUkX5+rKMw+l8PJsLKJPtu8I01baw2Wbg8d
         w7kA==
X-Gm-Message-State: AOAM5332By/3EdlwoqoOeTcqU4K+1KTvA13AO13XHGof6w6SxTIqKmQw
        Vh3RENeKE1B+nU6DRpFX+GWERFIrTKc=
X-Google-Smtp-Source: ABdhPJxBxnWhK/T/YC1ixyvyPgdoExS8e4Gqg5NaGr0r92YyaBUe1Uv7e4pendK2J5FBpTk9jYx7hw==
X-Received: by 2002:adf:fa8d:: with SMTP id h13mr3728375wrr.331.1616149634125;
        Fri, 19 Mar 2021 03:27:14 -0700 (PDT)
Received: from [192.168.8.173] ([185.69.144.156])
        by smtp.gmail.com with ESMTPSA id o7sm7194914wrs.16.2021.03.19.03.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 03:27:13 -0700 (PDT)
Subject: Re: [PATCH] io_uring: Try to merge io requests only for regular files
To:     Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>,
        linux-kernel@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        axboe@kernel.dk, io-uring <io-uring@vger.kernel.org>
References: <20210319052859.3220-1-dmtrmonakhov@yandex-team.ru>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 mQINBFmKBOQBEAC76ZFxLAKpDw0bKQ8CEiYJRGn8MHTUhURL02/7n1t0HkKQx2K1fCXClbps
 bdwSHrhOWdW61pmfMbDYbTj6ZvGRvhoLWfGkzujB2wjNcbNTXIoOzJEGISHaPf6E2IQx1ik9
 6uqVkK1OMb7qRvKH0i7HYP4WJzYbEWVyLiAxUj611mC9tgd73oqZ2pLYzGTqF2j6a/obaqha
 +hXuWTvpDQXqcOZJXIW43atprH03G1tQs7VwR21Q1eq6Yvy2ESLdc38EqCszBfQRMmKy+cfp
 W3U9Mb1w0L680pXrONcnlDBCN7/sghGeMHjGKfNANjPc+0hzz3rApPxpoE7HC1uRiwC4et83
 CKnncH1l7zgeBT9Oa3qEiBlaa1ZCBqrA4dY+z5fWJYjMpwI1SNp37RtF8fKXbKQg+JuUjAa9
 Y6oXeyEvDHMyJYMcinl6xCqCBAXPHnHmawkMMgjr3BBRzODmMr+CPVvnYe7BFYfoajzqzq+h
 EyXSl3aBf0IDPTqSUrhbmjj5OEOYgRW5p+mdYtY1cXeK8copmd+fd/eTkghok5li58AojCba
 jRjp7zVOLOjDlpxxiKhuFmpV4yWNh5JJaTbwCRSd04sCcDNlJj+TehTr+o1QiORzc2t+N5iJ
 NbILft19Izdn8U39T5oWiynqa1qCLgbuFtnYx1HlUq/HvAm+kwARAQABtDFQYXZlbCBCZWd1
 bmtvdiAoc2lsZW5jZSkgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+iQJOBBMBCAA4FiEE+6Ju
 PTjTbx479o3OWt5b1Glr+6UFAlmKBOQCGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ
 Wt5b1Glr+6WxZA//QueaKHzgdnOikJ7NA/Vq8FmhRlwgtP0+E+w93kL+ZGLzS/cUCIjn2f4Q
 Mcutj2Neg0CcYPX3b2nJiKr5Vn0rjJ/suiaOa1h1KzyNTOmxnsqE5fmxOf6C6x+NKE18I5Jy
 xzLQoktbdDVA7JfB1itt6iWSNoOTVcvFyvfe5ggy6FSCcP+m1RlR58XxVLH+qlAvxxOeEr/e
 aQfUzrs7gqdSd9zQGEZo0jtuBiB7k98t9y0oC9Jz0PJdvaj1NZUgtXG9pEtww3LdeXP/TkFl
 HBSxVflzeoFaj4UAuy8+uve7ya/ECNCc8kk0VYaEjoVrzJcYdKP583iRhOLlZA6HEmn/+Gh9
 4orG67HNiJlbFiW3whxGizWsrtFNLsSP1YrEReYk9j1SoUHHzsu+ZtNfKuHIhK0sU07G1OPN
 2rDLlzUWR9Jc22INAkhVHOogOcc5ajMGhgWcBJMLCoi219HlX69LIDu3Y34uIg9QPZIC2jwr
 24W0kxmK6avJr7+n4o8m6sOJvhlumSp5TSNhRiKvAHB1I2JB8Q1yZCIPzx+w1ALxuoWiCdwV
 M/azguU42R17IuBzK0S3hPjXpEi2sK/k4pEPnHVUv9Cu09HCNnd6BRfFGjo8M9kZvw360gC1
 reeMdqGjwQ68o9x0R7NBRrtUOh48TDLXCANAg97wjPoy37dQE7e5Ag0EWYoE5AEQAMWS+aBV
 IJtCjwtfCOV98NamFpDEjBMrCAfLm7wZlmXy5I6o7nzzCxEw06P2rhzp1hIqkaab1kHySU7g
 dkpjmQ7Jjlrf6KdMP87mC/Hx4+zgVCkTQCKkIxNE76Ff3O9uTvkWCspSh9J0qPYyCaVta2D1
 Sq5HZ8WFcap71iVO1f2/FEHKJNz/YTSOS/W7dxJdXl2eoj3gYX2UZNfoaVv8OXKaWslZlgqN
 jSg9wsTv1K73AnQKt4fFhscN9YFxhtgD/SQuOldE5Ws4UlJoaFX/yCoJL3ky2kC0WFngzwRF
 Yo6u/KON/o28yyP+alYRMBrN0Dm60FuVSIFafSqXoJTIjSZ6olbEoT0u17Rag8BxnxryMrgR
 dkccq272MaSS0eOC9K2rtvxzddohRFPcy/8bkX+t2iukTDz75KSTKO+chce62Xxdg62dpkZX
 xK+HeDCZ7gRNZvAbDETr6XI63hPKi891GeZqvqQVYR8e+V2725w+H1iv3THiB1tx4L2bXZDI
 DtMKQ5D2RvCHNdPNcZeldEoJwKoA60yg6tuUquvsLvfCwtrmVI2rL2djYxRfGNmFMrUDN1Xq
 F3xozA91q3iZd9OYi9G+M/OA01husBdcIzj1hu0aL+MGg4Gqk6XwjoSxVd4YT41kTU7Kk+/I
 5/Nf+i88ULt6HanBYcY/+Daeo/XFABEBAAGJAjYEGAEIACAWIQT7om49ONNvHjv2jc5a3lvU
 aWv7pQUCWYoE5AIbDAAKCRBa3lvUaWv7pfmcEACKTRQ28b1y5ztKuLdLr79+T+LwZKHjX++P
 4wKjEOECCcB6KCv3hP+J2GCXDOPZvdg/ZYZafqP68Yy8AZqkfa4qPYHmIdpODtRzZSL48kM8
 LRzV8Rl7J3ItvzdBRxf4T/Zseu5U6ELiQdCUkPGsJcPIJkgPjO2ROG/ZtYa9DvnShNWPlp+R
 uPwPccEQPWO/NP4fJl2zwC6byjljZhW5kxYswGMLBwb5cDUZAisIukyAa8Xshdan6C2RZcNs
 rB3L7vsg/R8UCehxOH0C+NypG2GqjVejNZsc7bgV49EOVltS+GmGyY+moIzxsuLmT93rqyII
 5rSbbcTLe6KBYcs24XEoo49Zm9oDA3jYvNpeYD8rDcnNbuZh9kTgBwFN41JHOPv0W2FEEWqe
 JsCwQdcOQ56rtezdCJUYmRAt3BsfjN3Jn3N6rpodi4Dkdli8HylM5iq4ooeb5VkQ7UZxbCWt
 UVMKkOCdFhutRmYp0mbv2e87IK4erwNHQRkHUkzbsuym8RVpAZbLzLPIYK/J3RTErL6Z99N2
 m3J6pjwSJY/zNwuFPs9zGEnRO4g0BUbwGdbuvDzaq6/3OJLKohr5eLXNU3JkT+3HezydWm3W
 OPhauth7W0db74Qd49HXK0xe/aPrK+Cp+kU1HRactyNtF8jZQbhMCC8vMGukZtWaAwpjWiiH bA==
Message-ID: <53e87077-88dc-26e3-40e7-a440afb3b0d0@gmail.com>
Date:   Fri, 19 Mar 2021 10:23:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210319052859.3220-1-dmtrmonakhov@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/03/2021 05:28, Dmitry Monakhov wrote:
> Otherwise we may endup blocking on pipe or socket.

CC: io-uring ml

> 
> Fixes: 6d5d5ac ("io_uring: extend async work merge")
> Testcase: https://github.com/dmonakhov/liburing/commit/16d171b6ef9d68e6db66650a83d98c5c721d01f6
> Signed-off-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
> ---
>  fs/io_uring.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 478df7e..848657c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2183,6 +2183,9 @@ static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  static struct async_list *io_async_list_from_req(struct io_ring_ctx *ctx,
>  						 struct io_kiocb *req)
>  {
> +	if (!(req->flags & REQ_F_ISREG))
> +		return NULL;
> +
>  	switch (req->submit.opcode) {
>  	case IORING_OP_READV:
>  	case IORING_OP_READ_FIXED:
> 

-- 
Pavel Begunkov
