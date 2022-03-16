Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62A74DB654
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 17:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349863AbiCPQjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 12:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350386AbiCPQjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 12:39:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEB31EAC8;
        Wed, 16 Mar 2022 09:38:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35BA3B81C00;
        Wed, 16 Mar 2022 16:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708E4C340EC;
        Wed, 16 Mar 2022 16:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647448702;
        bh=QRb9iay02/ip8ur1u1poArBgqT5E3Mi+3WJnvg49UO8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yPRVDDB8SgZbkbzvlN5wPbOea4BqYqBqAwe2x9yNHc9Axa+LSloUJdNeEQRNL+MUE
         mpRb2oyeF6rlVKAqTvGBjjILwyn5xWKw8s9nNsPyJz4jxb0I+GjdOZ9mNmNRhmCay4
         Kf3Fpwsf/FJaqsYV9/ZLUqas0GAa00Oz3dg4cVWE=
Date:   Wed, 16 Mar 2022 17:38:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: return back safer resurrect
Message-ID: <YjISer/xC0/ZEh/1@kroah.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
 <7a080c20f686d026efade810b116b72f88abaff9.1618101759.git.asml.silence@gmail.com>
 <YjINyFwcvPs+a8uq@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjINyFwcvPs+a8uq@google.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 16, 2022 at 04:18:16PM +0000, Lee Jones wrote:
> Stable Team,
> 
> > Revert of revert of "io_uring: wait potential ->release() on resurrect",
> > which adds a helper for resurrect not racing completion reinit, as was
> > removed because of a strange bug with no clear root or link to the
> > patch.
> > 
> > Was improved, instead of rcu_synchronize(), just wait_for_completion()
> > because we're at 0 refs and it will happen very shortly. Specifically
> > use non-interruptible version to ignore all pending signals that may
> > have ended prior interruptible wait.
> > 
> > This reverts commit cb5e1b81304e089ee3ca948db4d29f71902eb575.
> > 
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > ---
> >  fs/io_uring.c | 18 ++++++++++++++----
> >  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> Please back-port this as far as it will apply.
> 
> Definitely through v5.10.y.
> 
> It solves a critical bug.
> 
> Subject: "io_uring: return back safer resurrect"
> 
> Upstream commit:: f70865db5ff35f5ed0c7e9ef63e7cca3d4947f04

It only applies to 5.10.y.  It showed up in 5.12, so if you want it
further back than 5.10.y, can you provide a working backport?

thanks,

greg k-h
