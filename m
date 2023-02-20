Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B92969D1AA
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 17:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjBTQr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 11:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbjBTQr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 11:47:27 -0500
Received: from soltyk.jannau.net (soltyk.jannau.net [144.76.91.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDA340E8
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 08:46:53 -0800 (PST)
Received: by soltyk.jannau.net (Postfix, from userid 1000)
        id 42F3226F7BB; Mon, 20 Feb 2023 17:45:59 +0100 (CET)
Date:   Mon, 20 Feb 2023 17:45:59 +0100
From:   Janne Grunau <j@jannau.net>
To:     gregkh@linuxfoundation.org
Cc:     hch@lst.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] nvme-apple: reset controller during
 shutdown" failed to apply to 6.1-stable tree
Message-ID: <20230220164559.GA24656@jannau.net>
References: <1676893225104207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1676893225104207@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hej,

On 2023-02-20 12:40:25 +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Why was this patch even considered for the 6.1-stable tree? Its "Fixes:" 
tag references a commit which only appeared in v6.2-rc1.

There is no need to backport this to any stable tree.

The message suggest that ignoring this would have been fine but it seems 
worthwhile to report a potential bug or ommission in the stable backport 
tooling.

> Possible dependencies:
> 
> c06ba7b892a5 ("nvme-apple: reset controller during shutdown")

certainly doesn't depend on itself

...

> c76b8308e4c9 ("nvme-apple: fix controller shutdown in apple_nvme_disable")

commit from "Fixes:"

...

If this is intended since "Fixes:" tags are in general not relieable 
enough to decide to which trees regression fixes have to be applied to 
that's acceptable

ciao

Janne

> ------------------ original commit in Linus's tree ------------------
> 
> From c06ba7b892a50b48522ad441a40053f483dfee9e Mon Sep 17 00:00:00 2001
> From: Janne Grunau <j@jannau.net>
> Date: Tue, 17 Jan 2023 19:25:00 +0100
> Subject: [PATCH] nvme-apple: reset controller during shutdown
> 
> This is a functional revert of c76b8308e4c9 ("nvme-apple: fix controller
> shutdown in apple_nvme_disable").
> 
> The commit broke suspend/resume since apple_nvme_reset_work() tries to
> disable the controller on resume. This does not work for the apple NVMe
> controller since register access only works while the co-processor
> firmware is running.
> 
> Disabling the NVMe controller in the shutdown path is also required
> for shutting the co-processor down. The original code was appropriate
> for this hardware. Add a comment to prevent a similar breaking changes
> in the future.
> 
> Fixes: c76b8308e4c9 ("nvme-apple: fix controller shutdown in apple_nvme_disable")
> Reported-by: Janne Grunau <j@jannau.net>
> Link: https://lore.kernel.org/all/20230110174745.GA3576@jannau.net/
> Signed-off-by: Janne Grunau <j@jannau.net>
> [hch: updated with a more descriptive comment from Hector Martin]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
> index bf1c60edb7f9..146c9e63ce77 100644
> --- a/drivers/nvme/host/apple.c
> +++ b/drivers/nvme/host/apple.c
> @@ -829,7 +829,23 @@ static void apple_nvme_disable(struct apple_nvme *anv, bool shutdown)
>  			apple_nvme_remove_cq(anv);
>  		}
>  
> -		nvme_disable_ctrl(&anv->ctrl, shutdown);
> +		/*
> +		 * Always disable the NVMe controller after shutdown.
> +		 * We need to do this to bring it back up later anyway, and we
> +		 * can't do it while the firmware is not running (e.g. in the
> +		 * resume reset path before RTKit is initialized), so for Apple
> +		 * controllers it makes sense to unconditionally do it here.
> +		 * Additionally, this sequence of events is reliable, while
> +		 * others (like disabling after bringing back the firmware on
> +		 * resume) seem to run into trouble under some circumstances.
> +		 *
> +		 * Both U-Boot and m1n1 also use this convention (i.e. an ANS
> +		 * NVMe controller is handed off with firmware shut down, in an
> +		 * NVMe disabled state, after a clean shutdown).
> +		 */
> +		if (shutdown)
> +			nvme_disable_ctrl(&anv->ctrl, shutdown);
> +		nvme_disable_ctrl(&anv->ctrl, false);
>  	}
>  
>  	WRITE_ONCE(anv->ioq.enabled, false);
> 
