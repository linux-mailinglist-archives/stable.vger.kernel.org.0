Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6255524EFB7
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 22:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgHWUnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 16:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgHWUnL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Aug 2020 16:43:11 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BA7C20774;
        Sun, 23 Aug 2020 20:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598215390;
        bh=NK/X9Ulv7PcHHH2x0gj5xA39roeB65MyjwtzNvAPt/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QK6vDAOapxuz2sfNXnLXHALHGjX+aIWGa/TEanRq6zSlp9uqfU6e0DBisqumkjm0B
         pFeE1XRPHFuGwpvZqYEI/ihyj99yNj900jnEzb498J7tLHBBdI0UoWGW/e3nGIWs1z
         ki3zfOSLmXJ7fHmF32Q4ReEVuKwkCZXPlIvfXdwY=
Date:   Sun, 23 Aug 2020 16:43:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     gregkh@linuxfoundation.org, asml.silence@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: find and cancel head link async
 work on files exit" failed to apply to 5.7-stable tree
Message-ID: <20200823204309.GF8670@sasha-vm>
References: <159818496684216@kroah.com>
 <5e0d43b1-f2ed-3faa-cb30-8cacd5f16faa@kernel.dk>
 <fcf3384c-956e-8310-d0d6-1ac8e1f66ebe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <fcf3384c-956e-8310-d0d6-1ac8e1f66ebe@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 23, 2020 at 02:04:25PM -0600, Jens Axboe wrote:
>On 8/23/20 7:48 AM, Jens Axboe wrote:
>> On 8/23/20 6:16 AM, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 5.7-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>
>> This needs this one backported:
>>
>> commit 4f26bda1522c35d2701fc219368c7101c17005c1
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Mon Jun 15 10:24:03 2020 +0300
>>
>>     io-wq: add an option to cancel all matched reqs
>>
>> I'll take a look later today, unless Pavel beats me to it.
>
>OK, you just need to cherry pick this one:
>
>commit f4c2665e33f48904f2766d644df33fb3fd54b5ec
>Author: Pavel Begunkov <asml.silence@gmail.com>
>Date:   Mon Jun 15 10:24:02 2020 +0300
>
>    io-wq: reorder cancellation pending -> running
>
>and then cherry pick this one:
>
>commit 4f26bda1522c35d2701fc219368c7101c17005c1
>Author: Pavel Begunkov <asml.silence@gmail.com>
>Date:   Mon Jun 15 10:24:03 2020 +0300
>
>    io-wq: add an option to cancel all matched reqs
>
>and then the patch will apply directly without needing any sort of
>massaging. Looking at that series, please pick this one as well (either
>at the end, or after the first two):
>
>commit 44e728b8aae0bb6d4229129083974f9dea43f50b
>Author: Pavel Begunkov <asml.silence@gmail.com>
>Date:   Mon Jun 15 10:24:04 2020 +0300
>
>    io_uring: cancel all task's requests on exit

Done, thanks!

-- 
Thanks,
Sasha
