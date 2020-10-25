Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F4429834C
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 20:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418439AbgJYTE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 15:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1418437AbgJYTE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Oct 2020 15:04:58 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061BBC061755;
        Sun, 25 Oct 2020 12:04:56 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id n18so10054925wrs.5;
        Sun, 25 Oct 2020 12:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kWaeqoP/0id2uGZrHX/xZoXJACwWij2H/tnv3owuhS4=;
        b=NZbrjRF1synDNX3CCAHR1ZtWi0qSXlaFnda+DX/FvXJVp9guYJf1jsZfnMn5E+brFM
         /FsbsBM3tdPqhZ+m32YspTHSBzOJr7ZFIga6+Nm9HO3egEx1KRD7aWPmN0uvELOZHcBN
         6NYtDXK9yD/6B5B6diL4f2zdpRJFX+YDLdXBWaj7fOM0rHuBvVd3CBdVLgU0WPPwHZyh
         YF0zGmwqzl8Pf1rXxYhdPQTl74HCFNUnSpIoV3WBGIwdkEWf2AkKmes2Rby3sFpC4SqZ
         0ZzEPif/T7DWIaRkEdBHTWhbxMF/Xa4ihxtXAhkAmFT2xUq0LTpeWrdADV2uBpm3rfpT
         NqQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kWaeqoP/0id2uGZrHX/xZoXJACwWij2H/tnv3owuhS4=;
        b=QOUCRKsUz2qTahkth0uqtZ+w+nnFCP6DS3/thiMvMXrbPOXgRnXMGbLYzeKIwwwuLI
         EJ8t9GUqRqpfFhF1vGTLuKlZg8eWMA6cire8iSKgCAw7pTwBvQ1W4lykgOqTTbpdBkqm
         XTtLiEiRQPYdUS7iimnAu71ZiEmsJ8z4xOK0yJaRGowAyze9KSiwtx16P6cSz5tZgsv5
         o08tiev1tgQOjG11a+RrRHIjihmZ9G8IWV2B7jiLZbw7EVlVASBTtd1OATzdoDkIs+5P
         3rdaBz2G+xs3YD54olTdK8wk3ZHDNpl96CyPdayqCEqdGApbgljbAX2oEAwm9U+KRD8t
         9aSw==
X-Gm-Message-State: AOAM533qkAIna+xCFJ77JQB7uQqhSZYLifll9McG14ucRE0m9twOGlB+
        Sp/qsLjIxbhlRvvB+w6cNRgF1ynzHL6Wfg==
X-Google-Smtp-Source: ABdhPJyD34Y7jgkGn0lNq3qAPoQcZTwYuSwRtKao+xniv1YjnM15+ZYaUysiRaf/jUnx9q9b4FJtZw==
X-Received: by 2002:a05:6000:81:: with SMTP id m1mr14218014wrx.67.1603652693328;
        Sun, 25 Oct 2020 12:04:53 -0700 (PDT)
Received: from [192.168.1.159] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id f8sm18418446wrw.85.2020.10.25.12.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2020 12:04:52 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix invalid handler for double apoll
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <1bf1093730a68f8939bfd7e6747add7af37ad321.1603635991.git.asml.silence@gmail.com>
 <1ea94ec7-d80a-527b-5366-b91815496f4a@kernel.dk>
 <2022677d-6783-468d-6e77-43208a91edba@gmail.com>
 <83e9fd0e-9136-0ca7-5eb9-01f8da6bd212@kernel.dk>
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
Message-ID: <94e07136-2be5-2981-79ae-d4f714803143@gmail.com>
Date:   Sun, 25 Oct 2020 19:01:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <83e9fd0e-9136-0ca7-5eb9-01f8da6bd212@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/10/2020 18:42, Jens Axboe wrote:
> On 10/25/20 10:24 AM, Pavel Begunkov wrote:
>> On 25/10/2020 15:53, Jens Axboe wrote:
>>> On 10/25/20 8:26 AM, Pavel Begunkov wrote:
>>>> io_poll_double_wake() is called for both: poll requests and as apoll
>>>> (internal poll to make rw and other requests), hence when it calls
>>>> __io_async_wake() it should use a right callback depending on the
>>>> current poll type.
>>>
>>> Can we do something like this instead? Untested...
>>
>> It should work, but looks less comprehensible. Though, it'll need
> 
> Not sure I agree, with a comment it'd be nicer im ho:

I don't really care enough to start a bikeshedding, let's get yours
tested and merged.

> 
> /* call appropriate handler for this request type */
> poll->wait.func(wait, mode, sync, key);
> 
> instead of having to manually dig at the opcode to figure out which one
> to use.
> 

-- 
Pavel Begunkov
