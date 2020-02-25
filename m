Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01EA116EA45
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 16:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgBYPkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 10:40:24 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:34292 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgBYPkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 10:40:24 -0500
Received: by mail-io1-f66.google.com with SMTP id 13so14091377iou.1
        for <stable@vger.kernel.org>; Tue, 25 Feb 2020 07:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HJs6lNzlny8C5dUd8NDLLpx0JALPeod87u9DRvjzyfM=;
        b=hyB0SuUO+OBFKI0rXlsG7qWGZABvBhwUVmU2qJ8h850FPo3FV2f1+C4CKfHTQWi/Yw
         PaffYDUcTMSGHbSBkPP4hSb55XH6yX6mrkpWYMT5t/nEwv1fmnH9lkAqgDT+aB5PuYb3
         zK7txAf0im57D//RSjMdoNjEujYyia4R/sHXcbvITUurogMglsbf16QKTrYeF67XyHX6
         l2rhZQaIXmsk8N7QM1Rd70vuEDt6KcXYKgb5frSOLkVWavAIHwb5bEZVcl5Hxd7wzAkZ
         UJa4l2ClqznR88rqfQe6gKWBOfInAIkMi0QCYA1iFtVQdadz9V8zova6V543O8am9xkf
         6JDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HJs6lNzlny8C5dUd8NDLLpx0JALPeod87u9DRvjzyfM=;
        b=lT5h9Ds9m69NT1rlVZ91nzv7QBpfcIKh270e90DjBRMmYJz8LiUluNq5kIPepQW7FA
         NTI2YEYJUeE/u3eJUOSI2J5ygcWxLfSLuiaS7PeUyTJvAS++zapJ5xYJ4wWP2O23CU5r
         hra8uSeKo5gM1If95MZZbivVEtfOPWU3v6c/rBGQ0g+7eSnzrqYFfLGiQtEpuJT8bzxp
         FMvC14uVOJvyADDSa54OvaLQGcx4RakfPisWk+h38d4jCdoaYivuezmuYTFVXJV//QSL
         8KTMrUTkxXEWuQy4KzLc8/5PkFyQZP0pT+TsqrW+BiTl8jxBSkwEfYWXrhQ0HEWIL84l
         r9/w==
X-Gm-Message-State: APjAAAUTBLZq1vGQ2HgIv5cebNlndowoefJNtKuIprv0DIZ+Cr2GTStg
        olDgo6+hg+BZYIhyw8c2GF70Ejzceqw=
X-Google-Smtp-Source: APXvYqxSPRUlaDuq7OHxGJ3QGS5tIJnfabQNYUaWkkq9uW9PklBzmTc+7mVE8BIE1sg5bgWzGV6HKg==
X-Received: by 2002:a6b:bb45:: with SMTP id l66mr59469984iof.73.1582645223184;
        Tue, 25 Feb 2020 07:40:23 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z66sm5584558ilc.17.2020.02.25.07.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 07:40:22 -0800 (PST)
Subject: Re: [PATCH] blktrace: Protect q->blk_trace with RCU
To:     Ming Lei <ming.lei@redhat.com>, Jan Kara <jack@suse.cz>
Cc:     linux-block@vger.kernel.org, tristmd@gmail.com,
        stable@vger.kernel.org
References: <20200206142812.25989-1-jack@suse.cz>
 <20200219125947.GA29390@quack2.suse.cz> <20200225102045.GB1771@ming.t460p>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8e0e19dd-66b2-16bc-5251-e26847cfe9a5@kernel.dk>
Date:   Tue, 25 Feb 2020 08:40:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200225102045.GB1771@ming.t460p>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/25/20 3:20 AM, Ming Lei wrote:
> On Wed, Feb 19, 2020 at 01:59:47PM +0100, Jan Kara wrote:
>> On Thu 06-02-20 15:28:12, Jan Kara wrote:
>>> KASAN is reporting that __blk_add_trace() has a use-after-free issue
>>> when accessing q->blk_trace. Indeed the switching of block tracing (and
>>> thus eventual freeing of q->blk_trace) is completely unsynchronized with
>>> the currently running tracing and thus it can happen that the blk_trace
>>> structure is being freed just while __blk_add_trace() works on it.
>>> Protect accesses to q->blk_trace by RCU during tracing and make sure we
>>> wait for the end of RCU grace period when shutting down tracing. Luckily
>>> that is rare enough event that we can afford that. Note that postponing
>>> the freeing of blk_trace to an RCU callback should better be avoided as
>>> it could have unexpected user visible side-effects as debugfs files
>>> would be still existing for a short while block tracing has been shut
>>> down.
>>>
>>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=205711
>>> CC: stable@vger.kernel.org
>>> Reported-by: Tristan <tristmd@gmail.com>
>>> Signed-off-by: Jan Kara <jack@suse.cz>
>>
>> Jens, do you plan to pick up the patch? Also the reporter asked me to
>> update the reference as:
>>
>> Reported-by: Tristan Madani <tristmd@gmail.com>
>>
>> Should I resend the patch with this update & reviewed-by's or will you fix
>> it up on commit? Thanks.
>>
> 
> I have run concurrent quick/repeated blktrace & long-time heavy IO, looks
> this patch just works fine, so:
> 
> Tested-by: Ming Lei <ming.lei@redhat.com>
> 
> Jens, any chance to take a look at this CVE issue?

Queued up for 5.6, thanks everyone.

-- 
Jens Axboe

