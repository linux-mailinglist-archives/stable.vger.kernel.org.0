Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC79968B8
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 20:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbfHTSor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 14:44:47 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33413 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730006AbfHTSor (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 14:44:47 -0400
Received: by mail-io1-f65.google.com with SMTP id z3so14365125iog.0
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 11:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=POIUFIUo+mTSLygBJlv/hquyjDRWa/g6KaVlpKSjnEg=;
        b=vyg75nXCa8XnlCUAVGElNqg0MWtHFhdo70nCA41hZzHck7ScYi0UkNGnxuXX9X6rM0
         UTDkQZ9WZ4AQ4VBV2pU51DfE+Ntv6U1M2Nc5yXUF81VswIX6jhgFvV/LMWM/T/aie/XY
         SP2yTXseloIhte5vFxyd4Yj1or8sXK7EoDjqPxxphEkQY63t19ZeJTlfqWtMtZzV+VqH
         w4iHCLwf5AC+UfGPWABPC3xBCi6EREjVCrb06zUANHwp7GEQjqT/VCvvQBkkzSOA5OcA
         JccRUQ9oDIooqecurFyCinCfj+sIIn1h/4C6metoJjsMAJD2uEe+/X2wc/hTDczdUW40
         4nTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=POIUFIUo+mTSLygBJlv/hquyjDRWa/g6KaVlpKSjnEg=;
        b=JXNBA4jEuJExoyehyasgEGPB8HDSmgWfw/pwX0JXidI+lBNiKvsBA9n73ZgespMBYq
         25+sEPhqlFzUJHGxI9v8jWfJGx5cQ5qtTaXbXYnamd3g/iPwgN5azUMaVWGgZD2r65R/
         WgBbNrdqfW/rAsudSAtaEGcMd8kfsA3mnbOwndzm/vQ7z0i1HIV0pKbeMzpJTxFk/e8I
         7W97/bilhbkNVuWPquDD0DIWLNHqa6+Gd9xr01axXKe5oOXFpRgvqGTEyklurUGK3kxh
         FAEKANSvZD730+6kbwP6REkvwXdWA5KV6lss/9oCw9oML/1RBNyefgSmCiACkSXvSTIH
         L9LA==
X-Gm-Message-State: APjAAAWWf1wJp/Y/l3pBjv7dMipDNd7OyVqLUZcza0Yd0vG1kQIHgroO
        uGJSyecbPMa74cw9fAVMO2dnXoxZlYUx8Q==
X-Google-Smtp-Source: APXvYqwEo2JqgTZoCXiXHwNt2ciu74IZ6pL+6qZCv/8VbQLBuB58YasfhLm7GbTfj/fi2hY/3+UtUg==
X-Received: by 2002:a6b:2cc7:: with SMTP id s190mr24697839ios.164.1566326685906;
        Tue, 20 Aug 2019 11:44:45 -0700 (PDT)
Received: from [192.168.1.50] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l2sm23612078ioq.83.2019.08.20.11.44.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 11:44:45 -0700 (PDT)
Subject: Re: [PATCH 1/1] nbd: fix max number of supported devs
To:     Mike Christie <mchristi@redhat.com>, josef@toxicpanda.com,
        linux-block@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20190804191006.5359-1-mchristi@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2c9a0b27-6761-f973-8e49-82e23b105e46@kernel.dk>
Date:   Tue, 20 Aug 2019 12:44:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190804191006.5359-1-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/4/19 1:10 PM, Mike Christie wrote:
> This fixes a bug added in 4.10 with commit:
> 
> commit 9561a7ade0c205bc2ee035a2ac880478dcc1a024
> Author: Josef Bacik <jbacik@fb.com>
> Date:   Tue Nov 22 14:04:40 2016 -0500
> 
>      nbd: add multi-connection support
> 
> that limited the number of devices to 256. Before the patch we could
> create 1000s of devices, but the patch switched us from using our
> own thread to using a work queue which has a default limit of 256
> active works.
> 
> The problem is that our recv_work function sits in a loop until
> disconnection but only handles IO for one connection. The work is
> started when the connection is started/restarted, but if we end up
> creating 257 or more connections, the queue_work call just queues
> connection257+'s recv_work and that waits for connection 1 - 256's
> recv_work to be disconnected and that work instance completing.
> 
> Instead of reverting back to kthreads, this has us allocate a
> workqueue_struct per device, so we can block in the work.

Applied for 5.4, thanks Mike.

-- 
Jens Axboe

