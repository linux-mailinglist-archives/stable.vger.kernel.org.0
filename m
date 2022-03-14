Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C72C4D8E0E
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 21:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244350AbiCNUZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 16:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241268AbiCNUZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 16:25:07 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886D5338BF
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 13:23:57 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id x9so5304754ilc.3
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 13:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=SJsceeI+x/18/bx+nnK2r3dBC17UiaTuZ4Tjl8b2uiU=;
        b=CTaH/p16a2Sxs97Dit9pUbwBat8DsAfQUdY95CWRgDTx5YYyCQyqaj6KRDL8Sskayz
         C8cuMCEVdrFRm45EkBZPyJndAVbYeCg5cKuEeEw547J6UUUYzjWIYoT5eGE/oN40A9P5
         6NGjeyn6gk3QYpLC/YA7NKD3p5hQMsGf5HfJ87meNOO5dA0m/gjZTYDXq09LKIXWwEVI
         j11xSkB4ZYlgapb7REdEe8rwZfwjeDWDiXwy2RAzrihzq5Z8g3mernKwT+x0FVlE78wf
         4sBfifsX9uV9zh8K0CmL+bwVEJf2KhWsKpacndB4P9bq8itVLyImeSr4qJhS6GM2I8Tz
         Bz8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=SJsceeI+x/18/bx+nnK2r3dBC17UiaTuZ4Tjl8b2uiU=;
        b=wXeUwhtaB5fukITRxeW8/J1+PLfTLIrvrYFME8KpvwTbFeOcApdTHi+xEPcX4UUH0h
         ZLtCcak5aZZCpUXzA1D0APcr/R+97TpbUTp2nTZiUurp9Y06gCuALQqYLFRGX8muFmmX
         Tl/bkpvGmuqu9cOWAW2IunQtqQQriSsByAqD75QidrhlATgOQTo43JHvISU1sTOtGBRf
         MpGsNSmdexJne27QOQbBpfNMoKu6A5mKqrBGgRhTPWKv3UVSoLPiVEq0dndrxk1Rj3M9
         bWx7xs2nQF8Mz3z9w5l8jDDZGJkYizERbnayGxX4Q+0XI6XvQMZ+bC4FIQHCHG88e4eU
         /2Fw==
X-Gm-Message-State: AOAM5310eqNejrR3VkqyIQGoblMgT3gDklyKw4F6/PU3JVFLRJh0XkvF
        Ze8qvU07MTl8eRYTxXAXh2xbWKoBdLALcc++
X-Google-Smtp-Source: ABdhPJzpRB0X86YH4PVUZTRije8pATz86fN/GG1G1V7Wkk6POPcEh8B+S61zsDs4Ys7WnT/w5eGMlg==
X-Received: by 2002:a05:6e02:1709:b0:2c6:6d6e:6dac with SMTP id u9-20020a056e02170900b002c66d6e6dacmr19664334ill.53.1647289436933;
        Mon, 14 Mar 2022 13:23:56 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g10-20020a056e021a2a00b002c780e4f32esm5711362ile.62.2022.03.14.13.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 13:23:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     syzbot+b42749a851a47a0f581b@syzkaller.appspotmail.com,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org
In-Reply-To: <20220314043018.177141-1-ming.lei@redhat.com>
References: <20220314043018.177141-1-ming.lei@redhat.com>
Subject: Re: [PATCH] block: release rq qos structures for queue without disk
Message-Id: <164728943636.144820.16345673188217476627.b4-ty@kernel.dk>
Date:   Mon, 14 Mar 2022 14:23:56 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Mar 2022 12:30:18 +0800, Ming Lei wrote:
> blkcg_init_queue() may add rq qos structures to request queue, previously
> blk_cleanup_queue() calls rq_qos_exit() to release them, but commit
> 8e141f9eb803 ("block: drain file system I/O on del_gendisk")
> moves rq_qos_exit() into del_gendisk(), so memory leak is caused
> because queues may not have disk, such as un-present scsi luns, nvme
> admin queue, ...
> 
> [...]

Applied, thanks!

[1/1] block: release rq qos structures for queue without disk
      commit: daaca3522a8e67c46e39ef09c1d542e866f85f3b

Best regards,
-- 
Jens Axboe


