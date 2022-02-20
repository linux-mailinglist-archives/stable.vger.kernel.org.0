Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBD44BCE2F
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 12:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbiBTLhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 06:37:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiBTLg7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 06:36:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70E7A183
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 03:36:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2D11B80CF0
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 11:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E4AC340E8;
        Sun, 20 Feb 2022 11:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645356996;
        bh=bFMZcQHWeYmQBNG0A/d5LOwzsZSEyJhIqBAZcW4IGJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xRKHpAE2biPCHiYRlxUaHZ9ACJmEui7bmnjXC7+iUjOd8dwy1MkVq1UhQSkrr9O3b
         yNL0ko5NnsI3K3n4jTqgEfGX7BbYsWA5FTnLy2kt4+EAi7ShPkcS9Ld4VXAVJXAUG/
         xIb9vKvTd3DNoTGUU1wsfD45+kro5fIwNzY5P28o=
Date:   Sun, 20 Feb 2022 12:36:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Lars Persson <larper@axis.com>
Subject: Re: [PATCH backport 5.10] optee: use driver internal tee_context for
 some rpc
Message-ID: <YhInwekLNcejxira@kroah.com>
References: <20220218131549.712802-1-jens.wiklander@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218131549.712802-1-jens.wiklander@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 02:15:49PM +0100, Jens Wiklander wrote:
> commit aceeafefff736057e8f93f19bbfbef26abd94604 upstream
> 
> Adds a driver private tee_context to struct optee.
> 
> The new driver internal tee_context is used when allocating driver
> private shared memory. This decouples the shared memory object from its
> original tee_context. This is needed when the life time of such a memory
> allocation outlives the client tee_context.
> 
> This patch fixes the problem described below:
> 
> The addition of a shutdown hook by commit f25889f93184 ("optee: fix tee out
> of memory failure seen during kexec reboot") introduced a kernel shutdown
> regression that can be triggered after running the OP-TEE xtest suites.
> 
> Once the shutdown hook is called it is not possible to communicate any more
> with the supplicant process because the system is not scheduling task any
> longer. Thus if the optee driver shutdown path receives a supplicant RPC
> request from the OP-TEE we will deadlock the kernel's shutdown.
> 
> Fixes: f25889f93184 ("optee: fix tee out of memory failure seen during kexec reboot")
> Fixes: 217e0250cccb ("tee: use reference counting for tee_context")
> Reported-by: Lars Persson <larper@axis.com>
> Cc: stable@vger.kernel.org # 1e2c3ef0496e tee: export teedev_open() and teedev_close_context()
> Cc: stable@vger.kernel.org
> Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
> [JW: backport to 5.10-stable + update commit message]
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> ---
>  drivers/tee/optee/core.c          | 8 ++++++++
>  drivers/tee/optee/optee_private.h | 2 ++
>  drivers/tee/optee/rpc.c           | 8 +++++---
>  3 files changed, 15 insertions(+), 3 deletions(-)

Now queued up, thanks.

greg k-h
