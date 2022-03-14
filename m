Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D994D8DD0
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 21:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244925AbiCNUIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 16:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244933AbiCNUHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 16:07:49 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEB940A2D
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 13:06:38 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id e22so19708870ioe.11
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 13:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pNK/mLCgZ08MWUxMB3jRjHDWa9CxmXckF+z5BU9c/js=;
        b=4kHOuCERNruRuZHNwoTUS+Qa525lSX1f4JvIs+FPT6KSZwPUwvkiSztroFhdqUYsap
         ZrS6qUl0bQOFK1BbrL1YXmWDrNJIT15+umgn/M7cBjxNokbnL3l5upF99BT5Ai476hda
         e7Jp0fAIfC/we3KGtvLyEXyLERpp3NsNG9cpyQepB5WyNClvHI+1wsc5RykkmJzfZP5r
         d96oYMyxWgUPYMGkMH54g1yUxVenRFoK2StUzmsQpSdBzYL3WRWbWO3arAQFmmzHsg5f
         OS9tkcvqnJDYDr7+eWZEALyWTmxk93WKCGgIY4HaNV3w2P8vsEp0I3TbNdAkjcvrAzCc
         YKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pNK/mLCgZ08MWUxMB3jRjHDWa9CxmXckF+z5BU9c/js=;
        b=xtZHPkfVoBbe5xARuGt5kVfJRm3VhWvLxUSii3vwJGOBtc+JIRphbvisNxAg56Iid7
         XZFocM/HQRQM6x7oT1Nas27taUJj5MyGFFCPI1yW9sSc4mCKqzPuJhVI0HfSWmzCqsgu
         F1u1vKxHB2070dVcSQP22QJ6W7u09/mvfs/7AOfFlUJR+ANLRYpFtxQbQ3aLpVkKibCq
         +7Lrv0tRr4ohEhL9tPGBrgoXKXJ62pn/ry+ItI9sWAjRmFwOHBmTCkVMePy/Kezx10xO
         TwXH8ANUIMFb08kpqfdrDSZPKASlWhSlqHKWvtCEh5R+XlzwiOQCziFPR3OcVrHSS9F4
         /cVQ==
X-Gm-Message-State: AOAM531Z5d+iAA6AK7M0tSBEa6zG4QFe5L0f5Vmhg7kesd7u0I9f8Ak9
        kElI/Xi2K/+1u8COh+4VcfQadw==
X-Google-Smtp-Source: ABdhPJxpltXYVgjr7+HOEGz9h4e31kr6H0zOlScN+VqNzc44T677L54zAPCZD13JOCIyK0HfVegUkw==
X-Received: by 2002:a05:6638:2686:b0:319:acb4:46e6 with SMTP id o6-20020a056638268600b00319acb446e6mr21036767jat.231.1647288397782;
        Mon, 14 Mar 2022 13:06:37 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s3-20020a056e021a0300b002c7a545c3c3sm1913809ild.66.2022.03.14.13.06.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 13:06:37 -0700 (PDT)
Message-ID: <57c08222-cf24-605b-ed51-5338698e55bd@kernel.dk>
Date:   Mon, 14 Mar 2022 14:06:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] block: release rq qos structures for queue without disk
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org,
        syzbot+b42749a851a47a0f581b@syzkaller.appspotmail.com
References: <20220314043018.177141-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220314043018.177141-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/13/22 10:30 PM, Ming Lei wrote:
> blkcg_init_queue() may add rq qos structures to request queue, previously
> blk_cleanup_queue() calls rq_qos_exit() to release them, but commit
> 8e141f9eb803 ("block: drain file system I/O on del_gendisk")
> moves rq_qos_exit() into del_gendisk(), so memory leak is caused
> because queues may not have disk, such as un-present scsi luns, nvme
> admin queue, ...
> 
> Fixes the issue by adding rq_qos_exit() to blk_cleanup_queue() back.
> 
> BTW, v5.18 won't need this patch any more since we move
> blkcg_init_queue()/blkcg_exit_queue() into disk allocation/release
> handler, and patches have been in for-5.18/block.

Applied, but it's a bit strange to send a 5.17 only patch against the
5.18 tree... Hand applied.

-- 
Jens Axboe

