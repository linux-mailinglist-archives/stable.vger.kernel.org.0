Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5B55FDE32
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 18:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJMQVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 12:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiJMQVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 12:21:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBF4E09D3
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 09:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4DF8B81D51
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 16:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DA9C433C1;
        Thu, 13 Oct 2022 16:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665678091;
        bh=9FuP1fI9rX5vnl4wS6/L8oY9mvho5Hrdt25yyBXhuXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BCqXNSJO0ImSBZsnCgHb9ORgPfRcX7jpEev3zQEr/lMrwFm94IR5Egx8HDnfoHfc2
         d6lr6jqz8PaupehxzoIAr0mZrY/pZko486MV1ZFxvwYU8k9pcI/f/Cst2WVfUaj+8B
         OqA2Gc/5XPW6ftGzaH0utO/5GpTSSzYwxft1xnTw=
Date:   Thu, 13 Oct 2022 18:22:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 1/3] random: restore O_NONBLOCK support
Message-ID: <Y0g7N95gKNFMJZ72@kroah.com>
References: <20221013153654.1397691-1-Jason@zx2c4.com>
 <20221013153654.1397691-2-Jason@zx2c4.com>
 <Y0g6utImsSCDJuio@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y0g6utImsSCDJuio@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 06:20:10PM +0200, Greg KH wrote:
> On Thu, Oct 13, 2022 at 09:36:52AM -0600, Jason A. Donenfeld wrote:
> > commit cd4f24ae9404fd31fc461066e57889be3b68641b upstream.
> > 
> > Prior to 5.6, when /dev/random was opened with O_NONBLOCK, it would
> > return -EAGAIN if there was no entropy. When the pools were unified in
> > 5.6, this was lost. The post 5.6 behavior of blocking until the pool is
> > initialized, and ignoring O_NONBLOCK in the process, went unnoticed,
> > with no reports about the regression received for two and a half years.
> > However, eventually this indeed did break somebody's userspace.
> > 
> > So we restore the old behavior, by returning -EAGAIN if the pool is not
> > initialized. Unlike the old /dev/random, this can only occur during
> > early boot, after which it never blocks again.
> > 
> > In order to make this O_NONBLOCK behavior consistent with other
> > expectations, also respect users reading with preadv2(RWF_NOWAIT) and
> > similar.
> > 
> > Fixes: 30c08efec888 ("random: make /dev/random be almost like /dev/urandom")
> > Reported-by: Guozihua <guozihua@huawei.com>
> > Reported-by: Zhongguohua <zhongguohua1@huawei.com>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Theodore Ts'o <tytso@mit.edu>
> > Cc: Andrew Lutomirski <luto@kernel.org>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
> >  drivers/char/mem.c    | 4 ++--
> >  drivers/char/random.c | 5 +++++
> >  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> Still breaks on older kernels:
> 
> drivers/char/random.c: In function ‘random_read_iter’:
> drivers/char/random.c:1299:33: error: ‘IOCB_NOWAIT’ undeclared (first use in this function); did you mean ‘IPC_NOWAIT’?
>  1299 |             ((kiocb->ki_flags & IOCB_NOWAIT) ||
>       |                                 ^~~~~~~~~~~
>       |                                 IPC_NOWAIT
> drivers/char/random.c:1299:33: note: each undeclared identifier is reported only once for each function it appears in
> drivers/char/mem.c:872:48: error: ‘FMODE_NOWAIT’ undeclared here (not in a function); did you mean ‘FOLL_NOWAIT’?
>   872 |          [8] = { "random", 0666, &random_fops, FMODE_NOWAIT },
>       |                                                ^~~~~~~~~~~~
>       |                                                FOLL_NOWAIT
> 

Hm, that's only broken on 4.9, the other ones it worked, now queued up
for 4.14, 4.19, and 5.4, thanks.

greg k-h
