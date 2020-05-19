Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC501D8FB0
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 08:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgESGAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 02:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgESGAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 02:00:44 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69549C05BD09
        for <stable@vger.kernel.org>; Mon, 18 May 2020 23:00:42 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id 82so10164685lfh.2
        for <stable@vger.kernel.org>; Mon, 18 May 2020 23:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6KzCFnBysx4f+SYXFrhJOfuSGyFAARDihLujrLqLhHI=;
        b=gg2IMSyUwj+ggi0vwse5+yIqvCKIt5mNtYP74zuvPh+TMb+1c3FQPwG1HRN2fkoHRA
         OmELKqyTaPghxxwwe5VHtsR26GGKMgBvalifw1O+GSSNkvw+a8dFVqZFbboS9tG+Gqau
         HvSCuyr0NszUhJGcZTTchqiWrpEU/bau4zKxl5SOYuNgiMbEKtb0IxifXWkycvIeqzL8
         UebwQR8f3C+TCvh3rtQKD5+VZVLinVWOef95AZ3b6ANNbkuDTKN8WOyWJk949ftNms2K
         uZRdj0zwUtOx2Bva0jvbK8mnEpUSh+oyX2UQo7je6BmAJSRsawolCdOl7cteqy0aIFQL
         kRQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6KzCFnBysx4f+SYXFrhJOfuSGyFAARDihLujrLqLhHI=;
        b=qBVnnM5Lk8Iilxpb+05YCUR4Ih1b/rq4cAMgMvueYK3fDm6i+BhcB7NN7UTIjjrx37
         7VQnPa24mB98utxk1jqAssDNbx/65J+eeiHDNDzB6chGKx7uz6ptHW0p6zx3eTS5c8lB
         Inylg06+CMzCFJvrpcHBNZPDozIRxeNUarPGQfISEQgumW4lGE/37rCx8YBh5m0T+b+n
         ihKddd/P1Zi6yRX8TelTGG7Qa8qS4HAqvigVyHhGX/sIiyX7d7LZDDrPJlgiYGPWYMYw
         gS72G5Sk0ZtBlzWnbSnUoqu/GOBDkn9ACovALEGCxIeb5zf/ymkPfYQ/EICy300h6nBu
         2uoQ==
X-Gm-Message-State: AOAM532BH4GBasFqMTbnirFXoFLOvMjhEqND0dHBVNKmOO9VP5uO4Zx0
        dOi84XvcUrsh8XLWs0s9VIpQog==
X-Google-Smtp-Source: ABdhPJyyLpBOcLYYQNPI6jD+RvQfGKDpqKyzETt2AanQcX4wtGv5uyEi6P6SkWtOAuQ/aqziNW4A8w==
X-Received: by 2002:a19:4b12:: with SMTP id y18mr13978660lfa.169.1589868040431;
        Mon, 18 May 2020 23:00:40 -0700 (PDT)
Received: from buimax ([109.204.208.150])
        by smtp.gmail.com with ESMTPSA id m13sm8329898lfk.12.2020.05.18.23.00.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 May 2020 23:00:40 -0700 (PDT)
Date:   Tue, 19 May 2020 09:00:38 +0300
From:   Henri Rosten <henri.rosten@unikie.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Giuliano Procida <gprocida@google.com>, lukas.bulwahn@gmail.com
Subject: Re: [PATCH 4.4 63/86] block: defer timeouts to a workqueue
Message-ID: <20200519060036.GA28441@buimax>
References: <20200518173450.254571947@linuxfoundation.org>
 <20200518173503.131794977@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518173503.131794977@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 07:36:34PM +0200, Greg Kroah-Hartman wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> commit 287922eb0b186e2a5bf54fdd04b734c25c90035c upstream.

I notice 287922eb0b18 has been referenced in Fixes-tag in mainline 
commit 5480e299b5ae ("scsi: iscsi: Fix a potential deadlock in the 
timeout handler"). Consider if backporting 5480e299b5ae together with 
this 4.4 version of 287922eb0b18 is also relevant.

Thanks,
-- Henri


> 
> Timer context is not very useful for drivers to perform any meaningful abort
> action from.  So instead of calling the driver from this useless context
> defer it to a workqueue as soon as possible.
> 
> Note that while a delayed_work item would seem the right thing here I didn't
> dare to use it due to the magic in blk_add_timer that pokes deep into timer
> internals.  But maybe this encourages Tejun to add a sensible API for that to
> the workqueue API and we'll all be fine in the end :)
> 
> Contains a major update from Keith Bush:
> 
> "This patch removes synchronizing the timeout work so that the timer can
>  start a freeze on its own queue. The timer enters the queue, so timer
>  context can only start a freeze, but not wait for frozen."
> 
> -------------
> NOTE: Back-ported to 4.4.y.
> 
> The only parts of the upstream commit that have been kept are various
> locking changes, none of which were mentioned in the original commit
> message which therefore describes this change not at all.
> 
> Timeout callbacks continue to be run via a timer. Both blk_mq_rq_timer
> and blk_rq_timed_out_timer will return without without doing any work
> if they cannot acquire the queue (without waiting).
> -------------
> 
 
