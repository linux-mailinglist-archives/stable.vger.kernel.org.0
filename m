Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF16B561B3D
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbiF3NYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiF3NYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:24:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122AE30F5B
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 06:24:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4658B82AC1
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 13:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8E9C34115;
        Thu, 30 Jun 2022 13:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656595441;
        bh=m+MlfyxVQ7wL9GGWqN/MjZ829vFNOaYVlTqOQG1SabQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FmlZeH9C5/S5fcMzI4NECbgNBB8L2TTNVFmbWau6jA4gWyHh2YADkZ1MH09wNn2eY
         /IUDW3khaf6K0MkOGZZtRXPTCh2pQZPmwdqcr5CFnsRzRLMXj5g+wlTwKQGLQrg0jS
         1KLTLEw5upBM8pCBPRrXubqwcjjvOxZdTW7ki1Vc=
Date:   Thu, 30 Jun 2022 15:23:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-5.15] io_uring: fix not locked access to fixed buf
 table
Message-ID: <Yr2j7rMISraubCIK@kroah.com>
References: <38d217692f3247110ce26e60b01f4eadd866757b.1656541986.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38d217692f3247110ce26e60b01f4eadd866757b.1656541986.git.asml.silence@gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 29, 2022 at 11:33:36PM +0100, Pavel Begunkov wrote:
> [ upstream commit 05b538c1765f8d14a71ccf5f85258dcbeaf189f7 ]
> 
> We can look inside the fixed buffer table only while holding
> ->uring_lock, however in some cases we don't do the right async prep for
> IORING_OP_{WRITE,READ}_FIXED ending up with NULL req->imu forcing making
> an io-wq worker to try to resolve the fixed buffer without proper
> locking.
> 
> Move req->imu setup into early req init paths, i.e. io_prep_rw(), which
> is called unconditionally for rw requests and under uring_lock.
> 
> Fixes: 634d00df5e1cf ("io_uring: add full-fledged dynamic buffers support")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 

Both backports now queued up, thanks.

greg k-h
