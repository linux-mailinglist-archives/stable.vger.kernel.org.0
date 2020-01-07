Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F87A13341D
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbgAGVX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:23:57 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:44250 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728473AbgAGVA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 16:00:58 -0500
Received: by mail-io1-f67.google.com with SMTP id b10so789274iof.11
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 13:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TUCMvAlrozTSswUZRaX/kk/b3mxYfUe4t6CXtrf2o+s=;
        b=GehBVaBAx2yLw8xmK6L9yXpZmniP/2JyAJ3/e8p9FE6da8ZcO/BGm8rhirJ906imzR
         MyMS2cxd096Pcka3v1dxK5QOY76n81+jkNNzm92Fu1BLm12o33wIh8PuqUyvqB5JgEAT
         kg2l9mn1owXVwnaEwiAe9SxaV14zDbe3aXQoIoZMkigADe2qBr1ShfEmJPt4DmnIkFdM
         Nl7O3XfkSkhCda0b1Hkp1OlbetxllC5f4OMGIaWe96kCUf2NJ3z2UgdQ3Uskep4pyBmT
         i7Kg9HyftPWed+j0nbeSEVmQxWqgcolE4dTvs6xIG2mvTDxwga0AhX4w/wDYcgT/lrhn
         TfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TUCMvAlrozTSswUZRaX/kk/b3mxYfUe4t6CXtrf2o+s=;
        b=livFmmfdt/BxljJgVKOtS+UG/NFZEWh1iLzVmL/qOpgji45Pv0pt3lKnD5TfxTHUoq
         X5IuJGeQ9byMWcBbOZ1dLkedMGEroNcnrBkSOpqg8DJMkw8AKe75ysPUbCj4brdDG23T
         7Br9BuRN3FRWguZiBAyDEGblnrxd6G3POp9Y/va+6MEOshDYjltPyaLx6DlLB80ePnjC
         FNfLNd0zYXGYgxZoP8726SxDnL09QAJQPa7mEVGba7j/13on0rQl5PH/wVit25ZTnfAv
         bOCTxWgYjLiW5C+jZmf5UMW4dJnX4Iop/Pev7yb4UuS4Gako7sA50Z/upye1kHEgB6UL
         jzLA==
X-Gm-Message-State: APjAAAXcQCQM0DpIIDopa4/xd8plW1uJyatyuo1ewsaPSWFjVGtrBr2h
        b9NvLWNGu6/9ydgKL2GExKwRcw==
X-Google-Smtp-Source: APXvYqzgUwxMWRW1F7AdWKU490fmEMlII4xM/XzIv7jxVALemJiPaRzlelnhtwr2Yi1XbXw+xwNUuw==
X-Received: by 2002:a6b:7f47:: with SMTP id m7mr789897ioq.82.1578430857516;
        Tue, 07 Jan 2020 13:00:57 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g62sm230208ile.39.2020.01.07.13.00.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 13:00:57 -0800 (PST)
Subject: Re: [PATCH 5.4 100/191] block: fix splitting segments on boundary
 masks
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Chris Mason <clm@fb.com>,
        Ming Lei <ming.lei@redhat.com>
References: <20200107205332.984228665@linuxfoundation.org>
 <20200107205338.341621494@linuxfoundation.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1fc351dd-a213-3310-7611-6b8c60c209cf@kernel.dk>
Date:   Tue, 7 Jan 2020 14:00:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200107205338.341621494@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/7/20 1:53 PM, Greg Kroah-Hartman wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> commit 429120f3df2dba2bf3a4a19f4212a53ecefc7102 upstream.
> 
> We ran into a problem with a mpt3sas based controller, where we would
> see random (and hard to reproduce) file corruption). The issue seemed
> specific to this controller, but wasn't specific to the file system.
> After a lot of debugging, we find out that it's caused by segments
> spanning a 4G memory boundary. This shouldn't happen, as the default
> setting for segment boundary masks is 4G.
> 
> Turns out there are two issues in get_max_segment_size():
> 
> 1) The default segment boundary mask is bypassed
> 
> 2) The segment start address isn't taken into account when checking
>    segment boundary limit
> 
> Fix these two issues by removing the bypass of the segment boundary
> check even if the mask is set to the default value, and taking into
> account the actual start address of the request when checking if a
> segment needs splitting.

Greg, there's a problem with this one on ARM. Should be resolved
shortly, but probably best to defer this one until the next 5.4
stable release.

I'll ping you with both patches once the dust has settled.

-- 
Jens Axboe

