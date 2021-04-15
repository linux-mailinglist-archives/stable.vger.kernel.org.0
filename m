Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92654360E1D
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbhDOPJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:09:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22756 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234526AbhDOPIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 11:08:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618499281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B+RcMi9EUTEAeg0+e1n9WdYE+vOGCi6FPADfZ4q309g=;
        b=MKui4G1XymTNN/EWfqj81zMgXUBJ1VFELq85BAESUUMdyMMME0/G3yjQ5LZuz9ovPsbs+B
        Eegn+rziqeefFI5hg7XURlcedjCJuqG2JlwFXzXGb3KnYErJx18rDo4FHDZngFqMNZfGTf
        2lBZAEZKzunASlksvrvEBtNBKQMV5iA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-eZDu6zWWPX2w3hg8A98pog-1; Thu, 15 Apr 2021 11:07:59 -0400
X-MC-Unique: eZDu6zWWPX2w3hg8A98pog-1
Received: by mail-qk1-f200.google.com with SMTP id t64so1708778qke.10
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 08:07:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=B+RcMi9EUTEAeg0+e1n9WdYE+vOGCi6FPADfZ4q309g=;
        b=BUO2ESxyGXg2LAEWQoQVnuVi1YEh/jOP8JOrxA60QeTApU95b2ElFYIHlx8hJHutcd
         Yv76KaJOjbfrSx6aBnKrxjBLx8rQTPbZPRLl04Gz2kIaoKQd0VUEVSiuHeJucWssYPPd
         wjO7ZpHX16wKbpcnoGdA50pLbA2D2ZOjY15ETqC6PX8uylcbmGyhuOH87WXiePiRiTm0
         nIp1Lt9upgkDfwChJqHMDdOGYR/oZ7LtzrasUKXow73GfuPGUtEHJ6K5+1tWXBU1ivMg
         dNjEXyPVB6eWX8itzDUR5+ujrCaAvz+0ZKionAHAfMNrbB0OmtvmQyfsWNhTwXeDDMzY
         26+g==
X-Gm-Message-State: AOAM533I/KoRQU69hQ/qhiOSx+80VGsdg9HPTuD1heY1RHM9gLgHQQ86
        yRCmq4Ja2adaHhDmE0BicKoV3KiuH9Gzx86GRdqqyEiapJF464ufXDbjlXxQuTJOaCo145WrSOq
        3ys1qFPy6ceTNLnAN
X-Received: by 2002:a05:6214:204:: with SMTP id i4mr3540341qvt.47.1618499279016;
        Thu, 15 Apr 2021 08:07:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFhlSmtVXAW8WqrqvmMdkj8FJ8KrqXP3B4vqoT5iqmvk3ewYPi9VqZkE/YEGGVxA8TVTDVJQ==
X-Received: by 2002:a05:6214:204:: with SMTP id i4mr3540316qvt.47.1618499278816;
        Thu, 15 Apr 2021 08:07:58 -0700 (PDT)
Received: from llong.remote.csb ([2601:191:8500:76c0::cdbc])
        by smtp.gmail.com with ESMTPSA id q23sm2083865qtl.25.2021.04.15.08.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 08:07:58 -0700 (PDT)
From:   Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] locking/qrwlock: Fix ordering in
 queued_write_lock_slowpath
To:     Ali Saidi <alisaidi@amazon.com>, linux-kernel@vger.kernel.org
Cc:     catalin.marinas@arm.com, steve.capper@arm.com,
        benh@kernel.crashing.org, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>
References: <20210415142552.30916-1-alisaidi@amazon.com>
Message-ID: <8f6a7af0-476e-ec34-b93a-d4331429c17c@redhat.com>
Date:   Thu, 15 Apr 2021 11:07:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210415142552.30916-1-alisaidi@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/15/21 10:25 AM, Ali Saidi wrote:
> While this code is executed with the wait_lock held, a reader can
> acquire the lock without holding wait_lock.  The writer side loops
> checking the value with the atomic_cond_read_acquire(), but only truly
> acquires the lock when the compare-and-exchange is completed
> successfully which isn’t ordered. The other atomic operations from this
> point are release-ordered and thus reads after the lock acquisition can
> be completed before the lock is truly acquired which violates the
> guarantees the lock should be making.
>
> Fixes: b519b56e378ee ("locking/qrwlock: Use atomic_cond_read_acquire() when spinning in qrwloc")
> Signed-off-by: Ali Saidi <alisaidi@amazon.com>
> Cc: stable@vger.kernel.org
> ---
>   kernel/locking/qrwlock.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
> index 4786dd271b45..10770f6ac4d9 100644
> --- a/kernel/locking/qrwlock.c
> +++ b/kernel/locking/qrwlock.c
> @@ -73,8 +73,8 @@ void queued_write_lock_slowpath(struct qrwlock *lock)
>   
>   	/* When no more readers or writers, set the locked flag */
>   	do {
> -		atomic_cond_read_acquire(&lock->cnts, VAL == _QW_WAITING);
> -	} while (atomic_cmpxchg_relaxed(&lock->cnts, _QW_WAITING,
> +		atomic_cond_read_relaxed(&lock->cnts, VAL == _QW_WAITING);
> +	} while (atomic_cmpxchg_acquire(&lock->cnts, _QW_WAITING,
>   					_QW_LOCKED) != _QW_WAITING);
>   unlock:
>   	arch_spin_unlock(&lock->wait_lock);

I think the original code isn't wrong. The read_acquire provides the 
acquire barrier for cmpxchg. Because of conditional dependency, the 
wait_lock unlock won't happen until the cmpxchg succeeds. Without doing 
a read_acquire, there may be a higher likelihood that the cmpxchg may fail.

Anyway, I will let Will or Peter chime in on this as I am not as 
proficient as them on this topic.

Cheers,
Longman


