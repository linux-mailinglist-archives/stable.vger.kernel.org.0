Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F441233E4
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 18:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfLQRuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 12:50:32 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:43927 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfLQRuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 12:50:32 -0500
Received: by mail-io1-f67.google.com with SMTP id s2so11964108iog.10
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 09:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PIHajc5T69riCgfx1WTM9wSNYlMqcBP3FW3/e8WLwW8=;
        b=c2/nDvfyq4GTr+gc8nYpZSJO9zSjRaTVbXSwTjz040mkufZ1aIt3/Tv2L+3w7VDOvd
         k5F7o4O3pauikobpVeY6fjBJDdeq/opt78VnHVbkEjqtfFnAuqGWJLCGsEoXCHvVfQcT
         ucT7ICyumVsU4+GKOuBzskQXQMfv6vmgoYGJARKFB9svsd/HcNyHLJIVnqv1TeWEf0v9
         d8xhkBWyuXIM6iIKD/MPqwWeg4w0ffKhdMEpUDW0upWU9iBYt8xVr2lYV7hZ7rlAi8uA
         0ARanpwf7dLBwaLlHycfWPs74/USc92rW3mdOdyvH7OghrxSFh2qDOJF232anXxhD9rF
         ZHag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PIHajc5T69riCgfx1WTM9wSNYlMqcBP3FW3/e8WLwW8=;
        b=azDMPTTEwvkWLzz5zduvZJS6XfL9XAuGQiOpYNwzWK7GfMdv7iEAceiCJVSmTBHu6H
         JH/ZCiipdvZek34Iu8K+T+eZvw1Lu4gt2/ObchVUBbh4iLi0QU1x0AiwlYju/QaabdEA
         x6YIVWHXQY/rURCigW/o1QSJ8+hTIddBoRICrksx9doQSBWZB4u2m0hZmugDPH63cHyi
         +dLlhfi9vAv7nclh98cya2dLK0BYbeOWExGG2vI/VaullZu70pgcCS3xaTDX2o67FxfW
         5X+sh+g3t5ydD0a/VqYKYHim/RgKOemV1F6vz4NFO3iP3JJ3mCPVSrEOjH34+JMn+reT
         u4VA==
X-Gm-Message-State: APjAAAUt9uPieFEg14PKUHxRbHdd8Icki1S/BDdcDX63eT9Jfbwi+C7t
        M2nGb/QxC94WCbp8sftsJ4wPVSFWXDkwXQ==
X-Google-Smtp-Source: APXvYqwVrKM1N+oHGRkj51mPZn4JC/P64LM/EyVU/TOjtftWlFuKwEr+DIXhrirm0a1jR8TKm6Ajbg==
X-Received: by 2002:a02:3f26:: with SMTP id d38mr18522848jaa.53.1576605031200;
        Tue, 17 Dec 2019 09:50:31 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r22sm6893741ilb.25.2019.12.17.09.50.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 09:50:30 -0800 (PST)
Subject: Re: [PATCH] nbd: fix shutdown and recv work deadlock v2
To:     Mike Christie <mchristi@redhat.com>, sunke32@huawei.com,
        nbd@other.debian.org, josef@toxicpanda.com,
        linux-block@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20191208225150.5944-1-mchristi@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <89b62516-087a-d5f7-6f53-749df63129cf@kernel.dk>
Date:   Tue, 17 Dec 2019 10:50:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191208225150.5944-1-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/8/19 3:51 PM, Mike Christie wrote:
> This fixes a regression added with:
> 
> commit e9e006f5fcf2bab59149cb38a48a4817c1b538b4
> Author: Mike Christie <mchristi@redhat.com>
> Date:   Sun Aug 4 14:10:06 2019 -0500
> 
>     nbd: fix max number of supported devs
> 
> where we can deadlock during device shutdown. The problem occurs if
> the recv_work's nbd_config_put occurs after nbd_start_device_ioctl has
> returned and the userspace app has droppped its reference via closing
> the device and running nbd_release. The recv_work nbd_config_put call
> would then drop the refcount to zero and try to destroy the config which
> would try to do destroy_workqueue from the recv work.
> 
> This patch just has nbd_start_device_ioctl do a flush_workqueue when it
> wakes so we know after the ioctl returns running works have exited. This
> also fixes a possible race where we could try to reuse the device while
> old recv_works are still running.

Applied, thanks Mike.

-- 
Jens Axboe

