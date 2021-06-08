Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC673A0594
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 23:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFHVPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 17:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhFHVPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 17:15:08 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6985CC061787
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 14:13:00 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id y11so9445527pgp.11
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 14:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kavbhkV/CORp2/ogdB7Rtj7eAxktrXq37FhU19x+nUk=;
        b=KBB/iKjh3n+I7dWpm/bbRMzFGylRHvlUJnpGGDzQn9hQPT/1v7BuDyRtaCFGDKsSZ/
         SRRD+GY8TuRx1wgYJ3SRVc5v1Ag1KqgrPh1waNhykvt68RxtIsq/robvfeAPC3r7Oq6L
         WEvRA8PBW42xemmkJkwsvPK9rKm7VDGZeeS+gjiBUXfGDtsK2CKptCOPrlakKqK/Fl9K
         +17fXokO4vcrugo4LOrIh5ot/kmLgVjs0fhf+ZCwRxaB2RfiugsyFgiFPIB7xR+rtWCk
         HL3lFxRDtXGzjXg3c0sP4rFGJ3baV4MU2YQ5PpkQIzdlC6U8NtT6KpfvPwlfairR12AA
         k2ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kavbhkV/CORp2/ogdB7Rtj7eAxktrXq37FhU19x+nUk=;
        b=sVUb7oNlyY463Rvc1PMr5n87iiZoLciK9845VJ0CjHjcTJ2GXxk1plJsdV81k6PGgD
         Q59ZYsaWPjsCikQXFelPQvLC0zboov8bt931e+s1WoUSsNSNJBJx3HWE2PL/UxSiT3rJ
         9J++q7OquMYCNgNAqE4zKw6QDnyImpgZIlGY3OFDs5IMztBEjm2tcJBKy6YR0GLAcrBl
         zZfHHscKI7S82+HJz+IOJhPHkhQfRAKRMRMugLWm92ET07VH9SRe0+YTfUnnJXDvoQlt
         Mohxt0afUQT4KInBBeTf5/VoNQ+bmCKDvUz+S4ZwWBTvY1IXx0Zn6clHKrfGoYB+tviA
         Ghzg==
X-Gm-Message-State: AOAM531VY13QsIxK0atauDir8QOUcbJpwemm0EzBVlIndjib+MUiUGEe
        PHq6EMCEsHEAe8e3nlrNvKP4ywuWXmzSCg==
X-Google-Smtp-Source: ABdhPJztTQV6zqfvIRBqvDAZKkQMbx3QWBPtGYGL9c7JROWyN/H0l4/bHq1BZ7/QpT4C3oZu1RTidQ==
X-Received: by 2002:a62:3344:0:b029:28c:6f0f:cb90 with SMTP id z65-20020a6233440000b029028c6f0fcb90mr1727257pfz.58.1623186779130;
        Tue, 08 Jun 2021 14:12:59 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id c20sm3036209pjr.35.2021.06.08.14.12.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 14:12:58 -0700 (PDT)
Subject: Re: [PATCH] rq-qos: fix missed wake-ups in rq_qos_throttle try two
To:     Jan Kara <jack@suse.cz>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-block@vger.kernel.org,
        stable@vger.kernel.org
References: <20210607112613.25344-1-jack@suse.cz>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e14aeaa7-45a3-b2f0-7738-3613189ae1d4@kernel.dk>
Date:   Tue, 8 Jun 2021 15:13:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210607112613.25344-1-jack@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/7/21 5:26 AM, Jan Kara wrote:
> Commit 545fbd0775ba ("rq-qos: fix missed wake-ups in rq_qos_throttle")
> tried to fix a problem that a process could be sleeping in rq_qos_wait()
> without anyone to wake it up. However the fix is not complete and the
> following can still happen:
> 
> CPU1 (waiter1)		CPU2 (waiter2)		CPU3 (waker)
> rq_qos_wait()		rq_qos_wait()
>   acquire_inflight_cb() -> fails
> 			  acquire_inflight_cb() -> fails
> 
> 						completes IOs, inflight
> 						  decreased
>   prepare_to_wait_exclusive()
> 			  prepare_to_wait_exclusive()
>   has_sleeper = !wq_has_single_sleeper() -> true as there are two sleepers
> 			  has_sleeper = !wq_has_single_sleeper() -> true
>   io_schedule()		  io_schedule()
> 
> Deadlock as now there's nobody to wakeup the two waiters. The logic
> automatically blocking when there are already sleepers is really subtle
> and the only way to make it work reliably is that we check whether there
> are some waiters in the queue when adding ourselves there. That way, we
> are guaranteed that at least the first process to enter the wait queue
> will recheck the waiting condition before going to sleep and thus
> guarantee forward progress.

Applied, thanks.

-- 
Jens Axboe

