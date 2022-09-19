Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B535C5BD62B
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 23:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiISVLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 17:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiISVLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 17:11:55 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F5248C9A
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 14:11:53 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id r23so514352pgr.6
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 14:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=W0a96HTGELWgvrQnGN1hUrtPgfOxy5xYLmfcoeuU0eQ=;
        b=hMpDUvdFSbjxz6UwxAI5eHT1tsJQWQuqT3sOCIxtv5qxpJuMkalrCionX+HZawlG4P
         ZWzhty2Ad8sEGJfa701IlIR31O+cqBvh9NMcfxg/EsqlZdZ4Dh3ujb24QHbcvKESclpq
         ywbr82QNN2H66XRwB2apSpfWLod+IokV2Z/ABNEAozo6gV70s8rkDcBFbqtqc6puu+b0
         uKIkTp3+qTBdfkKK9itu9YTnz1+YdnSzB++KmfpndGe2bK6a12R7Gp3q1iYpijj7lHML
         QBbpeyHFB8hH/HImzcqz8Ab/V4fKZ36K2LYOY9M/I2EmICH8mG1eBZnSIHXuOvcL6Rog
         hKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=W0a96HTGELWgvrQnGN1hUrtPgfOxy5xYLmfcoeuU0eQ=;
        b=WrVl1TNjkhY7Kp0CcgiZUQ/TOw5IujPYg8bjyX/00tdfgR+VcL290SDoNBBm9BJhkz
         UUBiczvRJ/r4t8lJIxhuuOniSdCPPxh2CMHREZmgMlnzvNKS5zAGP34gB96qVn9UvEWM
         sbIU3Gc8Sj1jesShpFPrhwUP0K03j1jQQeuESO0cvKPNFaC/Yba53Rd/j2CwGcL4+pv5
         RpO0NhDeF0E4HwemU+b+M+KmKq0nKK5YiGvzZs7K5ytldVC2zBppjuFFncQEYcY1vS/4
         mUFfqi0OOyy+Rqo7fh64v+yfXAElQo+kC5jZvUxrYH1+HHZBVk0RefavK5XkqCSMmbB4
         WkiQ==
X-Gm-Message-State: ACrzQf2lYO2u3F4uNX83Lg9sDp6VUrd1d+Dxkvr0lgBmzaKNRlxXRDgO
        aFeec65Rh9m+5y64BCv+EYhXDMi07yRmFA==
X-Google-Smtp-Source: AMsMyM48q3BV9tgQ1kQRyEem0YDlvVV7jWsfHvkETk0z3ifyQTCh7oroYkyF2kV8HumRXnMaqVl3NQ==
X-Received: by 2002:a63:1a45:0:b0:439:49b4:9672 with SMTP id a5-20020a631a45000000b0043949b49672mr17215903pgm.551.1663621913119;
        Mon, 19 Sep 2022 14:11:53 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a10-20020aa78e8a000000b00537eacc8fa6sm12206057pfr.40.2022.09.19.14.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 14:11:52 -0700 (PDT)
Message-ID: <ce458190-94b2-e7b7-3c93-36e52879fc93@kernel.dk>
Date:   Mon, 19 Sep 2022 15:11:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/3] io_uring/rw: fix short rw error handling
Content-Language: en-US
To:     Avadhut Naik <avadnaik@amd.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, stable@vger.kernel.org,
        Beld Zhang <beldzhang@gmail.com>
References: <20220919201741.18519-1-avadnaik@amd.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220919201741.18519-1-avadnaik@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/19/22 2:17 PM, Avadhut Naik wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> We have a couple of problems, first reports of unexpected link breakage
> for reads when cqe->res indicates that the IO was done in full. The
> reason here is partial IO with retries.
> 
> TL;DR; we compare the result in __io_complete_rw_common() against
> req->cqe.res, but req->cqe.res doesn't store the full length but rather
> the length left to be done. So, when we pass the full corrected result
> via kiocb_done() -> __io_complete_rw_common(), it fails.
> 
> The second problem is that we don't try to correct res in
> io_complete_rw(), which, for instance, might be a problem for O_DIRECT
> but when a prefix of data was cached in the page cache. We also
> definitely don't want to pass a corrected result into io_rw_done().
> 
> The fix here is to leave __io_complete_rw_common() alone, always pass
> not corrected result into it and fix it up as the last step just before
> actually finishing the I/O.

I'm confused by this email, why is it being sent? And what are the 2-3/3
patches?

And while this one should certainly go to stable, also note that:

commit 62bb0647b14646fa6c9aa25ecdf67ad18f13523c
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Tue Sep 13 13:21:23 2022 +0100

    io_uring/rw: fix error'ed retry return values

exists in Linus's tree and should go in alongside the parent as it
fixes the parameter type.

-- 
Jens Axboe


