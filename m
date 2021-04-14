Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F7835F8E1
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 18:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351434AbhDNQTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 12:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348855AbhDNQTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 12:19:51 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA810C061574
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 09:19:28 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id b17so17603185ilh.6
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 09:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qSdsiL0HGO2O9NOkPDe6XZEJN1S+MlqA1K8rzRFao24=;
        b=EKyNQau1M/GoJN2SeRy0tw4ZgwjFOFpKzzLtgOhg1YgLRO71XhBysKLA5EPSiLoHCC
         OupXstdR1jObGAS4Qs/I2FBk7xrQ2u27ya2Mf1Q8q9wK+cC3AxxmZlEzKXd3PtB9O2vY
         H766fP3Fw7UTem4iv8Dtcp4YOXE6PcQFbRX7GfAyHsiVB7ltVX8/9W4UB54Cq/uudNuK
         WbEmZPNpL0qivW8ZsR7jltbX0RwlbOyeqjGDa4vVpt6oCRjdxkfS3flh81EFdlUGIWCE
         y+mSuNPp++xWxu1wQi9zplfHd5oFkakJcm5IRnvsqrjF1RcWoPwF6a24PNezhRirJmPC
         ygxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qSdsiL0HGO2O9NOkPDe6XZEJN1S+MlqA1K8rzRFao24=;
        b=fmbfgIS6bVsv0jQ3Gamx9JpmxD2EU5/T3upxoP/0EifUMq7mpO2dfFYvWE6hxiUr0x
         YPkYKdLufPohlyhWr+tBZ8xTWsCvZhyBGALLKTIBinaYUkhJTMqhpwFq0zEbg4jJ3+9L
         iN1Vjh7+K32eovdgGfa07WWe7+Yv50jRn/0a9E2b3k0CB1CSiYSfsc9UsTBoCKmHTRzq
         siOf4AWs8Mmg3XeWrjeZz9bbADYA+du9sU5Ty9P7DPmVxMonbGzjtbK7zt5Ef1CnvuGY
         OxTeQELiN6jMhPEDo3U1bGMmle1eUVCQL9H8kRFiasBkzmPt8WNbO3JJVqlokEcKndz5
         Fy/w==
X-Gm-Message-State: AOAM5306qgRN64X0LEfCjAI7PHLIq9zqBeQIvHo9AkTGckH24L3MgNmc
        i3fQbai5EgeBCIo538sHT3MYzw==
X-Google-Smtp-Source: ABdhPJyrbwjtLW/FYQEgQe/wnGHsdiYJ+q79GBQkYCvmIfSj0qneLP8mRC8zwxrrMVpV2Vk97Li7Qg==
X-Received: by 2002:a05:6e02:168f:: with SMTP id f15mr5026977ila.264.1618417168236;
        Wed, 14 Apr 2021 09:19:28 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k11sm11858ilv.73.2021.04.14.09.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 09:19:27 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix early sqd_list removal sqpoll hangs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org, Joakim Hassila <joj@mac.com>
References: <1592cc2b0418a0512c83898dbef0b1c9722e8645.1618310545.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b7772850-f66a-165e-bd9e-e74a6a42f15e@kernel.dk>
Date:   Wed, 14 Apr 2021 10:19:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1592cc2b0418a0512c83898dbef0b1c9722e8645.1618310545.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/13/21 4:43 AM, Pavel Begunkov wrote:
> [  245.463317] INFO: task iou-sqp-1374:1377 blocked for more than 122 seconds.
> [  245.463334] task:iou-sqp-1374    state:D flags:0x00004000
> [  245.463345] Call Trace:
> [  245.463352]  __schedule+0x36b/0x950
> [  245.463376]  schedule+0x68/0xe0
> [  245.463385]  __io_uring_cancel+0xfb/0x1a0
> [  245.463407]  do_exit+0xc0/0xb40
> [  245.463423]  io_sq_thread+0x49b/0x710
> [  245.463445]  ret_from_fork+0x22/0x30
> 
> It happens when sqpoll forgot to run park_task_work and goes to exit,
> then exiting user may remove ctx from sqd_list, and so corresponding
> io_sq_thread() -> io_uring_cancel_sqpoll() won't be executed. Hopefully
> it just stucks in do_exit() in this case.

Added for 5.12, thanks.

-- 
Jens Axboe

