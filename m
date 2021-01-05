Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3E32EB2AE
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 19:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbhAESgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 13:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbhAESgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 13:36:15 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8495CC061795
        for <stable@vger.kernel.org>; Tue,  5 Jan 2021 10:35:35 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id q1so620117ilt.6
        for <stable@vger.kernel.org>; Tue, 05 Jan 2021 10:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WfmCKsV1w0JUF2QRxfEJ48eLQ078CnWCUJqZyL3Kbng=;
        b=rCa/G3QtmIf2y4BArqWZtVw8fuWX3ThfKx0r7WIxQNsSMHuVVuS85pLo2eJNPzq/G2
         WU5DeOfKL/d+mdvfNzTDU1+x6asCM3ueBS/I6OSyOtfHyvdcqzPuMGQ2rkehRl47zsJy
         y4d6EzgDNiw/Op0PMX5YHl/3t+SHZYaTgsrFGwRst7QkKBxjBQq17i7QmPuKS+r02ZYn
         DhPA38BSi9YU3FLU+MPJ2AG6ND/6Z7RAERS63FEBuKbsm5h+gUF0g5O1gPVTobC0YH0D
         RcuUl6cIjXNQpbiBTsu6NYh5tJQQ2EMKpnY2BhLib0BO1HFSeDg5Pt2Kh1L2zHHpQ/8S
         b5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WfmCKsV1w0JUF2QRxfEJ48eLQ078CnWCUJqZyL3Kbng=;
        b=Z1FBwEtFehyqU8Ci5YW85bTwduSnX+b4dIq/NY9SeaVGqcsVxEQ5h3rdhkKy+c0yq+
         aPz2nP/F0OWyCLPqnPFFfz6XUyg1wD6YwSYemFBJFeVG19ALH+JkUE4sj6jTBK0lJLB5
         hG4zXGvROXj7GWvYPjZgJVloNCDlURmupjB52SggHf9r4bHgpGPE6LOKsgPj4ZS3Ll0w
         9qxdKEcZII5G36jOIv4TUd6l/A+6PLLrTsk0ZUhYvX+OvIQz8E1gtzlOG0RdiN08wyRx
         E8tGiWqKZpaOh7mZcPfDWkdB4F9+Wig3/HUwJD/R3tLTxObf1B/QTKv8HmAKJADnu6n0
         flvg==
X-Gm-Message-State: AOAM533NnUPurllk2+G36UKH/rqyZPETNI+vhmEFJ0CDVUQPSxEe2Drl
        81dclW7wHvFGxdqWdfZveKlCGw==
X-Google-Smtp-Source: ABdhPJzsUG1CkQ0ckjLx1Hj7liQGqnIgWBDT2gTlQjk9E5MWh+DRFpuGKpf31r5ZtYxgqyfRJkoZAQ==
X-Received: by 2002:a92:c986:: with SMTP id y6mr925153iln.57.1609871734975;
        Tue, 05 Jan 2021 10:35:34 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s1sm60843iot.0.2021.01.05.10.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 10:35:34 -0800 (PST)
Subject: Re: [PATCH] block: fix use-after-free in disk_part_iter_next
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org,
        syzbot+825f0f9657d4e528046e@syzkaller.appspotmail.com
References: <20201221043335.2831589-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5ca75477-ca88-01a1-1581-ad2e8ecf3804@kernel.dk>
Date:   Tue, 5 Jan 2021 11:35:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201221043335.2831589-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/20/20 9:33 PM, Ming Lei wrote:
> Make sure that bdgrab() is done on the 'block_device' instance before
> referring to it for avoiding use-after-free.

Applied, thanks.

-- 
Jens Axboe

