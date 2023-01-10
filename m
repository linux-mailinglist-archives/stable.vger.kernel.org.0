Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A254D664470
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 16:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238777AbjAJPUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 10:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbjAJPTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 10:19:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2992D5C1EF;
        Tue, 10 Jan 2023 07:19:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB760B81731;
        Tue, 10 Jan 2023 15:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAA2C433F0;
        Tue, 10 Jan 2023 15:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673363991;
        bh=eo9TFkkF19HVlM3o4QpdLSsi0wJXq0jNn4MmAXxKsPE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XCbb2JpewK0YgB59TKO+QL7EUH6xCmoLRrtU0YpOeBwPX3RmV5rWR4XVpP6i2nfhL
         Ew6wMSRnOIbtUK3wOut1ugWrGxgis4ghq7B3MkrvT7wwPdy2uABE87UYiNDdrTuIMj
         Uu12qYYRill++Cfup9uVGbpf2RWcwJ+uchuOr1ZY=
Date:   Tue, 10 Jan 2023 16:19:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dan Carpenter <error27@gmail.com>,
        Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [PATCH 5.15 514/530] io_uring/rw: fix errored retry return values
Message-ID: <Y72CE2SkKR4CHW9G@kroah.com>
References: <20221024113044.976326639@linuxfoundation.org>
 <20221024113108.274007846@linuxfoundation.org>
 <9ae29224-beff-66b1-cfcd-881bd5351e1c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ae29224-beff-66b1-cfcd-881bd5351e1c@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 08:36:00PM +0530, Harshit Mogalapalli wrote:
> 
> Hi Greg,
> 
> On 24/10/22 5:04 pm, Greg Kroah-Hartman wrote:
> > From: Pavel Begunkov <asml.silence@gmail.com>
> > 
> > [ upstream commit 62bb0647b14646fa6c9aa25ecdf67ad18f13523c ]
> > 
> 
> This commit 62bb0647b14646fa6c9aa25ecdf67ad18f13523 also changes second
> argument from unsigned to long.
> 
> > Kernel test robot reports that we test negativity of an unsigned in
> > io_fixup_rw_res() after a recent change, which masks error codes and
> > messes up the return value in case I/O is re-retried and failed with
> > an error.
> > 
> > Fixes: 4d9cb92ca41dd ("io_uring/rw: fix short rw error handling")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > Link: https://lore.kernel.org/r/9754a0970af1861e7865f9014f735c70dc60bf79.1663071587.git.asml.silence@gmail.com
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   fs/io_uring.c |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -2701,7 +2701,7 @@ static bool __io_complete_rw_common(stru
> >   	return false;
> >   }
> > -static inline unsigned io_fixup_rw_res(struct io_kiocb *req, unsigned res)
> > +static inline int io_fixup_rw_res(struct io_kiocb *req, unsigned res)
> >   {
> 
> I think the res should be of type 'long'.
> I noticed this when I ran smatch on 5.10.y io_uring backport from 5.15.y
> patch.
> 
> Smatch warning: io_fixup_rw_res() warn: unsigned 'res' is never less than
> zero.
> 
> static inline int io_fixup_rw_res(struct io_kiocb *req, unsigned res)
> {
>         struct io_async_rw *io = req->async_data;
> 
>         /* add previously done IO, if any */
>         if (io && io->bytes_done > 0) {
>                 if (res < 0) //// unsigned comparison with zero.
>                         res = io->bytes_done;
>                 else
>                         res += io->bytes_done;
>         }
>         return res;
> }
> 
> We don't have upstream commit to backport in this case. Should we fix this
> with no-upstream reference commit?

Just reference the commit that this fixes properly and that should be
fine, thanks for the review and catching this!

greg k-h
