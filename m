Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A8A4EC9BE
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 18:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348861AbiC3Qgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 12:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348856AbiC3QgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 12:36:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336D9154692
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 09:34:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3770617CF
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 16:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D02C340EC;
        Wed, 30 Mar 2022 16:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648658077;
        bh=vZkHZYPThACBV4AnNqTr+6/ks3cZYKjAkOeq3htF3qA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DaBim6b7BbMSY2slyqH7pZqekRHdeZfyfNpF6oYDPUT5ab8wXm+v/u8kQX+ZuA+0r
         5H/qCSlccIKBwzsqYmt/pryUJ56qD2mUqTY6Y+HQC2pNL9lV6MCfZB84/y8v46Med+
         z1ZWMJ5J1DcU7GECuJwuf7+OUQGbszU1OOqmnDbs=
Date:   Wed, 30 Mar 2022 18:34:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zach O'Keefe <zokeefe@google.com>
Cc:     stable@vger.kernel.org, edumazet@google.com, khazhy@google.com,
        Miklos Szeredi <mszeredi@redhat.com>,
        Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4.14 v4.19] fuse: fix pipe buffer lifetime for direct_io
Message-ID: <YkSGmo2wtGMm7apu@kroah.com>
References: <20220330154505.3761706-1-zokeefe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330154505.3761706-1-zokeefe@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 08:45:04AM -0700, Zach O'Keefe wrote:
> From: Miklos Szeredi <mszeredi@redhat.com>
> 
> commit 0c4bcfdecb1ac0967619ee7ff44871d93c08c909 upstream.
> 
> In FOPEN_DIRECT_IO mode, fuse_file_write_iter() calls
> fuse_direct_write_iter(), which normally calls fuse_direct_io(), which then
> imports the write buffer with fuse_get_user_pages(), which uses
> iov_iter_get_pages() to grab references to userspace pages instead of
> actually copying memory.
> 
> On the filesystem device side, these pages can then either be read to
> userspace (via fuse_dev_read()), or splice()d over into a pipe using
> fuse_dev_splice_read() as pipe buffers with &nosteal_pipe_buf_ops.
> 
> This is wrong because after fuse_dev_do_read() unlocks the FUSE request,
> the userspace filesystem can mark the request as completed, causing write()
> to return. At that point, the userspace filesystem should no longer have
> access to the pipe buffer.
> 
> Fix by copying pages coming from the user address space to new pipe
> buffers.
> 
> Reported-by: Jann Horn <jannh@google.com>
> Fixes: c3021629a0d8 ("fuse: support splice() reading from fuse device")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Zach O'Keefe <zokeefe@google.com>
> 
> ---
> Applies against stable-v4.14 and stable-v4.19
> 
> struct fuse_args hasn't been piped through relevant functions yet, so
> place user_pages flag in an empty hole in struct fuse_req instead.

Thanks for the backport, now queued up.

greg k-h
