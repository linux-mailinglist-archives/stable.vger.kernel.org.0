Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF1C56AA38
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 20:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiGGSGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 14:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235933AbiGGSGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 14:06:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CDF27CC0
        for <stable@vger.kernel.org>; Thu,  7 Jul 2022 11:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95F2BB822B2
        for <stable@vger.kernel.org>; Thu,  7 Jul 2022 18:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D317EC341C0;
        Thu,  7 Jul 2022 18:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657217206;
        bh=0syJuJlZwKEdbzUnY1BqXiNZo9DlNrYFt+Zsd4I6NWE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SV8GsE4yy5n3+2KlayjjYa7jTlUcPo2lOcBUpqKDZ5W230eJcLIJmzAaNsERIxSKe
         Y5czKS0v53G6x+TwurfJ0kU/EhXsFhApKiiqaUYRl18oXaLx+SoNnljoaXXKqqrUUo
         OkdQmlVHBPuUIiotyudCUvCe/v9/1H1bcJAgrsR0=
Date:   Thu, 7 Jul 2022 20:06:43 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dylan Yudaken <dylany@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] io_uring: fix provided buffer import"
 failed to apply to 5.18-stable tree
Message-ID: <Yscgs5Uan6gruGOL@kroah.com>
References: <1656941060218130@kroah.com>
 <459dd43dc3f05e34eaf520752f3eb46daacd536a.camel@fb.com>
 <7fc4edd2-e394-6dfc-dd81-b2cad102dca0@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fc4edd2-e394-6dfc-dd81-b2cad102dca0@kernel.dk>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 05, 2022 at 08:38:19AM -0600, Jens Axboe wrote:
> On 7/5/22 8:36 AM, Dylan Yudaken wrote:
> > On Mon, 2022-07-04 at 15:24 +0200, gregkh@linuxfoundation.org wrote:
> >>
> >> The patch below does not apply to the 5.18-stable tree.
> >> If someone wants it applied there, or to any other stable or longterm
> >> tree, then please email the backport, including the original git
> >> commit
> >> id to <stable@vger.kernel.org>.
> >>
> >> thanks,
> >>
> >> greg k-h
> >>
> >> ------------------ original commit in Linus's tree ------------------
> >>
> >> From 09007af2b627f0f195c6c53c4829b285cc3990ec Mon Sep 17 00:00:00
> >> 2001
> >> From: Dylan Yudaken <dylany@fb.com>
> >> Date: Thu, 30 Jun 2022 06:20:06 -0700
> >> Subject: [PATCH] io_uring: fix provided buffer import
> >>
> >> io_import_iovec uses the s pointer, but this was changed immediately
> >> after the iovec was re-imported and so it was imported into the wrong
> >> place.
> >>
> >> Change the ordering.
> >>
> >> Fixes: 2be2eb02e2f5 ("io_uring: ensure reads re-import for selected
> >> buffers")
> >> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> >> Link:
> >> https://lore.kernel.org/r/20220630132006.2825668-1-dylany@fb.com
> >> [axboe: ensure we don't half-import as well]
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>
> >> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >> index aeb042ba5cc5..0d491ad15b66 100644
> >> --- a/fs/io_uring.c
> >> +++ b/fs/io_uring.c
> >> @@ -4318,18 +4318,19 @@ static int io_read(struct io_kiocb *req,
> >> unsigned int issue_flags)
> >>                 if (unlikely(ret < 0))
> >>                         return ret;
> >>         } else {
> >> +               rw = req->async_data;
> >> +               s = &rw->s;
> >> +
> >>                 /*
> >>                  * Safe and required to re-import if we're using
> >> provided
> >>                  * buffers, as we dropped the selected one before
> >> retry.
> >>                  */
> >> -               if (req->flags & REQ_F_BUFFER_SELECT) {
> >> +               if (io_do_buffer_select(req)) {
> >>                         ret = io_import_iovec(READ, req, &iovec, s,
> >> issue_flags);
> >>                         if (unlikely(ret < 0))
> >>                                 return ret;
> >>                 }
> >>  
> >> -               rw = req->async_data;
> >> -               s = &rw->s;
> >>                 /*
> >>                  * We come here from an earlier attempt, restore our
> >> state to
> >>                  * match in case it doesn't. It's cheap enough that
> >> we don't
> >>
> > 
> > Hi,
> > 
> > I have attached a fixed patch which fixes the problem on 5.18
> 
> Looks good to me, thanks Dylan!

Now queued up, thanks.

greg k-h
