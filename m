Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2455D2C8C55
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 19:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbgK3SNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 13:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbgK3SNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 13:13:08 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791ECC0617A6
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 10:12:28 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id l23so76894pjg.1
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 10:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9VSVSNx00MxNxe2izigxLAbvN36Y96mUCRMVskF44m8=;
        b=HjvCTVmwjbEfSQq0XHgwnb79Ei34LlrTbJR7otRQBSQB84yWuR71SgkrT0n3f7h8ps
         QCCmg+rsdr96iIRqdJ7sr0xWnK8nqPDJR1DPS8jKiV279PdA+ABNBvofzB7bo86gr0l1
         LrgO1f2hn77vy7u+69HEnWzbR0jdbfZ9X4brOMx+HhuZyPCrmb5GYS7sGIFrEaiMClMw
         ODZNlxBQ03N+uh1+F9mUZ/7FOZcJqqMgV1+U7iBl7tAc6NYn+V07mehjr4BFsMQIjs9R
         gDRxeoF3RnpcQsoTcDGo6ZZZHfb+a4TVmsRorhcomeC2RTi4WXO9Y6JfQx3HVNkVLvmG
         qH+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9VSVSNx00MxNxe2izigxLAbvN36Y96mUCRMVskF44m8=;
        b=g9I2OSjRUymQ/sVJ4ki9bmHMkuAIRrErGDG1b+JMwxMK6kuPE22nHlUXBFo1lQK5YD
         r6Y6kNjruN/Zr1IUpxNrXP8aTfCjOmOjACzpHj3uVFKlFzOLoVT8JtIcmFS9kc9n/RG3
         +BmD+W5NtCxUEoGvNh3TKyWmFl4Q3K748zD+QwoX+PygGnMYIFEsPbGPgN+GtbFaGyN3
         MZm5FkD3V+N3xLDGOm5RObEc/QzsWMEhPV223woo1d0+rz4laEuHkctTLmCc86qBCLxs
         1oYdFa98YOY+lavyMJNcxPnsl3rN2GK7NpN8bxAiX5xET1pAxoss2Bjdni4zXh/Atkmz
         Qg7w==
X-Gm-Message-State: AOAM532YNt8vsfU5AmFm1fd0mVHqv3xRYOn6wFzbhMPUV4490AvGZYpj
        qVgHh1KglIYdrPii7MSG/5v9Cj1JGDaSXw==
X-Google-Smtp-Source: ABdhPJyICmXAMFtAYHdEH5zbQIjvJbNmCJK9O2IcuL2dYe5BD+lyOLrebs4DqM2rERJniEW51xSpYw==
X-Received: by 2002:a17:902:bb8c:b029:d9:261:5809 with SMTP id m12-20020a170902bb8cb02900d902615809mr19600799pls.29.1606759947259;
        Mon, 30 Nov 2020 10:12:27 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q126sm18204865pfc.168.2020.11.30.10.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 10:12:26 -0800 (PST)
Subject: Re: [PATCH 5.10] io_uring: fix recvmsg setup with compat buf-select
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <70a236ff44cc9361ed03ebcd9c361864efdf8dc3.1606674793.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ee19d846-6f58-5ff0-7928-48c00fcbce3a@kernel.dk>
Date:   Mon, 30 Nov 2020 11:12:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <70a236ff44cc9361ed03ebcd9c361864efdf8dc3.1606674793.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/29/20 11:33 AM, Pavel Begunkov wrote:
> __io_compat_recvmsg_copy_hdr() with REQ_F_BUFFER_SELECT reads out iov
> len but never assigns it to iov/fast_iov, leaving sr->len with garbage.
> Hopefully, following io_buffer_select() truncates it to the selected
> buffer size, but the value is still may be under what was specified.

Applied, thanks.

-- 
Jens Axboe

