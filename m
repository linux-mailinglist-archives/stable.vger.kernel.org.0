Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0344E5C5F
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 01:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346816AbiCXAha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 20:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346807AbiCXAha (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 20:37:30 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56F5888FB
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 17:35:59 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id g3so3157275plo.6
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 17:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Izgfg/oI5zYeaCDxkub+eMw0ElM6DVSvB82ta5GTPhw=;
        b=Ndse15B+qwG0d2/LFkWCD1OGy7onij507tn5U1ujD0RfO8JLvzF8etQpyeBE1enDLK
         PXr76JJWOh3KNdF9qnku1IvPLNTY5rxoxiC6cCfTyWfQH0AbYDj7qAmbyzu9R4uYyy3T
         bYE61uMe5F46ee4kQToxKtZiAs9MGKxTbj3S5jPfyBokHNLkavoMjFncvInwvVPXZ0tX
         nLff/XFyn6ZHROb667yHynDXGL7aZIjgHkZmvUnfeAjOjEDb3Aa5rMMDeXuJ3DaQWpvE
         lacUzIQ1cKci0jcIgKu8tSc4zL4MDEkpkbDd42dQkjs2Z4fW7SAbwB0O7jwuFasZ+FLG
         rKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Izgfg/oI5zYeaCDxkub+eMw0ElM6DVSvB82ta5GTPhw=;
        b=KTQ3q2F935wQVzSKy4K6zwKuDo4pZa5RK7ar2mvVGkxp5cnoFA1uQxoe2mla1tA9L2
         aeUEq33aYnCBJl5s+mx3uydiqCW9OYBL3e/uvBkKeALjeAzqAktYTq97sQHGAzdNEu7d
         oNt3VY0uuJjWJ5sU6ZN//X5q5fvF42o+hKMET1Ia8k6j0w3v7kFJ2nIts+DDxSliW7yY
         9PYb0M1EZsK9d5fIgoECprpYeppIwEI9OhazW70F0et/Wyzg3O+Rvb6NXqkWMHRWhfgD
         +Y6k+5D52WpNQDhLdtu1K48XgYWObSGDFvSHaEc8mr/O5Gf4NOEVI0j913Lg3+ea6B/i
         qxTw==
X-Gm-Message-State: AOAM531UW0QZZOgjdmPbUDHGsiE0KuSQvGCrqXxAx5aMHbVqzdmwbdIQ
        WXmJBEuMsIkKnOEyfPhvcIgrjw==
X-Google-Smtp-Source: ABdhPJz0aefpKM0Tn/gz9aL/6LXXn+Bq0nfE/b2siBP6hlnYsRjAI7+icomtl/B0a7G9H77SZourLA==
X-Received: by 2002:a17:903:11c7:b0:151:7290:ccc with SMTP id q7-20020a17090311c700b0015172900cccmr2917214plh.95.1648082159139;
        Wed, 23 Mar 2022 17:35:59 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u10-20020a63b54a000000b00380ea901cd2sm778338pgo.6.2022.03.23.17.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 17:35:58 -0700 (PDT)
Message-ID: <fe39288b-95a1-5300-f2ea-3c7018dfa18a@kernel.dk>
Date:   Wed, 23 Mar 2022 18:35:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] io_uring: ensure recv and recvmsg handle MSG_WAITALL
 correctly
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     constantine.gavrilov@gmail.com, stable@vger.kernel.org
References: <20220323224131.370674-1-axboe@kernel.dk>
 <20220323224131.370674-2-axboe@kernel.dk>
 <51a79835-9186-695c-0304-bfd6e6a5d17d@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <51a79835-9186-695c-0304-bfd6e6a5d17d@samba.org>
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

On 3/23/22 6:32 PM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> @@ -5524,12 +5542,22 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>               return -EAGAIN;
>>           if (ret == -ERESTARTSYS)
>>               ret = -EINTR;
>> +        if (ret > 0 && io_net_retry(sock, flags)) {
>> +            sr->len -= ret;
>> +            sr->buf += ret;
>> +            sr->done_io += ret;
>> +            return -EAGAIN;
>> +        }
>>           req_set_fail(req);
>>       } else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
>>   out_free:
>>           req_set_fail(req);
> 
> The change only affects retry based socket io in the main thread, correct?

Not sure I follow - it affects retries for streams based sockets, where
previously they could be broken into two pieces when they should not be.

> The truncated mesages still trigger req_set_fail if MSG_WAITALL was set?

If we don't retry, regardless of flags, then we'll set failure on the
request to break links. If it ends up transferring the whole amount,
regardless of whether or not it happens in one go or not, it will not
fail links.

-- 
Jens Axboe

