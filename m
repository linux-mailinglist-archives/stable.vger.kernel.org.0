Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB2C1EF83F
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 14:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgFEMrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 08:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgFEMrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 08:47:25 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683ABC08C5C2
        for <stable@vger.kernel.org>; Fri,  5 Jun 2020 05:47:25 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n9so3616183plk.1
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 05:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=490Gf2ZQ0nyEq6XiXWuoZcDXG5zho6wXaKrFBnwAX6I=;
        b=YJ/fPVEzCQVzHx3XF0LCWnOyVHVlaVv1Smwe4knU5+aaK/UoyrzSI8du61rjd/NI8R
         HDGY7fgG3eGhYJHqKaW4fxetecYI4aHggN5x9KU/D9O6vzc3/Hftq8VRf1I99N+NsyPh
         3K/TDOOs6LyOyU+tmzz6Na2LXqFLAZMU4Ml4MZfwh0icjI2AcJWFoADQ3EYuSyy2xpzx
         fD7DIk3/QfshP7+zEdXhO/cq8dof8xYj297b/Ai2GKzuah56KswsBXWHZhM2rHK+M4KW
         r2JqjoLAz+mSfVPOChEJsROrZ5VHHY/sNt8GX/v2R6us9p2j+NPu9IG8LhClD8Z1k8fv
         woMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=490Gf2ZQ0nyEq6XiXWuoZcDXG5zho6wXaKrFBnwAX6I=;
        b=c5uDp5nrZI4UfPGlZSS73ofFDuLdBHOfH+ez1Ae1DRcIN8WZkGU6P4lHrJ/RD3g58c
         HSMgAr6QALcagnQxVcCBuOB7ZXiMOtNgpWIO6hYPI0Np6xW57mTRBKvo0HYO0Mqhbl4C
         7j7BOfNEQ5aDELAnyGXLzgp9PkNaswmo/w92X7YRzgPWcVAE/jomKgeiKO6xvX6jIWNn
         t8Bp/4mtYXesROg9402W4IEMcHqb6bV1T0kzahe7NKYo1k5btjj7EwQyYW58NAhDDJ6f
         rDtg0O4q9rIBtTpY/J7mPwzfC2YNU0mVt59RNpx8o/uIY9DugYF6S3w1octiczLRrgwu
         kNTQ==
X-Gm-Message-State: AOAM533zKnxaV5YFsOvY3MdRMdow75Fbc65gALqWJSnDNv43LzuX4dw/
        7Liw52Wz9ZH5HFxlQhHD8y0ynlsJzhJqaQ==
X-Google-Smtp-Source: ABdhPJx3HI2O3F0O32IYSaYmXdqgjmrOOvr0+Gh4YuE0uQ85tItBnRvrQf84NW2ac3Qb4GHq7SRfaQ==
X-Received: by 2002:a17:902:aa48:: with SMTP id c8mr9954036plr.128.1591361244448;
        Fri, 05 Jun 2020 05:47:24 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x12sm7583806pfo.72.2020.06.05.05.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 05:47:23 -0700 (PDT)
Subject: Re: [PATCH] io_uring: use kvfree() in io_sqe_buffer_register()
To:     Denis Efremov <efremov@linux.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200605093203.40087-1-efremov@linux.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <855ab3dd-4a3b-2c66-ba82-e6a1fed2e3ee@kernel.dk>
Date:   Fri, 5 Jun 2020 06:47:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200605093203.40087-1-efremov@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/5/20 3:32 AM, Denis Efremov wrote:
> Use kvfree() to free the pages and vmas, since they are allocated by
> kvmalloc_array() in a loop.

Applied, thanks.

-- 
Jens Axboe

