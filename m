Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A85600B39
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 11:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiJQJpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 05:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiJQJpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 05:45:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DCA269
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 02:45:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77C54B80B37
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 09:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D58C433C1;
        Mon, 17 Oct 2022 09:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665999900;
        bh=nJku4sclQfCwp3CrmjgF3fmMEQMG0ZpRK63jQ68VUUc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ESlaqhE9Zirj42VD9bigdRVNJQ4Ecf5z/6RtVv6vF0tsEmx76Yoz5xZo7svg8NrxG
         vZNCzeVD/3DVL4IvXKVuJh4sE1vhaMHB4FhZ/nxjHdL7EwiX2HznYCL+BKy4VwsUCQ
         lUT5UeGt+LnQeZeOFacolO7Pm11AgDVjvnnMeDjI=
Date:   Mon, 17 Oct 2022 11:45:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-5.4 1/1] io_uring/af_unix: defer registered files
 gc to io_uring release
Message-ID: <Y00kS9AwCkio6/BF@kroah.com>
References: <84f1ec07537215261750d29ac6353fcfca8674e1.1665961345.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84f1ec07537215261750d29ac6353fcfca8674e1.1665961345.git.asml.silence@gmail.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 12:03:11AM +0100, Pavel Begunkov wrote:
> [ upstream commit 0091bfc81741b8d3aeb3b7ab8636f911b2de6e80 ]
> 
> Instead of putting io_uring's registered files in unix_gc() we want it
> to be done by io_uring itself. The trick here is to consider io_uring
> registered files for cycle detection but not actually putting them down.
> Because io_uring can't register other ring instances, this will remove
> all refs to the ring file triggering the ->release path and clean up
> with io_ring_ctx_free().
> 
> Cc: stable@vger.kernel.org
> Fixes: 6b06314c47e1 ("io_uring: add file set registration")
> Reported-and-tested-by: David Bouman <dbouman03@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> [axboe: add kerneldoc comment to skb, fold in skb leak fix]
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c          |  1 +
>  include/linux/skbuff.h |  2 ++
>  net/unix/garbage.c     | 20 ++++++++++++++++++++
>  3 files changed, 23 insertions(+)

Now queued up, thanks.

greg k-h
