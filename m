Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10FB5313FD
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbiEWPNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 11:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237687AbiEWPNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 11:13:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C264C407;
        Mon, 23 May 2022 08:13:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F2246126D;
        Mon, 23 May 2022 15:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F7CC34119;
        Mon, 23 May 2022 15:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653318803;
        bh=uO25Tzc06fqGR87hf2VJ5iR4cfjKvSlQqYudM+ajRcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mGTmjfMY0StxAmJQgb1MJIGv+3trot1pf+C/KC2Utl4oo0QdXUOd0TQ+khBB9XoAV
         YoScFeKFDjhlNftEGpssq/07h/NtETt14aQMuLlSOp5Z9M3ZWW80gScnn3k7Uxm+p+
         mD2mq9BDlajh1iZZNvPBeCzaik4T4bEWpFhaKFHE=
Date:   Mon, 23 May 2022 17:13:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gwendal Grignou <gwendal@chromium.org>
Cc:     paolo.valente@linaro.org, axboe@kernel.dk, xieyongji@bytedance.com,
        ming.lei@redhat.com, linux-block@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        stable@vger.kernel.org
Subject: Re: [PATCH] block: return ELEVATOR_DISCARD_MERGE if possible
Message-ID: <Youkj8RWDNlpNUnL@kroah.com>
References: <20220521185626.3333530-1-gwendal@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220521185626.3333530-1-gwendal@chromium.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 21, 2022 at 11:56:26AM -0700, Gwendal Grignou wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> When merging one bio to request, if they are discard IO and the queue
> supports multi-range discard, we need to return ELEVATOR_DISCARD_MERGE
> because both block core and related drivers(nvme, virtio-blk) doesn't
> handle mixed discard io merge(traditional IO merge together with
> discard merge) well.
> 
> Fix the issue by returning ELEVATOR_DISCARD_MERGE in this situation,
> so both blk-mq and drivers just need to handle multi-range discard.
> 
> Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Fixes: 2705dfb20947 ("block: fix discard request merge")
> Link: https://lore.kernel.org/r/20210729034226.1591070-1-ming.lei@redhat.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> commit 866663b7b52d2 upstream.
> 
> Similar to commit 87aa69aa10b42 ("block: return ELEVATOR_DISCARD_MERGE if possible")
> in 5.10 kernel.
> 
> Conflicts:
>    block/blk-merge.c: function at a different place.
>    block/mq-deadline-main.c: not in 5.4, use mq-deadline.c instead.
> 
> Cc: <stable@vger.kernel.org> # 5.4.y
> Signed-off-by: Gwendal Grignou <gwendal@chromium.org>

Now queued up, thanks.

greg k-h
