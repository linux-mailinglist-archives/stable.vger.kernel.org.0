Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6477A65EA32
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 12:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbjAELtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 06:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbjAELth (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 06:49:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B8A3056F
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 03:49:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 289C2B819BC
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 11:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922DCC433EF;
        Thu,  5 Jan 2023 11:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672919373;
        bh=ReRb5rRfkG0W5qU/URunlcYMQ+6LCsuNJ1tMpIrDTFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yZmO8clKXNDXV6E+QB3RmUYb1+T75n2d+9GabRIIIc0fGIH11asUNR87m1qA3krGg
         4cmh9VKMnExyQLNruCBD3U+MY2Of4WHZ8+UQvABYz+/A2cdrJIJaJMtKinV4rEs7DG
         uk2fRuEJNOt58AAQVeSGx9oNrdJeaBDZ/wuNv3pU=
Date:   Thu, 5 Jan 2023 12:49:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] block: mq-deadline: Fix dd_finish_request() for zoned
 devices
Message-ID: <Y7a5SuwQZMB+Q+mr@kroah.com>
References: <167284210313124@kroah.com>
 <20230105040756.579794-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105040756.579794-1-damien.lemoal@opensource.wdc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 01:07:56PM +0900, Damien Le Moal wrote:
> commit 2820e5d0820ac4daedff1272616a53d9c7682fd2 upstream.
> 
> dd_finish_request() tests if the per prio fifo_list is not empty to
> determine if request dispatching must be restarted for handling blocked
> write requests to zoned devices with a call to
> blk_mq_sched_mark_restart_hctx(). While simple, this implementation has
> 2 problems:
> 
> 1) Only the priority level of the completed request is considered.
>    However, writes to a zone may be blocked due to other writes to the
>    same zone using a different priority level. While this is unlikely to
>    happen in practice, as writing a zone with different IO priorirites
>    does not make sense, nothing in the code prevents this from
>    happening.
> 2) The use of list_empty() is dangerous as dd_finish_request() does not
>    take dd->lock and may run concurrently with the insert and dispatch
>    code.
> 
> Fix these 2 problems by testing the write fifo list of all priority
> levels using the new helper dd_has_write_work(), and by testing each
> fifo list using list_empty_careful().
> 
> Fixes: c807ab520fc3 ("block/mq-deadline: Add I/O priority support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Link: https://lore.kernel.org/r/20221124021208.242541-2-damien.lemoal@opensource.wdc.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  block/mq-deadline.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)

Now queued up, thanks.

greg k-h
