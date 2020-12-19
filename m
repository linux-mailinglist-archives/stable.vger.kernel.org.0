Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60DD2DEFD6
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgLSN1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgLSN1z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 08:27:55 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FBCC061282
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 05:27:15 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id f9so3255570pfc.11
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 05:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X0CmRjBq596vb807//GKT4AopKraqebi4ZJG8MFWUQg=;
        b=fHFNEe277TpiXRjqacoyWzVqKTe8tg+w5DmlW4oy7AB4KYoD3ElxXLTgLefeQRmoEJ
         7NqoWSH/LNlUKIoW0TAsdJOvPKeHYy+rjfOJ6VEExk97N2SgOL5xk+ehzGpTuO3S5wtV
         TAIcMD4V8Bdh6CKruDuW+l0Tl3/qe8upG9SrmstOeh2cRO6YjioPwscmzjMGk55b6n/+
         Sk7ir2XfQCu93g/wX3QhtgPE6GhsCgQkKHRrKBgx5zuMGJFhnO1qIZvQgP/mBt488EXU
         pAJzoJGUaly6aS7EiIGEX0hX1nfAQHem8ZVzIA5AjiG8YHQyFGLDcmIitsQD3mQiA6Ql
         2J7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X0CmRjBq596vb807//GKT4AopKraqebi4ZJG8MFWUQg=;
        b=KIgoMYIKgrDotSqoyUdK3PJJFm1si6LMGZzJU5vJK80dty8+rLVlB5XenXLB+SBsrz
         y9O0bqrh9yP44eUbbS6kn6eTQeEr4YErgjG8+7YgCsFx4GyNNSJNPYO4avUUZC5WDrTV
         xL4jNSySdtFN9KbwbEb26/67kSWLU9Bz/OI//Up5zuVzlGSgrsY0pnOXg63BGUGh6SlY
         zvXG7GntRTZ+9iLGf4cB9Yjznn8oqyM+Ug7tSKfeH24eRbNwNQb6Vkv3U8cwJ397HwfS
         qe2+cPIqV79Dk7oKFQNTVnOuK0Uwl+6v2k77LpprGEGMjadtXt2LS4nN79Ip8SDdkNUO
         rNFw==
X-Gm-Message-State: AOAM532HTu4VdPaX1SW897G9Tt0v2hBlvqlw4CBZ9MmSNOq9uGMfcgPd
        7MdqoD8ZNGqSwgZDEDung09wAIJ9yuMeLA==
X-Google-Smtp-Source: ABdhPJzOXwFyRRBMfWXWuzVm1UR6H7Km/t0285AaQGLY76o1kVySy8YkW8MvvhAII2vK77OI5ZZWoQ==
X-Received: by 2002:a63:5351:: with SMTP id t17mr8143895pgl.176.1608384434319;
        Sat, 19 Dec 2020 05:27:14 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v9sm11374511pff.102.2020.12.19.05.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 05:27:13 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix 0-iov read buffer select
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <cdc2fad4b752b14b6be240a3cd9e5a342271625a.1608347693.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <15a8aac0-99c5-316b-1f12-0991b3c863b3@kernel.dk>
Date:   Sat, 19 Dec 2020 06:27:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cdc2fad4b752b14b6be240a3cd9e5a342271625a.1608347693.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/18/20 8:15 PM, Pavel Begunkov wrote:
> Doing vectored buf-select read with 0 iovec passed is meaningless and
> utterly broken, forbid it.

Applied, thanks.

-- 
Jens Axboe

