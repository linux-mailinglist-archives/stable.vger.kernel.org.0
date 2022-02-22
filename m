Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6DB4BF1B5
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 06:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiBVFvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 00:51:38 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiBVFvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 00:51:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFE0BA4
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 21:51:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D983CB81256
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 05:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4633C340E8;
        Tue, 22 Feb 2022 05:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645509070;
        bh=bLIc3dD7WqiBZmwfEBk8Ij8AI95/OewnepBI/e5b+Oo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VeOQm6LPAKR8VwQdXSMUeVeiMURnIxitcuC+ezjwUkrjAhI8Yqygl8RYd8YrhI0xF
         o9VrY43qTD4IKWQioxfAuNS8gZYUZMis9E0mdlHphTYK9uF4oqGFAZb3rlckCtI2aP
         stdTARSSlqA0mahTfZTyOD5VkYQSJVy1uE9b7h3s=
Date:   Tue, 22 Feb 2022 06:51:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Lars Persson <larper@axis.com>
Subject: Re: [PATCH backport 5.10 v2] optee: use driver internal tee_context
 for some rpc
Message-ID: <YhR5y0gMli/ko2D8@kroah.com>
References: <20220221223945.1482216-1-jens.wiklander@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221223945.1482216-1-jens.wiklander@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 11:39:45PM +0100, Jens Wiklander wrote:
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
> Hi,
> 
> This is an update to the previous patch posted with the same name.

What changed in v2?
