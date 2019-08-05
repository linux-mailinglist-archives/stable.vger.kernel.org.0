Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 086D381098
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 05:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfHEDm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 23:42:29 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34209 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfHEDm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Aug 2019 23:42:29 -0400
Received: by mail-pl1-f195.google.com with SMTP id i2so35926306plt.1
        for <stable@vger.kernel.org>; Sun, 04 Aug 2019 20:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TyxUsFy0g0AoyoXbyHa8cG3SKeSFUmzhTiNZ1jvQoMY=;
        b=b94eJbBllBeKjACUA7ZSo9nWNoeamDyyUJLzT5V6v2JKv/tL0pgq/kK9PjSqL7kVdG
         NRyIUFYJD9QLfNkDvHAKSWO4GdpQqnzN2cVDZvRKuPzztSkAmUQquyQ6GllHwmIzkm+u
         mdoRQiDfAdpO1Nb6kouGlS5XcrVWJ+Rg6l3PZJeBxvrBiJpwRVAJ8ps46Kv8ww45//Fj
         RTQhPKHbmhlRJEfz0d8Vvcr35cQoymlOc6gj7yKoS3vLu90eSPOVGu8fHrdKg0dmXOQf
         gu0Tekg9SDldJlVdFqtOyeiFy0/CAjRAysgOaYSgOnmvRC4AKJNKeb2GMEuN59RJm4xF
         HfeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TyxUsFy0g0AoyoXbyHa8cG3SKeSFUmzhTiNZ1jvQoMY=;
        b=T5oM52vgPcEkvURLJCZ8BFBZcXv0hwNHYNgQhIrGvf7ech5uw0q/qk6sSWpdflP777
         C+8pA/C9WyBWNkr67kySc284n6xrygcSM6erwI4vI4en23HAsLQ8ZisEIloC3cf///fw
         spDyC9Q6ed8V0rIT4Wbt3qFacXxEJ7h4ZOENZH7kdLFLXudz8Wa2TvAovMOVNUDmGsSW
         lNKBpTjSn8qK9FMkhGs+B/suoLpwJhyIkvXpMNQGm0lRAPTeogFcBmJsxsf7JtAYALln
         KyXutPO8G13VXe1TGQQGwfpxpLL7IJXBqjUPpbeeUXUDFJivihWVxGR7OI/seSdBH+oE
         5y3w==
X-Gm-Message-State: APjAAAWcHlh2pmNTnSiTVKBObufQZcW+6EdWwG5EdCtqjd3QABvQ3bcf
        yyb4tb17a70QV5h9Nl3HNkDQdrfqNIA=
X-Google-Smtp-Source: APXvYqwLmx/zPu6DfQ6/dzDHZTfJz/tMSWimusqin+r7kDygU7dS7M/pjBgVPVIyhYb8fBZ8W3K+7Q==
X-Received: by 2002:a17:902:ac87:: with SMTP id h7mr21880581plr.36.1564976548565;
        Sun, 04 Aug 2019 20:42:28 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:83a1:61e6:1197:7c18:827e? ([2605:e000:100e:83a1:61e6:1197:7c18:827e])
        by smtp.gmail.com with ESMTPSA id o3sm14505866pje.1.2019.08.04.20.42.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 20:42:27 -0700 (PDT)
Subject: Re: [PATCH V4 0/2] block/scsi/dm-rq: fix leak of request private data
 in dm-mpath
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
References: <20190725020500.4317-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c7bd89e5-6fa9-2b3c-94f5-ca7ff9004e6a@kernel.dk>
Date:   Sun, 4 Aug 2019 20:42:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725020500.4317-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/24/19 7:04 PM, Ming Lei wrote:
> Hi,
> 
> When one request is dispatched to LLD via dm-rq, if the result is
> BLK_STS_*RESOURCE, dm-rq will free the request. However, LLD may allocate
> private data for this request, so this way will cause memory leak.
> 
> Add .cleanup_rq() callback and implement it in SCSI for fixing the issue,
> since SCSI is the only driver which allocates private requst data in
> .queue_rq() path.
> 
> Another use case of this callback is to free the request and re-submit
> bios during cpu hotplug when the hctx is dead, see the following link:
> 
> https://lore.kernel.org/linux-block/f122e8f2-5ede-2d83-9ca0-bc713ce66d01@huawei.com/T/#t

Applied for 5.4, thanks.

-- 
Jens Axboe

