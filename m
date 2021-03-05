Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAF432F285
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 19:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhCES2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 13:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhCES1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 13:27:46 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103C5C061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 10:27:46 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id p16so3023104ioj.4
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 10:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=URvi90fjReX66GGxg6Cc/WcyhDQVeYyWsL++jmjfP4w=;
        b=WEcDFIAY3501+eCSpuhzyzBep81t7Z9AAUlxXimo7Aj5Z5MbkoPNCt5g0sUEOHU6Hd
         yqIdAYxqfkEU3KDkjUjVAYOc1+/Ncw198mvgLsIwQDHD6ii43q/bPHpT4wOsn8sLY+di
         IvXMg1hk3Q7LWAwLPeYG9mVaNmrK7QQf2VDuFyU2AEO9hu2bTrw9/xCkKb+RiI41hP36
         /16mlEeJvW35yXQJDrHUXoxYQL5BgVCkwyinR7XOLlfoUsidgJ2AWIpz64LHF/35KTFk
         71qxnCYG/tNsCBuGsj7ByY9p3H38hIVgFDtiof7bivJo2RGBHmOiSAtIv8yt+7ihjRMh
         8kjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=URvi90fjReX66GGxg6Cc/WcyhDQVeYyWsL++jmjfP4w=;
        b=LmS0iHq8QR6jz7VwkR5q/GJRm4tb3acHEzeyWU+yT1E/Rrd7l8cs1DMZfSa4Wx0sI0
         zMUZ4nV7hULloOJmV4tRxWBuFyHRR0EaJ2H5NswHnDHdAqK3QWHrc0xRUZF46lmnALkM
         PgUsM23R5EzhqZY+ha7BARNTna+5M9Jh+RcbesN1NveXDq2Su94v9+8oKHRGvhcME+bU
         FtNOVohqVDyvsFn25+MyV9SBIYJ1L1Hszc7TIrMqFbQnPT7YMjhbVII0/wWgqPZ+Xiaf
         fmUighVaA/ZvFtMeLTQQqj61ZNUHGwcOYuuKAVoIRMm59AEok2RBx4aG1lgwMWAp330T
         8u6w==
X-Gm-Message-State: AOAM5332q50h02RbFhHBOjocRlkiH3J/PLSO7tsfKBRUsJF4o5oWiB9O
        35Fa1Y0mWkc0uzUitMEBlxvjR64/04BvFg==
X-Google-Smtp-Source: ABdhPJwqjG7Eq8kF3HmSR3Fy2ObJJoErkj1f5tNBTd9wUKtd5rUPdCoxhJ/05fFUXlAn0FSoCLxdjQ==
X-Received: by 2002:a02:8545:: with SMTP id g63mr11315827jai.79.1614968865235;
        Fri, 05 Mar 2021 10:27:45 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s16sm1630643ioe.44.2021.03.05.10.27.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 10:27:44 -0800 (PST)
Subject: Re: [PATCH v2] block: Try to handle busy underlying device on discard
To:     Jan Kara <jack@suse.cz>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        stable@vger.kernel.org
References: <20210222094809.21775-1-jack@suse.cz>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <53689a67-7591-0ad8-3e7d-dca9a626cd99@kernel.dk>
Date:   Fri, 5 Mar 2021 11:27:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210222094809.21775-1-jack@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/22/21 2:48 AM, Jan Kara wrote:
> Commit 384d87ef2c95 ("block: Do not discard buffers under a mounted
> filesystem") made paths issuing discard or zeroout requests to the
> underlying device try to grab block device in exclusive mode. If that
> failed we returned EBUSY to userspace. This however caused unexpected
> fallout in userspace where e.g. FUSE filesystems issue discard requests
> from userspace daemons although the device is open exclusively by the
> kernel. Also shrinking of logical volume by LVM issues discard requests
> to a device which may be claimed exclusively because there's another LV
> on the same PV. So to avoid these userspace regressions, fall back to
> invalidate_inode_pages2_range() instead of returning EBUSY to userspace
> and return EBUSY only of that call fails as well (meaning that there's
> indeed someone using the particular device range we are trying to
> discard).

This missed -rc2, but I'll queue it up for -rc3.

-- 
Jens Axboe

