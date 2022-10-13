Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5AD5FDE1A
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 18:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiJMQT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 12:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiJMQT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 12:19:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00191382D6
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 09:19:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C8816173A
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 16:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD65C433D6;
        Thu, 13 Oct 2022 16:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665677966;
        bh=9unufc0GmS0V4TPu72uaUpjrVNPAcjjbH6GrMX5K4m4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vVqbxYPbYWewMQXWvcIUQ+JCBIBLGarNJF25Xx086TrtPfV6L9rsswHoU+VVu8FNC
         Wigs+DDMRZkk5C3pk/8eVzlkqIFeHhLZ3aHoU5ca0TaHEe8aqdBNJGiYW2xmUq93kG
         TPu7kUO4IwaCj0HI5iTT/ChZL5sk4Wqg9o6GJlBI=
Date:   Thu, 13 Oct 2022 18:20:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 1/3] random: restore O_NONBLOCK support
Message-ID: <Y0g6utImsSCDJuio@kroah.com>
References: <20221013153654.1397691-1-Jason@zx2c4.com>
 <20221013153654.1397691-2-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221013153654.1397691-2-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 09:36:52AM -0600, Jason A. Donenfeld wrote:
> commit cd4f24ae9404fd31fc461066e57889be3b68641b upstream.
> 
> Prior to 5.6, when /dev/random was opened with O_NONBLOCK, it would
> return -EAGAIN if there was no entropy. When the pools were unified in
> 5.6, this was lost. The post 5.6 behavior of blocking until the pool is
> initialized, and ignoring O_NONBLOCK in the process, went unnoticed,
> with no reports about the regression received for two and a half years.
> However, eventually this indeed did break somebody's userspace.
> 
> So we restore the old behavior, by returning -EAGAIN if the pool is not
> initialized. Unlike the old /dev/random, this can only occur during
> early boot, after which it never blocks again.
> 
> In order to make this O_NONBLOCK behavior consistent with other
> expectations, also respect users reading with preadv2(RWF_NOWAIT) and
> similar.
> 
> Fixes: 30c08efec888 ("random: make /dev/random be almost like /dev/urandom")
> Reported-by: Guozihua <guozihua@huawei.com>
> Reported-by: Zhongguohua <zhongguohua1@huawei.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andrew Lutomirski <luto@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/char/mem.c    | 4 ++--
>  drivers/char/random.c | 5 +++++
>  2 files changed, 7 insertions(+), 2 deletions(-)

Still breaks on older kernels:

drivers/char/random.c: In function ‘random_read_iter’:
drivers/char/random.c:1299:33: error: ‘IOCB_NOWAIT’ undeclared (first use in this function); did you mean ‘IPC_NOWAIT’?
 1299 |             ((kiocb->ki_flags & IOCB_NOWAIT) ||
      |                                 ^~~~~~~~~~~
      |                                 IPC_NOWAIT
drivers/char/random.c:1299:33: note: each undeclared identifier is reported only once for each function it appears in
drivers/char/mem.c:872:48: error: ‘FMODE_NOWAIT’ undeclared here (not in a function); did you mean ‘FOLL_NOWAIT’?
  872 |          [8] = { "random", 0666, &random_fops, FMODE_NOWAIT },
      |                                                ^~~~~~~~~~~~
      |                                                FOLL_NOWAIT


