Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A077ECF11
	for <lists+stable@lfdr.de>; Sat,  2 Nov 2019 15:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfKBOD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Nov 2019 10:03:59 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46703 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfKBOD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Nov 2019 10:03:59 -0400
Received: by mail-pg1-f193.google.com with SMTP id f19so8214472pgn.13
        for <stable@vger.kernel.org>; Sat, 02 Nov 2019 07:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cIqRCDelQ2QzV3ADiNrggvNsE7uK4SPsRu91QQliWOM=;
        b=m6LW3TEsSigobj/S/Uuy6wHLViVXGdoGFXMWyLaGj0NH+ujv0Ybt+rbgh51DMpHi6y
         lD1z1FRy7fXhTLx7dN225D0z0pUV3tdr9z36Yqfu/81U2zEhFRDzYWhapjzrp5TnZgm0
         7azXh9RhlCHlD4Q5VrNNB0cCiSrFYeKInvIdyIlze5/1RTWbavObzMnbLFj2lE8EmdQh
         Hr20d3llTHHbAttzTasScpYQTxOLVKVtI3A0Hb6R+yHhpQGQ4a3vGXj3lio0qV6E8wMB
         BXjgV/cPuKDjBC86VFPV1nYyoHprUEmWAlssZOr9FWNkzGH0IjL80Zw8Efn5vX/Qh++y
         npFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cIqRCDelQ2QzV3ADiNrggvNsE7uK4SPsRu91QQliWOM=;
        b=Dgg5Zs0oZtdW8JBUM5WdhPCJGwkgvfDsoAxX1pJNJ/U3J1nwBR3yGJVj+tbmfsw/IP
         B6Kuy+pWXPYXmAS74OTy6ds6mRXoHbjuYXvRSYE4H5ycjGTYg5bkNV3WOSkadm/f+rVI
         gPItE6X4xJHJSOMWiYzK7XXi2cesAfdnjZTiZ5Au5wYdVCt8cKBGtHkkwqYXir+xZ9Kn
         Nw9n0CDEN/xDxsncMujF/SiBsOJajlOUxfaYZtcw5MxHBViZOQahIIxdto2NI3HSVPpk
         hOsiIy2IVmGJ6LXG3zhl7xlC0aVjgRHfZ79nLCDqZLPHX+tVQhsUt1/pcPJ/qLd3x69h
         UtXg==
X-Gm-Message-State: APjAAAVMkwPpyl3/lvfUT44m8xrAt2fqBmQQQVsT4P/t3vFokqIwLhHX
        AjXf1O/r7R3P2Ko0976RKN3P2hkgE503cA==
X-Google-Smtp-Source: APXvYqxFCfGRNK8kJt+Um+HkJ7nPNPJhWf7yglDrAdKMcBLPmJavyuWIE7Ywg6m99GLm5NcuYv83Cg==
X-Received: by 2002:a62:e214:: with SMTP id a20mr4798191pfi.193.1572703436397;
        Sat, 02 Nov 2019 07:03:56 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id 18sm10302057pfp.100.2019.11.02.07.03.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 02 Nov 2019 07:03:55 -0700 (PDT)
Subject: Re: [PATCH] blk-mq: avoid sysfs buffer overflow by too many CPU cores
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, stable@vger.kernel.org
References: <20191102080215.20223-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e9438176-1dbf-ca2c-62f2-b0c37f8c9bab@kernel.dk>
Date:   Sat, 2 Nov 2019 08:03:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191102080215.20223-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/2/19 2:02 AM, Ming Lei wrote:
> It is reported that sysfs buffer overflow can be triggered in case
> of too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs of
> hctx via /sys/block/$DEV/mq/$N/cpu_list.
> 
> So use snprintf for avoiding the potential buffer overflow.
> 
> This version doesn't change the attribute format, and simply stop
> to show CPU number if the buffer is to be overflow.

Applied, thanks.

-- 
Jens Axboe

