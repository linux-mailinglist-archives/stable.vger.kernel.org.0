Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B239C2FEA74
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 13:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbhAUMoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 07:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731446AbhAUMmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 07:42:36 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A23C0613C1
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 04:41:56 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id y205so1426478pfc.5
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 04:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dA7zANsaygFdbSr2Swz2dYvuIIf4Skowa5Aocwr2e7A=;
        b=WZsb9WuctKbC+Y6+LdTbWFYnz/OZwT4VPhRQ49yTCeD6+TivqhMGoxk4Dip21dyboi
         vZvw/+r6g1ouIh8lBkP6NEemwMFlr8aqSvPlzqlKq0iNW+aFddz4YMltLaXBlN5eixrb
         DOPY96conj+ZkyiTQemhJjj+xilXFnz89j4uxWospSpcgWZ12AwLwb+PH2rjP6QIWVs4
         rGLgvyiLzlLH86SzviB8eOyFbaHhqOSX8xRW7o9hf9UC83i+BcT2mCxq+WCbraiXha4d
         GH4cjuEs1fQ/ZrW9vd8pyqx52nEYD5GXUc6Rea4aGy9h9sAnSx5HLI7e/aLCpZ4g2xFI
         N6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dA7zANsaygFdbSr2Swz2dYvuIIf4Skowa5Aocwr2e7A=;
        b=FA70EHzffFIjA0QLd3jfmvG94adHTbi+szgzdqQNrUqu/GVctpxR8ORR2ct979J/EL
         p3NzcHYRoHtq7QvyOn6JZ4zxKZKT3wrVOO/Z5Mvk0RU0VtS30+EsOvuiR97G8+zmiD8F
         xFM5qGKqnevQeXzbNur0rskAe+GPBOZi4kTSLOyLLht8lTNKce6f0sBXO7ZGgCEl20pl
         jX0CCuiJ8Hk5CA1EkzT9pzQ10X/2ebf1bpXhyh6G2wr8n7yp3AGbqRiRfbqj9eo+jVum
         nUgh15DjCegfmuOdQiida53SJr6rmfdSMTjeLzKO+S9fEoFVYwqly/5/CZDBMaE+oXxt
         bzeg==
X-Gm-Message-State: AOAM5335CB5hkTKqBg0yy6JumPqYlFbD4h0bDxgHudhWAGoMrDLZaxEW
        UNhgfI/CZ6/gcRXuGI9oUMZ7UKwSaoOL8w==
X-Google-Smtp-Source: ABdhPJz5zkFH9t+SB5tPN6QE1MCSTC3KiJxRWJD3JUYyHN1Vi8W/tBzMVtTfuZdUeV2Z6cZALjjrVA==
X-Received: by 2002:a62:18c5:0:b029:1b7:d777:e7bd with SMTP id 188-20020a6218c50000b02901b7d777e7bdmr13995977pfy.22.1611232915961;
        Thu, 21 Jan 2021 04:41:55 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id q2sm5714367pfg.190.2021.01.21.04.41.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 04:41:55 -0800 (PST)
Subject: Re: [PATCH v2] io_uring: fix short read retries for non-reg files
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <99c647189104206e8391419d8267a82753883bbb.1611230356.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f618d487-91a7-ff90-d9b4-51b8e163e487@kernel.dk>
Date:   Thu, 21 Jan 2021 05:41:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <99c647189104206e8391419d8267a82753883bbb.1611230356.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/21/21 5:01 AM, Pavel Begunkov wrote:
> Sockets and other non-regular files may actually expect short reads to
> happen, don't retry reads for them. Because non-reg files don't set
> FMODE_BUF_RASYNC and so it won't do second/retry do_read, we can filter
> out those cases after first do_read() attempt with ret>0.

Applied, thanks.

-- 
Jens Axboe

